-- 11. Overall operational scorecard
SELECT
  COUNT(*) AS total_requests,
  COUNT(DISTINCT branch_id) AS branches,
  COUNT(DISTINCT city) AS cities,
  ROUND(AVG(waiting_time_min),2) AS avg_wait_min,
  ROUND(AVG(tat_min),2) AS avg_tat_min,
  ROUND(100.0 * AVG((sla_status='Met')::int),2) AS sla_compliance_pct,
  ROUND(100.0 * AVG(rework_required::int),2) AS rework_rate_pct,
  ROUND(100.0 * AVG(escalation::int),2) AS escalation_rate_pct
FROM branch_operations;

-- 12. Monthly KPI trend
SELECT DATE_TRUNC('month', date)::date AS month, COUNT(*) AS requests,
       ROUND(AVG(waiting_time_min),2) AS avg_wait_min,
       ROUND(AVG(tat_min),2) AS avg_tat_min,
       ROUND(100.0 * AVG((sla_status='Met')::int),2) AS sla_pct
FROM branch_operations
GROUP BY 1 ORDER BY 1;

-- 13. Day-of-week pattern
SELECT day_of_week, COUNT(*) AS requests, ROUND(AVG(waiting_time_min),2) AS avg_wait_min,
       ROUND(AVG(tat_min),2) AS avg_tat_min, ROUND(100.0 * AVG((sla_status='Met')::int),2) AS sla_pct
FROM branch_operations GROUP BY day_of_week
ORDER BY CASE day_of_week WHEN 'Monday' THEN 1 WHEN 'Tuesday' THEN 2 WHEN 'Wednesday' THEN 3 WHEN 'Thursday' THEN 4 WHEN 'Friday' THEN 5 WHEN 'Saturday' THEN 6 ELSE 7 END;

-- 14. Hourly pressure profile
SELECT hour, COUNT(*) AS requests, ROUND(AVG(customer_footfall),2) AS avg_footfall,
       ROUND(AVG(staff_available),2) AS avg_staff, ROUND(AVG(queue_length_at_arrival),2) AS avg_queue,
       ROUND(AVG(waiting_time_min),2) AS avg_wait_min, ROUND(AVG(tat_min),2) AS avg_tat_min,
       ROUND(100.0 * AVG((sla_status='Met')::int),2) AS sla_pct
FROM branch_operations GROUP BY hour ORDER BY hour;

-- 15. Overall workload per staff
SELECT ROUND(AVG(customer_footfall::numeric / NULLIF(staff_available,0)),2) AS avg_workload_per_staff
FROM branch_operations;

-- 16. Peak hour ranking by request volume
SELECT hour, COUNT(*) AS requests, RANK() OVER (ORDER BY COUNT(*) DESC) AS volume_rank
FROM branch_operations GROUP BY hour ORDER BY volume_rank;

-- 17. SLA breach count and share
SELECT COUNT(*) FILTER (WHERE sla_status='Breached') AS breach_count,
       ROUND(100.0 * AVG((sla_status='Breached')::int),2) AS breach_pct
FROM branch_operations;

-- 18. Waiting-time distribution bands
SELECT CASE WHEN waiting_time_min < 5 THEN '<5 min' WHEN waiting_time_min < 10 THEN '5-9 min'
            WHEN waiting_time_min < 20 THEN '10-19 min' WHEN waiting_time_min < 30 THEN '20-29 min'
            WHEN waiting_time_min < 60 THEN '30-59 min' ELSE '60+ min' END AS wait_band,
       COUNT(*) AS requests
FROM branch_operations GROUP BY 1 ORDER BY MIN(waiting_time_min);
