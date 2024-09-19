-- 3 hónapos mozgó átlag számítása:
select 
    *, 
    --avg(Total) over(order by Year, Month rows between 2 preceding and current row),
    --count(Total) over(order by Year, Month rows between 2 preceding and current row),
    case when count(Total) over(order by Year, Month rows between 2 preceding and current row) >= 3
         then avg(Total) over(order by Year, Month rows between 2 preceding and current row)
         else null
    end as [3MonthsMovingAvg]
from (
    select
        year(OrderDate) as Year,
        month(OrderDate) as Month,
        sum(SubTotal) as Total
    from Orders
    group by year(OrderDate), month(OrderDate)
    --order by 1, 2
) t
order by 1, 2