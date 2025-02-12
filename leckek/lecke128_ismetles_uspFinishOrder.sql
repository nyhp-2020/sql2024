
/*
uspFinishOrder
rendel�s v�gleges�t�se, k�szleten l�v� mennyis�g cs�kkent�se, ProductOrders sor t�rl�se
*/

create or alter procedure uspFinishOrder(
	@OrderID int
)
as

--declare @OrderID int = 10

--el�tte
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
Ha a ProductOrders-ben benne vannak uspAddToOrder �ltal rosszul besz�rt plusz sorok (T�bb ProductID az Inventory-ban),
akkor itt mindegyiket m�dos�tja (mindegyikb�l kivonja a mennyis�get)
*/

--t�rl�m a z�rol�sokat
delete
from dbo.ProductOrders
where OrderID = @OrderID

--ut�na
--select * from  dbo.Inventory where ProductID = 1003
--select * from dbo.ProductOrders where OrderID = @OrderID
go

/*
Itt is k�rd�s, hogy a dbo.Inventory-ban megenged�nk-e t�bb sort ugyanazzal a ProductID-vel.
Mert az uspFinishOrder elj�r�s t�bb sort is fog m�dos�tani az Inventory-ban.
�s t�bb sort fog t�r�lni a dbo.ProductOrders-b�l,
amit kor�bban az uspAddToOrder elj�r�s sz�rt be oda ugyanazzal az OrderID-vel �s OrderQuantity-vel,
pont az miatt hogy a dbo.Inventory-ban t�bb sor van ugyanazzal a ProductID-vel...
Vagy k�nyszer�ts�k ki, hogy a dbo.Inventory-ban a ProductID egyedi legyen?
*/

select * from dbo.Orders where OrderID = 11
select * from  dbo.Inventory where ProductID = 1003
select * from dbo.ProductOrders where OrderID = 11

exec uspFinishOrder 11 --OrderID

select * from dbo.Orders where OrderID = 11
select * from  dbo.Inventory where ProductID = 1003
select * from dbo.ProductOrders where OrderID = 11

-- tov�bbi anyag

-- mennyi helyet foglal egy t�bla
exec sp_spaceused 'dbo.Country'

--minden t�bl�ra lefuttat egy lek�rdez�st
exec sp_msforeachtable 'select ''?'' as table_name, count(*) row_count from ?' --dinamikus sql
