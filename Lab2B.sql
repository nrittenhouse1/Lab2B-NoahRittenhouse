/*
	Noah Rittenhouse, A01
	Dan Gilleland
	Database Fundamentals

	Deficiencies: 
*/


USE [1508_Lab2A_BooksGalore]
GO

--1.	Select the ISBN, title, publisher name and number in stock.  List the data in ISBN sequence. 

SELECT ISBN, Title, P.Name AS 'Publisher Name', NumberInStock
FROM Books B
	INNER JOIN Publishers P ON B.PublisherCode = P.PublisherCode
ORDER BY ISBN

--2.	The company is having a 10% sale on books in the category �Computers�. 
--		Select the ISBN, title, suggested price, the sale price (suggested price less 10%) and the difference between the two values.

SELECT ISBN, Title, SuggestedPrice AS 'Suggested Price', 
	SuggestedPrice - (SuggestedPrice * 0.10) AS 'Sale Price', /*Sale Price*/
	SuggestedPrice - (SuggestedPrice - (SuggestedPrice * 0.10)) AS 'Difference' /*Difference*/
FROM Books B
	INNER JOIN Categories C ON B.CategoryCode = C.CategoryCode
WHERE C.Description = 'Computers'

--3.	Select the employee number and name of all the employees who don�t have a sale. Do not use a join.

SELECT EmployeeNumber, FirstName + ' ' + LastName AS 'Employee Name'
FROM Employees
WHERE EmployeeNumber NOT IN /* Employees who are not in the sales category, meaning they made no sales the lazy good for nothings*/
	(
		SELECT EmployeeNumber
		FROM Sales
	)

--4.	Select the total number of books and the total money earned for the company for the current year. 

SELECT SUM(NumberInStock) AS 'Total Books', SUM(S.Total) AS 'Total Income'
FROM Books B
	INNER JOIN SaleDetails SD ON B.ISBN = SD.ISBN
	INNER JOIN Sales S ON SD.SaleNumber = S.SaleNumber
WHERE YEAR(S.Date) = YEAR(GETDATE())

--5.	Select the category code, category description and the total number of books sold and the total money earned for each and every category.

SELECT C.categoryCode AS 'Category Code', C.Description, SUM(SD.Quantity) AS 'Total Books Sold', SUM(S.Total) AS 'Total Income'
FROM Categories C
	INNER JOIN Books B ON B.CategoryCode = C.categoryCode
	INNER JOIN SaleDetails SD ON SD.ISBN = B.ISBN
	INNER JOIN Sales S On S.SaleNumber = SD.SaleNumber
GROUP BY C.categoryCode, C.Description

--6.	Select the ISBN, title and amount earned for the current year for the titles that sold more than $100(not including GST).

SELECT B.ISBN, Title, SUM(SubTotal) AS 'Total Income(No GST)'
FROM Books B
	INNER JOIN SaleDetails SD ON SD.ISBN = B.ISBN
	INNER JOIN Sales S ON S.SaleNumber = SD.SaleNumber
WHERE SD.Amount > 100
GROUP BY B.ISBN, Title

--7.	Write the select statement to return ALL the customer names, CustomerNumbers and how many sales they have.

SELECT FirstName + ' ' + LastName AS 'Customer Name', C.CustomerNumber, COUNT(SaleNumber) AS 'Sale Count'
FROM Customers C
	INNER JOIN Sales S ON S.CustomerNumber = C.CustomerNumber
GROUP BY C.CustomerNumber, FirstName, LastName

--8.	Select The CustomerNumber, Full Name, SaleNumber, SaleDate, SubTotal, GST, Total, ISBN, Title Quantity, and Amount for Sale Numbers 3008 to 3010. 

SELECT C.CustomerNumber, FirstName + ' ' + LastName AS 'Customer Name', S.SaleNumber, Date, SubTotal, GST, Total, ISBN, COUNT(Quantity) AS 'Title Quantity', Amount
FROM Customers C
	INNER JOIN Sales S ON S.CustomerNumber = C.CustomerNumber
	INNER JOIN SaleDetails SD ON SD.SaleNumber = S.SaleNumber
WHERE S.SaleNumber >= 3008 AND S.SaleNumber <= 3010
GROUP BY C.CustomerNumber, FirstName, LastName, S.SaleNumber, Date, SubTotal, GST, Total, ISBN, Amount

