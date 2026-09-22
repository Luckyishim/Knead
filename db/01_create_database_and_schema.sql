-- db/01_create_database_and_schema.sql
-- Purpose: Create KneadDB database (if not exists), create schema (tables, constraints), and seed initial data.
-- Run in SSMS or sqlcmd. ALWAYS BACKUP before running against a production server.

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'KneadDB')
BEGIN
	CREATE DATABASE KneadDB;
END
GO

USE KneadDB;
GO

-- Drop tables if they exist in reverse foreign key order
IF OBJECT_ID('dbo.ForumComment', 'U') IS NOT NULL DROP TABLE dbo.ForumComment;
IF OBJECT_ID('dbo.ForumTopic', 'U') IS NOT NULL DROP TABLE dbo.ForumTopic;
IF OBJECT_ID('dbo.FavoriteRecipe', 'U') IS NOT NULL DROP TABLE dbo.FavoriteRecipe;
IF OBJECT_ID('dbo.UserProgress', 'U') IS NOT NULL DROP TABLE dbo.UserProgress;
IF OBJECT_ID('dbo.QuizAttempt', 'U') IS NOT NULL DROP TABLE dbo.QuizAttempt;
IF OBJECT_ID('dbo.QuizQuestion', 'U') IS NOT NULL DROP TABLE dbo.QuizQuestion;
IF OBJECT_ID('dbo.Quiz', 'U') IS NOT NULL DROP TABLE dbo.Quiz;
IF OBJECT_ID('dbo.RecipeStep', 'U') IS NOT NULL DROP TABLE dbo.RecipeStep;
IF OBJECT_ID('dbo.Recipe', 'U') IS NOT NULL DROP TABLE dbo.Recipe;
IF OBJECT_ID('dbo.CourseType', 'U') IS NOT NULL DROP TABLE dbo.CourseType;
IF OBJECT_ID('dbo.Cuisine', 'U') IS NOT NULL DROP TABLE dbo.Cuisine;
IF OBJECT_ID('dbo.Users', 'U') IS NOT NULL DROP TABLE dbo.Users;
GO

-- 1. Users Table
CREATE TABLE Users (
	UserID INT IDENTITY(1,1) PRIMARY KEY,
	FullName NVARCHAR(100) NOT NULL,
	Email NVARCHAR(150) UNIQUE NOT NULL,
	PasswordHash NVARCHAR(255) NOT NULL,
	Role NVARCHAR(20) NOT NULL CHECK (Role IN ('Admin','Member')),
	ProfileImage NVARCHAR(255),
	CreatedAt DATETIME DEFAULT GETDATE()
);

-- 2. Cuisine Table
CREATE TABLE Cuisine (
	CuisineID INT IDENTITY(1,1) PRIMARY KEY,
	CuisineName NVARCHAR(100) NOT NULL UNIQUE,
	Description NVARCHAR(MAX),
	ImageURL NVARCHAR(255)
);

-- 3. CourseType Table
CREATE TABLE CourseType (
	CourseTypeID INT IDENTITY(1,1) PRIMARY KEY,
	CuisineID INT NOT NULL,
	CourseTypeName NVARCHAR(100) NOT NULL,
	Description NVARCHAR(MAX),
	FOREIGN KEY (CuisineID) REFERENCES Cuisine(CuisineID) ON DELETE CASCADE
);

-- 4. Recipe Table
CREATE TABLE Recipe (
	RecipeID INT IDENTITY(1,1) PRIMARY KEY,
	CourseTypeID INT NOT NULL,
	RecipeTitle NVARCHAR(200) NOT NULL,
	Description NVARCHAR(MAX),
	Ingredients NVARCHAR(MAX),
	Duration INT,
	Difficulty NVARCHAR(20),
	Thumbnail NVARCHAR(255),
	VideoURL NVARCHAR(255),
	CreatedAt DATETIME DEFAULT GETDATE(),
	FOREIGN KEY (CourseTypeID) REFERENCES CourseType(CourseTypeID) ON DELETE CASCADE
);

-- 5. RecipeStep Table
CREATE TABLE RecipeStep (
	StepID INT IDENTITY(1,1) PRIMARY KEY,
	RecipeID INT NOT NULL,
	StepNumber INT,
	Instruction NVARCHAR(MAX),
	ImageURL NVARCHAR(255),
	FOREIGN KEY (RecipeID) REFERENCES Recipe(RecipeID) ON DELETE CASCADE
);

-- 6. Quiz Table
CREATE TABLE Quiz (
	QuizID INT IDENTITY(1,1) PRIMARY KEY,
	RecipeID INT UNIQUE NOT NULL,
	QuizTitle NVARCHAR(200),
	PassingScore INT,
	FOREIGN KEY (RecipeID) REFERENCES Recipe(RecipeID) ON DELETE CASCADE
);

