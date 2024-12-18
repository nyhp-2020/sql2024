
/*
uspFinishOrder
rendelés véglegesítése, készleten lévõ mennyiség csökkentése, ProductOrders sor törlése
*/

create or alter procedure uspFinishOrder(
	@OrderID int
)
as

--declare @OrderID int = 10

--elõtte
--select * from  dbo.Inventory where ProductID = 1003
--select * from dbo.ProductOrders where OrderID = @OrderID

--/*
update dbo.Orders
set Status = 1
where OrderID = @OrderID 
and Status = 0
--*/

update i
--select i.ProductLeft, po.OrderQuantity
set i.ProductLeft = i.ProductLeft - po.OrderQuantity
from dbo.ProductOrders po
inner join dbo.Inventory i on i.ID = po.InventoryID
where po.OrderID = @OrderID

--törlöm a zárolásokat
delete
from dbo.ProductOrders
where OrderID = @OrderID

--utána
--select * from  dbo.Inventory where ProductID = 1003
--select * from dbo.ProductOrders where OrderID = @OrderID
go

select * from dbo.Orders where OrderID = 11
select * from  dbo.Inventory where ProductID = 1003
select * from dbo.ProductOrders where OrderID = 11

exec uspFinishOrder 11 --OrderID

select * from dbo.Orders where OrderID = 11
select * from  dbo.Inventory where ProductID = 1003
select * from dbo.ProductOrders where OrderID = 11

-- további anyag

-- mennyi helyet foglal egy tábla
exec sp_spaceused 'dbo.Country'

--minden táblára lefuttat egy lekérdezést
exec sp_msforeachtable 'select ''?'' as table_name, count(*) row_count from ?' --dinamikus sql
