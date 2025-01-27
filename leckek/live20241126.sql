
--+ case when @OsszesOrszag = 1 then 'left' else 'inner' end +  -- itt t�bbir�ny� el�gaz�s is lehet
+ iif(@OsszesOrszag = 1,'left','inner') +  -- itt csak k�tir�ny� el�gaz�s lehet

--Le lehet tiltani az olyan m�veleteket, ami t�bla �jragy�rt�ssal j�r
--Tools->Options >Designers > Table and Database Designers > 
-- Prevent saving changes that require table re-creation

--Table Designer -> Generate Change Script...

--Collation 1. Karakter k�dol�s 2.Karakter set 3 Illeszt�s min�s�ge
--AB-ra ->Properties ->Collation : Hungarian_CI_AS
-- CI Case insensitive (kis-, nagybet� �rz�ketlen)
if 'A' = 'a' print 'OK'
-- AS Accent sensitive (�kezetekre �rz�keny)
if 'A' = '�' print 'OK'
if 'A' = '�' collate Hungarian_CI_AI print 'OK' -- accent insensitive
if 'a' = '�' collate Hungarian_CS_AI print 'OK' -- case sensitive, accent insensitive

--Ezt is csak a t�bla �jra�p�t�s�vel lehet megv�ltoztatni

-- A szerver collationja olyan legyen, mint amilyet az adatb�zisok ig�nyelnek
--Properties > Server Collation (Hungarian_CI_AS)

if 'A' = 'a' collate SQL_Latin1_General_CP1_CI_AS print 'OK'

select N'�' -- unicode

--
drop table if exists #t1
create table #t1(
Name varchar(100) collate database_default -- a temp t�bla az aktu�lis adatb�zis collation-j�val j�n l�tre
)

select *
from Person.Person p
join #t1 t on t.Name = p.FirstName --collate Hungarian_CI_AS -- collation k�nyszer�t�s
-- ez egy fajta adatt�pus k�nyszer�t�s

--SQL Sever Management Studio 21 megjelent (64 bit-es)
--Visual Studio Shell-re �p�l (egy be�p�l� modul a Visual Studi�ban)
--M�g probl�m�s a haszn�lata
-- Dark m�d! nem kifinomult, nincs mindennek s�t�t t�m�ja
-- Consolas bet�t�pus az j� (nem az a gy�ri...)
--Nem lehet excelbe export�lni eredm�nyt
-- ld. Import/Export wizard
-- tabok helye v�laszthat�, minden ablak l�tszik

--Bejelentett�k az SQL Server 2025-�t (AI be�p�t�se, nem lek�rdez�s optimaliz�l�s :(, native json kezel�s, REST API endpoint-ok )
--a 2022-es ben k�zelebb hozt�k a felh�t (azure) az adatb�zishoz

