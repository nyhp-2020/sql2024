
Use MyDB
go

--s�ma l�trehoz�sa
create schema test
go
--ld. MyDB->Security->Schemas

--n�zet l�trehoz�sa az �j s�m�ban
create or alter view test.Product
as
select * from dbo.Product
where Status = 1
go

-- �j login l�trehoz�sa
--Security->Logins JobbEg�r New Login
--szkriptelve
USE [master]
GO
CREATE LOGIN [test] WITH PASSWORD=N'123', DEFAULT_DATABASE=[MyDB], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

--User l�trehoz�s
MyDB->Security->Users Jobbeg�r New User
--szkriptelve
USE [MyDB]
GO
CREATE USER [test] FOR LOGIN [test] WITH DEFAULT_SCHEMA=[test]
GO

--alap�rtelmezett s�ma be�ll�tva a l�trehoz�sn�l

--jogosults�gok be�ll�t�sa
--MyDB->Security->Users->test jobbeg�r Properties Securables > Search gomb >
-- Add Objects >All objects of types... OK gomb > Select Object Types > Schemas kiv�laszt�sa >OK gomb
-- test s�ma kiv�laszt�sa fel�l, alul kiv�lasztva Grant alatt: Delete,Execute,Insert,Select,Update; OK gomb
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

--Bel�p�s
--Connect -> Database Engine
select * from Product

select * from test.Product --Ezt l�tja a test felhaszn�l�, ez az alap�rtelmezett neki

select * from dbo.Product -- a test felhaszn�l� ezt nem l�tja
