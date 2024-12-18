create or alter procedure uspCleanupOrder
as

create table #pqal92(OrderID int)

-- st�tusz �ll�t�s
update dbo.Orders
set Status = 1
output inserted.OrderID into #pqal92
--select *,datediff(minute , Orderdate, getdate())
from Orders o
where datediff(minute , Orderdate, getdate()) > 60 -- egy �r�n�l r�gebbi
and Status = 0									   -- le nem z�rt

select * from #pqal92

-- kapcsol�d� sorok t�rl�se (t�rl�se azoknak, amik benne vannak egy m�sik t�bl�ban )
delete from dbo.ProductOrders
from dbo.ProductOrders po
inner join #pqal92 t on t.OrderID = po.OrderID


drop table if exists #pqal92
go

exec uspCleanupOrder