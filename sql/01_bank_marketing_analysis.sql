/* ============================================================
   PROJECT: Bank Marketing Campaign Analysis
   TOOL: SQL Server
   PURPOSE:
   - Validate imported campaign data
   - Create business-ready fields
   - Calculate campaign KPIs
   - Build segment-level conversion summaries
   - Prepare dashboard-ready views
   ============================================================ */

USE bank_marketing_project;
GO


/* ============================================================
   1. Raw Table Check
   ============================================================ */

-- Preview imported data
SELECT TOP 10 *
FROM bank_marketing_raw;

-- Check total row count
SELECT 
    COUNT(*) AS total_rows
FROM bank_marketing_raw;

-- Check target counts
SELECT
    y AS response,
    COUNT(*) AS customers
FROM bank_marketing_raw
GROUP BY y
ORDER BY customers DESC;


/* ============================================================
   2. Data Quality Validation
   ============================================================ */

-- Data quality summary
SELECT
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(age) AS missing_age,
    COUNT(*) - COUNT(job) AS missing_job,
    COUNT(*) - COUNT(marital) AS missing_marital,
    COUNT(*) - COUNT(education) AS missing_education,
    COUNT(*) - COUNT(y) AS missing_target
FROM bank_marketing_raw;

-- Check duplicate rows
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT CONCAT(
        age, '|', job, '|', marital, '|', education, '|', [default], '|',
        balance, '|', housing, '|', loan, '|', contact, '|', [day], '|',
        [month], '|', duration, '|', campaign, '|', pdays, '|',
        previous, '|', poutcome, '|', y
    )) AS distinct_rows
FROM bank_marketing_raw;

-- Check target values
SELECT
    y AS response,
    COUNT(*) AS customers
FROM bank_marketing_raw
GROUP BY y;


/* ============================================================
   3. Create Analysis-Ready View
   ============================================================ */

CREATE OR ALTER VIEW vw_bank_marketing_analysis_ready AS
SELECT
    age,
    job,
    marital,
    education,
    [default],
    balance,
    housing,
    loan,
    contact,
    [day],
    [month],
    duration,
    campaign,
    pdays,
    previous,
    poutcome,
    y,

    CASE
        WHEN y = 'yes' THEN 1
        ELSE 0
    END AS y_binary,

    CASE
        WHEN age < 25 THEN '<25'
        WHEN age BETWEEN 25 AND 34 THEN '25-34'
        WHEN age BETWEEN 35 AND 44 THEN '35-44'
        WHEN age BETWEEN 45 AND 54 THEN '45-54'
        WHEN age BETWEEN 55 AND 64 THEN '55-64'
        ELSE '65+'
    END AS age_group,

    CASE
        WHEN balance < 0 THEN 'negative'
        WHEN balance BETWEEN 0 AND 1000 THEN '0-1,000'
        WHEN balance BETWEEN 1001 AND 5000 THEN '1,001-5,000'
        WHEN balance BETWEEN 5001 AND 10000 THEN '5,001-10,000'
        ELSE '10,000+'
    END AS balance_group,

    CASE
        WHEN pdays = -1 THEN 0
        ELSE 1
    END AS was_previously_contacted,

    CASE
        WHEN previous = 0 THEN '0 previous contacts'
        WHEN previous = 1 THEN '1 previous contact'
        WHEN previous = 2 THEN '2 previous contacts'
        WHEN previous = 3 THEN '3 previous contacts'
        WHEN previous BETWEEN 4 AND 5 THEN '4-5 previous contacts'
        WHEN previous BETWEEN 6 AND 10 THEN '6-10 previous contacts'
        ELSE '10+ previous contacts'
    END AS previous_contact_group,

    CASE
        WHEN campaign = 1 THEN '1 contact'
        WHEN campaign BETWEEN 2 AND 3 THEN '2-3 contacts'
        WHEN campaign BETWEEN 4 AND 5 THEN '4-5 contacts'
        WHEN campaign BETWEEN 6 AND 10 THEN '6-10 contacts'
        ELSE '10+ contacts'
    END AS campaign_contact_group,

    CASE
        WHEN housing = 'yes' OR loan = 'yes' THEN 1
        ELSE 0
    END AS has_any_loan

