begin tran

set transaction isolation level repeatable read

select top 1 *from dbo.Inventory

rollback
go

--deadlock 1
begin tran

set transaction isolation level read committed

--módosítás a Product-on
update top (1) Product set ListPrice = 100
--futtatás eddig
--majd
select * from dbo.Inventory

rollback

go


--serializable példa

begin tran

set transaction isolation level serializable

update top (1) Product set ListPrice = 100

select * from dbo.Inventory

rollback
go

--izolációs szint beállítása tábla szinten

begin tran

set transaction isolation level serializable

update top (1) Product set ListPrice = 999

rollback