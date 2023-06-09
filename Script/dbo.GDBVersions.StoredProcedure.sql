/* 
Stored Procedure to look at all geodatbases and return all versions
Line 8 - Input admin database for stored procedure to be created in
Line 33 - for NOT IN ('''') insert any databases to exclude; example NOT IN (''master'', ''dbname'')  
May need to change the schema from dbo to sde depending on which the geodatabase was created
*/

USE --[Admin Database]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GDBVersions]
AS
BEGIN
DECLARE @command varchar(1000)

DECLARE @GDBVersions as TABLE(
	DatabaseName nvarchar(100),
	name nvarchar(64),
	owner nvarchar(32),
	version_id int,
	status int,
	state_id bigint,
	description nvarchar(64),
	parent_name nvarchar(64),
	parent_owner nvarchar(32),
	parent_version_id int,
	creation_time datetime
)
SELECT @command = 'IF ''?'' NOT IN('''') BEGIN USE ? 
   EXEC(''SELECT DB_NAME() as DatabaseName,* FROM dbo.SDE_versions;
   '') END'

INSERT @GDBVersions EXEC sp_MSforeachdb @command
SELECT * FROM @GDBVersions
END
GO
