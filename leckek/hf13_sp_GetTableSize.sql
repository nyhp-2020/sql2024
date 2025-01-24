use master
go

create or alter procedure sp_GetTableSize(
	@schema_name sysname = null,
	@table_name sysname = null
)
as

if @schema_name is not null and @schema_name not in (select s.name from sys.schemas s)
	begin
		throw 50000, 'The specified schema does not exist!',0;
		return
	end

--tábla változó
declare @result table(
	object_id int,
	schema_name sysname,
	table_name sysname,
	rows int,
	size_KB int
)

declare @part_result table(
	object_id int,
	schema_name sysname,
	table_name sysname
)

declare @tables cursor
declare @object_id int
declare @sql nvarchar(max)
declare @row_count int
declare @table_size int

declare @cursor_query nvarchar(max),
		@scncond nvarchar(max),
		@tbncond nvarchar(max)

select @scncond = case when @schema_name is null then '@schema_name is null' else 's.name = @schema_name' end
select @tbncond = case when @table_name is null then '@table_name is null' else 't.name = @table_name' end

set @cursor_query = '
	select t.object_id, s.name as schema_name, t.name as table_name
	from sys.tables t
	join sys.schemas s on s.schema_id = t.schema_id
	where '+ @scncond +' and '+ @tbncond

insert into @part_result
exec sp_executesql 
	@cursor_query, 
	N'@schema_name sysname, @table_name sysname', 
	@schema_name = @schema_name, 
	@table_name = @table_name

set @tables = cursor static for
select * from @part_result

open @tables
fetch next from @tables into @object_id, @schema_name, @table_name
while(@@fetch_status = 0)
begin
	set @sql = 'select @rows = count(*) from ' + @schema_name + '.' + @table_name
	exec sp_executesql @sql, N'@rows int output', @rows = @row_count output

	select @table_size = sum(au.total_pages) * 8  --KB-ban
	from sys.allocation_units au
	inner join sys.partitions p on p.partition_id = au.container_id
	where p.object_id = @object_id

	insert into @result(object_id,	schema_name, table_name, rows, size_KB)
	values(@object_id, @schema_name, @table_name, @row_count, @table_size)

	fetch next from @tables into @object_id, @schema_name, @table_name
end
close @tables

select * from @result
go

use master
go
exec sys.sp_MS_marksystemobject 'sp_GetTableSize'
go

-- teszt
sp_GetTableSize

sp_GetTableSize null, 'Currency'

sp_GetTableSize 'Sales', 'Currency'

sp_GetTableSize 'Sales'

exec sp_GetTableSize null, 'Orders'

exec sp_GetTableSize 'dbo', 'Orders'

exec sp_GetTableSize 'dbo'

exec sp_GetTableSize 'trwert'

go

---
declare @schema_name sysname = null,
		@table_name sysname = null

declare @scncond nvarchar(max),
		@tbncond nvarchar(max)

select @scncond = case when @schema_name is null then '@schema_name is null' else 's.name = @schema_name' end
select @tbncond = case when @table_name is null then '@table_name is null' else 't.name = @table_name' end
print @scncond
print @tbncond

-- minden tábla sémával
select t.object_id, s.name as schema_name, t.name as table_name
from sys.tables t
join sys.schemas s on s.schema_id = t.schema_id
where (@schema_name is null) and (@table_name is null)

-- minden séma táblával
select t.object_id, s.name as schema_name, t.name as table_name 
from sys.schemas s
join sys.tables t on s.schema_id = t.schema_id
--where (1 = 1) and (1 = 1)

--adott nevû séma
select t.object_id, s.name as schema_name, t.name as table_name 
from sys.schemas s
join sys.tables t on s.schema_id = t.schema_id
where s.name = 'Production' and (1 = 1)

-- adott nevû tábla
select t.object_id, s.name as schema_name, t.name as table_name
from sys.tables t
join sys.schemas s on s.schema_id = t.schema_id
where t.name = 'Product' and (1 = 1)
