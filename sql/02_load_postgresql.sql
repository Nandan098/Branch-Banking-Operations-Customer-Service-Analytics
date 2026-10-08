-- Run from the project root in psql after creating the table.
\copy branch_operations FROM 'data/raw/branch_banking_operations_customer_service_100k.csv' WITH (FORMAT csv, HEADER true, NULL '');

SELECT COUNT(*) AS rows_loaded, COUNT(DISTINCT branch_id) AS branches, COUNT(DISTINCT city) AS cities
FROM branch_operations;
