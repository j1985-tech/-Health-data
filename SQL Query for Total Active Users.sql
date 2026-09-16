
--counting for active patients in hospital
SELECT * fROM dbo.Patients_Staging;
SELECT COUNT(*) AS TotalActiveUsers
FROM dbo.Patients_Staging
WHERE Patient_Status = 'Active';
--counting for active patients from last in hospital
SELECT COUNT(*) AS TotalActiveUsers
FROM dbo.Patients_Staging
WHERE Patient_Status = 'Active'
  AND Date_of_Birth >= DATEADD(DAY, -90, GETDATE());
 -- Adding new columns to the table 
 ALTER TABLE dbo.Patients_Staging
ADD AuditID INT IDENTITY(1,1);