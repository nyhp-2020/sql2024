-- Kérdezzük le a 2011-es év vásárlásait, jelenítsük meg a vásárló nevét
select 
    --o.*, 
    o.OrderID,
    o.OrderDate,
    c.FirstName + ' ' + c.LastName as FullName,
    o.SalesPersonID,
    o.SubTotal
from Orders o
inner join Customer c on c.CustomerID = o.CustomerID
where year(o.OrderDate) = 2011

-- Kérdezzük le a termékek eladásait 2012-ben, vásárló nevével és termék nevével
select o.*, od.*, c.FirstName + ' ' + c.LastName as FullName, p.Name as ProductName
from Orders o
inner join Customer c on c.CustomerID = o.CustomerID
inner join OrderDetail od on od.OrderID = o.OrderID
inner join Product p on p.ProductID = od.ProductID
where year(o.OrderDate) = 2012

-- Jelenítsük meg a termékek listáját és hogy mennyit adtak el belőlük 2012-ben
select p.ProductID, p.Name as ProductName, sum(od.OrderQty) as Darab
from Orders o
inner join OrderDetail od on od.OrderID = o.OrderID
inner join Product p on p.ProductID = od.ProductID
where year(o.OrderDate) = 2012
group by p.ProductID, p.Name

-- Az előzőt egészítsük ki azokkal a termékekkel, amelyekből nem volt eladás
select p.ProductID, p.Name as ProductName, isnull(sum(od.OrderQty), 0) as Darab
from Product p 
left join OrderDetail od on od.ProductID = p.ProductID
left join Orders o on o.OrderID = od.OrderID and year(o.OrderDate) = 2012
group by p.ProductID, p.Name

-- apply
select *
from Product p
where p.ProductSubcategoryID = 10

-- cross apply
select *
from Product p
cross apply (
    select top 3 LineTotal, OrderQty
    from OrderDetail od
    where od.ProductID = p.ProductID
    order by od.OrderID desc
) as top3
where p.ProductSubcategoryID = 10

-- outer apply
select p.Name, top3.OrderQty
from Product p
outer apply (
    select top 3 LineTotal, OrderQty
    from OrderDetail od
    where od.ProductID = p.ProductID
    order by od.OrderID desc
) as top3
where p.ProductSubcategoryID = 10

