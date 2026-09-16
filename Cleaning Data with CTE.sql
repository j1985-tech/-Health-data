--| Cleaning Rule                | SQL Function         |
--| ---------------------------- | -------------------- |
--| Remove duplicates            | `ROW_NUMBER()`       |
--| Trim spaces                  | `LTRIM()`, `RTRIM()` |
--| Standardize names            | `UPPER()`, `LOWER()` |
--| Standardize gender           | `CASE`               |
--| Replace invalid dates        | `CASE`               |
--| Convert emails to lowercase  | `LOWER()`            |
--| Remove phone formatting      | `REPLACE()`          |
--| Keep only one patient record | `WHERE RN = 1`       


--CTE Patient_Clean

WITH Patient_Clean AS
(
SELECT
    Patient_ID,

    -- Remove extra spaces and convert to Proper Case
    UPPER(LEFT(LTRIM(RTRIM(First_Name)),1)) +
    LOWER(SUBSTRING(LTRIM(RTRIM(First_Name)),2,LEN(First_Name)))
        AS First_Name,

    -- Standardize Gender
    CASE
        WHEN UPPER(Gender) IN ('M','MALE') THEN 'Male'
        WHEN UPPER(Gender) IN ('F','FEMALE') THEN 'Female'
        ELSE 'Unknown'
    END AS Gender,

    -- Replace Invalid Date_of_Birth
    CASE
        WHEN Date_of_Birth='1900-01-01'
             OR Date_of_Birth IS NULL
        THEN NULL
        ELSE Date_of_Birth
    END AS Date_of_Birth,

    -- Convert Email to Lower Case
    LOWER(Email) AS Email,

    -- Remove special characters from Phone
    REPLACE(REPLACE(REPLACE(Phone,'-',''),'(',''),')','') AS Phone,

    -- Remove spaces from City
    LTRIM(RTRIM(City)) AS City,

    ROW_NUMBER() OVER
    (
        PARTITION BY Patient_ID
        ORDER BY Patient_ID
    ) RN

FROM dbo.Patients_Staging
)

SELECT
Patient_ID,
First_Name,
Gender,
Date_of_Birth,
Email,
Phone,
City
FROM Patient_Clean
WHERE RN=1;


Select Date_of_Birth from dbo.Patients_Staging;