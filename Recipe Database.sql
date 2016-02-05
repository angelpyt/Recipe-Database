CHECK CONSTRAINT: A recipe can only have one recipe type

CREATE FUNCTION fn_RecipeType(@RecipeID int)
RETURNS INT
AS
BEGIN
DECLARE @result INT = 0

IF EXISTS (
SELECT RecipeTypeID, count(*)
FROM RECIPE
GROUP BY RecipeTypeID
HAVING (count(*) > 1)
)

SET @result = 1
RETURN @result

END

ALTER TABLE RECIPE WITH NOCHECK
ADD CONSTRAINT ck_checkTotalRecipeType 
CHECK (dbo.fn_RecipeType(RecipeID) = 0) 

STORED PROCEDURE: POPULATE SUBSCRIPTION_TYPE TABLE

SELECT * FROM [dbo].[Subscription$]
SELECT * FROM [dbo].[SubscriptionType$]
SELECT * FROM SUBSCRIPTION_TYPE

CREATE PROCEDURE addSubscriptionType
@count int

AS

DECLARE @Name varchar(10)
DECLARE @Limit int
DECLARE @Cost money
DECLARE @Descr varchar(500)
DECLARE @ID int

WHILE @count > 0

BEGIN

SET @ID = (SELECT min(SubscriptionTypeID) FROM SubscriptionType$)
SET @Name = (SELECT SubscriptionTypeName FROM SubscriptionType$ WHERE SubscriptionTypeID = @ID)
SET @Limit = (SELECT SubscriptionTypeLimit FROM SubscriptionType$ WHERE SubscriptionTypeID = @ID)
SET @Cost = (SELECT SubscriptionCost FROM SubscriptionType$ WHERE SubscriptionTypeID = @ID)
SET @Descr = (SELECT SubscriptionTypeDescr FROM SubscriptionType$ WHERE SubscriptionTypeID = @ID)

INSERT INTO SUBSCRIPTION_TYPE(SubscriptionTypeName, SubscriptionTypeDescr, SubscriptionTypeLimit, SubscriptionCost)
VALUES  (@Name, @Descr, @Limit, @Cost)

DELETE FROM SubscriptionType$ WHERE SubscriptionTypeID = @ID

SET @count = @count-1 

END

//
EXECUTE addSubscriptionType @count = 3

STORED PROCEDURE: POPULATE RECIPE_INSTRUCTION TABLE

CREATE PROCEDURE addRecipeInstruction 
@Name VARCHAR(100),
@Sequence INT,
@Type VARCHAR(100),
@Descr VARCHAR(500)

AS

BEGIN

DECLARE @ID INT
DECLARE @TypeID INT

SET @ID = (SELECT RecipeID FROM RECIPE WHERE RecipeName = @Name)
SET @TypeID = (SELECT InstructionTypeID FROM INSTRUCTION_TYPE WHERE InstructionTypeName = @Type)

INSERT INTO RECIPE_INSTRUCTION(RecipeID, InstructionDescr, InstructionSequence, InstructionTypeID)
VALUES(@ID, @Descr, @Sequence, @TypeID)

END

//
EXECUTE addRecipeInstruction @Name = "Guacamole", @Sequence = 1, @Type = "Prep", @Descr = "Peel and mash avocado in medium serving bowl"
EXECUTE addRecipeInstruction @Name = "Guacamole", @Sequence = 2, @Type = "Prep", @Descr = "Stir in onion, garlic, tomato, lime juice, salt and pepper"
EXECUTE addRecipeInstruction @Name = "Guacamole", @Sequence = 3, @Type = "Prep", @Descr = "Season with remaining lime juice and salt and pepper to taste"
EXECUTE addRecipeInstruction @Name = "Guacamole", @Sequence = 4, @Type = "Store", @Descr = "Chill in fridge to blend flavors"

EXECUTE addRecipeInstruction @Name = "Chocolate Cake", @Sequence = 1, @Type = "Prep", @Descr = "Preheat oven to 350 degrees F (175 degrees C). Grease and flour two 9 inch cake pans."
EXECUTE addRecipeInstruction @Name = "Chocolate Cake", @Sequence = 2, @Type = "Prep", @Descr = "Use the first set of ingredients to make the cake."
EXECUTE addRecipeInstruction @Name = "Chocolate Cake", @Sequence = 3, @Type = "Cook", @Descr = "Bake for 30 to 35 minutes in the preheated oven, until a toothpick inserted comes out clean."
EXECUTE addRecipeInstruction @Name = "Chocolate Cake", @Sequence = 4, @Type = "Prep", @Descr = "To make the frosting, use the second set of ingredients. Cream butter until light and fluffy."
EXECUTE addRecipeInstruction @Name = "Chocolate Cake", @Sequence = 5, @Type = "Prep", @Descr = "Split the layers of cooled cake horizontally, cover the top of each layer with frosting.."

EXECUTE addRecipeInstruction @Name = "Chicken Noodle Soup", @Sequence = 1, @Type = "Prep", @Descr = "In 3-quart saucepan, heat oil over medium heat."
EXECUTE addRecipeInstruction @Name = "Chicken Noodle Soup", @Sequence = 2, @Type = "Cook", @Descr = "Stir in remaining ingredients. Heat to boiling; reduce heat."
EXECUTE addRecipeInstruction @Name = "Chocolate Covered Strawberries", @Sequence = 1, @Type = "Prep", @Descr = "Line cookie sheet with waxed paper"
EXECUTE addRecipeInstruction @Name = "Chocolate Covered Strawberries", @Sequence = 2, @Type = "Cook", @Descr = "In 1-quart saucepan, melt chocolate chips."
EXECUTE addRecipeInstruction @Name = "Chocolate Covered Strawberries", @Sequence = 3, @Type = "Cook", @Descr = "Dip lower half of each strawberry into chocolate mixture; allow excess to drip back into saucepan."

