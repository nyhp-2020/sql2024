ALTER   procedure [dbo].[uspFinishOrder](
	@OrderID int
)
as

--declare @OrderID int = 10

--elõtte
--select * from  dbo.Inventory where ProductID = 1003
--select * from dbo.ProductOrders where OrderID = @OrderID

declare @table table(ID int, ProductID int) --tábla változó pl.

--tramzakció nyitás
begin transaction
--/*
update dbo.Orders
set Status = 1
where OrderID = @OrderID 
and Status = 0
--*/

update i
--select i.ProductLeft, po.OrderQuantity
set i.ProductLeft = i.ProductLeft - po.OrderQuantity
output inserted.ID,inserted.ProductID into @table(ID, ProductID) -- otput betöltése tábla változóba; De temp táblába is lehet
												--itt ezt most nem használjuk, csak példa volt
from dbo.ProductOrders po
inner join dbo.Inventory i on i.ID = po.InventoryID
where po.OrderID = @OrderID

--törlöm a zárolásokat
delete
from dbo.ProductOrders
where OrderID = @OrderID
-- tranzakció zárás (mentés)
commit transaction

--
/*
Függvény nem módosíthat semmit, csak olvashat
*/