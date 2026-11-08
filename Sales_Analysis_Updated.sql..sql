select * from orders
select * from orderdetails

SELECT MAX(Orderid) AS MaxOrderID
FROM orders;
SELECT MAX(orderdetailid) AS MaxOrderDetailID
FROM orderdetails;

SELECT *
FROM orders
ORDER BY Orderid;

SELECT *
FROM orderdetails
ORDER BY orderdetailid;
select *
from produts

--1. orders


INSERT INTO orders (Orderid, Customerid, orderdate)
VALUES
-- 2022
(107, 1, '2022-01-05'),
(108, 2, '2022-01-08'),
(109, 3, '2022-01-15'),
(110, 4, '2022-02-02'),
(111, 5, '2022-02-10'),
(112, 1, '2022-02-18'),

-- 2023
(113, 2, '2023-01-05'),
(114, 3, '2023-01-08'),
(115, 4, '2023-01-15'),
(116, 5, '2023-02-02'),
(117, 1, '2023-02-10'),
(118, 2, '2023-02-18'),

-- 2024
(119, 3, '2024-01-05'),
(120, 4, '2024-01-08'),
(121, 5, '2024-01-15'),
(122, 1, '2024-02-02'),
(123, 2, '2024-02-10'),
(124, 3, '2024-02-18'),

-- 2025
(125, 4, '2025-01-05'),
(126, 5, '2025-01-08'),
(127, 1, '2025-01-15'),
(128, 2, '2025-02-02'),
(129, 3, '2025-02-10'),
(130, 4, '2025-02-18');

--2. orderdetails 
INSERT INTO orderdetails
    (orderdetailid, orderid, productid, quantity, unitprice)
VALUES
-- 2022
(8, 107, 1, 1, 899.99),
(9, 108, 2, 2, 29.99),
(10, 109, 3, 1, 199.99),
(11, 110, 4, 1, 349.99),
(12, 111, 6, 1, 299.99),
(13, 112, 5, 2, 59.99),

-- 2023
(14, 113, 1, 1, 899.99),
(15, 114, 2, 3, 29.99),
(16, 115, 3, 2, 199.99),
(17, 116, 4, 1, 349.99),
(18, 117, 6, 2, 299.99),
(19, 118, 5, 3, 59.99),

-- 2024
(20, 119, 1, 1, 899.99),
(21, 120, 2, 2, 29.99),
(22, 121, 3, 1, 199.99),
(23, 122, 4, 2, 349.99),
(24, 123, 6, 1, 299.99),
(25, 124, 5, 2, 59.99),

-- 2025
(26, 125, 1, 1, 899.99),
(27, 126, 2, 4, 29.99),
(28, 127, 3, 2, 199.99),
(29, 128, 4, 1, 349.99),
(30, 129, 6, 2, 299.99),
(31, 130, 5, 3, 59.99);

select * from orders

select * from produts

ALTER TABLE produts
ADD unitcost DECIMAL(10,2);

UPDATE produts
SET unitcost = CASE Productid
    WHEN 1 THEN 650.00  -- Laptop
    WHEN 2 THEN 12.00   -- Wireless Mouse
    WHEN 3 THEN 120.00  -- Office Chair
    WHEN 4 THEN 220.00  -- Desk
    WHEN 5 THEN 20.00   -- Keyboard
    WHEN 6 THEN 180.00  -- Monitor
END;
--1.--running total 

SELECT
    o.OrderID,
    o.OrderDate,
    p.ProductName,
    od.Quantity,
    od.UnitPrice,
    od.Quantity * od.UnitPrice AS SalesAmount,
    SUM(od.Quantity * od.UnitPrice) OVER (
        ORDER BY
            o.OrderDate,
            o.OrderID,
            od.OrderDetailID
        ROWS BETWEEN UNBOUNDED PRECEDING
                 AND CURRENT ROW
    ) AS RunningTotalSales
FROM Orders AS o
INNER JOIN OrderDetails AS od
    ON o.OrderID = od.OrderID
INNER JOIN Produts AS p
    ON od.ProductID = p.ProductID
ORDER BY
    o.OrderDate,
    o.OrderID,
    od.OrderDetailID;
--cte and previous order revenu 
with ordersales as 
(
select o.customerid,
        o.orderid ,
        o.orderdate,
sum (od.quantity * od.unitprice) as orderrevenu 
from orders as o
inner join  orderdetails od 
on o.orderid = od. orderid 
group by o.customerid,
        o.orderid ,
        o.orderdate
 )
 select customerid,
        orderid ,
        orderdate,
        orderrevenu,
        lag (orderrevenu) over 
        ( 
          partition by customerid
          order by orderdate, orderid
          ) as previousorderrevenue 
          from ordersales ;
select * from orders
select * from orderdetails
--2 calcuate the percentage change 
--cast (order revenu- previousorderrevenue)* 100/nullif (previousorderrevenue,0)
-- as decimal (10,2)
--as percentagechange 

