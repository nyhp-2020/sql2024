
/*
uspFinishOrder
rendel�s v�gleges�t�se, k�szleten l�v� mennyis�g cs�kkent�se, ProductOrders sor t�rl�se
*/

create or alter procedure uspFinishOrder(
	@OrderID int
)
as

--declare @OrderID int = 10

--el�tte
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

--t�rl�m a z�rol�sokat
delete
from dbo.ProductOrders
where OrderID = @OrderID

--ut�na
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

-- tov�bbi anyag

-- mennyi helyet foglal egy t�bla
exec sp_spaceused 'dbo.Country'

--minden t�bl�ra lefuttat egy lek�rdez�st
exec sp_msforeachtable 'select ''?'' as table_name, count(*) row_count from ?' --dinamikus sql
