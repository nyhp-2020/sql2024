begin transaction t1

set transaction isolation level repeatable read

delete top (1) from dbo.Inventory

--ez innent�l blokkol�dik, ha a m�sikb�l lefutott az els� 3 utas�t�s

select @@trancount

--select * from dbo.Inventory

rollback
go

--deadlock2
begin transaction t1
--m�dos�t�s az Inventory-n
delete top (1) from dbo.Inventory

--futtat�s eddig

--majd
select * from dbo.Product -- ennek itt v�rnia kell, mert a m�sik tranzakci�ban z�rol�s van

-- ezt l�tte ki a szerver rollback-el deadlock miatt

rollback
go

--serializable p�lda

begin transaction t1

set transaction isolation level read committed

delete top (1) from dbo.Inventory --ez nem tud lefutni, mert a serializable tranzakci� z�rolta a sorokat

rollback
go

--izol�ci�s szint be�ll�t�sa t�bla szinten

begin transaction t1

set transaction isolation level read committed

select * from dbo.Product with (readuncommitted) --nem teszi ki a lock-okat olvas�s k�zben,�gy inkonzisztens adatokat is olvashat
--vagy
select * from dbo.Product with (nolock)

rollback