# Branch Banking Operations & Customer Service Analytics

## Project Overview

This project analyzes branch-level banking operations and customer service performance to understand how workload, staffing, service demand, and process quality affect customer experience and operational efficiency.

The project is designed around a practical banking-operations use case. The objective is not simply to build a dashboard, but to answer operational questions that a branch or business manager could use for monitoring and decision-making.

### Core business questions

- Which branches handle the highest service volumes?
- Which services have the longest waiting time and turnaround time (TAT)?
- When do branches experience peak workload?
- How does staff availability relate to queue pressure and waiting time?
- Which services show weaker SLA performance?
- Where are documentation issues, rework, and escalations concentrated?
- Which customer interactions create potential follow-up or relationship opportunities?
- Which branches or time periods should be investigated for operational improvement?

---

## Project Objectives

1. Measure branch workload and customer service demand.
2. Calculate waiting time, service time, TAT, and SLA performance.
3. Compare branch and service-level operational efficiency.
4. Identify workload and capacity pressure points.
5. Analyze process-quality indicators such as documentation issues, rework, and escalations.
6. Surface customer and relationship signals that can support follow-up activity.
7. Present the results through SQL analysis, Python validation, and a Power BI dashboard.

---

## Technology Stack

| Tool | Purpose |
|---|---|
| **SQL / PostgreSQL** | Data quality checks, KPI calculations, branch/service analysis, advanced operational analysis, and Power BI views |
| **Python / Pandas** | Data validation, descriptive analysis, consistency checks, and reproducible summaries |
| **Power BI** | Interactive KPI dashboard and operational performance visualization |
| **SQLite** | Packaged local database for quick querying and demonstration |
| **Excel** | Source workbook and data-dictionary reference |

---

## Dataset

The project contains **100,000 service-request records** covering **60 branches across 10 cities** over the period **April 2026 to September 2026**.

Each row represents **one customer service interaction/request**.

The dataset is used for portfolio and analytical practice and **is not ICICI Bank customer or branch data**. No confidential customer information is used.

### Main data areas

**Branch and location**
- Branch ID
- City
- Branch type

**Customer and service**
- Customer type
- Service type
- Service channel
- Existing product count

**Branch operations**
- Date
- Day of week
- Hour
- Staff available
- Customer footfall
- Queue length at arrival

**Service performance**
- Waiting time
- Service time
- Turnaround time (TAT)
- SLA target
- SLA status

**Process quality**
- Documentation issue
- Rework required
- Escalation

**Business / relationship signals**
- Product inquiry
- Follow-up required

The data is deliberately varied across branches, services, workload periods, and operational conditions so that the analysis can identify meaningful differences rather than producing identical branch profiles.

For column definitions, see `data/data_dictionary.csv`.

---

## Key Business Definitions

### Waiting Time

Time between a customer's arrival/request and the start of service.

### Service Time

Time spent actively processing the request.

### Turnaround Time (TAT)

The project uses:

```text
TAT = Waiting Time + Service Time + Rework-related delay
```

### SLA Compliance

A request is marked as **Met** when its TAT is within the service-specific SLA target.

```text
SLA Compliance % =
Requests completed within SLA / Total requests × 100
```

### Rework

A service request that requires repeat processing because of a process or documentation issue.

---

## Current Portfolio KPIs

The current dataset produces the following overall metrics:

| KPI | Value |
|---|---:|
| Service requests | 100,000 |
| Branches | 60 |
| Cities | 10 |
| Average waiting time | 14.56 min |
| Average TAT | 28.60 min |
| SLA compliance | 72.69% |
| Rework rate | 4.39% |
| Escalation rate | 3.09% |

These are portfolio-analysis figures and should not be presented as actual ICICI Bank operating metrics.

---

## Analytical Workflow

```text
Raw operational data
        ↓
Data quality validation
        ↓
SQL KPI calculations
        ↓
Branch / service / workload analysis
        ↓
Process-quality analysis
        ↓
Advanced operational analysis
        ↓
Power BI data model & dashboard
        ↓
Business insights and recommendations
```

---

## SQL Analysis

