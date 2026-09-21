-- =============================================
-- KNEAD CULINARY LMS DATABASE SCHEMA & SEED DATA
-- Database Name: KneadDB
-- =============================================

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
(1, 'Full Course', 'Complete traditional main course dishes of Nepal.'),
(1, 'Appetizer', 'Quick bites and traditional snacks.'),
(2, 'Main Course', 'Handcrafted pasta and iconic Italian mains.'),
(3, 'Soup & Noodle', 'Rich ramen broths and wok noodle dishes.'),
(5, 'Artisan Bread', 'Sourdough and yeast bread baking masterclasses.');

-- Seed Recipes
INSERT INTO Recipe (CourseTypeID, RecipeTitle, Description, Ingredients, Duration, Difficulty, Thumbnail, VideoURL) VALUES
(1, 'Traditional Nepali Steamed Momos', 'Master the art of folding and steaming authentic Nepali chicken momos with spicy tomato golbheda chutney.', '500g All-purpose Flour|400g Minced Chicken|1 cup Chopped Red Onion|2 tbsp Fresh Ginger Paste|2 tbsp Garlic Paste|1 tsp Momo Masala|2 tbsp Cooking Oil|Salt to taste|3 Fresh Tomatoes (for Chutney)|2 Szechuan Pepper (Timmur)', 45, 'Intermediate', 'images/momo_dish.jpg', 'https://www.youtube.com/embed/dQw4w9WgXcQ'),
(3, 'Handcrafted Tagliatelle Bolognese', 'Learn authentic slow-simmered ragù bolognese paired with handmade egg pasta dough.', '400g Pasta Flour (Tipo 00)|4 Eggs|300g Ground Beef|150g Ground Pork|1 Onion finely diced|1 Carrot finely diced|1 Celery stalk|2 tbsp Tomato Paste|1 cup Dry White Wine|1 cup Whole Milk|Parmigiano-Reggiano', 90, 'Advanced', 'https://images.unsplash.com/photo-1551183053-bf91a1d81141?w=600&auto=format&fit=crop&q=80', 'https://www.youtube.com/embed/dQw4w9WgXcQ'),
(4, 'Tonkotsu Ramen Masterclass', 'Deep rich 12-hour pork bone broth served with springy ramen noodles, chashu pork, and soft-boiled ajitsuke tamago.', '2kg Pork Marrow Bones|500g Pork Belly|1 Ginger Knob|1 Garlic Bulb|4 tbsp Soy Sauce|2 tbsp Mirin|Ramen Noodles|Green Onions|Nori Sheets|4 Eggs', 120, 'Advanced', 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=600&auto=format&fit=crop&q=80', 'https://www.youtube.com/embed/dQw4w9WgXcQ'),
(5, 'Wild Yeast Sourdough Bread', 'Natural wild yeast fermentation, dough hydration, stretch and fold technique, and Dutch oven baking.', '500g Bread Flour|350g Water (70% Hydration)|100g Active Sourdough Starter|10g Fine Sea Salt', 60, 'Intermediate', 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=600&auto=format&fit=crop&q=80', 'https://www.youtube.com/embed/dQw4w9WgXcQ');

-- Seed RecipeSteps for Recipe 1 (Momos)
INSERT INTO RecipeStep (RecipeID, StepNumber, Instruction, ImageURL) VALUES
(1, 1, 'Combine all-purpose flour with cold water and knead into a smooth, firm dough. Cover and rest for 30 minutes.', 'images/momo_dish.jpg'),
(1, 2, 'In a mixing bowl, combine minced chicken, chopped onions, ginger, garlic, momo masala, oil, and salt. Mix thoroughly until well combined.', 'images/momo_dish.jpg'),
(1, 3, 'Roll out thin small dough circles (approx 3 inches in diameter) keeping edges thinner than the center.', 'images/momo_dish.jpg'),
(1, 4, 'Place a tablespoon of filling in the center and fold into neat pleats, pinching the top firmly to seal.', 'images/momo_dish.jpg'),
(1, 5, 'Grease steamer oil container, arrange momos evenly without touching, and steam over high heat for 12-15 minutes.', 'images/momo_dish.jpg');

-- Seed Quiz for Recipe 1
INSERT INTO Quiz (RecipeID, QuizTitle, PassingScore) VALUES
(1, 'Nepali Momo Cooking & Technique Quiz', 70);

-- Seed QuizQuestions for Quiz 1
INSERT INTO QuizQuestion (QuizID, Question, OptionA, OptionB, OptionC, OptionD, CorrectAnswer) VALUES
(1, 'What is the main purpose of resting the dough after kneading?', 'To cool down the dough', 'To allow gluten relaxation for easier rolling', 'To absorb spice flavors', 'To make it rise like bread', 'B'),
(1, 'Which spice gives traditional Nepali golbheda chutney its signature numb-spicy aroma?', 'Cumin Seeds', 'Black Pepper', 'Timmur (Szechuan Pepper)', 'Turmeric', 'C'),
(1, 'How long should chicken momos typically be steamed over boiling water?', '5 minutes', '12 to 15 minutes', '30 minutes', '45 minutes', 'B');

-- Seed ForumTopics
INSERT INTO ForumTopic (RecipeID, UserID, TopicTitle) VALUES
(1, 2, 'How do you prevent momo dough wrappers from tearing while pleating?'),
(2, 2, 'Best white wine substitutes for slow-simmered bolognese sauce?');

-- Seed ForumComments
INSERT INTO ForumComment (TopicID, UserID, CommentText) VALUES
(1, 1, 'Make sure your dough rests for at least 30 minutes, and keep the edges of the circle thinner than the middle so the bottom can support the weight!'),
(2, 1, 'A splash of dry apple cider or light chicken stock with a teaspoon of lemon juice works wonders as a non-alcoholic substitute!');

-- Seed UserProgress
INSERT INTO UserProgress (UserID, RecipeID, IsCompleted, CompletedDate) VALUES
(2, 1, 1, GETDATE());

-- Seed FavoriteRecipe
INSERT INTO FavoriteRecipe (UserID, RecipeID) VALUES
(2, 1);
GO

SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME IN ('Cuisine', 'CourseType', 'Recipe', 'RecipeStep', 'Quiz', 'QuizQuestion')
ORDER BY TABLE_NAME, ORDINAL_POSITION;