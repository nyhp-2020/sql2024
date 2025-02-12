-- az Inventory-ban m�dos�tand� sorok, amiket az uspFinishOrder m�dos�t

declare @OrderID int = 10

select i.ProductLeft, po.OrderQuantity, i.ProductID,po.OrderID,i.ID
--set i.ProductLeft = i.ProductLeft - po.OrderQuantity
from dbo.ProductOrders po
inner join dbo.Inventory i on i.ID = po.InventoryID
where po.OrderID = @OrderID

/*
Ha a ProductOrders-ben benne vannak uspAddToOrder �ltal rosszul besz�rt plusz sorok (T�bb ProductID az Inventory-ban),
akkor itt mindegyiket m�dos�tja (mindegyikb�l kivonja a mennyis�get)
*/