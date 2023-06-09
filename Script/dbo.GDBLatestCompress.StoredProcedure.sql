/* 
Stored Procedure to look at all geodatabases and return database compress information
Line 8 - Input admin database for stored procedure to be created in
Line 32 - for NOT IN ('''') insert any databases to exclude; example NOT IN (''master'', ''dbname'')  
May need to change the schema from dbo to sde depending on which the geodatabase was created
*/

USE --[Admin Database]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GDBLatestCompress] as
BEGIN

DECLARE @command nvarchar(1000)
DECLARE @Compress TABLE (
	[database_name] [nvarchar](32),
	[compress_id] [int],
	[sde_id] [int],
	[server_id] [int],
	[direct_connect] [varchar](1),
	[compress_start] [datetime],
	[start_state_count] [int],
	[compress_end] [datetime],
	[end_state_count] [int],
	[compress_status] [varchar](20),
	[Delta] [int]
	)
SET @command = 'IF ''?'' NOT IN('''') BEGIN USE ? 
   EXEC(''IF EXISTS (SELECT table_name FROM INFORMATION_SCHEMA.TABLES WHERE table_schema IN ("SDE", "DBO") AND table_name = "SDE_compress_log")
BEGIN
	select DB_NAME() as DatabaseName, *, (start_state_count - end_state_count) as Delta from SDE_compress_log
	WHERE compress_end = (select MAX(compress_end) from SDE_compress_log)
END'')END'

INSERT INTO @Compress EXEC sp_MSforeachdb @command
SELECT * FROM @Compress
END
GO
