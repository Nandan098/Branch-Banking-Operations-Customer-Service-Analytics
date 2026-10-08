-- 19. Branch performance scorecard
SELECT branch_id, city, branch_type, COUNT(*) AS requests,
       ROUND(AVG(waiting_time_min),2) AS avg_wait_min, ROUND(AVG(tat_min),2) AS avg_tat_min,
       ROUND(100.0 * AVG((sla_status='Met')::int),2) AS sla_pct,
       ROUND(100.0 * AVG(rework_required::int),2) AS rework_pct
FROM branch_operations GROUP BY branch_id, city, branch_type ORDER BY requests DESC;

-- 20. Highest-volume branches
SELECT branch_id, city, COUNT(*) AS requests
FROM branch_operations GROUP BY branch_id, city ORDER BY requests DESC LIMIT 15;

-- 21. Lowest-SLA branches with minimum volume guardrail
SELECT branch_id, city, COUNT(*) AS requests, ROUND(100.0*AVG((sla_status='Met')::int),2) AS sla_pct,
       ROUND(AVG(waiting_time_min),2) AS avg_wait_min
FROM branch_operations GROUP BY branch_id, city HAVING COUNT(*) >= 1000
ORDER BY sla_pct ASC, requests DESC LIMIT 15;

-- 22. Branch workload per staff
SELECT branch_id, city, COUNT(*) AS requests,
       ROUND(AVG(customer_footfall::numeric / NULLIF(staff_available,0)),2) AS avg_workload_per_staff,
       ROUND(AVG(waiting_time_min),2) AS avg_wait_min
FROM branch_operations GROUP BY branch_id, city ORDER BY avg_workload_per_staff DESC;

-- 23. Branch type comparison
SELECT branch_type, COUNT(DISTINCT branch_id) AS branches, COUNT(*) AS requests,
       ROUND(AVG(waiting_time_min),2) AS avg_wait_min, ROUND(AVG(tat_min),2) AS avg_tat_min,
       ROUND(100.0*AVG((sla_status='Met')::int),2) AS sla_pct
FROM branch_operations GROUP BY branch_type ORDER BY requests DESC;

-- 24. Rank branches within each city
WITH perf AS (
  SELECT branch_id, city, COUNT(*) AS requests, AVG(tat_min) AS avg_tat, AVG((sla_status='Met')::int) AS sla_rate
  FROM branch_operations GROUP BY branch_id, city
)
SELECT *, RANK() OVER (PARTITION BY city ORDER BY sla_rate DESC, avg_tat ASC) AS city_rank
FROM perf ORDER BY city, city_rank;

-- 25. High-volume + low-SLA branch watchlist
SELECT branch_id, city, COUNT(*) AS requests, ROUND(AVG(waiting_time_min),2) AS avg_wait_min,
       ROUND(100.0*AVG((sla_status='Met')::int),2) AS sla_pct
FROM branch_operations GROUP BY branch_id, city
HAVING COUNT(*) > (SELECT AVG(cnt) FROM (SELECT COUNT(*) cnt FROM branch_operations GROUP BY branch_id) x)
   AND AVG((sla_status='Met')::int) < 0.70
ORDER BY requests DESC, sla_pct ASC;

-- 26. Branch service mix concentration
SELECT branch_id, service_type, COUNT(*) AS requests,
       ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY branch_id),2) AS branch_service_share_pct
FROM branch_operations GROUP BY branch_id, service_type
ORDER BY branch_id, requests DESC;
