--tempdb adatbázisban Ideiglenes táblák

select max(OrderDate) from Orders

select OrderDate, dateadd(year,8,OrderDate) from Orders --Plusz 8 év

select
    OrderID,
    dateadd(year,8,OrderDate),
    CustomerID,
    SalesPersonID,
    Subtotal
from Orders




drop table if exists #adatok
select
    OrderID,
    dateadd(year,8,OrderDate) as OrderDate,  --nevet kell adni a számított oszlopnak
    CustomerID,
    SalesPersonID,
    Subtotal
into #adatok --ideiglenes tábla
from Orders

select * from #adatok

--kapcsolaton belül egyediek a temp táblák

select *
from #adatok
where OrderDate > '2020-04-14'

select *
from #adatok
where OrderDate > getdate()

select dateadd(year, -2, getdate())

select *
from #adatok
where OrderDate > dateadd(year, -4, getdate())
and OrderDate <= Getdate()

select cast(dateadd(year, -2, getdate()) as date) --dátummá konvertálás

select *
from #adatok
where OrderDate > cast(dateadd(year, -4, getdate()) as date) --így már a reggel 8 órások is benne lesznek (éjféltől mindenki)
and OrderDate <= Getdate()

-- mai napig
select *
from #adatok
where OrderDate > cast(dateadd(year, -4, getdate()) as date) --így már a reggel 8 órások is benne lesznek (éjféltől mindenki)
and OrderDate < cast(Getdate() as date) --tegnap éjfélig

-- aktuális hónapig
select dateadd(year, -2, getdate())

select year(dateadd(year, -4, getdate())),month(dateadd(year, -2, getdate()))-6,1 --cél 2020.04.01

select datefromparts(year(dateadd(year, -4, getdate())),month(dateadd(year, -2, getdate()))-6,1)


select *
from #adatok
where OrderDate between datefromparts(year(dateadd(year, -4, getdate())),month(dateadd(year, -2, getdate()))-6,1)
and dateadd(day, -1,datefromparts(year(getdate()), month(getdate()),1))

select dateadd(day,-1, datetimefromparts(year(getdate()), month(getdate()),1,23,59,59,900))

select *
from #adatok
where OrderDate between datefromparts(year(dateadd(year, -4, getdate())),month(dateadd(year, -2, getdate()))-6,1)
and dateadd(day,-1, datetimefromparts(year(getdate()), month(getdate()),1,23,59,59,900))

-- aktuális hónapig between nélkül
select *
from #adatok
where OrderDate >= datefromparts(year(dateadd(year, -4, getdate())),month(dateadd(year, -2, getdate()))-6,1)
and OrderDate < datefromparts(year(getdate()), month(getdate()),1)

