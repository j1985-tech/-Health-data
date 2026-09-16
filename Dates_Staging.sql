SELECT *
INTO dbo.Dates_Staging1
FROM vw_dates_clean;

SELECT * FROM dbo.Dates_Staging;

-- Remove leading/trailing spaces and convert empty strings to NULL
UPDATE dbo.Dates_Staging
SET 
    Date_ID        = NULLIF(LTRIM(RTRIM(Date_ID)), ''),
    Reference_ID   = NULLIF(LTRIM(RTRIM(Reference_ID)), ''),
    Event_Type     = NULLIF(LTRIM(RTRIM(Event_Type)), ''),
    Raw_Date       = NULLIF(LTRIM(RTRIM(Raw_Date)), ''),
    Fiscal_Year    = NULLIF(LTRIM(RTRIM(Fiscal_Year)), ''),
    Quarter        = NULLIF(LTRIM(RTRIM(Quarter)), ''),
    Day_of_Week    = NULLIF(LTRIM(RTRIM(Day_of_Week)), ''),
    Holiday_Flag   = NULLIF(LTRIM(RTRIM(Holiday_Flag)), ''),
    Data_Source    = NULLIF(LTRIM(RTRIM(Data_Source)), ''),
    Last_Updated   = NULLIF(LTRIM(RTRIM(Last_Updated)), '');

    -- Add a new standardized date column
ALTER TABLE dbo.Dates_Staging ADD Clean_Date DATE;

-- Convert Raw_Date into a proper DATE using multiple formats
UPDATE dbo.Dates_Staging
SET Clean_Date = COALESCE(
        TRY_CONVERT(date, Raw_Date, 101),  -- mm/dd/yyyy
        TRY_CONVERT(date, Raw_Date, 103),  -- dd/mm/yyyy
        TRY_CONVERT(date, Raw_Date, 105),  -- dd-mm-yyyy
        TRY_CONVERT(date, Raw_Date, 110),  -- mm-dd-yyyy
        TRY_CONVERT(date, Raw_Date, 111),  -- yyyy/mm/dd
        TRY_CONVERT(date, Raw_Date, 120),  -- yyyy-mm-dd
        TRY_CONVERT(date, Raw_Date, 107)   -- Month dd, yyyy
    );

IF NOT EXISTS (
    SELECT 1 
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'dates'
      AND COLUMN_NAME = 'Clean_Date'
)
BEGIN
    ALTER TABLE dates ADD Clean_Date DATE;
END;
UPDATE Dates_Staging
SET Clean_Date = COALESCE(
        TRY_CONVERT(date, Last_Updated, 101),
        TRY_CONVERT(date, Last_Updated, 103),
        TRY_CONVERT(date, Last_Updated, 105),
        TRY_CONVERT(date, Last_Updated, 110),
        TRY_CONVERT(date, Last_Updated, 111),
        TRY_CONVERT(date, Last_Updated, 120),
        TRY_CONVERT(date, Last_Updated, 107)
    );

  

  -- Add new column for cleaned dates
ALTER TABLE dbo.Dates_Staging
ADD Clean_Date DATE;

-- Populate cleaned dates using multiple possible formats
UPDATE Dates_Staging
SET Clean_Date = COALESCE(
    TRY_CONVERT(date, Raw_Date, 101), -- mm/dd/yyyy
    TRY_CONVERT(date, Raw_Date, 103), -- dd/mm/yyyy
    TRY_CONVERT(date, Raw_Date, 105), -- dd-mm-yyyy
    TRY_CONVERT(date, Raw_Date, 110), -- mm-dd-yyyy
    TRY_CONVERT(date, Raw_Date, 120), -- yyyy-mm-dd
    TRY_CONVERT(date, Raw_Date, 111), -- yyyy/mm/dd
    TRY_CONVERT(date, Raw_Date, 107)  -- Mon dd, yyyy
);


-- Add cleaned Last_Updated column
ALTER TABLE dbo.Dates_Staging ADD Clean_Last_Updated DATE;

-- Convert Last_Updated into a proper DATE
UPDATE dbo.Dates_Staging
SET Clean_Last_Updated = COALESCE(
        TRY_CONVERT(date, Last_Updated, 101),
        TRY_CONVERT(date, Last_Updated, 103),
        TRY_CONVERT(date, Last_Updated, 105),
        TRY_CONVERT(date, Last_Updated, 110),
        TRY_CONVERT(date, Last_Updated, 111),
        TRY_CONVERT(date, Last_Updated, 120),
        TRY_CONVERT(date, Last_Updated, 107)
    );

    -- Add a flag for invalid or unparseable dates
ALTER TABLE dbo.Dates_Staging ADD Invalid_Date_Flag BIT;

