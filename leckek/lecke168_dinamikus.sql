use [AdventureWorks2019]
go

select ProductID, [2011],[2012]
from (
select od.ProductID, year(oh.OrderDate) as Year, od.LineTotal
from Sales.SalesOrderHeader oh
join Sales.SalesOrderDetail od on od.SalesOrderID = oh.SalesOrderID
--where year(oh.OrderDate) in (2011,2012)
) s
pivot(sum(LineTotal) for Year in ([2011],[2012]) ) p -- ezek itt oszlop címkék
go

-- dinamikus lekérdezés (pivot) összeállítás, futtatás
declare @values table(value nvarchar(100))
declare @query nvarchar(max)
declare @sql nvarchar(max) = '
select od.ProductID, year(oh.OrderDate) as Year, od.LineTotal
from Sales.SalesOrderHeader oh
join Sales.SalesOrderDetail od on od.SalesOrderID = oh.SalesOrderID
'
+ 'where oh.OrderDate < ''2010-01-01''' --szövegen belüli aposztrof: dupla aposztrof

set @query = '
SELECT DISTINCT Year
FROM (
' + @sql +'
) s
ORDER BY 1'

--print @query
insert into @values(value) --tábla változóba mentem az évszámokat
exec(@query)

if @@rowcount = 0 throw 50000, 'Nincs eredmény', 0

set @query = null

select @query = isnull(@query + ',','') + + '['+ value + ']' from @values

--print @query

--select * from @values

set @query = '
SELECT ProductID, '+ @query + '
FROM ('
+ @sql +
'
) s
PIVOT(SUM(LineTotal) FOR Year IN ('+ @query +')) p
'

--print @query

exec(@query)