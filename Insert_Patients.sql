USE [Health]
GO

INSERT INTO [dbo].[patients]
           ([Patient_ID]
           ,[First_Name]
           ,[Last_Name]
           ,[Date_of_Birth]
           ,[Age]
           ,[Gender]
           ,[Phone]
           ,[Email]
           ,[City]
           ,[Zip_Code]
           ,[Patient_Status]
           ,[Insurance])
     VALUES
           (<Patient_ID, nvarchar(50),>
           ,<First_Name, nvarchar(50),>
           ,<Last_Name, nvarchar(50),>
           ,<Date_of_Birth, date,>
           ,<Age, tinyint,>
           ,<Gender, nvarchar(50),>
           ,<Phone, nvarchar(50),>
           ,<Email, nvarchar(50),>
           ,<City, nvarchar(50),>
           ,<Zip_Code, int,>
           ,<Patient_Status, nvarchar(50),>
           ,<Insurance, nvarchar(50),>)
GO

