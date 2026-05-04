USE [Health]
GO

SELECT [Patient_ID]
      ,[Name]
      ,[Age]
      ,[Gender]
      ,[Visit_Date]
      ,[Diagnosis_Code]
      ,[Billing_Amount]
      ,[Hospital]
      ,[City]
  FROM [dbo].[health_raw_data]

GO
SELECT *
From dbo.health_staging;

UPDATE dbo.health_staging
SET Age = 0
WHERE Age IS NULL;

UPDATE dbo.health_staging
SET Gender = 
    CASE 
        WHEN Gender IN ('M','Male') THEN 'Male'
        WHEN Gender IN ('F','Female') THEN 'Female'
        ELSE 'Unknown'
    END;

    UPDATE dbo.health_staging
SET Diagnosis_Code = 'No Code'
WHERE Diagnosis_Code IS NULL;

UPDATE dbo.health_staging
SET Billing_Amount = 0
WHERE Billing_Amount IS NULL;


/* =========================
   DATA CLEANING - HEALTH TABLE
   dbo.health_staging
   ========================= */

UPDATE dbo.health_staging
SET 
    -- Replace NULL Age with 0
    Age = CASE 
            WHEN Age IS NULL THEN 0 
            ELSE Age 
          END,

    -- Standardize Gender values
    Gender = CASE 
                WHEN Gender IN ('M', 'Male') THEN 'Male'
                WHEN Gender IN ('F', 'Female') THEN 'Female'
                ELSE 'Unknown'
             END,

    -- Replace NULL Diagnosis_Code with default value
    Diagnosis_Code = ISNULL(Diagnosis_Code, 'No Code'),

    -- Replace NULL Billing_Amount with 0
    Billing_Amount = ISNULL(Billing_Amount, 0);

    /* =========================================
   DATA VALIDATION QUERY
   Purpose: View all records from staging
   Table: Claims_staging
   Table: visits_staging
   Table: patients_staging  
   Table: health_staging
   Usage: Used after ETL load to verify data
   ========================================= */
    Select * From dbo.visits_staging;
    Select * from dbo.claims_staging;
    Select * from dbo.patients_staging;
    Select * from dbo.health_staging;
    
    
    /* =========================================
   FULL LOAD: Create staging table from raw
   Used for initial load only
   ========================================= */
   SELECT *
INTO dbo.claims_staging
FROM dbo.claims;

 SELECT *
INTO dbo.patients_staging
FROM dbo.patients;

 SELECT *
INTO dbo.visits_staging
FROM dbo.visits;



UPDATE dbo.claims_staging
SET Billing_Amount = 0
WHERE Billing_Amount IS NULL;

UPDATE dbo.health_staging
SET Billing_Amount = 0
WHERE Billing_Amount IS NULL;

UPDATE dbo.patients_staging
SET 
    -- Replace NULL Age with 0
    age = CASE 
            WHEN Age IS NULL THEN 0 
            ELSE Age 
          END,

    -- Standardize Gender values
    gender = CASE 
                WHEN Gender IN ('M', 'Male') THEN 'Male'
                WHEN Gender IN ('F', 'Female') THEN 'Female'
                ELSE 'Unknown'
             END;

             
    UPDATE dbo.visits_staging
SET diagnosis_code = 'No Code'
WHERE diagnosis_code IS NULL;
