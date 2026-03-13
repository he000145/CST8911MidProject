# CST8911 Midterm Project

## Group Members
- Jingjing Duan
- Shan Jiang
- Naveed Hossain
- Bryan Edler
- Yiming He

## Duty 1 — Data & Blob (Ingestion) -> Yiming He
![blob1](/blob/blob1.png "create storage account")
![blob2](/blob/blob2advanced.png "advanced setting")
![blob3](/blob/blob3createContainer.png "create Container")
![blob4](/blob/blobl4uploadCVS.png "upload CVS")

    For my part, I set up the Blob Storage input area for our project. I created a Storage Account called 8911midblob in West US. I originally planned to use East US, but under our current subscription East US was not available when creating the resource, so I chose West US as the closest workable option. Then I created a container named data and uploaded the two CSV files using the exact required paths:

    raw/customers.csv

    raw/transactions.csv

    I kept the files as CSV because it is simple and easy for Azure Data Factory to read and copy into SQL staging tables. For cost, I chose Standard performance + LRS since this is a course project and we do not need cross-region disaster recovery. I also kept the access tier as Hot, because during development we will read these files multiple times when testing and re-running pipelines.

    For security, I did not enable anonymous/public access to the container. I used Microsoft Entra ID (RBAC) to control access, so only our team members and the Data Factory managed identity can read the blobs when needed. After uploading, I verified the folder structure and confirmed both files are under the raw/ folder in the container.
## Duty 2 — Data Factory (Pipelines) -> Jingjing Duan
### Overview
This section implements a data ingestion pipeline using Azure Data Factory.
The pipeline extracts CSV files from Azure Blob Storage and loads the data into Azure SQL Database tables. Two datasets (customers and transactions) are processed using Copy activities. Basic error handling and pipeline monitoring are also demonstrated.
### 2.1 Create Azure Data Factory
![Pipeline](<Duty 2/Step1-Azure Data Factory.png>)
### 2.2 Create Linked Services
Linked services define the connection information required for Azure Data Factory to access external data sources.
1. Created an Azure Blob Storage linked service to access CSV files stored in Blob Storage.
![Pipeline](<Duty 2/2.21.png>)

2. Created an Azure Blob Storage linked service to access CSV files stored in Blob Storage.
![Pipeline](<Duty 2/2.22.png>)

### 2.3 Create Datasets
Datasets define the structure and location of the data.
1. Two datasets were created for the CSV files in Blob Storage:
ds_csv_customers
![Pipeline](<Duty 2/2.31.png>)
ds_csv_transactions
![Pipeline](<Duty 2/2.32.png>)
2. Two datasets were also created for the destination SQL tables:
ds_sql_customers
![Pipeline](<Duty 2/2.33.png>)
ds_sql_transactions
![Pipeline](<Duty 2/2.34.png>)

### 2.4 Create Data Pipeline
A pipeline named pl_blob_to_sql was created to move data from Blob Storage to Azure SQL Database.
1. Two Copy activities were configured:
![Pipeline](<Duty 2/2.41.png>)
copy_customers
![Pipeline](<Duty 2/2.42.png>)
![Pipeline](<Duty 2/2.43.png>)
![Pipeline](<Duty 2/2.44.png>)
copy_transactions
![Pipeline](<Duty 2/2.45.png>)
![Pipeline](<Duty 2/2.46.png>)
![Pipeline](<Duty 2/2.47.png>)

2. Data flow:
Blob Storage (CSV)  
        ↓  
Azure Data Factory Pipeline  
        ↓  
Azure SQL Database Tables  

3. Basic error handling was enabled using fault tolerance settings to skip incompatible rows.
![Pipeline](<Duty 2/2.48.png>)
![Pipeline](<Duty 2/2.49.png>)

### 2.5 Data Pipeline publish all & run
![Pipeline](<Duty 2/2.51.png>)
![Pipeline](<Duty 2/2.52.png>)

### 2.6 Pipeline Execution and Monitoring
The pipeline was executed using the Debug or Trigger Now option.

