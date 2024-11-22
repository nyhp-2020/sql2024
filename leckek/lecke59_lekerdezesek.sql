--AdventureRorks2019 adatbázis
--ld. ELSOHET_PPT.pdf

--SalesOrderId,Year,ProductSubCategory,LineTotal

--CTE-hez SalesData
SELECT        oh.SalesOrderID, YEAR(oh.OrderDate) AS Year, pc.Name AS ProductSubCategory, od.LineTotal
FROM            Sales.SalesOrderHeader AS oh
INNER JOIN Sales.SalesOrderDetail AS od ON od.SalesOrderID = oh.SalesOrderID
INNER JOIN Production.Product AS p ON p.ProductID = od.ProductID
INNER JOIN Production.ProductSubcategory AS ps ON ps.ProductSubcategoryID = p.ProductSubcategoryID
INNER JOIN Production.ProductCategory AS pc ON pc.ProductCategoryID = ps.ProductCategoryID




with SalesData as( --CTE
	SELECT        oh.SalesOrderID, YEAR(oh.OrderDate) AS Year, pc.Name AS ProductSubCategory, od.LineTotal
	FROM            Sales.SalesOrderHeader AS oh
	INNER JOIN Sales.SalesOrderDetail AS od ON od.SalesOrderID = oh.SalesOrderID
	INNER JOIN Production.Product AS p ON p.ProductID = od.ProductID
	INNER JOIN Production.ProductSubcategory AS ps ON ps.ProductSubcategoryID = p.ProductSubcategoryID
	INNER JOIN Production.ProductCategory AS pc ON pc.ProductCategoryID = ps.ProductCategoryID
),
CurrentYear as(  --CTE
	select 2014 as Year --year(detdate()) as Year
),
YearData as ( --CTE
	select 'CurrentYear' as YearLabel, ProductSubCategory,LineTotal
	from SalesData
	where [Year] = (select Year from CurrentYear)

	union all

	select 'LastYear' as YearLabel, ProductSubCategory,LineTotal --* Csak azok kellenek, ami a pivotnak kell (mert belekerül a pivot group by -ba)
	from SalesData
	where [Year] = ((select Year from CurrentYear) -1)
)
select ProductSubCategory,[CurrentYear],[LastYear]
from YearData
pivot(sum(LineTotal) for YearLabel in ([CurrentYear],[LastYear])) p
order by ProductSubCategory

