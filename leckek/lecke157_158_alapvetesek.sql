begin transaction t1
set transaction isolation level read uncommitted --betekint�st enged a "piszkos" adatokba amik nincsenek v�gleges�tve
set transaction isolation level read committed  --csak a v�gleges�tett adatok l�tszanak; ALAP�RTELMEZETT!
set transaction isolation level repeatable read --z�rolja a kiolvasott sorokat a tranzakci�ban
set transaction isolation level serializable --minden sort z�rol vagy v�r (cs�kken a p�rhuzamoss�g, holtpont vesz�ly)
set transaction isolation level snapshot --z�rol�s helyett verzi�z�st haszn�l (veri�k a tempdb-ben: verzi�t�r)
-- az �r�k nem blokkolj�k az olvas�kat, az olvas�k nem blokkolj�k az �r�kat,csak az �r�k blokkolj�k egym�st
--enged�lyez�s: Allow Snapshot Isolation (Az Options alatt)

--Is Read Committed Snapshot On (Read Committed helyett Snapshot) (Szint�n az Options alatt)

select * from dbo.Inventory

select @@trancount,xact_state()

rollback

select * from sys.tables
select * from sys.objects


--Query Options->Advanced: SET TRANSACTION ISOLATION LEVEL