Pipeline execution was monitored in the Monitor tab of Azure Data Factory.

Both copy activities completed successfully.
![Pipeline](<Duty 2/2.61.png>)

### 2.7 Data Verification
To verify the data ingestion process, SQL queries were executed in Azure SQL Database.
![Pipeline](<Duty 2/2.71.png>)
![Pipeline](<Duty 2/2.72.png>)

## Duty 3 — SQL (Schema + T-SQL + Views) -> Shan Jiang
### Step 1: Database Provisioning
I provisioned the Azure SQL Database in **West US**. Originally, the plan was East US, but I had to switch due to subscription quota limits. I selected the **Basic tier** and **LRS backup** to strictly follow the "cheapest development option" requirement. 

For the **“Allow Azure services and resources to access this server”** part, I selected **“Yes”** to allow Data Factory (Duty 2) to transfer data and added my local IP address so I could run SQL queries manually.

![Database Provisioning](<Duty 3/Step1-Database Provisioning.png>)

### Step 2: Database Schema Creation
I developed and executed T-SQL scripts to create the production tables (`dbo.Customers` and `dbo.Transactions`). I ensured the column headers, data types, and ordering strictly matched the data contract provided by Duty 1.

![Database Schema Creation](<Duty 3/Step2-Database Schema Creation.png>)

### Step 3: Integration & Direct Loading
During the integration phase, Duty 2 and Duty 3 collaborated to streamline the process. Since the source data was already clean and matched our schema, we performed a direct load to the production tables, reducing the processing time by skipping the redundant staging-to-production migration.

![Integration & Direct Loading](<Duty 3/Step3-Integration & Direct Loading1.png>)
![Integration & Direct Loading](<Duty 3/Step3-Integration & Direct Loading2.png>)

### Step 4: SQL View Development
I created three specialized SQL Views to support Duty 4’s Power BI dashboard. These views perform data aggregation (e.g., total sales by region and monthly trends) at the database level, which improves the reporting performance.

![SQL View Development](<Duty 3/Step4-SQL View Development.png>)

### Step 5: Verify
I verified that the views were accessible and ready for visualization.

![Verify](<Duty 3/Step5-Verify.png>)

## Duty 4 — Power BI (Dashboard) -> Naveed Hossain

### Step 1: Data Connection

I connected Power BI to the Azure SQL Database to import two types of data: raw tables containing transaction and customer information, and SQL views that contain the pre-transformed data for the dashboard.

![Data Connection](<Duty 4/Azure SQL Database Connection.png>)

![Data Connection](<Duty 4/SQL Database Connection.png>)

Technical Adjustment: I modified the SQL views to include Customer ID as the primary key. This allows Power BI to create accurate relationships between tables and allows Power BI to correctly filter related data across visuals.

### Step 2: Data Modeling

After importing the data, I organized the tables and views into a relational model in Model View. This setup ensures that data in one table can correctly filter related data in others. I used Customer ID as the primary key to create these relationships, this allows cross-filtering across the entire dashboard.

![Data Modeling](<Duty 4/Data Model.png>)

### Step 3: Dashboard Design

Dashboard View

![Dashboard Design](<Duty 4/Dashboard.png>)

I used the Azure Maps visual to create a Regional Sales Heatmap, where the size of each bubble represents the total volume of sales for a region. This allows users to quickly see which provinces, such as Ontario and British Columbia, are performing best. I also added a Slicer Bar at the top, allowing users to select a province to instantly zoom the map and filters to show data for that region.

![Dashboard Design](<Duty 4/Regional Heat Map.png>)

By using Power BI Line Charts, a Monthly Sales Trend graph was created to monitor sales over a period. This provides a clear revenue timeline, showing that sales peaked in January at $41,000 and then declined steadily throughout the months.

![Dashboard Design](<Duty 4/Monthly Sales Trends.png>)

