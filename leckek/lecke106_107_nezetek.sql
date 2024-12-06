
-- összesen mennyi van a raktárban
select ProductID, sum(ProductLeft)
from dbo.Inventory
group by ProductID

-- épp a kosárba bekerülõ rendelések, de még nem fizették ki
select *
from dbo.ProductOrders

-- folyamatban levõ rendelések összege
select ProductID, sum(OrderQuantity)
from dbo.ProductOrders
group by ProductID

-- view létrehozása
create view ProductsInStock
as
-- összekapcsolva: ennyi áll rendelkezésre egy termékbõl
select i.ProductID, /* i.ProductLeft, o.OrderQuantity,*/ i.ProductLeft - isnull(o.OrderQuantity, 0) as InStock
from(
	select ProductID, sum(ProductLeft) as ProductLeft
	from dbo.Inventory
	group by ProductID
) i --inventory
left join(		-- így az összeset visszaadja (left join)
	select ProductID, sum(OrderQuantity) as OrderQuantity
	from dbo.ProductOrders
	group by ProductID
) o --rendelés alatt
on o.ProductID = i.ProductID
-- most már ilyen nevû view-t v. táblát nem hozhatok létre az adatbázisban

-- view módosítása
alter view ProductsInStock
as
-- összekapcsolva: ennyi áll rendelkezésre a rendelés alatt lévõ termékekbõl
select i.ProductID, i.ProductLeft - isnull(o.OrderQuantity, 0) as InStock
from(
	select ProductID, sum(ProductLeft) as ProductLeft
	from dbo.Inventory
	group by ProductID
) i --inventory
inner join(		-- így csak a rendelés alatt lévõket adja vissza (inner join)
	select ProductID, sum(OrderQuantity) as OrderQuantity
	from dbo.ProductOrders
	group by ProductID
) o --rendelés alatt
on o.ProductID = i.ProductID



-- lekérdezés view-ból
select * from dbo.ProductsInStock

select * from dbo.ProductsInStock
where InStock > 5

-- a view-k egymásba ágyazhatók

-- ez így lehet egy külön szkript a módosításra (törlés,létrehozás)
drop view if exists ProductsInStock
go --ez azért kell, mert a create view csak elsõ lehet egy szkriptben...

create view ProductsInStock
as
-- összekapcsolva: ennyi áll rendelkezésre egy termékbõl
select i.ProductID, i.ProductLeft - isnull(o.OrderQuantity, 0) as InStock
from(
	select ProductID, sum(ProductLeft) as ProductLeft
	from dbo.Inventory
	group by ProductID
) i --inventory
left join(		-- így az összeset visszaadja (left join)
	select ProductID, sum(OrderQuantity) as OrderQuantity
	from dbo.ProductOrders
	group by ProductID
) o --rendelés alatt
on o.ProductID = i.ProductID

--VAGY
--SqlServer 2016 óta
create or alter view ProductsInStock --ha nincs létrehozza,különben módosítja
as
-- összekapcsolva: ennyi áll rendelkezésre egy termékbõl
select i.ProductID, i.ProductLeft - isnull(o.OrderQuantity, 0) as InStock
from(
	select ProductID, sum(ProductLeft) as ProductLeft
	from dbo.Inventory
	group by ProductID
) i --inventory
left join(		-- így az összeset visszaadja (left join)
	select ProductID, sum(OrderQuantity) as OrderQuantity
	from dbo.ProductOrders
	group by ProductID
) o --rendelés alatt
on o.ProductID = i.ProductID

select p.*, s.InStock
from dbo.Product p
inner join dbo.ProductsInStock s
on s.ProductID = p.ProductID

select p.*, s.InStock
from dbo.Product p
left join dbo.ProductsInStock s --összes termék
on s.ProductID = p.ProductID

-- kijelölt objektumnál (tábla,view) Alt + F1 -> tábla objektum információkkal

--nézet a színnel rendelkezõ termékekre
go --új batch

create or alter view ProductsWithColor
as
select *
from dbo.Product
where Color is not null

select * from ProductsWithColor

select * from Product

-- oszlop törlés (elromlik a view)
alter table dbo.Product
	drop column SellStartDate

-- 1. create or alter view futtatás (frissítés)

-- 2. rendszer tárolt eljárás
sp_refreshview 'ProductsWithColor'
--Olyan oszlop nem tûnhet el, amire where feltétel van. Vagy hivatkozás oszloplistában. Akkor nem frissül a view.

go
-- ez csak az elsõ és egyetlen lehet egy batch-ben
create or alter view ProductsWithColor
with schemabinding  --védelem a táblamódosítás ellen
as
select [ProductID], [ProductName], [ListPrice], [Color], [Size], [CreatedDate], [ProductNumber], [StandardCost]
from dbo.Product
where Color is not null
go
-- ezek nem futnak le a fenti parancs után
-- csak view törlés után
alter table dbo.Product
	drop column [CreatedDate]

alter table dbo.Product
	drop column Size
