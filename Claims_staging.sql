SELECT * FROM dbo.Claims_Staging;
SELECT *
INTO dbo.Claims_Staging
FROM dbo.Claims; 

-- 1️⃣ Standardize all date formats
-- Standardize Claim_Date into a consistent DATE format
UPDATE dbo.Claims_Staging
SET Claim_Date = COALESCE(
        TRY_CONVERT(date, Claim_Date, 105),   -- dd-mm-yyyy
        TRY_CONVERT(date, Claim_Date, 103),   -- dd/mm/yyyy
        TRY_CONVERT(date, Claim_Date, 101),   -- mm/dd/yyyy
        TRY_CONVERT(date, Claim_Date, 102),   -- yyyy.mm.dd
        TRY_CONVERT(date, Claim_Date, 120),   -- yyyy-mm-dd
        TRY_CONVERT(date, Claim_Date, 107)    -- Month dd, yyyy
    );

    -- 2️⃣ Fix negative claim amounts
    -- Convert negative claim amounts to positive values
UPDATE dbo.Claims_Staging
SET Claim_Amount = ABS(Claim_Amount)
WHERE Claim_Amount < 0;

--3️⃣ Normalize Claim_Status values
-- Normalize claim status values to consistent casing
UPDATE dbo.Claims_Staging
SET Claim_Status = CASE 
        WHEN LOWER(Claim_Status) = 'paid' THEN 'Paid'
        WHEN LOWER(Claim_Status) = 'denied' THEN 'Denied'
        WHEN LOWER(Claim_Status) = 'pending' THEN 'Pending'
        WHEN LOWER(Claim_Status) = 'under review' THEN 'Under Review'
        ELSE NULL  -- Replace unknown or blank statuses with NULL
    END;

    -- 4️⃣ Trim whitespace and clean text fields
    -- Trim whitespace and convert empty strings to NULL
UPDATE dbo.Claims_Staging
SET 
    Claim_ID = NULLIF(LTRIM(RTRIM(Claim_ID)), ''),
    Patient_ID = NULLIF(LTRIM(RTRIM(Patient_ID)), ''),
    Visit_ID = NULLIF(LTRIM(RTRIM(Visit_ID)), ''),
    Hospital = NULLIF(LTRIM(RTRIM(Hospital)), ''),
    Insurance_Provider = NULLIF(LTRIM(RTRIM(Insurance_Provider)), ''),
    Claim_Status = NULLIF(LTRIM(RTRIM(Claim_Status)), ''),
    ICD_Code = NULLIF(LTRIM(RTRIM(ICD_Code)), ''),
    Approval_Code = NULLIF(LTRIM(RTRIM(Approval_Code)), '');

   -- 5️⃣ Validate ICD codes
   -- Set invalid ICD codes to NULL
UPDATE dbo.Claims_Staging
SET ICD_Code = NULL
WHERE ICD_Code NOT LIKE 'ICD-%';

-- 6️⃣ Remove duplicate Claim_ID rows
-- Remove duplicate Claim_ID rows
DELETE c
FROM claims c
JOIN (
    SELECT Claim_ID, MIN(Claim_ID) AS KeepRow
    FROM claims
    GROUP BY Claim_ID
) x ON c.Claim_ID = x.Claim_ID
WHERE c.Claim_ID <> x.KeepRow;

 -- -- Replace NULL VALUES
    UPDATE Claims_Staging
SET
    Hospital = ISNULL(Hospital, 'No_Hospttal'),
    Claim_Amount = ISNULL(Claim_Amount, 0),
    Claim_Date = ISNULL(Claim_Date, '1900-01-01'),
    Insurance_Provider = ISNULL(LTRIM(RTRIM(Insurance_Provider)), 'No_Insurance'),
    Claim_Status = ISNULL(LTRIM(RTRIM(Insurance_Provider)), 'No_Insurance'),
    ICD_Code = ISNULL(LTRIM(RTRIM(Insurance_Provider)), 'No_Code'),
    Approval_Code = ISNULL(LTRIM(RTRIM(Insurance_Provider)), 'No_Code'),
    Procedure_Name = ISNULL(LTRIM(RTRIM(Procedure_Name)), 'No_Procedure')

-- Update only rows that contain NULL values
WHERE 
    Hospital IS NULL
    OR Claim_Amount IS NULL
    OR Claim_Date IS NULL
    OR Insurance_Provider IS NULL
    OR Claim_Status IS NULL
    OR ICD_Code IS NULL
    OR Approval_Code IS NULL
    OR Procedure_Name IS NULL

-- Retrieve data types for multiple columns in a table
SELECT 
    COLUMN_NAME,            -- Name of the column
    DATA_TYPE,              -- Data type (varchar, int, date, etc.)
    CHARACTER_MAXIMUM_LENGTH, -- Length for text columns
    IS_NULLABLE             -- Whether NULL values are allowed
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Claims_Staging'
  AND COLUMN_NAME IN (
        'Claim_ID',
        'Claim_Date',
        'Claim_Amount',
        'ICD_Code',
        'Procedure'
    );
   
   UPDATE Claims_Staging
SET
Procedure_Name = NULLIF(LTRIM(RTRIM(Procedure_Name)), 'No_Procedure')
WHERE 
Procedure_Name IS NULL

-- Rename a column in SQL Server



-- Remove duplicate rows based on Claim_ID
-- ROW_NUMBER() assigns 1 to the first occurrence and >1 to duplicates
WITH CTE AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY Claim_ID      -- natural key
               ORDER BY Claim_ID
           ) AS rn
    FROM Claims_Staging
)
-- Delete all rows where rn > 1 (duplicates)
DELETE FROM CTE WHERE rn > 1;





