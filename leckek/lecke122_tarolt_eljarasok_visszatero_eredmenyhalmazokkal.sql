create or alter procedure dbo.uspCollectEmailAddresses(
	@Load bit = 1
)
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

if @Load = 1
	insert into dbo.EmailAddresses(EmailAddress)
	select distinct EmailAddress
	from #email e
	where not exists(select * from dbo.EmailAddresses ea where ea.EmailAddress = e.EmailAddress)
else
	select distinct EmailAddress
	from #email e

go

--exec uspCollectEmailAddresses

exec uspCollectEmailAddresses @Load = 1 -- ekkor bet�lti

insert into dbo.EmailAddresses(EmailAddress) -- beszurhatjuk a visszaadott eredm�nyt egy t�bl�ba, ha minden Ok.
exec uspCollectEmailAddresses @Load = 0 -- ekkor nem t�lti be, csak visszaadja

-- most �gy dupl�n vannak.
--select * from dbo.EmailAddresses
--order by EmailAddress