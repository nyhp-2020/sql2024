use
[MyDB]
go
create or alter procedure [dbo].[uspCleanupOrders]
as
declare @updated_orderid table (UpdatedOrderID int)
--az 1 �r�n�l r�gebb �ta le nem z�rt rendel�sek st�tusz�t -1-re �ll�tja
begin try
	begin transaction
	update dbo.Orders
	Set dbo.Orders.Status = -1
	--elmentem a -1-es st�tuszra �ll�tott rendel�sek ID-j�t
	output inserted.OrderID into @updated_orderid
	where (datediff(hour,dbo.Orders.OrderDate,getdate())>1)
	and dbo.Orders.Status = 0

	--a hozz� kapcsol�d� ProductOrders sorokat t�rli.
	delete from dbo.ProductOrders
	where OrderID in (select UpdatedOrderID from @updated_orderid)
	commit transaction
end try
begin catch
	if @@trancount > 0 rollback transaction
end catch

go