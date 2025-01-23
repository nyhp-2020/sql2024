begin tran

set transaction isolation level repeatable read

select top 1 *from dbo.Inventory

rollback
go

--deadlock 1
begin tran

set transaction isolation level read committed

--m�dos�t�s a Product-on
update top (1) Product set ListPrice = 100
--futtat�s eddig
--majd
select * from dbo.Inventory

rollback

go


--serializable p�lda

begin tran

set transaction isolation level serializable

update top (1) Product set ListPrice = 100

select * from dbo.Inventory

rollback
go

--izol�ci�s szint be�ll�t�sa t�bla szinten

begin tran

set transaction isolation level serializable

update top (1) Product set ListPrice = 999

rollback