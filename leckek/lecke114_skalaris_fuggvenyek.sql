use MyDB
go

--függvény létrehozás
-- számított skaláris függvény
create function dbo.UserFunction1()
returns int
as
begin
	return 0
end

go

-- lekérdezésbõl származó skaláris érték
create function dbo.UserFunction2()
returns int
as
begin
	return (
		select count(*) from dbo.Product
	)
end

-- meghívás
select dbo.UserFunction1()

select dbo.UserFunction2() 

go

create function dbo.MonthStart()
returns date
as
begin
	return datefromparts(year(getdate()),month(getdate()),1)
end
go

create function dbo.MonthEnd()
returns date
as
begin
	return dateadd(day, -1,dateadd(month,1,datefromparts(year(getdate()),month(getdate()),1)))
end
go

select dbo.MonthStart(),dbo.MonthEnd() -- a sémanevet oda kell tenni

create or alter function dbo.GetNumOfProducts() -- létrehozás v. módosítás
returns int
as
begin
	return (
		select count(*) from dbo.Product
	)
end
go

select dbo.GetNumOfProducts() as NumOfProducts
go

use AdventureWorks2019
go

select distinct Style from Production.Product

create or alter function dbo.GetStyleName(@Style nchar(2))
returns nvarchar(10)
as
begin
	return case @Style when 'M' then 'Men'
					   when 'W' then 'Women'
					   when 'U' then 'Unisex'
		   end
end
go

select Style, dbo.GetStyleName(Style),* from Production.Product where Style is not null


use MyDB
go
select * from dbo.Inventory


-- az eladott mennyiség
create or alter function dbo.GetSoldQuantity(@p int)
returns int
as
begin
	return (
	select sum(ProductCount - ProductLeft) 
	from dbo.Inventory
	where ProductID = @p
	)
end
go

select dbo.GetSoldQuantity(1004)

select dbo.GetSoldQuantity(ProductID),* from dbo.Product

-- mennyi van raktáron figyelembevéve a rendeléseket is
create or alter function dbo.GetInStock(@p int)
returns int
as
begin
	return(
	select sum(ProductLeft)	--raktárom
	from dbo.Inventory i
	where ProductID = @p
	) - (
	select sum(OrderQuantity) --megrendelve
	from dbo.ProductOrders
	where ProductID = @p
	)
end
go

create or alter function dbo.GetInStock(@p int = NULL) -- alapértelmezett érték
returns int
as
begin
	return(
	select sum(ProductLeft)	--raktárom
	from dbo.Inventory i
	--where ProductID = case when @p is not null then @p else ProductID end
	where ProductID = isnull(@p,ProductID)
	--ha null akkor is igaz lesz a ProductID = ProductID, vagyis mintha ott sem lenne
	) - isnull((
	select sum(OrderQuantity) --megrendelve
	from dbo.ProductOrders
	where ProductID = case when @p is not null then @p else ProductID end
	),0)
end
go

select dbo.GetInStock(default) -- meghívás default értékkel
select dbo.GetInStock(null) -- vagy be is írhatjuk
select dbo.GetInStock() -- így nem lehet

select dbo.GetInStock(ProductID),dbo.GetSoldQuantity(ProductID),* from dbo.Product

-- ld. további skaláris fv. feladatok