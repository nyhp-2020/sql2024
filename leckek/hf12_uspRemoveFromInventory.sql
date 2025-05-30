USE [MyDB]
GO

-- uspRemoveFromInventory
create or alter  procedure [dbo].[uspRemoveFromInventory](
	@ProductID int,
	@Qty int
)
as
declare	@temp_qty int

--if dbo.GetInStock(@ProductID) < @Qty return

if dbo.GetInStock(@ProductID) < @Qty
begin
	raiserror('Nem áll rendelkezésre ekkora mennyiség (%d)',12,0, @Qty)
	return
end

update i
	set @temp_qty = @Qty,
	ProductLeft = case when ProductLeft >=  @temp_qty then ProductLeft -  @temp_qty else 0 end,
	@Qty = case when ProductLeft >= @temp_qty then 0 else @temp_qty - ProductLeft end
from dbo.Inventory i
where ProductID = @ProductID

go
--------------------
USE [MyDB]
GO
-- uspRemoveFromInventory Új!!!
create or alter  procedure [dbo].[uspRemoveFromInventory](
	@ProductID int,
	@Qty int
)
as
declare	@temp_qty int
declare @ID int = 0 --legyen kezdetben nem null értéke!

begin try
	begin transaction

	if not exists(select ProductID from Inventory where ProductID = @ProductID)
	begin
		raiserror('Nem létezik ilyen ProductID (%d)',12,0, @ProductID)
		return
	end

	if dbo.GetInStock(@ProductID) < @Qty
	begin
		raiserror('Nem áll rendelkezésre ekkora mennyiség (%d)',12,0, @Qty)
		return
	end

	while (1 = 1)
	begin

		select top 1 @ProductID = ProductID,@ID = ID
		from Inventory
		where ProductID = @ProductID
		and ID > @ID
		order by ID

		if @@rowcount = 0 break

		update i
		set @temp_qty = @Qty,
		ProductLeft = case when ProductLeft >=  @temp_qty then ProductLeft -  @temp_qty else 0 end,
		@Qty = case when ProductLeft >= @temp_qty then 0 else @temp_qty - ProductLeft end
		from dbo.Inventory i
		where ProductID = @ProductID and ID = @ID

		if @Qty = 0 break

	end
	commit
end try
begin catch
	if @@trancount > 0 rollback transaction;
	throw;
end catch
go

dbo.uspRemoveFromInventory 1003, 3

dbo.uspRemoveFromInventory 1139, 6

dbo.uspRemoveFromInventory 1002, 600
--
select * from dbo.Inventory
order by ProductID

