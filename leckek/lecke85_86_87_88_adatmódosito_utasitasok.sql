use MyDB
go

--INSERT

select * from dbo.Product


--explicit beszúrás

insert into dbo.Product
values ('USB cable', 2.99, 'Black',0) --kevés a paraméter

-- oszlop lista nélkül
insert into dbo.Product
values ('USB cable', 2.99, 'Black',0, getdate())

--értékek (oszlopok) felsorolásával
--oszlop listával (a sorrend mindegy, de a values-ben is ugyanaz a sorrend kell!)
insert into dbo.Product(ProductName,ListPrice,Color,Size)
values ('USB cable2', 2.99, 'Black',0)

-- több soros values
insert into dbo.Product(ListPrice,ProductName,Color,Size)
values  (2.99,'USB cable3','Black',0),
		(2.99,'USB cable4','Black',0)

--SELECT változatok
--A Selectben nem fontosak az alias nevek, csak a sorrendjük!
-- a.) alias nevek nélkül

insert into dbo.Product(ProductName,ListPrice,Color,Size)
select
	'USB cable5',
	2.99,
	'Black',
	 0

-- c.) alias nevek elöl
insert into dbo.Product(ProductName,ListPrice,Color,Size)
select
	[ProductName] = 'USB cable6',
	[ListPrice] = 2.99,
	[Color] = 'Black',
	[Size] = 0

-- b.) alias nevek hátul (as)
insert into dbo.Product(ProductName,ListPrice,Color,Size)
select
	'USB cable7' as [ProductName],
	2.99 as [ListPrice],
	'Black' as [Color],
	0 as [Size]

--nem explicit beszúrás
/*
Beszúrás forrás lekérdezésbõl vagy táblából
*/

-- lekérdezés másik adatbázisból

select *
from AdventureWorks2019.Production.Product

--Szúrjunk be 100 sort a ... -ból, ahol van Color
insert into dbo.Product(ProductName,ListPrice,Color,Size)
select top 100 Name, ListPrice, Color, Size  --a Size-al típus probléma van
from AdventureWorks2019.Production.Product
where Color is not null
and ListPrice > 0

insert into dbo.Product(ProductName,ListPrice,Color,Size)
select top 100 Name, ListPrice, Color, null --vagy null-t adok vissza
from AdventureWorks2019.Production.Product
where Color is not null
and ListPrice > 0

--ez lefutott (a lehetséges típus konverziuókkal)
insert into dbo.Product(ProductName,ListPrice,Color)
select top 100 Name, ListPrice, Color   --vagy kihagyom
from AdventureWorks2019.Production.Product
where Color is not null
and ListPrice > 0

--szúrjunk be 10 darabot minden dbo.Product táblában lévõ piros termékbõl a dbo.Inventory táblába az AA polcra.

select * from dbo.Inventory

select * from dbo.Product

--ez sikerül
insert into dbo.Inventory
select 'AA', ProductID, 10, 10
from dbo.Product

-- nem mûködik. mert a ProductID nem létezik a Product táblában
insert into dbo.Inventory
select 'AA', 13564, 10, 10
from dbo.Product

insert into dbo.Inventory
select 'AA', ProductID, 10, 10
from dbo.Product
where Color = 'Red'  -- ha szín szerint is szûrünk


--IDENTITY beszúrás
set identity_insert dbo.Product on -- identity insert bekapcsolása (egyszerre csak egy táblán?)
insert into dbo.Product(ProductID,ProductName,ListPrice,Color)
values(13564, 'XXX', 1, 'Red')

set identity_insert dbo.Product off -- identity insert kikapcsolása

--UPDATE

select * from dbo.Product

--Növeljük egy termék árárt 3%-al
update top(1) dbo.Product  --update-nél kötelezõ a zárójel a top-hoz!
set ListPrice = ListPrice * 1.03
where ProductID = 1  --where nélkül az összes sorra lefut!

update dbo.Product
set ListPrice = ListPrice * 1.03
where ProductID = 1


--Növeljük a fekete színû termékek árárt 5%-al
update dbo.Product
set ListPrice = ListPrice * 1.05
--select *
from dbo.Product
where Color = 'Black'

--Terméknév alapján állítsuk vissza a listaárakat az AdventureWorks adatbázisból

--Collate állítások (egyelõre nem mentek...)
ALTER TABLE dbo.Product
    ALTER COLUMN ProductName NVARCHAR(100) COLLATE SQL_Latin1_General_CP1_CI_AS;

ALTER TABLE dbo.Product
    ALTER COLUMN ProductName NVARCHAR(100) COLLATE Hungarian_CI_AS;

--
select *
from dbo.Product p
inner join AdventureWorks2019.Production.Product a on a.Name = p.ProductName

--Cannot resolve the collation conflict between "Hungarian_CI_AS" and "SQL_Latin1_General_CP1_CI_AS" in the equal to operation.

select *
from dbo.Product p
inner join AdventureWorks2019.Production.Product a on a.Name = p.ProductName collate SQL_Latin1_General_CP1_CI_AS


update p
set p.ListPrice = a.ListPrice
--select p.ListPrice, a.ListPrice, *
from dbo.Product p
inner join AdventureWorks2019.Production.Product a on a.Name = p.ProductName collate SQL_Latin1_General_CP1_CI_AS


-- egy update-ben több oszlopot is módosíthatunk
update p
set p.ListPrice = a.ListPrice,
	p.Color = a.Color
--select p.ListPrice, a.ListPrice
from dbo.Product p
inner join AdventureWorks2019.Production.Product a on a.Name = p.ProductName

-- az identity oszlopot nem lehet az update-ben módosítani

--DELETE

select * from dbo.Inventory
select * from dbo.Product

delete from dbo.Product
where ProductID = 1

--The DELETE statement conflicted with the REFERENCE constraint "FK_Inventory_Product". The conflict occurred in database "MyDB", table "dbo.Inventory", column 'ProductID'

-- megszüntetjük a hivatkozást az idegen kulcsra
delete from dbo.Inventory
where ProductID = 1


delete from dbo.Product
where Color = 'Black'
--The DELETE statement conflicted with the REFERENCE constraint "FK_Inventory_Product". The conflict occurred in database "MyDB", table "dbo.Inventory", column 'ProductID'

delete top(10) from dbo.Product
where Color = 'Black'

--töröljük az összes szürke terméket (nincs)
delete from dbo.Product
where Color = 'Grey'

-- az összes feketét
delete from dbo.Product
--select *
from dbo.Product
where color = 'Black'

--NOT EXIST

delete from dbo.Product
--select *
from dbo.Product p 
where color = 'Black'
and not exists(select * from dbo.Inventory i where i.ProductID = p.ProductID)


-- elõbb töröljünk néhány sort az Inventory-ból
delete top(50) from dbo.Inventory

--Töröljük az összes sort az Inventory táblából
delete from dbo.Inventory  --veszélyes!

select * from dbo.Inventory

--Töröljük az összes AdentureWorks-bõl származó terméket név alapján
delete from dbo.Product
--select *
from dbo.Product p
inner join AdventureWorks2019.Production.Product a on a.Name = p.ProductName collate SQL_Latin1_General_CP1_CI_AS

--Ürítsük ki az Inventory táblát
truncate table dbo.Inventory  --DDL utasítás; tranzakcióban visszaállítható

--Product tábla
truncate table dbo.Product
--Cannot truncate table 'dbo.Product' because it is being referenced by a FOREIGN KEY constraint.
delete from dbo.Product --ilyenkor ez marad