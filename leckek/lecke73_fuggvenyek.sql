-- skalár függvény futtatása pl.
select [dbo].[ufnGetStock](846) --mennyi van raktáron?...

select [dbo].[ufnGetStock](ProductID) as InStock, * from Production.Product --minden sorra

select [dbo].[ufnGetAccountingEndDate]()

-- tábla függvény hívás


select * from [dbo].[ufnGetContactInformation](1)

select top 1 *
from Person.Person
cross apply [dbo].[ufnGetContactInformation](Person.Person.BusinessEntityID)

select top 1 f.*
from Person.Person
cross apply [dbo].[ufnGetContactInformation](Person.Person.BusinessEntityID) as f

select f.*
from Person.Person
cross apply [dbo].[ufnGetContactInformation](Person.Person.BusinessEntityID) as f

--függvény létrehozás
--inline tábla függvény
create function [dbo].[ufnOrderStat](@Year int)
returns table
as
return(
	select year(OrderDate) as Year, month(OrderDate) as Month, count(*) as OrderCount,sum(SubTotal) as Total
	from Sales.SalesOrderHeader
	where year(OrderDate) = @Year
	group by year(OrderDate), month(OrderDate)
)
GO

--futtatás paraméterrel
select * from dbo.ufnOrderStat(2012)