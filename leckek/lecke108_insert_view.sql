
select * from dbo.ProductsWithColor order by ProductID desc

-- csak olyan oszlopokba szúrhatok be, amit a view visszaad
insert into dbo.ProductsWithColor([ProductName], [ListPrice], [Color],[ProductNumber])
values('New-Product 1', 6.00,'Red','NP-001')
-- törölni, módosítani is lehet a view segítségével
-- pl. jogosultságkezelés

--ez lefut
insert into dbo.ProductsWithColor([ProductName], [ListPrice], [Color],[ProductNumber])
values('New-Product 2', 7.00,null,'NP-002')
-- a view-ben van is not null szûrés a Color-ra,ahova null-t akarok beszúrni
-- A sor bekerül a Product-ba, de a view nem adja vissza

insert into dbo.ProductsWithColor([ProductName], [ListPrice], [Color],[ProductNumber])
values('New-Product 3', 7.00,'Black','NP-003')
-- A nézet megenged olyan értéket beszúrni, ami nem felel meg a WHERE feltételnek!


-- nézzünk bele a Product táblába
select top 10 * from dbo.Product order by ProductID desc
-- és a wiew-ba
select * from dbo.ProductsWithColor order by ProductID desc

--view módosítás
create or alter view ProductsWithColor
with schemabinding  --védelem a táblamódosítás ellen
as
select [ProductID], [ProductName], [ListPrice], [Color], [Size], [CreatedDate], [ProductNumber], [StandardCost]
from dbo.Product
where Color = 'Red' 

--with check option
create or alter view ProductsWithColor
with schemabinding  --védelem a táblamódosítás ellen
as
select [ProductID], [ProductName], [ListPrice], [Color], [Size], [CreatedDate], [ProductNumber], [StandardCost]
from dbo.Product
where Color = 'Red'
with check option --amit a view nem ad vissza, olyat beszúrni sem enged
-- ezek után ez nem sikerül
insert into dbo.ProductsWithColor([ProductName], [ListPrice], [Color],[ProductNumber])
values('New-Product 4', 1.00,'Black','NP-004')

--a view-ok nem tárolnak adatot!!!
--csak lekérdezés szövegét. (subquery)

-- A materializált, indexelt view eredménye letárolódik és rendszer szinten frissül.

-- A nézeteknek lehetnek triggerei. Ezek eseménykezelõk. (insert,update,delete)

-- A nézetek lehetnek particionáltak. (union all részek)