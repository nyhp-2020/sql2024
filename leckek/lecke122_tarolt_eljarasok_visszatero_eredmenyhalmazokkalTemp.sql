create or alter procedure dbo.uspCollectEmailAddressesTemp
as
set nocount on  -- kikapcsolja a ... rows affected üzeneteket

create table #email(EmailAddress nvarchar(100))

insert into #email
select EmailAddress from AdventureWorks2019.Production.ProductReview where EmailAddress > ''

insert into #email
select EmailAddress from AdventureWorks2019.Person.EmailAddress where EmailAddress > ''

insert into #email
select EmailAddress from WideWorldImporters.Application.People where EmailAddress > ''

insert into #email
select EmailAddress from WideWorldImporters.Application.People_Archive where EmailAddress > ''

insert into #EmailAddresses(EmailAddress) --ez tárolt eljáráson kívüli hivatkozás
select distinct EmailAddress
from #email e

go

drop table if exists #EmailAddresses
create table #EmailAddresses(EmailAddress nvarchar(100)) --ha nem létezik létre kell hozni,különben hiba van
exec uspCollectEmailAddressesTemp --ilyenkor már léteznie kell a belül hivatkozott temp táblának

select * from #EmailAddresses