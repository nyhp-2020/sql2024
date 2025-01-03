create or alter trigger tr_ProductsInStock_InStock_Insert
on dbo.ProductsInStock
instead of insert
as
--ha nincs bent a nézetben (Product-ban), itt nem szúrhatjuk be (mert a Product-ba is be kéne szúrni)
if not exists(select *
		  from dbo.ProductsInStock v
		  inner join inserted i on i.ProductID = v.ProductID) return

--ha teljesülnek feltételek, beszúrunk az Inventory-ba
insert into dbo.Inventory(ProductID,ProductLeft,ProductCount,Shelf)
select i.ProductID,i.InStock,1,'ZZ' --ProductCount > 0
from dbo.ProductsInStock v
inner join inserted i on i.ProductID = v.ProductID --létezik a nézetben (a Product-ban is)
left join dbo.Inventory iv on iv.ProductID = v.ProductID
where iv.ProductID is null --de az inventory-ban nincs benne (oda be lehet szúrni)
and i.InStock = 0  -- 0-val szúrnánk be (csak 0-val szúrhatunk be )

/*
select *
from dbo.ProductsInStock v
inner join inserted i on i.ProductID = v.ProductID --létezik a nézetben (a Product-ban is)
left join dbo.Inventory iv on iv.ProductID = v.ProductID
where iv.ProductID is null --de az inventory-ban nincs benne (oda be lehet szúrni)
and i.InStock = 0  -- 0-val szúrnánk be (csak 0-val szúrhatunk be )
*/
--select * from inserted
go

--select * from dbo.ProductsInStock
insert into dbo.ProductsInStock(ProductID,InStock,ProductLeft,OrderQuantity)
values(1,1,3,2),
(1002,1,10,10),
(1007,0,10,10)