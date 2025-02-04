select i.*, p.ProductName
from Inventory i
inner join Product p on i.ProductID = p.ProductID
where i.ProductLeft > 0


exec uspAddToInventory
@ProductID
@Uantity
@Shelf