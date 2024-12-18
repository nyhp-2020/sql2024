
create or alter procedure uspAddToOrder
	@OrderID int,
	@ProductID int,
	@Qty smallint
as

/*declare
	@OrderID int = 10,
	@ProductID int = 1003,
	@Qty smallint = 1 */

--if dbo.GetInStock(@ProductID) >= @Qty 

if dbo.GetInStock(@ProductID) < @Qty return 1 -- nincs annyi mennyiség raktáron
update p
set OrderQuantity = OrderQuantity  + @Qty
--select *
from dbo.ProductOrders p
where OrderID = @OrderID and ProductID = @ProductID

if @@rowcount = 0  --elõzõ nem érintett egy sort se
	insert into dbo.ProductOrders(OrderID,Status,InventoryID,OrderQuantity,DueDate,OrderStart,ProductID)
	select @OrderID,0,i.ID,@Qty,dateadd(hour,1,getdate()), getdate(),i.ProductID
	from dbo.Inventory i
	where i.ProductID = @ProductID -- több is lehet? 
	-- (akkor több sort is beszúrhat dbo.ProductOrders-be ugyanazzal a mennyiséggel, ugyanazzal az OrderID-vel!...)
	and i.ProductLeft >= @Qty
return 0 --csak tárolt eljárásban adhat vissza értéket a return

--delete from dbo.ProductOrders where OrderID = 10

--select *
--from dbo.ProductOrders p
--where OrderID = 10 and ProductID = 1003

go

-- meghívás
exec uspAddToOrder
	@OrderID = 10,
	@ProductID = 1003,
	@Qty = 2

-- ld. még uspFinishOrder feladat