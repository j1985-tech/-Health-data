USE [Health]
GO

INSERT INTO [dbo].[visits]
           ([Visit_ID]
           ,[Patient_ID]
           ,[Hospital_ID]
           ,[Admission_Date]
           ,[Discharge_Date]
           ,[Length_of_Stay]
           ,[Diagnosis]
           ,[Department]
           ,[Attending_Doctor]
           ,[Visit_Cost]
           ,[Readmission]
           ,[Visit_Type])
     VALUES
           (<Visit_ID, nvarchar(50),>
           ,<Patient_ID, nvarchar(50),>
           ,<Hospital_ID, nvarchar(50),>
           ,<Admission_Date, date,>
           ,<Discharge_Date, date,>
           ,<Length_of_Stay, tinyint,>
           ,<Diagnosis, nvarchar(50),>
           ,<Department, nvarchar(50),>
           ,<Attending_Doctor, nvarchar(50),>
           ,<Visit_Cost, float,>
           ,<Readmission, bit,>
           ,<Visit_Type, nvarchar(50),>)
GO

