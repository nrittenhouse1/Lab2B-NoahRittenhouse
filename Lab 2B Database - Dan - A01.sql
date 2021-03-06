IF DB_ID('1508_Lab2A_BooksGalore') IS NULL
	CREATE DATABASE [1508_Lab2A_BooksGalore]
GO
USE [1508_Lab2A_BooksGalore]
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'SaleDetails')
    DROP TABLE [SaleDetails]
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Sales')
    DROP TABLE [Sales]
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'BookAuthors')
    DROP TABLE [BookAuthors]
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Books')
    DROP TABLE [Books]
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Authors')
    DROP TABLE [Authors]
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Publishers')
    DROP TABLE [Publishers]
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Customers')
    DROP TABLE [Customers]
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Categories')
    DROP TABLE [Categories]
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Employees')
    DROP TABLE [Employees]
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'EmployeeGroups')
    DROP TABLE [EmployeeGroups]


/****** Object:  Table [dbo].[EmployeeGroups]    Script Date: 2/7/2018 9:22:27 AM ******/
CREATE TABLE [dbo].[EmployeeGroups](
	[GroupCode] [char](1)
     CONSTRAINT [PK_EmployeeGroups] PRIMARY KEY CLUSTERED 
     NOT NULL,
	[Name] [nvarchar](30) NOT NULL,
	[Wage] [smallmoney] NOT NULL,
)
GO
/****** Object:  Table [dbo].[Employees]    Script Date: 2/7/2018 9:22:27 AM ******/
CREATE TABLE [dbo].[Employees](
	[EmployeeNumber] [int]
     CONSTRAINT [PK_employee] PRIMARY KEY CLUSTERED 
     IDENTITY(300,1) NOT NULL,
	[SIN] [char](9) NOT NULL,
	[LastName] [varchar](30) NOT NULL,
	[FirstName] [varchar](30) NOT NULL,
	[Address] [varchar](40) NOT NULL,
	[City] [varchar](20) NULL,
	[Province] [char](2)
    CONSTRAINT [df_employee_province]  DEFAULT ('AB')
     NULL,
	[PostalCode] [char](6)
    CONSTRAINT [CK_postal_emp158] CHECK  (([postalcode] like '[a-z][0-9][a-z][0-9][a-z][0-9]'))
     NULL,
	[HomePhone] [char](10)
    CONSTRAINT [CK_Employee_Home_phone] CHECK  (([HomePhone] like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'))
     NULL,
	[workPhone] [char](10)
    CONSTRAINT [CK_Employee_Work_phone] CHECK  (([WorkPhone] like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'))
     NULL,
	[Email] [varchar](30) NULL,
)
GO
/****** Object:  Table [dbo].[Categories]    Script Date: 2/7/2018 9:22:27 AM ******/
CREATE TABLE [dbo].[Categories](
	[categoryCode] [int]
     CONSTRAINT [PK_category] PRIMARY KEY CLUSTERED 
     IDENTITY(1,1) NOT NULL,
	[Description] [varchar](40) NOT NULL,
)
GO
/****** Object:  Table [dbo].[Customers]    Script Date: 2/7/2018 9:22:27 AM ******/
CREATE TABLE [dbo].[Customers](
	[CustomerNumber] [int]
     CONSTRAINT [PK_customer] PRIMARY KEY CLUSTERED 
     IDENTITY(1,1) NOT NULL,
	[LastName] [varchar](30) NOT NULL,
	[FirstName] [varchar](30) NOT NULL,
	[Address] [varchar](40) NOT NULL,
	[City] [varchar](20) NULL,
	[Province] [char](2)
    CONSTRAINT [df_customer_province]  DEFAULT ('AB')
     NULL,
	[PostalCode] [char](6) 
    CONSTRAINT [CK_postal_cust] CHECK  (([postalcode] like '[a-z][0-9][a-z][0-9][a-z][0-9]'))
    NULL,
	[HomePhone] [char](10)
    CONSTRAINT [CK_Customer_Home_phone] CHECK  (([HomePhone] like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'))
     NULL,
)
GO
/****** Object:  Table [dbo].[Publishers]    Script Date: 2/7/2018 9:22:27 AM ******/
CREATE TABLE [dbo].[Publishers](
	[PublisherCode] [int]
     CONSTRAINT [PK_publisher] PRIMARY KEY CLUSTERED 
     IDENTITY(200,1) NOT NULL,
	[Name] [varchar](40) NOT NULL,
)
GO
/****** Object:  Table [dbo].[Authors]    Script Date: 2/7/2018 9:22:27 AM ******/
CREATE TABLE [dbo].[Authors](
	[AuthorCode] [int]
    CONSTRAINT [PK_author] PRIMARY KEY
     IDENTITY(100,1) NOT NULL,
	[LastName] [varchar](30) NOT NULL,
	[FirstName] [varchar](30) NOT NULL,
)
GO
/****** Object:  Table [dbo].[Books]    Script Date: 2/7/2018 9:22:27 AM ******/
CREATE TABLE [dbo].[Books](
	[ISBN] [char](10)
    CONSTRAINT [PK_title] PRIMARY KEY CLUSTERED 
     NOT NULL,
	[Title] [varchar](40) NOT NULL,
	[CategoryCode] [int]
    CONSTRAINT [fk_category] FOREIGN KEY([CategoryCode])
REFERENCES [dbo].[Categories] ([categoryCode])
     NOT NULL,
	[PublisherCode] [int]
    CONSTRAINT [fk_publisher] FOREIGN KEY([PublisherCode])
REFERENCES [dbo].[Publishers] ([PublisherCode])
     NOT NULL,
	[SuggestedPrice] [money]
    CONSTRAINT [DF_sellprice]  DEFAULT ((0))
     NOT NULL,
	[NumberInStock] [int] 
    CONSTRAINT [DF_stock]  DEFAULT ((0))
    CONSTRAINT [ck_numberinstock] CHECK  (([numberinstock]>=(0)))
    NOT NULL,
)
GO
/****** Object:  Table [dbo].[BookAuthors]    Script Date: 2/7/2018 9:22:27 AM ******/
CREATE TABLE [dbo].[BookAuthors](
	[AuthorCode] [int]
    CONSTRAINT [FK_auCode] FOREIGN KEY([AuthorCode])
REFERENCES [dbo].[Authors] ([AuthorCode])
     NOT NULL,
	[ISBN] [char](10)
    CONSTRAINT [FK_ISBN] FOREIGN KEY([ISBN])
REFERENCES [dbo].[Books] ([ISBN])
     NOT NULL,
 CONSTRAINT [PK_authortitle] PRIMARY KEY CLUSTERED 
(
	[AuthorCode],
	[ISBN]
)
)
GO
/****** Object:  Table [dbo].[Sales]    Script Date: 2/7/2018 9:22:27 AM ******/
CREATE TABLE [dbo].[Sales](
	[SaleNumber] [int]
     CONSTRAINT [PK_sale] PRIMARY KEY CLUSTERED 
     IDENTITY(3000,1) NOT NULL,
	[Date] [datetime] NOT NULL,
	[CustomerNumber] [int]
    CONSTRAINT [FK_customer] FOREIGN KEY([CustomerNumber])
REFERENCES [dbo].[Customers] ([CustomerNumber])
     NOT NULL,
	[EmployeeNumber] [int]
    CONSTRAINT [FK_employee] FOREIGN KEY([EmployeeNumber])
REFERENCES [dbo].[Employees] ([EmployeeNumber])
     NOT NULL,
	[SubTotal] [money] NOT NULL,
	[GST] [money] NOT NULL,
	[Total] [money] NOT NULL,
    CONSTRAINT [ck_total_subtotal] CHECK  (([Total]>=[Subtotal]))
)

GO
/****** Object:  Table [dbo].[SaleDetails]    Script Date: 2/7/2018 9:22:27 AM ******/
CREATE TABLE [dbo].[SaleDetails](
	[SaleNumber] [int]
    CONSTRAINT [FK_saleNum] FOREIGN KEY([SaleNumber])
REFERENCES [dbo].[Sales] ([SaleNumber])
     NOT NULL,
	[ISBN] [char](10)
    CONSTRAINT [FK_employee_saledetail] FOREIGN KEY([ISBN])
REFERENCES [dbo].[Books] ([ISBN])
     NOT NULL,
	[SellingPrice] [money] NOT NULL,
	[Quantity] [int] NOT NULL,
	[Amount] [money] NOT NULL,
 CONSTRAINT [PK_saledetail] PRIMARY KEY CLUSTERED 
(	[SaleNumber] ,	[ISBN] )
)
GO

/* Alter Tables */
ALTER TABLE Customers
	ADD WorkPhone char(10) NULL
ALTER TABLE Customers
	ADD Email varchar(30) NULL
		CONSTRAINT CK_Customers_Email
			CHECK (Email LIKE '___%@___%.__%')
ALTER TABLE Employees
	ADD Active char(1) NOT NULL
		CONSTRAINT DF_Employees_Active DEFAULT ('Y')
GO
/* ************************************************************************* */

Insert INTO Authors (LastName,FirstName) values ('Smith', 'Sam')
Insert INTO Authors (LastName,FirstName) values ('Green', 'George')
Insert INTO Authors (LastName,FirstName)values ('Jones', 'John')
Insert INTO Authors (LastName,FirstName)values ('Davidson', 'David')
Insert INTO Authors (LastName,FirstName)values ('Robertson', 'Rob')
Insert INTO Authors (LastName,FirstName)values ('Abbot', 'Abe')
Insert INTO Authors (LastName,FirstName)values ('Baker', 'Bob')
Insert INTO Authors (LastName,FirstName)values ('Cater', 'Clem')
Insert INTO Authors (LastName,FirstName)values ('Semenko',    'Dave')
Insert INTO Authors (LastName,FirstName)values ('Frank', 'Fran')
Insert INTO Authors (LastName,FirstName)values ('Horton', 'Harry')
Insert INTO Authors (LastName,FirstName)values ('Kelly', 'Kevin')
Insert INTO Authors (LastName,FirstName)values ('Lambert', 'Larry')
Insert INTO Authors (LastName,FirstName)values ('Johnson', 'Jon')
Insert INTO Authors (LastName,FirstName)values ('Anderson', 'Ander')
Insert INTO Authors (LastName,FirstName)values ('Peterson', 'Peter')
Insert INTO Authors (LastName,FirstName)values ('Jensen', 'Jens')
Insert INTO Authors (LastName,FirstName)values ('Issacsen', 'Issac')

Insert INTO Publishers (Name) values ('Addison Westley')
Insert INTO Publishers (Name) values ('SAMS')
Insert INTO Publishers (Name) values ('Harlequin')
Insert INTO Publishers (Name)values ('Self Publish Inc')
Insert INTO Publishers (Name)values ('Microsoft Press')
Insert INTO Publishers (Name)values ('Jones and Bartlett')
Insert INTO Publishers (Name)values ('WROX')
Insert INTO Publishers (Name)values ('West')
Insert INTO Publishers (Name)values ('Premier')

Insert INTO Categories (Description) values ('Computers')
Insert INTO Categories (Description) values ('Business')
Insert INTO Categories (Description) values ('Human Relations')
Insert INTO Categories (Description) values ('Electronics')
Insert INTO Categories (Description) values ('Design')
Insert INTO Categories (Description) values ('Miscellaneous')
Insert INTO Categories (Description) values ('Media Design')
Insert INTO Categories (Description) values ('Information Technology')

Insert INTO Employees (SIN, LastName, FirstName, Address, City, Province, PostalCode, HomePhone, workPhone, Email)  values ('666555444', 'Zinick', 'Zeb',      '12345 67 St',	 'Edmonton', 'AB', 'T5J1X1', '7806665555', '7809976666', 'Zebz@hotmail.com')
Insert INTO Employees (SIN, LastName, FirstName, Address, City, Province, PostalCode, HomePhone, workPhone, Email) values ('666555444', 'Young', 'Yanny',     '12345 77 St', 	 'Edmonton', 'AB', 'T5J1X2', '7806664433', '7809971234', 'yannyy@hotmail.com')
Insert INTO Employees (SIN, LastName, FirstName, Address, City, Province, PostalCode, HomePhone, workPhone, Email) values ('666555444', 'Winters', 'Willy',   '12345 87 St', 	 'Edmonton', 'AB', 'T5J1X3', '7806665544', '7809972345', 'willyw@hotmail.com')
Insert INTO Employees (SIN, LastName, FirstName, Address, City, Province, PostalCode, HomePhone, workPhone, Email) values ('666555444', 'Verse', 'Vinny',     '12345 97 St', 	 'Edmonton', 'AB', 'T5J1X4', '7806666655', '7809973456', 'vinnyv@hotmail.com')
Insert INTO Employees (SIN, LastName, FirstName, Address, City, Province, PostalCode, HomePhone, workPhone, Email) values ('666555444', 'Unger', 'Ursella',   '12345 107 St',	 'Edmonton', 'AB', 'T5J1X5', '7806667766', '7809974567', 'ursellau@hotmail.com')
Insert INTO Employees (SIN, LastName, FirstName, Address, City, Province, PostalCode, HomePhone, workPhone, Email) values ('666555444', 'Tucker', 'Tom',      '12345 57 St', 	 'Edmonton', 'AB', 'T5J1X6', '7806668877', '7809975678', 'tomt@hotmail.com')
Insert INTO Employees (SIN, LastName, FirstName, Address, City, Province, PostalCode, HomePhone, workPhone, Email) values ('666555444', 'Stevenson', 'Steve', '12345 47 St', 	 'Edmonton', 'AB', 'T5J1X7', '7806669988', '7809976789', 'steves@hotmail.com')
Insert INTO Employees (SIN, LastName, FirstName, Address, City, Province, PostalCode, HomePhone, workPhone, Email) values ('666555444', 'Sun', 'Sam',         '12345 117 St',	 'Edmonton', 'AB', 'T5J1X8', '7806660099', '7809977890', 'sams@hotmail.com')
Insert INTO Employees (SIN, LastName, FirstName, Address, City, Province, PostalCode, HomePhone, workPhone, Email) values ('666555444', 'Gretzki', 'Wayne',   '12345 22 Avenue',   'Edmonton', 'AB', 'T5J1X4', '7806666641', '7809973401', 'wayneg@gmail.com')
Insert INTO Employees (SIN, LastName, FirstName, Address, City, Province, PostalCode, HomePhone, workPhone, Email) values ('666555444', 'Coffee', 'Ron',	    '12345 122 Avenue',  'Edmonton', 'AB', 'T5J1X5', '7806667740', '7809974523', 'rcoffee@gmail.com')
Insert INTO Employees (SIN, LastName, FirstName, Address, City, Province, PostalCode, HomePhone, workPhone, Email) values ('666555444', 'Lowe', 'Kevin',      '12345 56 Avenue',   'Edmonton', 'AB', 'T5J1X6', '7806668839', '7809975634', 'kevinl@hotmail.com')
Insert INTO Employees (SIN, LastName, FirstName, Address, City, Province, PostalCode, HomePhone, workPhone, Email) values ('666555444', 'Dryden', 'Dave',     '12345 100 Avenue',  'Edmonton', 'AB', 'T5J1X7', '7806669938', '7809976735', 'ddry@hotmail.com')
Insert INTO Employees (SIN, LastName, FirstName, Address, City, Province, PostalCode, HomePhone, workPhone, Email) values ('666555444', 'Kurri', 'Jari',      '12345 78 Avenue',   'Edmonton', 'AB', 'T5J1X8', '7806660037', '7809977836', 'jarikur@hotmail.com')
Insert INTO Employees (SIN, LastName, FirstName, Address, City, Province, PostalCode, HomePhone, workPhone, Email) values ('666555444', 'Thirteen', 'Lucky',      '12345 70 Avenue',   'Edmonton', 'AB', 'T5J1X0', '7806660030', '7809977830', 'lucky13@hotmail.com')

Insert INTO Customers (LastName, FirstName, Address, City, PRovince, PostalCode, HomePhone, WorkPhone, EMail)  values ('Gretzki', 'Wayne',   '5678 - 123 Ave', 'Edmonton', 'AB', 'T5R1B1', '7807771234', '7897871122', 'russr@shaw.ca')
Insert INTO Customers (LastName, FirstName, Address, City, PRovince, PostalCode, HomePhone, WorkPhone, EMail) values ('Potter',   'Harry',  '5678 - 123 Ave', 'Edmonton', 'AB', 'T5R1B2', '7807772345', '7897872122', 'hpotter@gmail.com')
Insert INTO Customers (LastName, FirstName, Address, City, PRovince, PostalCode, HomePhone, WorkPhone, EMail) values ('Overland', 'Miles',  '5678 - 123 Ave', 'Edmonton', 'AB', 'T5R1B3', '7807771245', '7897874122', 'mileso@shaw.ca')
Insert INTO Customers (LastName, FirstName, Address, City, PRovince, PostalCode, HomePhone, WorkPhone, EMail) values ('North',    'Nathan', '5678 - 123 Ave', 'Edmonton', 'AB', 'T5R1B4', '7807775432', '7897871422', 'nnorth@shaw.ca')
Insert INTO Customers (LastName, FirstName, Address, City, PRovince, PostalCode, HomePhone, WorkPhone, EMail) values ('Morton',   'Milley', '5678 - 123 Ave', 'Edmonton', 'AB', 'T5R1B5', '7807776543', '7897871142', 'mmorton@gmail.com')
Insert INTO Customers (LastName, FirstName, Address, City, PRovince, PostalCode, HomePhone, WorkPhone, EMail) values ('Lancelot', 'Cruse',  '5678 - 123 Ave', 'Edmonton', 'AB', 'T5R1B6', '7807773456', '7897871124', 'mmorton@shaw.ca')
Insert INTO Customers (LastName, FirstName, Address, City, PRovince, PostalCode, HomePhone, WorkPhone, EMail) values ('Kettle',   'P. A.',  '5678 - 123 Ave', 'Edmonton', 'AB', 'T5R1B7', '7807774567', '7897875122', 'pak@shaw.ca')
Insert INTO Customers (LastName, FirstName, Address, City, PRovince, PostalCode, HomePhone, WorkPhone, EMail) values ('Great', 'Wayne',   '5678 - 123 Ave', 'Edmonton', 'AB', 'T5R1B8', '7807777654', '7897871522', 'johnj@shaw.ca')
Insert INTO Customers (LastName, FirstName, Address, City, PRovince, PostalCode, HomePhone, WorkPhone, EMail) values ('Innes',    'Isabel', '5678 - 123 Ave', 'Edmonton', 'AB', 'T5R1B9', '7807771236', '7897871152', 'iines@shaw.ca')
Insert INTO Customers (LastName, FirstName, Address, City, PRovince, PostalCode, HomePhone, WorkPhone, EMail) values ('Hanson',   'Hans',   '5678 - 123 Ave', 'Edmonton', 'AB', 'T5R2B1', '7807771237', '7897871125', 'hansh@shaw.ca')
Insert INTO Customers (LastName, FirstName, Address, City, PRovince, PostalCode, HomePhone, WorkPhone, EMail) values ('Guest',    'Guss',   '5678 - 123 Ave', 'Edmonton', 'AB', 'T5R3C1', '7807771238', '7897876122', 'gussg@shaw.ca')
Insert INTO Customers (LastName, FirstName, Address, City, PRovince, PostalCode, HomePhone, WorkPhone, EMail) values ('Forest',   'Fern',   '5678 - 123 Ave', 'Edmonton', 'AB', 'T5R4C1', '7807771239', '7897871622', 'fernf@shaw.ca')
Insert INTO Customers (LastName, FirstName, Address, City, PRovince, PostalCode, HomePhone, WorkPhone, EMail) values ('Evans',    'Even',   '5678 - 123 Ave', 'Edmonton', 'AB', 'T5R5B1', '7807771230', '7897871162', 'evene@shaw.ca')
Insert INTO Customers (LastName, FirstName, Address, City, PRovince, PostalCode, HomePhone, WorkPhone, EMail) values ('Drake',    'Doris',  '5678 - 123 Ave', 'Edmonton', 'AB', 'T5R6B1', '7807771288', '7897871126', 'ddrake@hotmail.com')
Insert INTO Customers (LastName, FirstName, Address, City, PRovince, PostalCode, HomePhone, WorkPhone, EMail) values ('Cotter',   'Cal',    '5678 - 123 Ave', 'Edmonton', 'AB', 'T5R7B1', '7807771777', '7897877122', 'calc@shaw.ca')
Insert INTO Customers (LastName, FirstName, Address, City, PRovince, PostalCode, HomePhone, WorkPhone, EMail) values ('Benson',   'Ben',    '5678 - 123 Ave', 'Edmonton', 'AB', 'T5R8B1', '7807771785', '7897871722', 'benb@hotmail.com')
Insert INTO Customers (LastName, FirstName, Address, City, PRovince, PostalCode, HomePhone, WorkPhone, EMail) values ('Apple',    'Andy',   '5678 - 123 Ave', 'Edmonton', 'AB', 'T5R9B1', '7807771456', '7897871172', 'andya@shaw.ca')
Insert INTO Customers (LastName, FirstName, Address, City, PRovince, PostalCode, HomePhone, WorkPhone, EMail) values ('Kay', 'Jari',   '5678 - 123 Ave', 'Edmonton', 'AB', 'T5R0B1', '7807771455', '7897871127', 'billb@shaw.ca')
Insert INTO Customers (LastName, FirstName, Address, City, PRovince, PostalCode, HomePhone, WorkPhone, EMail) values ('Kurri', 'Jari',  '5678 - 123 Ave', 'Edmonton', 'AB', 'T5R3F1', '7807771223', '7897878122', 'ccrane@hotmail.com')
Insert INTO Customers (LastName, FirstName, Address, City, PRovince, PostalCode, HomePhone, WorkPhone, EMail) values ('Dove',     'Dave',   '5678 - 123 Ave', 'Edmonton', 'AB', 'T5R4R1', '7807771986', '7897871822', 'ddove@shaw.ca')
Insert INTO Customers (LastName, FirstName, Address, City, PRovince, PostalCode, HomePhone, WorkPhone, EMail) values ('Anderson',  'Glen',   '5678 - 123 Ave', 'Edmonton', 'AB', 'T5R1B1', '7807771234', '7897871122', 'dsem@shaw.ca')
Insert INTO Customers (LastName, FirstName, Address, City, PRovince, PostalCode, HomePhone, WorkPhone, EMail) values ('Coffey',   'Paul', 	 '5678 - 123 Ave', 'Edmonton', 'AB', 'T5R1B2', '7807772345', '7897872122', 'glenandr@shaw.ca')
Insert INTO Customers (LastName, FirstName, Address, City, PRovince, PostalCode, HomePhone, WorkPhone, EMail) values ('Price', 'Pat', 	 '5678 - 123 Ave', 'Edmonton', 'AB', 'T5R1B3', '7807771245', '7897874122', 'pcof@shaw.ca')
Insert INTO Customers (LastName, FirstName, Address, City, PRovince, PostalCode, HomePhone, WorkPhone, EMail) values ('Semenko',    'Dave',	 '5678 - 123 Ave', 'Edmonton', 'AB', 'T5R1B4', '7807775432', '7897871422', 'atprice@shaw.ca')
Insert INTO Customers (LastName, FirstName, Address, City, PRovince, PostalCode, HomePhone, WorkPhone, EMail) values ('Huddy',   'Charlie', 	'5678 - 123 Ave', 'Edmonton', 'AB', 'T5R1B5', '7807776543', '7897871142', 'chud@shaw.ca')
Insert INTO Customers (LastName, FirstName, Address, City, PRovince, PostalCode, HomePhone, WorkPhone, EMail) values ('Low', 'Ron',  	'5678 - 123 Ave', 'Edmonton', 'AB', 'T5R1B6', '7807773456', '7897871124', 'ronl@gmail.com')
Insert INTO Customers (LastName, FirstName, Address, City, PRovince, PostalCode, HomePhone, WorkPhone, EMail) values ('Simpson', 'Homer',  	'5432 - 123 Ave', 'Edmonton', 'AB', 'T5R1B6', '7807773456', '7897871124', 'simpone@gmail.com')
Insert INTO Customers (LastName, FirstName, Address, City, PRovince, PostalCode, HomePhone, WorkPhone, EMail) values ('Claus', 'Santa',  	'5678 - 123 Ave', 'Edmonton', 'AB', 'T5R1B6', '7807773456', '7897871124', 'SantaC@gmail.com')
Insert INTO Customers (LastName, FirstName, Address, City, PRovince, PostalCode, HomePhone, WorkPhone, EMail) values ('Horton', 'Tim',  	'5678 - 123 Ave', 'Edmonton', 'AB', 'T5R1B6', '7807773456', '7897871124', 'TimG@gmail.com')

Insert INTO Books (ISBN, Title, CategoryCode, PublisherCode, SuggestedPrice, NumberInStock) values ('1021031040', 'PL SQL', 1, 200, 75.50, 10)
Insert INTO Books (ISBN, Title, CategoryCode, PublisherCode, SuggestedPrice, NumberInStock) values ('1021031041', 'SQL in 30 days',      1, 201, 90.00, 12)
Insert INTO Books (ISBN, Title, CategoryCode, PublisherCode, SuggestedPrice, NumberInStock) values ('1021031042', 'Visual Basic .Net',   1, 202, 95.00, 15)
Insert INTO Books (ISBN, Title, CategoryCode, PublisherCode, SuggestedPrice, NumberInStock) values ('1021031043', 'Pascal',              1, 203, 178.40, 6)
Insert INTO Books (ISBN, Title, CategoryCode, PublisherCode, SuggestedPrice, NumberInStock) values ('1021031044', 'Introduction to .net',1, 204, 70.00, 7)
Insert INTO Books (ISBN, Title, CategoryCode, PublisherCode, SuggestedPrice, NumberInStock) values ('1021031045', 'VB.Net for Business', 1, 205, 99.00, 8)
Insert INTO Books (ISBN, Title, CategoryCode, PublisherCode, SuggestedPrice, NumberInStock) values ('1021031046', 'Programming for Bus', 1, 200, 78.00, 10)
Insert INTO Books (ISBN, Title, CategoryCode, PublisherCode, SuggestedPrice, NumberInStock) values ('1021031047', 'Java',                1, 201, 67.30, 10)
Insert INTO Books (ISBN, Title, CategoryCode, PublisherCode, SuggestedPrice, NumberInStock) values ('1021031048', 'Java Beans',          1, 202, 70.00, 2)
Insert INTO Books (ISBN, Title, CategoryCode, PublisherCode, SuggestedPrice, NumberInStock) values ('1021031049', 'Flowcharting',        1, 203, 75.00, 12)
Insert INTO Books (ISBN, Title, CategoryCode, PublisherCode, SuggestedPrice, NumberInStock) values ('1021031050', 'Structured Charts',   1, 204, 145.00, 10)
Insert INTO Books (ISBN, Title, CategoryCode, PublisherCode, SuggestedPrice, NumberInStock) values ('1021031051', 'Object Code',         1, 205,23.00, 10)
Insert INTO Books (ISBN, Title, CategoryCode, PublisherCode, SuggestedPrice, NumberInStock) values ('1021031052', 'MS SQL',              1, 205, 12.00, 15)
Insert INTO Books (ISBN, Title, CategoryCode, PublisherCode, SuggestedPrice, NumberInStock) values ('1021031053', 'Database Management', 1, 204, 56.00, 10)
Insert INTO Books (ISBN, Title, CategoryCode, PublisherCode, SuggestedPrice, NumberInStock) values ('1021031054', 'Oracle',              4, 203, 80.00, 5)
Insert INTO Books (ISBN, Title, CategoryCode, PublisherCode, SuggestedPrice, NumberInStock) values ('1021031055', 'Oracle in 21 days',   4, 202, 90.00, 10)
Insert INTO Books (ISBN, Title, CategoryCode, PublisherCode, SuggestedPrice, NumberInStock) values ('1021031056', 'Accounting Basics',   2, 201, 80.00, 5)
Insert INTO Books (ISBN, Title, CategoryCode, PublisherCode, SuggestedPrice, NumberInStock) values ('1021031057', 'Intro to Acct',       2, 200, 80.00, 6)
Insert INTO Books (ISBN, Title, CategoryCode, PublisherCode, SuggestedPrice, NumberInStock) values ('1021031058', 'Intermediate Acct',   2, 200, 90.00, 7)
Insert INTO Books (ISBN, Title, CategoryCode, PublisherCode, SuggestedPrice, NumberInStock) values ('1021031059', 'Advanced Accounting', 2, 201, 70.00, 0)
Insert INTO Books (ISBN, Title, CategoryCode, PublisherCode, SuggestedPrice, NumberInStock) values ('1021031061', 'Management Principles',2, 202, 80.00, 0)
Insert INTO Books (ISBN, Title, CategoryCode, PublisherCode, SuggestedPrice, NumberInStock) values ('1021031063', 'Marketing Now',       2, 203, 80.00, 10)
Insert INTO Books (ISBN, Title, CategoryCode, PublisherCode, SuggestedPrice, NumberInStock) values ('1021031064', 'Bus Communications',  2, 203, 80.00, 5)
Insert INTO Books (ISBN, Title, CategoryCode, PublisherCode, SuggestedPrice, NumberInStock) values ('1021031065', 'Corporate Law',       2, 204, 99.00, 6)
Insert INTO Books (ISBN, Title, CategoryCode, PublisherCode, SuggestedPrice, NumberInStock) values ('1021031066', 'Circuts',             4, 205, 80.00, 7)
Insert INTO Books (ISBN, Title, CategoryCode, PublisherCode, SuggestedPrice, NumberInStock) values ('1021031068', 'Circut Design',       4, 205, 80.00, 8)
Insert INTO Books (ISBN, Title, CategoryCode, PublisherCode, SuggestedPrice, NumberInStock) values ('1021031069', 'UML a new Approach',  5, 205, 35.00, 10)
Insert INTO Books (ISBN, Title, CategoryCode, PublisherCode, SuggestedPrice, NumberInStock) values ('1021031070', 'UML Basics',          5, 200, 45.00, 10)
Insert INTO Books (ISBN, Title, CategoryCode, PublisherCode, SuggestedPrice, NumberInStock) values ('1021031071', 'Business Life Cycle', 5, 200, 355.00, 10)
Insert INTO Books (ISBN, Title, CategoryCode, PublisherCode, SuggestedPrice, NumberInStock) values ('1021031072', 'C++',                 4, 201, 80.00, 2)
Insert INTO Books (ISBN, Title, CategoryCode, PublisherCode, SuggestedPrice, NumberInStock) values ('1021031073', 'Visual C',            4, 202, 80.00, 2)
Insert INTO Books (ISBN, Title, CategoryCode, PublisherCode, SuggestedPrice, NumberInStock) values ('1021031074', 'ADO.Net',             4, 203, 80.00, 0)
Insert INTO Books (ISBN, Title, CategoryCode, PublisherCode, SuggestedPrice, NumberInStock) values ('1021031075', 'Changing a Tire',     6, 204, 20.00, 1)
Insert INTO Books (ISBN, Title, CategoryCode, PublisherCode, SuggestedPrice, NumberInStock) values ('1021031076', 'Defensive Driving',   6, 205, 50.00, 2)
Insert INTO Books (ISBN, Title, CategoryCode, PublisherCode, SuggestedPrice, NumberInStock) values ('1021031077', 'The Art of Cooking',  6, 200, 40.00, 1)
Insert INTO Books (ISBN, Title, CategoryCode, PublisherCode, SuggestedPrice, NumberInStock) values ('1021031079', 'Baking Bread',        6, 201, 30.00, 1)
Insert INTO Books (ISBN, Title, CategoryCode, PublisherCode, SuggestedPrice, NumberInStock) values ('1021031200', 'Flash Beginners',     7, 205, 150.00, 7)
Insert INTO Books (ISBN, Title, CategoryCode, PublisherCode, SuggestedPrice, NumberInStock) values ('1021031201', 'Analysis of Business',8, 205, 180.00, 8)
Insert INTO Books (ISBN, Title, CategoryCode, PublisherCode, SuggestedPrice, NumberInStock) values ('1021031203', 'Php, Java and C#',    8, 205, 130.00, 10)
Insert INTO Books (ISBN, Title, CategoryCode, PublisherCode, SuggestedPrice, NumberInStock) values ('1021031204', 'SAD at NAIT',          8, 200, 10.00, 10)
Insert INTO Books (ISBN, Title, CategoryCode, PublisherCode, SuggestedPrice, NumberInStock) values ('1021031205', 'Business DATABASE',   8, 200, 190.00, 10)
Insert INTO Books (ISBN, Title, CategoryCode, PublisherCode, SuggestedPrice, NumberInStock) values ('1021031207', 'Oracle and Beyond',   8, 201, 120.00, 2)
Insert INTO Books (ISBN, Title, CategoryCode, PublisherCode, SuggestedPrice, NumberInStock) values ('1021031208', 'Flash and the Web',   7, 202, 130.00, 2)
Insert INTO Books (ISBN, Title, CategoryCode, PublisherCode, SuggestedPrice, NumberInStock) values ('1021031210', 'Web Design',          7, 203, 110.00, 0)
Insert INTO Books (ISBN, Title, CategoryCode, PublisherCode, SuggestedPrice, NumberInStock) values ('1021031211', 'Illustrator',     	   7, 204, 100.00, 1)
Insert INTO Books (ISBN, Title, CategoryCode, PublisherCode, SuggestedPrice, NumberInStock) values ('1021031212', 'Photoshop Starter',   7, 205, 150.00, 2)
Insert INTO Books (ISBN, Title, CategoryCode, PublisherCode, SuggestedPrice, NumberInStock) values ('1021031213', 'Flash and Fun',       7, 200, 140.00, 1)
Insert INTO Books (ISBN, Title, CategoryCode, PublisherCode, SuggestedPrice, NumberInStock) values ('1021031214', 'Indesign and Fun',    7, 201, 130.00, 1)

insert into BookAuthors (authorCode, ISBN) values (100, '1021031040') 
insert into BookAuthors (authorCode, ISBN)values (101, '1021031040') 
insert into BookAuthors (authorCode, ISBN)values (103, '1021031040') 
insert into BookAuthors (authorCode, ISBN)values (100, '1021031041') 
insert into BookAuthors (authorCode, ISBN)values (101, '1021031042') 
insert into BookAuthors (authorCode, ISBN)values (102, '1021031042') 
insert into BookAuthors (authorCode, ISBN)values (103, '1021031043') 
insert into BookAuthors (authorCode, ISBN)values (104, '1021031044') 
insert into BookAuthors (authorCode, ISBN)values (105, '1021031045') 
insert into BookAuthors (authorCode, ISBN)values (106, '1021031046') 
insert into BookAuthors (authorCode, ISBN)values (107, '1021031047') 
insert into BookAuthors (authorCode, ISBN)values (108, '1021031048') 
insert into BookAuthors (authorCode, ISBN)values (109, '1021031049') 
insert into BookAuthors (authorCode, ISBN)values (110, '1021031050') 
insert into BookAuthors (authorCode, ISBN)values (101, '1021031051') 
insert into BookAuthors (authorCode, ISBN)values (102, '1021031052') 
insert into BookAuthors (authorCode, ISBN)values (103, '1021031053') 
insert into BookAuthors (authorCode, ISBN)values (104, '1021031054') 
insert into BookAuthors (authorCode, ISBN)values (105, '1021031054') 
insert into BookAuthors (authorCode, ISBN)values (105, '1021031055') 
insert into BookAuthors (authorCode, ISBN)values (106, '1021031056') 
insert into BookAuthors (authorCode, ISBN)values (107, '1021031057') 
insert into BookAuthors (authorCode, ISBN)values (108, '1021031058') 
insert into BookAuthors (authorCode, ISBN)values (109, '1021031059')
insert into BookAuthors (authorCode, ISBN)values (110, '1021031059') 
insert into BookAuthors (authorCode, ISBN)values (100, '1021031061') 
insert into BookAuthors (authorCode, ISBN)values (101, '1021031063') 
insert into BookAuthors (authorCode, ISBN)values (102, '1021031064') 
insert into BookAuthors (authorCode, ISBN)values (103, '1021031065') 
insert into BookAuthors (authorCode, ISBN)values (104, '1021031066') 
insert into BookAuthors (authorCode, ISBN)values (105, '1021031068') 
insert into BookAuthors (authorCode, ISBN)values (106, '1021031069') 
insert into BookAuthors (authorCode, ISBN)values (107, '1021031070') 
insert into BookAuthors (authorCode, ISBN)values (108, '1021031071') 
insert into BookAuthors (authorCode, ISBN)values (109, '1021031072')
insert into BookAuthors (authorCode, ISBN)values (108, '1021031072') 
insert into BookAuthors (authorCode, ISBN)values (100, '1021031073') 
insert into BookAuthors (authorCode, ISBN)values (101, '1021031074') 
insert into BookAuthors (authorCode, ISBN)values (108, '1021031075') 
insert into BookAuthors (authorCode, ISBN)values (108, '1021031076') 
insert into BookAuthors (authorCode, ISBN)values (108, '1021031077') 
insert into BookAuthors (authorCode, ISBN)values (106, '1021031079') 
insert into BookAuthors (authorCode, ISBN)values (107, '1021031079') 
insert into BookAuthors (authorCode, ISBN)values (108, '1021031079') 



Insert INTO Sales(Date, CustomerNumber, EmployeeNumber, SubTotal, GST, total) Values  ( 'Dec 20, 2011',  1,  300,75.00, 3.75 , 78.75  )
Insert INTO SaleDetails (SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3000, 1021031079, 75.00,  1, 75.00)

Insert INTO Sales(Date, CustomerNumber, EmployeeNumber, SubTotal, GST, total) values ( 'Jan 10, 2012',  2,  301, 70.00, 3.50 , 73.50  )
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3001, 1021031077, 70.00,  1,70.00)
 

Insert INTO Sales(Date, CustomerNumber, EmployeeNumber, SubTotal, GST, total) values ( 'Jan 10, 2012',  3,  302, 70.00, 3.50 , 73.50  )
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3002, 1021031077, 70.00,  1,70.00)

Insert INTO Sales(Date, CustomerNumber, EmployeeNumber, SubTotal, GST, total) values ( 'Jan 10, 2012',  4,  303, 70.00, 3.50 , 73.50  )
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3003, 1021031076, 70.00,  1,70.00)

Insert INTO Sales(Date, CustomerNumber, EmployeeNumber, SubTotal, GST, total) values (  'Jan 10, 2012',  5,  304, 60.00, 3.00 , 63.00  )
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3004, 1021031076, 60.00,  1,60.00)

Insert INTO Sales(Date, CustomerNumber, EmployeeNumber, SubTotal, GST, total) values (  'Jan 10, 2012',  6,  305, 200.00, 10.00 ,210.00 )
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3005, 1021031075, 90.00,  1,90.00)
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3005, 1021031074, 60.00,  1,60.00)
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3005, 1021031073, 50.00,  1,50.00)

