--AdventureRorks2019 adatbázis

select TerritoryID, row_number() over(order by ModifiedDate)
from Sales.Customer
order by TerritoryID

select TerritoryID, row_number() over(partition by TerritoryID order by ModifiedDate)
from Sales.Customer
order by TerritoryID


select 
	*,
	row_number() over(partition by TerritoryID order by ModifiedDate),
	count(CustomerID) over(partition by TerritoryID)
from Sales.Customer
order by TerritoryID


select *, count(BusinessEntityID) over(partition by FirstName)
from Person.Person
order by FirstName

-- nevek több mint egyszer
select *
from(
	select *, count(BusinessEntityID) over(partition by FirstName) as C
	from Person.Person
) s
where C > 1
order by FirstName


-- nevek amik nem ismétlõdnek
select *
from(
	select *, count(BusinessEntityID) over(partition by FirstName) as C
	from Person.Person
) s
where C = 1
order by FirstName