The SQL library contains a broad set of queries rather than only a few basic aggregations.

### `03_data_quality.sql`

Checks include:
- Row counts
- Null checks
- Duplicate request IDs
- Invalid ranges
- SLA consistency
- TAT consistency
- Category checks

### `04_kpi_analysis.sql`

Includes:
- Overall request volume
- Average waiting time
- Average service time
- Average TAT
- SLA compliance
- Rework rate
- Escalation rate
- Product inquiry rate
- Monthly KPIs
- Hourly KPIs

### `05_branch_analysis.sql`

Includes:
- Branch workload
- Branch-level TAT
- Branch SLA performance
- Average staffing
- Workload per staff member
- Branch rankings
- High-pressure branches
- City-level comparisons

### `06_service_analysis.sql`

Includes:
- Service volume
- Average service time
- Average TAT
- Waiting time by service
- SLA performance by service
- Service-level quality indicators
- Service ranking

### `07_customer_relationship.sql`

Includes:
- Customer-type analysis
- Existing product depth
- Product inquiry patterns
- Follow-up requirements
- Customer/service combinations
- Relationship-oriented operational signals

### `08_risk_quality.sql`

Includes:
- Documentation issues
- Rework
- Escalation patterns
- Quality metrics by service
- SLA breaches with process issues
- Quality concentration by branch

### `09_advanced_analysis.sql`

Includes more advanced operational analysis such as:
- Workload-pressure ranking
- Peak-hour branch analysis
- Staff-to-demand relationships
- SLA risk segmentation
- Branch benchmarking
- High-pressure service combinations
- Operational comparison across periods

### `10_views_for_powerbi.sql`

Creates analysis-ready views for Power BI so the dashboard can be connected to clean KPI outputs instead of rebuilding every calculation inside the report.

---

## Example SQL Questions

A few examples from the analysis library:

```sql
-- Average TAT by service
SELECT
    service_type,
    ROUND(AVG(tat_min), 2) AS avg_tat_min
FROM branch_operations
GROUP BY service_type
ORDER BY avg_tat_min DESC;
```

```sql
-- SLA compliance by branch
SELECT
    branch_id,
    ROUND(
        100.0 * AVG(CASE WHEN sla_status = 'Met' THEN 1.0 ELSE 0.0 END),
        2
    ) AS sla_compliance_pct
FROM branch_operations
GROUP BY branch_id
ORDER BY sla_compliance_pct;
```

```sql
-- Peak-hour workload
SELECT
    hour,
    COUNT(*) AS service_requests,
    ROUND(AVG(waiting_time_min), 2) AS avg_waiting_time
FROM branch_operations
GROUP BY hour
ORDER BY hour;
```

The complete project contains **60 SQL analysis queries** organized by business theme.

---

## Python Analysis

`src/run_analysis.py` is used for reproducible validation and summary analysis.

The Python workflow checks:

- Data types
- Missing values
- Duplicate identifiers
- Numeric ranges
- Distribution of waiting time and TAT
- Service mix
- Branch mix
- SLA performance
- Quality indicators
- Summary outputs used in the project report

Run it from the project root:

```bash
python src/run_analysis.py
```

---

## Power BI Dashboard

The dashboard is designed as a three-page branch-operations reporting solution.

### Page 1 — Branch Operations Overview

Key KPIs:
- Total service requests
- Customers served
- Average waiting time
- Average TAT
- SLA compliance
- Staff availability

Visual analysis:
- Service request volume
- Footfall by hour
- Branch workload
- TAT by service

### Page 2 — Customer Service Efficiency

Focus areas:
- Waiting time by service
- TAT by service
- SLA met vs breached
- Rework rate
- Escalations
- Staff workload

### Page 3 — Business & Operational Insights

Focus areas:
- New vs existing customer activity
- Product inquiry patterns
- Follow-up requirements
- Documentation and KYC-related issues
- Branch opportunity / pressure matrix
- Operational improvement areas

The dashboard calculations are documented in:

`powerbi/DAX_Measures.dax`

The page-by-page design is documented in:

`powerbi/Dashboard_Blueprint.md`

