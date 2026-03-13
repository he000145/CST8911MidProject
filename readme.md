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

## Duty 5 — Integration + Security/RBAC + Cost + Documentation + Cleanup -> Bryan Edler

## 🔐 SECURITY & RBAC IMPLEMENTATION

### Role Assignment Strategy
For this academic project, we assigned the **Contributor** role to all team members at the resource group scope. This decision was made to facilitate collaboration and allow team members to assist each other when needed.

### Access Control Matrix
| Member | Duty | Role | Scope |
|--------|------|------|-------|
| Yiming He | Duty 1 - Data & Blob | Contributor | AzureDataProject-RG |
| Jingjing Duan | Duty 2 - Data Factory | Contributor | AzureDataProject-RG |
| Shan Jiang | Duty 3 - SQL Database | Contributor | AzureDataProject-RG |
| Naveed Hossain | Duty 4 - Power BI | Contributor | AzureDataProject-RG |
| [Owner Name] | Project Lead | Owner | Entire Subscription |

Since it is a student project and for a sure period of time all participant were granted a contributor role

### Implementation Evidence

#### Screenshot 1: Resource Group Overview

*Caption: AzureDataProject-RG resource group containing all project resources*

#### Screenshot 2: Adding Role Assignment

*Caption: Initiating role assignment from Access Control (IAM)*

#### Screenshot 3: Selecting Contributor Role

*Caption: Contributor role selected from built-in role list*

#### Screenshot 4: Adding Team Members

*Caption: All team members selected for Contributor role*

#### Screenshot 5: Completed Role Assignments

*Caption: Final role assignments showing all members as Contributors*

### Verification
All role assignments were verified by:
1. Each team member confirming they can access the Azure portal
2. Testing that members can view the resource group
3. Confirming no one has Owner permissions except the project lead

### Security Rationale
While this deviates from the "least privilege" principle, it was appropriate for this context because:
- Short project duration (3 weeks)
- Small team of 4 known members
- All resources will be deleted after demo
- Budget alerts limit financial risk
- Educational environment prioritizing learning over strict security

##  COST MANAGEMENT - BUDGET ALERTS

### Why Budget Alerts Are Critical
Since all team members have Contributor access, anyone could inadvertently create expensive resources. Budget alerts provide a safety net by notifying us before costs spiral out of control .

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
(<Cost/Budget Creation.png>)
*Caption: Creating $20 monthly budget for AzureDataProject-RG*

#### Screenshot 2: Alert Conditions
[INSERT SCREENSHOT]
*Caption: Multiple alert thresholds configured at 50%, 80%, 90%, 100%, and 120%*

#### Screenshot 3: Action Group Configuration
[INSERT SCREENSHOT]
*Caption: Action group with email notifications for all team members*

#### Screenshot 4: Completed Budget
[INSERT SCREENSHOT]
*Caption: Final budget view showing all configured alerts*

#### Screenshot 5: Cost Analysis with Budget
[INSERT SCREENSHOT]
*Caption: Cost analysis chart tracking actual spending against budget*

### Sample Alert Email

When a threshold is reached, team members receive an email like this:


### Azure Activity Log (Sample Audit)

*Caption: Azure Activity Log tracks all actions by all contributors for accountability*
