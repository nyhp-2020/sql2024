-- kiindulás egy ügyfél vásárlásai
select *
from Orders
where CustomerID = 29734
order by OrderDate


select *,lag(OrderDate) over(order by OrderDate) --előző, az elsőnél null
from Orders
where CustomerID = 29734
order by OrderDate


select *,lag(OrderDate,2) over(order by OrderDate) --előző, az elsőnél null Ez két sorral lép vissza lag fv. második paramétere
from Orders
where CustomerID = 29734
order by OrderDate


select *,lag(OrderDate,1,'2000-01-01') over(order by OrderDate) --lag harmadik paraméter: mivel térjen vissza, ha nincs előző
from Orders
where CustomerID = 29734
order by OrderDate


select *,lag(OrderDate,1,OrderDate) over(order by OrderDate) --lag harmadik paraméter: mivel térjen vissza, ha nincs előző; ugyanazt is megadhatom
from Orders
where CustomerID = 29734
order by OrderDate


select *,
    lag(OrderDate,1,OrderDate) over(order by OrderDate),
    lead(OrderDate) over(order by OrderDate) -- ez egysorral előre felé néz; utolsó sorban null
from Orders
where CustomerID = 29734
order by OrderDate


select *,
    lag(OrderDate,1,OrderDate) over(order by OrderDate),
    lead(OrderDate,1,OrderDate) over(order by OrderDate) -- ez egysorral előre felé néz
from Orders
where CustomerID = 29734
order by OrderDate


select *,
    lag(OrderDate,1) over(partition by CustomerID order by OrderDate) as [LAG],
    lead(OrderDate,1) over(partition by CustomerID order by OrderDate) as [LEAD] -- ez egysorral előre felé néz
from Orders
--where CustomerID = 29734
order by CustomerID,OrderDate

select *,
    lag(OrderDate,1, OrderDate) over(partition by CustomerID order by OrderDate) as [LAG],
    lead(OrderDate,1, OrderDate) over(partition by CustomerID order by OrderDate) as [LEAD] -- ez egysorral előre felé néz
from Orders
--where CustomerID = 29734
order by CustomerID,OrderDate


select *,
    lag(OrderDate,1, OrderDate) over(partition by CustomerID order by OrderDate) as [LAG],
    lead(OrderDate,1, OrderDate) over(partition by CustomerID order by OrderDate) as [LEAD],
    first_value(SubTotal) over(partition by CustomerID order by (select null) ) --ha nem kell order by, de a függvénynek kell
from Orders
--where CustomerID = 29734
order by CustomerID,OrderDate

-- Számítsuk ki, hogy az egyes vásárlók vásárlásai között hány nap telt el.

select *, datediff(day, OrderDate, NextOrderDate) Days
from (
    select 
        OrderID,
        CustomerId,
        OrderDate,
        lead(OrderDate) over(partition by CustomerID order by OrderDate) as NextOrderDate
    from Orders
) o
order by CustomerID, OrderDate, OrderID


select 
        OrderID,OrderDate,Subtotal,
        lead(Subtotal)          over(partition by CustomerID order by OrderID) [LEAD],
        lag(Subtotal)           over(partition by CustomerID order by OrderID) [LAG],
        first_value(Subtotal)   over(partition by CustomerID order by OrderID) [FIRST_VALUE_1],
        last_value(Subtotal)    over(partition by CustomerID order by OrderID desc) [FIRST_VALUE_2], --!!!!
        first_value(Subtotal)   over(partition by CustomerID order by OrderID rows between unbounded preceding and unbounded following) [FIRST_VALUE_3],
        last_value(Subtotal)    over(partition by CustomerID order by OrderID) [LAST_VALUE_1], --!!!! ez nem jó (különböző ablakméretek miatt)
        first_value(Subtotal)   over(partition by CustomerID order by OrderID desc) [LAST_VALUE_2], --ez a helyes
        last_value(Subtotal)    over(partition by CustomerID order by OrderID rows between unbounded preceding and unbounded following) [LAST_VALUE_3]
from Orders
where CustomerID = 11000
order by OrderID


