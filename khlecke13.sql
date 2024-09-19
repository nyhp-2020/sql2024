select year(Orderdate) as Year,month(OrderDate) as Month,count(*) as Orders,sum(Subtotal) as Total
from Orders
group by year(Orderdate),month(OrderDate)
order by year(Orderdate),month(OrderDate)

--éves görgetett összegek számítása
with O as(
    select year(Orderdate) as Year,month(OrderDate) as Month,count(*) as Orders,sum(Subtotal) as Total
    from Orders
    group by year(Orderdate),month(OrderDate)
    --order by year(Orderdate),month(OrderDate)
)
select *,
    sum(Orders) over(partition by Year order by Month) as RunningOrders,
    sum(Total) over(partition by Year order by Month) as RunningTotal
from o
order by 1,2

--alap tábla elkészítés
select year(Orderdate) as Year,month(OrderDate) as Month,sum(Subtotal) as Total
from Orders
group by year(Orderdate),month(OrderDate)
order by 1,2

--allekérdezésbe tesszük
select *, avg(Total) over(partition by Year order by Month)
from(
    select year(Orderdate) as Year,month(OrderDate) as Month,sum(Subtotal) as Total
    from Orders
    group by year(Orderdate),month(OrderDate)
    --order by 1,2
) t
order by 1,2

--háromhavi mozgóátlag (az aktuális és az előző 2 hónap átlaga), évhatárok nélkül
select *, avg(Total) over(order by Year,Month rows between 2 preceding and current row)
from(
    select year(Orderdate) as Year,month(OrderDate) as Month,sum(Subtotal) as Total
    from Orders
    group by year(Orderdate),month(OrderDate)
) t
order by 1,2

-- az átlagban résztvevők megszámlálása
select *,
        avg(Total) over(order by Year,Month rows between 2 preceding and current row),
        count(Total) over(order by Year,Month rows between 2 preceding and current row)
from(
    select year(Orderdate) as Year,month(OrderDate) as Month,sum(Subtotal) as Total
    from Orders
    group by year(Orderdate),month(OrderDate)
) t
order by 1,2

--ha nincs 3 db az átlagban, nem jelenítem meg
select *,
        --avg(Total) over(order by Year,Month rows between 2 preceding and current row),
        --count(Total) over(order by Year,Month rows between 2 preceding and current row),
        case when count(Total) over(order by Year,Month rows between 2 preceding and current row) >= 3
             then avg(Total) over(order by Year,Month rows between 2 preceding and current row)
             else 0 --v. null
        end as [3MounthsMovingAvg] --csak így kezdődhet számmal az oszlopnév
from(
    select year(Orderdate) as Year,month(OrderDate) as Month,sum(Subtotal) as Total
    from Orders
    group by year(Orderdate),month(OrderDate)
) t
order by 1,2