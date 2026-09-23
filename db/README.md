KneadDB — database scripts
==========================

This directory contains SQL scripts used to create and maintain the KneadDB database for the Knead culinary LMS web application.

Files and purpose
-----------------
- 01_create_database_and_schema.sql
  - Primary schema + seed script. Creates the KneadDB database (if missing), all tables, constraints, and initial seed rows. Run this to create a fresh local database.

Recommended setup (for a new environment)
---------------------------------------------
1. Backup any existing database you care about.
2. Run db/01_create_database_and_schema.sql in SSMS or via sqlcmd. This creates KneadDB and seeds initial data.

Safety and cautions
-------------------
- ALWAYS take a backup before running migration or reseed scripts on a non-development database.
- The reseed script should be run only when the application is stopped or write activity is paused.
- These scripts are intended for local development or controlled maintenance. Review the SQL before execution in production.

Run the scripts on another PC (quick guide)
------------------------------------------
Prerequisites on target machine:
- Microsoft SQL Server (Express) or LocalDB installed (LocalDB is sufficient for development).
- SQL Server Management Studio (SSMS) or sqlcmd utility available.
- Visual Studio (to open the solution) if you want to run and debug the web app.

Steps:
1. Clone the repo:
   git clone https://github.com/Luckyishim/Knead.git
   cd "Knead_Assignment"

2. Update connection string (if needed):
   - Open Web.config and verify the `connectionStrings` entry named `KneadDB`.
   - For LocalDB (default), connectionString is usually:
	 Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=KneadDB;Integrated Security=True;TrustServerCertificate=True;
   - If using a different SQL Server instance, update Data Source, User ID and Password accordingly.

3. Create the database and schema:
   Option A: Use SSMS
	 - Open SSMS, connect to your SQL Server instance (or (localdb)\MSSQLLocalDB).
	 - Open db/01_create_database_and_schema.sql and execute the script.

   Option B: Use sqlcmd (PowerShell)
	 - Example for LocalDB:
	   sqlcmd -S "(localdb)\MSSQLLocalDB" -i "db/01_create_database_and_schema.sql"
	 - Example for a named instance (replace SERVERNAME and instance):
	   sqlcmd -S "SERVERNAME\INSTANCE" -i "db/01_create_database_and_schema.sql"

4. Run the web app
   - Open Knead.sln in Visual Studio and press F5 (IIS Express) or Start Debugging.
   - The application uses the connection string in Web.config to connect to KneadDB.

Notes
-----
- If you prefer, you can copy the SQL files to a central deployment pipeline or wrap them in a small PowerShell script to run in sequence.
- If you need a non-LocalDB SQL Server, create the database on that server and update Web.config accordingly.

Need help?
----------
If you want, I can:
- Add a numbered migration file for the reseed script (e.g., db/scripts/02_reseed_recipe_identity.sql).
- Create a PowerShell helper that runs the scripts in order against a given connection string.
- Produce a short checklist (one-shot commands) you can copy/paste to set up a new machine.