EXECUTE addRecipeInstruction @Name = "Pico De Gallo", @Sequence = 1, @Type = "Prep", @Descr = "In a medium bowl, combine tomato, onion, jalapeno pepper (to taste,) cilantro and green onion. "
EXECUTE addRecipeInstruction @Name = "Pico De Gallo", @Sequence = 2, @Type = "Prep", @Descr = "Season with garlic powder, salt and pepper."
EXECUTE addRecipeInstruction @Name = "Pico De Gallo", @Sequence = 3, @Type = "Prep", @Descr = "Stir until evenly distributed. "
EXECUTE addRecipeInstruction @Name = "Pico De Gallo", @Sequence = 4, @Type = "Store", @Descr = "Refrigerate for 30 minutes."

EXECUTE addRecipeInstruction @Name = "Teriyaki Chicken", @Sequence = 1, @Type = "Prep", @Descr = "In a small saucepan over low heat, combine the cornstarch, cold water, sugar, soy sauce, vinegar."
EXECUTE addRecipeInstruction @Name = "Teriyaki Chicken", @Sequence = 2, @Type = "Prep", @Descr = "Preheat oven to 425 degrees F (220 degrees C)."
EXECUTE addRecipeInstruction @Name = "Teriyaki Chicken", @Sequence = 3, @Type = "Prep", @Descr = "Place chicken pieces in a lightly greased 9x13 inch baking dish. Brush chicken with the sauce."
EXECUTE addRecipeInstruction @Name = "Teriyaki Chicken", @Sequence = 4, @Type = "Cook", @Descr = "Bake in the preheated oven for 30 minutes. Turn pieces over."

EXECUTE addRecipeInstruction @Name = "Mexican Grilled Corn", @Sequence = 1, @Type = "Prep", @Descr = "Prepare a grill, with heat medium-high and rack about."
EXECUTE addRecipeInstruction @Name = "Mexican Grilled Corn", @Sequence = 2, @Type = "Prep", @Descr = "Mix together mayonnaise, lime juice, chili powder and some salt and pepper in a small bowl."
EXECUTE addRecipeInstruction @Name = "Mashed Potatoes", @Sequence = 1, @Type = "Cook", @Descr = "Bring a pot of salted water to a boil. Add potatoes and cook until tender but still firm, about 15 minutes; drain."
EXECUTE addRecipeInstruction @Name = "Mashed Potatoes", @Sequence = 2, @Type = "Cook", @Descr = "In a small saucepan heat butter and milk over low heat until butter is melted."
EXECUTE addRecipeInstruction @Name = "Stuffed Strawberries", @Sequence = 1, @Type = "Prep", @Descr = "Cut the tops off of the strawberries and stand upright on the cut side."

EXECUTE addRecipeInstruction @Name = "Stuffed Strawberries", @Sequence = 2, @Type = "Prep", @Descr = "Beat together the cream cheese, sugar, and liqueur until smooth in a mixer or a food processor."
EXECUTE addRecipeInstruction @Name = "Hashbrowns", @Sequence = 1, @Type = "Cook", @Descr = "Shred potatoes into a large bowl filled with cold water. Stir until water is cloudy, drain."
EXECUTE addRecipeInstruction @Name = "Hashbrowns", @Sequence = 2, @Type = "Cook", @Descr = "Heat clarified butter in a large non-stick pan over medium heat. Sprinkle shredded potatoes."
EXECUTE addRecipeInstruction @Name = "Hashbrowns", @Sequence = 3, @Type = "Cook", @Descr = "Cook potatoes until a brown crust forms on the bottom, about 5 minutes. Continue to cook."

CHECK CONSTRAINT: A user can only have one subscription
CREATE FUNCTION fn_SubscriptionType(@SubscriptionID int)
RETURNS INT
AS
BEGIN
DECLARE @result INT = 0
IF EXISTS(
SELECT SubscriptionTypeID, count(*)
FROM SUBSCRIPTION 
GROUP BY SubscriptionTypeID
HAVING (count(*) > 1)
)

SET @result = 1
RETURN @result
END

ALTER TABLE SUBSCRIPTION WITH NOCHECK
ADD CONSTRAINT ck_CheckTotalSubscriptionType
CHECK (dbo.fn_SubscriptionType(SubscriptionID) = 0)

STORED PROCEDURE: POPULATE INGREDIENT TABLE
Select * From ingredient$
Select * From Ingredient
Select * From Ingredient_type

CREATE PROCEDURE addIngredient 
@count INT

AS

DECLARE @Name VARCHAR(100)
DECLARE @Descr VARCHAR(500)
DECLARE @TypeID INT

WHILE @count > 0

BEGIN

SET @Name = (SELECT TOP 1(IngredientName) FROM Ingredient$)
SET @Descr = (SELECT TOP 1(IngredientDescr) FROM Ingredient$)
SET @TypeID = (SELECT IngredientTypeID FROM INGREDIENT_TYPE WHERE (SELECT TOP 1(IngredientType) FROM Ingredient$) = IngredientTypeName)

