set xact_abort on --bármilyen hibánál rollback-eli a tranzakciót

begin transaction --nyitás

select @@trancount --tranzakció mélységet mutatja pl. egymásba ágyazott tranzakcióknál

select xact_state() --állapot (1,0,-1)

select * from dbo.Inventory

delete top (85) from dbo.Inventory

truncate table dbo.Inventory

rollback --visszagörgetés
commit --véglegesítés

--implicit tranzakció
/*
Amikor a szerver automatikusan tranzakcióban futtat mûveleteket
pl. alter table, minden módosítás

nem tranzakcióba illõ mûveletek: backup, restore,...
*/