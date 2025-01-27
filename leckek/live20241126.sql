
--+ case when @OsszesOrszag = 1 then 'left' else 'inner' end +  -- itt többirányú elágazás is lehet
+ iif(@OsszesOrszag = 1,'left','inner') +  -- itt csak kétirányú elágazás lehet

--Le lehet tiltani az olyan mûveleteket, ami tábla újragyártással jár
--Tools->Options >Designers > Table and Database Designers > 
-- Prevent saving changes that require table re-creation

--Table Designer -> Generate Change Script...

--Collation 1. Karakter kódolás 2.Karakter set 3 Illesztés minõsége
--AB-ra ->Properties ->Collation : Hungarian_CI_AS
-- CI Case insensitive (kis-, nagybetû érzéketlen)
if 'A' = 'a' print 'OK'
-- AS Accent sensitive (ékezetekre érzékeny)
if 'A' = 'á' print 'OK'
if 'A' = 'á' collate Hungarian_CI_AI print 'OK' -- accent insensitive
if 'a' = 'á' collate Hungarian_CS_AI print 'OK' -- case sensitive, accent insensitive

--Ezt is csak a tábla újraépítésével lehet megváltoztatni

-- A szerver collationja olyan legyen, mint amilyet az adatbázisok igényelnek
--Properties > Server Collation (Hungarian_CI_AS)

if 'A' = 'a' collate SQL_Latin1_General_CP1_CI_AS print 'OK'

select N'õ' -- unicode

--
drop table if exists #t1
create table #t1(
Name varchar(100) collate database_default -- a temp tábla az aktuális adatbázis collation-jával jön létre
)

select *
from Person.Person p
join #t1 t on t.Name = p.FirstName --collate Hungarian_CI_AS -- collation kényszerítés
-- ez egy fajta adattípus kényszerítés

--SQL Sever Management Studio 21 megjelent (64 bit-es)
--Visual Studio Shell-re épül (egy beépülõ modul a Visual Studióban)
--Még problémás a használata
-- Dark mód! nem kifinomult, nincs mindennek sötét témája
-- Consolas betûtípus az jó (nem az a gyári...)
--Nem lehet excelbe exportálni eredményt
-- ld. Import/Export wizard
-- tabok helye választható, minden ablak látszik

--Bejelentették az SQL Server 2025-öt (AI beépítése, nem lekérdezés optimalizálás :(, native json kezelés, REST API endpoint-ok )
--a 2022-es ben közelebb hozták a felhõt (azure) az adatbázishoz

