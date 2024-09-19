SELECT FirstName, LastName, City
from Customer
WHERE City IN ('Budapest', 'Chicago')
ORDER BY City

--1op 100 from Customer
SELECT TOP 100 *
FROM Customer

SELECT FirstName, LastName, City
from Customer
WHERE City IN ('Budapest', 'Chicago')
ORDER BY FirstName, City DESC


SELECT Title,FirstName, LastName, City
from Customer
WHERE City IN ('Budapest', 'Chicago')
AND Title IS NULL
ORDER BY FirstName, City DESC

SELECT CustomerID,Title,FirstName, LastName, City
from Customer
WHERE CustomerID < 20000
ORDER BY CustomerId DESC
