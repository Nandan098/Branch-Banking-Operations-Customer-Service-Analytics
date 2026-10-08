-- 35. Customer type service performance
SELECT customer_type, COUNT(*) AS requests, ROUND(AVG(waiting_time_min),2) AS avg_wait_min,
       ROUND(AVG(tat_min),2) AS avg_tat_min, ROUND(100.0*AVG((sla_status='Met')::int),2) AS sla_pct
FROM branch_operations GROUP BY customer_type ORDER BY requests DESC;

-- 36. New vs existing customers
SELECT CASE WHEN customer_type='New Customer' THEN 'New' ELSE 'Existing/Other' END AS customer_group,
       COUNT(*) AS requests, ROUND(AVG(waiting_time_min),2) AS avg_wait_min, ROUND(AVG(tat_min),2) AS avg_tat_min
FROM branch_operations GROUP BY 1;

-- 37. Product inquiry rate by customer type
SELECT customer_type, COUNT(*) AS requests,
       ROUND(100.0*AVG(product_inquiry::int),2) AS product_inquiry_pct,
       ROUND(100.0*AVG(follow_up_required::int),2) AS follow_up_pct
FROM branch_operations GROUP BY customer_type ORDER BY product_inquiry_pct DESC;

-- 38. Relationship depth buckets
SELECT CASE WHEN existing_product_count=0 THEN '0 products' WHEN existing_product_count=1 THEN '1 product'
            WHEN existing_product_count BETWEEN 2 AND 3 THEN '2-3 products' ELSE '4+ products' END AS relationship_band,
       COUNT(*) AS requests, ROUND(100.0*AVG(product_inquiry::int),2) AS inquiry_pct,
       ROUND(100.0*AVG(follow_up_required::int),2) AS follow_up_pct
FROM branch_operations GROUP BY 1 ORDER BY MIN(existing_product_count);

-- 39. Service mix by customer type
SELECT customer_type, service_type, COUNT(*) AS requests,
       ROUND(100.0*COUNT(*)/SUM(COUNT(*)) OVER (PARTITION BY customer_type),2) AS share_within_customer_type_pct
FROM branch_operations GROUP BY customer_type, service_type ORDER BY customer_type, requests DESC;

-- 40. Product inquiry and follow-up intersection
SELECT product_inquiry, follow_up_required, COUNT(*) AS requests
FROM branch_operations GROUP BY product_inquiry, follow_up_required ORDER BY requests DESC;

-- 41. High relationship depth + inquiry signal
SELECT customer_type, COUNT(*) AS requests, ROUND(AVG(existing_product_count),2) avg_product_count,
       ROUND(100.0*AVG(product_inquiry::int),2) inquiry_pct
FROM branch_operations GROUP BY customer_type ORDER BY inquiry_pct DESC;
