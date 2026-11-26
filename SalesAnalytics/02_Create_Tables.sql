


-- SalesAnalytics Project
-- Creates all six database tables.

USE SalesAnalytics;
GO

-- 1. Customers table
CREATE TABLE Customers
(
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    City VARCHAR(100),
    State VARCHAR(50)
);
GO

-- 2. Products table
CREATE TABLE Products
(
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(100),
    Price DECIMAL(10,2)
);
GO

-- 3. Categories table
CREATE TABLE Categories
(
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(50) NOT NULL
);
GO

-- 4. Orders table
CREATE TABLE Orders
(
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE
);
GO

-- 5. OrderDetails table
CREATE TABLE OrderDetails
(
    OrderDetailID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    UnitPrice DECIMAL(10,2)
);
GO

-- 6. Payment table
CREATE TABLE Payment
(
    PaymentID INT PRIMARY KEY,
    OrderID INT,
    PaymentMethod VARCHAR(50) NOT NULL,
    PaymentDate DATE NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (OrderID)
        REFERENCES Orders(OrderID)
);
GO
