use MyDB
go

--f�ggv�ny l�trehoz�s
-- sz�m�tott skal�ris f�ggv�ny
create function dbo.UserFunction1()
returns int
as
begin
	return 0
end

go

-- lek�rdez�sb�l sz�rmaz� skal�ris �rt�k
create function dbo.UserFunction2()
returns int
as
begin
	return (
		select count(*) from dbo.Product
	)
end

-- megh�v�s
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

select dbo.MonthStart(),dbo.MonthEnd() -- a s�manevet oda kell tenni

create or alter function dbo.GetNumOfProducts() -- l�trehoz�s v. m�dos�t�s
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


-- az eladott mennyis�g
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

-- mennyi van rakt�ron figyelembev�ve a rendel�seket is
create or alter function dbo.GetInStock(@p int)
returns int
as
begin
	return(
	select sum(ProductLeft)	--rakt�rom
	from dbo.Inventory i
	where ProductID = @p
	) - (
	select sum(OrderQuantity) --megrendelve
	from dbo.ProductOrders
	where ProductID = @p
	)
end
go

create or alter function dbo.GetInStock(@p int = NULL) -- alap�rtelmezett �rt�k
returns int
as
begin
	return(
	select sum(ProductLeft)	--rakt�rom
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

select dbo.GetInStock(default) -- megh�v�s default �rt�kkel
select dbo.GetInStock(null) -- vagy be is �rhatjuk
select dbo.GetInStock() -- �gy nem lehet

select dbo.GetInStock(ProductID),dbo.GetSoldQuantity(ProductID),* from dbo.Product

-- ld. tov�bbi skal�ris fv. feladatok