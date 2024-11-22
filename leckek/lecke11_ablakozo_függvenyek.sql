select *,
        lag(OrderDate, 1, Orderdate) over(order by OrderDate) as [Előző],  --előző sor (egy lépés vissza)
        lead(OrderDate, 1, OrderDate) over(order by OrderDate) as [Következő] --következő sor (egy lépés előre)
from Orders
where CustomerID = 29734
order by OrderDate


select 
    *, 
    lag(OrderDate, 1, OrderDate) over(order by OrderDate) as [LAG],
    lead(OrderDate, 1, OrderDate) over(order by OrderDate) as [LEAD],
    first_value(SubTotal) over(partition by CustomerID order by (select null))
from Orders
--where CustomerID = 29734
order by CustomerID, OrderDate


select 
    *, 
    lag(OrderDate, 1) over(partition by CustomerID order by OrderDate) as [LAG],     --particion by CustomerID Minden CustomerID-nél újraindul az előző, következő sor keresése
    lead(OrderDate, 1) over(partition by CustomerID order by OrderDate) as [LEAD],
    first_value(SubTotal) over(partition by CustomerID order by (select null))
from Orders
--where CustomerID = 29734
order by CustomerID, OrderDate


select 
    *, 
    lag(OrderDate, 1, OrderDate) over(partition by CustomerID order by OrderDate) as [LAG],     --particion by CustomerID Minden CustomerID-nél újraindul az előző, következő sor keresése
    lead(OrderDate, 1, OrderDate) over(partition by CustomerID order by OrderDate) as [LEAD],
    first_value(SubTotal) over(partition by CustomerID order by (select null))                  -- ha az order by lényegtelen : order by (select null)
from Orders
--where CustomerID = 29734
order by CustomerID, OrderDate


--Számítsuk ki, hogy az egyes vásárlók vásárlásai között hány nap telt el.

select *, datediff(day, OrderDate, NextOrderDate) Days 
from (
    select 
        OrderID,
        CustomerID,
        OrderDate,
        lead(OrderDate) over(partition by CustomerID order by OrderDate) as NextOrderDate
    from Orders 

) o
order by CustomerID, OrderDate, OrderID 


select 
    OrderID, OrderDate, Subtotal,
    lead(Subtotal)          over(partition by CustomerID order by OrderID) [LEAD],
    lag(Subtotal)           over(partition by CustomerID order by OrderID) [LAG],
    first_value(Subtotal)   over(partition by CustomerID order by OrderID) [FIRST_VALUE_1],  --helyes
    last_value(Subtotal)    over(partition by CustomerID order by OrderID desc) [FIRST_VALUE_2], -- !!! nem jó
    first_value(Subtotal)   over(partition by CustomerID order by OrderID rows between unbounded preceding and unbounded following) [FIRST_VALUE_3],
    last_value(Subtotal)    over(partition by CustomerID order by OrderID) [LAST_VALUE_1], -- !!! nem jó
    first_value(Subtotal)   over(partition by CustomerID order by OrderID desc) [LAST_VALUE_2], -- helyes
    last_value(Subtotal)    over(partition by CustomerID order by OrderID rows between unbounded preceding and unbounded following) [LAST_VALUE_3]
from Orders
where CustomerID = 11000
order by OrderID
