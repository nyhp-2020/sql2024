create or alter procedure uspCleanupOrder
as

create table #pqal92(OrderID int)

-- státusz állítás
update dbo.Orders
set Status = 1
output inserted.OrderID into #pqal92
--select *,datediff(minute , Orderdate, getdate())
from Orders o
where datediff(minute , Orderdate, getdate()) > 60 -- egy óránál régebbi
and Status = 0									   -- le nem zárt

select * from #pqal92

-- kapcsolódó sorok törlése (törlése azoknak, amik benne vannak egy másik táblában )
delete from dbo.ProductOrders
from dbo.ProductOrders po
inner join #pqal92 t on t.OrderID = po.OrderID


drop table if exists #pqal92
go

exec uspCleanupOrder