/*
�j elj�r�s: uspNewCustomer
Param�terek: Title,FirstName,LastName, CountryCode, CountryName,CountryIso3Code
�j Customer l�trehoz�sa, �j orsz�g felv�tele, ha kell
*/

create or alter procedure uspNewCustomer(

--declare
	@Title nvarchar(10),
	@FirstName nvarchar(100) = 'Peter',
	@LastName nvarchar(100) = 'Nyarai',
	@CountryCode nchar(2) = 'HU',
	@CountryName nvarchar(50) = 'Hungary',
	@CountryIso3Code nchar(3) = 'HUN'
) -- z�r�jelek nem k�telez�ek
as

-- ha valamelyik passzol
if exists( --ha ad vissza eredm�nyt
		select *
		from dbo.Country
		where CountryCode = @CountryCode
		or CountryName = @CountryName
		or CountryIso3Code = @CountryIso3Code
	)
	and not exists(
	-- biztos �gy van felv�ve
		select *
		from dbo.Country
		where CountryCode = @CountryCode
		and CountryName = @CountryName
		and CountryIso3Code = @CountryIso3Code
	)
	begin
		print 'Nem megfelel� orsz�g k�dok'
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

