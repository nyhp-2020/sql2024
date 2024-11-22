declare @Year int = 2011
declare @SQL nvarchar(max)


set @SQL ='
select *
from Customer c 
inner join Orders o on o.CustomerID = c.CustomerID
where year(o.Orderdate) =' +  cast(@Year as nvarchar(4))

print @SQL

exec(@SQL)


-- dinamikus sql nélkül

declare @RowHeader nvarchar(max) = 'Country'
declare @ColumnsHeader nvarchar(255) = 'Color'
declare @AggFunction nvarchar(100) = 'COUNT'
declare @AggColumn nvarchar(255) = 'LineTotal'

declare @Year int = 2014
declare @SQL nvarchar(max)




set @SQL = '
select c.Country, p.Color, od.LineTotal
from Customer c 
inner join Orders o on o.CustomerID = c.CustomerID
inner join OrderDetail od on od.OrderID = o.OrderID
inner join Product p on od.ProductID = p.ProductID
where year(o.Orderdate) = @Y
and c.Country is not NULL
and p.Color is not null
'

declare @ColumnsSQL nvarchar(max)
declare @Columns nvarchar(max)
declare @ColumnsTable table(ColumnName nvarchar(255))

set @ColumnsSQL = '
SELECT DISTINCT '+ @ColumnsHeader +'
FROM (
' +@SQL+ '
) s
'

print @ColumnsSQL

insert into @ColumnsTable(ColumnName) -- a következő lekérdezés adatait betölti a táblaváltozóba (egyoszlopos eredménytábla)
--exec(@ColumnsSQL)
exec sp_executesql @ColumnsSQL, N'@Y int', @Y = @Year

select @Columns = isnull(@Columns + ',','') + ColumnName from @ColumnsTable order by ColumnName --vesszővel elválasztott színlista
print @Columns

set @SQL = '
SELECT '+ @RowHeader +',' + @Columns +'
FROM (
'+ @SQL +'    
) s
PIVOT ('+@AggFunction+'('+ @AggColumn +') FOR '+ @ColumnsHeader + ' IN ('+ @Columns+')) p
ORDER BY '+ @RowHeader

print @SQL
--exec(@SQL)
exec sp_executesql @SQL, N'@Y int', @Y = @Year

--
--set @SQL = '
--SELECT Country, ' + @Columns +'
--FROM (
--'+ @SQL +'    
--) s
--PIVOT (SUM(LineTotal) FOR Color IN ('+ @Columns+')) p
--ORDER BY Country'