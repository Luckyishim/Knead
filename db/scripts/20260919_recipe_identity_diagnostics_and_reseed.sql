-- db/scripts/20260919_recipe_identity_diagnostics_and_reseed.sql
-- Run these queries in SSMS after taking a full backup of the KneadDB database.
-- 1) Inspect current identity and max PK values
SELECT IDENT_CURRENT('Recipe') AS CurrentIdentity;
SELECT ISNULL(MAX(RecipeID), 0) AS MaxRecipeID FROM Recipe;
SELECT COUNT(*) AS TotalRows FROM Recipe;

-- Optional: show top rows by RecipeID for manual inspection
SELECT TOP 50 RecipeID, RecipeTitle FROM Recipe ORDER BY RecipeID DESC;

-- 2) Safe reseed: sets identity to MAX(RecipeID) so next insert uses Max+1
-- Only run this after you have a backup and while the app is not writing to the table.
DECLARE @maxId INT;
SELECT @maxId = ISNULL(MAX(RecipeID), 0) FROM Recipe;
PRINT 'MaxRecipeID = ' + CAST(@maxId AS VARCHAR(20));
IF @maxId >= 0
BEGIN
	DECLARE @cmd NVARCHAR(200) = N'DBCC CHECKIDENT (''Recipe'', RESEED, ' + CAST(@maxId AS NVARCHAR(20)) + N')';
	PRINT 'Executing: ' + @cmd;
	EXEC sp_executesql @cmd;
	PRINT 'DBCC CHECKIDENT completed.';
END
ELSE
BEGIN
	PRINT 'No reseed action taken.';
END

-- 3) Re-verify
SELECT IDENT_CURRENT('Recipe') AS CurrentIdentity, ISNULL(MAX(RecipeID),0) AS MaxRecipeID FROM Recipe;

-- End of script
