select 
    *, 
    lag(OrderDate, 1, OrderDate) over(partition by CustomerID order by OrderDate) as [LAG],
    lead(OrderDate, 1, OrderDate) over(partition by CustomerID order by OrderDate) as [LEAD],
    first_value(SubTotal) over(partition by CustomerID order by (select null))
from Orders
--where CustomerID = 29734
order by CustomerID, OrderDate