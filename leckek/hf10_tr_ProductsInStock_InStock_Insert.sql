create or alter trigger tr_ProductsInStock_InStock_Insert
on dbo.ProductsInStock
instead of insert
as
--ha nincs bent a n�zetben (Product-ban), itt nem sz�rhatjuk be (mert a Product-ba is be k�ne sz�rni)
if not exists(select *
		  from dbo.ProductsInStock v
		  inner join inserted i on i.ProductID = v.ProductID) return

--ha teljes�lnek felt�telek, besz�runk az Inventory-ba
insert into dbo.Inventory(ProductID,ProductLeft,ProductCount,Shelf)
select i.ProductID,i.InStock,1,'ZZ' --ProductCount > 0
from dbo.ProductsInStock v
inner join inserted i on i.ProductID = v.ProductID --l�tezik a n�zetben (a Product-ban is)
left join dbo.Inventory iv on iv.ProductID = v.ProductID
where iv.ProductID is null --de az inventory-ban nincs benne (oda be lehet sz�rni)
and i.InStock = 0  -- 0-val sz�rn�nk be (csak 0-val sz�rhatunk be )

/*
select *
from dbo.ProductsInStock v
inner join inserted i on i.ProductID = v.ProductID --l�tezik a n�zetben (a Product-ban is)
left join dbo.Inventory iv on iv.ProductID = v.ProductID
where iv.ProductID is null --de az inventory-ban nincs benne (oda be lehet sz�rni)
and i.InStock = 0  -- 0-val sz�rn�nk be (csak 0-val sz�rhatunk be )
*/
--select * from inserted
go

--select * from dbo.ProductsInStock
insert into dbo.ProductsInStock(ProductID,InStock,ProductLeft,OrderQuantity)
values(1,1,3,2),
(1002,1,10,10),
(1007,0,10,10)