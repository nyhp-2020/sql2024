
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

if dbo.GetInStock(@ProductID) < @Qty return 1 -- nincs annyi mennyis�g rakt�ron
update p
set OrderQuantity = OrderQuantity  + @Qty
--select *
from dbo.ProductOrders p
where OrderID = @OrderID and ProductID = @ProductID

if @@rowcount = 0  --el�z� nem �rintett egy sort se
	insert into dbo.ProductOrders(OrderID,Status,InventoryID,OrderQuantity,DueDate,OrderStart,ProductID)
	select @OrderID,0,i.ID,@Qty,dateadd(hour,1,getdate()), getdate(),i.ProductID
	from dbo.Inventory i
	where i.ProductID = @ProductID -- t�bb is lehet? 
	-- (akkor t�bb sort is besz�rhat dbo.ProductOrders-be ugyanazzal a mennyis�ggel, ugyanazzal az OrderID-vel!...)
	and i.ProductLeft >= @Qty
return 0 --csak t�rolt elj�r�sban adhat vissza �rt�ket a return

--delete from dbo.ProductOrders where OrderID = 10

--select *
--from dbo.ProductOrders p
--where OrderID = 10 and ProductID = 1003

go

-- megh�v�s
exec uspAddToOrder
	@OrderID = 10,
	@ProductID = 1003,
	@Qty = 2

-- ld. m�g uspFinishOrder feladat