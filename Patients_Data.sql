USE [Health]
GO

/****** Object:  Table [dbo].[patients]    Script Date: 8/1/2026 6:48:32 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[patients](
	[Patient_ID] [nvarchar](50) NOT NULL,
	[First_Name] [nvarchar](50) NULL,
	[Last_Name] [nvarchar](50) NULL,
	[Date_of_Birth] [date] NULL,
	[Age] [tinyint] NULL,
	[Gender] [nvarchar](50) NULL,
	[Phone] [nvarchar](50) NULL,
	[Email] [nvarchar](50) NULL,
	[City] [nvarchar](50) NULL,
	[Zip_Code] [int] NULL,
	[Patient_Status] [nvarchar](50) NULL,
	[Insurance] [nvarchar](50) NULL,
 CONSTRAINT [PK_patients] PRIMARY KEY CLUSTERED 
(
	[Patient_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

