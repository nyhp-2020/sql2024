
-- �sszesen mennyi van a rakt�rban
select ProductID, sum(ProductLeft)
from dbo.Inventory
group by ProductID

-- �pp a kos�rba beker�l� rendel�sek, de m�g nem fizett�k ki
select *
from dbo.ProductOrders

-- folyamatban lev� rendel�sek �sszege
select ProductID, sum(OrderQuantity)
from dbo.ProductOrders
group by ProductID

-- view l�trehoz�sa
create view ProductsInStock
as
-- �sszekapcsolva: ennyi �ll rendelkez�sre egy term�kb�l
select i.ProductID, /* i.ProductLeft, o.OrderQuantity,*/ i.ProductLeft - isnull(o.OrderQuantity, 0) as InStock
from(
	select ProductID, sum(ProductLeft) as ProductLeft
	from dbo.Inventory
	group by ProductID
) i --inventory
left join(		-- �gy az �sszeset visszaadja (left join)
	select ProductID, sum(OrderQuantity) as OrderQuantity
	from dbo.ProductOrders
	group by ProductID
) o --rendel�s alatt
on o.ProductID = i.ProductID
-- most m�r ilyen nev� view-t v. t�bl�t nem hozhatok l�tre az adatb�zisban

-- view m�dos�t�sa
alter view ProductsInStock
as
-- �sszekapcsolva: ennyi �ll rendelkez�sre a rendel�s alatt l�v� term�kekb�l
select i.ProductID, i.ProductLeft - isnull(o.OrderQuantity, 0) as InStock
from(
	select ProductID, sum(ProductLeft) as ProductLeft
	from dbo.Inventory
	group by ProductID
) i --inventory
inner join(		-- �gy csak a rendel�s alatt l�v�ket adja vissza (inner join)
	select ProductID, sum(OrderQuantity) as OrderQuantity
	from dbo.ProductOrders
	group by ProductID
) o --rendel�s alatt
on o.ProductID = i.ProductID



-- lek�rdez�s view-b�l
select * from dbo.ProductsInStock

select * from dbo.ProductsInStock
where InStock > 5

-- a view-k egym�sba �gyazhat�k

-- ez �gy lehet egy k�l�n szkript a m�dos�t�sra (t�rl�s,l�trehoz�s)
drop view if exists ProductsInStock
go --ez az�rt kell, mert a create view csak els� lehet egy szkriptben...

create view ProductsInStock
as
-- �sszekapcsolva: ennyi �ll rendelkez�sre egy term�kb�l
select i.ProductID, i.ProductLeft - isnull(o.OrderQuantity, 0) as InStock
from(
	select ProductID, sum(ProductLeft) as ProductLeft
	from dbo.Inventory
	group by ProductID
) i --inventory
left join(		-- �gy az �sszeset visszaadja (left join)
	select ProductID, sum(OrderQuantity) as OrderQuantity
	from dbo.ProductOrders
	group by ProductID
) o --rendel�s alatt
on o.ProductID = i.ProductID

--VAGY
--SqlServer 2016 �ta
create or alter view ProductsInStock --ha nincs l�trehozza,k�l�nben m�dos�tja
as
-- �sszekapcsolva: ennyi �ll rendelkez�sre egy term�kb�l
select i.ProductID, i.ProductLeft - isnull(o.OrderQuantity, 0) as InStock
from(
	select ProductID, sum(ProductLeft) as ProductLeft
	from dbo.Inventory
	group by ProductID
) i --inventory
left join(		-- �gy az �sszeset visszaadja (left join)
	select ProductID, sum(OrderQuantity) as OrderQuantity
	from dbo.ProductOrders
	group by ProductID
) o --rendel�s alatt
on o.ProductID = i.ProductID

select p.*, s.InStock
from dbo.Product p
inner join dbo.ProductsInStock s
on s.ProductID = p.ProductID

select p.*, s.InStock
from dbo.Product p
left join dbo.ProductsInStock s --�sszes term�k
on s.ProductID = p.ProductID

-- kijel�lt objektumn�l (t�bla,view) Alt + F1 -> t�bla objektum inform�ci�kkal

--n�zet a sz�nnel rendelkez� term�kekre
go --�j batch

create or alter view ProductsWithColor
as
select *
from dbo.Product
where Color is not null

select * from ProductsWithColor

select * from Product

-- oszlop t�rl�s (elromlik a view)
alter table dbo.Product
	drop column SellStartDate

-- 1. create or alter view futtat�s (friss�t�s)

-- 2. rendszer t�rolt elj�r�s
sp_refreshview 'ProductsWithColor'
--Olyan oszlop nem t�nhet el, amire where felt�tel van. Vagy hivatkoz�s oszloplist�ban. Akkor nem friss�l a view.

go
-- ez csak az els� �s egyetlen lehet egy batch-ben
create or alter view ProductsWithColor
with schemabinding  --v�delem a t�blam�dos�t�s ellen
as
select [ProductID], [ProductName], [ListPrice], [Color], [Size], [CreatedDate], [ProductNumber], [StandardCost]
from dbo.Product
where Color is not null
go
-- ezek nem futnak le a fenti parancs ut�n
-- csak view t�rl�s ut�n
alter table dbo.Product
	drop column [CreatedDate]

alter table dbo.Product
	drop column Size
