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


