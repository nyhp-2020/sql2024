-- nézeten is lehet trigger
create or alter trigger tr_ProductsInStock_InStock_Update
on dbo.ProductsInStock
instead of update
as

if update(InStock)
	update dbo.Inventory
	set ProductLeft = ch.Instock
	from (
		select i.ProductID,i.Instock
		from dbo.ProductsInStock v
		inner join inserted i on i.ProductID = v.ProductID
		where i.InStock = 0 and v.InStock <> 0 --ahol 0-ra változtattuk az InStock-ot nem 0-ról
	) ch, dbo.Inventory
	where dbo.Inventory.ProductID = ch.ProductID

/*
select *
from dbo.ProductsInStock v
inner join inserted i on i.ProductID = v.ProductID
where i.InStock = 0 and v.InStock <> 0
*/

go


--select * from dbo.ProductsInStock
update dbo.ProductsInStock set InStock = 0
where ProductID in (1002,1003,1004,1005)


/*
UPDATE demo_table1
SET demo_table1.NAME=demo_table2.NAME, 
demo_table1.AGE=demo_table2.AGE
FROM demo_table1, demo_table2
WHERE demo_table1.ID=demo_table2.ID;
*/