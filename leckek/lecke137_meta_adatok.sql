--Adatbázis szintû metaadatok (fontos a contextus)

--összes objektum az adatbázisban
select * from sys.objects

--összes séma
select * from sys.schemas
--szabványos
select * from INFORMATION_SCHEMA.SCHEMATA

--összes tábla
select * from sys.tables

--táblák
select * from INFORMATION_SCHEMA.TABLES

-- idegen kulcsok
select * from sys.foreign_keys

select * from sys.objects
where object_id = 1925581898

-- pl. idegen kulcs kapcsolatok lekérdezése
select fk.name,pt.name,rt.name
from sys.foreign_keys fk
inner join sys.tables pt on pt.object_id = fk.parent_object_id
inner join sys.tables rt on rt.object_id = fk.referenced_object_id

--minden tábla,view minden oszlopa
select * from sys.columns

--adott táblában
select * from sys.columns
where object_id = 1925581898

--összes sql kód, ami szerver oldalon le van tárolva
select * from sys.sql_modules
--adatbázis minõsítés a lekérdezésben
select * from MyDB.sys.sql_modules
select * from [AdventureWorks2019].sys.sql_modules


--felhasználók
select * from sys.database_principals

--típusok
select * from sys.types

--szerver szintû meta adatok

--adatbázisok (amikhez jogom van)
select * from sys.databases

--loginok
select * from sys.server_principals

-- ld. Security->Logins
select * from sys.server_principals where type_desc in ('SQL_LOGIN','WINDOWS_LOGIN') order by name

--folyamatok,session-ok az sql server-ben
select * from sys.sysprocesses

--metaadat függvények
select object_schema_name(object_id),object_name(object_id),*  --séma,object_name meghatározás
from sys.columns
where object_id = object_id('dbo.Customer') --object_id meghatározás

--kontextusban lévõ AB id-je,neve
select db_id(),db_name()

--vagy paraméterezve
select db_id('MyDB'),db_name(7)