INSERT INTO INGREDIENT(IngredientName, IngredientDescr, IngredientTypeID)
VALUES (@Name, @Descr, @TypeID)

DELETE FROM Ingredient$ WHERE IngredientName = @Name

SET @count = @count-1

END

//
EXECUTE addIngredient @count = 27

STORED PROCEDURE: POPULATE RECIPE TABLE

CREATE PROCEDURE addRecipe
@RecipeType VARCHAR(20),
@Cuisine VARCHAR(20)

AS

DECLARE @Name VARCHAR(50)
DECLARE @Descr VARCHAR(200)
DECLARE @TypeID INT
DECLARE @CuisineID INT

BEGIN

SET @Name = (SELECT TOP 1(RecipeName) FROM Recipe$)
SET @Descr = (SELECT TOP 1(RecipeDescr) FROM Recipe$)
SET @TypeID = (SELECT RecipeTypeID FROM RECIPE_TYPE WHERE RecipeTypeName = @RecipeType)
SET @CuisineID = (SELECT RecipeCuisineID FROM RECIPE_CUISINE WHERE RecipeCuisineName = @Cuisine)

INSERT INTO RECIPE(RecipeName, RecipeTypeID, RecipeCuisineID, RecipeDescr)
VALUES (@Name, @TypeID, @CuisineID, @Descr)

DELETE FROM Recipe$ WHERE RecipeName = @Name

END

//
EXECUTE addRecipe @RecipeType = "Appetizer", @Cuisine = "Mexican"
EXECUTE addRecipe @RecipeType = "Dessert", @Cuisine = "Western"
EXECUTE addRecipe @RecipeType = "Main Course", @Cuisine = "Western"
EXECUTE addRecipe @RecipeType = "Appetizer", @Cuisine = "Mexican"
EXECUTE addRecipe @RecipeType = "Dessert", @Cuisine = "Western"
EXECUTE addRecipe @RecipeType = "Main Course", @Cuisine = "Asian"
EXECUTE addRecipe @RecipeType = "Appetizer", @Cuisine = "Mexican"
EXECUTE addRecipe @RecipeType = "Appetizer", @Cuisine = "Western"
EXECUTE addRecipe @RecipeType = "Dessert", @Cuisine = "Western"
EXECUTE addRecipe @RecipeType = "Appetizer", @Cuisine = "Western"


CHECK CONSTRAINT: A user can't access more than their number of recipes in the same year
CREATE FUNCTION fn_NumRecipesAccessed(@SubscriptionID  int)
RETURNS INT
AS
BEGIN
DECLARE @result INT = 0
DECLARE @Limit INT = (SELECT SubscriptionTypeLimit FROM SUBSCRIPTION_TYPE)
IF EXISTS( 
SELECT S.SubscriptionID, COUNT(RecipeAccessID)  
FROM SUBSCRIPTION_TYPE ST
	JOIN SUBSCRIPTION S ON ST.SubscriptionTypeID = S.SubscriptionTypeID
	JOIN RECIPE_ACCESS RA ON S.SubscriptionID = RA.SubscriptionID
WHERE DATEDIFF(YEAR, S.BeginDate, GetDate()) < 1
GROUP BY S.SubscriptionID
HAVING COUNT(RecipeAccessID) > @Limit
)
SET @result = 1
RETURN @result
END
ALTER TABLE RECIPE_ACCESS WITH NOCHECK
ADD CONSTRAINT ck_RecipeAccessed
CHECK (dbo.fn_NumRecipesAccessed(SubscriptionID) = 0)
STORED PROCEDURE: POPULATE SUBSCRIPTION TABLE
CREATE PROCEDURE addSubscription
@Fname varchar(20),
@Lname varchar(20),
@SubName varchar(20),
@Begin datetime,
@End datetime

AS

BEGIN

DECLARE @CustID int
DECLARE @SubTypeID int

SET @CustID = (SELECT CustomerID FROM CUSTOMER WHERE CustomerFname = @Fname AND CustomerLname = @Lname)
SET @SubTypeID = (SELECT SubscriptionTypeID FROM SUBSCRIPTION_TYPE WHERE SubscriptionTypeName = @SubName)

INSERT INTO SUBSCRIPTION(SubscriptionTypeID, CustomerID, BeginDate, EndDate)
VALUES (@SubTypeID, @CustID, @Begin, @End)

END

//
EXECUTE addSubscription @Fname = "Annette", @Lname = "Mugica", @Subname = "Free", @Begin = "12-13-2000", @End = "12-13-2013"
EXECUTE addSubscription @Fname = "Nettie", @Lname = "Ori", @Subname = "Premium", @Begin = "03-13-2000", @End = "3-13-2014"
EXECUTE addSubscription @Fname = "Leroy", @Lname = "Heaney", @Subname = "Standard", @Begin = "04-26-2001", @End = NULL
EXECUTE addSubscription @Fname = "Debbi", @Lname = "Hasson", @Subname = "Free", @Begin = "12-13-2002", @End = "12-13-2011"
EXECUTE addSubscription @Fname = "Jarred", @Lname = "Marentis", @Subname = "Standard", @Begin = "07-04-2003", @End = NULL
EXECUTE addSubscription @Fname = "Malisa", @Lname = "Ansbro", @Subname = "Standard", @Begin = "04-30-2003", @End = NULL
EXECUTE addSubscription @Fname = "Julieann", @Lname = "Tippy", @Subname = "Premium", @Begin = "05-19-2004", @End = "5-19-2006"
EXECUTE addSubscription @Fname = "Earlie", @Lname = "Eveleth", @Subname = "Standard", @Begin = "12-13-2009", @End = NULL
EXECUTE addSubscription @Fname = "Delena", @Lname = "Dakins", @Subname = "Free", @Begin = "12-06-2011", @End = NULL
EXECUTE addSubscription @Fname = "Delmer", @Lname = "Grunow", @Subname = "Premium", @Begin = "01-18-2014", @End = "01-18-2015"

