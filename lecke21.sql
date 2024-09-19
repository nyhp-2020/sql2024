SELECT FirstName as [Előnév], LastName, FirstName + LastName as Fullname
from Customer

SELECT  FirstName + ' ' +LastName as FullName, City
from Customer
ORDER BY City DESC, FullName ASC

SELECT  FirstName + ' ' +LastName as FullName, City
from Customer
ORDER BY 2 DESC, 1 ASC

SELECT  FirstName + ' ' +LastName as FullName, City
from Customer
ORDER BY City DESC, FirstName + ' ' +LastName ASC


SELECT  City,FirstName + ' ' +LastName as FullName
from Customer
ORDER BY 1 DESC, 2 ASC

--szűrés
SELECT  City,FirstName + ' ' +LastName as FullName
from Customer
WHERE Country = 'US' --nem is szerepel a megjelenített mezők között
ORDER BY 1 DESC, 2 ASC