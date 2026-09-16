Select Gender, Count(*) as  total From dbo.Patients_Staging group by Gender;

--Finding the total billing amount by each insurance provider

SELECT Insurance_Provider,
 ROUND(sum(Claim_Amount), 2) as Total_Claims
 FROM dbo.Claims_Staging
 GROUP BY Insurance_Provider;

 SELECT
    Insurance_Provider,
    COUNT(DISTINCT Patient_ID) AS Total_Patients,
    SUM(Claim_Amount) AS Total_Claim_Amount
FROM dbo.Claims_Staging
GROUP BY Insurance_Provider
ORDER BY Total_Claim_Amount DESC;

-- Top 10 frequently used diagnosis codes

SELECT TOP 10
    ICD_Code,
    COUNT(*) AS Total_Claims
FROM dbo.Claims_Staging
GROUP BY ICD_Code
ORDER BY Total_Claims DESC;

-- Total claim amount by diagnosis code

SELECT
    ICD_Code,
    Round(SUM(Claim_Amount), 2) AS Total_Claim_Amount
FROM dbo.Claims_Staging
GROUP BY ICD_Code
ORDER BY Total_Claim_Amount DESC;


--READMISSION-RELATED ICD ANALYSIS
-- Patients with repeated diagnosis claims

SELECT
    Patient_ID,
    ICD_Code,
    COUNT(*) AS Visit_Count
FROM dbo.Claims_Staging
GROUP BY
    Patient_ID,
    ICD_Code
HAVING COUNT(*) > 1
ORDER BY Visit_Count DESC;

-- Count the number of patients based on 30-day readmission status

SELECT
    Readmission_30Day,          -- Indicates whether the patient was readmitted within 30 days (Yes/No)

    COUNT(*) AS Total_Patients  -- Counts total patients for each readmission category

FROM Population_Health_Clean   -- Source table containing population health data

GROUP BY Readmission_30Day;    -- Groups records by readmission status

-- ICD category level analysis using first 3 characters

SELECT
    LEFT(ICD_Code, 3) AS ICD_Category,
    COUNT(*) AS Total_Cases
FROM dbo.Claims_Staging
GROUP BY LEFT(ICD_Code, 3)
ORDER BY Total_Cases DESC;

--Patients with Multiple ICD Conditions
-- Patients having multiple diagnosis conditions

SELECT
    Patient_ID,
    COUNT(DISTINCT ICD_Code) AS Total_Diagnoses
FROM dbo.Claims_Staging
GROUP BY Patient_ID
HAVING COUNT(DISTINCT ICD_Code) > 3
ORDER BY Total_Diagnoses DESC;
