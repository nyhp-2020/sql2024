-- 3. where után = < > LIKE
-- ez így még nem jó, mert egy oszlop lehet az allekérdezésben
select *
from Orders o
where o.CustomerID = (
    select top 1 CustomerID, sum(Subtotal)
    from Orders
    group by CustomerID
    order by 2 desc
)

-- ez jó
select *
from Orders o
where o.CustomerID = (
    select top 1 CustomerID --, sum(Subtotal)
    from Orders
    group by CustomerID
    order by sum(Subtotal) desc
)

select *
from Orders o
where o.CustomerID = (
    select CustomerId  --Ez itt egyetlen sorral és egyetlen oszloppal tér vissza (külön is futtatható)
    from (
        select top 1 CustomerID, sum(Subtotal) as Total -- Ez még két oszloppal tér vissza, kell alias a sum-nak
        from Orders
        group by CustomerID
        order by 2 desc -- itt lehet order by, de akkor kell a top is
    ) s
)

-- a legtöbbet vásárolt vásárló
--saját
select top 1 c.CustomerID,sum(o.SubTotal)
from Customer c
inner join Orders o on c.CustomerID = o.CustomerID
group by c.CustomerID
order by sum(SubTotal) desc

--előadó
select top 1 CustomerID, sum(Subtotal)
from Orders
group by CustomerID
order by 2 desc

--listázzunk ki minden eladást 2013-ban, amik az átlagos napi eladás felettiek
select *
from Orders
where
subtotal > 
(select avg(DayTotal) as AvgDayTotal
    from (
        select sum(SubTotal) as DayTotal
        from Orders
        group by OrderDate) as dt
)
and YEAR(OrderDate) = 2013

-- napi eladások összegezve
select OrderDate,sum(SubTotal)
from Orders
group by OrderDate
order by OrderDate

select sum(SubTotal)
from Orders
group by OrderDate

-- napi eladás(összegek) átlaga
select avg(DayTotal) as AvgDayTotal
from (
    select sum(SubTotal) as DayTotal
    from Orders
    group by OrderDate) as dt

-- minden, egy nap több eladás is van
select Orderdate,OrderId,Subtotal
from Orders
Order by OrderDate

--inline tábla készítés
--tábla konstruktor
-- ami a zárójelek között van, az egy subquery
select *
from (values(0)) as Table1(ID)

select *
from (values(0),(1),(2),(3)) as Table1(ID)

select *
from (values(0,'A'),(1,'A'),(2,'B'),(3,'C')) as Table1(ID, Value)

select *
from (values(0,'A'),(1,'A'),(2,'B'),(3,'C')) as Table1(ID, Value)
where ID = 3

--év-hónap lista előállítása
select *
from (values(2010), (2011),(2012),(2013),(2014),(2015),(2016) ) as evek(ev)

select *
from (values(1), (2),(3),(4),(5),(6),(7),(8),(9),(10),(11),(12)) as ehonapok(honap)

--a cross join mindent mindennel kombinál
select *
from (values(2010), (2011),(2012),(2013),(2014),(2015),(2016) ) as evek(ev)
cross join (values(1), (2),(3),(4),(5),(6),(7),(8),(9),(10),(11),(12)) as ehonapok(honap)