Insert INTO Sales(Date, CustomerNumber, EmployeeNumber, SubTotal, GST, total) values (  'Oct 10, 2012',  7,  306, 160.00, 8.00 , 168.00 )
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3006, 1021031072, 70.00,  1,70.00)
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3006, 1021031075, 90.00,  1,90.00)

Insert INTO Sales(Date, CustomerNumber, EmployeeNumber, SubTotal, GST, total) values (  'Oct 10, 2012',  8,  306, 200.00,  10.00 , 210.00 )
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3007, 1021031042, 100.00,  1,100.00)
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3007, 1021031043, 100.00,  1,100.00)

Insert INTO Sales(Date, CustomerNumber, EmployeeNumber, SubTotal, GST, total) values (  'Oct 10, 2012',  9,  305, 100.00,  5.00 , 105.00 )
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3008, 1021031074, 50.00,  1,50.00)
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3008, 1021031075, 50.00,  1,50.00)

Insert INTO Sales(Date, CustomerNumber, EmployeeNumber, SubTotal, GST, total) values (  'Oct 10, 2012',  10,  306, 200.00, 10.00 , 210.00     )
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3009, 1021031055, 80.00,  1,80.00)
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3009, 1021031054, 70.00,  1,70.00)
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3009, 1021031053, 50.00,  1,50.00)

