if not exists( -- ha m�g nincs ilyen nev� oszlop
	select name
	from sys.columns
	where object_id = object_id('dbo.Inventory')
	and name = 'UnitPrice'
)
alter table dbo.Inventory --hozz�adjuk
	add UnitPrice decimal(10,4) null

update i
set i.UnitPrice = p.ListPrice --ha a UnitPrice null friss�t�s a ListPrice-b�l
--select *
from dbo.Product p
inner join dbo.Inventory i on p.ProductID = i.ProductID
where i.UnitPrice is null

alter table dbo.Inventory  -- a UnitPrice oszlop not null-ra �ll�t�sa
	alter column UnitPrice decimal(10,4) not null
go
