select 
    YEAR(OrderDate) as [Year],
    COUNT(o.OrderID) as [Count],
    COUNT(od.ProductID) as [Count_Product_789]
from Orders o
left join OrderDetail od on od.OrderID = o.OrderID and od.ProductID = 789
group by YEAR(OrderDate)
order by 1

select 
    YEAR(OrderDate) as [Year],
    count(distinct o.OrderID),
    sum(case when od.ProductID = 789 then 1 else 0 end)
from Orders o
left join OrderDetail od on od.OrderID = o.OrderID --and od.ProductID = 789
group by YEAR(OrderDate)
order by 1

select *
from Orders o
where o.OrderID = 43662

select distinct od.OrderID
from OrderDetail od
where od.OrderID = 43662

select count(od.OrderID), count(distinct od.OrderID)
from OrderDetail od
where od.OrderID = 43662


