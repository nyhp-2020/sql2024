SELECT ProductID, Name as ProductName, Color,
case 
    when Color = 'Black' then 'Fekete'
    when Color = 'Blue' then 'Kék'
    when Color = 'Grey' then 'Szürke'
    when Color = 'Multi' then 'Több'
    when Color = 'Red' then 'Piros'
    when Color = 'Silver' then 'Ezüst'
    when Color = 'Silver/Black' then 'Ezüst/Fekete'
    when Color = 'White' then 'Fehér'
    when Color = 'Yellow' then 'Sárga'
end as [Szín]
from Product
WHERE Color is NOT NULL


SELECT count(*) as TotalCustomer,
    count(Title) as CountOfTitle,
    count(City) as CountOfCity,
    count(Country) as CountOfCountry
FROM Customer


SELECT TOP 3 *
FROM Orders o 
WHERE YEAR(OrderDate) = 2012
ORDER BY SubTotal DESC

SELECT TOP 3
    OrderID, OrderDate,
    c.FirstName + ' ' + c.LastName as CustomerName,
    SalesPersonID, SubTotal
FROM Orders o
INNER JOIN Customer c ON c.CustomerID = o.CustomerID
WHERE YEAR(OrderDate) = 2012
ORDER BY SubTotal DESC



SELECT distinct YEAR(OrderDate) as Year
FROM Orders
ORDER BY Year


select *
from
(SELECT distinct YEAR(OrderDate) as Year
FROM Orders
) as t
CROSS APPLY(
    SELECT TOP 3
    o.OrderID, o.OrderDate,
    c.FirstName + ' ' + c.LastName as CustomerName,
    o.SalesPersonID, o.SubTotal
    FROM Orders o
    INNER JOIN Customer c ON c.CustomerID = o.CustomerID
    WHERE YEAR(o.OrderDate) = t.[Year]
    ORDER BY o.SubTotal DESC
)as top3
ORDER by t.[Year]
