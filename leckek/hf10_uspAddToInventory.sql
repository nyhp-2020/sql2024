create or alter procedure uspAddToInventory(
	@ProductID int,
	@Quantity smallint,
	@Shelf nvarchar(10)
)
as

if exists(select * from dbo.Inventory i
		  where i.ProductID = @ProductID and i.Shelf = @Shelf)
	update dbo.Inventory
	set ProductCount += @Quantity,
		ProductLeft += @Quantity
	where ProductID = @ProductID and Shelf = @Shelf
else
	insert into dbo.Inventory(Shelf,ProductID,ProductCount,ProductLeft)
	values(@Shelf,@ProductID,@Quantity,@Quantity)
go

uspAddToInventory 1003, 5, 'BB'
uspAddToInventory 1002, 10, 'CC'
uspAddToInventory 2000, 10, 'DD' --Ilyen ProductID nincs...
