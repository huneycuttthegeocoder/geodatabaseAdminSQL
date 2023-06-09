/* 
Stored Procedure to look at all geodatbases and return all users
Line 8 - Input admin database for stored procedure to be created in
Line 27 - for NOT IN ('''') insert any databases to exclude; example NOT IN (''master'', ''dbname'')  
May need to change the schema from dbo to sde depending on which the geodatabase was created
*/

USE --[Admin Database]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GDBUserInfos]
AS
BEGIN
DECLARE @command nvarchar(1000)
DECLARE @userTable TABLE (
databaseName nvarchar(100),
userName nvarchar(200),
loginType nvarchar(100),
userCreatedDate datetime,
roleName nvarchar(100)
)
SET @command = 'IF ''?'' NOT IN('''') BEGIN USE ? 
   EXEC(''
SELECT
	DB_NAME() as databaseName,DBUSERS.name as userName, DBUSERS.type_desc as loginType, DBUSERS.create_date as userCreatedDate, DBROLENAME.name as roleName FROM sys.database_principals as DBUSERS
LEFT JOIN sys.database_role_members as DBROLES ON DBROLES.member_principal_id=DBUSERS.principal_id
LEFT JOIN sys.database_principals as DBROLENAME on DBROLES.role_principal_id=DBROLENAME.principal_id

WHERE
	DBUSERS.type_desc in ("WINDOWS_USER", "SQL_USER") and DBUSERS.name NOT IN ("dbo", "guest", "INFORMATION_SCHEMA", "sys")'')END'

INSERT INTO @userTable EXEC sp_MSforeachdb @command
SELECT * FROM @userTable
END
GO
