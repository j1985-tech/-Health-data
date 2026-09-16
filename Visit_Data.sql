USE [Health]
GO

/****** Object:  Table [dbo].[visits]    Script Date: 8/1/2026 6:49:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[visits](
	[Visit_ID] [nvarchar](50) NOT NULL,
	[Patient_ID] [nvarchar](50) NOT NULL,
	[Hospital_ID] [nvarchar](50) NOT NULL,
	[Admission_Date] [date] NULL,
	[Discharge_Date] [date] NULL,
	[Length_of_Stay] [tinyint] NULL,
	[Diagnosis] [nvarchar](50) NULL,
	[Department] [nvarchar](50) NULL,
	[Attending_Doctor] [nvarchar](50) NULL,
	[Visit_Cost] [float] NULL,
	[Readmission] [bit] NULL,
	[Visit_Type] [nvarchar](50) NULL
) ON [PRIMARY]
GO

