/*
K�sz�ts�nk egy triggert, amely megakad�lyozza, hogy a ProductOrders t�bl�n az OrderStart oszlopot m�dos�hassuk
*/

create or alter trigger tr_ProductOrders_OrderStart
on dbo.ProductOrders
instead of update -- instead of (before) esem�ny el�tt fut
as

declare @i int

--if not update(OrderStart) return -- ha nem m�dos�tj�k az OrderStart oszlopot, kil�p�s

if update(OrderStart)
select @i = (1/0)

-- implement�lni kell az eredeti m�veletet, mert k�l�nben nem t�rt�nik semmi
update p
set p.Status = i.Status,
	p.OrderQuantity = i.OrderQuantity,
	p.DueDate = i.DueDate
from dbo.ProductOrders p
inner join inserted i on i.OrderID = p.OrderID
					  and i.InventoryID = p.InventoryID
					  and i.ProductID = p.ProductID

--declare @i int
--select @i = (1/0) --null�val oszt�s hiba
go

--javaslat: insert/update/delete m�veletekre k�l�n triggert �rjunk

-- ellen�rz�s
select * from dbo.ProductOrders
update dbo.ProductOrders set OrderStart = getdate()

update top(1) dbo.ProductOrders set DueDate = '2024-06-01'

--HF
--update dbo.ProductsInStock set ProductAvailable = 0 where ProductID = ...
--select * from dbo.Inventory where ProductID = ... -- lehet t�bb sor is
--�s a ProductLeft-et mindenhol 0-ra kell �ll�tani (Ha lek�rdzz� ka view-t, 0-t adjon)

-- friss�t egy kapcsol�d� inventory sort
-- vannak nem friss�thet� view-k, ez is olyan...

-- n�zeten is lehet trigger
create or alter trigger tr_ProductsInStock
on dbo.ProductsInStock
instead of update
as
print ''-- kell bele utas�t�s

go