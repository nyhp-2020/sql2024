
execute as user = 'test' --jogosults�g be�ll�t�s

select * from Customer

revert -- visszavon�s

--usernevek lek�rdez�se
select user_name(),suser_sname(),original_login()

execute as user = 'test'

exec dbo.uspCleanupOrders
/*
create ...
with execute as 'dbo'
*/

exec test.uspCleanupOrders