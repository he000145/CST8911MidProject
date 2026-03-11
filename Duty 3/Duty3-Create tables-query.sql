CREATE TABLE dbo.stg_customers (
    customer_id INT,
    age INT,
    gender VARCHAR(20),
    region VARCHAR(50)
);

CREATE TABLE dbo.stg_transactions (
    txn_id INT,
    customer_id INT,
    amount DECIMAL(18,2),
    txn_date DATE,
    region VARCHAR(50)
);

CREATE TABLE dbo.Customers (
    customer_id INT PRIMARY KEY,
    age INT,
    gender VARCHAR(20),
    region VARCHAR(50)
);

CREATE TABLE dbo.Transactions (
    txn_id INT PRIMARY KEY,
    customer_id INT,
    amount DECIMAL(18,2),
    txn_date DATE,
    region VARCHAR(50)
);