--This sets the default database to RetailDB
use RETAILDB;
--This construct defines the structure for product category
create table productcategory
(
ID INT IDENTITY(1,1),
CategoryID CHAR(4) NOT NULL,
Category VARCHAR(50) NOT NULL,
PRIMARY KEY(CategoryID)
);

create table products
(
ID INT IDENTITY(1,1),
ProductID CHAR(3) NOT NULL,
ProductName VARCHAR(50) NOT NULL,
CategoryID CHAR(4) NOT NULL,
CostPrice MONEY DEFAULT 0.00,
SellingPrice MONEY DEFAULT 0.00,
PRIMARY KEY(ProductID),
FOREIGN KEY (CategoryID) REFERENCES productcategory(CategoryID),
CHECK (CostPrice >= 0),
CHECK (SellingPrice >= 0),
CHECK (SellingPrice >= CostPrice)
);

CREATE TABLE supplier
(
ID INT IDENTITY(1,1),
SupplierID CHAR(3) NOT NULL,
SupplierName VARCHAR(50) NOT NULL,
ContactAddress VARCHAR(50) NOT NULL,
City VARCHAR(50) NOT NULL,
PhoneNo CHAR(11) NOT NULL,
Email VARCHAR(50) NOT NULL,
PRIMARY KEY (SupplierID)
);

CREATE TABLE WareHouse
(
ID BIGINT IDENTITY(1,1),
WareHouseID CHAR(3) NOT NULL,
LocationDetail VARCHAR(50) NOT NULL,
PRIMARY KEY (WareHouseId)
);

CREATE TABLE supply
(
ID BIGINT IDENTITY(1,1),
SupplyID VARCHAR(15) NOT NULL,
SupplierID CHAR(3) NOT NULL,
SupplyDate DATE NOT NULL,
SupplyTotal MONEY DEFAULT 0.00,
PRIMARY KEY (SupplyID),
FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID),
CHECK (SupplyTotal >=0),
CHECK (SupplyDate <= GETDATE()),
);

CREATE TABLE supplydetails
(
ID BIGINT IDENTITY(1,1),
SupplyID VARCHAR(15) NOT NULL,
ProductID CHAR(3) NOT NULL,
Quantity FLOAT DEFAULT 0.00,
CostPrice MONEY DEFAULT 0.00,
WareHouseID CHAR(3) NOT NULL,
FOREIGN KEY (SupplyID) REFERENCES Supply(SupplyID),
FOREIGN KEY (ProductID) REFERENCES Products(Productid),
FOREIGN KEY (WareHouseID) REFERENCES WareHouse(WareHouseID)
);

 CREATE TABLE staff
(
 ID INT IDENTITY(1,1),
 StaffID VARCHAR(10) NOT NULL,
 FirstName VARCHAR(50) NOT NULL,
 LastName VARCHAR(50) NOT NULL,
 HireDate DATE DEFAULT GETDATE(),
 Gender VARCHAR(6),
 PRIMARY KEY(StaffID)
);
 CREATE TABLE Customer
(
 ID INT IDENTITY(1,1),
 CustomerID VARCHAR(10) NOT NULL,
 FirstName VARCHAR(50) NOT NULL,
 LastName VARCHAR(50) NOT NULL,
 HireDate DATE DEFAULT GETDATE(),
 Gender VARCHAR(6),
 PhoneNo CHAR(11),
 Email VARCHAR(50),
 ContactAddress VARCHAR(100),
 City VARCHAR(20),
 PRIMARY KEY(CustomerID)
 );

CREATE TABLE orders
(
ID BIGINT IDENTITY(1,1),
OrderID VARCHAR(15) NOT NULL,
CustomerID VARCHAR(10) NOT NULL,
OrderDate DATE NOT NULL,
OrderTotal MONEY DEFAULT 0.00,
PRIMARY KEY (OrderID),
FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
CHECK (OrderTotal >=0),
CHECK (OrderDate <= GETDATE())
);

CREATE TABLE Orderdetails
(
ID BIGINT IDENTITY(1,1),
OrderID VARCHAR(15) NOT NULL,
ProductID CHAR(3) NOT NULL,
Quantity FLOAT DEFAULT 0.00,
SellingPrice MONEY DEFAULT 0.00,
FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