;WITH OrderSales AS
(
    SELECT
        o.CustomerID,
        o.OrderID,
        o.OrderDate,
        SUM(od.Quantity * od.UnitPrice) AS OrderRevenue
    FROM Orders AS o
    INNER JOIN OrderDetails AS od
        ON o.OrderID = od.OrderID
    GROUP BY
        o.CustomerID,
        o.OrderID,
        o.OrderDate
),
PreviousOrders AS
(
    SELECT
        CustomerID,
        OrderID,
        OrderDate,
        OrderRevenue,
        LAG(OrderRevenue) OVER
        (
            PARTITION BY CustomerID
            ORDER BY OrderDate, OrderID
        ) AS PreviousOrderRevenue
    FROM OrderSales
)
SELECT
    CustomerID,
    OrderID,
    OrderDate,
    OrderRevenue,
    PreviousOrderRevenue,
    CAST(
        (OrderRevenue - PreviousOrderRevenue) * 100.0
        / NULLIF(PreviousOrderRevenue, 0)
        AS DECIMAL(10,2)
    ) AS PercentageChange
FROM PreviousOrders
ORDER BY CustomerID, OrderDate, OrderID;

-- case statement 
;WITH OrderSales AS
(
    SELECT
        o.CustomerID,
        o.OrderID,
        o.OrderDate,
        SUM(od.Quantity * od.UnitPrice) AS OrderRevenue
    FROM Orders AS o
    INNER JOIN OrderDetails AS od
        ON o.OrderID = od.OrderID
    GROUP BY
        o.CustomerID,
        o.OrderID,
        o.OrderDate
),
PreviousOrders AS
(
    SELECT
        CustomerID,
        OrderID,
        OrderDate,
        OrderRevenue,
        LAG(OrderRevenue) OVER
        (
            PARTITION BY CustomerID
            ORDER BY OrderDate, OrderID
        ) AS PreviousOrderRevenue
    FROM OrderSales
)
SELECT
    CustomerID,
    OrderID,
    OrderDate,
    OrderRevenue,
    PreviousOrderRevenue,
    CAST(
        (OrderRevenue - PreviousOrderRevenue) * 100.0
        / NULLIF(PreviousOrderRevenue, 0)
        AS DECIMAL(10,2)

)  
AS PercentageChange,

    CASE
        WHEN PreviousOrderRevenue IS NULL
            THEN 'First Order'
        WHEN PreviousOrderRevenue = 0
            THEN 'First Order'
        WHEN OrderRevenue > PreviousOrderRevenue
            THEN 'Increased'
        WHEN OrderRevenue < PreviousOrderRevenue
            THEN 'Decreased'
        ELSE 'No Change'
    END AS RevenueStatus
FROM PreviousOrders
ORDER BY CustomerID, OrderDate, OrderID;
--inserting customer records 
---inserting orders 
-- inserting orderdetails 
-- inserting product 
--creating table product 
--creating table category 
--creating table payment 
 INSERT INTO Customers
    (CustomerID, CustomerName, City, satate)
VALUES
    (6, 'Olivia Martin', 'Columbus', 'Ohio'),
    (7, 'James Anderson', 'Cleveland', 'Ohio'),
    (8, 'Sophia Thomas', 'Cincinnati', 'Ohio');   

---inserting 50 records into customer table 

;WITH Numbers AS
(
    SELECT 6 AS CustomerID
    UNION ALL
    SELECT CustomerID + 1
    FROM Numbers
    WHERE CustomerID < 50
)
INSERT INTO Customers
    (CustomerID, CustomerName, City, satate)
SELECT
    n.CustomerID,
    CONCAT('Customer ', n.CustomerID),
    CASE n.CustomerID % 5
        WHEN 0 THEN 'Columbus'
        WHEN 1 THEN 'Cleveland'
        WHEN 2 THEN 'Cincinnati'
        WHEN 3 THEN 'Detroit'
        ELSE 'Chicago'
    END,
    CASE n.CustomerID % 5
        WHEN 0 THEN 'Ohio'
        WHEN 1 THEN 'Ohio'
        WHEN 2 THEN 'Ohio'
        WHEN 3 THEN 'Michigan'
        ELSE 'Illinois'
    END
FROM Numbers AS n
WHERE NOT EXISTS
(
    SELECT 1
    FROM Customers AS c
    WHERE c.CustomerID = n.CustomerID
)
OPTION (MAXRECURSION 100);

