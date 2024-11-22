select 
    year(Orderdate) as Year,
    month(OrderDate) as Month,
    sum(SubTotal) as Total
from Orders
group by  year(Orderdate) , month(OrderDate)
order by 1,2

--mozgóátlagok éveken belül
select *, avg(Total) over(partition by Year order by Month rows between 2 preceding and current row)
from(
    select 
        year(Orderdate) as Year,
        month(OrderDate) as Month,
        sum(SubTotal) as Total
    from Orders
    group by  year(Orderdate) , month(OrderDate)
    --order by 1,2
) t
order by 1,2


--mozgóátlagok éveken áthúzódva
select *, avg(Total) over(order by Year,Month rows between 2 preceding and current row)
from(
    select 
        year(Orderdate) as Year,
        month(OrderDate) as Month,
        sum(SubTotal) as Total
    from Orders
    group by  year(Orderdate) , month(OrderDate)
    --order by 1,2
) t
order by 1,2

--
select *,
     avg(Total) over(order by Year,Month rows between 2 preceding and current row),
     count(Total) over(order by Year,Month rows between 2 preceding and current row) -- ablak sorainak a száma
from(
    select 
        year(Orderdate) as Year,
        month(OrderDate) as Month,
        sum(SubTotal) as Total
    from Orders
    group by  year(Orderdate) , month(OrderDate)
    --order by 1,2
) t
order by 1,2

--csak ha tud 3 sorból átlagot számolni
-- 3 hónapos mozgó átlag számítása:
select *,
     --avg(Total) over(order by Year,Month rows between 2 preceding and current row),
     --count(Total) over(order by Year,Month rows between 2 preceding and current row),
     case when count(Total) over(order by Year,Month rows between 2 preceding and current row) >= 3 -- ablak sorainak a száma
        then avg(Total) over(order by Year,Month rows between 2 preceding and current row)
        else NULL
        --else 0
    end as [3MonthsMovingAvg]
from(
    select 
        year(Orderdate) as Year,
        month(OrderDate) as Month,
        sum(SubTotal) as Total
    from Orders
    group by  year(Orderdate) , month(OrderDate)
    --order by 1,2
) t
order by 1,2