--Gyakorlatok
-- Készítsünk egy sriptet, amely a biztonsági mentés fájlnevét generálja le
-- egy @file nevű változóba a következő formátumban: Backup_ééé_hh_óóppmm.bak

declare @file varchar(2000)
set @file = 'Backup_' + format(getdate(), 'yyyy_MM_dd_hh_mm_ss') + '.bak'

set @file = 'Backup_' + cast(year(getdate()) as varchar(4)) + '_' 
                      + cast(month(getdate()) as varchar(2)) + '_'
                      + cast(day(getdate()) as varchar(2)) + '.bak'

select @file

--Készítsünk egy scriptet, amely megméri egy lekérdezés futási idejét
--és visszaadja ezred másodpercekben (millisecond) -

declare @most datetime = getdate()

select top 100 * from Customer c
outer apply(select sum (SubTotal) T from Orders where c.CustomerID = c.CustomerID) o

select datediff(ms, @most, getdate())
print datediff(ms, @most, getdate()) --messages tab-ra írja



declare @most datetime = getdate()
-- lehet, hogy ez volt az eredeti szándék...
select top 100 * from Customer c
outer apply(select sum (SubTotal) T from Orders o where c.CustomerID = o.CustomerID) o

select datediff(ms, @most, getdate())
print datediff(ms, @most, getdate()) --messages tab-ra írja


--Írjunk egy lekérdezést, amely két változóba lekérdezi,
-- hogy mely vásárlónak volt a legtöbb vásárlása és megjeleníti a következő formátumban:
-- CustomerID: 11176, Orders: 28


select top 1 CustomerID, count(*) Orders
from Orders
group by CustomerID
order by Orders desc


declare @eredmeny nvarchar(100)

select top 1 @eredmeny = 'CustomerID: ' +  cast(CustomerID as varchar(10)) + ', Orders: ' +  cast(count(*) as varchar(10))
from Orders
group by CustomerID
order by count(*) desc

print @eredmeny

-- Egy select vagy változónak ad értéket, vagy eredményhalmazzal tér vissza. Egyszerre a kettő nem lehetséges.
-- ilyet nem lehet
declare @FirstName nvarchar(100)
select @FirstName = FirstName, Lastname
from Customer
