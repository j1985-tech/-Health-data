USE [Health]
GO

INSERT INTO [dbo].[claims]
           ([Claim_ID]
           ,[Patient_ID]
           ,[Visit_ID]
           ,[Hospital]
           ,[Claim_Date]
           ,[Claim_Amount]
           ,[Insurance_Provider]
           ,[Procedure]
           ,[Claim_Status]
           ,[ICD_Code]
           ,[Approval_Code])
     VALUES
           (<Claim_ID, nvarchar(50),>
           ,<Patient_ID, nvarchar(50),>
           ,<Visit_ID, nvarchar(50),>
           ,<Hospital, nvarchar(50),>
           ,<Claim_Date, date,>
           ,<Claim_Amount, float,>
           ,<Insurance_Provider, nvarchar(50),>
           ,<Procedure, nvarchar(50),>
           ,<Claim_Status, nvarchar(50),>
           ,<ICD_Code, nvarchar(50),>
           ,<Approval_Code, nvarchar(50),>)
GO

