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
	insert into dbo.Inventory(Shelf,ProductID,ProductCount,ProductLeft,UnitPrice)
	select @Shelf,@ProductID,@Quantity,@Quantity,ListPrice
	from dbo.Product
	where ProductID = @ProductID

	--values(@Shelf,@ProductID,@Quantity,@Quantity)
go


uspAddToInventory 1004, 10, 'DD'
uspAddToInventory 2000, 10, 'DD' --Ilyen ProductID nincs...
