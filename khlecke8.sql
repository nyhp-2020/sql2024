--kiinduláss
select
    year(OrderDate) as [Year],
    month(OrderDate) as [Month],
    count(*) Orders,
    sum(SubTotal) Total
from Orders
where year(OrderDate) = 2012
group by year(OrderDate),month(OrderDate)
order by 1,2


select *, count(*) over() --az összegző függvényekhez nem kötelező megadni partition by-t v. order by-t (a rangsorolókhoz kötelező)
from (
    select
        year(OrderDate) as [Year],
        month(OrderDate) as [Month],
        count(*) Orders,
        sum(SubTotal) Total
    from Orders
    where year(OrderDate) = 2012
    group by year(OrderDate),month(OrderDate)
    --order by 1,2
) s
order by 1,2


select *, sum(Orders) over() --az összegző függvényekhez nem kötelező megadni partition by-t v. order by-t- Ilyenkor minden sorban megjelenik az összegzés
from (
    select
        year(OrderDate) as [Year],
        month(OrderDate) as [Month],
        count(*) Orders,
        sum(SubTotal) Total
    from Orders
    where year(OrderDate) = 2012
    group by year(OrderDate),month(OrderDate)
    --order by 1,2
) s
order by 1,2


select *, sum(Orders) over(partition by Year)
from (
    select
        year(OrderDate) as [Year],
        month(OrderDate) as [Month],
        count(*) Orders,
        sum(SubTotal) Total
    from Orders
    --where year(OrderDate) = 2012
    group by year(OrderDate),month(OrderDate)
    --order by 1,2
) s
order by 1,2


select *, sum(Orders) over(partition by Year,Month)
from (
    select
        year(OrderDate) as [Year],
        month(OrderDate) as [Month],
        count(*) Orders,
        sum(SubTotal) Total
    from Orders
    where year(OrderDate) = 2012
    group by year(OrderDate),month(OrderDate)
    --order by 1,2
) s
order by 1,2

-- ilyenkor soronként göngyölített összeget számol (futó összeg)
select *, sum(Orders) over(partition by Year order by Month)
from (
    select
        year(OrderDate) as [Year],
        month(OrderDate) as [Month],
        count(*) Orders,
        sum(SubTotal) Total
    from Orders
    where year(OrderDate) = 2012
    group by year(OrderDate),month(OrderDate)
    --order by 1,2
) s
order by 1,2

-- ekkor az egész táblázaton számol göngyölt összeget (nincs partition by)
select *, sum(Orders) over(order by Year,Month)
from (
    select
        year(OrderDate) as [Year],
        month(OrderDate) as [Month],
        count(*) Orders,
        sum(SubTotal) Total
    from Orders
    --where year(OrderDate) = 2012
    group by year(OrderDate),month(OrderDate)
    --order by 1,2
) s
order by 1,2

-- itt évenként kezdi a göngyölítést a partition by miatt
select *, sum(Orders) over(partition by Year order by Year,Month)
from (
    select
        year(OrderDate) as [Year],
        month(OrderDate) as [Month],
        count(*) Orders,
        sum(SubTotal) Total
    from Orders
    --where year(OrderDate) = 2012
    group by year(OrderDate),month(OrderDate)
    --order by 1,2
) s
order by 1,2
-- a partition by-nál indul az új ablak
-- az order by-al nő az ablak mérete


select [Year],[Month],
    Orders,Total,
    sum(Orders) over(partition by [Year] order by [Month]) RunningOrders,
    sum(Total) over(partition by [Year] order by [Month]) RunningTotal, -- növekvő ablak az order by miatt
    sum(Total) over(partition by [Year]) YearTotal,
    max(Total) over(partition by [Year]) YearMaxTotal,
    sum(Total) over() Total
from (
    select
        year(OrderDate) as [Year],
        month(OrderDate) as [Month],
        count(*) Orders,
        sum(SubTotal) Total
    from Orders
    where year(OrderDate) in (2012,2013)
    group by year(OrderDate),month(OrderDate)
) totals


select [Year],[Month],
    Orders,Total,
    sum(Orders) over(partition by [Year] order by [Month]) RunningOrders,
    sum(Total) over(partition by [Year] order by [Month]) RunningTotal, -- növekvő ablak az order by miatt
    sum(Total) over(partition by [Year]) YearTotal,
    max(Total) over(partition by [Year] order by Month) YearMaxTotal --itt ez is egyre növekvő ablakban számolódik
    --ablak felső széle rögzített, az alsó széle az aktuális sor
    --sum(Total) over() Total
from (
    select
        year(OrderDate) as [Year],
        month(OrderDate) as [Month],
        count(*) Orders,
        sum(SubTotal) Total
    from Orders
    where year(OrderDate) in (2012,2013)
    group by year(OrderDate),month(OrderDate)
) totals


select [Year],[Month],
    Orders,Total,
    sum(Orders) over(partition by [Year] order by [Month]) RunningOrders,
    sum(Total) over(partition by [Year] order by [Month]) RunningTotal, -- növekvő ablak az order by miatt
    sum(Total) over(partition by [Year]) YearTotal,
    max(Total) over(partition by [Year] order by Month) YearMaxTotal,
    max(Total) over(partition by [Year] order by Month rows between unbounded preceding and current row) --ez ugyanaz (felső szélétől az aktuálisig)
from (
    select
        year(OrderDate) as [Year],
        month(OrderDate) as [Month],
        count(*) Orders,
        sum(SubTotal) Total
    from Orders
    where year(OrderDate) in (2012,2013)
    group by year(OrderDate),month(OrderDate)
) totals


select [Year],[Month],
    Orders,Total,
    sum(Orders) over(partition by [Year] order by [Month]) RunningOrders,
    sum(Total) over(partition by [Year] order by [Month]) RunningTotal, -- növekvő ablak az order by miatt
    sum(Total) over(partition by [Year]) YearTotal,
    max(Total) over(partition by [Year] order by Month) YearMaxTotal,
    max(Total) over(partition by [Year] order by Month rows between unbounded preceding and unbounded following ) -- ez mindig a teljes ablak
from (
    select
        year(OrderDate) as [Year],
        month(OrderDate) as [Month],
        count(*) Orders,
        sum(SubTotal) Total
    from Orders
    where year(OrderDate) in (2012,2013)
    group by year(OrderDate),month(OrderDate)
) totals