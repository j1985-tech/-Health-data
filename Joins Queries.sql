-- Join Visits and Claims

SELECT
    v.Visit_ID,
    v.Patient_ID,
    v.Admission_Date,
    c.Claim_ID,
    c.Claim_Amount,
    c.Claim_Status
FROM Visits_Staging v
INNER JOIN Claims_Staging c
ON v.Visit_ID = c.Visit_ID;

-- Find Patients with Multiple Claims (ROW_NUMBER)

--we can use Below Use Case
--1.Keeps the latest claim for each patient.
--2.Removes duplicate claim history during ETL.

WITH ClaimCTE AS
(
SELECT
    v.Patient_ID,
    v.Admission_Date,
    c.Claim_ID,
    c.Claim_Amount,

    ROW_NUMBER() OVER
    (
        PARTITION BY v.Patient_ID
        ORDER BY v.Admission_Date DESC
    ) AS RN

FROM Visits_Staging v
INNER JOIN Claims_Staging c
ON v.Visit_ID = c.Visit_ID
)

SELECT *
FROM ClaimCTE
WHERE RN = 1;