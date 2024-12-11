use MyDB
go

truncate table[dbo].[Inventory]
--truncate table[dbo].[Product]
delete from [dbo].[Product]

select * from dbo.Product

--csak 1 sor deszúrása
insert into [dbo].[Product](/*[ProductID],*/ [ProductName], [ListPrice], [Color], [Size], [ProductNumber], [StandardCost], [SellStartDate])
select top 1 /*ProductID,*/ Name, ListPrice,Color,null, ProductNumber,StandardCost,SellStartDate
from AdventureWorks2019.Production.Product
where ListPrice > 0

-- a legutoljára beszúrt identity értéket adja vissza, ha közvetlenül az insert után futtatjuk
select scope_identity()

select * from dbo.Product

delete from [dbo].[Product]

-- sok sor beszúrása
insert into [dbo].[Product](/*[ProductID],*/ [ProductName], [ListPrice], [Color], [Size], [ProductNumber], [StandardCost], [SellStartDate])
select /*ProductID,*/ Name, ListPrice,Color,null, ProductNumber,StandardCost,SellStartDate
from AdventureWorks2019.Production.Product
where ListPrice > 0

select scope_identity() -- csak a legutolsó beszúrás eredményét adja vissza

--output záradék hasonlít egy select-hez

--INSERT
-- több sor beszúrása
insert into [dbo].[Product](/*[ProductID],*/ [ProductName], [ListPrice], [Color], [Size], [ProductNumber], [StandardCost], [SellStartDate])
output inserted.*
select /*ProductID,*/ Name, ListPrice,Color,null, ProductNumber,StandardCost,SellStartDate
from AdventureWorks2019.Production.Product
where ListPrice > 0

insert into [dbo].[Product](/*[ProductID],*/ [ProductName], [ListPrice], [Color], [Size], [ProductNumber], [StandardCost], [SellStartDate])
output inserted.ProductID,inserted.ProductName --,deleted.ProductName ez itt nem létezik
select /*ProductID,*/ Name, ListPrice,Color,null, ProductNumber,StandardCost,SellStartDate
from AdventureWorks2019.Production.Product
where ListPrice > 0

-- az output kimenetét beleírom egy táblába
insert into [dbo].[Product](/*[ProductID],*/ [ProductName], [ListPrice], [Color], [Size], [ProductNumber], [StandardCost], [SellStartDate])
output inserted.ProductID into [dbo].[NewProducts](ProductID)  -- ID-k elmentése
select /*ProductID,*/ Name, ListPrice,Color,null, ProductNumber,StandardCost,SellStartDate
from AdventureWorks2019.Production.Product
where ListPrice > 0
-- Edit ->IntelliSense -> Refresh Local Cache (A query ablak így tudja meg, hogy új tábla van)
--UPDATE
update p
set p.ProductName = data.ProductName,
	p.ListPrice = data.ListPrice
output deleted.ProductName,inserted.ProductName,
	   deleted.ListPrice,inserted.ListPrice
--select *
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
('BK-M444-38', 'Mountain-444, 38','900,O', '499,0', 				'2014-06-01'),
('BK-M111-40', 'Mountain-111, 40','650,O', '300,0',					'2014-06-01'),
('BK-M38S-38', 'Mountain-400-W Silver, 38','769.49', '419.0',		'2013-05-30'),
('BK-M18S-40', 'Mountain-500 Silver, 40','564.99', '311.0',			'2013-05-30'),
('BK-M18B-40', 'Mountain-500 Black, 40','539.99', '211.0', 			'2013-05-30'),
('BK-R19B-44', 'Road-750 Black, 44','539.99', '343.0',				'2013-05-30'),
('BK-R19B-48', 'Road-750 Black, 48','111.11', '343.0',				'2013-05-30')
) data(	ProductNumber,	ProductName,	ListPrice,	StandardCost,	SellStartDate)
inner join dbo.Product p on p.ProductNumber = data.ProductNumber

--MERGE

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
	delete
output $action, inserted.ListPrice, deleted.ListPrice --virtuális oszlop a mûveletekrõl
;

--ID RESET
-- Inventory feltöltés
insert into dbo.Inventory
select 'AA',ProductID, 10,10
from dbo.Product
--where Color = 'Red'

select * from dbo.Inventory
--törlés; Az ID számláló nem reset-elõdik
delete from dbo.Inventory
-- ez visszaállítja az ID számlálót is alaphelyzetbe (ahonnan a definíció szerint kell indulnia: seed,increment)
truncate table dbo.Inventory

--truncate table[dbo].[Product] --ez nem lehet az idegen kulcsok miatt,amik rá mutatnak
delete from [dbo].[Product]
-- reset the current identity value
dbcc checkident ('dbo.Product',RESEED,1); -- a következõ érték az itt megadott után következik
-- ez akkor is megtehetõ, ha a tábla nem üres (a primary key és az identity által kiosztott számoknak nincs közük egymáshoz!)