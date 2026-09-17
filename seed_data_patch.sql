-- =============================================
-- KNEAD CULINARY LMS — RICH SEED DATA PATCH
-- Run this AFTER schema.sql has been applied
-- Adds more users, cuisines, courses, recipes,
-- quiz questions, progress and forum data
-- =============================================

USE KneadDB;
GO

-- Additional Users (Members)
-- Password for all below = 'password123'
-- Hash: ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f
INSERT INTO Users (FullName, Email, PasswordHash, Role, ProfileImage) VALUES
('Priya Sharma',      'priya@knead.com',   'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', 'Member', NULL),
('Lucas Mendes',      'lucas@knead.com',   'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', 'Member', NULL),
('Aiko Tanaka',       'aiko@knead.com',    'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', 'Member', NULL),
('Fatima Al-Hassan',  'fatima@knead.com',  'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', 'Member', NULL),
('Carlos Rivera',     'carlos@knead.com',  'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', 'Member', NULL);
GO

-- Additional Cuisines
INSERT INTO Cuisine (CuisineName, Description, ImageURL) VALUES
('Mexican',   'Bold street food culture — tacos, salsas, guacamole and slow-braised birria using traditional comal and clay-pot techniques.',
 'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=600&auto=format&fit=crop&q=80'),
('Indian',    'Complex spice blending, slow-braised curries, tandoor techniques, and the vast vegetarian repertoire of the subcontinent.',
 'https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=600&auto=format&fit=crop&q=80'),
