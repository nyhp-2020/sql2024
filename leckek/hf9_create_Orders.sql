
create table dbo.Orders(
	OrderID int not null identity(1,1),
	OrderDate datetime not null constraint DF_Orders_OrderDate default getdate(),
	Status tinyint not null default 0 constraint CH_Status check (Status >= 0 and Status <= 10),
	SessionID uniqueidentifier not null constraint DF_Orders_SessionID default newid() constraint UK_SessionID unique
)
