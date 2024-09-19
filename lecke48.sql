--itt jó a Count érték
select
    YEAR(OrderDate) as [Year], 
    count(o.OrderID) as [Count],
    count(od.ProductID) as [Count_Product_789]
from Orders o
left join Orderdetail od on od.OrderID = o.OrderID and od.ProductID = 789 --egy rendelésen belül egy termék csak egyszer szerepelhet -> max egy sor kapcolódik v. egy se
group BY YEAR(OrderDate)
order by 1

--itt tul nagy a Count érték a sokszorozódások miatt (o.OrderID ismétlődések)
select
    YEAR(OrderDate) as [Year], 
    count(o.OrderID) as [Count],
    --count(od.ProductID) as [Count_Product_789],
    sum(case when od.ProductID = 789 then 1 else 0 end)
from Orders o
left join Orderdetail od on od.OrderID = o.OrderID -- itt egy rendeléshez több sor tartozhat (több tétel lehet egy rendelésben), így az o.OrderID is sokszorozódhat
group BY YEAR(OrderDate)
order by 1

-- distinct-et használva a count-ban jó értékeket számol a count (az ismétlődéseket nem számolja)
select
    YEAR(OrderDate) as [Year], 
    count(distinct o.OrderID) as [Count],
    --count(od.ProductID) as [Count_Product_789],
    sum(case when od.ProductID = 789 then 1 else 0 end)
from Orders o
left join Orderdetail od on od.OrderID = o.OrderID -- itt egy rendeléshez több sor tartozhat (több tétel lehet egy rendelésben), így az o.OrderID is sokszorozódhat
group BY YEAR(OrderDate)
order by 1

--egy orders tétel kiválasztása
select *
from Orders o
where o.OrderID = 43662

-- ugyanez az OrderID az OrderDetail-ben
select *
from OrderDetail od
where od.OrderID = 43662

-- a darabszám
select count(od.OrderID) -- ha van érték (nem null),ott számol egyet
from OrderDetail od
where od.OrderID = 43662

--distinct a countban
select count(distinct od.OrderID) -- így csak egyet számol, ha többször is fordul elő
from OrderDetail od
where od.OrderID = 43662

-- így visszaadja az összes ismétlődést
select od.OrderID
from OrderDetail od
where od.OrderID = 43662

-- így csak egyet; distinct a mezőnév előtt
select distinct od.OrderID
from OrderDetail od
where od.OrderID = 43662