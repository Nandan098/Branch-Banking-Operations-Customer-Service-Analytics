CREATE OR REPLACE VIEW vw_branch_kpis AS
SELECT branch_id, city, branch_type, COUNT(*) AS requests,
       ROUND(AVG(waiting_time_min),2) AS avg_wait_min, ROUND(AVG(tat_min),2) AS avg_tat_min,
       ROUND(100.0*AVG((sla_status='Met')::int),2) AS sla_compliance_pct,
       ROUND(100.0*AVG(rework_required::int),2) AS rework_pct,
       ROUND(AVG(customer_footfall::numeric / NULLIF(staff_available,0)),2) AS workload_per_staff
FROM branch_operations GROUP BY branch_id, city, branch_type;

CREATE OR REPLACE VIEW vw_service_kpis AS
SELECT service_type, COUNT(*) AS requests, ROUND(AVG(waiting_time_min),2) AS avg_wait_min,
       ROUND(AVG(service_time_min),2) AS avg_service_min, ROUND(AVG(tat_min),2) AS avg_tat_min,
       ROUND(100.0*AVG((sla_status='Met')::int),2) AS sla_compliance_pct,
       ROUND(100.0*AVG(rework_required::int),2) AS rework_pct
FROM branch_operations GROUP BY service_type;

CREATE OR REPLACE VIEW vw_hourly_kpis AS
SELECT hour, COUNT(*) AS requests, ROUND(AVG(customer_footfall),2) AS avg_footfall,
       ROUND(AVG(staff_available),2) AS avg_staff, ROUND(AVG(queue_length_at_arrival),2) AS avg_queue,
       ROUND(AVG(waiting_time_min),2) AS avg_wait_min, ROUND(AVG(tat_min),2) AS avg_tat_min,
       ROUND(100.0*AVG((sla_status='Met')::int),2) AS sla_compliance_pct
FROM branch_operations GROUP BY hour;

CREATE OR REPLACE VIEW vw_customer_kpis AS
SELECT customer_type, COUNT(*) AS requests, ROUND(AVG(waiting_time_min),2) AS avg_wait_min,
       ROUND(AVG(tat_min),2) AS avg_tat_min, ROUND(100.0*AVG(product_inquiry::int),2) AS product_inquiry_pct,
       ROUND(100.0*AVG(follow_up_required::int),2) AS follow_up_pct
FROM branch_operations GROUP BY customer_type;
