-- Migration: Add or rename CuisineID column
-- File: db/migrations/20260919_add_cuisineid.sql
-- IMPORTANT: BACKUP your database before running this script.
-- Run in SSMS connected to the KneadDB database.

SET NOCOUNT ON;
BEGIN TRY
	BEGIN TRANSACTION;

	DECLARE @schemaName SYSNAME = 'dbo';
	DECLARE @tableName  SYSNAME = 'Cuisine';
	DECLARE @fullTable  NVARCHAR(256) = QUOTENAME(@schemaName) + '.' + QUOTENAME(@tableName);
	DECLARE @targetCol  SYSNAME = 'CuisineID';

	-- 1) If target column already exists, nothing to do
	IF EXISTS (
		SELECT 1 FROM sys.columns
		WHERE object_id = OBJECT_ID(@fullTable)
		  AND name = @targetCol
	)
	BEGIN
		PRINT 'No action: column ' + @targetCol + ' already exists on ' + @fullTable;
		COMMIT TRANSACTION;
		RETURN;
	END

	-- 2) Search for common existing id-like columns
	DECLARE @existingCandidate SYSNAME;
	SELECT TOP (1) @existingCandidate = name
	FROM sys.columns
	WHERE object_id = OBJECT_ID(@fullTable)
	  AND name COLLATE Latin1_General_CI_AS IN ('CuisineID','CuisineId','Cuisine_Id','Id','ID','cuisineid')
	ORDER BY
		CASE WHEN name IN ('CuisineID','CuisineId','Cuisine_Id') THEN 0 ELSE 1 END,
		name;

	IF @existingCandidate IS NOT NULL
	BEGIN
		PRINT 'Found existing column: ' + @existingCandidate + '. Will rename to ' + @targetCol + '.\n';

		-- List foreign keys that reference the table (informational)
		SELECT
			fk.name AS ForeignKeyName,
			OBJECT_SCHEMA_NAME(fk.parent_object_id) AS ChildSchema,
			OBJECT_NAME(fk.parent_object_id) AS ChildTable
		FROM sys.foreign_key_columns fkc
		JOIN sys.foreign_keys fk ON fkc.constraint_object_id = fk.object_id
		JOIN sys.columns rc ON rc.object_id = fk.referenced_object_id AND rc.column_id = fkc.referenced_column_id
		WHERE fk.referenced_object_id = OBJECT_ID(@fullTable)
		  AND rc.name = @existingCandidate;

		-- Perform rename (may require maintaining dependent code)
		DECLARE @renameSql NVARCHAR(MAX) = N'EXEC sp_rename ''' + @schemaName + '.' + @tableName + '.' + @existingCandidate + ''', ''' + @targetCol + ''', ''COLUMN'';';
		PRINT @renameSql;
		EXEC sp_executesql @renameSql;

		PRINT 'Column renamed: ' + @existingCandidate + ' -> ' + @targetCol;
		COMMIT TRANSACTION;
		RETURN;
	END

	-- 3) No id-like column found: add a new CuisineID column (IDENTITY)
	PRINT 'No id-like column found. Will add new column ' + @targetCol + ' INT IDENTITY(1,1).\n';

	-- Check whether table already has a PRIMARY KEY
	DECLARE @hasPK BIT = CASE WHEN EXISTS (
		SELECT 1 FROM sys.key_constraints kc
		WHERE kc.parent_object_id = OBJECT_ID(@fullTable) AND kc.type = 'PK'
	) THEN 1 ELSE 0 END;

	-- Add the new column (identity)
	DECLARE @addColSql NVARCHAR(MAX) = N'ALTER TABLE ' + @fullTable + ' ADD ' + QUOTENAME(@targetCol) + ' INT IDENTITY(1,1) NOT NULL;';
	PRINT @addColSql;
	EXEC sp_executesql @addColSql;

	IF @hasPK = 0
	BEGIN
		-- create a PK constraint on the new column
		DECLARE @pkName SYSNAME = 'PK_' + @tableName + '_' + @targetCol;
		DECLARE @addPkSql NVARCHAR(MAX) = N'ALTER TABLE ' + @fullTable + ' ADD CONSTRAINT ' + QUOTENAME(@pkName) + ' PRIMARY KEY CLUSTERED (' + QUOTENAME(@targetCol) + ');';
		PRINT @addPkSql;
		EXEC sp_executesql @addPkSql;
		PRINT 'Added new primary key on ' + @targetCol;
	END
	ELSE
	BEGIN
		PRINT 'Table already has a primary key; added ' + @targetCol + ' as a non-key identity column. You may later migrate FK relationships to use it.';
	END

	COMMIT TRANSACTION;
	PRINT 'Migration completed successfully.';
END TRY
BEGIN CATCH
	PRINT 'ERROR: ' + ERROR_MESSAGE();
	ROLLBACK TRANSACTION;
	THROW;
END CATCH;
