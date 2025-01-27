use master
go

create or alter procedure sp_Pivot(
		@Query nvarchar(max),
		@RowHeaders nvarchar(1000),
		@ColumnHeader nvarchar(1000),
		@Function nvarchar(10),
		@Field nvarchar(100)
)
as

declare @values table(value nvarchar(100))
declare @sql nvarchar(max)

if @Function not in ('count','sum','avg','min','max')
	throw 50001, 'Ismeretlen függvény !', 0;

set @sql = '
SELECT DISTINCT ' + @ColumnHeader + '
FROM (
' + @Query + '
) s
ORDER BY 1'

insert into @values(value)
exec(@sql)

if @@rowcount = 0 throw 50000, 'Nincs eredmény', 0;

set @sql = null
select @sql = isnull(@sql + ',', '') + '[' + value + ']' from @values

--csak azokat kérdezzük le, amire a pivotnak szüksége van (mindenre csoportosít a @RowHeaders-ben)
set @sql = '
SELECT ' + @RowHeaders + ', ' + @sql + '
FROM (
	SELECT ' + @RowHeaders + ', ' + @ColumnHeader + ', ' + @Field + '
	FROM (
	' + @Query + '
	) [@Query]
) s
PIVOT(' + @Function + '(' + @Field + ') FOR ' + @ColumnHeader + ' IN (' + @sql + ')) p
ORDER BY 1'

exec(@sql)
go

-- rendszer eljárássá teszem
exec sp_MS_marksystemobject 'sp_Pivot'
go

-- teszt
use[AdventureWorks2019]
--exec master..sp_Pivot
exec sp_Pivot
@Query = '
	select od.ProductID, month(oh.OrderDate) as Month, year(oh.OrderDate) as Year, od.LineTotal
    from Sales.SalesOrderHeader oh
    join Sales.SalesOrderDetail od on od.SalesOrderID = oh.SalesOrderID', 
@RowHeaders = 'ProductID, Month', 
@ColumnHeader = 'Year', 
@Function = 'SUM', 
@Field = 'LineTotal'

go
use MyDB
go

exec sp_Pivot
@Query = 'select * from Inventory', 
@RowHeaders = 'ProductID', 
@ColumnHeader = 'Shelf', 
@Function = 'COUNT', 
@Field = 'ID'

use MyDB
go

exec sp_Pivot
@Query = 'select * from Inventory', 
@RowHeaders = 'ProductID', 
@ColumnHeader = 'Shelf', 
@Function = 'SUM', 
@Field = 'ProductLeft'