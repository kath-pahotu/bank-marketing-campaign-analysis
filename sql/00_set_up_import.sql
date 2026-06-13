--Step 1: Create a new database

IF DB_ID('bank_marketing_project') IS NULL
BEGIN
    CREATE DATABASE bank_marketing_project;
END;
GO

USE bank_marketing_project;
GO

--Step 2: Create the table
USE bank_marketing_project;
GO

DROP TABLE IF EXISTS bank_marketing_raw;
GO

CREATE TABLE bank_marketing_raw (
    age INT,
    job VARCHAR(50),
    marital VARCHAR(50),
    education VARCHAR(50),
    [default] VARCHAR(10),
    balance INT,
    housing VARCHAR(10),
    loan VARCHAR(10),
    contact VARCHAR(50),
    [day] INT,
    [month] VARCHAR(10),
    duration INT,
    campaign INT,
    pdays INT,
    previous INT,
    poutcome VARCHAR(50),
    y VARCHAR(10)
);
GO

--Step 3: Import the CSV file
BULK INSERT bank_marketing_raw
FROM 'C:\Users\phanh\Data Analyst Journey\portfolio_projects\bank_marketing_campaign_analysis\data\bank-full.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',
    FIELDQUOTE = '"',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001'
);
GO

--Check if import worked
SELECT TOP 10 *
FROM bank_marketing_raw;

--check row count
SELECT COUNT(*) AS total_rows
FROM bank_marketing_raw;


--check column
SELECT
    COUNT(*) AS total_rows,
    COUNT(CASE WHEN y = 'yes' THEN 1 END) AS subscribers,
    COUNT(CASE WHEN y = 'no' THEN 1 END) AS non_subscribers
FROM bank_marketing_raw;




