

-- Update Claims_Staging to clean Product_Name andClaim_Status columns
UPDATE Claims_Staging
SET 
    -- Clean Product_Name column
    Procedure_Name = 
        CASE 
            -- If Product_Name is NULL OR empty OR contains only spaces
            WHEN Procedure_Name IS NULL 
                 OR LTRIM(RTRIM(Procedure_Name)) = '' 
            THEN 'Unknown'   -- Replace with default value
            
            -- Otherwise keep the trimmed original value
            ELSE LTRIM(RTRIM(Procedure_Name))  
        END,

          -- Clean Claim_Status column
    Claim_Status = 
        CASE 
            -- If Claim_Status is NULL OR empty OR contains only spaces
            WHEN Claim_Status IS NULL 
                 OR LTRIM(RTRIM(Claim_Status)) = '' 
            THEN 'No_Status'   -- Replace with default value
            
            -- Otherwise keep the trimmed original value
            ELSE LTRIM(RTRIM(Claim_Status))  
        END,

        -- Clean Hospital column
       Hospital =  
        CASE 
            -- If Claim_Status is NULL OR empty OR contains only spaces
            WHEN Claim_Status IS NULL 
                 OR LTRIM(RTRIM(Hospital)) = '' 
            THEN 'UnKnown'   -- Replace with default value
            
            -- Otherwise keep the trimmed original value
            ELSE LTRIM(RTRIM(Hospital))  
        END,

          -- Clean  Insurance_Provider column
         Insurance_Provider =  
        CASE 
            -- If Claim_Status is NULL OR empty OR contains only spaces
            WHEN Claim_Status IS NULL 
                 OR LTRIM(RTRIM(Hospital)) = '' 
            THEN 'UnKnown'   -- Replace with default value
            
            -- Otherwise keep the trimmed original value
            ELSE LTRIM(RTRIM(Hospital))  
        END,

         -- Clean  ICD_Code column
         ICD_Code =  
        CASE 
            -- If ICD_Code is NULL OR empty OR contains only spaces
            WHEN ICD_Code IS NULL 
                 OR LTRIM(RTRIM(ICD_Code)) = '' 
            THEN 'No_Code'   -- Replace with default value
            
            -- Otherwise keep the trimmed original value
            ELSE LTRIM(RTRIM(ICD_Code))  
        END,

          -- Clean  Approval_Code column
Approval_Code =  
CASE 
    -- If Approval_Code is NULL OR empty OR contains only spaces
    WHEN Claim_Status IS NULL 
         OR LTRIM(RTRIM(Approval_Code)) = '' 
    THEN 'UnKnown'   -- Replace with default value
    
    -- Otherwise keep the trimmed original value
    ELSE LTRIM(RTRIM(Approval_Code))  
END


       -- Remove duplicate Claim_ID rows from Claims_Staging table

WITH CTE_Duplicates AS
(
    SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY Claim_ID 
            ORDER BY Claim_ID
        ) AS Row_Num
    FROM Claims_Staging
)

DELETE FROM CTE_Duplicates
WHERE Row_Num > 1; 

-- Remove duplicate Patient_ID rows from Claims_Staging table

WITH CTE_Duplicates AS
(
    SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY Patient_ID 
            ORDER BY Patient_ID
        ) AS Row_Num
    FROM Claims_Staging
)

DELETE FROM CTE_Duplicates
WHERE Row_Num > 1;
