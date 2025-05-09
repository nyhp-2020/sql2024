USE [MyDB]
GO
/****** Object:  StoredProcedure [dbo].[uspAddToOrder]    Script Date: 2025. 01. 30. 12:50:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- arra az esetre, ha a dbo.Inventory-ban több sor is van ugyanazzal a ProductID-vel (több polcon)
-- ciklikusan szúr be foglalásokat a ProductOrders-be az Inventory sorok alapján
create or ALTER   procedure [dbo].[uspAddToOrder]
	@OrderID int,
	@ProductID int,
	@Qty smallint
as
set xact_abort on
set nocount on
begin transaction

	if @Qty <= 0 throw 50000, 'Nem lehet zéró vagy negatív mennyiség.', 0

	if dbo.GetInStock(@ProductID) < @Qty throw 50001, 'Nincs elegendő készlet !', 0 -- nincs annyi mennyiség raktáron

	if not exists(select * from Orders where OrderID = @OrderID and Status = 0)
		throw 50002, 'Nem nyitott rendelés.', 0

	declare	@ProductLeft smallint,
			@qty_ins int,
			@ID int = 0 --kisebb,mint a legelső ID az Inventory-ban

/*  -- Több sor is bekerülhet ide -jelen eljárás által- amire igaz a feltétel... Akkor nem volna jó ez a könyvelés.
	update p
	set OrderQuantity = OrderQuantity  + @Qty
	--select *
	from dbo.ProductOrders p
	where OrderID = @OrderID and ProductID = @ProductID

	if @@rowcount = 0  --előző nem érintett egy sort se
*/

	while (1 = 1)
		begin

			select top 1 @ProductID = ProductID,@ID = ID,@ProductLeft = ProductLeft
			from Inventory
			where ProductID = @ProductID
			and ID > @ID
			order by ID

			if @@rowcount = 0 break --elfogyott a sor

			--beszúrandó mennyiség
			set @Qty_ins = case when @ProductLeft >= @Qty then @Qty else @ProductLeft end

			if @qty_ins > 0  --nullánál nagyobb mennyiséget szúrok csak be...
				insert into dbo.ProductOrders(OrderID,Status,InventoryID,OrderQuantity,DueDate,OrderStart,ProductID)
				select @OrderID,0,@ID,@Qty_ins,dateadd(hour,1,getdate()), getdate(),@ProductID

			--következő ciklusra (maradék igény)
			set @Qty = case when @ProductLeft >= @Qty then 0 else @Qty - @ProductLeft end

			if @Qty <= 0 break --elfogyott az igény

		end
commit transaction

return 0
----------------- eljárás vége------------------
go

declare
	@OrderID int,
	@ProductID int = 1077,
	@Qty smallint = 13

declare
	@ProductLeft smallint

declare	@qty_ins int
declare @ID int = 0

while (1 = 1)
	begin

		select top 1 @ProductID = ProductID,@ID = ID,@ProductLeft = ProductLeft
		from Inventory
		where ProductID = @ProductID
		and ID > @ID
		order by ID

		if @@rowcount = 0 break

		--beszúrandó mennyiség
		set @Qty_ins = case when @ProductLeft >= @Qty then @Qty else @ProductLeft end

		--insert into dbo.ProductOrders(OrderID,Status,InventoryID,OrderQuantity,DueDate,OrderStart,ProductID)
		--select @OrderID,0,@ID,@Qty_ins,dateadd(hour,1,getdate()), getdate(),@ProductID

		select @ProductID as ProductID,@ID as InventoryID,@ProductLeft as ProductLeft,@Qty as igény, @Qty_ins as beszur
		
		--következő ciklusra (maradék igény)
		set @Qty = case when @ProductLeft >= @Qty then 0 else @Qty - @ProductLeft end

		--print concat(@ProductID, ' ', @ID, ' ', @ProductLeft)

	end

go

select * from Inventory
order by ProductId

select * from ProductOrders