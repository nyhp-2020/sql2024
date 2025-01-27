
--system versioning (Temporal table)
create table Orders(
SalesOrderID int identity(1,1) not for replication not null,
OrderDate datetime not null,
Status tinyint not null,
CustomerID int not null,
SubTotal money not null,
ValidFrom datetime2 generated always as row start not null,
ValidTo datetime2 generated always as row end not null
constraint Pk_SalesOrderHeader_SalesOrderId primary key clustered (SalesOrderID asc),
period for SYSTEM_TIME (ValidFrom,ValidTo)
)
with (system_versioning = on) --UTC id�t haszn�l, nem lok�lis id�t

--felt�lt�s
insert into Orders(OrderDate,Status,CustomerID, Subtotal)
select top 10000 OrderDate,Status,CustomerID, Subtotal
from AdventureWorks2019.Sales.SalesOrderHeader

--valamikori �llapot
select * from Orders for system_time as of '2025-01-09 12:00'

select * from Orders for system_time as of '2025-01-09 13:00'

--update
update Orders set Subtotal = 0 where SalesOrderID = 1

--history t�bla (sorok r�gi �llapota)
select * from [dbo].[MSSQL_TemporalHistoryFor_933578364]

select * from Orders for system_time as of '2025-01-09 12:12'
order by SalesOrderID

--t�rl�s
delete from Orders

--�sszes  verzi� lek�rdez�se
select * from Orders for system_time all
where SalesOrderID = 1
order by SalesOrderID

select * from Orders for system_time between '2025-01-09 12:12' and '2025-01-09 13:12'
--where SalesOrderID = 1
order by SalesOrderID

--verzi�kezel�s kikapcsol�sa (history t�bla lev�lik a f�t�bl�r�l)
alter table Orders
set (system_versioning = off)

--k�zben �tnevezt�k a history t�bl�t
select * from Orders_History

-- verzi�kezel�s visszakapcsol�sa (esetleg �talak�t�s ut�n)
alter table Orders
set (system_versioning = on (HISTORY_TABLE = dbo.Orders_History, DATA_CONSISTENCY_CHECK = ON))



--egy egy kapcsolat, ha k�t els�dleges kulcsot kapcsolok �ssze

alter authorization on database::[Teszt] to sa --hogy database diagramot csin�lhassunk

Create table Orders2(
ID int not null primary key
)

-- ebbe a t�bl�ba csak olyat vehetek fel, ami benne van az Orders-ben
alter table Orders2
	add constraint FK_Orders_Orders2 foreign key (ID) references Orders(SalesOrderID)

--Az Orders-be b�rmilyet felvehetek

/*
A sorsz�moz�s ki/be kapcsol�sa
Tools -> Options->Text Editor -> All Languages -> Line numbers (pipa ki/be)
*/