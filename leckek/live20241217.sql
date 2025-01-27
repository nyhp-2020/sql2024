ALTER   procedure [dbo].[uspFinishOrder](
	@OrderID int
)
as

--declare @OrderID int = 10

--el�tte
--select * from  dbo.Inventory where ProductID = 1003
--select * from dbo.ProductOrders where OrderID = @OrderID

declare @table table(ID int, ProductID int) --t�bla v�ltoz� pl.

--tramzakci� nyit�s
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
output inserted.ID,inserted.ProductID into @table(ID, ProductID) -- otput bet�lt�se t�bla v�ltoz�ba; De temp t�bl�ba is lehet
												--itt ezt most nem haszn�ljuk, csak p�lda volt
from dbo.ProductOrders po
inner join dbo.Inventory i on i.ID = po.InventoryID
where po.OrderID = @OrderID

--t�rl�m a z�rol�sokat
delete
from dbo.ProductOrders
where OrderID = @OrderID
-- tranzakci� z�r�s (ment�s)
commit transaction

--
/*
F�ggv�ny nem m�dos�that semmit, csak olvashat
*/