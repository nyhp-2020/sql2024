-- triggerek -esem�nykezel�k (ritk�n haszn�latosak,k�nyszer� okokb�l)
-- t�rolt elj�r�s (nincs param�ter)

-- Adjunk a Product t�bl�hoz egy �j bit oszlopot (Status)
-- 1: Van olyan sor az Inventory-ban ahol a ProductLeft > 0
use MyDB
go

alter table dbo.Product add Status bit null

-- 0 v. 1 el��ll�t�s
select case when isnull(dbo.GetInStock(ProductID),0) = 0 then 0 else 1 end,*
from dbo.Product

-- v. el�jel f�ggv�nnyel
select sign(isnull(dbo.GetInStock(ProductID),0)),*
from dbo.Product

update p
set Status = sign(isnull(dbo.GetInStock(ProductID),0))
--select sign(isnull(dbo.GetInStock(ProductID),0)),*
from dbo.Product p
go

--After triggerek: esem�ny ut�n futnak

--trigger l�trehoz�sa
create or alter trigger tr_Inventory
on dbo.Inventory
after insert,update,delete
as

if not update(ProductLeft) return --ha a ProductLeft nem v�ltozik

update p
set p.Status = sign(isnull(dbo.GetInStock(product_list.ProductID),0))
--select dbo.GetInStock(product_list.ProductID)
from(
select distinct ProductID
from INSERTED
--from dbo.Inventory
) product_list
inner join dbo.Product p on p.ProductID = product_list.ProductID
--where Status <> sign(isnull(dbo.GetInStock(product_list.ProductID),0))
go -- eddig tart a trigger

-- trigger letilt�sa: jobb eg�rgomb,Disable
--vagy
--tilt�s
disable trigger tr_Inventory on dbo.Inventory

--enged�lyez�s
enable trigger tr_Inventory on dbo.Inventory

-- amib�l van
select * from dbo.Product where ProductID = 1022
select * from dbo.Inventory where ProductID = 1022
select * from dbo.ProductOrders where ProductID = 1022

update dbo.Inventory set ProductLeft = 1 --�gy csak egy darab maradt bel�le
where ProductID = 1022

update dbo.Inventory set ProductLeft = 0 --elfogyott -> St�tusz �t�ll 0-ra a Product-ban is
where ProductID = 1022


insert into dbo.Inventory ([Shelf], [ProductID], [ProductCount], [ProductLeft]) -- �jra 1 a Status a Product-ban
values('BB', 1022, 5, 5)


--DML trigger gaykorlat II.
--Customer,LastChanged oszlop
create or alter trigger tr_Customer_LastChanged
on dbo.Customer --ld kijel�l�s, Alt+F1 bill.: sp_help futtat�sa
after update
as

if update(LastChanged) return -- ha m�dos�tott�k a LastChanged mez�t

update dbo.Customer
set LastChanged = getdate()
where CustomerID in (select CustomerID from INSERTED)
go

--ellen�rz�s
select top(1) * from dbo.Customer
update top(1) dbo.Customer set LastName = 'Farkas' -- az els� sor fizikai sorrendben