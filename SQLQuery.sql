USE Adventureworks2019

SELECT  
OH.[SalesOrderID], [OrderDate], [DueDate],[ShipDate], [Status]
, [OnlineOrderFlag],[CustomerID], [SalesPersonID],
ter. [TerritoryID], meth.[ShipMethodID], [CreditCardID]
, [SubTotal], [TaxAmt], [Freight], [TotalDue],
[SalesOrderDetailID], [OrderQty], OD.[ProductID]
, [UnitPrice], [LineTotal]
, pp.[Name] AS ProductName , sub.[Name] AS SubCategoryName, cat.[Name] AS CategoryName
, meth.[Name] AS ShipMethodName ,ter.[Name] AS TerritoryName, ter.[Group] AS TerritoryGroup

FROM 
    [sales].[SalesOrderHeader] AS OH 
JOIN
    [sales].[SalesOrderDetail] AS OD ON OH.[SalesOrderID]=OD.[SalesOrderID]
JOIN 
    [Production].[Product] AS pp ON pp.[ProductID]=OD.[ProductID] 
JOIN 
	[Production].[ProductSubcategory] AS sub on sub.[ProductSubcategoryID]=pp.[ProductSubcategoryID]
JOIN 
	[Production].[ProductCategory] AS cat ON cat.[ProductCategoryID]=sub.[ProductCategoryID]
JOIN 
    [Purchasing].[ShipMethod] meth ON meth.[ShipMethodID]=OH.[ShipMethodID]
JOIN 
	[Sales].[SalesTerritory] AS ter ON OH.[TerritoryID]=ter.[TerritoryID];

 
---Questions & Answers:

---1)Top 10 Sold Products:

SELECT TOP 10
    P.[Name] AS ProductName,
    SUM(OD.LineTotal) AS TotalRevenue
FROM
    [Sales].[SalesOrderDetail] AS OD
JOIN
    [Production].[Product] AS P ON OD.[ProductID] = P.[ProductID]
GROUP BY
    P.[Name]
ORDER BY
    TotalRevenue DESC;

---2)Top 10 Customers making orders?
----
SELECT TOP 10 
    C.[FirstName] + ' ' +C.[LastName] AS CustomerName,
    COUNT(OH.[SalesOrderID]) AS OrderCount
FROM 
    [Sales].[SalesOrderHeader] AS OH
JOIN 
    [Person].[Person] AS C ON OH.[CustomerID] = C.[BusinessEntityID]
GROUP BY 
    C.[FirstName], C.[LastName]
ORDER BY 
    OrderCount DESC;

---3)What is the average cost of shipping?

SELECT 
    AVG(Freight) AS AverageShippingCost
FROM 
    [Sales].[SalesOrderHeader];

---4)Total Sales by each Territory name:

SELECT 
    T.[Name] AS TerritoryName, 
	SUM(OH.[TotalDue]) AS TotalSales
FROM 
    [Sales].[SalesOrderHeader] AS OH
JOIN 
    [Sales].[Customer] AS C ON OH.[CustomerID] = C.[CustomerID]
JOIN 
    Sales.SalesPerson AS SP ON OH.[SalesPersonID] = SP.[BusinessEntityID]
JOIN 
    Sales.SalesTerritory AS T ON SP.[TerritoryID] = T.[TerritoryID]
GROUP BY 
    T.[Name]
ORDER BY 
    TotalSales DESC;


---5)Top 10 employees by salary:
SELECT TOP 10
    P.[FirstName] + ' ' +P.[LastName] AS EmployeeName , JobTitle , Rate AS EmployeeSalary 
FROM 
    [HumanResources].[EmployeePayHistory] AS EP
JOIN 
    [HumanResources].[Employee] AS E ON EP.[BusinessEntityID] = E.[BusinessEntityID]
JOIN 
     [Person].[Person] AS P ON EP.[BusinessEntityID] = P.[BusinessEntityID]
ORDER BY 
    EmployeeSalary Desc; 

---6)What is the total number of products in each category?

SELECT 
    C.[Name] AS CategoryName,
    COUNT(P.ProductID) AS TotalProducts
FROM 
    [Production].[Product] AS P
JOIN 
    [Production].[ProductSubcategory] AS SC ON P.[ProductSubcategoryID] = SC.[ProductSubcategoryID]
JOIN 
    [Production].[ProductCategory] AS C ON SC.[ProductCategoryID] = C.[ProductCategoryID]
GROUP BY 
    C.[Name]
ORDER BY 
   TotalProducts desc;

---7)What is the total number of orders sold by each year?

SELECT 
    YEAR(OH.OrderDate) AS OrderYear,
    COUNT(OH.SalesOrderID) AS TotalOrders
FROM 
    [Sales].[SalesOrderHeader] AS OH
GROUP BY 
    YEAR(OH.OrderDate)
ORDER BY 
    OrderYear;

---8) What is the total quantity sold from each subcategory?

SELECT 
    SC.[Name] AS SubcategoryName,
    SUM(OD.OrderQty) AS TotalQuantitySold
FROM 
    [Sales].[SalesOrderDetail] AS OD
JOIN 
    [Production].[Product] AS P ON OD.[ProductID] = P.[ProductID]
JOIN 
    [Production].[ProductSubcategory] AS SC ON P.[ProductSubcategoryID] = SC.[ProductSubcategoryID]
GROUP BY 
    SC.[Name]
