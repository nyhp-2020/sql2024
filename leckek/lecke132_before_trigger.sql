/*
Készítsünk egy triggert, amely megakadályozza, hogy a ProductOrders táblán az OrderStart oszlopot módosíhassuk
*/

create or alter trigger tr_ProductOrders_OrderStart
on dbo.ProductOrders
instead of update -- instead of (before) esemény elõtt fut
as

declare @i int

--if not update(OrderStart) return -- ha nem módosítják az OrderStart oszlopot, kilépés

if update(OrderStart)
select @i = (1/0)

-- implementálni kell az eredeti mûveletet, mert különben nem történik semmi
update p
set p.Status = i.Status,
	p.OrderQuantity = i.OrderQuantity,
	p.DueDate = i.DueDate
from dbo.ProductOrders p
inner join inserted i on i.OrderID = p.OrderID
					  and i.InventoryID = p.InventoryID
					  and i.ProductID = p.ProductID

--declare @i int
--select @i = (1/0) --nullával osztás hiba
go

--javaslat: insert/update/delete mûveletekre külön triggert írjunk

-- ellenõrzés
select * from dbo.ProductOrders
update dbo.ProductOrders set OrderStart = getdate()

update top(1) dbo.ProductOrders set DueDate = '2024-06-01'

--HF
--update dbo.ProductsInStock set ProductAvailable = 0 where ProductID = ...
--select * from dbo.Inventory where ProductID = ... -- lehet több sor is
--és a ProductLeft-et mindenhol 0-ra kell állítani (Ha lekérdzzü ka view-t, 0-t adjon)

-- frissít egy kapcsolódó inventory sort
-- vannak nem frissíthetõ view-k, ez is olyan...

-- nézeten is lehet trigger
create or alter trigger tr_ProductsInStock
on dbo.ProductsInStock
instead of update
as
print ''-- kell bele utasítás

go