Insert INTO Sales(Date, CustomerNumber, EmployeeNumber, SubTotal, GST, total) values (  'Oct 10, 2012',  11,  306, 50.00,  2.50 ,  52.50     )
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3010, 1021031053, 50.00,  1,50.00)

Insert INTO Sales(Date, CustomerNumber, EmployeeNumber, SubTotal, GST, total) values (  'Oct 15, 2012',  12,  301, 60.00,    3.00 ,  63.00     )
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3011, 1021031056, 60.00,  1,60.00)

Insert INTO Sales(Date, CustomerNumber, EmployeeNumber, SubTotal, GST, total) values (  'Nov 10, 2012',  13,  302, 50.00,     2.50 , 52.50      )
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3012, 1021031057, 50.00,  1,50.00)

Insert INTO Sales(Date, CustomerNumber, EmployeeNumber, SubTotal, GST, total) values (  'Nov 10, 2012',  14,  303, 80.00,   4.00 , 84.00      )
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3013, 1021031058, 80.00,  1,80.00)

Insert INTO Sales(Date, CustomerNumber, EmployeeNumber, SubTotal, GST, total) values (  'Nov 10, 2012',  15,  304, 60.00,     3.00,  63.00     )
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3014, 1021031059, 60.00,  1,60.00)

Insert INTO Sales(Date, CustomerNumber, EmployeeNumber, SubTotal, GST, total) values (  'Nov 10, 2012',  16,   305, 200.00,   10.00,  210.00     )
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3015, 1021031042, 100.00,  1,100.00)
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3015, 1021031043, 100.00,  1,100.00)