select * from customers
select count (*) total 
from customers 
--updating the customers name 
UPDATE Customers
SET CustomerName =
    CASE CustomerID
        WHEN 9 THEN 'Daniel Wilson'
        WHEN 10 THEN 'Emma Taylor'
        WHEN 11 THEN 'Noah Moore'
        WHEN 12 THEN 'Ava Jackson'
        WHEN 13 THEN 'Liam Martin'
        WHEN 14 THEN 'Mia Thompson'
        WHEN 15 THEN 'Ethan White'
        WHEN 16 THEN 'Isabella Harris'
        WHEN 17 THEN 'Mason Clark'
        WHEN 18 THEN 'Amelia Lewis'
        WHEN 19 THEN 'Logan Robinson'
        WHEN 20 THEN 'Charlotte Walker'
        WHEN 21 THEN 'Lucas Hall'
        WHEN 22 THEN 'Harper Allen'
        WHEN 23 THEN 'Benjamin Young'
        WHEN 24 THEN 'Evelyn King'
        WHEN 25 THEN 'Henry Wright'
        WHEN 26 THEN 'Abigail Scott'
        WHEN 27 THEN 'Alexander Green'
        WHEN 28 THEN 'Ella Baker'
        WHEN 29 THEN 'Sebastian Adams'
        WHEN 30 THEN 'Grace Nelson'
        WHEN 31 THEN 'Jack Hill'
        WHEN 32 THEN 'Chloe Campbell'
        WHEN 33 THEN 'Owen Mitchell'
        WHEN 34 THEN 'Lily Roberts'
        WHEN 35 THEN 'Samuel Carter'
        WHEN 36 THEN 'Aria Phillips'
        WHEN 37 THEN 'Joseph Evans'
        WHEN 38 THEN 'Scarlett Turner'
        WHEN 39 THEN 'Wyatt Parker'
        WHEN 40 THEN 'Victoria Collins'
        WHEN 41 THEN 'Gabriel Edwards'
        WHEN 42 THEN 'Riley Stewart'
        WHEN 43 THEN 'Julian Morris'
        WHEN 44 THEN 'Zoey Rogers'
        WHEN 45 THEN 'Levi Reed'
        WHEN 46 THEN 'Hannah Cook'
        WHEN 47 THEN 'Isaac Morgan'
        WHEN 48 THEN 'Layla Bell'
        WHEN 49 THEN 'Anthony Murphy'
        WHEN 50 THEN 'Nora Bailey'
    END
WHERE CustomerID BETWEEN 9 AND 50;
---inserting orders 
select * from orders
INSERT INTO Orders (OrderID, CustomerID, OrderDate)
VALUES
(131, 6,  '2025-03-05'),
(132, 7,  '2025-03-12'),
(133, 8,  '2025-03-19'),
(134, 9,  '2025-04-02'),
(135, 10, '2025-04-10'),
(136, 11, '2025-04-18'),
(137, 12, '2025-05-05'),
(138, 13, '2025-05-14'),
(139, 14, '2025-05-22'),
(140, 15, '2025-06-03'),
(141, 16, '2025-06-11'),
(142, 17, '2025-06-20'),
(143, 18, '2025-07-04'),
(144, 19, '2025-07-12'),
(145, 20, '2025-07-21'),
(146, 21, '2025-08-05'),
(147, 22, '2025-08-13'),
(148, 23, '2025-08-22'),
(149, 24, '2025-09-06'),
(150, 25, '2025-09-15');
-- inserting orderdetails 
select * from orderdetails
INSERT INTO OrderDetails
    (OrderDetailID, OrderID, ProductID, Quantity, UnitPrice)
VALUES
(32, 131, 1, 1, 899.99),
(33, 132, 2, 2, 29.99),
(34, 133, 3, 1, 199.99),
(35, 134, 4, 1, 349.99),
(36, 135, 5, 2, 59.99),
(37, 136, 6, 1, 299.99),
(38, 137, 1, 2, 899.99),
(39, 138, 2, 3, 29.99),
(40, 139, 3, 1, 199.99),
(41, 140, 4, 2, 349.99),
(42, 141, 5, 1, 59.99),
(43, 142, 6, 2, 299.99),
(44, 143, 1, 1, 899.99),
(45, 144, 2, 4, 29.99),
(46, 145, 3, 2, 199.99),
(47, 146, 4, 1, 349.99),
(48, 147, 5, 3, 59.99),
(49, 148, 6, 1, 299.99),
(50, 149, 1, 1, 899.99);
---interting products 
select * from produts
;WITH ProductNumbers AS
(
    SELECT 7 AS ProductID
    UNION ALL
    SELECT ProductID + 1
    FROM ProductNumbers
    WHERE ProductID < 50
)
INSERT INTO Produts
    (ProductID, ProductName, Category, Price, UnitCost)
