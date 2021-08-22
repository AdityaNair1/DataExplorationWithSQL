-- DIM_Date Table --
/* Conducting data exploration to find data that is useful for creating insights and data visualizations. 
first on the list of was to ascertain the neccessary dates related to this sales database. 
This meant querying all the relevant date columns to see which is the most useful for creating visuals and develop 
insights */
Select 
	DateKey,
	FullDateAlternateKey AS Date,
	EnglishDayNameOfWeek AS Day,
	WeekNumberOfYear AS WeekNumber,
	EnglishMonthName AS Month,
	LEFT(EnglishMonthName, 3) AS MonthShort, -- To create a short month column, helps in keeping visuals compact
	MonthNumberOfYear AS MonthNumber,
	CalendarQuarter AS Quarter,
	CalendarYear AS Year
FROM [AdventureWorksDW2019].[dbo].[DimDate]	
WHERE CalendarYear >= 2019 -- Business requirement stated data from 2019 onwards.
Go

-- DIM_Customer Table --
/* As we are looking at Sales data, we need customer data that helps in creating visuals that showcase 
insights on customer purchases. Hence, we are querying the DB to get relevant customer specific data and
conducting a join with the Geography table to get location data of customers into one single table*/
Select 
	Cust.CustomerKey AS CustomerKey,
	Cust.FirstName AS FirstName,
	Cust.LastName AS LastName,
	FirstName + ' ' + LastName AS FullName,
	CASE Cust.Gender WHEN 'M' THEN 'Male' WHEN 'F' THEN 'Female' END AS Gender,
	Cust.DateFirstPurchase AS DateFirstPurchase,
	Geo.City AS CustomerCity -- Joined customer city from geography table 
FROM 
[dbo].[DimCustomer] AS Cust
LEFT JOIN [dbo].[DimGeography] AS Geo ON Geo.GeographyKey = Cust.GeographyKey
Order by CustomerKey ASC -- Ordering the table by customer key
GO

-- DIM_Product Table --
/*Extracting Product specific data from Product table and further joining it with Product category
and subcategory table so as to get the required data to perform drillthrough functions during data
visualization. Through this query, all product related information is brought into one single table*/
Select
	Prod.ProductKey,
	Prod.ProductAlternateKey AS ProductItemCode,
	Prod.EnglishProductName AS ProductName,
	SubProd.EnglishProductSubcategoryName AS SubCategory, -- From SubCategory Table
	ProdCat.EnglishProductCategoryName AS ProductCategory, -- From Category Table 
	Prod.Color AS ProductColor,
	Prod.Size AS ProductSize,
	Prod.ProductLine AS ProductLine,
	Prod.ModelName AS ProductModelName,
	Prod.EnglishDescription AS ProductDescription,
	ISNULL (Prod.Status, 'Outdated') AS ProductStatus
FROM 
[dbo].[DimProduct] AS Prod -- Joining three table to get the desired data
LEFT JOIN [dbo].[DimProductSubcategory] AS SubProd ON SubProd.ProductSubcategoryKey = Prod.ProductSubcategoryKey
LEFT JOIN [dbo].[DimProductCategory] AS ProdCat ON SubProd.ProductSubcategoryKey = ProdCat.ProductCategoryKey
Order By
Prod.ProductKey ASC
GO

-- Internet sales fact table --
/*Querying the database to fetch a fact table to use in data visualization */
Select 
	ProductKey,
	OrderDateKey,
	DueDateKey,
	ShipDateKey,
	CustomerKey,
	SalesOrderNumber,
	SalesAmount
From [dbo].[FactInternetSales]
Where LEFT (OrderDateKey, 4) >= YEAR(GETDATE()) -2 -- Only need the last two years of data
Order By OrderDateKey ASC
GO