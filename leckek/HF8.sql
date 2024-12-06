select * --Name,CountryRegionCode
from AdventureWorks2019.Person.CountryRegion

select * --CountryName, IsoAlpha3Code
from WideWorldImporters.Application.Countries

-- k�t t�bla �sszekapcsol�sa
select cr.Name,cr.CountryRegionCode,co.IsoAlpha3Code,co.CountryName
from AdventureWorks2019.Person.CountryRegion cr
inner join WideWorldImporters.Application.Countries co
on cr.Name = co.CountryName collate Latin1_General_100_CI_AS

-- Country form�tumban
select left(cr.CountryRegionCode,2) as CountryCode,co.CountryName,co.IsoAlpha3Code as CountryISO3Code
from AdventureWorks2019.Person.CountryRegion cr
inner join WideWorldImporters.Application.Countries co
on cr.Name = co.CountryName collate Latin1_General_100_CI_AS

--I
--SCRIPT START
---------------------
-- �j oszlop a country t�bl�ban,egyel�re null
go
alter table dbo.Country
	add CountryISO3Code nchar(3) null

-- t�bla felt�lt�s, m�dos�t�s
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

-- �j oszlop not null-ra �ll�t�sa
go
alter table dbo.Country
	alter column CountryISO3Code nchar(3) not null

-- unique be�ll�t�s az �j oszlopon
go
alter table dbo.Country
	add constraint UK_CountryISO3Code unique (CountryISO3Code)

go
--SCRIPT END


-- ha vissza�llunk miut�n t�r�lt�k az �j oszlopot
--delete from dbo.Country
--where CountryCode not in('HU','IT','ES','US')


--ProductsInStock n�zet "eredeti"
create or alter view ProductsInStock --ha nincs l�trehozza,k�l�nben m�dos�tja
as
-- �sszekapcsolva: ennyi �ll rendelkez�sre egy term�kb�l
select i.ProductID, i.ProductLeft - isnull(o.OrderQuantity, 0) as InStock
from(
	select ProductID, sum(ProductLeft) as ProductLeft  --ezek vannak rakt�ron
	from dbo.Inventory
	group by ProductID
) i --inventory
left join(		-- �gy az �sszeset visszaadja (left join)
	select ProductID, sum(OrderQuantity) as OrderQuantity
	from dbo.ProductOrders
	group by ProductID
) o --rendel�s alatt
on o.ProductID = i.ProductID

-- Product �s Inventory �sszekapcsol�sa
select p.ProductID,sum(isnull(i.ProductLeft,0)) as ProductLeft
from dbo.Product p
left join dbo.Inventory i on p.ProductID = i.ProductID
group by p.ProductID

--II
--ProductsInStock n�zet
go
-- csak egyed�l lehet egy script-ben
create or alter view ProductsInStock --ha nincs l�trehozza,k�l�nben m�dos�tja
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
	group by p.ProductID --t�bb polc, inventory bejegyz�s is lehet
) pr --Product
left join(		-- �gy az �sszeset visszaadja (left join)
	select ProductID, sum(OrderQuantity) as OrderQuantity
	from dbo.ProductOrders
	group by ProductID --t�bb rendel�s is lehet
) o --rendel�s alatt
on o.ProductID = pr.ProductID

--
go
select * from ProductsInStock

