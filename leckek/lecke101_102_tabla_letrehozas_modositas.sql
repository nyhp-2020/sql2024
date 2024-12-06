drop table if exists dbo.ProductOrders
-- tábla létrehozás
-- CREATE TABLE
create table dbo.ProductOrders(
	OrderID int not null,
	Status bit not null,
	InventoryID int not null,
	OrderQuantity int not null,
	DueDate	datetime not null constraint DF_ProductOrders_DueDate default (dateadd(hour, 1, getdate()))
)

select * from dbo.Inventory

--Product tábla feltöltése
insert into dbo.Product(ProductName,ListPrice, Color, ProductNumber)
select top 100 Name, ListPrice, Color, ProductNumber
from [AdventureWorks2019].Production.Product
where Color is not null
and ListPrice > 0

--Inventory tábla feltöltése
insert into dbo.Inventory
select 'AA', ProductID, 10, 10
from dbo.Product
where Color = 'Red'

--beszúrás a ProductOrders táblába
insert into dbo.ProductOrders(OrderID,Status,InventoryID,OrderQuantity)
values(1,0,1,5)

select * from dbo.ProductOrders

--ALTER TABLE
-- egy új oszlop (,meg egy constraint) hozzáadása
alter table dbo.ProductOrders
	add OrderStart datetime constraint DF_ProductOrders_OrderStart default (getdate())

-- meglévõ oszlop típusának módosítása
alter table dbo.ProductOrders
	alter column Status tinyint not null

alter table dbo.ProductOrders
	alter column OrderQuantity smallint not null

-- új constraint felvétele névvel
alter table dbo.ProductOrders
	add constraint CH_ProductOrders_OrderQuantity check ( OrderQuantity > 0)

--Új constraint felvétele név nélkül
alter table dbo.ProductOrders
	add check ( OrderQuantity > 0)

-- constraint törlése
alter table dbo.ProductOrders
	drop constraint [CK__ProductOr__Order__74794A92]


--feladat
-- új ProductID oszlop null-ként
alter table dbo.ProductOrders
	add ProductID int null	--hogy le tudjuk futtatni ezt

-- reláció definiálása a Product táblához név nélkül
alter table dbo.ProductOrders
	add foreign key (ProductID) references dbo.Product (ProductID)

-- reláció definiálása a Product táblához névvel
alter table dbo.ProductOrders
	add constraint FK_ProductOrders_Product foreign key (ProductID) references dbo.Product (ProductID)

-- üres ProductID oszlop feltöltése az Inventory táblából
update po
set po.ProductID = iv.ProductID
--select po.ProductID, iv.ProductID --ezt frissítem erre
from dbo.ProductOrders po
inner join dbo.Inventory iv on iv.ID = po.InventoryID

select * from dbo.ProductOrders

--ProductID oszlop beállítása not null-ra
alter table dbo.ProductOrders
	alter column ProductId int not null