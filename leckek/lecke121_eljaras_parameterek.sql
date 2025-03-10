create or alter procedure uspUpdateProducts(
	@DeleteMissing bit = 0, --alap�rtelmezett �rt�k "nem"
	@RowsLoaded int = null output  --kifel� t�rt�n� �rt�kad�shoz (opcion�lis param�ter)
)
as

--use MyDB --ez nem megengedett az elj�r�sban
-- ideiglenes t�bla l�trehoz�sa
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

--ld. lecke 95 (adatbet�lt�s csv-b�l)
bulk insert #load
from 'C:\temp\data.csv' --az SQL szervernek hozz� kell f�rni a file-hoz! (Ez �ltal�ban nem �gy van.)
with (
	firstrow = 2,
	fieldterminator = '\t'
)

--rendszerv�ltoz�
-- select @@rowcount as [row_count]-- az utols� sql utas�t�s �ltal �rintett sorok sz�ma

set @RowsLoaded = @@rowcount --v�ltoz� �rt�k�nek be�ll�t�sa

--select * from #load

--UPDATE
update p
set p.ListPrice = l.ListPrice -- ListPrice friss�t�s
--select ProductName,try_cast(ListPrice as decimal(20,2)),ProductNumber,try_cast(StandardCost as decimal(20,2)), getdate()
from #load l
inner join dbo.Product p on p.ProductName = l.ProductName
where exists(select * from dbo.Product t where t.ProductName = l.ProductName)
and try_cast(l.ListPrice as decimal(20,2)) is not null
and try_cast(l.StandardCost as decimal(20,2)) is not null


--INSERT
-- m�solat k�sz�t�s ideiglenes t�bl�ba
/*
select top 0 * into #product from dbo.Product

-- kijel�l�s, ctrl+4 ?
-- temp t�bl�ra lefutott
insert into #Product(ProductName,ListPrice,ProductNumber,StandardCost,CreatedDate)
select ProductName,try_cast(ListPrice as decimal(20,2)),ProductNumber,try_cast(StandardCost as decimal(20,2)), getdate()
from #load l
where not exists(select * from #Product t where t.ProductName = l.ProductName)
and try_cast(ListPrice as decimal(20,2)) is not null
and try_cast(StandardCost as decimal(20,2)) is not null
*/
-- �t�rom val�s t�bl�ra
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

return 1 --lehet visszat�r�si k�d is
go --eddig tart a t�rolt elj�r�s k�dja (ha nincs go, a file v�g�ig)

-- egy teszth�v�s
-- exec uspUpdateProducts --go n�lk�l ez egy rekurz�v h�v�s lenne (limit 32)

/*
exec uspUpdateProducts
--ha meg akarom adni a @DeleteMissing param�tert
-- nem kell z�r�jel!
-- sorrend szerint
exec uspUpdateProducts 0
exec uspUpdateProducts 1
-- n�v szerint
exec uspUpdateProducts @DeleteMissing = 0
exec uspUpdateProducts @DeleteMissing = 1

-- a visszat�r�si �rt�k kinyer�se
declare @return_value int
exec @return_value = uspUpdateProducts -- @Param1 = 1, ...
select @return_value

-- param�terek megad�sa 121 lecke szerint
declare @rows int -- alap�rtelmezett null
exec uspUpdateProducts @DeleteMissing = 0, @RowsLoaded = 1
exec uspUpdateProducts @DeleteMissing = 0, @RowsLoaded = @rows -- itt �res v�ltoz� �rt�ket adtam meg

-- output param�ter lek�rdez�se
declare @rows int
set @rows = 1
exec uspUpdateProducts @DeleteMissing = 0, @RowsLoaded = @rows output --kifel� ir�nyul� param�ter �tad�s (@rows kap �rt�ket!)
select @rows

*/