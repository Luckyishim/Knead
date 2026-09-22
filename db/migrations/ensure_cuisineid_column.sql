-- db/migrations/ensure_cuisineid_column.sql
-- Purpose: Ensure the Cuisine table has a column named CuisineID. If a different id-like column exists
-- it will be renamed to CuisineID. If none exists, a new INT IDENTITY column named CuisineID will be added.
-- Run in SSMS against the KneadDB database after backup.

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

		DECLARE @renameSql NVARCHAR(MAX) = N'EXEC sp_rename ''' + @schemaName + '.' + @tableName + '.' + @existingCandidate + ''', ''' + @targetCol + ''', ''COLUMN'';';
		PRINT @renameSql;
		EXEC sp_executesql @renameSql;

		PRINT 'Column renamed: ' + @existingCandidate + ' -> ' + @targetCol;
		COMMIT TRANSACTION;
		RETURN;
	END

	-- 3) No id-like column found: add a new CuisineID column (IDENTITY)
	PRINT 'No id-like column found. Will add new column ' + @targetCol + ' INT IDENTITY(1,1).\n';

	DECLARE @hasPK BIT = CASE WHEN EXISTS (
		SELECT 1 FROM sys.key_constraints kc
		WHERE kc.parent_object_id = OBJECT_ID(@fullTable) AND kc.type = 'PK'
	) THEN 1 ELSE 0 END;

	DECLARE @addColSql NVARCHAR(MAX) = N'ALTER TABLE ' + @fullTable + ' ADD ' + QUOTENAME(@targetCol) + ' INT IDENTITY(1,1) NOT NULL;';
	PRINT @addColSql;
	EXEC sp_executesql @addColSql;

	IF @hasPK = 0
	BEGIN
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