STORED PROCEDURE: POPULATE RECIPE_INGREDIENT TABLE

CREATE PROCEDURE addRecipeIngredients

@RecipeName varchar(50), 
@MeasurementName varchar(20), 
@IngredientName varchar(30), 
@Quantity INT

AS

DECLARE @RecipeID int
DECLARE @MeasurementID int
DECLARE @IngredientID int

BEGIN
SET @RecipeID = (SELECT RecipeID FROM RECIPE WHERE RecipeName= @RecipeName)
SET @MeasurementID = (SELECT MeasurementID FROM MEASUREMENT WHERE MeasurementName = @MeasurementName)
SET @IngredientID = (SELECT IngredientID FROM INGREDIENT WHERE IngredientName = @IngredientName)

INSERT INTO RECIPE_INGREDIENT(RecipeID,  MeasurementID, IngredientID,Quantity)
VALUES(@RecipeID,@MeasurementID,@IngredientID,@Quantity)

END

//
EXECUTE addRecipeIngredients @RecipeName = "Guacamole", @MeasurementName = "Unit", @IngredientName = "Avacado", @Quantity = "2"
EXECUTE addRecipeIngredients @RecipeName = "Guacamole", @MeasurementName = "Unit", @IngredientName = "Garlic", @Quantity = "1"
EXECUTE addRecipeIngredients @RecipeName = "Guacamole", @MeasurementName = "Unit", @IngredientName = "Onion", @Quantity = "1"
EXECUTE addRecipeIngredients @RecipeName = "Guacamole", @MeasurementName = "Unit", @IngredientName = "Tomato", @Quantity = "1"
EXECUTE addRecipeIngredients @RecipeName = "Guacamole", @MeasurementName = "Unit", @IngredientName = "Lime", @Quantity = "1"
EXECUTE addRecipeIngredients @RecipeName = "Guacamole", @MeasurementName = "Pinch", @IngredientName = "Salt", @Quantity = "1"
EXECUTE addRecipeIngredients @RecipeName = "Guacamole", @MeasurementName = "Pinch", @IngredientName = "Pepper", @Quantity = "1"
EXECUTE addRecipeIngredients @RecipeName = "Chocolate Cake", @MeasurementName = "Cup", @IngredientName = "Sugar", @Quantity = "7"
EXECUTE addRecipeIngredients @RecipeName = "Chocolate Cake", @MeasurementName = "Cup", @IngredientName = "Flour", @Quantity = "1"
EXECUTE addRecipeIngredients @RecipeName = "Chocolate Cake", @MeasurementName = "Cup", @IngredientName = "Cocoa Powder", @Quantity = "3"
EXECUTE addRecipeIngredients @RecipeName = "Chocolate Cake", @MeasurementName = "Teaspoon", @IngredientName = "Baking Soda", @Quantity = "4"
EXECUTE addRecipeIngredients @RecipeName = "Chocolate Cake", @MeasurementName = "Teaspoon", @IngredientName = "Baking Powder", @Quantity = "2"
EXECUTE addRecipeIngredients @RecipeName = "Chocolate Cake", @MeasurementName = "Teaspoon", @IngredientName = "Salt", @Quantity = "1"
EXECUTE addRecipeIngredients @RecipeName = "Chocolate Cake", @MeasurementName = "Unit", @IngredientName = "Eggs", @Quantity = "4"
EXECUTE addRecipeIngredients @RecipeName = "Chocolate Cake", @MeasurementName = "Cup", @IngredientName = "Milk", @Quantity = "2"
EXECUTE addRecipeIngredients @RecipeName = "Chocolate Cake", @MeasurementName = "Tablespoon", @IngredientName = "Butter", @Quantity = "6"
EXECUTE addRecipeIngredients @RecipeName = "Chocolate Cake", @MeasurementName = "Cup", @IngredientName = "Vegetable Oil", @Quantity = "1"
EXECUTE addRecipeIngredients @RecipeName = "Pico de Gallo", @MeasurementName = "Unit", @IngredientName = "Tomato", @Quantity = "1"
EXECUTE addRecipeIngredients @RecipeName = "Pico de Gallo", @MeasurementName = "Unit", @IngredientName = "Onion", @Quantity = "1"
EXECUTE addRecipeIngredients @RecipeName = "Pico de Gallo", @MeasurementName = "Unit", @IngredientName = "Lime", @Quantity = "1"
EXECUTE addRecipeIngredients @RecipeName = "Pico de Gallo", @MeasurementName = "Pinch", @IngredientName = "Salt", @Quantity = "1"
EXECUTE addRecipeIngredients @RecipeName = "Pico de Gallo", @MeasurementName = "Pinch", @IngredientName = "Pepper", @Quantity = "1"
EXECUTE addRecipeIngredients @RecipeName = "Chocolate Covered Strawberries", @MeasurementName = "Unit", @IngredientName = "Strawberries", @Quantity = "10"
EXECUTE addRecipeIngredients @RecipeName = "Chocolate Covered Strawberries", @MeasurementName = "Cup", @IngredientName = "Chocolate Chips", @Quantity = "1"
EXECUTE addRecipeIngredients @RecipeName = "Mashed Potatoes", @MeasurementName = "Pound", @IngredientName = "Potatoes", @Quantity = "5"
EXECUTE addRecipeIngredients @RecipeName = "Mashed Potatoes", @MeasurementName = "Teaspoon", @IngredientName = "Butter", @Quantity = "6"
EXECUTE addRecipeIngredients @RecipeName = "Mashed Potatoes", @MeasurementName = "Cup", @IngredientName = "Milk", @Quantity = "1"
EXECUTE addRecipeIngredients @RecipeName = "Stuffed Strawberries", @MeasurementName = "Unit", @IngredientName = "Strawberries", @Quantity = "20"
EXECUTE addRecipeIngredients @RecipeName = "Stuffed Strawberries", @MeasurementName = "Cup", @IngredientName = "Whipped Cream", @Quantity = "2"
EXECUTE addRecipeIngredients @RecipeName = "Hashbrowns", @MeasurementName = "Unit", @IngredientName = "Potatoes", @Quantity = "1"
EXECUTE addRecipeIngredients @RecipeName = "Hashbrowns", @MeasurementName = "Tablespoon", @IngredientName = "Butter", @Quantity = "4"
EXECUTE addRecipeIngredients @RecipeName = "Teriyaki Chicken", @MeasurementName = "Pound", @IngredientName = "Chicken", @Quantity = "2"
EXECUTE addRecipeIngredients @RecipeName = "Teriyaki Chicken", @MeasurementName = "Cup", @IngredientName = "Sugar", @Quantity = "1"
EXECUTE addRecipeIngredients @RecipeName = "Mexican Grilled Corn", @MeasurementName = "Unit", @IngredientName = "Corn", @Quantity = "4"
EXECUTE addRecipeIngredients @RecipeName = "Mexican Grilled Corn", @MeasurementName = "Tablespoon", @IngredientName = "Butter", @Quantity = "4"
EXECUTE addRecipeIngredients @RecipeName = "Mexican Grilled Corn", @MeasurementName = "Pinch", @IngredientName = "Salt", @Quantity = "4"
EXECUTE addRecipeIngredients @RecipeName = "Chicken Noodle Soup", @MeasurementName = "Unit", @IngredientName = "Celery", @Quantity = "4"
EXECUTE addRecipeIngredients @RecipeName = "Chicken Noodle Soup", @MeasurementName = "Cup", @IngredientName = "Chicken Broth", @Quantity = "4"
EXECUTE addRecipeIngredients @RecipeName = "Chicken Noodle Soup", @MeasurementName = "Cup", @IngredientName = "Chicken", @Quantity = "2"
EXECUTE addRecipeIngredients @RecipeName = "Chicken Noodle Soup", @MeasurementName = "Cup", @IngredientName = "Noodles", @Quantity = "3"
EXECUTE addRecipeIngredients @RecipeName = "Chicken Noodle Soup", @MeasurementName = "Cup", @IngredientName = "Carrots", @Quantity = "2"
EXECUTE addRecipeIngredients @RecipeName = "Chicken Noodle Soup", @MeasurementName = "Pinch", @IngredientName = "Salt", @Quantity = "4"
EXECUTE addRecipeIngredients @RecipeName = "Chicken Noodle Soup", @MeasurementName = "Pinch", @IngredientName = "Pepper", @Quantity = "4"


