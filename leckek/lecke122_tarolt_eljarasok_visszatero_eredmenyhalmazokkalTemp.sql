create or alter procedure dbo.uspCollectEmailAddressesTemp
as
set nocount on  -- kikapcsolja a ... rows affected �zeneteket

create table #email(EmailAddress nvarchar(100))

insert into #email
select EmailAddress from AdventureWorks2019.Production.ProductReview where EmailAddress > ''

insert into #email
select EmailAddress from AdventureWorks2019.Person.EmailAddress where EmailAddress > ''

insert into #email
select EmailAddress from WideWorldImporters.Application.People where EmailAddress > ''

insert into #email
select EmailAddress from WideWorldImporters.Application.People_Archive where EmailAddress > ''

insert into #EmailAddresses(EmailAddress) --ez t�rolt elj�r�son k�v�li hivatkoz�s
select distinct EmailAddress
from #email e

go

drop table if exists #EmailAddresses
create table #EmailAddresses(EmailAddress nvarchar(100)) --ha nem l�tezik l�tre kell hozni,k�l�nben hiba van
exec uspCollectEmailAddressesTemp --ilyenkor m�r l�teznie kell a bel�l hivatkozott temp t�bl�nak

select * from #EmailAddresses