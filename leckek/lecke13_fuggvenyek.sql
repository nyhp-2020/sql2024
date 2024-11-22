-- dátum függvények: datediff
select *, datediff(day, OrderDate, NextOrderDate) Days
from (
    select
        OrderID,
        CustomerID,
        OrderDate,
    lead(OrderDate, 1, OrderDate) over(partition by CustomerID order by OrderDate, OrderID) as NextOrderDate
    from Orders
) o
order by CustomerID, OrderDate, OrderID

-- szöveg függvények:
-- Mutassuk ki, hogy hányféle domain van az Email oszlopban a Customer táblában.
select distinct
    --Email, CHARINDEX('@', Email), LEN(Email), LEN(Email) - CHARINDEX('@', Email), 
    RIGHT(Email, LEN(Email) - CHARINDEX('@', Email))
from Customer