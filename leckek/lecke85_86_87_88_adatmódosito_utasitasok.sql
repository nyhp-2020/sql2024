use MyDB
go

--INSERT

select * from dbo.Product


--explicit besz�r�s

insert into dbo.Product
values ('USB cable', 2.99, 'Black',0) --kev�s a param�ter

-- oszlop lista n�lk�l
insert into dbo.Product
values ('USB cable', 2.99, 'Black',0, getdate())

--�rt�kek (oszlopok) felsorol�s�val
--oszlop list�val (a sorrend mindegy, de a values-ben is ugyanaz a sorrend kell!)
insert into dbo.Product(ProductName,ListPrice,Color,Size)
values ('USB cable2', 2.99, 'Black',0)

-- t�bb soros values
insert into dbo.Product(ListPrice,ProductName,Color,Size)
values  (2.99,'USB cable3','Black',0),
		(2.99,'USB cable4','Black',0)

--SELECT v�ltozatok
--A Selectben nem fontosak az alias nevek, csak a sorrendj�k!
-- a.) alias nevek n�lk�l

insert into dbo.Product(ProductName,ListPrice,Color,Size)
select
	'USB cable5',
	2.99,
	'Black',
	 0

-- c.) alias nevek el�l
insert into dbo.Product(ProductName,ListPrice,Color,Size)
select
	[ProductName] = 'USB cable6',
	[ListPrice] = 2.99,
	[Color] = 'Black',
	[Size] = 0

-- b.) alias nevek h�tul (as)
insert into dbo.Product(ProductName,ListPrice,Color,Size)
select
	'USB cable7' as [ProductName],
	2.99 as [ListPrice],
	'Black' as [Color],
	0 as [Size]

--nem explicit besz�r�s
/*
Besz�r�s forr�s lek�rdez�sb�l vagy t�bl�b�l
*/

-- lek�rdez�s m�sik adatb�zisb�l

select *
from AdventureWorks2019.Production.Product

--Sz�rjunk be 100 sort a ... -b�l, ahol van Color
insert into dbo.Product(ProductName,ListPrice,Color,Size)
select top 100 Name, ListPrice, Color, Size  --a Size-al t�pus probl�ma van
from AdventureWorks2019.Production.Product
where Color is not null
and ListPrice > 0

insert into dbo.Product(ProductName,ListPrice,Color,Size)
select top 100 Name, ListPrice, Color, null --vagy null-t adok vissza
from AdventureWorks2019.Production.Product
where Color is not null
and ListPrice > 0

--ez lefutott (a lehets�ges t�pus konverziu�kkal)
insert into dbo.Product(ProductName,ListPrice,Color)
select top 100 Name, ListPrice, Color   --vagy kihagyom
from AdventureWorks2019.Production.Product
where Color is not null
and ListPrice > 0

--sz�rjunk be 10 darabot minden dbo.Product t�bl�ban l�v� piros term�kb�l a dbo.Inventory t�bl�ba az AA polcra.

select * from dbo.Inventory

select * from dbo.Product

--ez siker�l
insert into dbo.Inventory
select 'AA', ProductID, 10, 10
from dbo.Product

-- nem m�k�dik. mert a ProductID nem l�tezik a Product t�bl�ban
insert into dbo.Inventory
select 'AA', 13564, 10, 10
from dbo.Product

insert into dbo.Inventory
select 'AA', ProductID, 10, 10
from dbo.Product
where Color = 'Red'  -- ha sz�n szerint is sz�r�nk


--IDENTITY besz�r�s
set identity_insert dbo.Product on -- identity insert bekapcsol�sa (egyszerre csak egy t�bl�n?)
insert into dbo.Product(ProductID,ProductName,ListPrice,Color)
values(13564, 'XXX', 1, 'Red')

set identity_insert dbo.Product off -- identity insert kikapcsol�sa

--UPDATE

select * from dbo.Product

--N�velj�k egy term�k �r�rt 3%-al
update top(1) dbo.Product  --update-n�l k�telez� a z�r�jel a top-hoz!
set ListPrice = ListPrice * 1.03
where ProductID = 1  --where n�lk�l az �sszes sorra lefut!

update dbo.Product
set ListPrice = ListPrice * 1.03
where ProductID = 1


--N�velj�k a fekete sz�n� term�kek �r�rt 5%-al
update dbo.Product
set ListPrice = ListPrice * 1.05
--select *
from dbo.Product
where Color = 'Black'

--Term�kn�v alapj�n �ll�tsuk vissza a lista�rakat az AdventureWorks adatb�zisb�l

--Collate �ll�t�sok (egyel�re nem mentek...)
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


-- egy update-ben t�bb oszlopot is m�dos�thatunk
update p
set p.ListPrice = a.ListPrice,
	p.Color = a.Color
--select p.ListPrice, a.ListPrice
from dbo.Product p
inner join AdventureWorks2019.Production.Product a on a.Name = p.ProductName

-- az identity oszlopot nem lehet az update-ben m�dos�tani

--DELETE

select * from dbo.Inventory
select * from dbo.Product

delete from dbo.Product
where ProductID = 1

--The DELETE statement conflicted with the REFERENCE constraint "FK_Inventory_Product". The conflict occurred in database "MyDB", table "dbo.Inventory", column 'ProductID'

-- megsz�ntetj�k a hivatkoz�st az idegen kulcsra
delete from dbo.Inventory
where ProductID = 1


delete from dbo.Product
where Color = 'Black'
--The DELETE statement conflicted with the REFERENCE constraint "FK_Inventory_Product". The conflict occurred in database "MyDB", table "dbo.Inventory", column 'ProductID'

delete top(10) from dbo.Product
where Color = 'Black'

--t�r�lj�k az �sszes sz�rke term�ket (nincs)
delete from dbo.Product
where Color = 'Grey'

-- az �sszes feket�t
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


-- el�bb t�r�lj�nk n�h�ny sort az Inventory-b�l
delete top(50) from dbo.Inventory

--T�r�lj�k az �sszes sort az Inventory t�bl�b�l
delete from dbo.Inventory  --vesz�lyes!

select * from dbo.Inventory

--T�r�lj�k az �sszes AdentureWorks-b�l sz�rmaz� term�ket n�v alapj�n
delete from dbo.Product
--select *
from dbo.Product p
inner join AdventureWorks2019.Production.Product a on a.Name = p.ProductName collate SQL_Latin1_General_CP1_CI_AS

--�r�ts�k ki az Inventory t�bl�t
truncate table dbo.Inventory  --DDL utas�t�s; tranzakci�ban vissza�ll�that�

--Product t�bla
truncate table dbo.Product
--Cannot truncate table 'dbo.Product' because it is being referenced by a FOREIGN KEY constraint.
delete from dbo.Product --ilyenkor ez marad