/* 
Stored Procedure to look at all geodatbases and return all geodatabase objects
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
CREATE PROCEDURE [dbo].[GDBObjects]
AS
BEGIN
DECLARE @command varchar(1000)

DECLARE @GDBObjects as TABLE(
DatabaseName nvarchar(100),
Name nvarchar(226),
UUID uniqueidentifier,
PhysicalName nvarchar(226),
OBType nvarchar(226),
OBTypeID uniqueidentifier,
GDBLocation nvarchar(226),
ParentID uniqueidentifier,
ParentName nvarchar(226),
ParentType nvarchar(226)
)
SELECT @command = 'IF ''?'' NOT IN('''') BEGIN USE ? 
   EXEC(''SELECT        DB_NAME() AS DatabaseName, GDBOB.Name, GDBOB.UUID, GDBOB.PhysicalName, GDBTYPE.Name AS Type, GDBTYPE.UUID AS TypeID, GDBRELTYPES.Name as GDBLocation, GDBRELS.OriginID AS ParentID, PAROB.Name AS ParentName, 
                         PARTYPE.Name AS ParentType
FROM            dbo.GDB_ITEMS AS GDBOB INNER JOIN
                         dbo.GDB_ITEMTYPES AS GDBTYPE ON GDBOB.Type = GDBTYPE.UUID INNER JOIN
                         dbo.GDB_ITEMRELATIONSHIPS AS GDBRELS ON GDBRELS.DestID = GDBOB.UUID FULL OUTER JOIN
                         dbo.GDB_ITEMS AS PAROB ON PAROB.UUID = GDBRELS.OriginID INNER JOIN
                         dbo.GDB_ITEMTYPES AS PARTYPE ON PARTYPE.UUID = PAROB.Type INNER JOIN
						 dbo.GDB_ITEMRELATIONSHIPTYPES as GDBRELTYPES ON GDBRELS.Type = GDBRELTYPES.UUID;
   '') END'

INSERT @GDBObjects EXEC sp_MSforeachdb @command
SELECT * FROM @GDBObjects
END
GO
