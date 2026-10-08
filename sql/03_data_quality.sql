-- 01. Row count
SELECT COUNT(*) AS total_rows FROM branch_operations;

-- 02. Duplicate request IDs
SELECT request_id, COUNT(*) AS occurrences
FROM branch_operations
GROUP BY request_id
HAVING COUNT(*) > 1
ORDER BY occurrences DESC;

-- 03. Missing values by column (core fields)
SELECT
  COUNT(*) FILTER (WHERE branch_id IS NULL) AS missing_branch_id,
  COUNT(*) FILTER (WHERE service_type IS NULL) AS missing_service_type,
  COUNT(*) FILTER (WHERE waiting_time_min IS NULL) AS missing_waiting_time,
  COUNT(*) FILTER (WHERE tat_min IS NULL) AS missing_tat,
  COUNT(*) FILTER (WHERE staff_available IS NULL) AS missing_staff,
  COUNT(*) FILTER (WHERE customer_footfall IS NULL) AS missing_footfall
FROM branch_operations;

-- 04. Invalid hours
SELECT COUNT(*) AS invalid_hours
FROM branch_operations
WHERE hour NOT BETWEEN 9 AND 16;

-- 05. Negative operational measures
SELECT COUNT(*) AS invalid_measure_rows
FROM branch_operations
WHERE staff_available < 0 OR customer_footfall < 0 OR queue_length_at_arrival < 0
   OR waiting_time_min < 0 OR service_time_min < 0 OR tat_min < 0 OR sla_target_min <= 0;

-- 06. TAT consistency check (allows modeled rework delay)
SELECT COUNT(*) AS inconsistent_tat_rows
FROM branch_operations
WHERE tat_min < waiting_time_min + ROUND(service_time_min)::int;

-- 07. SLA status consistency
SELECT COUNT(*) AS inconsistent_sla_rows
FROM branch_operations
WHERE (tat_min <= sla_target_min AND sla_status <> 'Met')
   OR (tat_min > sla_target_min AND sla_status <> 'Breached');

-- 08. Boolean-domain checks
SELECT documentation_issue, COUNT(*) FROM branch_operations GROUP BY documentation_issue;
SELECT rework_required, COUNT(*) FROM branch_operations GROUP BY rework_required;
SELECT escalation, COUNT(*) FROM branch_operations GROUP BY escalation;

-- 09. Date range
SELECT MIN(date) AS min_date, MAX(date) AS max_date, COUNT(DISTINCT date) AS active_days
FROM branch_operations;

-- 10. Service category distribution
SELECT service_type, COUNT(*) AS requests,
       ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS share_pct
FROM branch_operations
GROUP BY service_type
ORDER BY requests DESC;
