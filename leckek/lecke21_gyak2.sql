drop table if exists #adatok
select
    OrderID,
    dateadd(year,8,OrderDate) as OrderDate,  --nevet kell adni a számított oszlopnak
    CustomerID,
    SalesPersonID,
    Subtotal
into #adatok --ideiglenes tábla
from Orders

--"tavaji" vásárlások
select *
from #adatok
where OrderDate between '2021-01-01' and '2021-12-31'

-- tavaj vásárlók listája
select distinct CustomerID
from #adatok
where OrderDate between '2021-01-01' and '2021-12-31'

except --tavaj vásároltak, de az idén nem 

-- idén vásároltak
select distinct CustomerID
from #adatok
where OrderDate between '2022-01-01' and '2022-12-31'


--
select Customer.*
from(
    select distinct CustomerID
    from #adatok
    where OrderDate between '2021-01-01' and '2021-12-31'

    except --tavaj vásároltak, de az idén nem 

    select distinct CustomerID
    from #adatok
    where OrderDate between '2022-01-01' and '2022-12-31'
) c
join Customer on Customer.CustomerID = c.CustomerID

-- A dátumokat számítjuk (itt most 2024 évből: year(getdate())-3 )

select Customer.*
from(
    select distinct CustomerID
    from #adatok
    --where OrderDate between '2021-01-01' and '2021-12-31'
    where OrderDate between datefromparts(year(getdate())-3,1,1) and datefromparts(year(getdate())-3,12,31)

    except --tavaj vásároltak, de az idén nem 

    select distinct CustomerID
    from #adatok
    --where OrderDate between '2022-01-01' and '2022-12-31'
     where OrderDate between datefromparts(year(getdate())-2,1,1) and datefromparts(year(getdate())-2,12,31)
) c
join Customer on Customer.CustomerID = c.CustomerID

--utolsó vásárlás az előző évből

select Customer.CustomerID,last_order.OrderDate,last_order.SubTotal
from(
    select distinct CustomerID
    from #adatok
    --where OrderDate between '2021-01-01' and '2021-12-31'
    where OrderDate between datefromparts(year(getdate())-3,1,1) and datefromparts(year(getdate())-3,12,31)

    except --tavaj vásároltak, de az idén nem 

    select distinct CustomerID
    from #adatok
    --where OrderDate between '2022-01-01' and '2022-12-31'
     where OrderDate between datefromparts(year(getdate())-2,1,1) and datefromparts(year(getdate())-2,12,31)
) c
join Customer on Customer.CustomerID = c.CustomerID
outer apply(
    select top 1 *
    from #adatok o 
    where o.CustomerID = c.CustomerID
    order by OrderDate desc
) last_order
