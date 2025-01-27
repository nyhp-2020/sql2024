
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
with (system_versioning = on) --UTC idõt használ, nem lokális idõt

--feltöltés
insert into Orders(OrderDate,Status,CustomerID, Subtotal)
select top 10000 OrderDate,Status,CustomerID, Subtotal
from AdventureWorks2019.Sales.SalesOrderHeader

--valamikori állapot
select * from Orders for system_time as of '2025-01-09 12:00'

select * from Orders for system_time as of '2025-01-09 13:00'

--update
update Orders set Subtotal = 0 where SalesOrderID = 1

--history tábla (sorok régi állapota)
select * from [dbo].[MSSQL_TemporalHistoryFor_933578364]

select * from Orders for system_time as of '2025-01-09 12:12'
order by SalesOrderID

--törlés
delete from Orders

--összes  verzió lekérdezése
select * from Orders for system_time all
where SalesOrderID = 1
order by SalesOrderID

select * from Orders for system_time between '2025-01-09 12:12' and '2025-01-09 13:12'
--where SalesOrderID = 1
order by SalesOrderID

--verziókezelés kikapcsolása (history tábla leválik a fõtábláról)
alter table Orders
set (system_versioning = off)

--közben átneveztük a history táblát
select * from Orders_History

-- verziókezelés visszakapcsolása (esetleg átalakítás után)
alter table Orders
set (system_versioning = on (HISTORY_TABLE = dbo.Orders_History, DATA_CONSISTENCY_CHECK = ON))



--egy egy kapcsolat, ha két elsõdleges kulcsot kapcsolok össze

alter authorization on database::[Teszt] to sa --hogy database diagramot csinálhassunk

Create table Orders2(
ID int not null primary key
)

-- ebbe a táblába csak olyat vehetek fel, ami benne van az Orders-ben
alter table Orders2
	add constraint FK_Orders_Orders2 foreign key (ID) references Orders(SalesOrderID)

--Az Orders-be bármilyet felvehetek

/*
A sorszámozás ki/be kapcsolása
Tools -> Options->Text Editor -> All Languages -> Line numbers (pipa ki/be)
*/