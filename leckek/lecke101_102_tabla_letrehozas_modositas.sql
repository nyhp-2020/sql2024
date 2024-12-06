drop table if exists dbo.ProductOrders
-- t�bla l�trehoz�s
-- CREATE TABLE
create table dbo.ProductOrders(
	OrderID int not null,
	Status bit not null,
	InventoryID int not null,
	OrderQuantity int not null,
	DueDate	datetime not null constraint DF_ProductOrders_DueDate default (dateadd(hour, 1, getdate()))
)

select * from dbo.Inventory

--Product t�bla felt�lt�se
insert into dbo.Product(ProductName,ListPrice, Color, ProductNumber)
select top 100 Name, ListPrice, Color, ProductNumber
from [AdventureWorks2019].Production.Product
where Color is not null
and ListPrice > 0

--Inventory t�bla felt�lt�se
insert into dbo.Inventory
select 'AA', ProductID, 10, 10
from dbo.Product
where Color = 'Red'

--besz�r�s a ProductOrders t�bl�ba
insert into dbo.ProductOrders(OrderID,Status,InventoryID,OrderQuantity)
values(1,0,1,5)

select * from dbo.ProductOrders

--ALTER TABLE
-- egy �j oszlop (,meg egy constraint) hozz�ad�sa
alter table dbo.ProductOrders
	add OrderStart datetime constraint DF_ProductOrders_OrderStart default (getdate())

-- megl�v� oszlop t�pus�nak m�dos�t�sa
alter table dbo.ProductOrders
	alter column Status tinyint not null

alter table dbo.ProductOrders
	alter column OrderQuantity smallint not null

-- �j constraint felv�tele n�vvel
alter table dbo.ProductOrders
	add constraint CH_ProductOrders_OrderQuantity check ( OrderQuantity > 0)

--�j constraint felv�tele n�v n�lk�l
alter table dbo.ProductOrders
	add check ( OrderQuantity > 0)

-- constraint t�rl�se
alter table dbo.ProductOrders
	drop constraint [CK__ProductOr__Order__74794A92]


--feladat
-- �j ProductID oszlop null-k�nt
alter table dbo.ProductOrders
	add ProductID int null	--hogy le tudjuk futtatni ezt

-- rel�ci� defini�l�sa a Product t�bl�hoz n�v n�lk�l
alter table dbo.ProductOrders
	add foreign key (ProductID) references dbo.Product (ProductID)

-- rel�ci� defini�l�sa a Product t�bl�hoz n�vvel
alter table dbo.ProductOrders
	add constraint FK_ProductOrders_Product foreign key (ProductID) references dbo.Product (ProductID)

-- �res ProductID oszlop felt�lt�se az Inventory t�bl�b�l
update po
set po.ProductID = iv.ProductID
--select po.ProductID, iv.ProductID --ezt friss�tem erre
from dbo.ProductOrders po
inner join dbo.Inventory iv on iv.ID = po.InventoryID

select * from dbo.ProductOrders

--ProductID oszlop be�ll�t�sa not null-ra
alter table dbo.ProductOrders
	alter column ProductId int not null