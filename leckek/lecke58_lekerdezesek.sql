--AdventureRorks2019 adatbázis
--ld. ELSOHET_PPT.pdf

--eladók listája (csak 17 sor)
SELECT  Sales.SalesPerson.BusinessEntityID, Person.Person.FirstName + ' ' + Person.Person.LastName as FullName
FROM [Sales].[SalesPerson]
inner join Person.Person on Person.Person.BusinessEntityID = Sales.SalesPerson.BusinessEntityID

--teljes eladás
select oh.SalesPersonID, sum(oh.SubTotal) Total_2011
from Sales.SalesOrderHeader oh
where year(oh.OrderDate) = 2011
group by oh.SalesPersonID

-- HL Mountain Frame eladások
select oh.SalesPersonID, sum(od.LineTotal) 
from Sales.SalesOrderHeader oh
inner join Sales.SalesOrderDetail od on od.SalesOrderID = oh.SalesOrderID
inner join Production.Product p on p.ProductID = od.ProductID
where year(oh.OrderDate) = 2011 and p.Name like 'HL Mountain Frame%'
group by oh.SalesPersonID

--left joinnal
select *
from(
	SELECT  Sales.SalesPerson.BusinessEntityID, Person.Person.FirstName + ' ' + Person.Person.LastName as FullName
	FROM [Sales].[SalesPerson]
	inner join Person.Person on Person.Person.BusinessEntityID = Sales.SalesPerson.BusinessEntityID
) s
left join (
	select oh.SalesPersonID, sum(oh.SubTotal) Total_2011
	from Sales.SalesOrderHeader oh
	where year(oh.OrderDate) = 2011
	group by oh.SalesPersonID
) TotalSales on TotalSales.SalesPersonID = s.BusinessEntityID

--inner joinnal (csak egyezõ sorok)
select *
from(
	SELECT  Sales.SalesPerson.BusinessEntityID, Person.Person.FirstName + ' ' + Person.Person.LastName as FullName
	FROM [Sales].[SalesPerson]
	inner join Person.Person on Person.Person.BusinessEntityID = Sales.SalesPerson.BusinessEntityID
) s
inner join (
	select oh.SalesPersonID, sum(oh.SubTotal) Total_2011
	from Sales.SalesOrderHeader oh
	where year(oh.OrderDate) = 2011
	group by oh.SalesPersonID
) TotalSales on TotalSales.SalesPersonID = s.BusinessEntityID


--egész lekérdezés
select
	s.*,
	isnull(TotalSales.Total_2011,0) as Total_2011,
	isnull(ProductSales.HL_2011, 0) as HL_2011,
	format(isnull(ProductSales.HL_2011 / TotalSales.Total_2011, 0), 'p2') as Ratio
from(
	SELECT  Sales.SalesPerson.BusinessEntityID, Person.Person.FirstName + ' ' + Person.Person.LastName as FullName --eladók listája
	FROM [Sales].[SalesPerson]
	inner join Person.Person on Person.Person.BusinessEntityID = Sales.SalesPerson.BusinessEntityID
) s
left join (
	select oh.SalesPersonID, sum(oh.SubTotal) Total_2011 --teljes eladás
	from Sales.SalesOrderHeader oh
	where year(oh.OrderDate) = 2011
	group by oh.SalesPersonID
) TotalSales on TotalSales.SalesPersonID = s.BusinessEntityID
left join (
	select oh.SalesPersonID, sum(od.LineTotal) as HL_2011  -- HL Mountain Frame eladások
	from Sales.SalesOrderHeader oh
	inner join Sales.SalesOrderDetail od on od.SalesOrderID = oh.SalesOrderID
	inner join Production.Product p on p.ProductID = od.ProductID
	where year(oh.OrderDate) = 2011 and p.Name like 'HL Mountain Frame%'
	group by oh.SalesPersonID
) ProductSales on ProductSales.SalesPersonID = s.BusinessEntityID