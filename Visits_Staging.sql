Select * from dbo.visits;

SELECT * FROM dbo.Visits_Staging;
SELECT *
INTO dbo.Visits_Staging
FROM dbo.visits;

SELECT * FROM dbo.Visits_Staging;

    --short Version 
    UPDATE dbo.Visits_Staging
SET
    Length_of_Stay = ISNULL(Length_of_Stay, 0),

    Readmission = ISNULL(Readmission, 0),
    Admission_date = ISNULL(Admission_Date, '1900-01-01'),
    Discharge_Date = ISNULL(Discharge_Date, '1900-01-01'),
    Diagnosis = ISNULL(LTRIM(RTRIM(Diagnosis)), 'Unknown'),
    Department = ISNULL(LTRIM(RTRIM(Department)), 'Unknown'),
    Attending_Doctor = ISNULL(LTRIM(RTRIM(Attending_Doctor)), 'Unknown'),
    Visit_Cost = ISNULL(Visit_Cost, 0),
    Visit_Type = ISNULL(LTRIM(RTRIM(Visit_Type)), 'Unknown')
   

WHERE 
    Length_of_Stay IS NULL
    OR Readmission IS NULL
    OR Admission_date IS NULL
    OR Discharge_Date IS NULL
    OR Diagnosis IS NULL
    OR Department IS NULL
    OR Attending_Doctor IS NULL
    OR Visit_Cost IS NULL
    OR Visit_Type IS NULL
    