('French',    'Classical mother sauces, precise knife skills, consomme clarification, and the art of patisserie from the world culinary capital.',
 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=600&auto=format&fit=crop&q=80'),
('Middle Eastern', 'Fragrant mezze spreads, slow-roasted lamb, hummus mastery, and perfumed rice pilafs from the Levant and Persian kitchen.',
 'https://images.unsplash.com/photo-1626645738196-c2a7c87a8f58?w=600&auto=format&fit=crop&q=80'),
('Desserts and Chocolate', 'Professional tempering, ganache, sugar work, plated desserts, and French patisserie classics from eclairs to mille-feuille.',
 'https://images.unsplash.com/photo-1551024601-bec78aea704b?w=600&auto=format&fit=crop&q=80');
GO

-- Additional CourseTypes
-- Existing CuisineIDs: 1=Nepali 2=Italian 3=Asian 4=Continental 5=Baking
-- New CuisineIDs: 6=Mexican 7=Indian 8=French 9=Middle Eastern 10=Desserts
INSERT INTO CourseType (CuisineID, CourseTypeName, Description) VALUES
(2, 'Risotto and Polenta',    'Creamy Arborio risottos and slow-stirred stone-ground polenta from Northern Italy.'),
(2, 'Antipasto',              'Italian starters — bruschetta, carpaccio, and marinated vegetable plates.'),
(3, 'Stir-Fry Wok',          'High-heat wok techniques for Chinese stir-fries, fried rice, and lo mein.'),
(3, 'Sushi and Maki',        'Japanese rice preparation, knife skills for raw fish, and rolling techniques.'),
(4, 'Steak and Grill',       'Pan-seared steaks, compound butters, jus lie, and proper resting techniques.'),
(4, 'Seafood',               'Pan-searing fish fillets, court-bouillon poaching, and shellfish bisque.'),
(1, 'Pickle and Condiments', 'Traditional Nepali achaar — fermented gundruk, sesame achar, and tomato chutney.'),
(5, 'Croissant and Laminated','Butter lamination for croissants, pain au chocolat, and Danish pastry.'),
(5, 'Cake and Sponge',       'Classic genoise, chiffon, and layered celebration cakes with Swiss meringue buttercream.'),
(6, 'Tacos and Street Food', 'Corn tortilla craft, al pastor marination, and authentic street-style salsa bar.'),
(6, 'Mole and Salsas',       'Complex 30-ingredient mole negro, verde, and five essential Mexican salsas.'),
(7, 'Curry Fundamentals',    'Onion-tomato masala base, blooming spices in ghee, and curry leaf tempering.'),
(7, 'Tandoor and Breads',    'Marination for tandoori chicken, naan stretching, and paratha layering.'),
(7, 'Biryani and Rice',      'Dum-style Hyderabadi biryani, long-grain basmati perfumery, and raita pairings.'),
(8, 'Sauces and Stocks',     'Fond de veau, beurre blanc, hollandaise, and the five French mother sauces.'),
(8, 'Pastry and Tart',       'Pate brisee, creme patissiere, Paris-Brest, and tarte Tatin caramelisation.'),
(9, 'Mezze and Dips',        'Restaurant-quality hummus, mutabal, tabbouleh, and falafel masterclass.'),
(9, 'Grills and Kebabs',     'Kofta spice blending, shish tawook marinade, and live-fire charcoal technique.'),
(10,'Chocolate Work',        'Tempering dark chocolate, ganache ratios, truffle rolling, and chocolate mousse.'),
(10,'Plated Desserts',       'Restaurant-style plating — creme brulee, panna cotta, and warm fondant.'),
(10,'Ice Cream and Sorbet',  'Custard base, churning technique, and fruit sorbets without a machine.');
GO

-- RECIPES
-- Existing CourseTypeIDs: 1=Nepali Full 2=Nepali App 3=Italian Main 4=Asian Soup 5=Artisan Bread
-- New CourseTypeIDs: 6=Risotto 7=Antipasto 8=Stir-Fry 9=Sushi 10=Steak 11=Seafood
-- 12=Pickle 13=Croissant 14=Cake 15=Tacos 16=Mole 17=Curry 18=Tandoor
-- 19=Biryani 20=Sauces 21=Pastry 22=Mezze 23=Kebabs 24=Chocolate 25=Plated 26=IceCream
INSERT INTO Recipe (CourseTypeID, RecipeTitle, Description, Ingredients, Duration, Difficulty, Thumbnail, VideoURL) VALUES
(6, 'Creamy Saffron Risotto Milanese',
 'Classic Milanese risotto perfumed with saffron, finished with cold butter and aged Parmigiano.',
 '320g Arborio Rice|1.5L Warm Chicken Stock|1 White Onion finely diced|80ml Dry White Wine|Large Pinch Saffron Threads|60g Unsalted Butter cold|80g Parmigiano-Reggiano grated|2 tbsp Olive Oil|Salt and White Pepper',
 40, 'Intermediate',
 'https://images.unsplash.com/photo-1476124369491-e7addf5db371?w=600&auto=format&fit=crop&q=80',
 'https://www.youtube.com/embed/dQw4w9WgXcQ'),

(7, 'Classic Bruschetta al Pomodoro',
 'Garlic-rubbed toasted sourdough crowned with San Marzano tomatoes, basil, and extra virgin olive oil.',
 '8 Thick Sourdough Slices|4 San Marzano Tomatoes diced|2 Garlic Cloves|20 Fresh Basil Leaves|60ml Extra Virgin Olive Oil|Flaky Sea Salt|Black Pepper',
 15, 'Beginner',
 'https://images.unsplash.com/photo-1572695157366-5e585ab2b69f?w=600&auto=format&fit=crop&q=80',
 'https://www.youtube.com/embed/dQw4w9WgXcQ'),

(8, 'High-Heat Cantonese Beef Stir-Fry',
 'Tender flank steak, broccolini, and oyster sauce tossed in a scorching carbon-steel wok for authentic wok hei.',
 '400g Flank Steak thinly sliced|200g Broccolini florets|3 Garlic Cloves|1 tbsp Fresh Ginger|3 tbsp Oyster Sauce|1 tbsp Soy Sauce|1 tsp Sesame Oil|1 tbsp Cornstarch|2 tbsp Shaoxing Wine|2 tbsp Neutral Oil',
 25, 'Intermediate',
 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=600&auto=format&fit=crop&q=80',
 'https://www.youtube.com/embed/dQw4w9WgXcQ'),

(9, 'Spicy Tuna Maki and Nigiri Masterclass',
 'Foundational Japanese sushi rice seasoning, safe raw-fish handling, and precision knife cuts for maki and nigiri.',
 '400g Sushi-Grade Short Grain Rice|100ml Rice Vinegar|40g Sugar|10g Salt|300g Sushi-Grade Tuna|5 Nori Sheets|2 tbsp Sriracha|2 tbsp Japanese Mayo|Pickled Ginger|Wasabi|Soy Sauce',
 75, 'Advanced',
 'https://images.unsplash.com/photo-1617196034183-421b4040ed20?w=600&auto=format&fit=crop&q=80',
 'https://www.youtube.com/embed/dQw4w9WgXcQ'),

(10,'Perfect Dry-Aged Ribeye with Red Wine Jus',
 'Reverse-sear technique on thick-cut dry-aged ribeye, compound herb butter baste, and silky red wine jus.',
 '2x 400g Bone-In Ribeye Steaks dry-aged|4 Garlic Cloves|4 Thyme Sprigs|4 Rosemary Sprigs|100g Unsalted Butter|2 Shallots|200ml Full-Bodied Red Wine|300ml Beef Demi-Glace|Salt and Black Pepper',
 50, 'Advanced',
 'https://images.unsplash.com/photo-1544025162-d76694265947?w=600&auto=format&fit=crop&q=80',
 'https://www.youtube.com/embed/dQw4w9WgXcQ'),

(11,'Pan-Seared Sea Bass with Lemon Beurre Blanc',
 'Crispy skin sea bass fillet pan-seared to perfection, served with silky French beurre blanc and wilted spinach.',
 '4 Sea Bass Fillets|3 Shallots finely chopped|150ml Dry White Wine|50ml White Wine Vinegar|200g Cold Unsalted Butter cubed|1 Lemon|200g Baby Spinach|2 tbsp Olive Oil|Salt and White Pepper',
 35, 'Intermediate',
 'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?w=600&auto=format&fit=crop&q=80',
 'https://www.youtube.com/embed/dQw4w9WgXcQ'),

(2, 'Spiced Aloo Chana Samosa',
 'Crispy golden samosas filled with spiced potato and black chickpea, served with mint-coriander chutney.',
 '500g All-Purpose Flour|250g Ghee|600g Boiled Potatoes|200g Cooked Black Chickpeas|2 tsp Cumin Seeds|1 tsp Coriander Powder|1 tsp Garam Masala|2 Green Chillies|Fresh Coriander|Salt|Oil for frying',
 55, 'Intermediate',
 'images/momo_dish.jpg',
 'https://www.youtube.com/embed/dQw4w9WgXcQ'),

(12,'Fermented Gundruk Achar',
 'Traditional Nepali pickle using sun-dried fermented gundruk leaves, sesame seeds, and fresh chilli.',
 '200g Dried Gundruk|3 tbsp Toasted Sesame Seeds|4 Dried Red Chillies|2 Garlic Cloves|2 tbsp Mustard Oil|1 tsp Turmeric|Salt to taste|Lemon Juice',
 20, 'Beginner',
 'images/momo_dish.jpg',
 'https://www.youtube.com/embed/dQw4w9WgXcQ'),

(13,'Classic Butter Croissant Lamination Masterclass',
 'Master the 27-layer butter lamination process for perfectly honeycombed, shatteringly flaky French croissants.',
 '500g Strong Bread Flour|280ml Whole Milk|10g Fine Salt|50g Caster Sugar|7g Instant Yeast|30g Unsalted Butter soft|280g High-Fat Butter for lamination|1 Egg plus Milk for egg wash',
 480,'Advanced',
 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=600&auto=format&fit=crop&q=80',
 'https://www.youtube.com/embed/dQw4w9WgXcQ'),

(14,'Layered Vanilla Genoise Birthday Cake',
 'Classic French genoise sponge with vanilla pastry cream, macerated strawberries, and Swiss meringue buttercream rosettes.',
 '6 Eggs|200g Caster Sugar|200g Plain Flour|60g Unsalted Butter melted|1 tsp Vanilla Bean Paste|500ml Double Cream|400g Fresh Strawberries|300g Unsalted Butter for buttercream|4 Egg Whites for meringue',
 120,'Advanced',
 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=600&auto=format&fit=crop&q=80',
 'https://www.youtube.com/embed/dQw4w9WgXcQ'),

(15,'Authentic Carne Asada Street Tacos',
 'Overnight citrus-achiote marinated flank steak grilled over charcoal, piled into hand-pressed corn tortillas with salsa verde.',
 '800g Flank Steak|4 Limes|1 Orange|4 Garlic Cloves|2 tbsp Achiote Paste|1 tsp Cumin|1 tsp Smoked Paprika|Corn Tortillas|White Onion|Fresh Coriander|Salsa Verde|Lime Wedges',
 30, 'Intermediate',
 'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=600&auto=format&fit=crop&q=80',
 'https://www.youtube.com/embed/dQw4w9WgXcQ'),

(16,'Oaxacan Black Mole Sauce',
 'The king of Mexican sauces — 30+ ingredients including mulato, ancho, pasilla chillies, Mexican chocolate, and charred plantain slow-cooked for 3 hours.',
 '6 Mulato Chillies|4 Ancho Chillies|4 Pasilla Chillies|1 Ripe Plantain|1 Stale Tortilla|50g Sesame Seeds|50g Pumpkin Seeds|1 tsp Black Pepper|1 Cinnamon Stick|2 Onions|5 Garlic Cloves|3 Tomatoes|90g Mexican Dark Chocolate|1.5L Chicken Stock|Lard|Salt',
 180,'Advanced',
 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=600&auto=format&fit=crop&q=80',
 'https://www.youtube.com/embed/dQw4w9WgXcQ'),

(17,'Restaurant-Style Butter Chicken Murgh Makhani',
 'Silky tomato-cashew gravy with tandoor-charred chicken, finished with cold butter and dried fenugreek leaves.',
 '800g Chicken Thighs|200g Full-Fat Yogurt|2 tbsp Ginger-Garlic Paste|2 tsp Garam Masala|2 tsp Red Chilli Powder|400g Crushed Tomatoes|100g Raw Cashews soaked|3 tbsp Unsalted Butter|200ml Double Cream|1 tsp Kasuri Methi|1 tsp Sugar|Salt',
 60, 'Intermediate',
 'https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=600&auto=format&fit=crop&q=80',
 'https://www.youtube.com/embed/dQw4w9WgXcQ'),

(18,'Garlic Naan on Open Flame',
 'Tandoor-style hand-stretched leavened naan, blistered directly on a gas flame and brushed with garlic ghee.',
 '500g All-Purpose Flour|200ml Warm Water|100g Plain Yogurt|7g Instant Yeast|1 tsp Sugar|1 tsp Salt|2 tbsp Oil|60g Ghee|6 Garlic Cloves minced|Fresh Coriander',
 90, 'Beginner',
 'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=600&auto=format&fit=crop&q=80',
 'https://www.youtube.com/embed/dQw4w9WgXcQ'),

(19,'Hyderabadi Dum Biryani',
 'Aromatic long-grain basmati layered with slow-braised saffron mutton, sealed with dough and slow-cooked dum-style.',
 '1kg Bone-In Mutton|600g Aged Basmati Rice|300g Fried Onions|200g Full-Fat Yogurt|3 tbsp Ginger-Garlic Paste|2 tsp Biryani Masala|Large Pinch Saffron|60ml Warm Milk|80g Ghee|Fresh Mint|Fresh Coriander|4 Green Chillies|Salt',
 150,'Advanced',
 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=600&auto=format&fit=crop&q=80',
 'https://www.youtube.com/embed/dQw4w9WgXcQ'),

(20,'Classic French Onion Soup with Gruyere Croute',
 'Deeply caramelised onion consomme topped with a crusty baguette croute and bubbling melted Gruyere.',
 '1.5kg Yellow Onions thinly sliced|60g Unsalted Butter|1 tbsp Olive Oil|2 tsp Sugar|200ml Dry White Wine|1.5L Beef Stock|4 Thyme Sprigs|1 Bay Leaf|1 Baguette|200g Gruyere grated|Salt and Black Pepper',
 75, 'Intermediate',
 'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=600&auto=format&fit=crop&q=80',
 'https://www.youtube.com/embed/dQw4w9WgXcQ'),

(21,'Tarte Tatin Upside-Down Caramel Apple Tart',
 'Golden caramelised Cox apple tarte Tatin with buttery rough puff pastry, served warm with creme fraiche.',
 '1.2kg Cox Apples peeled cored halved|150g Caster Sugar|80g Unsalted Butter|1 Vanilla Pod|250g Puff Pastry all-butter|Creme Fraiche to serve',
 65, 'Intermediate',
 'https://images.unsplash.com/photo-1502741338009-cac2772e18bc?w=600&auto=format&fit=crop&q=80',
 'https://www.youtube.com/embed/dQw4w9WgXcQ'),

(22,'Silky Smooth Hummus from Scratch',
 'Overnight-soaked dried chickpeas blended with premium tahini, ice-cold water, and lemon for restaurant-grade hummus.',
 '300g Dried Chickpeas soaked overnight|1 tsp Baking Soda|150g Tahini|3 Garlic Cloves|60ml Lemon Juice|50ml Ice-Cold Water|1 tsp Cumin|Salt|Extra Virgin Olive Oil|Paprika|Fresh Parsley',
 40, 'Beginner',
 'https://images.unsplash.com/photo-1626645738196-c2a7c87a8f58?w=600&auto=format&fit=crop&q=80',
 'https://www.youtube.com/embed/dQw4w9WgXcQ'),

(23,'Lamb Kofta with Pomegranate Molasses Glaze',
 'Hand-ground spiced lamb kofta grilled over charcoal and finished with a tart pomegranate molasses glaze and herbed yogurt.',
 '700g Ground Lamb|1 Onion grated|3 Garlic Cloves|2 tsp Cumin|1 tsp Coriander|1 tsp Allspice|0.5 tsp Cinnamon|Fresh Parsley|Fresh Mint|3 tbsp Pomegranate Molasses|1 tbsp Honey|Greek Yogurt|Salt',
 45, 'Intermediate',
 'https://images.unsplash.com/photo-1544148103-0773bf10d330?w=600&auto=format&fit=crop&q=80',
 'https://www.youtube.com/embed/dQw4w9WgXcQ'),

(24,'Dark Chocolate Tempering and Truffle Making',
 'Master three-stage tempering method for couverture chocolate to produce glossy snap chocolates and hand-rolled ganache truffles.',
 '500g Valrhona 70% Dark Couverture|200ml Double Cream|30g Unsalted Butter|2 tbsp Cognac optional|200g Cocoa Powder for rolling|100g Chopped Pistachios|Chocolate Thermometer',
 90, 'Advanced',
 'https://images.unsplash.com/photo-1551024601-bec78aea704b?w=600&auto=format&fit=crop&q=80',
 'https://www.youtube.com/embed/dQw4w9WgXcQ'),

(25,'Vanilla Bean Creme Brulee',
 'Classic French custard with a silky baked centre, topped with a caramelised sugar disc shattered tableside.',
 '6 Egg Yolks|120g Caster Sugar plus extra for caramelising|600ml Double Cream|2 Vanilla Pods|Pinch Salt|Kitchen Blowtorch',
 60, 'Intermediate',
 'https://images.unsplash.com/photo-1470324161839-ce2bb6fa6bc3?w=600&auto=format&fit=crop&q=80',
 'https://www.youtube.com/embed/dQw4w9WgXcQ'),

(26,'No-Churn Mango and Cardamom Ice Cream',
 'Luscious no-churn mango ice cream perfumed with green cardamom and swirled with a salted mango caramel ribbon.',
 '4 Ripe Alphonso Mangoes pulped|400ml Double Cream|200g Sweetened Condensed Milk|1 tsp Ground Cardamom|0.5 tsp Saffron|1 Lime zest|Pinch Flaky Salt|2 tbsp Sugar for caramel swirl',
 30, 'Beginner',
 'https://images.unsplash.com/photo-1567206563064-6f60f40a2b57?w=600&auto=format&fit=crop&q=80',
 'https://www.youtube.com/embed/dQw4w9WgXcQ');
GO

-- RECIPE STEPS for key new recipes
-- Recipe 5 = Saffron Risotto (RecipeIDs 1-4 exist, new start at 5)
INSERT INTO RecipeStep (RecipeID, StepNumber, Instruction, ImageURL) VALUES
(5, 1, 'Steep saffron threads in 3 tablespoons of warm stock for 10 minutes to bloom their colour and aroma.', NULL),
(5, 2, 'In a wide heavy pan, sweat the diced onion in olive oil over medium heat until completely translucent — about 8 minutes.', NULL),
(5, 3, 'Add arborio rice and toast, stirring constantly, for 2 minutes until the edges turn slightly translucent.', NULL),
(5, 4, 'Deglaze with white wine and stir until fully absorbed. Add warm stock one ladle at a time, stirring continuously, waiting for each addition to absorb before adding the next.', NULL),
(5, 5, 'After 18 minutes the rice should be al dente. Remove from heat, stir in the saffron liquid, cold butter, and Parmigiano. Season and rest 2 minutes before serving.', NULL);

-- Recipe 17 = Butter Chicken
INSERT INTO RecipeStep (RecipeID, StepNumber, Instruction, ImageURL) VALUES
(17,1, 'Marinate chicken in yogurt, ginger-garlic paste, 1 tsp chilli powder, 1 tsp garam masala, and lemon juice for at least 4 hours or overnight.', NULL),
(17,2, 'Grill or broil chicken under high heat until charred at the edges. Set aside.', NULL),
(17,3, 'In a deep pot, cook onions in butter until golden. Add remaining ginger-garlic paste, tomatoes, and soaked cashews. Simmer 20 minutes.', NULL),
(17,4, 'Blend the tomato-cashew mixture until completely smooth. Strain through a fine sieve back into the pot.', NULL),
(17,5, 'Add the grilled chicken pieces, cream, kasuri methi, sugar, and remaining garam masala. Simmer 10 minutes. Finish with cold butter and adjust seasoning.', NULL);

-- Recipe 22 = Hummus
INSERT INTO RecipeStep (RecipeID, StepNumber, Instruction, ImageURL) VALUES
(22,1, 'Drain soaked chickpeas, add baking soda, and boil vigorously for 60-90 minutes until very soft. Reserve 200ml cooking liquid.', NULL),
(22,2, 'While still hot, blend chickpeas in a food processor for 3 minutes until a thick paste forms.', NULL),
(22,3, 'Add tahini, lemon juice, garlic, and cumin. Blend for another 3 minutes, streaming in ice-cold water until silky smooth and pale.', NULL),
(22,4, 'Season well with salt. Refrigerate for 30 minutes to firm up.', NULL),
(22,5, 'Spread in a shallow bowl with a swirl. Drizzle generously with olive oil, sprinkle paprika, and top with whole chickpeas and fresh parsley.', NULL);
GO

-- QUIZZES for new Recipes
INSERT INTO Quiz (RecipeID, QuizTitle, PassingScore) VALUES
(2,  'Tagliatelle Bolognese Technique Quiz',       70),
(3,  'Tonkotsu Ramen Knowledge Check',             70),
(5,  'Risotto Fundamentals Quiz',                  70),
(11, 'Steak Cookery and Jus Masterclass Quiz',     75),
(17, 'Butter Chicken Fundamentals Quiz',           70),
(22, 'Hummus Preparation Quiz',                    70),
(25, 'Creme Brulee Technique Quiz',                70),
(24, 'Chocolate Tempering Masterclass Quiz',       80);
GO

-- QUIZ QUESTIONS (3 per new quiz)
INSERT INTO QuizQuestion (QuizID, Question, OptionA, OptionB, OptionC, OptionD, CorrectAnswer) VALUES
-- Quiz 2: Bolognese
(2,'What is the correct Italian name for a slow-simmered meat sauce from Bologna?','Carbonara','Ragu alla Bolognese','Arrabbiata','Puttanesca','B'),
(2,'Why is whole milk added to traditional bolognese?','To add calcium','To tenderize the meat and balance tomato acidity','To make it thicker','As cream substitute','B'),
(2,'What pasta shape is classically paired with bolognese in Bologna?','Spaghetti','Penne','Tagliatelle','Rigatoni','C'),
-- Quiz 3: Tonkotsu
(3,'How long is pork bone broth typically simmered for authentic tonkotsu?','1 hour','4 hours','12 hours','24 hours','C'),
(3,'What gives tonkotsu its creamy opaque white appearance?','Added cream','Emulsified fat and collagen from rapid boiling of pork bones','Cornstarch','White miso','B'),
(3,'What is the marinated soft-boiled egg served in ramen called?','Onsen tamago','Tamagoyaki','Ajitsuke tamago','Kinoko egg','C'),
-- Quiz 4: Risotto
(4,'Why add warm stock gradually and stir constantly when making risotto?','To keep it hot','To gradually release starch from the rice for a creamy texture','To prevent burning','Cold stock ruins the color','B'),
(4,'What is the Italian term for finishing risotto off-heat with cold butter?','Flambe','Mantecatura','Brunoise','Monter au beurre','B'),
(4,'Which rice variety is preferred for Italian risotto?','Jasmine','Basmati','Arborio','Wild Rice','C'),
-- Quiz 5: Steak
(5,'What does the reverse-sear steak method involve?','Searing first then resting','Slow-roasting to near target temp then searing in a very hot pan','Boiling then searing','Marinating overnight then grilling','B'),
(5,'Why should you rest a steak after cooking?','To cool it down','To allow juices to redistribute evenly throughout the meat','To firm up the crust','To add more flavor','B'),
(5,'Which cut is the ribeye taken from?','The rear leg','The belly','The rib section between the chuck and loin','The shoulder','C'),
-- Quiz 6: Butter Chicken
(6,'What dried herb gives butter chicken its distinctive floral finish?','Dried Mint','Kasuri Methi dried fenugreek leaves','Dried Thyme','Dried Basil','B'),
(6,'Why are cashews blended into makhani sauce?','For crunch','To add natural creaminess and body without excessive cream','As a thickening starch','For color','B'),
(6,'When should cold butter be added to makhani sauce?','At the very beginning','Just before serving off the heat','While adding cream','While frying onions','B'),
-- Quiz 7: Hummus
(7,'Why is baking soda added when boiling dried chickpeas?','For flavor','To speed up softening by breaking down the outer skin','To keep color bright','To make it gluten-free','B'),
(7,'What is the key to achieving ultra-smooth pale hummus?','Using canned chickpeas','Blending while hot and using ice-cold water','Adding cornstarch','Removing all garlic','B'),
(7,'Which ingredient provides hummus its characteristic bitter nuttiness?','Cumin','Lemon Juice','Tahini sesame paste','Olive Oil','C'),
-- Quiz 8: Creme Brulee
(8,'What internal temperature should creme brulee custard reach when baked?','60C','75C to 80C','100C','45C','B'),
(8,'Why is the baking dish placed in a water bath?','To add steam flavor','To provide gentle even heat and prevent egg proteins from curdling','To keep sugar from burning','To speed up baking','B'),
(8,'What sugar type caramelises best for the brulee crust?','Brown Sugar','Icing Sugar','Fine Caster Sugar','Muscovado Sugar','C'),
-- Quiz 9: Chocolate Tempering
(9,'What are the three temperature stages for tempering dark chocolate?','50C 27C 31C','40C 20C 25C','60C 35C 40C','45C 30C 33C','A'),
(9,'What defect occurs when chocolate is stored at too warm a temperature?','Tempering','Fat bloom — grey-white streaks from separated cocoa butter','Caramelisation','Conching','B'),
(9,'What percentage of cocoa solids is typically found in couverture dark chocolate?','25-30%','50-55%','55-70% or higher','90-100%','C');
GO

-- USER PROGRESS
-- UserIDs: 1=Admin 2=Chef Anna 3=Priya 4=Lucas 5=Aiko 6=Fatima 7=Carlos
INSERT INTO UserProgress (UserID, RecipeID, IsCompleted, CompletedDate) VALUES
(2,2, 1, DATEADD(DAY,-18,GETDATE())),
(2,3, 1, DATEADD(DAY,-12,GETDATE())),
(2,5, 1, DATEADD(DAY,-8, GETDATE())),
(2,13,1, DATEADD(DAY,-3, GETDATE())),
(2,17,0, NULL),
(3,1, 1, DATEADD(DAY,-30,GETDATE())),
(3,7, 1, DATEADD(DAY,-22,GETDATE())),
(3,13,1, DATEADD(DAY,-14,GETDATE())),
(3,17,1, DATEADD(DAY,-5, GETDATE())),
(3,19,0, NULL),
(4,4, 1, DATEADD(DAY,-25,GETDATE())),
(4,11,1, DATEADD(DAY,-15,GETDATE())),
(4,9, 1, DATEADD(DAY,-7, GETDATE())),
(4,20,0, NULL),
(5,9, 1, DATEADD(DAY,-20,GETDATE())),
(5,5, 1, DATEADD(DAY,-10,GETDATE())),
(5,25,1, DATEADD(DAY,-2, GETDATE())),
(6,22,1, DATEADD(DAY,-18,GETDATE())),
(6,23,1, DATEADD(DAY,-9, GETDATE())),
(6,17,1, DATEADD(DAY,-4, GETDATE())),
(6,19,0, NULL),
(7,15,1, DATEADD(DAY,-14,GETDATE())),
(7,16,0, NULL),
(7,13,1, DATEADD(DAY,-6, GETDATE()));
GO

-- QUIZ ATTEMPTS
INSERT INTO QuizAttempt (QuizID, UserID, Score, Passed, AttemptDate) VALUES
(1,2,100,1,DATEADD(DAY,-19,GETDATE())),
(2,2,85, 1,DATEADD(DAY,-17,GETDATE())),
(3,2,67, 0,DATEADD(DAY,-11,GETDATE())),
(3,2,100,1,DATEADD(DAY,-10,GETDATE())),
(4,2,90, 1,DATEADD(DAY,-7, GETDATE())),
(1,3,67, 0,DATEADD(DAY,-29,GETDATE())),
(1,3,100,1,DATEADD(DAY,-28,GETDATE())),
(6,3,90, 1,DATEADD(DAY,-13,GETDATE())),
(7,3,80, 1,DATEADD(DAY,-4, GETDATE())),
(3,4,100,1,DATEADD(DAY,-24,GETDATE())),
(5,4,75, 1,DATEADD(DAY,-14,GETDATE())),
(3,5,100,1,DATEADD(DAY,-19,GETDATE())),
(4,5,90, 1,DATEADD(DAY,-9, GETDATE())),
(9,5,80, 1,DATEADD(DAY,-1, GETDATE())),
(7,6,100,1,DATEADD(DAY,-17,GETDATE())),
(8,6,67, 0,DATEADD(DAY,-8, GETDATE())),
(8,6,100,1,DATEADD(DAY,-7, GETDATE())),
(1,7,67, 0,DATEADD(DAY,-13,GETDATE())),
(1,7,100,1,DATEADD(DAY,-12,GETDATE())),
(6,7,90, 1,DATEADD(DAY,-5, GETDATE()));
GO

-- FAVORITE / SAVED RECIPES
INSERT INTO FavoriteRecipe (UserID, RecipeID) VALUES
(2,2),(2,5),(2,13),(2,17),
(3,1),(3,7),(3,13),(3,22),
(4,4),(4,11),(4,9),
(5,5),(5,9),(5,25),
(6,17),(6,22),(6,23),
(7,15),(7,13);
GO

-- FORUM TOPICS AND COMMENTS
INSERT INTO ForumTopic (RecipeID, UserID, TopicTitle) VALUES
(3, 3,'How do you achieve true wok hei at home without a powerful burner?'),
(5, 4,'My risotto is always too stodgy — what am I doing wrong?'),
(11,5,'Reverse sear vs traditional sear first — which gives better crust?'),
(17,6,'How to get that authentic smoky tandoori char without an actual tandoor?'),
(22,7,'How long should hummus really be blended for maximum smoothness?'),
(17,3,'Can I substitute kasuri methi with fresh fenugreek leaves?'),
(9, 4,'Best tips for rolling tight maki rolls without a bamboo mat?'),
(4, 2,'Is a 12-hour tonkotsu broth worth it vs 4-hour pressure cooker method?');

INSERT INTO ForumComment (TopicID, UserID, CommentText) VALUES
(3,1,'Get your pan screaming hot before adding oil — wait until it lightly smokes. Cook in very small batches so the temperature never drops significantly.'),
(3,2,'Preheat your wok dry on highest flame for 3 full minutes. Add oil just before ingredients — this mimics restaurant wok heat reasonably well.'),
(4,1,'Add stock ladle by ladle and never let the rice become dry before the next addition. Constant stirring and patience are the only secrets!'),
(5,2,'The reverse sear wins every time for thicker cuts. You get edge-to-edge even doneness and a superior Maillard crust because the surface is bone-dry from the oven.'),
(6,1,'A cast iron griddle pan preheated for 10 minutes on high and a small knob of ghee gives excellent char marks. Alternatively broil on the highest rack position.'),
(7,2,'Blend for a full 4-5 minutes with ice cold water. The cold water prevents the tahini from seizing and is the secret to ultra-pale fluffy hummus.'),
(8,3,'Yes — fresh fenugreek leaves work but use half the amount and add them earlier in cooking. Kasuri methi has a more concentrated toasted aroma.'),
(9,1,'Wet your hands slightly and press the rice firmly. A clean damp kitchen towel works instead of a bamboo mat — roll and squeeze in a tight cylinder.'),
(10,3,'The pressure cooker method gets you 80% of the way there in a fraction of the time. True 12-hour tonkotsu has a silkier more complex finish but both are excellent.');
GO
CREATE TABLE ForumComment (
    CommentID INT IDENTITY(1,1) PRIMARY KEY,
    TopicID INT NOT NULL,
    UserID INT NOT NULL,
    CommentText NVARCHAR(MAX) NOT NULL,
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_ForumComment_Topic FOREIGN KEY (TopicID) REFERENCES ForumTopic(TopicID),
    CONSTRAINT FK_ForumComment_User FOREIGN KEY (UserID) REFERENCES Users(UserID)
);
GO

-- FORUM TOPICS AND COMMENTS
INSERT INTO ForumTopic (RecipeID, UserID, TopicTitle) VALUES
(3, 3,'How do you achieve true wok hei at home without a powerful burner?'),
(5, 4,'My risotto is always too stodgy — what am I doing wrong?'),
(11,5,'Reverse sear vs traditional sear first — which gives better crust?'),
(17,6,'How to get that authentic smoky tandoori char without an actual tandoor?'),
(22,7,'How long should hummus really be blended for maximum smoothness?'),
(17,3,'Can I substitute kasuri methi with fresh fenugreek leaves?'),
(9, 4,'Best tips for rolling tight maki rolls without a bamboo mat?'),
(4, 2,'Is a 12-hour tonkotsu broth worth it vs 4-hour pressure cooker method?');
GO

INSERT INTO ForumComment (TopicID, UserID, CommentText) VALUES
(3,1,'Get your pan screaming hot before adding oil — wait until it lightly smokes. Cook in very small batches so the temperature never drops significantly.'),
(3,2,'Preheat your wok dry on highest flame for 3 full minutes. Add oil just before ingredients — this mimics restaurant wok heat reasonably well.'),
(4,1,'Add stock ladle by ladle and never let the rice become dry before the next addition. Constant stirring and patience are the only secrets!'),
(5,2,'The reverse sear wins every time for thicker cuts. You get edge-to-edge even doneness and a superior Maillard crust because the surface is bone-dry from the oven.'),
(6,1,'A cast iron griddle pan preheated for 10 minutes on high and a small knob of ghee gives excellent char marks. Alternatively broil on the highest rack position.'),
(7,2,'Blend for a full 4-5 minutes with ice cold water. The cold water prevents the tahini from seizing and is the secret to ultra-pale fluffy hummus.'),
(8,3,'Yes — fresh fenugreek leaves work but use half the amount and add them earlier in cooking. Kasuri methi has a more concentrated toasted aroma.'),
(9,1,'Wet your hands slightly and press the rice firmly. A clean damp kitchen towel works instead of a bamboo mat — roll and squeeze in a tight cylinder.'),
(10,3,'The pressure cooker method gets you 80% of the way there in a fraction of the time. True 12-hour tonkotsu has a silkier more complex finish but both are excellent.');
GO

SELECT RecipeID FROM Recipe WHERE RecipeID IN (3,4,5,9,11,17,22);
SELECT UserID FROM Users WHERE UserID IN (1,2,3,4,5,6,7);