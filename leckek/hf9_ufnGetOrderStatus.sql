create or alter function dbo.ufnGetOrderStatus(@OrderID int)
returns int
as
begin	
	return case (select o.Status
				 from dbo.Orders o
				 where OrderID = @OrderID)
		   when 0 then 1 --�l a rendel�s
		   else 0
		   end
end
go

select dbo.ufnGetOrderStatus(100)

select *,dbo.ufnGetOrderStatus(OrderID)
from dbo.Orders