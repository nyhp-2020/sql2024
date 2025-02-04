
-- �sszetett kulcsod adunk (defini�lunk) a ProductOrders -hez
alter table [dbo].[ProductOrders]
	add constraint PK_ProductOrders primary key (OrderID,InventoryID)
-- csak not null oszlop lehet benne els�dleges kulcsban !

--Inventory t�bl�n m�sodlagos kulcs defini�l�sa
-- ha van duplik�tum, nem fut le
alter table [dbo].[Inventory]
	add constraint UK_Inventory unique (Shelf,ProductID)
--de sz�rt unique index lehet
create unique index UX_Inventory on [dbo].[Inventory](Shelf,ProductID)
where ProductLeft > 0

-- a [dbo].[uspFinishOrder] tranzakci�kezeltt� t�tele
select * from Orders
exec [dbo].[uspFinishOrder] @OrderID = 1

--uspAddToOrder , tranzakci�, ellen�rz�sek
exec dbo.uspAddToOrder @OrderID = 1, @ProductID = 1, @Qty = -1

--uspAddToInventory
exec dbo.uspAddToInventory @ProductID = 1,	@Quantity = -1,	@Shelf = 'AA'