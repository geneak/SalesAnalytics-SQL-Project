-- SalesAnalytics Project
-- Analysis queries practiced during the project.

USE SalesAnalytics;
GO

-- 1. Customers by state
SELECT State, COUNT(*) AS CustomerCount
FROM Customers
GROUP BY State;

-- 2. Products by category
SELECT Category, COUNT(*) AS ProductCount
FROM Products
GROUP BY Category;

-- 3. Orders per customer
SELECT
    c.CustomerName,
    COUNT(o.OrderID) AS OrderCount
FROM Customers c
JOIN Orders o
    ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerName;

-- 4. Revenue per order
SELECT
    OrderID,
    SUM(Quantity * UnitPrice) AS TotalSales
FROM OrderDetails
GROUP BY OrderID;

-- 5. Total spending per customer
SELECT
    c.CustomerName,
    SUM(od.Quantity * od.UnitPrice) AS TotalSpent
FROM Customers c
JOIN Orders o
    ON c.CustomerID = o.CustomerID
JOIN OrderDetails od
    ON o.OrderID = od.OrderID
GROUP BY c.CustomerName
ORDER BY TotalSpent DESC;

-- 6. Revenue by product
SELECT
    p.ProductName,
    SUM(od.Quantity * od.UnitPrice) AS TotalRevenue
FROM Products p
JOIN OrderDetails od
    ON p.ProductID = od.ProductID
GROUP BY p.ProductName
ORDER BY TotalRevenue DESC;

-- 7. Revenue by category
SELECT
    p.Category,
    SUM(od.Quantity * od.UnitPrice) AS TotalRevenue
FROM Products p
JOIN OrderDetails od
    ON p.ProductID = od.ProductID
GROUP BY p.Category
ORDER BY TotalRevenue DESC;

-- 8. Units sold by category
SELECT
    p.Category,
    SUM(od.Quantity) AS UnitsSold
FROM Products p
JOIN OrderDetails od
    ON p.ProductID = od.ProductID
GROUP BY p.Category
ORDER BY UnitsSold DESC;

-- 9. Units sold and revenue by category
SELECT
    p.Category,
    SUM(od.Quantity) AS UnitsSold,
    SUM(od.Quantity * od.UnitPrice) AS TotalRevenue
FROM Products p
JOIN OrderDetails od
    ON p.ProductID = od.ProductID
GROUP BY p.Category
ORDER BY UnitsSold DESC;

-- 10. Top 3 products by revenue
SELECT TOP 3
    p.ProductName,
    SUM(od.Quantity * od.UnitPrice) AS TotalRevenue
FROM Products p
JOIN OrderDetails od
    ON p.ProductID = od.ProductID
GROUP BY p.ProductName
ORDER BY TotalRevenue DESC;

-- 11. Customer and product units bought
SELECT
    c.CustomerName,
    p.ProductName,
    SUM(od.Quantity) AS UnitsBought
FROM Customers c
JOIN Orders o
    ON c.CustomerID = o.CustomerID
JOIN OrderDetails od
    ON o.OrderID = od.OrderID
JOIN Products p
    ON od.ProductID = p.ProductID
GROUP BY c.CustomerName, p.ProductName;

-- 12. Customer with the highest total spending
SELECT TOP 1
    c.CustomerName,
    SUM(od.Quantity * od.UnitPrice) AS TotalSpent
FROM Customers c
JOIN Orders o
    ON c.CustomerID = o.CustomerID
JOIN OrderDetails od
    ON o.OrderID = od.OrderID
GROUP BY c.CustomerName
ORDER BY TotalSpent DESC;

-- 13. Customers with no orders
SELECT
    c.CustomerName
FROM Customers c
LEFT JOIN Orders o
    ON o.CustomerID = c.CustomerID
WHERE o.OrderID IS NULL;

-- 14. Monthly sales
SELECT
    YEAR(o.OrderDate) AS SalesYear,
    MONTH(o.OrderDate) AS SalesMonth,
    SUM(od.Quantity * od.UnitPrice) AS TotalSales
FROM Orders o
JOIN OrderDetails od
    ON od.OrderID = o.OrderID
GROUP BY YEAR(o.OrderDate), MONTH(o.OrderDate)
ORDER BY SalesYear, SalesMonth;

-- 15. Average order value using a subquery
SELECT
    AVG(OrderTotal) AS AverageOrderValue
FROM
(
    SELECT
        o.OrderID,
        SUM(od.Quantity * od.UnitPrice) AS OrderTotal
    FROM Orders o
    JOIN OrderDetails od
        ON od.OrderID = o.OrderID
    GROUP BY o.OrderID
) AS OrderTotals;

-- 16. Customer segmentation using CASE
SELECT
    c.CustomerName,
    SUM(od.Quantity * od.UnitPrice) AS TotalSpent,
    CASE
        WHEN SUM(od.Quantity * od.UnitPrice) >= 500 THEN 'High Value'
        WHEN SUM(od.Quantity * od.UnitPrice) >= 200 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS CustomerSegment
FROM Customers c
JOIN Orders o
    ON o.CustomerID = c.CustomerID
JOIN OrderDetails od
    ON od.OrderID = o.OrderID
GROUP BY c.CustomerName;
GO