Insert INTO Sales(Date, CustomerNumber, EmployeeNumber, SubTotal, GST, total) values (  'Nov 10, 2012',  19,   306,  100.00,   5.00,  105.00     )
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3016, 1021031077, 50.00,  1,50.00)
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3016, 1021031079, 50.00,  1,50.00)

Insert INTO Sales(Date, CustomerNumber, EmployeeNumber, SubTotal, GST, total) values (  'Nov 10, 2012',  16,   305, 160.00,    8.00,  168.00    )
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3017, 1021031046, 80.00,  1,80.00)
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3017, 1021031047, 80.00,  1,80.00)

Insert INTO Sales(Date, CustomerNumber, EmployeeNumber, SubTotal, GST, total) values (  'Nov 10, 2012',  15,   305, 180.00,    9.00,  189.00     )
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3018, 1021031048, 90.00,  1,90.00)
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3018, 1021031049, 90.00,  1,90.00)

Insert INTO Sales(Date, CustomerNumber, EmployeeNumber, SubTotal, GST, total) values (  'Nov 10, 2012',  14,   306, 400.00,    20.00,  420.00     )
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3019, 1021031064, 80.00,  2,160.00)
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3019, 1021031063, 80.00,  3,240.00)

Insert INTO Sales(Date, CustomerNumber, EmployeeNumber, SubTotal, GST, total) values (  'May 10, 2012',  13,   300, 200.00,   10.00,  210.00 )
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3020, 1021031042, 100.00,  1,100.00)
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3020, 1021031043, 100.00,  1,100.00)

