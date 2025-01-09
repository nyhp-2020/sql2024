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


-- ld. ufnGetContactInformation tábla függvényt az AdventureWorks2019 adatbázisban
-- ld.CalculateCustomerPrice skalár függvényt a WideWorldImporters adatbázisban

declare @var int --= 10
if @var < 10 print 'OK' --ha a @var null, a @var < 10 feltétel hamis (vagyis ellenõrzi, hogy a @var null -e)
if @var is not null and @var < 10 print 'OK' -- tehát ez felesleges

--

DROP TABLE IF EXISTS AB

--régebben
IF OBJECT_ID('AB') IS NOT NULL
	DROP TABLE AB