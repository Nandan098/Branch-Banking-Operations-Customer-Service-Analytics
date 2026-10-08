-- 50. Queue / waiting relationship (Pearson correlation, PostgreSQL)
SELECT CORR(queue_length_at_arrival::numeric, waiting_time_min) AS queue_wait_corr
FROM branch_operations;

-- 51. Workload/staff relationship
SELECT CORR((customer_footfall::numeric / NULLIF(staff_available,0)), waiting_time_min) AS workload_wait_corr
FROM branch_operations;

-- 52. Footfall/staff pressure by branch
SELECT branch_id, city, ROUND(AVG(customer_footfall::numeric / NULLIF(staff_available,0)),2) AS avg_workload_per_staff,
       ROUND(AVG(waiting_time_min),2) AS avg_wait_min, ROUND(100.0*AVG((sla_status='Met')::int),2) AS sla_pct
FROM branch_operations GROUP BY branch_id, city
ORDER BY avg_workload_per_staff DESC;

-- 53. High-pressure branch-hour combinations
SELECT branch_id, city, hour, COUNT(*) AS requests,
       ROUND(AVG(customer_footfall),2) AS avg_footfall, ROUND(AVG(staff_available),2) AS avg_staff,
       ROUND(AVG(waiting_time_min),2) AS avg_wait_min, ROUND(100.0*AVG((sla_status='Met')::int),2) AS sla_pct
FROM branch_operations GROUP BY branch_id, city, hour
HAVING COUNT(*) >= 50 AND AVG(customer_footfall::numeric / NULLIF(staff_available,0)) > 10
ORDER BY avg_wait_min DESC LIMIT 25;

-- 54. Rank services within each branch by TAT
WITH s AS (
  SELECT branch_id, service_type, COUNT(*) AS requests, AVG(tat_min) AS avg_tat
  FROM branch_operations GROUP BY branch_id, service_type
)
SELECT *, DENSE_RANK() OVER (PARTITION BY branch_id ORDER BY avg_tat DESC) AS tat_rank_in_branch
FROM s ORDER BY branch_id, tat_rank_in_branch;

-- 55. Monthly service mix
SELECT DATE_TRUNC('month', date)::date AS month, service_type, COUNT(*) AS requests,
       ROUND(100.0*COUNT(*)/SUM(COUNT(*)) OVER (PARTITION BY DATE_TRUNC('month',date)),2) AS monthly_share_pct
FROM branch_operations GROUP BY 1,2 ORDER BY 1, requests DESC;

-- 56. Seven-day rolling TAT (calendar dates with data)
WITH daily AS (
  SELECT date, AVG(tat_min) AS avg_tat
  FROM branch_operations GROUP BY date
)
SELECT date, ROUND(avg_tat,2) AS avg_tat,
       ROUND(AVG(avg_tat) OVER (ORDER BY date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW),2) AS rolling_7d_avg_tat
FROM daily ORDER BY date;

-- 57. Volume vs SLA quadrant
WITH b AS (
  SELECT branch_id, city, COUNT(*) AS requests, AVG((sla_status='Met')::int) AS sla_rate, AVG(waiting_time_min) avg_wait
  FROM branch_operations GROUP BY branch_id, city
), thresholds AS (
  SELECT AVG(requests) avg_requests, AVG(sla_rate) avg_sla FROM b
)
SELECT b.*, CASE WHEN requests >= t.avg_requests AND sla_rate < t.avg_sla THEN 'High Volume / Low SLA'
                 WHEN requests >= t.avg_requests AND sla_rate >= t.avg_sla THEN 'High Volume / Strong SLA'
                 WHEN requests < t.avg_requests AND sla_rate < t.avg_sla THEN 'Low Volume / Low SLA'
                 ELSE 'Low Volume / Strong SLA' END AS quadrant
FROM b CROSS JOIN thresholds t ORDER BY quadrant, requests DESC;

-- 58. Weighted operational opportunity score (relative, not causal)
WITH b AS (
 SELECT branch_id, city, COUNT(*) requests, AVG(waiting_time_min) avg_wait,
        1-AVG((sla_status='Met')::int) sla_breach_rate,
        AVG(rework_required::int) rework_rate,
        AVG(customer_footfall::numeric / NULLIF(staff_available,0)) workload_ratio
 FROM branch_operations GROUP BY branch_id, city
), n AS (
 SELECT *,
   (requests-MIN(requests) OVER ()) / NULLIF(MAX(requests) OVER ()-MIN(requests) OVER (),0) vol_n,
   (avg_wait-MIN(avg_wait) OVER ()) / NULLIF(MAX(avg_wait) OVER ()-MIN(avg_wait) OVER (),0) wait_n,
   (sla_breach_rate-MIN(sla_breach_rate) OVER ()) / NULLIF(MAX(sla_breach_rate) OVER ()-MIN(sla_breach_rate) OVER (),0) breach_n,
   (rework_rate-MIN(rework_rate) OVER ()) / NULLIF(MAX(rework_rate) OVER ()-MIN(rework_rate) OVER (),0) rework_n,
   (workload_ratio-MIN(workload_ratio) OVER ()) / NULLIF(MAX(workload_ratio) OVER ()-MIN(workload_ratio) OVER (),0) workload_n
 FROM b
)
SELECT branch_id, city, ROUND(100*(0.25*vol_n+0.25*wait_n+0.20*breach_n+0.15*rework_n+0.15*workload_n),1) AS opportunity_score,
       requests, ROUND(avg_wait,2) avg_wait_min, ROUND(100*sla_breach_rate,2) sla_breach_pct, ROUND(100*rework_rate,2) rework_pct
FROM n ORDER BY opportunity_score DESC;

-- 59. Top branches contributing to total SLA breaches (Pareto-style)
WITH b AS (
 SELECT branch_id, city, COUNT(*) FILTER (WHERE sla_status='Breached') AS breaches
 FROM branch_operations GROUP BY branch_id, city
), r AS (
 SELECT *, SUM(breaches) OVER () total_breaches,
        SUM(breaches) OVER (ORDER BY breaches DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) cumulative_breaches
 FROM b
)
SELECT branch_id, city, breaches, ROUND(100.0*breaches/NULLIF(total_breaches,0),2) contribution_pct,
       ROUND(100.0*cumulative_breaches/NULLIF(total_breaches,0),2) cumulative_pct
FROM r ORDER BY breaches DESC;

-- 60. High-value follow-up worklist for analysis (no automatic product recommendation)
SELECT branch_id, city, service_type, customer_type, existing_product_count,
       product_inquiry, follow_up_required, sla_status, rework_required, escalation
FROM branch_operations
WHERE follow_up_required = TRUE
ORDER BY CASE WHEN escalation THEN 1 WHEN sla_status='Breached' THEN 2 WHEN rework_required THEN 3 ELSE 4 END,
         existing_product_count DESC
LIMIT 200;
