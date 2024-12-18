create or alter procedure uspUpdateProducts(
	@DeleteMissing bit = 0 --alapértelmezett érték "nem"
)
as

--use MyDB --ez nem megengedett az eljárásban
-- ideiglenes tábla létrehozása
drop table if exists #load

create table #load(
Nr nvarchar(100) null,
ProductNumber nvarchar(100) null,
ProductName nvarchar(100) null,
ListPrice nvarchar(100) null,
StandardCost nvarchar(100) null,
SellStartDate nvarchar(100) null
)

--select * from #load

--ld. lecke 95 (adatbetöltés csv-bõl)
bulk insert #load
from 'C:\temp\data.csv' --az SQL szervernek hozzá kell férni a file-hoz! (Ez általában nem így van.)
with (
	firstrow = 2,
	fieldterminator = '\t'
)

--select * from #load

--UPDATE
update p
set p.ListPrice = l.ListPrice -- ListPrice frissítés
--select ProductName,try_cast(ListPrice as decimal(20,2)),ProductNumber,try_cast(StandardCost as decimal(20,2)), getdate()
from #load l
inner join dbo.Product p on p.ProductName = l.ProductName
where exists(select * from dbo.Product t where t.ProductName = l.ProductName)
and try_cast(l.ListPrice as decimal(20,2)) is not null
and try_cast(l.StandardCost as decimal(20,2)) is not null


--INSERT
-- másolat készítés ideiglenes táblába
/*
select top 0 * into #product from dbo.Product

-- kijelölés, ctrl+4 ?
-- temp táblára lefutott
insert into #Product(ProductName,ListPrice,ProductNumber,StandardCost,CreatedDate)
select ProductName,try_cast(ListPrice as decimal(20,2)),ProductNumber,try_cast(StandardCost as decimal(20,2)), getdate()
from #load l
where not exists(select * from #Product t where t.ProductName = l.ProductName)
and try_cast(ListPrice as decimal(20,2)) is not null
and try_cast(StandardCost as decimal(20,2)) is not null
*/
-- átírom valós táblára
insert into dbo.Product(ProductName,ListPrice,ProductNumber,StandardCost,CreatedDate)
select ProductName,try_cast(ListPrice as decimal(20,2)),ProductNumber,try_cast(StandardCost as decimal(20,2)), getdate()
from #load l
where not exists(select * from dbo.Product t where t.ProductName = l.ProductName)
and try_cast(ListPrice as decimal(20,2)) is not null
and try_cast(StandardCost as decimal(20,2)) is not null


--DELETE
delete from p
--select *
from dbo.Product p
where not exists(select * from #load l where l.ProductName = p.ProductName)
and @DeleteMissing = 1

return 1 --lehet visszatérési kód is
go --eddig tart a tárolt eljárás kódja (ha nincs go, a file végéig)

-- egy teszthívás
exec uspUpdateProducts --go nélkül ez egy rekurzív hívás lenne (limit 32)