-- 42. Documentation issue rate
SELECT ROUND(100.0*AVG(documentation_issue::int),2) AS documentation_issue_pct
FROM branch_operations;

-- 43. Documentation issues by service
SELECT service_type, COUNT(*) AS requests, ROUND(100.0*AVG(documentation_issue::int),2) AS issue_pct
FROM branch_operations GROUP BY service_type ORDER BY issue_pct DESC;

-- 44. Rework impact on TAT
SELECT rework_required, COUNT(*) AS requests, ROUND(AVG(tat_min),2) AS avg_tat_min,
       ROUND(AVG(waiting_time_min),2) AS avg_wait_min
FROM branch_operations GROUP BY rework_required ORDER BY rework_required DESC;

-- 45. Escalation by service
SELECT service_type, COUNT(*) AS requests, ROUND(100.0*AVG(escalation::int),2) AS escalation_pct
FROM branch_operations GROUP BY service_type ORDER BY escalation_pct DESC;

-- 46. SLA breach + escalation intersection
SELECT sla_status, escalation, COUNT(*) AS requests
FROM branch_operations GROUP BY sla_status, escalation ORDER BY sla_status, escalation;

-- 47. Rework + follow-up intersection
SELECT rework_required, follow_up_required, COUNT(*) AS requests
FROM branch_operations GROUP BY rework_required, follow_up_required ORDER BY requests DESC;

-- 48. Quality watchlist: high-rework services
SELECT service_type, COUNT(*) AS requests, ROUND(100.0*AVG(rework_required::int),2) AS rework_pct,
       ROUND(100.0*AVG(documentation_issue::int),2) AS doc_issue_pct
FROM branch_operations GROUP BY service_type
HAVING AVG(rework_required::int) > (SELECT AVG(rework_required::int) FROM branch_operations)
ORDER BY rework_pct DESC;

-- 49. Branch quality scorecard
SELECT branch_id, city, COUNT(*) AS requests,
       ROUND(100.0*AVG(documentation_issue::int),2) AS doc_issue_pct,
       ROUND(100.0*AVG(rework_required::int),2) AS rework_pct,
       ROUND(100.0*AVG(escalation::int),2) AS escalation_pct
FROM branch_operations GROUP BY branch_id, city ORDER BY rework_pct DESC;