Insert INTO Sales(Date, CustomerNumber, EmployeeNumber, SubTotal, GST, total) values (  'May 10, 2012',  23,    301, 60.00,    3.00,   63.00      )
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3021, 1021031076, 60.00,  1,60.00)

Insert INTO Sales(Date, CustomerNumber, EmployeeNumber, SubTotal, GST, total) values (  'May 10, 2012',  24,    302,   100.00,  5.00,  105.00  )
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3022, 1021031077, 50.00,  2,100.00)

Insert INTO Sales(Date, CustomerNumber, EmployeeNumber, SubTotal, GST, total) values (  'May 10, 2012',  25,    303,160.00,     8.00,  168.00    )
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3023, 1021031066, 80.00,  2,160.00)

Insert INTO Sales(Date, CustomerNumber, EmployeeNumber, SubTotal, GST, total) values (  'May 10, 2012',  26,    304,  73.00,   3.50,   73.50 )
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3024, 1021031063, 70.00,  1,70.00)

Insert INTO Sales(Date, CustomerNumber, EmployeeNumber, SubTotal, GST, total) values (  'May 10, 2012',  22,    305, 73.00,    3.50,  73.50   )
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3025, 1021031064, 70.00,  1,70.00)

Insert INTO Sales(Date, CustomerNumber, EmployeeNumber, SubTotal, GST, total) values (  'Jun 10, 2012',  21,    306,  80.00,   4.00,  84.00  )
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3026, 1021031041, 80.00,  1,80.00)

