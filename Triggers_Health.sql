

   
    








CREATE TRIGGER trg_Patients_Validate_DOB1
ON Patients_Staging
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Check whether Date_of_Birth is in the future
    IF EXISTS
    (
        SELECT 1
        FROM inserted
        WHERE Date_of_Birth > CAST(GETDATE() AS DATE)
    )
    BEGIN
        RAISERROR
        (
            'Invalid patient record: Date of Birth cannot be in the future.',
            16,
            1
        );

        -- Cancel the INSERT or UPDATE
        ROLLBACK TRANSACTION;

        RETURN;
    END
END;


INSERT INTO Patients_Staging(Patient_ID, Date_of_Birth)
VALUES ('PAT01000', '2030-01-01');
SELECT * FROM Patients_Staging;
INSERT INTO Patients_Staging
(
    Patient_ID,
    First_Name,
    Last_Name,
    Date_of_Birth
)
VALUES
(
    'PAT00001',
    'John',
    'Smith',
    '2030-01-01'
);
INSERT INTO Patients_Staging
(
    Patient_ID,
    First_Name,
    Last_Name,
    Date_of_Birth
)
VALUES
(
    'PH1002',
    'John',
    'Smith',
    '1990-01-01'
);

SELECT * FROM Patients_Staging
WHERE Patient_ID = 'PH1002';


UPDATE Patients_Staging
SET
    Phone = '225-555-1004',
    Email = 'john2@gmail.com',
    City = 'Zachary',
    Gender = 'Male',
    Age = 28,
    Zip_Code = 70761,
    Patient_Status = 'Inctive',
    Insurance = 'BlueCross', 
    Invalid_DOB_Flag =1
WHERE Patient_ID = 'PH1002';


--you want to remove the duplicate trigger
EXEC sp_helptext 'trg_Patients_Validate_DOB1';


--Check whether your DOB trigger exists
SELECT name
FROM sys.triggers
WHERE name LIKE '%DOB%';