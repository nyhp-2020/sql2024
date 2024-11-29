truncate table[dbo].[Inventory]
--truncate table[dbo].[Product]
delete from [dbo].[Product]

--új tábla struktúra
-- Product feltöltés

set identity_insert [dbo].[Product] on  --bekapcsol

insert into [dbo].[Product]([ProductID], [ProductName], [ListPrice], [Color], [Size], [ProductNumber], [StandardCost], [SellStartDate])
select ProductID, Name, ListPrice,Color,null, ProductNumber,StandardCost,SellStartDate
from AdventureWorks2019.Production.Product
where ListPrice > 0

set identity_insert [dbo].[Product] off  --kikapcsol

select * from dbo.Product