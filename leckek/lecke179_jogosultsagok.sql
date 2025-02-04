
execute as user = 'test' --jogosultság beállítás

select * from Customer

revert -- visszavonás

--usernevek lekérdezése
select user_name(),suser_sname(),original_login()

execute as user = 'test'

exec dbo.uspCleanupOrders
/*
create ...
with execute as 'dbo'
*/

exec test.uspCleanupOrders