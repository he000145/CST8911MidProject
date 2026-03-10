# CST8911 Midterm Project

## Group Members
- Jingjing Duan
- Shan Jiang
- Naveed Hossain
- Bryan Edler
- Yiming He

## Duty 1 — Data & Blob (Ingestion) -> Yiming He
![blob1](/blob1.png "create storage account")
![blob2](/blob2advanced.png "advanced setting")
![blob3](/blob3createContainer.png "create Container")
![blob4](/blobl4uploadCVS.png "upload CVS")

    For my part, I set up the Blob Storage input area for our project. I created a Storage Account called 8911midblob in West US. I originally planned to use East US, but under our current subscription East US was not available when creating the resource, so I chose West US as the closest workable option. Then I created a container named data and uploaded the two CSV files using the exact required paths:

    raw/customers.csv

    raw/transactions.csv

    I kept the files as CSV because it is simple and easy for Azure Data Factory to read and copy into SQL staging tables. For cost, I chose Standard performance + LRS since this is a course project and we do not need cross-region disaster recovery. I also kept the access tier as Hot, because during development we will read these files multiple times when testing and re-running pipelines.

    For security, I did not enable anonymous/public access to the container. I used Microsoft Entra ID (RBAC) to control access, so only our team members and the Data Factory managed identity can read the blobs when needed. After uploading, I verified the folder structure and confirmed both files are under the raw/ folder in the container.
## Duty 2 — Data Factory (Pipelines) -> Jingjing Duan

## Duty 3 — SQL (Schema + T-SQL + Views) -> Shan Jiang

## Duty 4 — Power BI (Dashboard) -> Naveed Hossain

## Duty 5 — Integration + Security/RBAC + Cost + Documentation + Cleanup -> Bryan Edler