CHECK CONSTRAINT: A customer can only comment/review/rate if they have on a recipe if they have access to it
CREATE FUNCTION fn_ReviewAccess()
RETURNS INT
AS 

BEGIN 
DECLARE @result int = 0

IF EXISTS(
SELECT RA.RecipeAccessID, COUNT(*)
FROM RECIPE_ACCESS RA
	JOIN RECIPE R ON RA.RecipeID = R.RecipeID
	JOIN REVIEW RE ON R.RecipeID = RE.RecipeID
GROUP BY RA.RecipeAccessID
HAVING COUNT(*) < 1
)

SET @result = 1
RETURN @result

END

ALTER TABLE REVIEW
ADD CONSTRAINT ck_ReviewAccess
CHECK (dbo.fn_ReviewAccess() = 0)

STORED PROCEDURE: POPULATE CUSTOMER AND CUSTOMER_ADDRESS TABLE

SELECT TOP 15* INTO CUSTOMER_TRASH
FROM CUSTOMER_BUILD.[dbo].[CUSTOMERTRASH]
SELECT * FROM CUSTOMER_Address
SELECT * FROM CUSTOMER_TRASH
CREATE PROCEDURE addCustomer
@Password varchar(50),
@Birthdate datetime
AS
DECLARE @ID int
DECLARE @Street varchar (35)
DECLARE @City varchar(35)
DECLARE @State varchar (40)
DECLARE @Fname varchar(50)
DECLARE @Lname varchar (50)
DECLARE @Email varchar(50)
DECLARE @AddressID int
BEGIN
SET @ID = (SELECT Min(CustomerID) FROM CUSTOMER_TRASH )
SET @Street =(SELECT CustomerAddress FROM CUSTOMER_TRASH  WHERE CustomerID = @ID)
SET @City =(SELECT CustomerCity FROM CUSTOMER_TRASH  WHERE CustomerID = @ID)
SET @State =(SELECT CustomerState FROM CUSTOMER_TRASH  WHERE CustomerID = @ID)
SET @Fname = (SELECT CustomerFname FROM CUSTOMER_TRASH WHERE CustomerID = @ID)
SET @Lname =(SELECT CustomerLname FROM CUSTOMER_TRASH  WHERE CustomerID = @ID)
SET @Email =(SELECT Email FROM CUSTOMER_TRASH  WHERE CustomerID = @ID)
INSERT INTO CUSTOMER_ADDRESS (Street, City, State)
VALUES  (@Street, @City, @State)
SET @AddressID = (SELECT Scope_Identity())
INSERT INTO CUSTOMER(CustomerFname, CustomerLname, CustomerPassword, CustomerBirthdate, CustomerEmail, CustomerAddressID )
VALUES (@Fname, @Lname, @Password, @Birthdate, @Email, @AddressID)
DELETE FROM CUSTOMER_TRASH WHERE CustomerID = @ID
END
//
EXECUTE addCustomer @Password = "HelloWorld!123", @Birthdate = "12-15-1989"
EXECUTE addCustomer @Password = "fuzzypenguin", @Birthdate = "09-27-1965"
EXECUTE addCustomer @Password = "iloveinfo", @Birthdate = "01-03-1995"
EXECUTE addCustomer @Password = "password", @Birthdate = "10-18-1900"
EXECUTE addCustomer @Password = "youCantguessThis", @Birthdate = "04-20-1979"
EXECUTE addCustomer @Password = "wisdomTeeth", @Birthdate = "05-15-1969"
EXECUTE addCustomer @Password = "databases!", @Birthdate = "06-31-1998"
EXECUTE addCustomer @Password = "Yo", @Birthdate = "08-09-1986"
EXECUTE addCustomer @Password = "chocoYo", @Birthdate = "02-14-1994"
EXECUTE addCustomer @Password = "GregHEYYYYYYYY", @Birthdate = "12-03-2015"
EXECUTE addCustomer @Password = "boom!2015", @Birthdate = "8/26/1987"

