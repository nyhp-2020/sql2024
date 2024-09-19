select * from orders

select CustomerID,count(*) as cnt,avg(SubTotal) as avg
from Orders
group by CustomerID
having count(*) >= 25

select CustomerID,avg(SubTotal) as avg
from Orders
group by CustomerID
having count(*) >= 25

-- itt két Customer van kiválasztva
select 'Customer' as Customer,
    [14324],[22814]
from(
    select CustomerID,Subtotal
    from Orders
) p
pivot(avg(Subtotal) for CustomerID in ([14324],[22814]) ) pvt


select CustomerID,avg(SubTotal) as avg,count(*)
from Orders
group by CustomerID
having count(*) >= 25

--itt 14 db a fenti lekérdezésből
select 'Customer' as Customer,
    [11287],[11330],[11711],[11176],[11276],[11331],[11262],
    [11185],[11566],[11300],[11200],[11277],[11091],[11223]
from( -- ebben ismétlődik többször a CustomerID (több vásárlása adott ügyfélnek)
    select CustomerID,Subtotal
    from Orders
) p
-- A kiválasztott ügyfelek Subtotal átlagai jelennek meg egy sorban
pivot(avg(Subtotal) for CustomerID in ([11287],[11330],[11711],[11176],[11276],[11331],[11262],
                                       [11185],[11566],[11300],[11200],[11277],[11091],[11223]) ) pvt


-- sorba kiírja hány rendelése van a kiválasztott ügyfeleknek
select 'Orders',[11287],[11330],[11176]
from(
    select OrderID,CustomerID
    from Orders
    ) p
pivot(count(OrderID) for CustomerID in ([11287],[11330],[11176])) pvt

-- éves bontásban írja ki a kiválasztott ügyfelek rendeléseit
select Year,[11287],[11330],[11176]
from(
    select year(OrderDate) as Year,OrderID,CustomerID
    from Orders
    ) p
pivot(count(OrderID) for CustomerID in ([11287],[11330],[11176])) pvt

-- éves bontásban írja ki a kiválasztott ügyfelek rendeléseit
select [11287],[11330],[11176],Year
from(
    select OrderID,CustomerID,year(OrderDate) as Year
    from Orders
    ) p
pivot(count(OrderID) for CustomerID in ([11287],[11330],[11176])) pvt


-- év + hó bontásban írja ki a kiválasztott ügyfelek rendeléseit
select Year,Month,[11287],[11330],[11176]
from(
    select year(OrderDate) as Year,month(OrderDate) Month,OrderID,CustomerID
    from Orders
    ) p
pivot(count(OrderID) for CustomerID in ([11287],[11330],[11176])) pvt
order by 1,2