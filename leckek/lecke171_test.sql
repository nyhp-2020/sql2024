
drop table if exists #mytemptable
create table #mytemptable(id int)

exec uspFillTempTable
	@query = 'SELECT SalesOrderID,Status,CustomerID,SubTotal FROM [AdventureWorks2019].Sales.SalesOrderHeader',
	@temp_table = '#mytemptable'

select * from #mytemptable