SELECT
    n.ProductID,
    CASE n.ProductID
        WHEN 7  THEN 'USB-C Hub'
        WHEN 8  THEN 'Webcam'
        WHEN 9  THEN 'Headphones'
        WHEN 10 THEN 'Printer'
        WHEN 11 THEN 'Tablet'
        WHEN 12 THEN 'Smartphone'
        WHEN 13 THEN 'External Hard Drive'
        WHEN 14 THEN 'SSD Drive'
        WHEN 15 THEN 'Computer Speakers'
        WHEN 16 THEN 'Laptop Stand'
        WHEN 17 THEN 'Bookshelf'
        WHEN 18 THEN 'Office Table'
        WHEN 19 THEN 'Filing Cabinet'
        WHEN 20 THEN 'Desk Lamp'
        WHEN 21 THEN 'Ergonomic Chair'
        WHEN 22 THEN 'Standing Desk'
        WHEN 23 THEN 'Storage Cabinet'
        WHEN 24 THEN 'Conference Table'
        WHEN 25 THEN 'Wireless Keyboard'
        WHEN 26 THEN 'Gaming Mouse'
        WHEN 27 THEN 'Docking Station'
        WHEN 28 THEN 'Microphone'
        WHEN 29 THEN 'Projector'
        WHEN 30 THEN 'Router'
        WHEN 31 THEN 'Network Switch'
        WHEN 32 THEN 'Graphics Tablet'
        WHEN 33 THEN 'Office Phone'
        WHEN 34 THEN 'Barcode Scanner'
        WHEN 35 THEN 'Label Printer'
        WHEN 36 THEN 'Paper Shredder'
        WHEN 37 THEN 'Whiteboard'
        WHEN 38 THEN 'Monitor Arm'
        WHEN 39 THEN 'Laptop Backpack'
        WHEN 40 THEN 'Surge Protector'
        WHEN 41 THEN 'Power Bank'
        WHEN 42 THEN 'Memory Card'
        WHEN 43 THEN 'Flash Drive'
        WHEN 44 THEN 'Wi-Fi Adapter'
        WHEN 45 THEN 'Portable Monitor'
        WHEN 46 THEN 'All-in-One PC'
        WHEN 47 THEN 'Document Scanner'
        WHEN 48 THEN 'Office Sofa'
        WHEN 49 THEN 'Reception Desk'
        WHEN 50 THEN 'Meeting Room Chair'
    END,
    CASE
        WHEN n.ProductID BETWEEN 17 AND 24
          OR n.ProductID IN (48, 49, 50)
            THEN 'Furniture'
        ELSE 'Electronics'
    END,
    CAST(n.ProductID * 15.00 + 24.99 AS DECIMAL(10,2)),
    CAST(n.ProductID * 8.00 + 10.00 AS DECIMAL(10,2))
FROM ProductNumbers AS n
WHERE NOT EXISTS
(
    SELECT 1
    FROM Produts AS p
    WHERE p.ProductID = n.ProductID
)
OPTION (MAXRECURSION 100);
-- creating payment table 
-- creatitng category 
CREATE TABLE Categories
(
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(50) NOT NULL
);
INSERT INTO Categories (CategoryID, CategoryName)
VALUES
(1, 'Computers'),
(2, 'Computer Accessories'),
(3, 'Computer Components'),
(4, 'Laptops'),
(5, 'Desktop Computers'),
(6, 'Tablets'),
(7, 'Smartphones'),
(8, 'Monitors'),
(9, 'Printers'),
(10, 'Scanners'),
(11, 'Keyboards'),
(12, 'Mice'),
(13, 'Headphones'),
(14, 'Speakers'),
(15, 'Webcams'),
(16, 'Microphones'),
(17, 'Storage Devices'),
(18, 'External Drives'),
(19, 'Memory Cards'),
(20, 'USB Drives'),
(21, 'Networking'),
(22, 'Routers'),
(23, 'Network Switches'),
(24, 'Wi-Fi Adapters'),
(25, 'Cables and Adapters'),
(26, 'Docking Stations'),
(27, 'Power Banks'),
(28, 'Power Supplies'),
(29, 'Surge Protectors'),
(30, 'Computer Cooling'),
(31, 'Graphics Tablets'),
(32, 'Projectors'),
(33, 'Office Furniture'),
(34, 'Office Chairs'),
(35, 'Desks'),
(36, 'Standing Desks'),
(37, 'Conference Tables'),
(38, 'Filing Cabinets'),
(39, 'Bookshelves'),
(40, 'Storage Cabinets'),
(41, 'Office Lighting'),
(42, 'Whiteboards'),
(43, 'Office Phones'),
(44, 'Label Printers'),
(45, 'Paper Shredders'),
(46, 'Laptop Bags'),
(47, 'Computer Stands'),
(48, 'Monitor Arms'),
(49, 'Office Sofas'),
(50, 'Meeting Room Furniture');
--Creating  payment 
CREATE TABLE payment 
(
    PaymentID INT PRIMARY KEY,
    Orderid int ,
    Paymentmethod  VARCHAR(50) NOT NULL,
    Paymentdate date not null,
    amount decimal (10,2)not null,
    fOREIGN KEY (OrderID)
        REFERENCES Orders(OrderID)
);
select * from payment
---inserting payment
;WITH PaymentNumbers AS
(
    SELECT 1 AS PaymentID
    UNION ALL
    SELECT PaymentID + 1
    FROM PaymentNumbers
    WHERE PaymentID < 50
)
INSERT INTO Payment
    (PaymentID, OrderID, PaymentDate, PaymentMethod, Amount)
SELECT
    n.PaymentID,
    o.OrderID,
    DATEADD(DAY, n.PaymentID % 10, o.OrderDate),
    CASE n.PaymentID % 4
        WHEN 0 THEN 'Credit Card'
        WHEN 1 THEN 'Debit Card'
        WHEN 2 THEN 'PayPal'
        ELSE 'Bank Transfer'
    END,
    r.OrderRevenue
FROM PaymentNumbers AS n
INNER JOIN Orders AS o
    ON o.OrderID = 100 + n.PaymentID
