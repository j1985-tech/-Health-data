USE [Health]
GO

/****** Object:  Table [dbo].[claims]    Script Date: 8/1/2026 6:43:12 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[claims](
	[Claim_ID] [nvarchar](50) NOT NULL,
	[Patient_ID] [nvarchar](50) NOT NULL,
	[Visit_ID] [nvarchar](50) NOT NULL,
	[Hospital] [nvarchar](50) NULL,
	[Claim_Date] [date] NULL,
	[Claim_Amount] [float] NULL,
	[Insurance_Provider] [nvarchar](50) NULL,
	[Procedure] [nvarchar](50) NULL,
	[Claim_Status] [nvarchar](50) NULL,
	[ICD_Code] [nvarchar](50) NULL,
	[Approval_Code] [nvarchar](50) NULL,
 CONSTRAINT [PK_claims] PRIMARY KEY CLUSTERED 
(
	[Claim_ID] ASC,
	[Patient_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

