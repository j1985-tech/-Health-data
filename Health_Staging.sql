
-- cleaning the health database 
USE [Health]
GO

SELECT [Patient_ID]
      ,[First_Name]
      ,[Age]
      ,[Gender]
      ,[Zip_Code]
      ,[AuditID]
      ,[Insurance]
      ,[Email]
      ,[City]
  FROM [dbo].[Patients_Staging]

GO
SELECT *
From dbo.Patients_staging;

UPDATE dbo.Patients_staging
SET Age = 0
WHERE Age IS NULL;

UPDATE dbo.Patients_Staging
SET Gender = 
    CASE 
        WHEN Gender IN ('M','Male') THEN 'Male'
        WHEN Gender IN ('F','Female') THEN 'Female'
        ELSE 'Unknown'
    END;

    UPDATE dbo.Visits_staging
SET Diagnosis = 'No Code'
WHERE Diagnosis IS NULL;

UPDATE dbo.Claims_staging
SET Claim_Amount = 0
WHERE Claim_Amount IS NULL;


/* =========================
   DATA CLEANING - HEALTH TABLES
   
   ========================= */

UPDATE dbo.Patients_Staging
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
             END;

    
    UPDATE dbo.Visits_Staging
SET 

    --Replace NULL Diagnosis_Code with default value
    Diagnosis = ISNULL(Diagnosis, 'No Code');

    
    UPDATE dbo.Claims_Staging
SET 
    -- Replace NULL Billing_Amount with 0
    Claim_Amount = ISNULL(Claim_Amount, 0);

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
    
    
    
    /* =========================================
   FULL LOAD: Create staging table from raw
   Used for initial load only
   ========================================= */
   SELECT *
INTO dbo.Claims_Staging
FROM dbo.claims;

 SELECT *
INTO dbo.Patients_Staging
FROM dbo.patients;

 SELECT *
INTO dbo.Visits_Staging
FROM dbo.visits;



UPDATE dbo.Claims_Staging
SET Claim_Amount = 0
WHERE Claim_Amount IS NULL;



UPDATE dbo.Patients_Staging
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
SET diagnosis = 'No Code'
WHERE diagnosis IS NULL;
