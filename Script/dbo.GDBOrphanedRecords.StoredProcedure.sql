/* 
Stored Procedure to look at all geodatbases and return any orphaned states
Line 8 - Input admin database for stored procedure to be created in
Line 28 - for NOT IN ('''') insert any databases to exclude; example NOT IN (''master'', ''dbname'')  
May need to change the schema from dbo to sde depending on which the geodatabase was created
*/

USE --[Admin Database]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GDBOrphanedRecords]
AS
BEGIN
DECLARE @command nvarchar(1000)
DECLARE @OpRecTable TABLE (
databaseName nvarchar(100),
sde_id int,
state_id bigint,
autolock char(1),
lock_type char(1),
lock_time datetime
)
SET @command = 'IF ''?'' NOT IN('''') BEGIN USE ? 
   EXEC(''
SELECT DB_NAME() as databaseName, * FROM dbo.SDE_state_locks 
WHERE sde_id NOT IN (SELECT sde_id FROM dbo.sde_process_information)'')END'

INSERT INTO @OpRecTable EXEC sp_MSforeachdb @command
SELECT * FROM @OpRecTable
END
GO
