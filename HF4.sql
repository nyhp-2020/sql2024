--1
SELECT ProductLine, count(*) as Products
FROM Product
GROUP BY ProductLine



--2
select p.Name as ProductName,sum(OrderQty) as SalesQuantity,SUM(od.LineTotal) as SalesAmount
FROM Orders o
INNER JOIN OrderDetail od ON o.OrderID = od.OrderID
INNER JOIN Product p ON od.ProductID = p.ProductID
WHERE YEAR(OrderDate) = 2013 AND MONTH(OrderDate)=3 AND p.ProductSubcategoryID = 12
GROUP BY p.Name
ORDER BY ProductName

--3 a 0 sorok nélkül
select YEAR(o.OrderDate) as Year,MONTH(o.OrderDate) as Month,sum(od.OrderQty) as SalesQuantity,SUM(od.LineTotal) as SalesAmount
FROM Orders o
JOIN OrderDetail od ON o.OrderID = od.OrderID
JOIN Product p ON od.ProductID = p.ProductID
WHERE OrderDate >= '2013-01-01' AND OrderDate <= '2014-12-31' AND p.Name LIKE('%tire%')
GROUP BY YEAR(o.OrderDate),MONTH(o.OrderDate)
ORDER BY 1,2

-- év hónap lista
SELECT *
FROM (values(2013), (2014)) AS evek(Year)
CROSS JOIN(values(1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),(12)) AS honapok(Month)
LEFT JOIN (
    select YEAR(o.OrderDate) as Year,MONTH(o.OrderDate) as Month,sum(od.OrderQty) as SalesQuantity,SUM(od.LineTotal) as SalesAmount
FROM Orders o
LEFT JOIN OrderDetail od ON o.OrderID = od.OrderID
LEFT JOIN Product p ON od.ProductID = p.ProductID
WHERE OrderDate >= '2013-01-01' AND OrderDate <= '2014-12-31' AND p.Name LIKE('%tire%')
GROUP BY YEAR(o.OrderDate),MONTH(o.OrderDate)
) t ON evek.[Year] = t.[Year] AND honapok.[Month] = t.[Month]


--3 NULL értékekkel
SELECT Year,Month,SalesQuantity,SalesAmount
FROM
(
SELECT *
FROM (values(2013), (2014)) AS evek(Year)
CROSS JOIN(values(1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),(12)) AS honapok(Month)
LEFT JOIN (
    select YEAR(o.OrderDate) as Y,MONTH(o.OrderDate) as M,sum(od.OrderQty) as SalesQuantity,SUM(od.LineTotal) as SalesAmount
    FROM Orders o
    JOIN OrderDetail od ON o.OrderID = od.OrderID
    JOIN Product p ON od.ProductID = p.ProductID
    WHERE OrderDate >= '2013-01-01' AND OrderDate <= '2014-12-31' AND p.Name LIKE('%tire%')
    GROUP BY YEAR(o.OrderDate),MONTH(o.OrderDate)
) t ON evek.[Year] = t.[Y] AND honapok.[Month] = t.[M]
) tt


--3 0 értékekkel
SELECT Year,Month,ISNULL(SalesQuantity,0) as SalesQuantity,ISNULL(SalesAmount,0.00) as SalesAmount
FROM
(
SELECT *
FROM (values(2013), (2014)) AS evek(Year)
CROSS JOIN(values(1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),(12)) AS honapok(Month)
LEFT JOIN (
    select YEAR(o.OrderDate) as Y,MONTH(o.OrderDate) as M,sum(od.OrderQty) as SalesQuantity,SUM(od.LineTotal) as SalesAmount
    FROM Orders o
    JOIN OrderDetail od ON o.OrderID = od.OrderID
    JOIN Product p ON od.ProductID = p.ProductID
    WHERE OrderDate >= '2013-01-01' AND OrderDate <= '2014-12-31' AND p.Name LIKE('%tire%')
    GROUP BY YEAR(o.OrderDate),MONTH(o.OrderDate)
) t ON evek.[Year] = t.[Y] AND honapok.[Month] = t.[M]
) tt


SELECT AVG(t.total)
FROM
(SELECT o.OrderDate,SUM(od.LineTotal) as total,SUM(OrderQty) as qty
FROM Orders o
INNER JOIN OrderDetail od ON o.OrderID = od.OrderID
GROUP BY o.OrderDate
HAVING YEAR(o.OrderDate) = 2011
) AS t

--4
SELECT *
FROM Orders
WHERE SubTotal >(
    SELECT AVG(t.total)
    FROM
    (SELECT o.OrderDate,SUM(od.LineTotal) as total,SUM(OrderQty) as qty
    FROM Orders o
    INNER JOIN OrderDetail od ON o.OrderID = od.OrderID
    GROUP BY o.OrderDate
    HAVING YEAR(o.OrderDate) = 2011
    ) AS t
 ) AND YEAR(OrderDate) = 2011

SELECT ProductID
FROM
(SELECT top 1 ProductID,SUM(OrderQty) AS Qty
FROM OrderDetail
GROUP BY ProductID
ORDER BY Qty DESC) as t


SELECT *
FROM OrderDetail

--5
SELECT *
FROM Product
WHERE ProductId = (SELECT ProductID
FROM
(SELECT top 1 ProductID,SUM(OrderQty) AS Qty
FROM OrderDetail
GROUP BY ProductID
ORDER BY Qty DESC) as t)
