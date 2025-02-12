
/*
uspFinishOrder
rendelés véglegesítése, készleten lévõ mennyiség csökkentése, ProductOrders sor törlése
*/

create or alter procedure uspFinishOrder(
	@OrderID int
)
as

--declare @OrderID int = 10

--elõtte
--select * from  dbo.Inventory where ProductID = 1003
--select * from dbo.ProductOrders where OrderID = @OrderID

--/*
update dbo.Orders
set Status = 1
where OrderID = @OrderID 
and Status = 0
--*/

update i
--select i.ProductLeft, po.OrderQuantity
set i.ProductLeft = i.ProductLeft - po.OrderQuantity
from dbo.ProductOrders po
inner join dbo.Inventory i on i.ID = po.InventoryID
where po.OrderID = @OrderID
/*
Ha a ProductOrders-ben benne vannak uspAddToOrder által rosszul beszúrt plusz sorok (Több ProductID az Inventory-ban),
akkor itt mindegyiket módosítja (mindegyikbõl kivonja a mennyiséget)
*/

--törlöm a zárolásokat
delete
from dbo.ProductOrders
where OrderID = @OrderID

--utána
--select * from  dbo.Inventory where ProductID = 1003
--select * from dbo.ProductOrders where OrderID = @OrderID
go

/*
Itt is kérdés, hogy a dbo.Inventory-ban megengedünk-e több sort ugyanazzal a ProductID-vel.
Mert az uspFinishOrder eljárás több sort is fog módosítani az Inventory-ban.
És több sort fog törölni a dbo.ProductOrders-bõl,
amit korábban az uspAddToOrder eljárás szúrt be oda ugyanazzal az OrderID-vel és OrderQuantity-vel,
pont az miatt hogy a dbo.Inventory-ban több sor van ugyanazzal a ProductID-vel...
Vagy kényszerítsük ki, hogy a dbo.Inventory-ban a ProductID egyedi legyen?
*/

select * from dbo.Orders where OrderID = 11
select * from  dbo.Inventory where ProductID = 1003
select * from dbo.ProductOrders where OrderID = 11

exec uspFinishOrder 11 --OrderID

select * from dbo.Orders where OrderID = 11
select * from  dbo.Inventory where ProductID = 1003
select * from dbo.ProductOrders where OrderID = 11

-- további anyag

-- mennyi helyet foglal egy tábla
exec sp_spaceused 'dbo.Country'

--minden táblára lefuttat egy lekérdezést
exec sp_msforeachtable 'select ''?'' as table_name, count(*) row_count from ?' --dinamikus sql