STORED PROCEDURE: POPULATE REVIEW TABLE

SELECT * FROM REVIEW         
SELECT * FROM RECIPE
SELECT * FROM RECIPE_ACCESS

CREATE PROCEDURE addReview
@Date DATETIME,
@Comment VARCHAR(500),
@RatingID INT,
@RecipeID INT

AS

BEGIN

INSERT INTO REVIEW(ReviewDate, Comment, RatingID, RecipeID)
VALUES(@Date, @Comment, @RatingID, @RecipeID)

END

//
EXECUTE addReview @Date = "12-16-2000", @Comment = "Perfect for my 3 year old's birthday! Shes a 100% chocolate addict that thinks of chocolate all the damn time!", @RatingID = 5, @RecipeID = 2
EXECUTE addReview @Date = "2-28-2000", @Comment = "Made this for my family, very tasty", @RatingID = "5", @RecipeID = "3"
EXECUTE addReview @Date = "5-9-2001", @Comment = "Made this for my son's pre-game party and it was the main attraction. Everyone asked where I got it from!", @RatingID = "5", @RecipeID = "1"
EXECUTE addReview @Date = "4-7-2002", @Comment = "Sweet yet healthy, fruit and chocolate together is the best!", @RatingID = "2", @RecipeID = "5"
EXECUTE addReview @Date = "10-25-2003", @Comment = "Was to chocolatey for my dog, he almost died", @RatingID = "3", @RecipeID = "2"
EXECUTE addReview @Date = "1-25-2004", @Comment = "Super tasty, almost as good as Panda Express!", @RatingID = "4", @RecipeID = "6"
EXECUTE addReview @Date = "2-3-2004", @Comment = "Perfect for a rainy day and sick day from work", @RatingID = "5", @RecipeID = "3"
EXECUTE addReview @Date = "4-29-2004", @Comment = "Strawberry and chocolate does NOT work together, never again!", @RatingID = "1", @RecipeID = "5"
EXECUTE addReview @Date = "5-4-2004", @Comment = "Tasted horrible, waste of potatoes.", @RatingID = "2", @RecipeID = "8"
EXECUTE addReview @Date = "5-17-2004", @Comment = "Almost as good as Mickey D's!", @RatingID = "4", @RecipeID = "10"
EXECUTE addReview @Date = "8-16-2005", @Comment = "Like salsa but not like salsa, ya feel?", @RatingID = "3", @RecipeID = "4"















































CREATE DATABASE AND TABLES

