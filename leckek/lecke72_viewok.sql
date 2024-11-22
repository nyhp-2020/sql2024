
-- create view (Minden oszlopnak legyen egyedi oszlopneve)
create view OrderStat
as
select year(OrderDate) as Year, month(OrderDate) as Month, count(*) as OrderCount,sum(SubTotal) as Total
from Sales.SalesOrderHeader
group by year(OrderDate), month(OrderDate)

-- run a view (táblaként viselkednek)
select * from OrderStat


select * from OrderStat
where Year = 2011
order by Year,Month

-- egy view megváltoztatása
ALTER view [dbo].[OrderStat]
as
select year(OrderDate) as Year, month(OrderDate) as Month, count(*) as OrderCount,sum(SubTotal) as Total
from Sales.SalesOrderHeader
group by year(OrderDate), month(OrderDate)