ORDER BY 
    SC.[Name]

---9)What is the average purchase for each category?

SELECT 
    C.[Name] AS CategoryName,
    AVG(OH.TotalDue) AS AveragePurchase
FROM 
    [Sales].[SalesOrderHeader] AS OH
JOIN 
    [Sales].[SalesOrderDetail] AS OD ON OH.[SalesOrderID] = OD.[SalesOrderID]
JOIN 
    [Production].[Product] AS P ON OD.[ProductID] = P.[ProductID]
JOIN 
    [Production].[ProductSubcategory] AS SC ON P.[ProductSubcategoryID] = SC.[ProductSubcategoryID]
JOIN 
    [Production].[ProductCategory] AS C ON SC.[ProductCategoryID] = C.[ProductCategoryID]
GROUP BY 
    C.[Name]
ORDER BY 
    C.[Name];

---10)Total number of orders sold by each employee: 

SELECT 
    P.[FirstName] + ' ' + P.[LastName] AS EmployeeName,
    COUNT(OH.SalesOrderID) AS TotalOrders
FROM 
    [Sales].[SalesOrderHeader] AS OH
JOIN 
    [Sales].[SalesPerson] AS SP ON OH.[SalesPersonID] = SP.[BusinessEntityID]
JOIN 
    [Person].[Person] AS P ON SP.[BusinessEntityID] = P.[BusinessEntityID]
GROUP BY 
    P.[FirstName], P.[LastName]
ORDER BY 
    TotalOrders DESC;

---11)What is the total number of products shipped by each method?

SELECT 
    M.[Name] AS ShipMethod,
	count(ProductID) AS TotalProducts 
FROM 
	[Sales].[SalesOrderHeader] AS OH 
JOIN 
	[sales].[SalesOrderDetail] AS OD ON OH.[SalesOrderID] = OD.[SalesOrderID]
JOIN 
    [Purchasing].[ShipMethod] AS M ON M.[ShipMethodID] = OH.[ShipMethodID]
GROUP BY
	ProductID, M.[Name];

---12)What is the frieght for each shipmethod?

SELECT 
    M.[Name] AS ShipMethod,  OH.[Freight]
FROM 
	[sales].[SalesOrderHeader] AS OH 
JOIN 
    [Purchasing].[ShipMethod] AS M ON M.[ShipMethodID] = OH.[ShipMethodID]
ORDER BY 
    Freight DESC;

---13)What is the total Profit for each Country?

SELECT 
    [Sales].[SalesTerritory].[Name] AS CountryName, SalesYTD AS Profit 
FROM 
    [Sales].[SalesTerritory]
ORDER BY 
    Profit;

---14)Top year by salary:

SELECT TOP 1 
    YEAR(OrderDate) AS TOP_YEAR , linetotal 
FROM 
	[Sales].[SalesOrderDetail] AS OD
JOIN 
    [Sales].[SalesOrderHeader] AS H on H.SalesOrderID = OD.SalesOrderID;

---15)Top 5 Employees by Sales:

SELECT TOP 5 
    Emp.[BusinessEntityID], -- Employee identifier
    Per.[FirstName] + ' ' + Per.[LastName] AS EmployeeName, 
    SUM(OH.TotalDue) AS TotalSales
FROM 
    [Sales].[SalesOrderHeader] AS OH
JOIN 
    [Sales].[SalesPerson] AS SP ON OH.[SalesPersonID] = SP.[BusinessEntityID]
JOIN 
    [HumanResources].[Employee] AS Emp ON SP.[BusinessEntityID] = Emp.[BusinessEntityID]
JOIN 
    [Person].[Person] Per ON Emp.[BusinessEntityID] = Per.[BusinessEntityID]
GROUP BY 
    Emp.[BusinessEntityID], Per.[FirstName], Per.[LastName]
ORDER BY 
    TotalSales DESC;

---16)Total orderds by each customer:

SELECT 
    OH.[CustomerID], 
    COUNT(OH.SalesOrderID) AS NumberOfOrders
FROM 
    [Sales].[SalesOrderHeader] AS OH
GROUP BY 
    OH.[CustomerID]
ORDER BY 
    NumberOfOrders DESC;

---17)What is the total number of customers in each territory?

SELECT 
    Ter.[Name] AS TerritoryName, 
    COUNT(C.CustomerID) AS NumberOfCustomers
FROM 
    [Sales].[Customer] C
JOIN 
    [Sales].[SalesTerritory] AS Ter ON C.[TerritoryID] = Ter.[TerritoryID]
GROUP BY 
    Ter.[Name]
ORDER BY 
    NumberOfCustomers DESC;

---18)What is the quantity stock for each product?

SELECT 
    P.[ProductID], 
    P.[Name] AS ProductName, 
    SUM(PI.Quantity) AS TotalStockQuantity
FROM 
    [Production].[Product] AS P
JOIN 
    [Production].[ProductInventory] AS PI ON P.[ProductID] = PI.[ProductID]
GROUP BY 
    P.[ProductID], P.[Name]
ORDER BY 
    TotalStockQuantity DESC;

---19)What is the total Sales Between  ‘31-5-2011’ and ‘31-10-2011’?

SELECT 
    COUNT(*) AS TotalOrders
FROM 
    [Sales].[SalesOrderHeader]
WHERE 
    OrderDate BETWEEN '2011-05-31' AND '2011-10-31';