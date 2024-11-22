-- skal�r f�ggv�ny futtat�sa pl.
select [dbo].[ufnGetStock](846) --mennyi van rakt�ron?...

select [dbo].[ufnGetStock](ProductID) as InStock, * from Production.Product --minden sorra

select [dbo].[ufnGetAccountingEndDate]()

-- t�bla f�ggv�ny h�v�s


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

--f�ggv�ny l�trehoz�s
--inline t�bla f�ggv�ny
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

--futtat�s param�terrel
select * from dbo.ufnOrderStat(2012)