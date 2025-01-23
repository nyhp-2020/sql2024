USE [MyDB]
GO
/****** Object:  StoredProcedure [dbo].[uspRemoveFromInventory]    Script Date: 2025. 01. 16. 14:30:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- uspRemoveFromInventory
ALTER   procedure [dbo].[uspRemoveFromInventory](
	@ProductID int,
	@Qty int
)
as
declare	@temp_qty int

--if dbo.GetInStock(@ProductID) < @Qty return

if dbo.GetInStock(@ProductID) < @Qty
begin
	raiserror('Nem �ll rendelkez�sre ekkora mennyis�g (%d)',12,0, @Qty)
	return
end

update i
	set @temp_qty = @Qty,
	ProductLeft = case when ProductLeft >=  @temp_qty then ProductLeft -  @temp_qty else 0 end,
	@Qty = case when ProductLeft >= @temp_qty then 0 else @temp_qty - ProductLeft end
from dbo.Inventory i
where ProductID = @ProductID

go

--exec dbo.uspRemoveFromInventory @ProductID = 1002, @Qty = 200

begin try
	exec dbo.uspRemoveFromInventory @ProductID = 1002, @Qty = 200
end try
begin catch
	SELECT ERROR_NUMBER() AS ErrorNumber, 
	ERROR_SEVERITY() AS ErrorSeverity, 
	ERROR_STATE() AS ErrorState, 
	ERROR_PROCEDURE() AS ErrorProcedure,
	ERROR_LINE() AS ErrorLine,
	ERROR_MESSAGE() AS ErrorMessage; 
end catch

--eredeti ld. lecke144
go

USE [MyDB]
GO
/****** Object:  StoredProcedure [dbo].[uspUpdateProducts]    Script Date: 2025. 01. 16. 15:06:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER   procedure [dbo].[uspUpdateProducts](
	@DeleteMissing bit = 0, --alap�rtelmezett �rt�k "nem"
	@RowsLoaded int = null output  --kifel� t�rt�n� �rt�kad�shoz
)
as

--use MyDB --ez nem megengedett az elj�r�sban
-- ideiglenes t�bla l�trehoz�sa
drop table if exists #load

create table #load(
Nr nvarchar(100) null,
ProductNumber nvarchar(100) null,
ProductName nvarchar(100) null,
ListPrice nvarchar(100) null,
StandardCost nvarchar(100) null,
SellStartDate nvarchar(100) null
)

--select * from #load

--ld. lecke 95 (adatbet�lt�s csv-b�l)
bulk insert #load
from 'C:\temp\data.csv' --az SQL szervernek hozz� kell f�rni a file-hoz! (Ez �ltal�ban nem �gy van.)
with (
	firstrow = 2,
	fieldterminator = '\t'
)

--rendszerv�ltoz�
-- select @@rowcount as [row_count]-- az utols� sql utas�t�s �ltal �rintett sorok sz�ma

set @RowsLoaded = @@rowcount --v�ltoz� �rt�k�nek be�ll�t�sa

--select * from #load
set xact_abort on

begin try

	begin transaction

	--UPDATE
	update p
	set p.ListPrice = l.ListPrice -- ListPrice friss�t�s
	--select ProductName,try_cast(ListPrice as decimal(20,2)),ProductNumber,try_cast(StandardCost as decimal(20,2)), getdate()
	from #load l
	inner join dbo.Product p on p.ProductName = l.ProductName
	where exists(select * from dbo.Product t where t.ProductName = l.ProductName)
	and try_cast(l.ListPrice as decimal(20,2)) is not null
	and try_cast(l.StandardCost as decimal(20,2)) is not null


	--INSERT
	-- m�solat k�sz�t�s ideiglenes t�bl�ba
	/*
	select top 0 * into #product from dbo.Product

	-- kijel�l�s, ctrl+4 ?
	-- temp t�bl�ra lefutott
	insert into #Product(ProductName,ListPrice,ProductNumber,StandardCost,CreatedDate)
	select ProductName,try_cast(ListPrice as decimal(20,2)),ProductNumber,try_cast(StandardCost as decimal(20,2)), getdate()
	from #load l
	where not exists(select * from #Product t where t.ProductName = l.ProductName)
	and try_cast(ListPrice as decimal(20,2)) is not null
	and try_cast(StandardCost as decimal(20,2)) is not null
	*/
	-- �t�rom val�s t�bl�ra
	insert into dbo.Product(ProductName,ListPrice,ProductNumber,StandardCost,CreatedDate)
	select ProductName,try_cast(ListPrice as decimal(20,2)),ProductNumber,try_cast(StandardCost as decimal(20,2)), getdate()
	from #load l
	where not exists(select * from dbo.Product t where t.ProductName = l.ProductName)
	and try_cast(ListPrice as decimal(20,2)) is not null
	and try_cast(StandardCost as decimal(20,2)) is not null


	--DELETE
	delete from p
	--select *
	from dbo.Product p
	where not exists(select * from #load l where l.ProductName = p.ProductName)
	and @DeleteMissing = 1

	commit transaction
	return 0
end try
begin catch
	if @@TRANCOUNT > 0 rollback;
	throw;
	return 1
end catch
go

exec dbo.uspUpdateProducts @DeleteMissing = 1

go

USE [MyDB]
GO
/****** Object:  StoredProcedure [dbo].[uspNewCustomer]    Script Date: 2025. 01. 16. 15:23:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
�j elj�r�s: uspNewCustomer
Param�terek: Title,FirstName,LastName, CountryCode, CountryName,CountryIso3Code
�j Customer l�trehoz�sa, �j orsz�g felv�tele, ha kell
*/

ALTER   procedure [dbo].[uspNewCustomer](

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
		--print 'Nem megfelel� orsz�g k�dok'
		raiserror('Nem megfelel� orsz�g k�dok (CountryCode: %s, CountryName: %s, CountryIso3Code: %s)',16,0,@CountryCode,@CountryName,@CountryIso3Code)
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

exec dbo.uspNewCustomer --ez hib�ra fut
	@Title = null,
	@FirstName  = 'John',
	@LastName  = 'Connor',
	@CountryCode  = 'A',
	@CountryName  = 'United States',
	@CountryIso3Code  = 'USA'

exec dbo.uspNewCustomer --ez lefut (nem l�tez� orsz�g)
	@Title = null,
	@FirstName  = 'John',
	@LastName  = 'Connor',
	@CountryCode  = 'AA',
	@CountryName  = 'Arnia',
	@CountryIso3Code  = 'AA'

