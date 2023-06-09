/* 
Stored Procedure to look at geodatabase connections across multiple geodatabases
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
CREATE PROCEDURE [dbo].[GDBConnections]
AS
BEGIN
DECLARE @command varchar(1000)

DECLARE @GDBConn AS TABLE (
DatabaseName nvarchar(100),
sde_id int,
UserName nvarchar(128),
AccessName nvarchar(256),
DirectConnect varchar(1),
spid int
)
SELECT @command = 'IF ''?'' NOT IN('''') BEGIN USE ? 
   EXEC(''SELECT DB_NAME(), sde_id, owner, nodename, direct_connect, spid FROM dbo.SDE_process_information;
   '') END'

INSERT @GDBConn EXEC sp_MSforeachdb @command
SELECT * FROM @GDBConn
END
GO
