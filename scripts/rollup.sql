-- adjunk az összesítéshez havi, éves és teljes részösszesítést
select 
    YEAR(OrderDate) as [Year],
    MONTH(OrderDate) as [Month],
    DAY(OrderDate) as [Day],
    count(*) as [Count],
    sum(SubTotal) as [Total]
from Orders
group by
    YEAR(OrderDate)
    ,MONTH(OrderDate)
    ,DAY(OrderDate)
with rollup