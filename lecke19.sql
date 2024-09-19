SELECT top 1 *
from Customer
ORDER BY CustomerID DESC

-- max CustomerID
select MAX(CustomerID)
FROM Customer

SELECT * FROM Customer
WHERE CustomerID IN
(select MAX(CustomerID)
FROM Customer)

SELECT * FROM Customer
WHERE CustomerID < 20000

--7
select *
from Customer
Where City is null

--Csak a Budapestiek
SELECT * from Customer
WHERE City = 'Budapest'

SELECT * from Customer
WHERE City  IN ('Budapest')

SELECT * from Customer
ORDER BY FirstName asc, City desc