Insert INTO Sales(Date, CustomerNumber, EmployeeNumber, SubTotal, GST, total) values (  'Jun 10, 2012',  22,    305,  160.00,   8.00, 168.00)
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3027, 1021031042, 80.00,  2,160.00)

Insert INTO Sales(Date, CustomerNumber, EmployeeNumber, SubTotal, GST, total) values (  'Jun 10, 2012',  9,    305, 180.00,    9.00, 189.00 )
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3028, 1021031043, 90.00,  2,180.00)

Insert INTO Sales(Date, CustomerNumber, EmployeeNumber, SubTotal, GST, total) values (  'Jun 10, 2012',  10,   305, 180.00,    9.00, 189.00 )
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3029, 1021031044, 90.00,  2,180.00)

Insert INTO Sales(Date, CustomerNumber, EmployeeNumber, SubTotal, GST, total) values (  'Jun 10, 2012',  11,   306, 180.00,    9.00, 189.00 )
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3030, 1021031048, 90.00,  1,90.00)
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3030, 1021031049, 90.00,  1,90.00)

Insert INTO Sales(Date, CustomerNumber, EmployeeNumber, SubTotal, GST, total) values (  'Jun 10, 2009',  11,   306,  180.00,   9.00, 189.00 )
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3031, 1021031048, 90.00,  1,90.00)



