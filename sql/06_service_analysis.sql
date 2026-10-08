-- 27. Service-level performance
SELECT service_type, COUNT(*) AS requests, ROUND(AVG(waiting_time_min),2) AS avg_wait_min,
       ROUND(AVG(service_time_min),2) AS avg_service_min, ROUND(AVG(tat_min),2) AS avg_tat_min,
       ROUND(100.0*AVG((sla_status='Met')::int),2) AS sla_pct
FROM branch_operations GROUP BY service_type ORDER BY avg_tat_min DESC;

-- 28. SLA performance by service
SELECT service_type, COUNT(*) AS requests,
       COUNT(*) FILTER (WHERE sla_status='Breached') AS breach_count,
       ROUND(100.0*AVG((sla_status='Met')::int),2) AS sla_pct
FROM branch_operations GROUP BY service_type ORDER BY sla_pct ASC;

-- 29. Service complexity: service time vs waiting time
SELECT service_type, ROUND(AVG(service_time_min),2) AS avg_service_min,
       ROUND(AVG(waiting_time_min),2) AS avg_wait_min,
       ROUND(AVG(tat_min),2) AS avg_tat_min
FROM branch_operations GROUP BY service_type ORDER BY avg_service_min DESC;

-- 30. Service by channel
SELECT service_type, channel, COUNT(*) AS requests, ROUND(AVG(waiting_time_min),2) AS avg_wait_min,
       ROUND(AVG(tat_min),2) AS avg_tat_min, ROUND(100.0*AVG((sla_status='Met')::int),2) AS sla_pct
FROM branch_operations GROUP BY service_type, channel ORDER BY service_type, requests DESC;

-- 31. Rework by service
SELECT service_type, COUNT(*) AS requests,
       ROUND(100.0*AVG(rework_required::int),2) AS rework_pct,
       ROUND(AVG(tat_min) FILTER (WHERE rework_required),2) AS avg_tat_rework_min,
       ROUND(AVG(tat_min) FILTER (WHERE NOT rework_required),2) AS avg_tat_no_rework_min
FROM branch_operations GROUP BY service_type ORDER BY rework_pct DESC;

-- 32. Documentation issues by service
SELECT service_type, COUNT(*) AS requests,
       ROUND(100.0*AVG(documentation_issue::int),2) AS documentation_issue_pct
FROM branch_operations GROUP BY service_type ORDER BY documentation_issue_pct DESC;

-- 33. Service volume share
SELECT service_type, COUNT(*) AS requests,
       ROUND(100.0*COUNT(*)/SUM(COUNT(*)) OVER (),2) AS volume_share_pct
FROM branch_operations GROUP BY service_type ORDER BY requests DESC;

-- 34. Services above overall average TAT
SELECT service_type, COUNT(*) AS requests, ROUND(AVG(tat_min),2) AS avg_tat_min
FROM branch_operations GROUP BY service_type
HAVING AVG(tat_min) > (SELECT AVG(tat_min) FROM branch_operations)
ORDER BY avg_tat_min DESC;
