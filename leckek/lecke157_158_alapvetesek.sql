begin transaction t1
set transaction isolation level read uncommitted --betekintést enged a "piszkos" adatokba amik nincsenek véglegesítve
set transaction isolation level read committed  --csak a véglegesített adatok látszanak; ALAPÉRTELMEZETT!
set transaction isolation level repeatable read --zárolja a kiolvasott sorokat a tranzakcióban
set transaction isolation level serializable --minden sort zárol vagy vár (csökken a párhuzamosság, holtpont veszély)
set transaction isolation level snapshot --zárolás helyett verziózást használ (veriók a tempdb-ben: verziótár)
-- az írók nem blokkolják az olvasókat, az olvasók nem blokkolják az írókat,csak az írók blokkolják egymást
--engedélyezés: Allow Snapshot Isolation (Az Options alatt)

--Is Read Committed Snapshot On (Read Committed helyett Snapshot) (Szintén az Options alatt)

select * from dbo.Inventory

select @@trancount,xact_state()

rollback

select * from sys.tables
select * from sys.objects


--Query Options->Advanced: SET TRANSACTION ISOLATION LEVEL