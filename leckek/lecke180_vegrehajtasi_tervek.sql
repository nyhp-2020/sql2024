
select top 10 * 
from Product
where ProductName like 'Road%'

select * from dbo.ProductsInStock

select *
from Product
outer apply(
	select *
	from Customer
	where FirstName = substring(FirstName, status + 1, 1)
) s

select top 10 *
from Product p
join Inventory i on i.ProductID = p.ProductID

/*
https://docs.microsoft.com/sql/relational-databases/performance/execution-plans

https://sqlserverfast.com/epr
*/