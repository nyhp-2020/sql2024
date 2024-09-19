--ideiglenes táblák
--create table #...
--select...into #... from

--Kérdezzük le az elmúlt 2 éc teljes eladásait a mai napig.
--Ehhez szimulálni kell adatokat az elmúlt 2 évre (OrderDate + 10 év).
--Tegyük meg ugyanezt a hónap elejéig vagy egész hónapokra
--(tehát 2022 áprilisban április1 és... között).

select max(orderdate) from Orders

select OrderDate, dateadd(year,9,OrderDate) from Orders --újabb dátum létrehozása

--újabb dátum oszlop létrehozása
select
    OrderID,
    dateadd(year,9,OrderDate),
    CustomerID,
    SalesPersonID,
    Subtotal
from Orders

--ideiglenes tábla létrehozása (csak egyszer lehet lefuttatni egy kapcsolaton)

drop table if exists #adatok

select
    OrderID,
    dateadd(year,8,OrderDate) as OrderDate,
    CustomerID,
    SalesPersonID,
    Subtotal
    into #adatok --itt hozom létre
from Orders

--tábla lekérdezése
select * from #adatok

select *
from #adatok
where OrderDate > '2020-04-14'

select *
from #adatok
where OrderDate > GETDATE() --ez a mai dátum

select dateadd(year,-2, getdate()) -- a mai dátum minusz két év


select *
from #adatok
where OrderDate > dateadd(year,-2, getdate())
and OrderDate <= getdate() --jövőbeni adatok kiszűrése

select cast(cast(dateadd(year,-2, getdate()) as date) as datetime) -- dátummá konvertálás

--mai napig
select *
from #adatok
where OrderDate > cast(dateadd(year,-2, getdate()) as date)
and OrderDate < cast(getdate() as date) -- a mai nap már nem

-- aktuális hónapig
select datefromparts(year(dateadd(year,-2, getdate())),month(dateadd(year,-2, getdate())),1) -- a két évvel ezelőtti hónap elseje

select datefromparts(year(getdate()),month(getdate()),1) --aktuális hónap elseje

select dateadd(day, -1,datefromparts(year(getdate()),month(getdate()),1)) --előző hónap utolsó napja

select dateadd(day, -1,datetimefromparts(year(getdate()),month(getdate()),1,23,59,59,900))--előző hónap utolsó napja éjfélig

--aktuális hónapig BETWEEN
select *
from #adatok
where OrderDate between datefromparts(year(dateadd(year,-2, getdate())),month(dateadd(year,-2, getdate())),1) --a between zárt intervallum
and dateadd(day, -1,datetimefromparts(year(getdate()),month(getdate()),1,23,59,59,900))

--aktuális hónapig BETWEEN nélkül
select *
from #adatok
where OrderDate >= datefromparts(year(dateadd(year,-2, getdate())),month(dateadd(year,-2, getdate())),1)
and OrderDate < datefromparts(year(getdate()),month(getdate()),1) --a vége előtt minden (aktuális hónap elseje)
