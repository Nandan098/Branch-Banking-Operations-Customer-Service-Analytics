# End-to-end project walkthrough

## 1. Business problem
A branch manager needs visibility into workload, customer waiting time, turnaround time, SLA performance, rework, escalation, and service patterns.

## 2. Data structure
Each row is one service request. The data covers demand, capacity, process time, quality, and relationship signals.

## 3. Data preparation
Use the SQL data-quality script to check duplicates, missing values, invalid ranges, SLA consistency, and key categories.

## 4. SQL analysis
The SQL library contains 60 questions grouped into KPI, branch, service, customer/relationship, risk/quality, and advanced analysis sections.

## 5. Python role
Python is used for reproducibility and validation; the included script verifies core row counts and KPI values through the local SQLite database.

## 6. Power BI role
Power BI converts the SQL/operational outputs into three management-facing pages covering branch operations, service efficiency, and business/operational opportunities.

## 7. Business insights
The project focuses on peak-hour capacity, service complexity, branch-level variation, documentation/rework, and follow-up signals.

## 8. Limitations
The dataset is simulated, so it cannot represent actual ICICI policies, branch schedules, customer behavior, or bank performance. Results are descriptive and should not be presented as real-world measured impact.
