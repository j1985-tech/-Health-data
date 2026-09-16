CREATE LOGIN [mettuanil@gmail.com]
WITH PASSWORD = 'Videep@2013';
GO

USE [Health];

-- Grant Permissions

ALTER ROLE db_datareader 
ADD MEMBER [mettuanil@gmail.com];

ALTER ROLE db_datawriter 
ADD MEMBER [mettuanil@gmail.com];


          --To recreate the user
--Step1:  Remove read and write  permission
 
 REVOKE SELECT TO [mettuanil@gmail.com];

 REVOKE INSERT, UPDATE, DELETE TO [mettuanil@gmail.com];






--To recreate the user 
--Step2: remove the existing database user:

 DROP USER [mettuanil@gmail.com];

--Step3: After that Creater again using:

CREATE USER [mettuanil@gmail.com] FROM EXTERNAL PROVIDER;

--Step4: And assign permissions:


ALTER ROLE db_datareader 
ADD MEMBER [mettuanil@gmail.com];

ALTER ROLE db_datawriter 
ADD MEMBER [mettuanil@gmail.com];


-- If you want to remove permissions from mettuanil@gmail.com in SQL Server/Azure SQL, use REVOKE.

-- Remove read permission

REVOKE SELECT TO [mettuanil@gmail.com];

-- If your goal is to completely remove the user from the database, use:

DROP USER [mettuanil@gmail.com];

-- Remove all common database roles

ALTER ROLE db_datareader DROP MEMBER [mettuanil@gmail.com];
ALTER ROLE db_datawriter DROP MEMBER [mettuanil@gmail.com];

-- Remove db_datawriter

ALTER ROLE db_datawriter
DROP MEMBER [mettuanil@gmail.com];

-- Remove a role such as db_datareader

ALTER ROLE db_datareader
DROP MEMBER [mettuanil@gmail.com];

















