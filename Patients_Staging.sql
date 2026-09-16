SELECT * FROM dbo.patients;
SELECT * FROM dbo.Patients_Staging;
SELECT *

INTO dbo.Patients_Staging
From dbo.patients;


    -- Clean all text fields: trim spaces and convert empty strings to NULL
UPDATE dbo.Patients_Staging
SET 
    Patient_ID      = NULLIF(LTRIM(RTRIM(Patient_ID)), ''),
    First_Name      = NULLIF(LTRIM(RTRIM(First_Name)), ''),
    Last_Name       = NULLIF(LTRIM(RTRIM(Last_Name)), ''),
    Date_of_Birth   = NULLIF(LTRIM(RTRIM(Date_of_Birth)), ''),
    Gender          = NULLIF(LTRIM(RTRIM(Gender)), ''),
    Phone           = NULLIF(LTRIM(RTRIM(Phone)), ''),
    Email           = NULLIF(LTRIM(RTRIM(Email)), ''),
    City            = NULLIF(LTRIM(RTRIM(City)), ''),
    Zip_Code        = NULLIF(LTRIM(RTRIM(Zip_Code)), ''),
    Patient_Status  = NULLIF(LTRIM(RTRIM(Patient_Status)), ''),
    Insurance       = NULLIF(LTRIM(RTRIM(Insurance)), '');

   -- Add a clean DOB column
IF NOT EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME='dbo.Patients_Staging' AND COLUMN_NAME='Clean_DOB'
)
ALTER TABLE dbo.Patients_Staging ADD Clean_DOB DATE;

-- Convert all DOB formats into a proper DATE
UPDATE dbo.Patients_Staging
SET Date_of_Birth = COALESCE(
        TRY_CONVERT(date, Date_of_Birth, 101),  -- mm/dd/yyyy
        TRY_CONVERT(date, Date_of_Birth, 103),  -- dd/mm/yyyy
        TRY_CONVERT(date, Date_of_Birth, 105),  -- dd-mm-yyyy
        TRY_CONVERT(date, Date_of_Birth, 110),  -- mm-dd-yyyy
        TRY_CONVERT(date, Date_of_Birth, 111),  -- yyyy/mm/dd
        TRY_CONVERT(date, Date_of_Birth, 120),  -- yyyy-mm-dd
        TRY_CONVERT(date, Date_of_Birth, 107)   -- Month dd, yyyy
    );

    -- Add invalid DOB flag
IF NOT EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME='dbo.Patients_Staging' AND COLUMN_NAME='Invalid_DOB_Flag'
)
ALTER TABLE dbo.Patients_Staging ADD Invalid_DOB_Flag BIT;

UPDATE dbo.Patients_Staging
SET Invalid_DOB_Flag = CASE
        WHEN Date_of_Birth IS NULL THEN 1
        WHEN Clean_DOB IS NULL THEN 1
        ELSE 0
    END;


    -- Standardize gender values
UPDATE dbo.Patients_Staging
SET Gender = CASE
        WHEN Gender IN ('M','m','Male','male') THEN 'Male'
        WHEN Gender IN ('F','f','Female','female') THEN 'Female'
        WHEN Gender IN ('Other','other') THEN 'Other'
        WHEN Gender IN ('Unknown','unknown') THEN 'Unknown'
        ELSE NULL
    END;

    -- Standardize patient status
UPDATE dbo.Patients_Staging
SET Patient_Status = CASE
        WHEN LOWER(Patient_Status) = 'active' THEN 'Active'
        WHEN LOWER(Patient_Status) = 'inactive' THEN 'Inactive'
        WHEN LOWER(Patient_Status) = 'deceased' THEN 'Deceased'
        WHEN LOWER(Patient_Status) = 'unknown' THEN 'Unknown'
        ELSE NULL
    END;


    -- Replace invalid emails with NULL
UPDATE dbo.Patients_Staging
SET Email = NULL
WHERE Email NOT LIKE '%@%.%';

-- Clean phone numbers: remove spaces
UPDATE dbo.Patients_Staging
SET Phone = REPLACE(Phone, ' ', '');

-- Set invalid phone numbers to NULL
UPDATE dbo.Patients_Staging
SET Phone = NULL
WHERE Phone NOT LIKE '%[0-9]%' OR LEN(Phone) < 7;

-- Convert ZIP to 5-digit format where possible
UPDATE dbo.Patients_Staging
SET Zip_Code = RIGHT('00000' + Zip_Code, 5)
WHERE Zip_Code IS NOT NULL AND Zip_Code LIKE '%[0-9]%';

-- Capitalize first letter of names
UPDATE dbo.Patients_Staging
SET First_Name = UPPER(LEFT(First_Name,1)) + LOWER(SUBSTRING(First_Name,2,LEN(First_Name))),
    Last_Name  = UPPER(LEFT(Last_Name,1))  + LOWER(SUBSTRING(Last_Name,2,LEN(Last_Name)))
WHERE First_Name IS NOT NULL OR Last_Name IS NOT NULL;

UPDATE dbo.Patients_Staging
SET 
    First_Name = NULLIF(First_Name, ''),
    Last_Name = NULLIF(Last_Name, ''),
    Gender = NULLIF(Gender, ''),
    Patient_Status = NULLIF(Patient_Status, ''),
    Insurance = NULLIF(Insurance, '');

    CREATE VIEW vw_patients_clean AS
SELECT
    Patient_ID,
    First_Name,
    Last_Name,
    Clean_DOB AS Date_of_Birth,
    Age,
    Gender,
    Phone,
    Email,
    City,
    Zip_Code,
    Patient_Status,
    Insurance,
    Invalid_DOB_Flag
FROM dbo.Patients_Staging;

SELECT * FROM vw_patients_clean;

    --short Version 
    UPDATE vw_patients_clean
SET
    Age = ISNULL(Age, 0),
    Zip_Code = ISNULL(Zip_code, 0),
    Date_of_Birth = ISNULL(Date_of_Birth, '1900-01-01'),
    First_Name = ISNULL(LTRIM(RTRIM(First_Name)), 'No_Name'),
    Last_Name = ISNULL(LTRIM(RTRIM(Last_Name)), 'No_Name'),
    Gender = ISNULL(LTRIM(RTRIM(Gender)), 'Unknown'),
    Phone = ISNULL(LTRIM(RTRIM(Phone)), 'Unknown'),
    Email = ISNULL(LTRIM(RTRIM(Email)), 'Unknown'),
    City = ISNULL(LTRIM(RTRIM(City)), 'Unknown'),
    Patient_Status = ISNULL(LTRIM(RTRIM(Patient_Status)), 'Unknown'),
    Insurance = ISNULL(LTRIM(RTRIM(Insurance)), 'Unknown')

WHERE 
    Age IS NULL
    OR Zip_Code IS NULL
    OR Date_of_Birth IS NULL
    OR First_Name IS NULL
    OR Last_Name IS NULL
    OR Gender IS NULL
    OR Phone IS NULL
    OR Email IS NULL
    OR City IS NULL
    OR Patient_Status IS NULL
    OR Insurance IS NULL;





 