/* 
Stored Procedure to look at all geodatbases all tables(features)
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

CREATE PROCEDURE [dbo].[GDBTableInfos]
AS
BEGIN
DECLARE @command varchar(1000)

DECLARE @TableInfos TABLE (
table_name nvarchar(100),
registration_id int,
adds int,
deletes int,
databaseName nvarchar(100),
schemaName nvarchar(100),
viewName nvarchar(100),
defaultCount int,
baseCount int)

SELECT @command = 'IF ''?'' NOT IN('''') BEGIN USE ? 
   EXEC(''EXEC dbo.GDBDeltaInfo;
   '') END'

INSERT @TableInfos EXEC sp_MSforeachdb @command
SELECT * FROM @TableInfos
END
GO
