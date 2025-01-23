begin transaction t1

set transaction isolation level repeatable read

delete top (1) from dbo.Inventory

--ez innentõl blokkolódik, ha a másikból lefutott az elsõ 3 utasítás

select @@trancount

--select * from dbo.Inventory

rollback
go

--deadlock2
begin transaction t1
--módosítás az Inventory-n
delete top (1) from dbo.Inventory

--futtatás eddig

--majd
select * from dbo.Product -- ennek itt várnia kell, mert a másik tranzakcióban zárolás van

-- ezt lõtte ki a szerver rollback-el deadlock miatt

rollback
go

--serializable példa

begin transaction t1

set transaction isolation level read committed

delete top (1) from dbo.Inventory --ez nem tud lefutni, mert a serializable tranzakció zárolta a sorokat

rollback
go

--izolációs szint beállítása tábla szinten

begin transaction t1

set transaction isolation level read committed

select * from dbo.Product with (readuncommitted) --nem teszi ki a lock-okat olvasás közben,így inkonzisztens adatokat is olvashat
--vagy
select * from dbo.Product with (nolock)

rollback