/* 
Stored Procedure to look at all geodatbases and output field information
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

CREATE PROCEDURE [dbo].[GDBFields] as
BEGIN

DECLARE @command nvarchar(1000)
DECLARE @Fields TABLE (
	[database_name] [nvarchar](32),
	[table_name] [sysname],
	[owner] [nvarchar](32),
	[column_name] [nvarchar](32),
	[sde_type] [int],
	[column_size] [int],
	[decimal_digits] [int],
	[description] [nvarchar](65),
	[object_flags] [int],
	[object_id] [int]
	)

SET @command = 'IF ''?'' NOT IN('''') BEGIN USE ? 
   EXEC(''SELECT * FROM dbo.SDE_column_registry'')END'

INSERT INTO @Fields EXEC sp_MSforeachdb @command
SELECT * FROM @Fields
END
GO
