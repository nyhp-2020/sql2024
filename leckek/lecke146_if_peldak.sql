select @@Version,serverproperty('ProductMajorVersion')

IF serverproperty('ProductMajorVersion') > 13
CREATE TABLE dbo.AuditLog(
	Id int not null identity( 1, 1),
	UserId int not null,
	EventInfo nvarchar(max),
	INDEX CCI_AuditLog CLUSTERED COLUMNSTORE
)
ELSE
CREATE TABLE dbo.AuditLog(
	Id int not null identity( 1, 1),
	UserId int not null,
	EventInfo nvarchar(max)
)


-- ld. ufnGetContactInformation t�bla f�ggv�nyt az AdventureWorks2019 adatb�zisban
-- ld.CalculateCustomerPrice skal�r f�ggv�nyt a WideWorldImporters adatb�zisban

declare @var int --= 10
if @var < 10 print 'OK' --ha a @var null, a @var < 10 felt�tel hamis (vagyis ellen�rzi, hogy a @var null -e)
if @var is not null and @var < 10 print 'OK' -- teh�t ez felesleges

--

DROP TABLE IF EXISTS AB

--r�gebben
IF OBJECT_ID('AB') IS NOT NULL
	DROP TABLE AB