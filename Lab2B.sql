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

--2.	The company is having a 10% sale on books in the category “Computers”. 
--		Select the ISBN, title, suggested price, the sale price (suggested price less 10%) and the difference between the two values.

SELECT ISBN, Title, SuggestedPrice AS 'Suggested Price', 
	SuggestedPrice - (SuggestedPrice * 0.10) AS 'Sale Price', /*Sale Price*/
	SuggestedPrice - (SuggestedPrice - (SuggestedPrice * 0.10)) AS 'Difference' /*Difference*/
FROM Books B
	INNER JOIN Categories C ON B.CategoryCode = C.CategoryCode
WHERE C.Description = 'Computers'

--3.	Select the employee number and name of all the employees who don’t have a sale. Do not use a join.

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
	INNER JOIN Sales S On S.SaleNumber = SD.SaleNumber
WHERE SD.Amount > 100
GROUP BY B.ISBN, Title

--7.	Write the select statement to return ALL the customer names, CustomerNumbers and how many sales they have.



--8.	Select The CustomerNumber, Full Name, SaleNumber, SaleDate, SubTotal, GST, Total, ISBN, Title Quantity, and Amount for Sale Numbers 3008 to 3010. 

--9.	Select the Full Names and full mailing address of all the Customers and Employees. In order to create mailing labels the following 5 columns are required: 
--		Name, Address, City, Prov, PC. DO NOT return more than 5 columns. There is no need to differentiate between Customer and Employee addresses.

--10.	Select the Customer Names that have shaw.ca email addresses and have made more than 3 sales.

--11.	Select the name of the Employee and the email address for the employee that has the highest individual sale for the current month. This query will be run on the last day of each month to determine the winner for that month. You must use a subquery in your solution.

--12.	Select ALL the customer full names (as one column),a count of books they have purchased and the number of sales they have. Order the list alphabeticaly by Customer Last Name.