CROSS APPLY
(
    SELECT SUM(od.Quantity * od.UnitPrice) AS OrderRevenue
    FROM OrderDetails AS od
    WHERE od.OrderID = o.OrderID
) AS r
WHERE r.OrderRevenue IS NOT NULL
  AND NOT EXISTS
  (
      SELECT 1
      FROM Payment AS p
      WHERE p.PaymentID = n.PaymentID
  )
OPTION (MAXRECURSION 100);
select * from payment
--ques.
    --Which products generate the most revenue?
    SELECT
    p.ProductID,
    p.ProductName,
    SUM(od.Quantity) AS TotalQuantitySold,
    SUM(od.Quantity * od.UnitPrice) AS TotalRevenue
FROM OrderDetails AS od
INNER JOIN Products AS p
    ON p.ProductID = od.ProductID
GROUP BY
    p.ProductID,
    p.ProductName
ORDER BY
    TotalRevenue DESC;
--Exercise 2 — Find products with revenue greater than $500
select Top 5
p.productid ,
p. productname,
sum(od.quantity) as totalquantitysold,
sum(od.quantity * od.unitprice) as totalrevenue
from orderdetails as od
inner join Products as p 
on p.Productid = od.productid
group by p.productid,
         p. productname
         HAVING SUM(od.Quantity * od.UnitPrice) > 500
         order by 
         totalrevenue desc;
--top 5 revenue
         select Top 5
p.productid ,
p.productname,
sum(od.quantity) as totalquantitysold,
sum(od.quantity * od.unitprice) as totalrevenue
from orderdetails as od
inner join Products as p 
on p.Productid = od.productid
group by p.productid,
         p. productname
         order by 
            totalrevenue desc;
--Exercise 4 — Find customers who have never placed an order
--Use Customers and Orders.

SELECT
    c.CustomerID,
    c.CustomerName,
    c.City,
    c.Satate
FROM Customers AS c
left join orders o
on c.customerid=o.Customerid
WHERE o.OrderID IS NULL;

--how many customers had placed orders 
SELECT
    c.CustomerID,
    c.CustomerName,
    COUNT(o.OrderID) AS TotalOrders
FROM Customers AS c
LEFT JOIN Orders AS o
    ON c.CustomerID = o.CustomerID
GROUP BY
    c.CustomerID,
    c.CustomerName
ORDER BY
    TotalOrders ASC;
--Check the customer and order totals   
SELECT COUNT(DISTINCT CustomerID) AS CustomersWithOrders
FROM Orders;
-- which customers have placed morethan one order
SELECT
    c.CustomerID,
    c.CustomerName,
    COUNT(o.OrderID) AS TotalOrders
FROM Customers AS c
LEFT JOIN Orders AS o
    ON c.CustomerID = o.CustomerID
GROUP BY
    c.CustomerID,
    c.CustomerName
            having count (o.orderid)>1

--Find each customer's total spending >1,000
SELECT
    c.CustomerID,
    c.CustomerName,
    SUM(od.Quantity * od.UnitPrice) AS TotalSpending
FROM Customers AS c
INNER JOIN Orders AS o
    ON c.CustomerID = o.CustomerID
INNER JOIN OrderDetails AS od
    ON o.OrderID = od.OrderID
GROUP BY
    c.CustomerID,
    c.CustomerName
HAVING
    SUM(od.Quantity * od.UnitPrice) > 1000
ORDER BY
    TotalSpending DESC;
    
 ---Find the most profitable products
 select p.productid ,
        p.productname,
        sum(od.quantity)as Totalunitsold,
        sum(od.quantity *(p.price-p.unitcost))as totalProfit
    from orderdetails as od
    inner join products  as p 
    on p.Productid =od.productid
    group by p.productid ,
        p.productname
        order by Totalprofit Desc;
--checking the tabe name 
        select * from products
        SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';

SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME = 'produts';

SELECT * FROM Products;

SELECT * FROM Categories;
UPDATE Products
SET CategoryID =
    CASE
        WHEN Category = 'Electronics' THEN 1
        WHEN Category = 'Furniture' THEN 2
    END;

    ALTER TABLE Products
ADD CategoryID INT;

UPDATE Products
SET CategoryID =
    CASE
        WHEN Category = 'Electronics' THEN 1
        WHEN Category = 'Furniture' THEN 2
    END;

    SELECT Productid,
       productname,
       Category,
       CategoryID
FROM Products

SELECT * FROM Categories;

