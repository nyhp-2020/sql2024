use MyDB
go

--I/1
select top 0
	cast(null as varchar(1000)) as EmailAddress,
	cast(null as datetime) as RegisteredDate
into dbo.EmailAddresses
--I/2
select top 0 *
into #tmp
from dbo.EmailAddresses

select * from #tmp

select * from dbo.EmailAddresses
truncate table dbo.EmailAddresses
--where #tmp.EmailAddress = AdventureWorks2019.Production.ProductReview.EmailAddress

--I/3
insert into #tmp(EmailAddress)--,RegisteredDate)
select pr.EmailAddress--, getdate() as Date
from AdventureWorks2019.Production.ProductReview pr

insert into #tmp(EmailAddress)--,RegisteredDate)
select eass.EmailAddress--, getdate() as Date
from AdventureWorks2019.Person.EmailAddress eass

insert into #tmp(EmailAddress)--,RegisteredDate)
select pe.EmailAddress--, getdate() as Date
from [WideWorldImporters].Application.People pe

insert into #tmp(EmailAddress)--,RegisteredDate)
select pea.EmailAddress--, getdate() as Date
from [WideWorldImporters].Application.People_Archive pea

--delete from #tmp
--I/4-5
insert into dbo.EmailAddresses(EmailAddress,RegisteredDate)
select distinct EmailAddress, getdate() as Date
from #tmp

-- vagy
insert into dbo.EmailAddresses(EmailAddress,RegisteredDate)
select EmailAddress, getdate() as Date
from #tmp
where not exists(select * from dbo.EmailAddresses ea where ea.EmailAddress = #tmp.EmailAddress)



--II
select * from dbo.Customer

select distinct FirstName,LastName,Country
from dbo.Customer


alter authorization on database::[WideWorldImporters] to sa --hogy tudjunk adatbázis diagramot csinálni

-- innen vehetjük az országnevet (inner join [AdventureWorks2019].Person.CountryRegion ...)
select *
from [WideWorldImporters].Application.Countries --CountryName

--itt találhatjuk az országkódot
select *
from [AdventureWorks2019].Person.CountryRegion --Name,CountryRegionCode (HU)

-- ez egy ideiglenes tábla volt a dbo.Customer helyettesítésére
/*select top 0 *
into #customer
from dbo.Customer

select * from #customer

drop table #customer
*/

-- nevek darabolása,kétnevûek kiválasztása
select CustomerID,CustomerName,ca.value,ca.rn,ca.cnt
into #name2
from [WideWorldImporters].Sales.Customers cu
cross apply(
	select value, row_number() over(order by (select null)) as rn,
				  count(*) over(partition by CustomerID) as cnt --hány részbõl áll a név
	from string_split(cu.CustomerName, ' ')
) ca
where ca.cnt = 2 --két nevûek

-- FirstName kigyûjtése
select CustomerID, value as FirstName
into #fn
from #name2
where  rn = 1 --FirstName

-- LastName kigyûjtése
select CustomerID, value as LastName
into #ln
from #name2
where  rn = 2  --LastName

--a forrás sorok kinyerése
select /*#fn.CustomerID,cu.CustomerName,*/ #fn.FirstName,#ln.LastName,left(cr.CountryRegionCode,2) as Country --dbo.Customer.Country
from #fn
inner join #ln on #fn.CustomerID = #ln.CustomerID
inner join [WideWorldImporters].Sales.Customers cu on cu.CustomerID = #ln.CustomerID
inner join [WideWorldImporters].Application.Cities ci on cu.DeliveryCityID = ci.CityID
inner join [WideWorldImporters].Application.StateProvinces sp on ci.StateProvinceID = sp.StateProvinceID
inner join [WideWorldImporters].Application.Countries co on co.CountryID = sp.CountryID
inner join [AdventureWorks2019].Person.CountryRegion cr on co.CountryName = cr.Name collate SQL_Latin1_General_CP1_CI_AS

-- a megoldás 
merge into dbo.Customer cel
using(
	select #fn.FirstName,#ln.LastName,left(cr.CountryRegionCode,2) as Country, getdate() as Date
	from #fn
	inner join #ln on #fn.CustomerID = #ln.CustomerID
	inner join [WideWorldImporters].Sales.Customers cu on cu.CustomerID = #ln.CustomerID
	inner join [WideWorldImporters].Application.Cities ci on cu.DeliveryCityID = ci.CityID
	inner join [WideWorldImporters].Application.StateProvinces sp on ci.StateProvinceID = sp.StateProvinceID
	inner join [WideWorldImporters].Application.Countries co on co.CountryID = sp.CountryID
	inner join [AdventureWorks2019].Person.CountryRegion cr on co.CountryName = cr.Name collate SQL_Latin1_General_CP1_CI_AS
) forras on forras.FirstName = cel.FirstName collate Hungarian_CI_AS
		and forras.LastName = cel.LastName collate Hungarian_CI_AS
		and forras.Country = cel.Country collate Hungarian_CI_AS
when matched  then
	update set
		cel.LastChanged = getdate()
when not matched by target then
	insert (FirstName, LastName, Country, LastChanged)
	values(forras.FirstName, forras.LastName, forras.Country, getdate())
;

--when not matched by source then
	--delete
--;


/*
select CustomerName, /* DeliveryCityID,*/ cr.CountryRegionCode --dbo.Customer.Country
from [WideWorldImporters].Sales.Customers cu
inner join [WideWorldImporters].Application.Cities ci on cu.DeliveryCityID = ci.CityID
inner join [WideWorldImporters].Application.StateProvinces sp on ci.StateProvinceID = sp.StateProvinceID
inner join [WideWorldImporters].Application.Countries co on co.CountryID = sp.CountryID
inner join [AdventureWorks2019].Person.CountryRegion cr on co.CountryName = cr.Name collate SQL_Latin1_General_CP1_CI_AS
*/

