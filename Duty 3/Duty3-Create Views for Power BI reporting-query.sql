-- Create Views for Power BI reporting (Duty 4)
-- View 1: Total sales by region
CREATE VIEW dbo.vw_sales_by_region AS
SELECT region, SUM(amount) AS total_sales 
FROM dbo.Transactions 
GROUP BY region;
GO

-- View 2: Monthly sales trend
CREATE VIEW dbo.vw_monthly_sales_trend AS
SELECT FORMAT(txn_date, 'yyyy-MM') AS sales_month, SUM(amount) AS monthly_sales 
FROM dbo.Transactions 
GROUP BY FORMAT(txn_date, 'yyyy-MM');
GO

-- View 3: Customer demographics by age group and gender
CREATE VIEW dbo.vw_customer_demographics AS
SELECT 
    CASE 
        WHEN age < 30 THEN 'Under 30' 
        WHEN age BETWEEN 30 AND 50 THEN '30-50' 
        ELSE 'Over 50' 
    END AS age_group,
    gender, 
    COUNT(*) AS customer_count
FROM dbo.Customers 
GROUP BY 
    CASE 
        WHEN age < 30 THEN 'Under 30' 
        WHEN age BETWEEN 30 AND 50 THEN '30-50' 
        ELSE 'Over 50' 
    END, 
    gender;
GO