UPDATE Products
SET CategoryID =
    CASE
        WHEN productname = 'Laptop' THEN 1
        WHEN productname = 'Wireless Mouse' THEN 12
        WHEN productname = 'Office Chair' THEN 34
        WHEN productname = 'Desk' THEN 35
        WHEN productname = 'Keyboard' THEN 11
        WHEN productname = 'Monitor' THEN 8
        WHEN productname = 'USB-C Hub' THEN 25
        WHEN productname = 'Webcam' THEN 15
        WHEN productname = 'Headphones' THEN 13
        WHEN productname = 'Printer' THEN 9
        WHEN productname = 'Tablet' THEN 6
        WHEN productname = 'Smartphone' THEN 7
        WHEN productname = 'External Hard Drive' THEN 18
        WHEN productname = 'SSD Drive' THEN 17
        WHEN productname = 'Computer Speakers' THEN 14
        WHEN productname = 'Laptop Stand' THEN 47
        WHEN productname = 'Bookshelf' THEN 39
        WHEN productname = 'Office Table' THEN 35
        WHEN productname = 'Filing Cabinet' THEN 38
        WHEN productname = 'Desk Lamp' THEN 41
        WHEN productname = 'Ergonomic Chair' THEN 34
        WHEN productname = 'Standing Desk' THEN 36
        WHEN productname = 'Storage Cabinet' THEN 40
        WHEN productname = 'Conference Table' THEN 37
        WHEN productname = 'Wireless Keyboard' THEN 11
        WHEN productname = 'Gaming Mouse' THEN 12
        WHEN productname = 'Docking Station' THEN 26
        WHEN productname = 'Microphone' THEN 16
        WHEN productname = 'Projector' THEN 32
        WHEN productname = 'Router' THEN 22
        WHEN productname = 'Network Switch' THEN 23
        WHEN productname = 'Graphics Tablet' THEN 31
        WHEN productname = 'Office Phone' THEN 43
        WHEN productname = 'Barcode Scanner' THEN 10
        WHEN productname = 'Label Printer' THEN 44
        WHEN productname = 'Paper Shredder' THEN 45
        WHEN productname = 'Whiteboard' THEN 42
        WHEN productname = 'Monitor Arm' THEN 48
        WHEN productname = 'Laptop Backpack' THEN 46
        WHEN productname = 'Surge Protector' THEN 29
        WHEN productname = 'Power Bank' THEN 27
        WHEN productname = 'Memory Card' THEN 19
        WHEN productname = 'Flash Drive' THEN 20
        WHEN productname = 'Wi-Fi Adapter' THEN 24
        WHEN productname = 'Portable Monitor' THEN 8
        WHEN productname = 'All-in-One PC' THEN 5
        WHEN productname = 'Document Scanner' THEN 10
        WHEN productname = 'Office Sofa' THEN 49
        WHEN productname = 'Reception Desk' THEN 35
        WHEN productname = 'Meeting Room Chair' THEN 50
    END;
    -----
    SELECT
    p.Productid,
    p.productname,
    p.CategoryID,
    c.CategoryName
FROM Products p
LEFT JOIN Categories c
    ON p.CategoryID = c.CategoryID;

------------------------
    --checking duplicate records 
    
    SELECT CategoryID, COUNT(*) AS DuplicateCount
FROM Categories
GROUP BY CategoryID
HAVING COUNT(*) > 1;
---ranking cusomers who has placed an odermore than one 

with rankorders as
(
    SELECT
        c.customerid,
        c.customername,
        o.orderid,
        o.orderdate,
        SUM(od.quantity * od.unitprice) AS TotalAmount,
        ROW_NUMBER() OVER (
            PARTITION BY c.customerid
            ORDER BY o.orderdate DESC
        ) AS rn
    FROM customers c
    INNER JOIN orders o
        ON o.customerid = c.customerid
    INNER JOIN orderdetails od
        ON o.orderid = od.orderid
    GROUP BY
        c.customerid,
        c.customername,
        o.orderid,
        o.orderdate
)
SELECT *
FROM rankorders
WHERE rn <= 3;
-- 
--- ProductID
--- ProductName
--- Total units sold
--- RANK() based on total units sold, highest first
--Use the Products and OrderDetails tables.
SELECT
        p.productid,
        p.Productname,
       
      DENSE_RANK () OVER (
    ORDER BY SUM(od.quantity) DESC
) AS ProductRank
        
    FROM products p
    INNER JOIN orderdetails od
        ON od.productid = p.productid
        GROUP BY
         p.productid,
         p.Productname

         ----getting privious order
   SELECT
        c.Customerid,
        o.orderid,
        o.orderdate,
    LAG(OrderDate) OVER (
    PARTITION BY c.CustomerID
    ORDER BY OrderDate
) AS PreviousOrderDate
    FROM customers c
    INNER JOIN orders o
        ON o.Customerid = c.customerid
        GROUP BY
        c.Customerid,
        o.orderid,
        o.orderdate;

--find each order and finds the previous order date and 
--calculates how many days pass between each customer's orders.

WITH RankOrders AS
(
    SELECT
        CustomerID,
        OrderID,
        OrderDate,
        LAG(OrderDate) OVER (
            PARTITION BY CustomerID
            ORDER BY OrderDate
        ) AS PreviousOrderDate
    FROM Orders
)
SELECT
    CustomerID,
    OrderID,
    OrderDate,
    PreviousOrderDate,
    DATEDIFF(DAY, PreviousOrderDate, OrderDate) AS DaysBetweenOrders
FROM RankOrders;

----find customers next order
SELECT
        CustomerID,
        OrderID,
        OrderDate,
        Lead (OrderDate) OVER (
            PARTITION BY CustomerID
            ORDER BY OrderDate
        ) AS nextOrderDate
    FROM Orders

