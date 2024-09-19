
select *, sum(Orders) over(partition by Year order by Year, Month)
from (
    select  
        year(OrderDate) AS [Year], 
        month(OrderDate) AS [Month],
        count(*) Orders,
        sum(SubTotal) Total
    from Orders
    --where year(OrderDate) = 2012
    group by year(OrderDate), month(OrderDate)
    --order by 1, 2
) s
order by 1, 2


select  
    [Year], [Month],
    Orders, Total,
    sum(Orders) over(partition by [Year] order by [Month]) RunningOrders,
    sum(Total) over(partition by [Year] order by [Month]) RunningTotal,
    sum(Total) over(partition by [Year]) YearTotal,
    max(Total) over(partition by [Year] order by Month) YearMaxTotal,
    max(Total) over(partition by [Year] order by Month rows between 1 preceding and unbounded following)
from (
    select  
        year(OrderDate) AS [Year], 
        month(OrderDate) AS [Month],
        count(*) Orders,
        sum(SubTotal) Total
    from Orders
    where year(OrderDate) in (2012, 2013)
    group by year(OrderDate), month(OrderDate)
) totals


