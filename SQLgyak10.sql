SELECT  *
FROM [dbo].[Customer]
WHERE CustomerId = (SELECT MAX(CustomerID)
FROM [dbo].[Customer])


SELECT top 1 *
FROM Customer
ORDER BY CustomerID DESC