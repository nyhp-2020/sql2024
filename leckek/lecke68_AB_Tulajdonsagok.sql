--AB WideWorldImporters
--DB file-ok lekérdezése
select * from sys.database_files

select
	name,
	physical_name,
	type_desc,
	size * 8 as Kbyte,size * 8 /1024 as size_Mbyte,
	fileproperty(name,'SpaceUsed') *8 /1024 as used_MB
from sys.database_files