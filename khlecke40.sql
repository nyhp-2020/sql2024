-- Írjunk egy olyan lekérdezést, amely egy változóban (@Year) megadott évből kérdezi le a vásárlók és vásárlásaik adatait
declare @Year int = 2012


select *
from Customer c 
inner join Orders o on o.CustomerID = c.CustomerID
where year(o.OrderDate) = @Year

-- dinamikus sql-el
declare @Year int = 2012
declare @SQL nvarchar(max)

set @SQL ='select *
from Customer c 
inner join Orders o on o.CustomerID = c.CustomerID
where year(o.OrderDate) = ' + cast(@Year as nvarchar(4))

print @SQL
exec(@SQL) --futtatás

-- A lekérdezés keresse meg az adott év összes eladásait és azok vásárlóit és jelenítsen meg belőle egy PIVOT lekérdezést
/* A PIVOT paraméterei
-Sor fejlécek: vásárló országa (kétbetűs kód), növekvőben rendezett
-Oszlop fejlécek: a termék színe (csak ahol van, balról jobbra növekvő sorrend)
-Összesítő függvény: összeg
-Összesített adat: LineTotal
*/
declare @RowHeaders nvarchar(max) = 'Country'
declare @ColumnsHeader nvarchar(255) = 'Color'
--declare @AggFunction nvarchar(100) = 'SUM'
declare @AggFunction nvarchar(100) = 'COUNT'
--declare @AggFunction nvarchar(100) = 'MAX'
--declare @AggColumn nvarchar(255) = 'LineTotal'
declare @AggColumn nvarchar(255) = 'ListPrice'

declare @Year int = 2014
declare @SQL nvarchar(max)
/*
declare @ColumnsSQL nvarchar(max)
declare @Columns nvarchar(max)
declare @ColumnsTable table(ColumnName nvarchar(255))
*/

-- pivot adatok összegyűjtése
/*
select c.Country,p.Color,od.LineTotal
from Customer c
inner join Orders o on c.CustomerID = o.CustomerID
inner join OrderDetail od on o.OrderID = od.OrderID
inner join Product p on od.ProductID = p.ProductID
where year(o.OrderDate) = @Year
and c.Country is not null
and p.Color is not null
*/
/*
--set @SQL ='select c.Country,p.Color,od.LineTotal
set @SQL ='select c.Country,p.Color,p.ListPrice
from Customer c
inner join Orders o on c.CustomerID = o.CustomerID
inner join OrderDetail od on o.OrderID = od.OrderID
inner join Product p on od.ProductID = p.ProductID
where year(o.OrderDate) = ' + cast(@Year as nvarchar(4)) +'
and c.Country is not null
and p.Color is not null'
*/

set @SQL ='select c.Country,p.Color,p.ListPrice
from Customer c
inner join Orders o on c.CustomerID = o.CustomerID
inner join OrderDetail od on o.OrderID = od.OrderID
inner join Product p on od.ProductID = p.ProductID
where year(o.OrderDate) = @Y
and c.Country is not null
and p.Color is not null'
/*
set @ColumnsSQL = '
SELECT DISTINCT Color
FROM (
' + @SQL +'
) s
'
*/

-------------------------------
declare @ColumnsSQL nvarchar(max)
declare @Columns nvarchar(max)
declare @ColumnsTable table(ColumnName nvarchar(255))

set @ColumnsSQL = '
SELECT DISTINCT ' +  @ColumnsHeader + '
FROM (
' + @SQL +'
) s
'

--print @SQL

insert into @ColumnsTable(ColumnName)
--exec(@ColumnsSQL)
exec sp_executesql @ColumnsSQL, N'@Y int', @Y = @Year --paraméter átadás

--select * from @ColumnsTable

-- vesszővel elválasztott értékek
select @Columns = isnull(@Columns + ',','') + ColumnName from @ColumnsTable order by ColumnName
print @Columns


/*
set @SQL ='
SELECT Country, '+ @Columns +'
FROM (
 ' +@SQL +'   
) s
PIVOT(SUM(LineTotal) FOR Color IN ('+ @Columns +')) p
ORDER BY Country
'
*/

set @SQL ='
SELECT '+ @RowHeaders + ', ' + @Columns +'
FROM (
 ' +@SQL +'   
) s
PIVOT(' + @AggFunction + '(' + @AggColumn + ') FOR '+  @ColumnsHeader + ' IN ('+ @Columns +')) p
ORDER BY '+ @RowHeaders

print @SQL

--exec(@SQL)
exec sp_executesql @SQL, N'@Y int', @Y = @Year --paraméter átadás

/* Ez van a dinamikus SQL-ben

SELECT Country, Black,Red,Silver,Yellow
FROM (
 select c.Country,p.Color,od.LineTotal
from Customer c
inner join Orders o on c.CustomerID = o.CustomerID
inner join OrderDetail od on o.OrderID = od.OrderID
inner join Product p on od.ProductID = p.ProductID
where year(o.OrderDate) = 2012
and c.Country is not null
and p.Color is not null   
) s
PIVOT(SUM(LineTotal) FOR Color IN (Black,Red,Silver,Yellow)) p
*/