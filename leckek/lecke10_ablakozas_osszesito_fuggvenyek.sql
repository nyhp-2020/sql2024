select
    year(OrderDate) as [Year],
    month(OrderDate) as [Month],
    count(*) Orders,
    sum(Subtotal) SubTotal
from Orders
where year(OrderDate) = 2012
group by year(OrderDate),month(OrderDate)
order by 1,2 --(év, hónap)


select *, count(*) over()   --itt nem kötelező megadni rendezést az over-ben
from(   --subquery
    select
        year(OrderDate) as [Year],
        month(OrderDate) as [Month],
        count(*) Orders,
        sum(Subtotal) SubTotal
    from Orders
    where year(OrderDate) = 2012
    group by year(OrderDate),month(OrderDate)
    --order by 1,2 --(év, hónap)
) s
order by 1,2


select *, sum(Orders) over()   --itt nem kötelező megadni rendezést az over-ben
from(   --subquery
    select
        year(OrderDate) as [Year],
        month(OrderDate) as [Month],
        count(*) Orders,
        sum(Subtotal) SubTotal
    from Orders
    where year(OrderDate) = 2012
    group by year(OrderDate),month(OrderDate)
    --order by 1,2 --(év, hónap)
) s
order by 1,2


select *, sum(Orders) over(partition by Year)
from(   --subquery
    select
        year(OrderDate) as [Year],
        month(OrderDate) as [Month],
        count(*) Orders,
        sum(Subtotal) SubTotal
    from Orders
    --where year(OrderDate) = 2012
    group by year(OrderDate),month(OrderDate)
    --order by 1,2 --(év, hónap)
) s
order by 1,2


select *, sum(Orders) over(partition by Year,Month)
from(   --subquery
    select
        year(OrderDate) as [Year],
        month(OrderDate) as [Month],
        count(*) Orders,
        sum(Subtotal) SubTotal
    from Orders
    where year(OrderDate) = 2012
    group by year(OrderDate),month(OrderDate)
    --order by 1,2 --(év, hónap)
) s
order by 1,2

select *, sum(Orders) over(partition by Year order by Month)    --növekvő ablakok; futó v. göngyölt összeg
from(   --subquery
    select
        year(OrderDate) as [Year],
        month(OrderDate) as [Month],
        count(*) Orders,
        sum(Subtotal) SubTotal
    from Orders
    where year(OrderDate) = 2012
    group by year(OrderDate),month(OrderDate)
    --order by 1,2 --(év, hónap)
) s
order by 1,2


select *, sum(Orders) over(order by Year,Month)    --növekvő ablakok; futó v. göngyölt összeg
from(   --subquery
    select
        year(OrderDate) as [Year],
        month(OrderDate) as [Month],
        count(*) Orders,
        sum(Subtotal) SubTotal
    from Orders
    where year(OrderDate) = 2012
    group by year(OrderDate),month(OrderDate)
    --order by 1,2 --(év, hónap)
) s
order by 1,2


select *, sum(Orders) over(order by Year,Month)    --növekvő ablakok; futó v. göngyölt összeg
from(   --subquery
    select
        year(OrderDate) as [Year],
        month(OrderDate) as [Month],
        count(*) Orders,
        sum(Subtotal) SubTotal
    from Orders
    --where year(OrderDate) = 2012          --eredmény összes sorának az összege (nincs partition by)
    group by year(OrderDate),month(OrderDate)
    --order by 1,2 --(év, hónap)
) s
order by 1,2

select *, sum(Orders) over(partition by Year order by Year,Month)    --növekvő ablakok; futó v. göngyölt összeg
from(   --subquery
    select
        year(OrderDate) as [Year],
        month(OrderDate) as [Month],
        count(*) Orders,
        sum(Subtotal) SubTotal
    from Orders
    --where year(OrderDate) = 2012          --ha vanpartition by, évenként újraindul a futó összeg
    group by year(OrderDate),month(OrderDate)
    --order by 1,2 --(év, hónap)
) s
order by 1,2

select 
    [Year], [Month],
    Orders, Total,
    sum(Orders) over(partition by [Year] order by [Month]) RunningOrders,
    sum(Total) over(partition by [Year] order by [Month]) RunningTotal,
    sum(Total) over(partition by [Year]) YearTotal,
    max(Total) over(partition by [Year] order by Month) YearMaxTotal,
    max(Total) over(partition by [Year] order by Month rows between unbounded preceding and current row)
from (
    select
        year(OrderDate) as [Year],
        month(OrderDate) as [Month],
        count(*) Orders,
        sum(Subtotal) Total
    from Orders
    where year(OrderDate) in(2012,2013)
    group by year(OrderDate),month(OrderDate)
) totals