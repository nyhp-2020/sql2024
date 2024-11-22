select c.CustomerID,p.Title, p.FirstName,p.LastName
from Sales.Customer c
inner join Person.Person p on p.BusinessEntityID = c.CustomerID
--inner join Person.BusinessEntityAddress pa on pa.BusinessEntityID = c.CustomerID
--inner join Person.Address a on a.AddressID = pa.AddressID
--inner join Sales.SalesTerritory st on st.TerritoryID = c.TerritoryID
--inner join Person.StateProvince sp on sp.StateProvinceID = st.