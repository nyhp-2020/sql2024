--AdventureRorks2019 adatb�zis
--ld. ELSOHET_PPT.pdf

--elad�k list�ja (csak 17 sor)
SELECT  Sales.SalesPerson.BusinessEntityID, Person.Person.FirstName + ' ' + Person.Person.LastName as FullName
FROM [Sales].[SalesPerson]
inner join Person.Person on Person.Person.BusinessEntityID = Sales.SalesPerson.BusinessEntityID

--teljes elad�s
select oh.SalesPersonID, sum(oh.SubTotal) Total_2011
from Sales.SalesOrderHeader oh
where year(oh.OrderDate) = 2011
group by oh.SalesPersonID

-- HL Mountain Frame elad�sok
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

--inner joinnal (csak egyez� sorok)
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


--eg�sz lek�rdez�s
select
	s.*,
	isnull(TotalSales.Total_2011,0) as Total_2011,
	isnull(ProductSales.HL_2011, 0) as HL_2011,
	format(isnull(ProductSales.HL_2011 / TotalSales.Total_2011, 0), 'p2') as Ratio
from(
	SELECT  Sales.SalesPerson.BusinessEntityID, Person.Person.FirstName + ' ' + Person.Person.LastName as FullName --elad�k list�ja
	FROM [Sales].[SalesPerson]
	inner join Person.Person on Person.Person.BusinessEntityID = Sales.SalesPerson.BusinessEntityID
) s
left join (
	select oh.SalesPersonID, sum(oh.SubTotal) Total_2011 --teljes elad�s
	from Sales.SalesOrderHeader oh
	where year(oh.OrderDate) = 2011
	group by oh.SalesPersonID
) TotalSales on TotalSales.SalesPersonID = s.BusinessEntityID
left join (
	select oh.SalesPersonID, sum(od.LineTotal) as HL_2011  -- HL Mountain Frame elad�sok
	from Sales.SalesOrderHeader oh
	inner join Sales.SalesOrderDetail od on od.SalesOrderID = oh.SalesOrderID
	inner join Production.Product p on p.ProductID = od.ProductID
	where year(oh.OrderDate) = 2011 and p.Name like 'HL Mountain Frame%'
	group by oh.SalesPersonID
) ProductSales on ProductSales.SalesPersonID = s.BusinessEntityID