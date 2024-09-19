-- Kérdezzük le az elmúlt 2 év teljes eladásait a mai napig. 
-- Ehhez szimulálnunk kell adatokat az elmúlt 2 évre (OrderDate + 8 év).
-- Tegyük meg ugyanezt ezt a hónap elejéig vagy egész hónapokra 
-- (tehát 2022 áprilisban 2020 április 1 és 2022 március 31 között).

drop table if exists #adatok

select
    OrderID,
    dateadd(year, 8, OrderDate) as OrderDate,
    CustomerID,
    SalesPersonID,
    SubTotal
into #adatok
from Orders

-- mai napig
select * 
from #adatok
where OrderDate > cast(DATEADD(year, -2, GETDATE()) as date)
and OrderDate < cast(GETDATE() as date)

-- aktuális hónapig BETWEEN
select * 
from #adatok
where 
OrderDate between DATEFROMPARTS(Year(DATEADD(year, -2, GETDATE())), Month(DATEADD(year, -2, GETDATE())), 1)
and DATEADD(day, -1, DATETIMEFROMPARTS(Year(GETDATE()), Month(GETDATE()), 1, 23, 59, 59, 900))

-- aktuális hónapig BETWEEN nélkül
select * 
from #adatok
where 
OrderDate >= DATEFROMPARTS(Year(DATEADD(year, -2, GETDATE())), Month(DATEADD(year, -2, GETDATE())), 1)
and OrderDate < DATEFROMPARTS(Year(GETDATE()), Month(GETDATE()), 1)


