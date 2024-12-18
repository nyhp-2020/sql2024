
use MyDB
go

create or alter function dbo.GetStockInfo(@ProductID int)
returns table
as
return (
	select
		(
			select sum(ProductLeft)	--rakt�rom
			from dbo.Inventory i
			where ProductID = @ProductID
		) - isnull((
			select sum(OrderQuantity) --megrendelve
			from dbo.ProductOrders
			where ProductID = @ProductID
		),0) as AvailableQuantity,
		(
			select sum(ProductCount - ProductLeft) 
			from dbo.Inventory
			where ProductID = @ProductID
		) as SoldQuantity,
		(
			select sum(OrderQuantity) --megrendelve
			from dbo.ProductOrders
			where ProductID = @ProductID
		) as OrderQuantity
)
go

select * from dbo.GetStockInfo(1003)


create or alter function dbo.GetStockInfo2(@ProductID int = null) --alap�rtelmezett �rt�k
returns table
as
return ( -- inline, egyetlen select
	select p.ProductID,
	isnull(pl.ProductLeft,0) - isnull(po.OrderQuantity,0) as AvailableQuantity,
	isnull(pl.SoldQuantity,0) as SoldQuantity,
	isnull(po.OrderQuantity,0) as OrderQuantity
	from Product p
	left join ( --rakt�ron l�v� mennyis�g
		select ProductID, sum(ProductLeft) as ProductLeft, sum(ProductCount - ProductLeft) as SoldQuantity
		from Inventory
		group by ProductID
	) pl on pl.ProductID = p.ProductID
	left join( -- rendel�s alatt l�v� mennyis�g
		select ProductID,sum(OrderQuantity) as OrderQuantity
		from dbo.ProductOrders
		group by ProductID
	) po on po.ProductID = p.ProductID
	where p.ProductID = case when @ProductID is null then p.ProductID else @ProductID end
)
go

select * from dbo.GetStockInfo2(1003)

select * from dbo.GetStockInfo2(default) -- default �rt�kkel megh�vva az �sszeset visszaadja

select * from dbo.GetStockInfo2(null)

-- t�blak�nt is haszn�lhatom a t�blaf�ggv�nyeket
select si.*,p.ProductName
from dbo.GetStockInfo2(null) si
left join dbo.Product p on p.ProductID = si.ProductID

--ha egyik fv. a m�siknak bemenete, akkor apply-t haszn�lok