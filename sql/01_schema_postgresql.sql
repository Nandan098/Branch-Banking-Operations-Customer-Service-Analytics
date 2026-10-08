DROP TABLE IF EXISTS branch_operations CASCADE;

CREATE TABLE branch_operations (
    Request_ID TEXT PRIMARY KEY,
    Date DATE NOT NULL,
    Day_of_Week TEXT NOT NULL,
    Branch_ID TEXT NOT NULL,
    City TEXT NOT NULL,
    Branch_Type TEXT NOT NULL,
    Customer_Type TEXT NOT NULL,
    Service_Type TEXT NOT NULL,
    Channel TEXT NOT NULL,
    Hour INTEGER NOT NULL,
    Staff_Available INTEGER NOT NULL,
    Customer_Footfall INTEGER NOT NULL,
    Queue_Length_At_Arrival INTEGER NOT NULL,
    Waiting_Time_Min INTEGER NOT NULL,
    Service_Time_Min NUMERIC(10,2) NOT NULL,
    TAT_Min INTEGER NOT NULL,
    SLA_Target_Min INTEGER NOT NULL,
    SLA_Status TEXT NOT NULL,
    Documentation_Issue BOOLEAN NOT NULL,
    Rework_Required BOOLEAN NOT NULL,
    Escalation BOOLEAN NOT NULL,
    Product_Inquiry BOOLEAN NOT NULL,
    Existing_Product_Count INTEGER NOT NULL,
    Follow_Up_Required BOOLEAN NOT NULL
);

CREATE INDEX idx_ops_date ON branch_operations(Date);
CREATE INDEX idx_ops_branch ON branch_operations(Branch_ID);
CREATE INDEX idx_ops_service ON branch_operations(Service_Type);
CREATE INDEX idx_ops_hour ON branch_operations(Hour);
CREATE INDEX idx_ops_customer_type ON branch_operations(Customer_Type);
CREATE INDEX idx_ops_sla ON branch_operations(SLA_Status);