-- 7. QuizQuestion Table
CREATE TABLE QuizQuestion (
	QuestionID INT IDENTITY(1,1) PRIMARY KEY,
	QuizID INT NOT NULL,
	Question NVARCHAR(MAX),
	OptionA NVARCHAR(255),
	OptionB NVARCHAR(255),
	OptionC NVARCHAR(255),
	OptionD NVARCHAR(255),
	CorrectAnswer CHAR(1),
	FOREIGN KEY (QuizID) REFERENCES Quiz(QuizID) ON DELETE CASCADE
);

-- 8. QuizAttempt Table
CREATE TABLE QuizAttempt (
	AttemptID INT IDENTITY(1,1) PRIMARY KEY,
	QuizID INT,
	UserID INT,
	Score INT,
	Passed BIT,
	AttemptDate DATETIME DEFAULT GETDATE(),
	FOREIGN KEY (QuizID) REFERENCES Quiz(QuizID) ON DELETE CASCADE,
	FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);

-- 9. UserProgress Table
CREATE TABLE UserProgress (
	ProgressID INT IDENTITY(1,1) PRIMARY KEY,
	UserID INT,
	RecipeID INT,
	IsCompleted BIT DEFAULT 0,
	CompletedDate DATETIME,
	FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
	FOREIGN KEY (RecipeID) REFERENCES Recipe(RecipeID) ON DELETE CASCADE
);

-- 10. FavoriteRecipe Table
CREATE TABLE FavoriteRecipe (
	FavoriteID INT IDENTITY(1,1) PRIMARY KEY,
	UserID INT,
	RecipeID INT,
	AddedDate DATETIME DEFAULT GETDATE(),
	FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
	FOREIGN KEY (RecipeID) REFERENCES Recipe(RecipeID) ON DELETE CASCADE
);

-- 11. ForumTopic Table
CREATE TABLE ForumTopic (
	TopicID INT IDENTITY(1,1) PRIMARY KEY,
	RecipeID INT,
	UserID INT,
	TopicTitle NVARCHAR(200),
	CreatedDate DATETIME DEFAULT GETDATE(),
	FOREIGN KEY (RecipeID) REFERENCES Recipe(RecipeID) ON DELETE SET NULL,
	FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);

-- 12. ForumComment Table
CREATE TABLE ForumComment (
	CommentID INT IDENTITY(1,1) PRIMARY KEY,
	TopicID INT,
	UserID INT,
	CommentText NVARCHAR(MAX),
	CreatedDate DATETIME DEFAULT GETDATE(),
	FOREIGN KEY (TopicID) REFERENCES ForumTopic(TopicID) ON DELETE CASCADE,
	FOREIGN KEY (UserID) REFERENCES Users(UserID)
);
GO

-- =============================================
-- SEED INITIAL DATA
-- =============================================

-- Seed Users (Passwords: SHA256 of 'admin123' and 'password123')
-- admin123 hash: 240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9
-- password123 hash: ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f
INSERT INTO Users (FullName, Email, PasswordHash, Role, ProfileImage) VALUES 
('System Admin', 'admin@knead.com', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', 'Admin', 'images/hero_cooking.jpg'),
('Chef Anna Smith', 'student@knead.com', 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', 'Member', 'images/momo_dish.jpg');

-- Seed Cuisines
INSERT INTO Cuisine (CuisineName, Description, ImageURL) VALUES
('Nepali', 'Himalayan flavours featuring iconic Momos, Dal Bhat, and fragrant spiced curries.', 'images/momo_dish.jpg'),
('Italian', 'Classic Mediterranean cuisine famous for fresh handmade pasta, risotto, and artisan breads.', 'https://images.unsplash.com/photo-1551183053-bf91a1d81141?w=600&auto=format&fit=crop&q=80'),
('Asian', 'Rich ramen broths, vibrant stir-fries, and traditional East Asian culinary techniques.', 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=600&auto=format&fit=crop&q=80'),
('Continental', 'Refined Western cooking focusing on pan-searing, pan sauces, and classic technique.', 'https://images.unsplash.com/photo-1544025162-d76694265947?w=600&auto=format&fit=crop&q=80'),
('Baking & Pastry', 'Artisan sourdough breads, flaky laminated pastries, and delicate baking methods.', 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=600&auto=format&fit=crop&q=80');

-- Seed CourseTypes
INSERT INTO CourseType (CuisineID, CourseTypeName, Description) VALUES
(1, 'Full Course', 'Complete tradition'
