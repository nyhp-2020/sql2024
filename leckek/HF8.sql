select * --Name,CountryRegionCode
from AdventureWorks2019.Person.CountryRegion

select * --CountryName, IsoAlpha3Code
from WideWorldImporters.Application.Countries

-- két tábla összekapcsolása
select cr.Name,cr.CountryRegionCode,co.IsoAlpha3Code,co.CountryName
from AdventureWorks2019.Person.CountryRegion cr
inner join WideWorldImporters.Application.Countries co
on cr.Name = co.CountryName collate Latin1_General_100_CI_AS

-- Country formátumban
select left(cr.CountryRegionCode,2) as CountryCode,co.CountryName,co.IsoAlpha3Code as CountryISO3Code
from AdventureWorks2019.Person.CountryRegion cr
inner join WideWorldImporters.Application.Countries co
on cr.Name = co.CountryName collate Latin1_General_100_CI_AS

--I
--SCRIPT START
---------------------
-- új oszlop a country táblában,egyelõre null
go
alter table dbo.Country
	add CountryISO3Code nchar(3) null

-- tábla feltöltés, módosítás
go
merge into dbo.Country cel
using(
	select left(cr.CountryRegionCode,2) as CountryCode,co.CountryName,co.IsoAlpha3Code as CountryISO3Code
	from AdventureWorks2019.Person.CountryRegion cr
	inner join WideWorldImporters.Application.Countries co
	on cr.Name = co.CountryName collate Latin1_General_100_CI_AS
) forras on forras.CountryCode = cel.CountryCode collate Hungarian_CI_AS
when matched  then
	update set
		cel.CountryISO3Code = forras.CountryISO3Code
when not matched by target then
	insert (CountryCode, CountryName, CountryISO3Code)
	values(forras.CountryCode, forras.CountryName, forras.CountryISO3Code)
;

-- új oszlop not null-ra állítása
go
alter table dbo.Country
	alter column CountryISO3Code nchar(3) not null

-- unique beállítás az új oszlopon
go
alter table dbo.Country
	add constraint UK_CountryISO3Code unique (CountryISO3Code)

go
--SCRIPT END


-- ha visszaállunk miután töröltük az új oszlopot
--delete from dbo.Country
--where CountryCode not in('HU','IT','ES','US')


--ProductsInStock nézet "eredeti"
create or alter view ProductsInStock --ha nincs létrehozza,különben módosítja
as
-- összekapcsolva: ennyi áll rendelkezésre egy termékbõl
select i.ProductID, i.ProductLeft - isnull(o.OrderQuantity, 0) as InStock
from(
	select ProductID, sum(ProductLeft) as ProductLeft  --ezek vannak raktáron
	from dbo.Inventory
	group by ProductID
) i --inventory
left join(		-- így az összeset visszaadja (left join)
	select ProductID, sum(OrderQuantity) as OrderQuantity
	from dbo.ProductOrders
	group by ProductID
) o --rendelés alatt
on o.ProductID = i.ProductID

-- Product és Inventory összekapcsolása
select p.ProductID,sum(isnull(i.ProductLeft,0)) as ProductLeft
from dbo.Product p
left join dbo.Inventory i on p.ProductID = i.ProductID
group by p.ProductID

--II
--ProductsInStock nézet
go
-- csak egyedül lehet egy script-ben
create or alter view ProductsInStock --ha nincs létrehozza,különben módosítja
as
select
	pr.ProductID,
	pr.ProductLeft - isnull(o.OrderQuantity, 0) as InStock,
	pr.ProductLeft,
	isnull(o.OrderQuantity,0) as OrderQuantity
from(
	select p.ProductID,sum(isnull(i.ProductLeft,0)) as ProductLeft
	from dbo.Product p
	left join dbo.Inventory i on p.ProductID = i.ProductID
	group by p.ProductID --több polc, inventory bejegyzés is lehet
) pr --Product
left join(		-- így az összeset visszaadja (left join)
	select ProductID, sum(OrderQuantity) as OrderQuantity
	from dbo.ProductOrders
	group by ProductID --több rendelés is lehet
) o --rendelés alatt
on o.ProductID = pr.ProductID

--
go
select * from ProductsInStock

