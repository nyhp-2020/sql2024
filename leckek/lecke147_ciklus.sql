declare @ProductID int = 0

while (1 = 1)
begin
	select top 1 @ProductID = ProductID
	from Product
	where ProductName like 'Mountain-%'
	and ProductID > @ProductID
	order by ProductID

	if @@rowcount = 0 break  --ha az elõzõ lekérdezés 0 sort ad vissza, kilép a ciklusból

	--select @ProductID
	print @ProductID
	
	exec uspAddToInventory
		@ProductID = @ProductID, --paraméterátadás az eljárásnak
		@Quantity = 12,
		@Shelf = 'BB'
end
go

/*
select *
from Product
where ProductName like 'Mountain-%'
*/

-- egy for ciklus
declare @i int = 1
while(@i <= 100)
begin
	print @i
	--set @i = @i + 1
	set @i += 1
end