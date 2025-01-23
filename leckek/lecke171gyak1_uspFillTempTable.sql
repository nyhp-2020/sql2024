/*
drop table #persons
create table #persons(ID int)
*/
create or alter procedure uspFillTempTable(
		@query nvarchar(max),
		@temp_table sysname  --nvarchar(512)
)
as
/*
set @query = '
SELECT BusinessEntityID, FirstName, LastName FROM [AdventureWorks2019].Person.Person
'
set @temp_table = '#persons'
*/

declare @sql nvarchar(max)
declare @drop_columns nvarchar(max)
declare @columns table(
	column_id int,
	column_name sysname,
	system_type_id int,
	user_type_id int,
	max_length int,
	precision int,
	scale int,
	is_nullable bit
)

--select object_id('tempdb..#persons') --ha ez null-t ad vissza, akkor nincs ez a tábla

if object_id('tempdb..' + @temp_table) is null
	throw 50000, 'Temporary table does not exists!',0;

/* --ez igazi táblákra használható
if not exists (select * from tempdb.sys.tables where name = @temp_table)
	throw 50000, 'Temporary table does not exists!',0;
*/

set @drop_columns = ''
-- az itt összeállított sql törli az oszlopokat késõbb (miután hozzáadtunk újakat)
select @drop_columns += 'ALTER TABLE ' + @temp_table + ' DROP COLUMN ' + c.name + ';' + char(13) + char(10)
from tempdb.sys.columns c
join sys.types t on t.system_type_id = c.system_type_id and t.user_type_id = c.user_type_id
where c.object_id = object_id('tempdb..' + @temp_table)

--print @drop_columns

-- ellenõrizzük hogy jó-e a lekérdezés
set @sql = '
SELECT TOP 0 *
INTO #result
FROM (
' + @query + '
) as [@query];

select column_id,name,system_type_id, user_type_id, max_length,precision, scale, is_nullable
from tempdb.sys.columns
where object_id = object_id(''tempdb..#result'')
order by column_id'

--print @sql

insert into @columns --tábla változóba mentem az eredményt (meta adatok)
exec(@sql)

set @sql = ''
-- az itt összeállított sql adja hozzá az oszlopokat
select @sql += 'ALTER TABLE ' + @temp_table + ' ADD ' + column_name + ' ' + t.name
			+ case when t.name in ('char', 'nchar','varchar', 'nvarchar') then concat('(' , c.max_length , ')') else '' end
			+ case when t.name in ('decimal', 'numeric') then concat('(' , c.scale , ',',c.precision, ')') else '' end
			+ ';' + char(13) + char(10)
from @columns c
join sys.types t on t.system_type_id = c.system_type_id and t.user_type_id = c.user_type_id

--print @sql
exec(@sql)

exec(@drop_columns)

-- az itt összeállított lekérdezés tölti fel a táblát
/*
set @sql = '
INSERT INTO #persons
' + @query +''
*/
set @sql = '
INSERT INTO '+ @temp_table + '
' + @query +''

exec(@sql)
go

--teszt
drop table if exists #mytemptable
create table #mytemptable(id int)

exec uspFillTempTable
	@query = 'SELECT SalesOrderID,Status,CustomerID,SubTotal FROM [AdventureWorks2019].Sales.SalesOrderHeader',
	@temp_table = '#mytemptable'

select * from #mytemptable


-- egy felhasznált lekérdezés
/*
select name,system_type_id, user_type_id, max_length,precision, scale, is_nullable
from tempdb.sys.columns
where object_id = object_id('tempdb..#result')
*/