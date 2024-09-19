-- 2. Listázzuk ki azokat a vásárlókat, akik a tavalyi évben vásároltak, de az idén még nem.
-- Szimuláljuk az adatokat 2018 és 2022 között
-- Mutassuk meg az érintett vásárlók utolsó vásárlását az előző évből (dátum,összeg).

drop table if exists #adatok

select
    OrderID,
    dateadd(year,10,OrderDate) as OrderDate,
    CustomerID,
    SalesPersonID,
    Subtotal
    into #adatok --itt hozom létre
from Orders

select * from #adatok

select *
from #adatok
where OrderDate >= datefromparts(year(dateadd(year,-2, getdate())),month(dateadd(year,-2, getdate())),1)
and OrderDate < datefromparts(year(getdate()),month(getdate()),1) --a vége előtt minden (aktuális hónap elseje)

-- a vásárlók,akik a "tavalyi" évben vásároltak
select distinct CustomerID
from #adatok
where OrderDate between '2021-01-01' and '2021-12-31'

except --kivéve (akik tavaly vásároltak, de az idén nem)

-- az "idén" vásárlók
select distinct CustomerID
from #adatok
where OrderDate between '2022-01-01' and '2022-12-31'


-- 2. Listázzuk ki azokat a vásárlókat, akik a tavalyi évben vásároltak, de az idén még nem.
select Customer.*
from(
    select distinct CustomerID
    from #adatok
    where OrderDate between '2021-01-01' and '2021-12-31'

    except --kivéve (akik tavaly vásároltak, de az idén nem)

    select distinct CustomerID
    from #adatok
    where OrderDate between '2022-01-01' and '2022-12-31' 
 ) c
 join Customer on Customer.CustomerID = c.CustomerID

-- számított dátumokkal
select Customer.*
from(
    select distinct CustomerID
    from #adatok
    --where OrderDate between '2021-01-01' and '2021-12-31'
    where OrderDate between datefromparts(year(getdate()) -1, 1, 1) and datefromparts(year(getdate()) -1, 12, 31) --előző év jan.1- től dec.31-ig

    except --kivéve (akik tavaly vásároltak, de az idén nem)

    select distinct CustomerID
    from #adatok
    --where OrderDate between '2022-01-01' and '2022-12-31'
    where OrderDate between datefromparts(year(getdate()), 1, 1) and datefromparts(year(getdate()), 12, 31) --aktuális év jan.1- től dec.31-ig (2024)
 ) c
 join Customer on Customer.CustomerID = c.CustomerID


-- Mutassuk meg az érintett vásárlók utolsó vásárlását az előző évből (dátum,összeg).
select Customer.CustomerID, last_order.OrderDate,last_order.SubTotal
from(
    select distinct CustomerID
    from #adatok
    where OrderDate between datefromparts(year(getdate()) -1, 1, 1) and datefromparts(year(getdate()) -1, 12, 31) --előző év jan.1- től dec.31-ig

    except --kivéve (akik tavaly vásároltak, de az idén nem)

    select distinct CustomerID
    from #adatok
    where OrderDate between datefromparts(year(getdate()), 1, 1) and datefromparts(year(getdate()), 12, 31) --aktuális év jan.1- től dec.31-ig (2024)
 ) c
 join Customer on Customer.CustomerID = c.CustomerID
 outer apply( --allekérdezés: minden Customer utolsó vásárlása (azok akik tavaly vásároltak, de az idén nem)
    select top 1 *
    from #adatok o
    where o.CustomerID = c.CustomerID
    order by OrderDate desc
 ) last_order