---

## Project Findings

The analysis is intended to identify patterns such as:

- Peak customer-demand periods creating higher queue pressure.
- Certain banking services having materially higher processing times than routine transactions.
- Differences in SLA compliance across branches and services.
- Higher operational pressure where service demand is high relative to available staff.
- Documentation issues and rework contributing to additional turnaround time.
- Escalations concentrating around delayed or more complex service requests.
- Certain customer-service interactions generating follow-up or relationship opportunities.

The detailed outputs are available in `reports/`.

---

## Project Structure

```text
Branch_Banking_Operations_Customer_Service_Analytics/
│
├── README.md
├── PROJECT_MANIFEST.txt
├── requirements.txt
│
├── data/
│   ├── data_dictionary.csv
│   └── raw/
│       ├── branch_banking_operations_customer_service_100k.csv
│       └── branch_banking_operations_customer_service_100k.xlsx
│
├── db/
│   └── branch_operations.sqlite
│
├── sql/
│   ├── 01_schema_postgresql.sql
│   ├── 02_load_postgresql.sql
│   ├── 03_data_quality.sql
│   ├── 04_kpi_analysis.sql
│   ├── 05_branch_analysis.sql
│   ├── 06_service_analysis.sql
│   ├── 07_customer_relationship.sql
│   ├── 08_risk_quality.sql
│   ├── 09_advanced_analysis.sql
│   └── 10_views_for_powerbi.sql
│
├── src/
│   └── run_analysis.py
│
├── powerbi/
│   ├── DAX_Measures.dax
│   └── Dashboard_Blueprint.md
│
├── reports/
│   ├── Project_Report.md
│   ├── overall_kpis.csv
│   ├── branch_performance.csv
│   ├── branch_ranking.csv
│   ├── service_performance.csv
│   ├── hourly_kpis.csv
│   ├── monthly_kpis.csv
│   ├── quality_by_service.csv
│   ├── channel_performance.csv
│   ├── customer_type.csv
│   └── high_pressure_branch_hours.csv
│
└── docs/
    ├── Project_Walkthrough.md
    ├── Interview_QA.md
    └── Resume_Bullets.md
```

---

## Setup

### Option 1 — SQLite

The packaged database is ready for local querying:

```text
db/branch_operations.sqlite
```

It can be opened with DB Browser for SQLite or queried through Python.

### Option 2 — PostgreSQL

1. Create a PostgreSQL database.
2. Run `sql/01_schema_postgresql.sql`.
3. Run `sql/02_load_postgresql.sql` from the project root.
4. Run the analysis files from `sql/03_data_quality.sql` through `sql/09_advanced_analysis.sql`.
5. Run `sql/10_views_for_powerbi.sql` to create dashboard-ready views.

### Python dependencies

See `requirements.txt`.

Install with:

```bash
pip install -r requirements.txt
```

---

## Interview Positioning

This project is designed to demonstrate four things:

**1. Customer orientation**  
Understanding waiting time, service quality, complaints, follow-up, and customer experience.

**2. Operational thinking**  
Understanding capacity, workload, staffing, queues, TAT, and SLA performance.

**3. Analytical ability**  
Using SQL and Python to move from raw records to measurable business insights.

**4. Business orientation**  
Connecting operational performance with customer relationships, service quality, and business opportunities.

A concise interview explanation is:

> "I worked on a branch banking operations and customer service analytics project. I analyzed service requests, branch workload, staffing, waiting time, turnaround time, SLA performance, and process-quality indicators. I used SQL and Python for the analysis and Power BI for monitoring branch performance and identifying operational bottlenecks. The objective was to understand where service delays occur and where branch operations can be improved to support better customer experience and business performance."

---

## Important Notes

- This is a **portfolio analytics project** and is not an ICICI Bank internal project.
- The metrics in this repository should not be represented as actual ICICI Bank operating metrics.
- No confidential customer information is included.
- The analysis demonstrates a banking-operations methodology rather than claiming access to proprietary branch systems.

---

## Author

**Nandan**  
Mechanical Engineering | Business Analytics | Python | SQL | Power BI