I used Doughnut Charts to show the customer base for the age group and gender. The data shows that the Age Group of 30-50 has the largest market share of 41%, while the Gender visual shows that the majority of the customers are Male with a 62% market share. I also added Button Slicers that allow users to filter the entire dashboard based on the demographic. This is important as it helps users analyze the trends for a particular demographic group, such as the regional purchases based on the gender or age group.

![Dashboard Design](<Duty 4/Demographic Breakdown.png>)

At the top of the dashboard, I added KPI cards to display three key metrics: number of customers, total sales, and total orders. These cards update automatically when users select different provinces or demographics, giving a quick and accurate view of performance for each KPI segment.

![Dashboard Design](<Duty 4/KPI Cards.png>)


## Duty 5 — Integration + Security/RBAC + Cost + Documentation + Cleanup -> Bryan Edler

##  SECURITY & RBAC IMPLEMENTATION

### Role Assignment Strategy
For this project, we assigned the **Contributor** role to all team members at the resource group scope. This decision was made to facilitate collaboration and allow team members to assist each other when needed.

### Access Control Matrix
| Member | Duty | Role | Scope |
|--------|------|------|-------|
| Yiming He | Duty 1 - Data & Blob | Contributor | AzureDataProject-RG |
| Jingjing Duan | Duty 2 - Data Factory | Contributor | AzureDataProject-RG |
| Shan Jiang | Duty 3 - SQL Database | Contributor | AzureDataProject-RG |
| Naveed Hossain | Duty 4 - Power BI | Contributor | AzureDataProject-RG |
| Bryan Edler | Project Lead | Owner | Entire Subscription |

Since it is a student project and for a sure period of time, all participants were granted a contributor role

### Implementation Evidence

#### Screenshot 1: Resource Group Overview

![Role](<Role/Resource Group Overview.png>)



#### Screenshot 2: Adding Role Assignment

![Role](<Role/Role assignment1.png>)

![Role](<Role/Role assignment2.png>)



#### Screenshot 3: Selecting Contributor Role

![Role](<Role/Access Control.png>)



### Verification
All role assignments were verified by:
1. Each team member confirming they can access the Azure portal
2. Testing that members can view the resource group
3. Confirming no one has Owner permissions except the project lead

### Security Rationale
While this deviates from the "least privilege" principle, it was appropriate for this context because:
- Short project duration (3 weeks)
- Small team of 5 known members
- All resources will be deleted after demo
- Budget alerts limit financial risk
- Educational environment prioritizing learning over strict security

##  COST MANAGEMENT - BUDGET ALERTS

### Why Budget Alerts Are Critical
Since all team members have Contributor access, anyone could inadvertently create expensive resources. Budget alerts provide a safety net by notifying us before costs spiral out of control.

### Budget Configuration

| Setting | Value | Justification |
|---------|-------|---------------|
| **Scope** | AzureDataProject-RG | All project resources in one group |
| **Budget Amount** | $20.00 | Protects owner's $100 credit while allowing flexibility |
| **Reset Period** | at the due date of submission | the project will be deleted |
| **Start Date** | March 1st | Covers entire project duration |
| **Expiration Date** | 13 days | Ensures coverage through cleanup |

### Alert Threshold Strategy

We implemented multiple thresholds for graduated awareness:

| Threshold | Alert Type | When Alert Fires | Action |
|-----------|------------|------------------|--------|
| **50% ($10)** | Actual | First warning | Review resource usage, check for unused resources |
| **90% ($18)** | Actual | Critical warning | Prepare to stop non-essential pipelines |
| **100% ($20)** | Actual | Budget reached | Stop all non-critical activities, prepare for cleanup |


### Implementation Evidence

#### Screenshot 1: Budget Creation
![Cost](<Cost/Budget Creation.png>)


#### Screenshot 2: Alert Conditions
![Cost](<Cost/Budget Creation.png>)


#### Screenshot 3: Action Group Configuration
![Cost](<Cost/Alert Conditions.png>)


#### Screenshot 4: Completed Budget
![Cost](<Cost/Completed Budget.png>)







