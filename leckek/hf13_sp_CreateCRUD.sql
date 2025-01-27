use master
go

create or alter procedure sp_CreateCRUD(
	@schema_name sysname,
	@table_name sysname,

	@create_procedures bit = 0 --run created procedures
)
as

drop table if exists #table_info

if not exists(
	select t.object_id, s.name as schema_name, t.name as table_name
	from sys.tables t
	join sys.schemas s on s.schema_id = t.schema_id
	where s.name = @schema_name and t.name = @table_name
)
	begin
		throw 50000, 'The specified table does not exist!',0;
		return
	end

select
c.name as
column_name,
t.name +
case when t.name in ('char','varchar','binary','varbinary') then concat('(', isnull(nullif(c.max_length,-1), 'max'),')') else '' end +
case when t.name in ('nchar','nvarchar') then concat('(',isnull(nullif(c.max_length/2, 0),'max'),')') else '' end +
case when t.name in ('decimal','numeric') then concat('(',c.precision,', ',c.scale,')') else '' end as data_type,
c.is_nullable,
c.is_identity,
c.is_computed,
case when exists(
select *
from sys.indexes i
join sys.index_columns ic on i.object_id = ic.object_id and ic.index_id = i.index_id
where i.object_id = c.object_id
and i.is_primary_key = 1
and ic.column_id = c.column_id
) then 1 else 0 end as is_primary_key
into #table_info
from sys.columns c
inner join sys.types t on t.system_type_id = c.system_type_id and t.user_type_id = c.user_type_id
where c.object_id = object_id(@schema_name + '.' + @table_name)

--select * from #table_info

declare @insert_parameters nvarchar(max),
		@insert_columns nvarchar(max),
		@insert_value_list nvarchar(max),
		@update_parameters nvarchar(max),
		@update_set_list nvarchar(max),
		@where_condition nvarchar(max),
		@delete_parameter nvarchar(max)

declare @column_name sysname,
		@data_type sysname,
		@is_nullable smallint,
		@is_identity smallint,
		@is_computed smallint,
		@is_primary_key smallint

declare @NL nvarchar(2) = char(13) + char(10) --new line

declare @columns cursor
set @columns = cursor static for
select * from #table_info
open @columns
fetch next from @columns into @column_name, @data_type, @is_nullable, @is_identity, @is_computed, @is_primary_key
while(@@fetch_status = 0)
begin
	if @is_primary_key = 1
		begin
			set @where_condition = @column_name + ' = @' + @column_name
			set @delete_parameter = isnull(@delete_parameter + ',','') + '@' + @column_name + ' ' + @data_type + @NL
		end
	if @is_identity <> 1 and @is_computed <> 1 and @is_primary_key <> 1
		begin
			set @insert_parameters = isnull(@insert_parameters + ',','') + '@' + @column_name + ' ' + @data_type + @NL
			set @insert_columns = isnull(@insert_columns + ',','') + @column_name
			set @insert_value_list = isnull(@insert_value_list + ',','') + '@' + @column_name
			set @update_set_list = isnull(@update_set_list + ',','') + @column_name + ' = ' + '@' + @column_name + @NL
		end
	set @update_parameters = isnull(@update_parameters + ',','') + '@' + @column_name + ' ' + @data_type + @NL

	fetch next from @columns into @column_name, @data_type, @is_nullable, @is_identity, @is_computed, @is_primary_key
end
close @columns

declare @create nvarchar(30) = 'CREATE OR ALTER PROCEDURE '

declare @insert nvarchar(100) = @NL + 
								'AS' + @NL + 
								'SET NOCOUNT ON;'+ @NL +@NL+
								'INSERT INTO ' + @schema_name + '.' + @table_name

declare @values nvarchar(30) = @NL + 
							   'VALUES'

declare @update nvarchar(100) = @NL + 
								'AS' + @NL +
								'SET NOCOUNT ON;'+ @NL +@NL+
								'UPDATE ' + @schema_name + '.' + @table_name + @NL +
								'SET '

declare @delete nvarchar(100) = @NL +
								'AS' + @NL +
								'SET NOCOUNT ON;'+ @NL +@NL+
								'DELETE FROM ' + @schema_name + '.' + @table_name + @NL

declare @where nvarchar(30) = 'WHERE '

declare @insert_proc_name sysname = @schema_name +'.usp_'+ @table_name + '_Insert'
declare @update_proc_name sysname = @schema_name +'.usp_'+ @table_name + '_Update'
declare @delete_proc_name sysname = @schema_name +'.usp_'+ @table_name + '_Delete'


declare  @insert_proc nvarchar(max) = '',
		 @update_proc nvarchar(max) = '',
		 @delete_proc nvarchar(max) = ''


set @insert_proc += 
	@create + 
	@insert_proc_name + '(' + @NL + 
	@insert_parameters + ')'+
	@insert + '(' +
	@insert_columns + ')' +
	@values + '('+
	@insert_value_list + ')' + @NL + @NL

set @update_proc +=
	@create +
	@update_proc_name + '(' + @NL +
	@update_parameters + ')'+
	@update +
	@update_set_list +
	@where + @where_condition + @NL + @NL

set	@delete_proc +=
	@create +
	@delete_proc_name + '(' + @NL +
	@delete_parameter + ')'+
	@delete +
	@where + @where_condition + @NL + @NL

print @insert_proc + 'GO' + @NL + @NL
print @update_proc + 'GO' + @NL + @NL
print @delete_proc + 'GO' + @NL + @NL

-- ez valószínûleg nem mûködik..., ahogy tapasztaltam
if @create_procedures = 1
begin
	--exec sp_executesql @insert_proc
	exec(@insert_proc)
	exec(@update_proc)
	exec(@delete_proc)
end
go

exec sys.sp_MS_marksystemobject 'sp_CreateCRUD'
go

--Teszt
use MyDB
go
sp_CreateCRUD 'dbo', 'Product'

exec sp_CreateCRUD 'dbo', 'Inventory'

exec sp_CreateCRUD @schema_name = 'dbo', @table_name = 'Product'

exec sp_CreateCRUD @schema_name = 'dbo', @table_name = 'Inventory'

exec sp_CreateCRUD @schema_name = 'dbo', @table_name = 'Inventory', @create_procedures = 1

exec sp_CreateCRUD @schema_name = 'dbo', @table_name = 'Product', @create_procedures = 1
