-- Select all columns from the Customers table
SELECT *,

       -- Assign a rank to each row within each Email group
       RANK() OVER
       (
           -- Divide the data into groups based on Email
           -- Each email is ranked separately
           PARTITION BY Patient_ID

           -- Sort records within each Email group
           -- The smallest CustomerID gets Rank = 1
           ORDER BY Patient_ID
       ) AS DuplicateRank   -- Name of the new column

-- Read data from the Customers table
FROM population_health_raw;

-- USING DENSE_RANK() WINDOW FUNCTION 
SELECT *,                      -- Select all columns

DENSE_RANK() OVER
(
    PARTITION BY Patient_ID        -- Create a separate group for each Patient

    ORDER BY Patient_ID         -- Rank rows within each Patient group
) AS DenseRank                  -- Store the rank in a new column

FROM population_health_raw;                 -- Read data from population_health_raw table

-- ROW_NUMBER() for deduplication, while RANK() and DENSE_RANK() are more appropriate for reporting and analytical ranking scenarios. give me simple example to explain in interview

SELECT Patient_ID, Gender,
      RANK() OVER
       (
           ORDER BY Patient_ID DESC
       )
       AS RankNo
FROM dbo.Population_Health_Staging;

WITH ReadmissionPatients AS
(
SELECT Patient_ID,
 DENSE_RANK() OVER
(
PARTITION BY Patient_ID
ORDER BY Readmission DESC
) AS RN
FROM Visits_Staging
)

SELECT *
FROM ReadmissionPatients
WHERE RN = 1;

