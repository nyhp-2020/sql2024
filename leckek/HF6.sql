select
	c.CustomerID,
	p.Title,
	p.FirstName,
	p.LastName,
	cr.CountryRegionCode as CountryCode,
	cr.Name as CountryName
from Sales.Customer c
inner join Person.Person p on p.BusinessEntityID = c.CustomerID
inner join Sales.SalesTerritory st on st.TerritoryID = c.TerritoryID
inner join Person.CountryRegion cr on cr.CountryRegionCode = st.CountryRegionCode