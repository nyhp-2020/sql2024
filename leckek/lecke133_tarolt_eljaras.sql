/*
Új eljárás: uspNewCustomer
Paraméterek: Title,FirstName,LastName, CountryCode, CountryName,CountryIso3Code
új Customer létrehozása, új ország felvétele, ha kell
*/

create or alter procedure uspNewCustomer(

--declare
	@Title nvarchar(10),
	@FirstName nvarchar(100) = 'Peter',
	@LastName nvarchar(100) = 'Nyarai',
	@CountryCode nchar(2) = 'HU',
	@CountryName nvarchar(50) = 'Hungary',
	@CountryIso3Code nchar(3) = 'HUN'
) -- zárójelek nem kötelezõek
as

-- ha valamelyik passzol
if exists( --ha ad vissza eredményt
		select *
		from dbo.Country
		where CountryCode = @CountryCode
		or CountryName = @CountryName
		or CountryIso3Code = @CountryIso3Code
	)
	and not exists(
	-- biztos így van felvéve
		select *
		from dbo.Country
		where CountryCode = @CountryCode
		and CountryName = @CountryName
		and CountryIso3Code = @CountryIso3Code
	)
	begin
		print 'Nem megfelelõ ország kódok'
		return
	end

if not exists(
	select *
	from dbo.Country
	where CountryCode = @CountryCode
	and CountryName = @CountryName
	and CountryIso3Code = @CountryIso3Code
	)
	insert into dbo.Country(CountryCode,CountryName,CountryISO3Code)
	values(@CountryCode,@CountryName,@CountryIso3Code)

insert into dbo.Customer(Title,FirstName,LastName,Country)
values(@Title,@FirstName,@LastName,@CountryCode)
go

