# Power BI Dashboard Blueprint

## Data load
Load `data/raw/branch_banking_operations_customer_service_100k.csv` as **BranchOps**. Keep Date as Date, Hour/Staff/Footfall/Queue/Waiting/TAT/SLA Target/Product Count as numeric/integer, and boolean fields as True/False.

## Page 1 — Branch Operations Overview
**Cards:** Total Requests, Average Waiting Time, Average TAT, SLA Compliance %, Average Footfall, Average Staff Available.

**Visuals:**
1. Line chart: monthly requests and SLA %.
2. Column chart: requests by service type.
3. Line/column combo: hourly footfall vs average waiting time.
4. Bar chart: branch requests by branch.
5. Scatter: workload per staff vs average waiting time, size = requests.
**Slicers:** City, Branch Type, Date, Service Type.

## Page 2 — Customer Service & Process Efficiency
**Cards:** Avg Wait, Avg TAT, SLA %, Rework %, Escalation %.

**Visuals:**
1. Bar: average TAT by service.
2. Bar: SLA % by service.
3. Stacked column: SLA met vs breached by hour.
4. Column: rework % by service.
5. Matrix: Branch x Service with Avg TAT, SLA %, Rework %.
6. Donut: channel mix.
**Slicers:** Service Type, Customer Type, Channel, City.

## Page 3 — Business Opportunities & Operational Issues
**Cards:** Product Inquiry %, Follow-up %, New Customer Requests, Escalations.

**Visuals:**
1. Bar: product inquiry % by customer type.
2. Bar: follow-up % by relationship-depth band.
3. Matrix: branch, requests, SLA %, rework %, workload per staff, opportunity score (from SQL view/query).
4. Bar: documentation issue % by service.
5. Stacked bar: follow-up requirement by SLA status.
**Slicers:** Customer Type, Service Type, Branch, City.

## Dashboard design principle
Use the dashboard to identify **operational opportunities**. Do not label a customer as a product target solely from one flag; any relationship/cross-sell action would need suitability, eligibility, existing relationship, and customer-need checks in a real bank.
