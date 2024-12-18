--Adatb�zis szint� metaadatok (fontos a contextus)

--�sszes objektum az adatb�zisban
select * from sys.objects

--�sszes s�ma
select * from sys.schemas
--szabv�nyos
select * from INFORMATION_SCHEMA.SCHEMATA

--�sszes t�bla
select * from sys.tables

--t�bl�k
select * from INFORMATION_SCHEMA.TABLES

-- idegen kulcsok
select * from sys.foreign_keys

select * from sys.objects
where object_id = 1925581898

-- pl. idegen kulcs kapcsolatok lek�rdez�se
select fk.name,pt.name,rt.name
from sys.foreign_keys fk
inner join sys.tables pt on pt.object_id = fk.parent_object_id
inner join sys.tables rt on rt.object_id = fk.referenced_object_id

--minden t�bla,view minden oszlopa
select * from sys.columns

--adott t�bl�ban
select * from sys.columns
where object_id = 1925581898

--�sszes sql k�d, ami szerver oldalon le van t�rolva
select * from sys.sql_modules
--adatb�zis min�s�t�s a lek�rdez�sben
select * from MyDB.sys.sql_modules
select * from [AdventureWorks2019].sys.sql_modules


--felhaszn�l�k
select * from sys.database_principals

--t�pusok
select * from sys.types

--szerver szint� meta adatok

--adatb�zisok (amikhez jogom van)
select * from sys.databases

--loginok
select * from sys.server_principals

-- ld. Security->Logins
select * from sys.server_principals where type_desc in ('SQL_LOGIN','WINDOWS_LOGIN') order by name

--folyamatok,session-ok az sql server-ben
select * from sys.sysprocesses

--metaadat f�ggv�nyek
select object_schema_name(object_id),object_name(object_id),*  --s�ma,object_name meghat�roz�s
from sys.columns
where object_id = object_id('dbo.Customer') --object_id meghat�roz�s

--kontextusban l�v� AB id-je,neve
select db_id(),db_name()

--vagy param�terezve
select db_id('MyDB'),db_name(7)