CREATE DATABASE AUT2015_RECIPE
CREATE TABLE CUSTOMER_ADDRESS (
CustomerAddressID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
Street VARCHAR(100) NOT NULL,
City VARCHAR(100) NOT NULL,
State VARCHAR(100) NOT NULL)
CREATE TABLE CUSTOMER (
CustomerID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
CustomerFname VARCHAR(100) NOT NULL,
CustomerLname VARCHAR(100) NOT NULL,
CustomerPassword VARCHAR(100) NOT NULL,
CustomerBirthDate DATE NOT NULL,
CustomerEmail VARCHAR(100) NOT NULL,
CustomerAddressID INT FOREIGN KEY REFERENCES CUSTOMER_ADDRESS(CustomerAddressID) NOT NULL
)
CREATE TABLE SUBSCRIPTION_TYPE (
SubscriptionTypeID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
SubscriptionTypeName VARCHAR(100) NOT NULL,
SubscriptionTypeDescr VARCHAR(500),
SubscriptionTypeLimit INT NOT NULL,
SubscriptionCost MONEY NOT NULL
)
CREATE TABLE SUBSCRIPTION (
SubscriptionID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
SubscriptionTypeID INT FOREIGN KEY REFERENCES SUBSCRIPTION_TYPE(SubscriptionTypeID),
CustomerID INT FOREIGN KEY REFERENCES CUSTOMER(CustomerID),
BeginDate DATETIME NOT NULL,
EndDate DATETIME
)
CREATE TABLE RATING (
RatingID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
RatingName VARCHAR(100) NOT NULL,
RatingDescr VARCHAR(500)
)
CREATE TABLE INGREDIENT_TYPE (
IngredientTypeID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
IngredientTypeName VARCHAR(100) NOT NULL,
IngredientTypeDescr VARCHAR(500)
)
CREATE TABLE INGREDIENT (
IngredientID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
IngredientName VARCHAR(100) NOT NULL,
IngredientDescr VARCHAR(500),
IngredientTypeID INT FOREIGN KEY REFERENCES INGREDIENT_TYPE(IngredientTypeID) NOT NULL
)
CREATE TABLE MEASUREMENT (
MeasurementID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
MeasurementName VARCHAR(100) NOT NULL,
MeasurementAbbrev VARCHAR(100)
)
CREATE TABLE RECIPE_TYPE (
RecipeTypeID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
RecipeTypeName VARCHAR(100) NOT NULL,
RecipeTypeDescr VARCHAR(500)
)
CREATE TABLE RECIPE_CUISINE (
RecipeCuisineID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
RecipeCuisineName VARCHAR(100) NOT NULL,
RecipeCuisineDescr VARCHAR(100)
)
CREATE TABLE RECIPE (
RecipeID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
RecipeName VARCHAR(100) NOT NULL,
RecipeTypeID INT FOREIGN KEY REFERENCES RECIPE_TYPE (RecipeTypeID),
RecipeCuisineID INT FOREIGN KEY REFERENCES RECIPE_CUISINE (RecipeCuisineID),
RecipeDescr VARCHAR(500)
)
CREATE TABLE REVIEW (
ReviewID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
ReviewDate DATE NOT NULL,
Comment VARCHAR(500) NOT NULL,
RatingID INT FOREIGN KEY REFERENCES RATING(RatingID) NOT NULL,
RecipeID INT FOREIGN KEY REFERENCES RECIPE(RecipeID) NOT NULL,
)
CREATE TABLE RECIPE_INGREDIENT (
RecipeIngredientID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
RecipeID INT FOREIGN KEY REFERENCES RECIPE(RecipeID) NOT NULL,
IngredientID INT FOREIGN KEY REFERENCES INGREDIENT(IngredientID) NOT NULL,
MeasurementID INT FOREIGN KEY REFERENCES MEASUREMENT(MeasurementID) NOT NULL,
Quantity INT NOT NULL
)
CREATE TABLE INSTRUCTION_TYPE (
InstructionTypeID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
InstructionTypeName VARCHAR (100) NOT NULL
)
CREATE TABLE RECIPE_INSTRUCTION (
RecipeInstructionID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
RecipeID INT FOREIGN KEY REFERENCES RECIPE(RecipeID) NOT NULL,
InstructionDescr VARCHAR(1000) NOT NULL,
InstructionSequence INT NOT NULL,
InstructionTypeID INT FOREIGN KEY REFERENCES INSTRUCTION_TYPE(InstructionTypeID) NOT NULL
)
CREATE TABLE RECIPE_ACCESS (
RecipeAccessID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
RecipeAcessDate DATETIME NOT NULL,
RecipeID INT FOREIGN KEY REFERENCES RECIPE(RecipeID) NOT NULL,
SubscriptionID INT FOREIGN KEY REFERENCES SUBSCRIPTION(SubscriptionID) NOT NULL
)

/* POPULATE INGREDIENT_TYPE TABLE */
select * from Ingredient$
select * from INGREDIENT_TYPE
Select * from IngredientType$

SELECT DISTINCT IngredientType INTO IngredientType$
FROM Ingredient$

CREATE PROCEDURE addIngredientType
@count int

AS
DECLARE @Name varchar(20)
DECLARE @Descr varchar(100) = NULL

WHILE @count > 0

BEGIN

SET @Name = (SELECT TOP 1(IngredientType) FROM IngredientType$)

INSERT INTO INGREDIENT_TYPE(IngredientTypeName, IngredientTypeDescr)
VALUES  (@Name, @Descr)
DELETE FROM IngredientType$ WHERE IngredientType = @Name

SET @count = @count-1
END

//
EXECUTE addIngredientType @count = 10

/* POPULATE INSTRUCTION_TYPE TABLE */
CREATE PROCEDURE addInstructionType
@Name VARCHAR(20)

AS 

BEGIN

INSERT INTO INSTRUCTION_TYPE(InstructionTypeName) 
VALUES(@Name)

END

//
EXECUTE addInstructionType @Name = "Prep"
EXECUTE addInstructionType @Name = "Cook"
EXECUTE addInstructionType @Name = "Store"

/* POPULATE RECIPE_TYPE TABLE  */
select * from [dbo].[Recipe_Type$]

