# Branch Banking Operations & Customer Service Analytics

## Project objective
Analyze branch-service workload, customer waiting time, turnaround time (TAT), SLA performance, process quality, and relationship opportunities to identify operational bottlenecks and improvement areas.

## Dataset
- 100,000 service-request records
- 60 branches
- 10 cities
- Analysis period: 2026-04-01 to 2026-09-30
- One row represents one customer service interaction/request.
- The dataset is simulated for portfolio/interview use; it is not ICICI Bank customer data.

## Overall KPIs
- Total requests: 100,000
- Branches: 60
- Cities: 10
- Average waiting time: 14.56 min
- Average TAT: 28.6 min
- SLA compliance: 72.69%
- Rework rate: 4.39%
- Escalation rate: 3.09%
- Product inquiry rate: 11.46%
- Follow-up rate: 6.96%

## Key observations
1. **Peak operating pressure:** request volume is highest around 11:00-13:00, and average waiting time is materially higher during this period.
2. **Service complexity matters:** loan inquiry and account opening have higher average processing/TAT than routine transaction services.
3. **Branch variation is material:** branch-level SLA results vary widely, showing where workload/capacity and process execution deserve attention.
4. **Quality bottlenecks:** KYC and account-opening requests show higher documentation issues and rework than routine cash/statement services.
5. **Relationship opportunity:** product inquiries and follow-ups provide a bridge between branch operations and relationship management without assuming automatic product suitability.

## Example service results

| Service | Requests | Avg TAT (min) | SLA % |
|---|---:|---:|---:|
| Cash Deposit | 19,088 | 22.69 | 68.44 |
| Cash Withdrawal | 14,914 | 21.95 | 70.82 |
| Statement/Passbook | 10,980 | 20.78 | 58.1 |
| KYC Update | 10,858 | 33.91 | 79.06 |
| Account Opening | 10,173 | 40.78 | 75.26 |
| Card Service | 10,044 | 30.4 | 79.28 |
| Fund Transfer | 7,995 | 25.85 | 72.57 |
| Loan Inquiry | 7,135 | 42.44 | 79.55 |
| Other Service | 4,889 | 27.79 | 76.15 |
| Complaint | 3,924 | 35.21 | 83.74 |

## Hourly results

| Hour | Requests | Avg Wait | Avg TAT | SLA % |
|---:|---:|---:|---:|---:|
| 9 | 6,849 | 7.42 | 21.61 | 87.36 |
| 10 | 12,091 | 10.25 | 24.17 | 80.39 |
| 11 | 17,914 | 19.06 | 33.11 | 63.75 |
| 12 | 19,952 | 21.59 | 35.6 | 60.37 |
| 13 | 16,093 | 16.37 | 30.47 | 68.12 |
| 14 | 13,127 | 10.59 | 24.52 | 79.77 |
| 15 | 8,966 | 8.41 | 22.63 | 84.24 |
| 16 | 5,008 | 6.3 | 20.29 | 90.65 |

## Lowest-SLA branches (min 1,000 requests)

| Branch | City | Requests | Avg Wait | Avg TAT | SLA % |
|---|---|---:|---:|---:|---:|
| B100 | Indore | 2,672 | 66.51 | 80.36 | 20.17 |
| B117 | Bhopal | 1,007 | 61.62 | 75.43 | 21.75 |
| B157 | Bhopal | 1,436 | 38.26 | 52.41 | 34.05 |
| B144 | Ahmedabad | 1,484 | 31.69 | 45.43 | 37.67 |
| B106 | Jaipur | 3,028 | 31.46 | 45.23 | 38.44 |
| B142 | Indore | 1,750 | 31.23 | 45.48 | 40.91 |
| B128 | Mumbai | 1,117 | 25.39 | 39.19 | 48.43 |
| B137 | Hyderabad | 1,672 | 18.03 | 32.28 | 57.89 |
| B120 | Pune | 4,235 | 18.2 | 32.04 | 58.63 |
| B119 | Ahmedabad | 1,591 | 14.39 | 28.23 | 65.68 |


## Important interpretation rule
The patterns above are descriptive and simulated. They should be used to identify analytical opportunities, not to claim actual ICICI branch performance or causal impact. In a real bank, operational recommendations would be validated with official branch schedules, queue systems, staffing plans, product SLAs, compliance rules, and historical outcomes.

## Recommended management actions from this analysis
- Review staffing/counter allocation during peak 11:00-13:00 periods.
- Investigate high-TAT services for documentation and process steps that drive rework.
- Benchmark low-SLA branches against similar-volume peers rather than against a single average.
- Separate routine transactions from advisory/document-heavy services when planning capacity.
- Use product inquiries/follow-ups as relationship-management signals, followed by suitability and eligibility checks.
