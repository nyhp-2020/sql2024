
Use MyDB
go

--séma létrehozása
create schema test
go
--ld. MyDB->Security->Schemas

--nézet létrehozása az új sémában
create or alter view test.Product
as
select * from dbo.Product
where Status = 1
go

-- Új login létrehozása
--Security->Logins JobbEgér New Login
--szkriptelve
USE [master]
GO
CREATE LOGIN [test] WITH PASSWORD=N'123', DEFAULT_DATABASE=[MyDB], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

--User létrehozás
MyDB->Security->Users Jobbegér New User
--szkriptelve
USE [MyDB]
GO
CREATE USER [test] FOR LOGIN [test] WITH DEFAULT_SCHEMA=[test]
GO

--alapértelmezett séma beállítva a létrehozásnál

--jogosultságok beállítása
--MyDB->Security->Users->test jobbegér Properties Securables > Search gomb >
-- Add Objects >All objects of types... OK gomb > Select Object Types > Schemas kiválasztása >OK gomb
-- test séma kiválasztása felül, alul kiválasztva Grant alatt: Delete,Execute,Insert,Select,Update; OK gomb
--szkriptelve
use [MyDB]
GO
GRANT DELETE ON SCHEMA::[test] TO [test]
GO
use [MyDB]
GO
GRANT EXECUTE ON SCHEMA::[test] TO [test]
GO
use [MyDB]
GO
GRANT INSERT ON SCHEMA::[test] TO [test]
GO
use [MyDB]
GO
GRANT SELECT ON SCHEMA::[test] TO [test]
GO
use [MyDB]
GO
GRANT UPDATE ON SCHEMA::[test] TO [test]
GO

--Belépés
--Connect -> Database Engine
select * from Product

select * from test.Product --Ezt látja a test felhasználó, ez az alapértelmezett neki

select * from dbo.Product -- a test felhasználó ezt nem látja