CREATE PROCEDURE addRecipeType
@count INT
AS 

DECLARE @Name VARCHAR(100)
DECLARE @Descr VARCHAR(500)

WHILE @count > 0

BEGIN
SET @Name = (SELECT TOP 1(RecipeTypeName) FROM Recipe_Type$)
SET @Descr = (SELECT TOP 1(RecipeTypeDescr) FROM Recipe_Type$)

INSERT INTO RECIPE_TYPE(RecipeTypeName, RecipeTypeDescr)

VALUES(@Name, @Descr)
DELETE FROM Recipe_Type$ WHERE RecipeTypeName = @Name

SET @count = @count-1
END

//
EXECUTE addRecipeType @count = 3

/* POPULATE MEASUREMENT TABLE */
CREATE PROCEDURE addMeasurement

@count INT
AS
DECLARE @Name VARCHAR(50)
DECLARE @Abbrev VARCHAR(10)

WHILE @count > 0 

BEGIN

SET @Name = (SELECT TOP 1(MeasurementName) FROM Measurement$)
SET @Abbrev =  (SELECT TOP 1(MeasurementAbbrev) FROM Measurement$)

INSERT INTO MEASUREMENT(MeasurementName, MeasurementAbbrev)
VALUES(@Name, @Abbrev)

DELETE FROM Measurement$ WHERE MeasurementName=@Name
SET @count = @count-1
END

//
EXECUTE addMeasurement @count=10

/* POPULATE RECIPE_CUISINE TABLE */

SELECT* FROM [dbo].[Cuisine$]
SELECT* FROM [dbo].[RECIPE_CUISINE]
CREATE PROCEDURE addRecipeCuisine
@count int
AS
DECLARE @Name VARCHAR(100)
DECLARE @Descr VARCHAR(500)
WHILE @count > 0
BEGIN
SET @Name =(SELECT TOP 1(CuisineName) FROM Cuisine$)
SET @Descr =(SELECT TOP 1(CuisineDescr) FROM Cuisine$)
INSERT INTO RECIPE_CUISINE(RecipeCuisineName, RecipeCuisineDescr)
VALUES(@Name, @Descr)
DELETE FROM Cuisine$ WHERE CuisineName =@Name
SET @count = @count-1
END

//
EXECUTE addRecipeCuisine @count = 3

/* POPULATE RATING TABLE */
CREATE PROCEDURE addRating

@count INT
AS
DECLARE @Name VARCHAR(50)
DECLARE @Descr VARCHAR(100)

WHILE @count > 0 

BEGIN

SET @Name = (SELECT TOP 1(RatingName) FROM Rating$)
SET @Descr =  (SELECT TOP 1(RatingDescr) FROM Rating$)

INSERT INTO RATING(RatingName, RatingDescr)
VALUES(@Name, @Descr)

DELETE FROM Rating$ WHERE RatingName=@Name
SET @count = @count-1
END

//
EXECUTE addRating @count = 5

/* POPULATE RECIPE_ACCESS TABLE */ 

SELECT * FROM RECIPE
SELECT * FROM RECIPE_ACCESS
SELECT * FROM SUBSCRIPTION

CREATE PROCEDURE addRecipeAccess
@Date DATETIME,
@RecipeID INT,
@SubID INT

AS

BEGIN

INSERT INTO RECIPE_ACCESS(RecipeAcessDate, RecipeID, SubscriptionID)
VALUES (@Date, @RecipeID, @SubID)

END

//
EXECUTE addRecipeAccess @Date = "12-15-2000", @RecipeID = 2, @SubID = 1
EXECUTE addRecipeAccess @Date = "2-27-2000", @RecipeID = 3, @SubID = 1
EXECUTE addRecipeAccess @Date = "5-8-2001", @RecipeID = 1, @SubID = 3
EXECUTE addRecipeAccess @Date = "4-6-2002", @RecipeID = 5, @SubID = 2
EXECUTE addRecipeAccess @Date = "10-24-2003", @RecipeID = 2, @SubID = 2
EXECUTE addRecipeAccess @Date = "1-24-2004", @RecipeID = 6, @SubID = 4
EXECUTE addRecipeAccess @Date = "2-2-2004", @RecipeID = 3, @SubID = 3
EXECUTE addRecipeAccess @Date = "4-28-2004", @RecipeID = 5, @SubID = 6
EXECUTE addRecipeAccess @Date = "5-3-2004", @RecipeID = 8, @SubID = 3
EXECUTE addRecipeAccess @Date = "5-16-2004", @RecipeID = 10, @SubID = 4
EXECUTE addRecipeAccess @Date = "8-15-2005", @RecipeID = 4, @SubID = 1
EXECUTE addRecipeAccess @Date = "9-27-2005", @RecipeID = 3, @SubID = 3
EXECUTE addRecipeAccess @Date = "10-7-2006", @RecipeID = 9, @SubID = 7
EXECUTE addRecipeAccess @Date = "10-19-2006", @RecipeID = 6, @SubID = 7
EXECUTE addRecipeAccess @Date = "6-13-2009", @RecipeID = 3, @SubID = 5
EXECUTE addRecipeAccess @Date = "12-25-2009", @RecipeID = 7, @SubID = 8
EXECUTE addRecipeAccess @Date = "12-31-2011", @RecipeID = 8, @SubID = 9
EXECUTE addRecipeAccess @Date = "5-18-2014", @RecipeID = 5, @SubID = 10