Insert INTO Sales(Date, CustomerNumber, EmployeeNumber, SubTotal, GST, total) values (  'Jul 10, 2012',  13,  301 ,200.00,    10.00, 210.00   )
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3032, 1021031046, 100.00,  1,100.00)
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3032, 1021031047, 100.00,  1,100.00)


Insert INTO Sales(Date, CustomerNumber, EmployeeNumber, SubTotal, GST, total) values (  'Oct 10, 2015',  14, 302  ,180.00,    9.00,  189.00   )
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3033, 1021031050, 90.00,  1,90.00)
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3033, 1021031051, 90.00,  1,90.00)


Insert INTO Sales(Date, CustomerNumber, EmployeeNumber, SubTotal, GST, total) values (  'Oct 10, 2018',  15, 303  , 160.00,    8.00,  168.00   )
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3034, 1021031051, 80.00,  1,80.00)
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3034, 1021031053, 80.00,  1,80.00)




Insert INTO Sales(Date, CustomerNumber, EmployeeNumber, SubTotal, GST, total) values (  'Oct 10, 2018',  12,  300 , 180.00,    9.00, 189.00  )
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3034, 1021031044, 90.00,  1,90.00)
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3034, 1021031045, 90.00,  1,90.00)

Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3035, 1021031045, 90.00,  1,90.00)



