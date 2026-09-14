-- SalesAnalytics Project
-- Sample data for the portfolio project.

USE SalesAnalytics;
GO

INSERT INTO Customers
(CustomerID, CustomerName, City, State)
VALUES
(1, 'John Smith', 'Columbus', 'Ohio'),
(2, 'Sarah Johnson', 'Cleveland', 'Ohio'),
(3, 'Michael Brown', 'Chicago', 'Illinois'),
(4, 'Emily Davis', 'Detroit', 'Michigan'),
(5, 'David Wilson', 'Columbus', 'Ohio');
GO

INSERT INTO Products
(ProductID, ProductName, Category, Price)
VALUES
(1, 'Laptop', 'Electronics', 899.99),
(2, 'Wireless Mouse', 'Electronics', 29.99),
(3, 'Office Chair', 'Furniture', 199.99),
(4, 'Desk', 'Furniture', 349.99),
(5, 'Keyboard', 'Electronics', 59.99),
(6, 'Monitor', 'Electronics', 299.99);
GO

INSERT INTO Orders
(OrderID, CustomerID, OrderDate)
VALUES
(101, 1, '2026-01-05'),
(102, 2, '2026-01-08'),
(103, 1, '2026-01-15'),
(104, 3, '2026-02-02'),
(105, 5, '2026-02-10'),
(106, 2, '2026-02-18');
GO

INSERT INTO OrderDetails
(OrderDetailID, OrderID, ProductID, Quantity, UnitPrice)
VALUES
(1, 101, 1, 1, 899.99),
(2, 101, 2, 2, 29.99),
(3, 102, 3, 1, 199.99),
(4, 103, 5, 2, 59.99),
(5, 104, 4, 1, 349.99),
(6, 105, 6, 2, 299.99),
(7, 106, 2, 1, 29.99);
GO
