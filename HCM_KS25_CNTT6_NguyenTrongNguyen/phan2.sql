CREATE DATABASE phan2;
USE phan2;

CREATE TABLE Product (
productID VARCHAR(10) PRIMARY KEY,
productName VARCHAR(255) NOT NULL,
manufacturer VARCHAR(100),
Price DECIMAL(12,2) CHECK (Price >=0),
StockQty INT CHECK (StockQty >= 0)
);

CREATE TABLE Customer(
CustomerID VARCHAR(10) PRIMARY KEY,
FullName VARCHAR(255) NOT NULL,
Email VARCHAR(255) UNIQUE,
Phone VARCHAR(20),
Address VARCHAR(255)
);

CREATE TABLE orderr(
OrderID VARCHAR(10) PRIMARY KEY,
Orderdate DATE,
TotalAmount DECIMAL(12,2),
CustomerID VARCHAR(10),
FOREIGN KEY(CustomerID)
REFERENCES Customer(CustomerID)
);

CREATE TABLE Orderr_Detail(
OrderID VARCHAR (10),
ProductID VARCHAR (10),
Quantity INT CHECK (Quantity > 0),

);