Insert INTO Sales(Date, CustomerNumber, EmployeeNumber, SubTotal, GST, total) values (  'Oct 10, 2018',  16, 304  ,180.00,    9.00, 189.00    )
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3036, 1021031048, 90.00,  1,90.00)
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3036, 1021031049, 90.00,  1,90.00)


Insert INTO Sales(Date, CustomerNumber, EmployeeNumber, SubTotal, GST, total) values (  'Oct 10, 2018',  11,  305  , 360.00,  18.00, 378.00   )
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3037, 1021031048, 90.00,  1,90.00)
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3037, 1021031049, 90.00,  1,90.00)
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3037, 1021031050, 90.00,  1,90.00)
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3037, 1021031051, 90.00,  1,90.00)



Insert INTO Sales(Date, CustomerNumber, EmployeeNumber, SubTotal, GST, total) values (  'Oct 10, 2018',  12,  306, 70.00,   3.50,  73.50   )
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3038, 1021031040, 70.00,  1,70.00)


Insert INTO Sales(Date, CustomerNumber, EmployeeNumber, SubTotal, GST, total) values (  'Oct 10, 2018',  23, 305, 70.00,   3.50,  73.50  )
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3039, 1021031041, 70.00,  1,70.00)

Insert INTO Sales(Date, CustomerNumber, EmployeeNumber, SubTotal, GST, total) values (  'Oct 10, 2018',  24,  305,  70.00,  3.50,  73.50  )
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3040, 1021031042, 70.00,  1,70.00)

Insert INTO Sales(Date, CustomerNumber, EmployeeNumber, SubTotal, GST, total) values (  'Oct 10, 2018',  25,   306, 70.00 ,  3.50,  73.50 )
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3041, 1021031043, 70.00,  1,70.00)


Insert INTO Sales(Date, CustomerNumber, EmployeeNumber, SubTotal, GST, total) values (  'Oct 10, 2018', 26,   306, 70.00,   3.50,  73.50  )
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3042, 1021031044, 70.00,  1,70.00)


Insert INTO Sales(Date, CustomerNumber, EmployeeNumber, SubTotal, GST, total) values (  'Oct 10, 2018',   17, 301,70.00 ,   3.50,  73.50 )
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3043, 1021031045, 70.00,  1,70.00)


Insert INTO Sales(Date, CustomerNumber, EmployeeNumber, SubTotal, GST, total) values (  'Oct 19, 2018',  18,   302, 140.00,   7.00,  147.00   )
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3044, 1021031046, 70.00,  1,70.00)
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3044, 1021031047, 70.00,  1,70.00)


Insert INTO Sales(Date, CustomerNumber, EmployeeNumber, SubTotal, GST, total) values (  'Oct 19, 2018',  19,   303, 140.00,   7.00,  147.00  )
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3045, 1021031048, 70.00,  1,70.00)
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3045, 1021031049, 70.00,  1,70.00)


Insert INTO Sales(Date, CustomerNumber, EmployeeNumber, SubTotal, GST, total) values (  'Oct 20, 2018',  10,    304, 140.00,  7.00,  147.00  )
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3046, 1021031050, 70.00,  1,70.00)
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3046, 1021031051, 70.00,  1,70.00)


Insert INTO Sales(Date, CustomerNumber, EmployeeNumber, SubTotal, GST, total) values (  'March 3, 2018',  21,   305,73.00,    3.50,  73.50  )
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3047, 1021031052, 70.00,  1,70.00)


Insert INTO Sales(Date, CustomerNumber, EmployeeNumber, SubTotal, GST, total) values (  'March 3, 2018',  22,    306, 73.00,   3.50,  73.50  )
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3048, 1021031053, 70.00,  1,70.00)


Insert INTO Sales(Date, CustomerNumber, EmployeeNumber, SubTotal, GST, total) values (  'March 3, 2018',  23,     310, 73.00 ,  3.50,  73.50  )
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3049, 1021031054, 70.00,  1,70.00)


Insert INTO Sales(Date, CustomerNumber, EmployeeNumber, SubTotal, GST, total) values (  'March 3, 2018',  24,     310, 73.00,   3.50,  73.50  )
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3050, 1021031055, 70.00,  1,70.00)


Insert INTO Sales(Date, CustomerNumber, EmployeeNumber, SubTotal, GST, total) values ( 'March 3, 2018',  25,    313,73.00   , 3.50,  73.50 )
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3051, 1021031056, 70.00,  1,70.00)

Insert INTO Sales(Date, CustomerNumber, EmployeeNumber, SubTotal, GST, total) values (  'March 10, 2018',  26,  313,200.00, 10.00 ,210.00 )
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3052, 1021031208, 90.00,  1,90.00)
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3052, 1021031210, 60.00,  1,60.00)
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3052, 1021031211, 50.00,  1,50.00)

Insert INTO Sales(Date, CustomerNumber, EmployeeNumber, SubTotal, GST, total) values (  'March 11, 2018',  26,   313,140.00,    7.00,  147.00   )
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3053, 1021031204, 70.00,  1,70.00)
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3053, 1021031205, 70.00,  1,70.00)

Insert INTO Sales(Date, CustomerNumber, EmployeeNumber, SubTotal, GST, total) values (  'March 12, 2018',  21,  312,  500.00,    25.00 , 525.00      )
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3054, 1021031205, 50.00,  10,500.00)

Insert INTO Sales(Date, CustomerNumber, EmployeeNumber, SubTotal, GST, total) values (  'March 12, 2018',  22,   311,700.00,    35.00,  735.00)
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3055, 1021031207, 70.00,  10,700.00)

Insert INTO Sales(Date, CustomerNumber, EmployeeNumber, SubTotal, GST, total) values (  'March 12, 2018',  23,  310  ,  360.00, 18.00, 378.00   )
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3056, 1021031200, 90.00,  1,90.00)
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3056, 1021031201, 90.00,  1,90.00)
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3056, 1021031203, 90.00,  1,90.00)
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3056, 1021031208, 90.00,  1,90.00)

Insert INTO Sales(Date, CustomerNumber, EmployeeNumber, SubTotal, GST, total) values (  'March 12, 2018',  24,   309,400.00,    20.00,  420.00     )
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3057, 1021031203, 80.00,  2,160.00)
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3057, 1021031204, 80.00,  3,240.00)

Insert INTO Sales(Date, CustomerNumber, EmployeeNumber, SubTotal, GST, total) values (  'March 13, 2018',  25,   309, 200.00,   10.00,  210.00 )
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3058, 1021031204, 100.00,  1,100.00)
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3058, 1021031205, 100.00,  1,100.00)

Insert into Sales(Date, CustomerNumber, EmployeeNumber, SubTotal, GST, total)  values (  'March 13, 2018',  26,  309,  600.00   , 30.00 ,  630.00     )
Insert INTO SaleDetails(SaleNumber, ISBN, SellingPrice, Quantity, Amount) values (3059, 1021031205, 60.00,  10,600.00)

