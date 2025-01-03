create or alter procedure sp_SearchColumn
@ColumnNamePart nvarchar(100)
as

select
	c.name as column_name,
	o.name as object_name,
	o.type_desc as object_type,
	s.name as schema_name
from sys.columns c
inner join sys.objects o on o.object_id = c.object_id
inner join sys.schemas s on s.schema_id = o.schema_id
where c.name LIKE '%' + @ColumnNamePart + '%'
go

--rendszer elj�r�ss� tessz�k
use master
go
exec sys.sp_MS_marksystemobject 'sp_SearchColumn'

--pr�ba
use MyDB
go
sp_SearchColumn 'Product'

-- pr�ba
sp_SearchColumn 'state'

sp_SearchColumn 'guid'

--minden oszlop
select * from sys.columns

--pl
select name,*
from sys.columns
where name LIKE '%' + 'state' + '%'

--�sszes s�ma
select * from sys.schemas

--�sszes objektum az adatb�zisban
select * from sys.objects