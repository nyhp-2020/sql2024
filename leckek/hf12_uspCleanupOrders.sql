use
[MyDB]
go
create or alter procedure [dbo].[uspCleanupOrders]
as
declare @updated_orderid table (UpdatedOrderID int)
--az 1 óránál régebb óta le nem zárt rendelések státuszát -1-re állítja
begin try
	begin transaction
	update dbo.Orders
	Set dbo.Orders.Status = -1
	--elmentem a -1-es státuszra állított rendelések ID-ját
	output inserted.OrderID into @updated_orderid
	where (datediff(hour,dbo.Orders.OrderDate,getdate())>1)
	and dbo.Orders.Status = 0

	--a hozzá kapcsolódó ProductOrders sorokat törli.
	delete from dbo.ProductOrders
	where OrderID in (select UpdatedOrderID from @updated_orderid)
	commit transaction
end try
begin catch
	if @@trancount > 0 rollback transaction
end catch

go