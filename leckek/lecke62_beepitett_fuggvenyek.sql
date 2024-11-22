--AdventureRorks2019 adatbázis

--SO eltávolítása, számmá alakítás
select SalesOrderNumber, cast(replace(SalesOrderNumber, 'SO','') as int)
from Sales.SalesOrderHeader

--datetime date-re alakítása
select 
	SalesOrderNumber, 
	cast(replace(SalesOrderNumber, 'SO','') as int),
	cast(ModifiedDate as date)
from Sales.SalesOrderHeader


select 
	SalesOrderNumber,
	right('0000000000' + cast(SalesOrderID as varchar(10)),10 ), --balra hozzátold 10 0-át, vesz 10-et jobbról
	cast(replace(SalesOrderNumber, 'SO','') as int),
	cast(ModifiedDate as date)
from Sales.SalesOrderHeader


select 
	SalesOrderDetailID,
	right('0000000000' + cast(SalesOrderDetailID as varchar(10)),10 ), --balra hozzátold 10 0-át, vesz 10-et jobbról
	right(replicate('0',10) + cast(SalesOrderDetailID as varchar(10)),10 )
from Sales.SalesOrderDetail 


select 
	SalesOrderNumber,
	right('0000000000' + cast(SalesOrderID as varchar(10)),10 ), --balra hozzátold 10 0-át, vesz 10-et jobbról
	cast(replace(SalesOrderNumber, 'SO','') as int),
	cast(ModifiedDate as date),
	OrderDate,
	format(Orderdate,'yyyy.MM.dd.'), -- dátum formázás
	format(SubTotal,'C0','hu-hu'), -- pénznem megjelenítés
	format(SubTotal,'C2')
from Sales.SalesOrderHeader

--string_split
select * from string_split('A,B,C', ',') --táblát ad vissza

select value from string_split('A,B,C', ',')

select SalesOrderID,AccountNumber, s.value
from Sales.SalesOrderHeader oh
cross apply string_split(oh.AccountNumber, '-') s


select SalesOrderID,AccountNumber, s.value, s.rn
from Sales.SalesOrderHeader oh
cross apply(
	select value, row_number() over(order by (select null)) as rn --ál rendezés
	from string_split(oh.AccountNumber, '-')
) s
where s.rn = 2

--
select
	BusinessEntityID,
	EmailAddress,
	charindex('@', EmailAddress),
	left(EmailAddress,charindex('@', EmailAddress) -1) as username,
	len(EmailAddress),
	len(EmailAddress) - charindex('@', EmailAddress),
	right(EmailAddress,len(EmailAddress) - charindex('@', EmailAddress)),
	reverse(EmailAddress),
	charindex('.', reverse(EmailAddress)),
	right(EmailAddress,charindex('.', reverse(EmailAddress)) -1)
from Person.EmailAddress

--dátum kezelõ függvények
select SalesOrderID, OrderDate, ShipDate, datediff(day,OrderDate,ShipDate)
from Sales.SalesOrderHeader


select SalesOrderID, OrderDate, ShipDate, datediff(hour,OrderDate,ShipDate)
from Sales.SalesOrderHeader

select SalesOrderID, OrderDate, ShipDate, datediff(hour,OrderDate,ShipDate),dateadd(hour,3,OrderDate)
from Sales.SalesOrderHeader

--F1 Online help

select choose(1, 'A','B','C')

--meta adatok

select object_id('Sales.Customer') --ez egy tábla
