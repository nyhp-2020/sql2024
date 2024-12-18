-- triggerek -eseménykezelõk (ritkán használatosak,kényszerû okokból)
-- tárolt eljárás (nincs paraméter)

-- Adjunk a Product táblához egy új bit oszlopot (Status)
-- 1: Van olyan sor az Inventory-ban ahol a ProductLeft > 0
use MyDB
go

alter table dbo.Product add Status bit null

-- 0 v. 1 elõállítás
select case when isnull(dbo.GetInStock(ProductID),0) = 0 then 0 else 1 end,*
from dbo.Product

-- v. elõjel függvénnyel
select sign(isnull(dbo.GetInStock(ProductID),0)),*
from dbo.Product

update p
set Status = sign(isnull(dbo.GetInStock(ProductID),0))
--select sign(isnull(dbo.GetInStock(ProductID),0)),*
from dbo.Product p
go

--After triggerek: esemény után futnak

--trigger létrehozása
create or alter trigger tr_Inventory
on dbo.Inventory
after insert,update,delete
as

if not update(ProductLeft) return --ha a ProductLeft nem változik

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

-- trigger letiltása: jobb egérgomb,Disable
--vagy
--tiltás
disable trigger tr_Inventory on dbo.Inventory

--engedélyezés
enable trigger tr_Inventory on dbo.Inventory

-- amibõl van
select * from dbo.Product where ProductID = 1022
select * from dbo.Inventory where ProductID = 1022
select * from dbo.ProductOrders where ProductID = 1022

update dbo.Inventory set ProductLeft = 1 --így csak egy darab maradt belõle
where ProductID = 1022

update dbo.Inventory set ProductLeft = 0 --elfogyott -> Státusz átáll 0-ra a Product-ban is
where ProductID = 1022


insert into dbo.Inventory ([Shelf], [ProductID], [ProductCount], [ProductLeft]) -- újra 1 a Status a Product-ban
values('BB', 1022, 5, 5)


--DML trigger gaykorlat II.
--Customer,LastChanged oszlop
create or alter trigger tr_Customer_LastChanged
on dbo.Customer --ld kijelölés, Alt+F1 bill.: sp_help futtatása
after update
as

if update(LastChanged) return -- ha módosították a LastChanged mezõt

update dbo.Customer
set LastChanged = getdate()
where CustomerID in (select CustomerID from INSERTED)
go

--ellenõrzés
select top(1) * from dbo.Customer
update top(1) dbo.Customer set LastName = 'Farkas' -- az elsõ sor fizikai sorrendben