FROM bank_marketing_raw;
GO


-- Preview analysis-ready view
SELECT TOP 10 *
FROM vw_bank_marketing_analysis_ready;


/* ============================================================
   4. Overall Campaign KPI
   ============================================================ */

SELECT
    COUNT(*) AS total_customers,
    SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) AS subscribers,
    SUM(CASE WHEN y = 'no' THEN 1 ELSE 0 END) AS non_subscribers,
    ROUND(
        100.0 * SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS conversion_rate_pct
FROM vw_bank_marketing_analysis_ready;


/* ============================================================
   5. Segment Conversion Analysis
   ============================================================ */

-- Conversion by job
SELECT
    job,
    COUNT(*) AS customers,
    SUM(y_binary) AS subscribers,
    COUNT(*) - SUM(y_binary) AS non_subscribers,
    ROUND(100.0 * SUM(y_binary) / COUNT(*), 2) AS conversion_rate_pct
FROM vw_bank_marketing_analysis_ready
GROUP BY job
ORDER BY conversion_rate_pct DESC;

-- Conversion by month
SELECT
    [month],
    COUNT(*) AS customers,
    SUM(y_binary) AS subscribers,
    COUNT(*) - SUM(y_binary) AS non_subscribers,
    ROUND(100.0 * SUM(y_binary) / COUNT(*), 2) AS conversion_rate_pct
FROM vw_bank_marketing_analysis_ready
GROUP BY [month]
ORDER BY conversion_rate_pct DESC;

-- Conversion by contact type
SELECT
    contact,
    COUNT(*) AS customers,
    SUM(y_binary) AS subscribers,
    COUNT(*) - SUM(y_binary) AS non_subscribers,
    ROUND(100.0 * SUM(y_binary) / COUNT(*), 2) AS conversion_rate_pct
FROM vw_bank_marketing_analysis_ready
GROUP BY contact
ORDER BY conversion_rate_pct DESC;

-- Conversion by previous campaign outcome
SELECT
    poutcome,
    COUNT(*) AS customers,
    SUM(y_binary) AS subscribers,
    COUNT(*) - SUM(y_binary) AS non_subscribers,
    ROUND(100.0 * SUM(y_binary) / COUNT(*), 2) AS conversion_rate_pct
FROM vw_bank_marketing_analysis_ready
GROUP BY poutcome
ORDER BY conversion_rate_pct DESC;

-- Conversion by age group
SELECT
    age_group,
    COUNT(*) AS customers,
    SUM(y_binary) AS subscribers,
    COUNT(*) - SUM(y_binary) AS non_subscribers,
    ROUND(100.0 * SUM(y_binary) / COUNT(*), 2) AS conversion_rate_pct
FROM vw_bank_marketing_analysis_ready
GROUP BY age_group
ORDER BY conversion_rate_pct DESC;


/* ============================================================
   6. High-Response Segment Summary
   ============================================================ */

-- Combine important segments into one summary table
WITH segment_summary AS (

    SELECT
        'job' AS segment_type,
        job AS segment,
        COUNT(*) AS customers,
        SUM(y_binary) AS subscribers,
        ROUND(100.0 * SUM(y_binary) / COUNT(*), 2) AS conversion_rate_pct
    FROM vw_bank_marketing_analysis_ready
    GROUP BY job

    UNION ALL

    SELECT
        'month' AS segment_type,
        [month] AS segment,
        COUNT(*) AS customers,
        SUM(y_binary) AS subscribers,
        ROUND(100.0 * SUM(y_binary) / COUNT(*), 2) AS conversion_rate_pct
    FROM vw_bank_marketing_analysis_ready
    GROUP BY [month]

    UNION ALL

    SELECT
        'contact' AS segment_type,
        contact AS segment,
        COUNT(*) AS customers,
        SUM(y_binary) AS subscribers,
        ROUND(100.0 * SUM(y_binary) / COUNT(*), 2) AS conversion_rate_pct
    FROM vw_bank_marketing_analysis_ready
    GROUP BY contact

    UNION ALL

    SELECT
        'poutcome' AS segment_type,
        poutcome AS segment,
        COUNT(*) AS customers,
        SUM(y_binary) AS subscribers,
        ROUND(100.0 * SUM(y_binary) / COUNT(*), 2) AS conversion_rate_pct
    FROM vw_bank_marketing_analysis_ready
    GROUP BY poutcome

    UNION ALL

    SELECT
        'age_group' AS segment_type,
        age_group AS segment,
        COUNT(*) AS customers,
        SUM(y_binary) AS subscribers,
        ROUND(100.0 * SUM(y_binary) / COUNT(*), 2) AS conversion_rate_pct
    FROM vw_bank_marketing_analysis_ready
    GROUP BY age_group

)

SELECT
    segment_type,
    segment,
    customers,
    subscribers,
    conversion_rate_pct
FROM segment_summary
WHERE customers >= 500
ORDER BY conversion_rate_pct DESC;


/* ============================================================
   7. Dashboard-Ready Views
   ============================================================ */

-- Overall KPI view
CREATE OR ALTER VIEW vw_campaign_kpi AS
SELECT
    COUNT(*) AS total_customers,
    SUM(y_binary) AS subscribers,
    COUNT(*) - SUM(y_binary) AS non_subscribers,
    ROUND(100.0 * SUM(y_binary) / COUNT(*), 2) AS conversion_rate_pct
FROM vw_bank_marketing_analysis_ready;
GO


-- Segment summary view for Power BI
CREATE OR ALTER VIEW vw_segment_conversion_summary AS
WITH segment_summary AS (

    SELECT
        'job' AS segment_type,
        job AS segment,
        COUNT(*) AS customers,
        SUM(y_binary) AS subscribers,
        ROUND(100.0 * SUM(y_binary) / COUNT(*), 2) AS conversion_rate_pct
    FROM vw_bank_marketing_analysis_ready
    GROUP BY job

    UNION ALL

    SELECT
        'month' AS segment_type,
        [month] AS segment,
        COUNT(*) AS customers,
        SUM(y_binary) AS subscribers,
        ROUND(100.0 * SUM(y_binary) / COUNT(*), 2) AS conversion_rate_pct
    FROM vw_bank_marketing_analysis_ready
    GROUP BY [month]

    UNION ALL

    SELECT
        'contact' AS segment_type,
        contact AS segment,
        COUNT(*) AS customers,
        SUM(y_binary) AS subscribers,
        ROUND(100.0 * SUM(y_binary) / COUNT(*), 2) AS conversion_rate_pct
    FROM vw_bank_marketing_analysis_ready
    GROUP BY contact

    UNION ALL

    SELECT
        'poutcome' AS segment_type,
        poutcome AS segment,
        COUNT(*) AS customers,
        SUM(y_binary) AS subscribers,
        ROUND(100.0 * SUM(y_binary) / COUNT(*), 2) AS conversion_rate_pct
    FROM vw_bank_marketing_analysis_ready
    GROUP BY poutcome

    UNION ALL

    SELECT
        'age_group' AS segment_type,
        age_group AS segment,
        COUNT(*) AS customers,
        SUM(y_binary) AS subscribers,
        ROUND(100.0 * SUM(y_binary) / COUNT(*), 2) AS conversion_rate_pct
    FROM vw_bank_marketing_analysis_ready
    GROUP BY age_group

)

SELECT
    segment_type,
    segment,
    customers,
    subscribers,
    conversion_rate_pct
FROM segment_summary;
GO

/* ============================================================
   8. Check Dashboard-Ready Views
   ============================================================ */

-- Check overall KPI view
SELECT *
FROM vw_campaign_kpi;

-- Check segment conversion summary view
SELECT TOP 20 *
FROM vw_segment_conversion_summary
ORDER BY conversion_rate_pct DESC;

-- Check segment types included in dashboard-ready view
SELECT
    segment_type,
    COUNT(*) AS number_of_segments
FROM vw_segment_conversion_summary
GROUP BY segment_type
ORDER BY segment_type;