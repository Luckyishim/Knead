# KNEAD Culinary LMS - Comprehensive Project Documentation

## 1. System Overview & Architecture

**KNEAD Culinary LMS** is a full-stack **ASP.NET Web Forms** web application designed for online culinary education. It allows users to explore world cuisines, learn recipes step-by-step with interactive ingredient checklists and video tutorials, take recipe assessment quizzes, track personal learning progress, bookmark favorite recipes, and participate in community discussion forums. It also includes an **Admin Panel** for platform management.

### Key Technology Stack:
* **Frontend**: HTML5, modular Vanilla CSS (`styles/`), JavaScript (`script.js`), ASP.NET Web Forms Server Controls.
* **Backend**: ASP.NET Web Forms (C# / .NET Framework 4.8).
* **Database**: Microsoft SQL Server (MSSQL / ADO.NET `System.Data.SqlClient`).
* **Security**: SHA256 Password Hashing, Parameterized SQL Queries (SQL Injection Prevention), Role-Based Authorization (`Admin` vs `Member`).

---

## 2. Database Schema (12 Tables Breakdown)

The database `KneadDB` consists of 12 normalized tables:

### 1. `Users`
Stores user profile information and credentials.
* `UserID` (INT, Primary Key, Identity): Unique user ID.
* `FullName` (NVARCHAR(100), NOT NULL): User's full name.
* `Email` (NVARCHAR(150), Unique, NOT NULL): Account email address.
* `PasswordHash` (NVARCHAR(255), NOT NULL): Hashed user password (SHA256).
* `Role` (NVARCHAR(20), CHECK ('Admin','Member')): Account role (`Admin` or `Member`).
* `ProfileImage` (NVARCHAR(255)): URL to user profile avatar.
* `CreatedAt` (DATETIME): Account creation timestamp.

### 2. `Cuisine`
Stores culinary regional categories (e.g., Nepali, Italian, Asian, Continental, Baking).
* `CuisineID` (INT, Primary Key, Identity): Unique cuisine ID.
* `CuisineName` (NVARCHAR(100), Unique, NOT NULL): Name of cuisine.
* `Description` (NVARCHAR(MAX)): Summary of cuisine region and characteristics.
* `ImageURL` (NVARCHAR(255)): Card background image URL.

### 3. `CourseType`
Stores course classifications within a cuisine (e.g., Full Course, Appetizer, Main Course, Soup & Noodle).
* `CourseTypeID` (INT, Primary Key, Identity): Unique course type ID.
* `CuisineID` (INT, Foreign Key ➔ `Cuisine.CuisineID`): Associated cuisine.
* `CourseTypeName` (NVARCHAR(100), NOT NULL): Name of course type.
* `Description` (NVARCHAR(MAX)): Description.

### 4. `Recipe`
Stores recipe tutorials.
* `RecipeID` (INT, Primary Key, Identity): Unique recipe ID.
* `CourseTypeID` (INT, Foreign Key ➔ `CourseType.CourseTypeID`): Associated course type.
* `RecipeTitle` (NVARCHAR(200), NOT NULL): Recipe title.
* `Description` (NVARCHAR(MAX)): Detailed overview of recipe.
* `Ingredients` (NVARCHAR(MAX)): Pipe-separated list of ingredients (`Ingredient 1|Ingredient 2`).
* `Duration` (INT): Preparation time in minutes.
* `Difficulty` (NVARCHAR(20)): Level (`Beginner`, `Intermediate`, `Advanced`).
* `Thumbnail` (NVARCHAR(255)): Image URL for recipe.
* `VideoURL` (NVARCHAR(255)): Tutorial video stream URL.
* `CreatedAt` (DATETIME): Creation date.

### 5. `RecipeStep`
Stores step-by-step preparation instructions for a recipe.
* `StepID` (INT, Primary Key, Identity): Unique step ID.
* `RecipeID` (INT, Foreign Key ➔ `Recipe.RecipeID`): Associated recipe.
* `StepNumber` (INT): Sequence number (1, 2, 3...).
* `Instruction` (NVARCHAR(MAX)): Detailed instruction for this step.
* `ImageURL` (NVARCHAR(255)): Optional step illustration.

### 6. `Quiz`
Stores recipe knowledge assessment tests.
* `QuizID` (INT, Primary Key, Identity): Unique quiz ID.
* `RecipeID` (INT, Foreign Key ➔ `Recipe.RecipeID`, Unique): Associated recipe.
* `QuizTitle` (NVARCHAR(200)): Quiz header title.
* `PassingScore` (INT): Minimum percentage score required to pass (e.g., 70%).

### 7. `QuizQuestion`
Stores multiple-choice questions for a quiz.
* `QuestionID` (INT, Primary Key, Identity): Unique question ID.
* `QuizID` (INT, Foreign Key ➔ `Quiz.QuizID`): Associated quiz.
* `Question` (NVARCHAR(MAX)): Question text.
* `OptionA`, `OptionB`, `OptionC`, `OptionD` (NVARCHAR(255)): Answer options.
* `CorrectAnswer` (CHAR(1)): Correct choice key (`'A'`, `'B'`, `'C'`, or `'D'`).

### 8. `QuizAttempt`
Logs user quiz submission results.
* `AttemptID` (INT, Primary Key, Identity): Unique attempt ID.
* `QuizID` (INT, Foreign Key ➔ `Quiz.QuizID`): Associated quiz.
* `UserID` (INT, Foreign Key ➔ `Users.UserID`): User who took test.
* `Score` (INT): Score achieved (percentage).
* `Passed` (BIT): `1` if passed, `0` if failed.
* `AttemptDate` (DATETIME): Submission timestamp.

### 9. `UserProgress`
Tracks user completion state for each recipe.
* `ProgressID` (INT, Primary Key, Identity): Unique progress record ID.
* `UserID` (INT, Foreign Key ➔ `Users.UserID`): Student ID.
* `RecipeID` (INT, Foreign Key ➔ `Recipe.RecipeID`): Recipe ID.
* `IsCompleted` (BIT): `1` if completed, `0` if in-progress.
* `CompletedDate` (DATETIME): Completion timestamp.

### 10. `FavoriteRecipe`
Stores user bookmarked/saved recipes.
* `FavoriteID` (INT, Primary Key, Identity): Unique favorite ID.
* `UserID` (INT, Foreign Key ➔ `Users.UserID`): Student ID.
* `RecipeID` (INT, Foreign Key ➔ `Recipe.RecipeID`): Favorited recipe ID.
* `AddedDate` (DATETIME): Bookmark timestamp.

### 11. `ForumTopic`
Stores community discussion threads.
* `TopicID` (INT, Primary Key, Identity): Unique topic ID.
* `RecipeID` (INT, Foreign Key ➔ `Recipe.RecipeID`, Nullable): Linked recipe (or NULL for General).
* `UserID` (INT, Foreign Key ➔ `Users.UserID`): Author ID.
* `TopicTitle` (NVARCHAR(200)): Discussion title.
* `CreatedDate` (DATETIME): Creation timestamp.

### 12. `ForumComment`
Stores responses/replies under a discussion topic.
* `CommentID` (INT, Primary Key, Identity): Unique comment ID.
* `TopicID` (INT, Foreign Key ➔ `ForumTopic.TopicID`): Topic ID.
* `UserID` (INT, Foreign Key ➔ `Users.UserID`): Author ID.
* `CommentText` (NVARCHAR(MAX)): Reply body.
* `CreatedDate` (DATETIME): Reply timestamp.

---

## 3. Explanation of Project Files

| File Name | Description & Purpose |
| :--- | :--- |
| **`Knead.sln`** | Visual Studio Solution File wrapping the project for Visual Studio 2019/2022. |
| **`Knead.csproj`** | MSBuild project configuration file defining items, code-behinds, and assemblies. |
| **`Web.config`** | Application configuration holding connection strings (`KneadDB`), globalization settings, and HTTP runtime settings. |
| **`schema.sql`** | Complete SQL script containing database DDL (tables + constraints) and initial seed data. |
| **`App_Code/DbHelper.cs`** | Centralized Data Access Layer class providing parameterized SQL execution methods and SHA256 password hashing. |
| **`Site.Master` & `.cs`** | Master Page defining top navbar header, dynamic session menu buttons (Member/Admin links, Logout), and footer. |
| **`Default.aspx` & `.cs`** | Main home page displaying statistics counter and dynamic cuisine cards from database. |
| **`Home.aspx` & `.cs`** | Home alias page redirecting to `Default.aspx`. |
| **`Login.aspx` & `.cs`** | User login page authenticating against `Users` table and setting session variables. |
| **`Register.aspx` & `.cs`** | Registration form creating new member accounts with hashed passwords. |
| **`Logout.aspx` & `.cs`** | Clears user session state and redirects to Home page. |
| **`ItemList.aspx` & `.cs`** | Recipe catalogue page supporting keyword search and cuisine dropdown filtering. |
| **`RecipeDetail.aspx` & `.cs`**| Detailed recipe viewer displaying ingredients checklist, steps, video link, bookmarking toggle, progress marking, and quiz prompt. |
| **`Quizzes.aspx` & `.cs`** | List of all available recipe quizzes with passing requirements. |
| **`QuizDetail.aspx` & `.cs`**| Interactive quiz assessment runner grading user choices A/B/C/D, logging attempts, and granting course completion. |
| **`UserDashboard.aspx` & `.cs`**| Learner portal displaying profile info, key metrics, active/completed recipes, quiz scores, and saved favorites. |
| **`SavedRecipes.aspx` & `.cs`**| Displays user's bookmarked favorite recipes. |
| **`Forums.aspx` & `.cs`** | Community forum page listing topics, filtering by recipe, and supporting new thread creation. |
| **`ForumDetail.aspx` & `.cs`**| Topic discussion page listing comments and accepting new user replies. |
| **`AdminPanel.aspx` & `.cs`**| Admin control dashboard for managing Cuisines, Course Types, Recipes, Recipe Steps, Quizzes, Questions, and Users. |
| **`About.aspx` & `.cs`** | About page detailing platform mission and contact info. |
| **`styles/`** | Shared and page-specific stylesheets controlling responsive design, cards, typography, and member portal layouts. |
| **`script.js`** | Client-side interactive scripts for checkboxes, tab switching, and modals. |

---

## 4. How to Run the Application

1. **Database Setup**:
   * Open `schema.sql` in SQL Server Management Studio (SSMS) or Azure Data Studio.
   * Execute the script on your local SQL Server instance.
2. **Open in Visual Studio**:
   * Double-click `Knead.sln` or open Visual Studio ➔ **File -> Open -> Project/Solution...** ➔ Select `Knead.sln`.
3. **Run Application**:
   * In Solution Explorer, right-click `Default.aspx` ➔ **Set As Start Page**.
   * Press **F5** to start IIS Express and launch the website in your browser!
