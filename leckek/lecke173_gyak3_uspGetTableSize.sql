use MyDB
go

create or alter procedure uspGetTableSize
as
--tábla változó
declare @result table(
	object_id int,
	schema_name sysname,
	table_name sysname,
	rows int,
	size_KB int
)


declare @tables cursor
declare @object_id int, @schema_name sysname, @table_name sysname
declare @sql nvarchar(max)
declare @row_count int
declare @table_size int

set @tables = cursor static for
	select t.object_id, s.name as schema_name, t.name as table_name
	from sys.tables t
	join sys.schemas s on s.schema_id = t.schema_id

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

--meghívás
exec uspGetTableSize



-- tábla által foglalt terület lekérdezése
select sum(au.total_pages) * 8  --KB-ban
from sys.allocation_units au
inner join sys.partitions p on p.partition_id = au.container_id
where p.object_id = object_id('dbo.Product')

--tábla sorainak száma
select count(*) from dbo.Product