-- First, calculate each order's total. Then calculate the running total.

;WITH OrderTotals AS
(
    SELECT
        o.OrderID,
        o.OrderDate,
        SUM(od.Quantity * od.UnitPrice) AS TotalAmount
    FROM Orders o
    INNER JOIN OrderDetails od
        ON o.OrderID = od.OrderID
    GROUP BY
        o.OrderID,
        o.OrderDate
)
SELECT
    OrderID,
    OrderDate,
    TotalAmount,
    SUM(TotalAmount) OVER (
        ORDER BY OrderDate, OrderID
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS RunningTotal
FROM OrderTotals
ORDER BY OrderDate, OrderID;

---to calculate Percentage Change compares individual order amounts

WITH OrderTotals AS
(
    SELECT
        o.OrderID,
        o.OrderDate,
        SUM(od.Quantity * od.UnitPrice) AS TotalAmount
    FROM Orders o
    INNER JOIN OrderDetails od
        ON o.OrderID = od.OrderID
    GROUP BY
        o.OrderID,
        o.OrderDate
),
PreviousOrders AS
(
select 
        OrderID,
        OrderDate,
        TotalAmount,
LAG(TotalAmount) OVER (
    ORDER BY OrderDate, OrderID
) AS PreviousAmount
from OrderTotals
)
SELECT
    OrderID,
    OrderDate,
    TotalAmount,
    PreviousAmount,
    CAST(
        (TotalAmount - PreviousAmount) * 100.0 /
        NULLIF(PreviousAmount, 0)
        AS DECIMAL(10,2)
    ) AS PercentageChange
FROM PreviousOrders
ORDER BY OrderDate, OrderID
--calculate Monthly Revenue Growth (%).

WITH MonthlySales AS
(
    SELECT
        YEAR(o.OrderDate) AS SalesYear,
        MONTH(o.OrderDate) AS SalesMonth,
        SUM(od.Quantity * od.UnitPrice) AS MonthlyRevenue
    FROM Orders o
    INNER JOIN OrderDetails od
        ON o.OrderID = od.OrderID
    GROUP BY
        YEAR(o.OrderDate),
        MONTH(o.OrderDate)
),
PreviousOrders AS
(
    SELECT
        SalesYear,
        SalesMonth,
        MonthlyRevenue,
        LAG(MonthlyRevenue) OVER (
            ORDER BY SalesYear, SalesMonth
        ) AS PreviousAmount
    FROM MonthlySales
)
SELECT
    SalesYear,
    SalesMonth,
    MonthlyRevenue,
    PreviousAmount,
    CAST(
        (MonthlyRevenue - PreviousAmount) * 100.0 /
        NULLIF(PreviousAmount, 0)
        AS DECIMAL(10,2)
    ) AS PercentageChange
FROM PreviousOrders
ORDER BY SalesYear, SalesMonth;

-- Calculate annual revenue and compare each year with the previous year.

--SalesYear
--AnnualRevenue
--PreviousYearRevenue
--PercentageChange
WITH AnnualYear AS
(
    SELECT
        YEAR(o.OrderDate) AS SalesYear,
        SUM(od.Quantity * od.UnitPrice) AS AnnualRevenue
    FROM Orders o
    INNER JOIN OrderDetails od
        ON o.OrderID = od.OrderID
    GROUP BY YEAR(o.OrderDate)
),
PreviousYearRevenue AS
(
    SELECT
        SalesYear,
        AnnualRevenue,
        LAG(AnnualRevenue) OVER (
            ORDER BY SalesYear
        ) AS PreviousAmount
    FROM AnnualYear
)
SELECT
    SalesYear,
    AnnualRevenue,
    PreviousAmount,
    CAST(
        (AnnualRevenue - PreviousAmount) * 100.0 /
        NULLIF(PreviousAmount, 0)
        AS DECIMAL(10,2)
    ) AS PercentageChange
FROM PreviousYearRevenue
ORDER BY SalesYear;
--Calculate each customer's annual revenue and the percentage change
--compared with that same customer's previous year.
                        --CustomerID
                        --SalesYear
                        --AnnualRevenue
                        --PreviousYearRevenue
                        --PercentageChange
WITH CustomersAnnualRevenue AS
(
    SELECT
        c.CustomerID,
        YEAR(o.OrderDate) AS SalesYear,
        SUM(od.Quantity * od.UnitPrice) AS AnnualRevenue
    FROM Customers c
    INNER JOIN Orders o
        ON o.CustomerID = c.CustomerID
    INNER JOIN OrderDetails od
        ON o.OrderID = od.OrderID
    GROUP BY
        c.CustomerID,
        YEAR(o.OrderDate)
),
PreviousYearRevenue AS
(
    SELECT
        CustomerID,
        SalesYear,
        AnnualRevenue,
        LAG(AnnualRevenue) OVER (
            PARTITION BY CustomerID
            ORDER BY SalesYear
        ) AS PreviousYearRevenue
    FROM CustomersAnnualRevenue
)
SELECT
    CustomerID,
    SalesYear,
    AnnualRevenue,
    PreviousYearRevenue,
    CAST(
        (AnnualRevenue - PreviousYearRevenue) * 100.0 /
        NULLIF(PreviousYearRevenue, 0)
        AS DECIMAL(10,2)
    ) AS Percentagchange 
FROM PreviousYearRevenue
ORDER BY CustomerID, SalesYear;
--Find customers with declining revenue
                        --PercentageChange
WITH CustomersAnnualRevenue AS
(
    SELECT
        c.CustomerID,
        YEAR(o.OrderDate) AS SalesYear,
        SUM(od.Quantity * od.UnitPrice) AS AnnualRevenue
    FROM Customers c
    INNER JOIN Orders o
        ON o.CustomerID = c.CustomerID
    INNER JOIN OrderDetails od
        ON o.OrderID = od.OrderID
    GROUP BY
        c.CustomerID,
        YEAR(o.OrderDate)
),
PreviousYearRevenue AS
(
    SELECT
        CustomerID,
        SalesYear,
        AnnualRevenue,
        LAG(AnnualRevenue) OVER (
            PARTITION BY CustomerID
            ORDER BY SalesYear
        ) AS PreviousYearRevenue
    FROM CustomersAnnualRevenue
)
SELECT
    CustomerID,
    SalesYear,
    AnnualRevenue,
    PreviousYearRevenue,
    CAST(
        (AnnualRevenue - PreviousYearRevenue) * 100.0 /
        NULLIF(PreviousYearRevenue, 0)
        AS DECIMAL(10,2)
    ) AS Percentagedecline 
FROM PreviousYearRevenue
 WHERE PreviousYearRevenue > AnnualRevenue 
ORDER BY CustomerID, SalesYear;

--Find customers with revenue growth above 20%
WITH CustomersAnnualRevenue AS
(
    SELECT
        c.CustomerID,
        YEAR(o.OrderDate) AS SalesYear,
        SUM(od.Quantity * od.UnitPrice) AS AnnualRevenue
    FROM Customers c
    INNER JOIN Orders o
        ON o.CustomerID = c.CustomerID
    INNER JOIN OrderDetails od
        ON o.OrderID = od.OrderID
    GROUP BY
        c.CustomerID,
        YEAR(o.OrderDate)
),
PreviousYearRevenue AS
(
    SELECT
        CustomerID,
        SalesYear,
        AnnualRevenue,
        LAG(AnnualRevenue) OVER (
            PARTITION BY CustomerID
            ORDER BY SalesYear
        ) AS PreviousYearRevenue
    FROM CustomersAnnualRevenue
),
GrowthCalculation AS
(
    SELECT
        CustomerID,
        SalesYear,
        AnnualRevenue,
        PreviousYearRevenue,
        CAST(
            (AnnualRevenue - PreviousYearRevenue) * 100.0 /
            NULLIF(PreviousYearRevenue, 0)
            AS DECIMAL(10,2)
        ) AS PercentageGrowth
    FROM PreviousYearRevenue
)
SELECT *
FROM GrowthCalculation
WHERE PercentageGrowth < -20
ORDER BY CustomerID, SalesYear;
--Customer Revenue Classification
WITH CustomersAnnualRevenue AS
(
    SELECT
        c.CustomerID,
        YEAR(o.OrderDate) AS SalesYear,
        SUM(od.Quantity * od.UnitPrice) AS AnnualRevenue
    FROM Customers c
    INNER JOIN Orders o
        ON o.CustomerID = c.CustomerID
    INNER JOIN OrderDetails od
        ON o.OrderID = od.OrderID
    GROUP BY
        c.CustomerID,
        YEAR(o.OrderDate)
)
SELECT
    CustomerID,
    SalesYear,
    AnnualRevenue,
    CASE
        WHEN AnnualRevenue > = 5000 THEN 'Excellent'
        WHEN AnnualRevenue between 2000 and 4999.99 THEN 'High'
        WHEN AnnualRevenue between 1000 and 1999.99 THEN 'Medium'
        ELSE 'Low'
    END AS RevenueCategory
FROM CustomersAnnualRevenue
ORDER BY CustomerID, SalesYear;

--Calculate each customer's total lifetime revenue and classify them:
WITH CustomerRevenue AS
(
    SELECT
        c.CustomerID,
        SUM(od.Quantity * od.UnitPrice) AS TotalRevenue
    FROM Customers c
    INNER JOIN Orders o
        ON o.CustomerID = c.CustomerID
    INNER JOIN OrderDetails od
        ON o.OrderID = od.OrderID
    GROUP BY
        c.CustomerID
)
SELECT
    CustomerID,
    TotalRevenue,
    CASE
        WHEN TotalRevenue >= 5000 THEN 'Excellent'
        WHEN TotalRevenue >= 2000 THEN 'High'
        WHEN TotalRevenue >= 1000 THEN 'Medium'
        ELSE 'Low'
    END AS RevenueCategory
FROM CustomerRevenue
ORDER BY CustomerID;