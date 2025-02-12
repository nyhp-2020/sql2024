-- az Inventory-ban módosítandó sorok, amiket az uspFinishOrder módosít

declare @OrderID int = 10

select i.ProductLeft, po.OrderQuantity, i.ProductID,po.OrderID,i.ID
--set i.ProductLeft = i.ProductLeft - po.OrderQuantity
from dbo.ProductOrders po
inner join dbo.Inventory i on i.ID = po.InventoryID
where po.OrderID = @OrderID

/*
Ha a ProductOrders-ben benne vannak uspAddToOrder által rosszul beszúrt plusz sorok (Több ProductID az Inventory-ban),
akkor itt mindegyiket módosítja (mindegyikbõl kivonja a mennyiséget)
*/