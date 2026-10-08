from pathlib import Path
import csv, sqlite3

ROOT = Path(__file__).resolve().parents[1]
CSV_PATH = ROOT / "data" / "raw" / "branch_banking_operations_customer_service_100k.csv"
DB_PATH = ROOT / "db" / "branch_operations.sqlite"
REPORTS = ROOT / "reports"

def main():
    conn = sqlite3.connect(DB_PATH)
    cur = conn.cursor()
    checks = [
        ("row_count", "SELECT COUNT(*) FROM branch_operations"),
        ("unique_requests", "SELECT COUNT(DISTINCT request_id) FROM branch_operations"),
        ("branches", "SELECT COUNT(DISTINCT branch_id) FROM branch_operations"),
        ("cities", "SELECT COUNT(DISTINCT city) FROM branch_operations"),
        ("avg_wait_min", "SELECT ROUND(AVG(waiting_time_min),2) FROM branch_operations"),
        ("avg_tat_min", "SELECT ROUND(AVG(tat_min),2) FROM branch_operations"),
        ("sla_pct", "SELECT ROUND(100.0*AVG(CASE WHEN sla_status='Met' THEN 1.0 ELSE 0.0 END),2) FROM branch_operations"),
    ]
    print("Project 2 checks")
    for name, q in checks:
        print(f"{name}: {cur.execute(q).fetchone()[0]}")
    conn.close()

if __name__ == "__main__":
    main()
