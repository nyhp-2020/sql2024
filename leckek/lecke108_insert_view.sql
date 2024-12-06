
select * from dbo.ProductsWithColor order by ProductID desc

-- csak olyan oszlopokba sz�rhatok be, amit a view visszaad
insert into dbo.ProductsWithColor([ProductName], [ListPrice], [Color],[ProductNumber])
values('New-Product 1', 6.00,'Red','NP-001')
-- t�r�lni, m�dos�tani is lehet a view seg�ts�g�vel
-- pl. jogosults�gkezel�s

--ez lefut
insert into dbo.ProductsWithColor([ProductName], [ListPrice], [Color],[ProductNumber])
values('New-Product 2', 7.00,null,'NP-002')
-- a view-ben van is not null sz�r�s a Color-ra,ahova null-t akarok besz�rni
-- A sor beker�l a Product-ba, de a view nem adja vissza

insert into dbo.ProductsWithColor([ProductName], [ListPrice], [Color],[ProductNumber])
values('New-Product 3', 7.00,'Black','NP-003')
-- A n�zet megenged olyan �rt�ket besz�rni, ami nem felel meg a WHERE felt�telnek!


-- n�zz�nk bele a Product t�bl�ba
select top 10 * from dbo.Product order by ProductID desc
-- �s a wiew-ba
select * from dbo.ProductsWithColor order by ProductID desc

--view m�dos�t�s
create or alter view ProductsWithColor
with schemabinding  --v�delem a t�blam�dos�t�s ellen
as
select [ProductID], [ProductName], [ListPrice], [Color], [Size], [CreatedDate], [ProductNumber], [StandardCost]
from dbo.Product
where Color = 'Red' 

--with check option
create or alter view ProductsWithColor
with schemabinding  --v�delem a t�blam�dos�t�s ellen
as
select [ProductID], [ProductName], [ListPrice], [Color], [Size], [CreatedDate], [ProductNumber], [StandardCost]
from dbo.Product
where Color = 'Red'
with check option --amit a view nem ad vissza, olyat besz�rni sem enged
-- ezek ut�n ez nem siker�l
insert into dbo.ProductsWithColor([ProductName], [ListPrice], [Color],[ProductNumber])
values('New-Product 4', 1.00,'Black','NP-004')

--a view-ok nem t�rolnak adatot!!!
--csak lek�rdez�s sz�veg�t. (subquery)

-- A materializ�lt, indexelt view eredm�nye let�rol�dik �s rendszer szinten friss�l.

-- A n�zeteknek lehetnek triggerei. Ezek esem�nykezel�k. (insert,update,delete)

-- A n�zetek lehetnek particion�ltak. (union all r�szek)