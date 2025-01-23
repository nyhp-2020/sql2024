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
	raiserror('Nem áll rendelkezésre ekkora mennyiség (%d)',12,0, @Qty)
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
	@DeleteMissing bit = 0, --alapértelmezett érték "nem"
	@RowsLoaded int = null output  --kifelé történõ értékadáshoz
)
as

--use MyDB --ez nem megengedett az eljárásban
-- ideiglenes tábla létrehozása
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

--ld. lecke 95 (adatbetöltés csv-bõl)
bulk insert #load
from 'C:\temp\data.csv' --az SQL szervernek hozzá kell férni a file-hoz! (Ez általában nem így van.)
with (
	firstrow = 2,
	fieldterminator = '\t'
)

--rendszerváltozó
-- select @@rowcount as [row_count]-- az utolsó sql utasítás által érintett sorok száma

set @RowsLoaded = @@rowcount --változó értékének beállítása

--select * from #load
set xact_abort on

begin try

	begin transaction

	--UPDATE
	update p
	set p.ListPrice = l.ListPrice -- ListPrice frissítés
	--select ProductName,try_cast(ListPrice as decimal(20,2)),ProductNumber,try_cast(StandardCost as decimal(20,2)), getdate()
	from #load l
	inner join dbo.Product p on p.ProductName = l.ProductName
	where exists(select * from dbo.Product t where t.ProductName = l.ProductName)
	and try_cast(l.ListPrice as decimal(20,2)) is not null
	and try_cast(l.StandardCost as decimal(20,2)) is not null


	--INSERT
	-- másolat készítés ideiglenes táblába
	/*
	select top 0 * into #product from dbo.Product

	-- kijelölés, ctrl+4 ?
	-- temp táblára lefutott
	insert into #Product(ProductName,ListPrice,ProductNumber,StandardCost,CreatedDate)
	select ProductName,try_cast(ListPrice as decimal(20,2)),ProductNumber,try_cast(StandardCost as decimal(20,2)), getdate()
	from #load l
	where not exists(select * from #Product t where t.ProductName = l.ProductName)
	and try_cast(ListPrice as decimal(20,2)) is not null
	and try_cast(StandardCost as decimal(20,2)) is not null
	*/
	-- átírom valós táblára
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
Új eljárás: uspNewCustomer
Paraméterek: Title,FirstName,LastName, CountryCode, CountryName,CountryIso3Code
új Customer létrehozása, új ország felvétele, ha kell
*/

ALTER   procedure [dbo].[uspNewCustomer](

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
		--print 'Nem megfelelõ ország kódok'
		raiserror('Nem megfelelõ ország kódok (CountryCode: %s, CountryName: %s, CountryIso3Code: %s)',16,0,@CountryCode,@CountryName,@CountryIso3Code)
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

exec dbo.uspNewCustomer --ez hibára fut
	@Title = null,
	@FirstName  = 'John',
	@LastName  = 'Connor',
	@CountryCode  = 'A',
	@CountryName  = 'United States',
	@CountryIso3Code  = 'USA'

exec dbo.uspNewCustomer --ez lefut (nem létezõ ország)
	@Title = null,
	@FirstName  = 'John',
	@LastName  = 'Connor',
	@CountryCode  = 'AA',
	@CountryName  = 'Arnia',
	@CountryIso3Code  = 'AA'

