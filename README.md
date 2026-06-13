\# Bank Marketing Campaign Analysis



\## Project Overview



This project analyzes a bank marketing campaign dataset to understand customer subscription behavior and improve campaign targeting.



The dataset contains customer demographic information, financial attributes, contact history, campaign details, and whether the customer subscribed to a term deposit.



The project combines SQL, Python, and business intelligence tools to build an end-to-end analytics workflow.



\## Business Objective



The main business goal is to identify which customers are more likely to subscribe to a term deposit so that the bank can improve campaign targeting and reduce inefficient outreach.



Key questions:



\- What is the overall campaign conversion rate?

\- Which customer and campaign segments have higher response rates?

\- Can predictive modeling improve customer targeting?

\- Which features are most useful for identifying likely subscribers?

\- How can the results be translated into business recommendations?



\## Tools Used



\- SQL Server: data import, validation, KPI calculation, segment summaries, and dashboard-ready views

\- Python: EDA, feature engineering, predictive modeling, lift analysis, and model interpretation

\- Power BI: dashboard development and business-facing reporting

\- GitHub: project documentation and version control



\## Project Workflow



1\. Import and validate the raw dataset using SQL Server.

2\. Create analysis-ready SQL views for business analysis and dashboard use.

3\. Perform exploratory data analysis in Python.

4\. Build and compare baseline predictive models.

5\. Evaluate campaign targeting lift using model-predicted probabilities.

6\. Interpret model feature importance.

7\. Translate insights into business recommendations and dashboard visuals.



\---



\## SQL Analysis



SQL Server was used to support the database and BI workflow of the project.



The SQL work focuses on:



\- creating the project database and raw data table

\- importing the original CSV file

\- validating row counts, target values, and data quality

\- creating business-friendly fields for analysis

\- calculating campaign KPIs

\- summarizing conversion rates by customer and campaign segments

\- creating dashboard-ready views for Power BI



\### SQL Files



The SQL scripts are stored in the `sql/` folder:



\- `00\_setup\_import.sql`: creates the database, creates the raw table, imports the CSV file, and checks whether the import worked correctly.

\- `01\_bank\_marketing\_analysis.sql`: validates the imported data, creates analysis-ready views, calculates campaign KPIs, performs segment conversion analysis, and creates dashboard-ready views.



\### Key SQL Views



The SQL analysis creates the following views:



\- `vw\_bank\_marketing\_analysis\_ready`

\- `vw\_campaign\_kpi`

\- `vw\_segment\_conversion\_summary`



These views are designed to support both SQL analysis and later Power BI dashboard development.



\### Main SQL Outputs



The SQL analysis produces:



\- overall campaign conversion KPI

\- data quality validation checks

\- analysis-ready view with business-friendly fields

\- conversion rate by job, month, contact type, previous campaign outcome, and age group

\- high-response segment summary

\- dashboard-ready views for Power BI



\### SQL Output Screenshots



\*\*Raw Table Check\*\*



!\[Raw table check](images/sql/raw\_table\_check.jpg)



\*\*Data Quality Check\*\*



!\[Data quality check](images/sql/data\_quality\_check.jpg)



\*\*Analysis-Ready View\*\*



!\[Analysis-ready view](images/sql/create\_analysis\_ready\_view.jpg)



\*\*Overall Campaign KPI\*\*



!\[Overall campaign KPI](images/sql/overall\_campaign\_kpi.jpg)



\*\*Segment Conversion Analysis\*\*



!\[Segment conversion analysis](images/sql/conversion\_by\_segment.jpg)



\*\*High-Response Segment Summary\*\*



!\[High-response segment summary](images/sql/high\_response\_segment\_summary.jpg)



\### SQL Summary



The SQL analysis confirms that the dataset was imported correctly and that the campaign baseline conversion rate is approximately 11.7%.



The SQL segment summaries show meaningful differences in conversion rates across customer and campaign groups. These outputs support the Python EDA and provide dashboard-ready views for Power BI.



\---



\## Python Analysis



The Python notebook performs deeper exploratory analysis and predictive modeling.



Main notebook components:



\- data quality review

\- target variable and baseline conversion KPI

\- automated profiling reports

\- feature engineering for business analysis

\- segment-level EDA

\- statistical association analysis

\- baseline predictive modeling

\- campaign targeting lift evaluation

\- Random Forest feature importance

\- business recommendations and limitations



The notebook shows that model-based targeting can significantly improve campaign efficiency compared with random customer selection.



\## Model Targeting Result



The Random Forest model performed best among the baseline models.



Using predicted subscription probabilities, the top 10% highest-probability customers achieved a conversion rate of approximately 48.9%, compared with the baseline conversion rate of approximately 11.7%.



This represents a lift of approximately 4.18 times the baseline.



\## Power BI Dashboard



The Power BI dashboard will use the SQL dashboard-ready views and Python analysis outputs to present the campaign results in a business-facing format.



Planned dashboard pages:



\- Campaign Overview

\- Segment Conversion Analysis

\- Model Targeting Impact

\- Business Recommendations



\## Repository Structure



```text

bank-marketing-campaign-analysis/

│

├── README.md

├── .gitignore

│

├── notebooks/

│   └── bank\_marketing\_campaign\_analysis.ipynb

│

├── sql/

│   ├── 00\_setup\_import.sql

│   └── 01\_bank\_marketing\_analysis.sql

│

├── data/

│   └── README.md

│

├── images/

│   └── sql/

│       ├── raw\_table\_check.jpg

│       ├── data\_quality\_check.jpg

│       ├── create\_analysis\_ready\_view.jpg

│       ├── overall\_campaign\_kpi.jpg

│       ├── conversion\_by\_segment.jpg

│       └── high\_response\_segment\_summary.jpg

│

└── dashboard/