--9.	Select the Full Names and full mailing address of all the Customers and Employees. In order to create mailing labels the following 5 columns are required: 
--		Name, Address, City, Prov, PC. DO NOT return more than 5 columns. There is no need to differentiate between Customer and Employee addresses.

--SELECT C.FirstName + ' ' + C.LastName AS 'Customer Name', C.Email, E.FirstName + ' ' + E.LastName AS 'Employee Name', E.Email
SELECT FirstName + ' ' + LastName AS 'Full Name', Address, City, Province, PostalCode
FROM Customers

UNION

SELECT FirstName + ' ' + LastName AS 'Full Name', Address, City, Province, PostalCode
FROM Employees

--10.	Select the Customer Names that have shaw.ca email addresses and have made more than 3 sales.

SELECT FirstName + ' ' + LastName AS 'Customer'
FROM Customers C
	INNER JOIN Sales S ON C.CustomerNumber = S.CustomerNumber
GROUP BY FirstName, LastName, Email
HAVING Email LIKE '%shaw.ca' AND COUNT(SaleNumber) > 3

--11.	Select the name of the Employee and the email address for the employee that has the highest individual sale for the current month. 
--		This query will be run on the last day of each month to determine the winner for that month. You must use a subquery in your solution.

SELECT FirstName + ' ' + LastName AS 'Employee', Email, Total
FROM Employees E
	INNER JOIN Sales S ON S.EmployeeNumber = E.EmployeeNumber
	WHERE S.Total =
	(
		SELECT MAX(total)
		FROM Sales
	)
GROUP BY FirstName, LastName, Email, Total


--12.	Select ALL the customer full names (as one column),a count of books they have purchased and the number of sales they have. Order the list alphabeticaly by Customer Last Name.

SELECT FirstName + ' ' + LastName AS 'Customer Name', COUNT(ISBN) AS 'Book Count', COUNT(S.SaleNumber) AS 'Sale Count'
FROM Customers C
	INNER JOIN Sales S ON S.CustomerNumber = C.CustomerNumber
	INNER JOIN SaleDetails SD ON SD.SaleNumber = S.SaleNumber
GROUP BY C.CustomerNumber, FirstName, LastName
ORDER BY LastName



-- VIEW
--1.	Create a view called CustomerSaleHistory that will select the customernumber, customer full name (one column), salenumber, saledate, title, sellingprice, 
--		and total for all the customers that have sales.

IF OBJECT_ID('CustomerSaleHistory', 'V') IS NOT NULL
    DROP VIEW CustomerSaleHistory
GO
CREATE VIEW CustomerSaleHistory
AS
    SELECT  C.CustomerNumber,  FirstName + ' ' + LastName AS 'Customer Name', S.SaleNumber, Date, Title, SellingPrice, Total
    FROM    Customers C
		INNER JOIN Sales S On S.CustomerNumber = C.CustomerNumber
		INNER JOIN SaleDetails SD ON SD.SaleNumber = S.SaleNumber
		INNER JOIN Books B On B.ISBN = SD.ISBN
	GROUP BY C.CustomerNumber, FirstName, LastName, S.SaleNumber, Date, Title, SellingPrice, Total
	HAVING COUNT(S.SaleNumber) != 0
GO

SELECT CustomerNumber, [Customer Name], SaleNumber, Date, Title, SellingPrice, Total
FROM CustomerSaleHistory
WHERE CustomerNumber = 11

-- DML
-- 1.	Insert the following records into the Books table given the following data:

INSERT INTO Books (ISBN, Title, SuggestedPrice, NumberInStock, PublisherName, CategoryCode)
VALUES(1021031217, 'SQL is my life. Make it yours!', .99, 95, 'West', 3)

--2.	Change the following records given the following data:
--	a.	Increase all the suggested prices of the books in the business category by 10%

UPDATE Books
	SET SuggestedPrice = SuggestedPrice * 1.10

--	b.	Adjust the Number in stock by +2 and change the suggested price to be $3.00 more than it is now for ISBN 1021031040

UPDATE Books
	SET NumberInStock = NumberInStock + 2, SuggestedPrice = SuggestedPrice + 3
	WHERE ISBN = 1021031040

--3.	Remove the following records given the following data:
--	a.	Remove publishers that do not have any books in our store

DELETE FROM Publishers
FROM Books
WHERE NumberInStock = 0
