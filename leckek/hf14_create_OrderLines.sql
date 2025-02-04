alter table dbo.Orders
	add constraint PK_Orders primary key (OrderID)
go

create table dbo.OrderLines(
	OrderLineID int not null identity(1,1),
	OrderID int not null,
	InventoryID int not null,
	ProductID int not null,
	Quantity smallint not null,
	constraint FK_OrderLines_Orders foreign key (OrderID) references dbo.Orders(OrderID),
	constraint FK_OrderLines_Inventory foreign key (InventoryID) references dbo.Inventory(ID),
	constraint FK_OrderLines_Product foreign key (ProductID) references dbo.Product(ProductID)
)

alter table dbo.OrderLines
	add constraint PK_OrderLines primary key (OrderID, InventoryID, ProductID)

