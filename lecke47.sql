select
    YEAR(OrderDate) as [Year],
    
    count(distinct o.OrderID) as [Count],
    count(case when od.ProductID = 789 then 1 end) as [Count_Product_789]
from Orders o
left join Orderdetail od on od.OrderID = o.OrderID
group BY
    YEAR(OrderDate)

order by 1

--éves bontásban az eladások száma és egy kiemelt termék (ProductID = 789) eladásainak száma
--százalékos arány: adott termék db száma/teljes db szám
--eredeti
select
    YEAR(OrderDate) as [Year], 
    count(o.OrderID) as [Count],
    count(od.ProductID) as [Count_Product_789]
from Orders o
inner join Orderdetail od on od.OrderID = o.OrderID
where od.ProductID = 789
group BY YEAR(OrderDate)


select
    YEAR(OrderDate) as [Year], 
    count(o.OrderID) as [Count]
    --count(od.ProductID) as [Count_Product_789]
from Orders o
inner join Orderdetail od on od.OrderID = o.OrderID
where od.ProductID = 789  --ez szűri az Orders táblát is ha inner join van
group BY YEAR(OrderDate)
order by 1

select
    YEAR(OrderDate) as [Year], 
    count(o.OrderID) as [Count]
    --count(od.ProductID) as [Count_Product_789]
from Orders o
left join Orderdetail od on od.OrderID = o.OrderID
where od.ProductID = 789 -- ha left joint használunk, akkor a jobb oldali táblára nem szabad szűrést csinálni. Mert az rögtön inner join-ná alakítja a left join-t
group BY YEAR(OrderDate)
order by 1
-- left joinnál csak a bal oldali táblára szűrhetünk, a jobb oldalira nem

-- ha a jobb oldali táblára szűrni kell, a szűrési feltételt átalakítom kapcsolási feltétellé (where-ből on záradékba)
select
    YEAR(OrderDate) as [Year], 
    count(o.OrderID) as [Count],
    count(od.ProductID) as [Count_Product_789]
from Orders o
left join Orderdetail od on od.OrderID = o.OrderID and od.ProductID = 789
group BY YEAR(OrderDate)
order by 1

--az éves eladás számok még nem jók?...

select count(*) from Orders where YEAR(OrderDate) = 2013

select count(*) from Orders where YEAR(OrderDate) = 2012

--ha a szűrés feltételben null értékek szerepelnek, azok eltűnnek (ez történik a left join jobb oldali táblájának null-os értékeivel is, eltűnnek, nem érvényesül a left join)
select * from Customer where Title = 'Mr.'

--csak így kerülnek bele a null értékek
select * from Customer where Title = 'Mr.' or Title is null

select
    YEAR(OrderDate) as [Year], 
    count(o.OrderID) as [Count],
    count(od.ProductID) as [Count_Product_789]
from Orders o
left join Orderdetail od on od.OrderID = o.OrderID and od.ProductID > 0 -- ahol null van, ott nincs egyezés
group BY YEAR(OrderDate)
order by 1

select
    YEAR(OrderDate) as [Year], 
    count(o.OrderID) as [Count],
    count(od.ProductID) as [Count_Product_789]
from Orders o
left join Orderdetail od on od.OrderID = o.OrderID and od.ProductID = 789
where od.ProductID > 0  -- így nem kapom vissza a null-okat
group BY YEAR(OrderDate)
order by 1


select
    YEAR(OrderDate) as [Year], 
    o.OrderID,
    od.ProductID
from Orders o
left join Orderdetail od on od.OrderID = o.OrderID and od.ProductID = 789 -- nullok lesznek ha nem 789 a ProductID
where od.ProductID > 0  -- így nem kapom vissza a null-okat mert szűrök a jobb oldali táblára -> kinyírja a left join-t
order by 1

--inner join-nál mindegy is hogy a where-ben v. az on záradékban van a feltétel

select
    YEAR(OrderDate) as [Year], 
    o.OrderID,
    od.ProductID
from Orders o
left join Orderdetail od on od.OrderID = o.OrderID and od.ProductID = 789 -- nullok lesznek ha nem 789 a ProductID
where od.ProductID is null --ez tud kezdeni valamit a null-okkal, itt az on feltétel biztos, hogy nem teljesül
order by 1

select
    YEAR(OrderDate) as [Year], 
    o.OrderID,
    od.ProductID
from Orders o
left join Orderdetail od on od.OrderID = o.OrderID and od.ProductID = 789
where od.ProductID is not null --ez is inner join-ná változtatja

-- (od.ProductID is not null) az univerzális változata  ennek: (od.ProductID > 0) (egyáltalán van-e érték)