UPDATE dbo.Dates_Staging
SET Invalid_Date_Flag = CASE
        WHEN Raw_Date IS NULL THEN 1
        WHEN Clean_Date IS NULL THEN 1
        ELSE 0
    END;

    -- Add numeric fiscal year column
ALTER TABLE Dates_Staging ADD Fiscal_Year_Num INT;

-- Extract numeric year
UPDATE dbo.Dates_Staging
SET Fiscal_Year_Num = TRY_CONVERT(INT, REPLACE(Fiscal_Year, 'FY', ''));

-- Add numeric quarter column
ALTER TABLE Dates_Staging ADD Quarter_Num INT;

-- Convert Q1/Q2/Q3/Q4 → 1/2/3/4
UPDATE bdo.Dates_Staging
SET Quarter_Num = TRY_CONVERT(INT, REPLACE(Quarter, 'Q', ''));


-- Keep only valid weekday names
UPDATE dbo.Dates_Staging
SET Day_of_Week = CASE
        WHEN Day_of_Week IN ('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday')
            THEN Day_of_Week
        ELSE NULL
    END;

    -- Standardize holiday/weekend/business day flags
UPDATE dbo.Dates_Staging
SET Holiday_Flag = CASE
        WHEN Holiday_Flag LIKE '%Holiday%' THEN 'Holiday'
        WHEN Holiday_Flag LIKE '%Weekend%' THEN 'Weekend'
        WHEN Holiday_Flag LIKE '%Business%' THEN 'Business Day'
        ELSE NULL
    END;

    -- Replace missing event types with 'Unknown'
UPDATE dbo.Dates_Staging
SET Event_Type = ISNULL(Event_Type, 'Unknown');


UPDATE dbo.Dates_Staging
SET 
    Event_Type   = NULLIF(Event_Type, ''),
    Holiday_Flag = NULLIF(Holiday_Flag, ''),
    Data_Source  = NULLIF(Data_Source, '');

    

ALTER TABLE dbo.Dates_Staging
ADD Date_ID INT;

UPDATE dbo.Dates_Staging
SET Date_ID = CAST(Date_ID AS INT);

SELECT * FROM dbo.Dates_Staging;

UPDATE dbo.Dates_Staging
SET
    
    Clean_Date = ISNULL(Clean_Date, '1900-01-01'),
    Clean_Last_Updated = ISNULL(Clean_Last_Updated, '1900-01-01'),
    Fiscal_Year_Num = ISNULL(Fiscal_Year_Num, '1900'),
    Holiday_Flag = ISNULL(LTRIM(RTRIM(Holiday_Flag)), 'No_Flag'),
    Data_Source =ISNULL(LTRIM(RTRIM(Data_Source)), 'No_Entry'),
    Day_of_Week = ISNULL(LTRIM(RTRIM(Day_of_Week)), 'N0_Day'),
    Quarter = ISNULL(Quarter, 0)

WHERE 
    Clean_Date IS NULL
    OR Clean_Last_Updated IS NULL
    OR Fiscal_Year_Num IS NULL
    OR Holiday_Flag IS NULL
    OR Data_Source IS NULL
    OR Day_of_Week IS NULL
    OR Quarter IS NULL


    -- Change the data type of an existing column from FLOAT to INT

    ALTER TABLE dbo.Dates_Staging1
ALTER COLUMN  Date_ID INT;

SELECT * FROM vw_dates_clean;

CREATE VIEW vw_dates_clean AS
SELECT
    Date_ID,
    Reference_ID,
    Event_Type,
    Clean_Date AS Event_Date,
    Fiscal_Year_Num AS Fiscal_Year,
    Quarter,
    Day_of_Week,
    Holiday_Flag,
    Data_Source,
    Clean_Last_Updated AS Last_Updated,
    Invalid_Date_Flag
FROM dates;

SELECT * FROM vw_dates_clean;

UPDATE vw_dates_clean
SET
    
    Day_of_Week = ISNULL(Day_of_Week, 'No_Day'),
    Event_Date = ISNULL(Event_Date, '1900-01-01'),
    Last_Updated = ISNULL(Last_Updated, '1900-01-01'),
    Fiscal_Year = ISNULL(Fiscal_Year, '1900'),
    Data_Source = ISNULL(LTRIM(RTRIM(Data_Source)), 'No_Entry'),
    Holiday_Flag = ISNULL(LTRIM(RTRIM(Holiday_Flag)), 'No_Flag'),
    Quarter = ISNULL(Quarter, 0)

-- Update only rows that contain NULL values
WHERE 
    Quarter IS NULL
    OR Holiday_Flag IS NULL
    OR Data_Source IS NULL
    OR Fiscal_Year IS NULL
    OR Last_Updated IS NULL
    OR Event_Date IS NULL
    OR Day_of_Week IS NULL
    