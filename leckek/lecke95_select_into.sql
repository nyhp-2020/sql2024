-- select into; ideiglenes v. rendes táblák léátrehozása
select *
into #data --dbo.data helyett ideiglenes tábla
from (
values
('RD-2308', 'Rear Derailleur','121.46', '53.9282',					'2013-05-30'),
('FR-T67U-50', 'LL Touring Frame - Blue, 50','333.42', '205.0',		'2014-05-30'),
('FR-M21B-44', 'LL Mountain Frame - Black, 44','249.79', '136.785',	'2013-05-30'),
('PD-M282', 'LL Mountain Pedal','40.49', '17.9776',					'2013-05-30'),
('CH-0234', 'Chain','20.24', '8.9866',								'2013-05-30'),
('BK-T44U-60', 'Touring-2000 Blue, 60','1214.85', '755.1508',		'2017-01-01'),
('BK-T79Y-46', 'Touring-1000 Yellow, 46','2384.07', '1481.9379',	'2017-01-01'),
('BK-T18U-54', 'Touring-3000 Blue, 54','742.35', '461.4448',		'2017-01-01'),
('BK-T18Y-44', 'Touring-3000 Yellow, 44','742.35', '461.4448',		'2017-01-01'),
('BK-T79U-46', 'Touring-1000 Blue, 46','2384.07', '1481.9379',		'2017-01-01'),
('BK-M444-38', 'Mountain-444, 38','900', '499.0', 				'2014-06-01'),    --javítva
('BK-M111-40', 'Mountain-111, 40','650', '300.0',					'2014-06-01'),--javítva
('BK-M38S-38', 'Mountain-400-W Silver, 38','769.49', '419.0',		'2013-05-30'),
('BK-M18S-40', 'Mountain-500 Silver, 40','564.99', '311.0',			'2013-05-30'),
('BK-M18B-40', 'Mountain-500 Black, 40','539.99', '211.0', 			'2013-05-30'),
('BK-R19B-44', 'Road-750 Black, 44','539.99', '343.0',				'2013-05-30'),
('BK-R19B-48', 'Road-750 Black, 48','539.99', '343.0',				'2013-05-30')
) data(	ProductNumber,	ProductName,	ListPrice,	StandardCost,	SellStartDate)

-- itt az eredmény
select * from #data

drop table #data  --tábla törlés
--v. újra csatlakozom a szerverhez...

-- Product feltöltés
set identity_insert [dbo].[Product] on  --bekapcsol
insert into [dbo].[Product]([ProductID], [ProductName], [ListPrice], [Color], [Size], [ProductNumber], [StandardCost], [SellStartDate])
select ProductID, Name, ListPrice,Color,null, ProductNumber,StandardCost,SellStartDate
from AdventureWorks2019.Production.Product
where ListPrice > 0
set identity_insert [dbo].[Product] off  --kikapcsol


select * from dbo.Product

--UPDATE
update p
set p.ProductName = data.ProductName,
	p.ListPrice = data.ListPrice
--select *
from #data data
inner join dbo.Product p on p.ProductNumber = data.ProductNumber

--INSERT
insert into [dbo].[Product]([ProductName], [ListPrice], [ProductNumber], [StandardCost], [SellStartDate])
select ProductName,try_convert(decimal(10,4),ListPrice), ProductNumber, replace(StandardCost,',','.'), SellStartDate
from #data data
where not exists (select * from dbo.Product p where p.ProductNumber = data.ProductNumber)
and try_convert(decimal(10,4),ListPrice) is not null

--DELETE

delete from p
--select *
from dbo.Product p
where ProductNumber not in (
	select ProductNumber
	from #data data
)

select * from dbo.Product


-- igazi tábla létrehozása
select *
into data
from (
values
('RD-2308', 'Rear Derailleur','121.46', '53.9282',					'2013-05-30'),
('FR-T67U-50', 'LL Touring Frame - Blue, 50','333.42', '205.0',		'2014-05-30'),
('FR-M21B-44', 'LL Mountain Frame - Black, 44','249.79', '136.785',	'2013-05-30'),
('PD-M282', 'LL Mountain Pedal','40.49', '17.9776',					'2013-05-30'),
('CH-0234', 'Chain','20.24', '8.9866',								'2013-05-30'),
('BK-T44U-60', 'Touring-2000 Blue, 60','1214.85', '755.1508',		'2017-01-01'),
('BK-T79Y-46', 'Touring-1000 Yellow, 46','2384.07', '1481.9379',	'2017-01-01'),
('BK-T18U-54', 'Touring-3000 Blue, 54','742.35', '461.4448',		'2017-01-01'),
('BK-T18Y-44', 'Touring-3000 Yellow, 44','742.35', '461.4448',		'2017-01-01'),
('BK-T79U-46', 'Touring-1000 Blue, 46','2384.07', '1481.9379',		'2017-01-01'),
('BK-M444-38', 'Mountain-444, 38','900', '499.0', 				'2014-06-01'),    --javítva
('BK-M111-40', 'Mountain-111, 40','650', '300.0',					'2014-06-01'),--javítva
('BK-M38S-38', 'Mountain-400-W Silver, 38','769.49', '419.0',		'2013-05-30'),
('BK-M18S-40', 'Mountain-500 Silver, 40','564.99', '311.0',			'2013-05-30'),
('BK-M18B-40', 'Mountain-500 Black, 40','539.99', '211.0', 			'2013-05-30'),
('BK-R19B-44', 'Road-750 Black, 44','539.99', '343.0',				'2013-05-30'),
('BK-R19B-48', 'Road-750 Black, 48','539.99', '343.0',				'2013-05-30')
) data(	ProductNumber,	ProductName,	ListPrice,	StandardCost,	SellStartDate)

-- tábla törlés
drop table dbo.data

delete from dbo.Product --törlés


--BULK INSERT

use MyDB

select top 0 --csak létrehozza a táblát, nem tölt bele sort
	ProductName as Nr,
	ProductName as ProductNumber, -- A Product.ProductName mezõbõl vettük az adattípust
	ProductName as ProductName,
	ProductName as ListPrice,
	ProductName as StandardCost,
	ProductName as SellStartDate
into #Product
from dbo.Product

-- A #Product táblának léteznie kell!
select * from #Product

drop table #Product

bulk insert #Product
from 'C:\temp\data.csv' --az SQL szervernek hozzá kell férni a file-hoz! (Ez általában nem így van.)
with (
	firstrow = 2,
	fieldterminator = '\t'
)