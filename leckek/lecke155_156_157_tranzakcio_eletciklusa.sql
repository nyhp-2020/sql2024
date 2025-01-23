set xact_abort on --b�rmilyen hib�n�l rollback-eli a tranzakci�t

begin transaction --nyit�s

select @@trancount --tranzakci� m�lys�get mutatja pl. egym�sba �gyazott tranzakci�kn�l

select xact_state() --�llapot (1,0,-1)

select * from dbo.Inventory

delete top (85) from dbo.Inventory

truncate table dbo.Inventory

rollback --visszag�rget�s
commit --v�gleges�t�s

--implicit tranzakci�
/*
Amikor a szerver automatikusan tranzakci�ban futtat m�veleteket
pl. alter table, minden m�dos�t�s

nem tranzakci�ba ill� m�veletek: backup, restore,...
*/