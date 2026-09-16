
SELECT *
INTO dbo.Hospitals_Staging
FROM dbo.hospitals;

SELECT * FROM dbo.Hospitals_Staging;

-- -- Replace NULL VALUES
    UPDATE Hospitals_Staging
SET
    Hospital_Name = ISNULL(Hospital_Name, 'Unknown'),
    Bed_Count = ISNULL(Bed_Count, 0),
    Zip_Code = ISNULL(Zip_Code, 00000),
    City = ISNULL(LTRIM(RTRIM(City)), 'Unknown'),
    State = ISNULL(LTRIM(RTRIM(State)), 'Unknown'),
    Hospital_Type = ISNULL(LTRIM(RTRIM(Hospital_Type)), 'Unknown'),
    Rating = ISNULL(Rating, 0),
    Accreditation = ISNULL(LTRIM(RTRIM(Accreditation)), 'Unknown'),
    Phone = ISNULL(LTRIM(RTRIM(Phone)), 'Unknown')

-- Update only rows that contain NULL values
WHERE 
    Hospital_Name IS NULL
    OR Bed_Count IS NULL
    OR Zip_Code IS NULL
    OR City IS NULL
    OR State IS NULL
    OR Hospital_Type IS NULL
    OR Rating IS NULL
    OR Accreditation IS NULL
    OR Phone IS NULL

    -- Round values to 2 decimal places
SELECT ROUND(Rating, 3) AS rounded_value
FROM Hospitals_Staging;

-- Change column datatype to DECIMAL with 2 decimal places
ALTER TABLE Hospitals_Staging
ALTER COLUMN Rating DECIMAL(10,3);