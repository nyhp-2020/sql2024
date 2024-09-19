-- Kérdezzük le a 2011-es év vásárlásait, jelenítsük meg a vásárló nevét
SELECT o.*, c.FirstName, c.LastName
FROM Orders o
INNER JOIN Customer c ON c.CustomerID = o.CustomerID
WHERE YEAR(o.OrderDate) = 2011

--CustomerID-t csak úgy tudjuk kihagyni, ha minden mást ami kell felsorolunk (pl. név)
SELECT
     --o.*,
     o.OrderID,
     o.OrderDate,
     c.FirstName,
     c.LastName,
     o.SalesPersonID,
     o.SubTotal
FROM Orders o
INNER JOIN Customer c ON c.CustomerID = o.CustomerID
WHERE YEAR(o.OrderDate) = 2011

SELECT
     --o.*,
     o.OrderID,
     o.OrderDate,
     c.FirstName + ' ' + c.LastName as FullName,
     o.SalesPersonID,
     o.SubTotal
FROM Orders o
INNER JOIN Customer c ON c.CustomerID = o.CustomerID
WHERE YEAR(o.OrderDate) = 2011

--Kérdezzük le a termékek eladásait 2012-ben, vásárló nevével és termék nevével

SELECT o.*,od.*, c.FirstName + ' ' + c.LastName as FullName, p.Name as ProductName
FROM Orders o
INNER JOIN Customer c ON c.CustomerID = o.CustomerID
inner join OrderDetail od on od.OrderID = o.OrderID
inner join Product p on p.ProductID = od.ProductID
WHERE YEAR(o.OrderDate) = 2012

-- Jelenítsük meg a termékek listáját és hogy mennyit adtak el belőlük 2012-ben

SELECT p.ProductID, p.Name as ProductName, sum(od.OrderQty) as Darab
FROM Orders o
inner join OrderDetail od on od.OrderID = o.OrderID
inner join Product p on p.ProductID = od.ProductID
WHERE YEAR(o.OrderDate) = 2012
group by p.ProductID, p.Name

--Jelenítsük meg azokat is amelyekből nem volt eladás
SELECT p.ProductID, p.Name as ProductName, isnull(sum(od.OrderQty), 0) as Darab --az isnull függvény 0-ra cseréli a null-t (ahol nem volt eladás)
FROM Product p
left join OrderDetail od on od.ProductID = p.ProductID
left join Orders o on o.OrderID = od.OrderID and YEAR(o.OrderDate) = 2012 -- ami a where-ben volt felhoztam az on záradékba, igy nem szűri ki a null OrderDate értékűeket a Product-ból
group by p.ProductID, p.Name

select * from product

SELECT p.ProductID, p.Name as ProductName, isnull(sum(od.OrderQty), 0) as Darab --az isnull függvény 0-ra cseréli a null-t (ahol nem volt eladás)
FROM Product p
left join OrderDetail od on od.ProductID = p.ProductID
left join Orders o on o.OrderID = od.OrderID
where YEAR(o.OrderDate) = 2012 -- ez kiszűri a null értékeket az OrderDate oszlopban (ott nem volt eladás)
group by p.ProductID, p.Name


SELECT p.ProductID, p.Name as ProductName, o.OrderDate
FROM Product p
left join OrderDetail od on od.ProductID = p.ProductID
left join Orders o on o.OrderID = od.OrderID and YEAR(o.OrderDate) = 2012



SELECT p.ProductID, p.Name as ProductName, count(*) as Vasarlas --Ez az OrderDetails sorainak a számát számolja (vásárlások száma)
FROM Orders o
inner join OrderDetail od on od.OrderID = o.OrderID
inner join Product p on p.ProductID = od.ProductID
WHERE YEAR(o.OrderDate) = 2012
group by p.ProductID, p.Name

--Összesítsük az eladásokat 2011-01-01 és 2016-01-01 között, de olyan dátumokat is jelenítsünk meg, amelyeken nem volt tranzakció