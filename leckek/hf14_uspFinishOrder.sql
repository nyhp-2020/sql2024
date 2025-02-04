create or ALTER   procedure [dbo].[uspFinishOrder](
	@OrderID int
)
as

set xact_abort on --b�rmilyen hib�n�l rollback-el
set nocount on

begin transaction

	update dbo.Orders
	set Status = 1
	where OrderID = @OrderID 
	and Status = 0

	if @@rowcount = 0 throw 50000,'A rendel�s nem nyitott vagy nem l�tezik', 0

	-- k�nyvel�s az Inventory-ba
	update i
	--select i.ProductLeft, po.OrderQuantity
	set i.ProductLeft = i.ProductLeft - po.OrderQuantity
	from dbo.ProductOrders po
	inner join dbo.Inventory i on i.ID = po.InventoryID
	where po.OrderID = @OrderID

	-- besz�r�s az OrderLines t�bl�ba
	insert into dbo.OrderLines(OrderID,InventoryID,ProductID,Quantity)
	select o.OrderID,i.ID,p.ProductID,po.OrderQuantity
	from dbo.ProductOrders po
	inner join dbo.Inventory i on i.ID = po.InventoryID
	inner join dbo.Product p on p.ProductID = i.ProductID
	inner join dbo.Orders o on o.OrderID = po.OrderID

	--t�rl�m a z�rol�sokat
	delete
	from dbo.ProductOrders
	where OrderID = @OrderID

commit transaction
go
--teszt
exec dbo.uspFinishOrder @OrderID = 9
exec dbo.uspFinishOrder @OrderID = 10
exec dbo.uspFinishOrder @OrderID = 11

--
exec dbo.uspNewOrder null

exec dbo.uspAddToOrder @OrderID = 11 ,	@ProductID = 1071,	@Qty = 14

exec dbo.uspAddToOrder @OrderID = 9 ,	@ProductID = 1023,	@Qty = 3
exec dbo.uspAddToOrder @OrderID = 10 ,	@ProductID = 1023,	@Qty = 1

select *
from Orders o


select *
from Inventory
order by ProductID

select *
from Product

select *
from dbo.ProductOrders po
inner join dbo.Inventory i on i.ID = po.InventoryID
inner join dbo.Product p on p.ProductID = i.ProductID
inner join dbo.Orders o on o.OrderID = po.OrderID