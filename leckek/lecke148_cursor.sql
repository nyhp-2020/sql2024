declare @cursor cursor
declare @ProductID int

set @cursor = cursor for
	select ProductID
	from Product
	where ProductName like 'Mountain-%'

open @cursor

fetch next from @cursor into @ProductID

while(@@fetch_status = 0)
begin
	print @ProductID
	
	exec uspAddToInventory
		@ProductID = @ProductID, --paraméterátadás az eljárásnak
		@Quantity = 12,
		@Shelf = 'CC'

	fetch next from @cursor into @ProductID
end

close @cursor

/*
select *
from Product
where ProductName like 'Mountain-%'
*/