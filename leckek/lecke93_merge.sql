truncate table[dbo].[Inventory]
--truncate table[dbo].[Product]
delete from [dbo].[Product]

--F1 Web Help
merge into [dbo].[Product] cel
using(
	select *
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
) forras on forras.ProductNumber = cel.ProductNumber
when matched then
	update set
		cel.ProductName = forras.ProductName,
		cel.ListPrice = forras.ListPrice
when not matched by target then
	insert (ProductNumber,	ProductName,	ListPrice,	StandardCost,	SellStartDate)
	values(forras.ProductNumber,	forras.ProductName,	forras.ListPrice,	forras.StandardCost,	forras.SellStartDate)
when not matched by source then
	delete;

select * from dbo.Product

--kiegészítések, további feltételek (itt nem lehet where)
merge into [dbo].[Product] cel
using(
	select *
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
) forras on forras.ProductNumber = cel.ProductNumber
when matched and convert(decimal(10,4),forras.ListPrice) > 0 then
	update set
		cel.ProductName = forras.ProductName,
		cel.ListPrice = forras.ListPrice
when not matched by target then
	insert (ProductNumber,	ProductName,	ListPrice,	StandardCost,	SellStartDate)
	values(forras.ProductNumber,	forras.ProductName,	forras.ListPrice,	forras.StandardCost,	forras.SellStartDate)
when not matched by source then
	delete;