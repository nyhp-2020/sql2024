if not exists( -- ha még nincs ilyen nevû oszlop
	select name
	from sys.columns
	where object_id = object_id('dbo.Inventory')
	and name = 'UnitPrice'
)
alter table dbo.Inventory --hozzáadjuk
	add UnitPrice decimal(10,4) null

update i
set i.UnitPrice = p.ListPrice --ha a UnitPrice null frissítés a ListPrice-ból
--select *
from dbo.Product p
inner join dbo.Inventory i on p.ProductID = i.ProductID
where i.UnitPrice is null

alter table dbo.Inventory  -- a UnitPrice oszlop not null-ra állítása
	alter column UnitPrice decimal(10,4) not null
go
