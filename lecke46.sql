select
    YEAR(OrderDate) as [Year],
    MONTH(OrderDate) as [Month],
    DAY(OrderDate) as [Day],
    count(*) as [Count],
    sum(Subtotal) as [Total]
from Orders
group BY
    YEAR(OrderDate)
    ,MONTH(OrderDate)
    ,DAY(OrderDate)
with rollup  --rész összesítések
--order by 1, 2

select
    YEAR(OrderDate) as [Year],
    MONTH(OrderDate) as [Month],
    --DAY(OrderDate) as [Day],
    count(*) as [Count],
    sum(Subtotal) as [Total]
from Orders
group BY
    YEAR(OrderDate)
    ,MONTH(OrderDate)
    --,DAY(OrderDate)
with cube --kocka OLAP aggregációk,összesítések