--Find Duplicate Patient IDs

SELECT
    Patient_ID,
    COUNT(*) AS DuplicateCount
FROM dbo.Patients_Staging 
GROUP BY Patient_ID
HAVING COUNT(*) > 1;

-- View Duplicate Records Using CTE
WITH PatientCTE AS
(
    SELECT *,
           ROW_NUMBER() OVER
           (
               PARTITION BY Patient_ID
               ORDER BY Email
           ) AS RN
    FROM dbo.Patients_Staging
)

-- Delete Duplicate Records

SELECT *
FROM PatientCTE
WHERE RN > 1;


WITH PatientCTE AS
(
    SELECT *,
           ROW_NUMBER() OVER
           (
               PARTITION BY Patient_ID
               ORDER BY Email
           ) AS RN
    FROM dbo.Patients_Staging
)

DELETE
FROM PatientCTE
WHERE RN > 1;