select o.*, c.FirstName, c.LastName
from Orders o
inner join Customer c on c.CustomerID = o.CustomerID

-- inline subquery
select 
    o.*, 
    (select c.FirstName + ' ' + c.LastName from Customer c where c.CustomerID = o.CustomerID) as CustomerName,
    (select count(*) from Customer) as AllCustomers
from Orders o

-- from utáni subquery
select p.Name as ProductName, sum(od.LineTotal)
from Product p
inner join OrderDetail od on od.ProductID = p.ProductID
group by p.Name
having sum(od.LineTotal) > 3000000

select ord.*
from (
    select p.Name as ProductName, sum(od.LineTotal) as Total
    from Product p
    inner join OrderDetail od on od.ProductID = p.ProductID
    group by p.Name
) as ord
where ord.Total > 3000000



-- APPLY 
select 
    p.ProductID, 
    p.Name as ProductName,
    o.*
from Product p
cross apply (
    select top 3 *
    from OrderDetail od
    where od.ProductID = p.ProductID
    order by OrderID desc
) o
where p.ProductSubcategoryID = 10
order by p.ProductID, o.OrderID desc

-- WHERE subquery
-- 1. EXISTS
select distinct o.OrderID, o.OrderDate, o.SubTotal
from Orders o
inner join OrderDetail od on od.OrderID = o.OrderID
where od.ProductID in (716, 725, 764)
order by o.OrderID
--vagy
select o.OrderID, o.OrderDate, o.SubTotal
from Orders o
where exists(
    select *
    from OrderDetail od 
    where od.OrderID = o.OrderID
    and od.ProductID in (716, 725, 764)
)
order by o.OrderID

-- 2. IN
select *
from Orders o
where o.OrderDate in (
    select distinct o.OrderDate
    from OrderDetail od
    inner join Orders o on o.OrderID = od.OrderID
    where od.ProductID = 911
)

-- 3. = <> LIKE
select *
from Orders o
where o.CustomerID = (
    select CustomerID
    from (
        select top 1 CustomerID, sum(SubTotal) as Total
        from Orders
        group by CustomerID
        order by 2 desc
    ) s
)

-- tábla konstruktor
-- év-hónap lista előállítása
select *
from ( values(2010), (2011), (2012), (2013), (2014), (2015), (2016) ) as evek(ev)
cross join ( values(1), (2), (3), (4), (5), (6), (7), (8), (9), (10), (11), (12) ) as honapok(honap)

-- cte
with termek as (
    select ProductID, sum(LineTotal) as SumLineTotal
    from OrderDetail
    group by ProductID
)
select p.*, termek.SumLineTotal
from termek 
inner join Product p on p.ProductID = termek.ProductID
where SumLineTotal > (select avg(SumLineTotal) from termek)

-- rekurzív cte
with CTE as (
    select cast('2010-01-01' as date) as [Date]
    union all
    select dateadd(day, 1, [Date]) from CTE
    where [Date] < getdate()
)
select [Date] from CTE
option (maxrecursion 10000)













