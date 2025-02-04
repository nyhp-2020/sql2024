
-- összetett kulcsod adunk (definiálunk) a ProductOrders -hez
alter table [dbo].[ProductOrders]
	add constraint PK_ProductOrders primary key (OrderID,InventoryID)
-- csak not null oszlop lehet benne elsõdleges kulcsban !

--Inventory táblán másodlagos kulcs definiálása
-- ha van duplikátum, nem fut le
alter table [dbo].[Inventory]
	add constraint UK_Inventory unique (Shelf,ProductID)
--de szûrt unique index lehet
create unique index UX_Inventory on [dbo].[Inventory](Shelf,ProductID)
where ProductLeft > 0

-- a [dbo].[uspFinishOrder] tranzakciókezeltté tétele
select * from Orders
exec [dbo].[uspFinishOrder] @OrderID = 1

--uspAddToOrder , tranzakció, ellenõrzések
exec dbo.uspAddToOrder @OrderID = 1, @ProductID = 1, @Qty = -1

--uspAddToInventory
exec dbo.uspAddToInventory @ProductID = 1,	@Quantity = -1,	@Shelf = 'AA'