-- uspRemoveFromInventory
create or alter procedure uspRemoveFromInventory(
	@ProductID int,
	@Qty int
)
as
declare	@temp_qty int

if dbo.GetInStock(@ProductID) < @Qty return

update i
	set @temp_qty = @Qty,
	ProductLeft = case when ProductLeft >=  @temp_qty then ProductLeft -  @temp_qty else 0 end,
	@Qty = case when ProductLeft >= @temp_qty then 0 else @temp_qty - ProductLeft end
from dbo.Inventory i
where ProductID = @ProductID
go

exec uspRemoveFromInventory 1003,12
select * from dbo.Inventory where ProductID = 1003

--ld 7HET_PPT.pdf UPDATE és a változók oldal (Quantity @ nélkül értendõ)
