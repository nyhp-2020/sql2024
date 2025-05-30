USE [MyDB]
GO

create or alter   procedure [dbo].[uspFinishOrder](
	@OrderID int
)
as

begin try
	begin transaction

	update dbo.Orders
	set Status = 1
	where OrderID = @OrderID 
	and Status = 0

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

	commit
end try
begin catch
	if @@trancount > 0 rollback
end catch

go
