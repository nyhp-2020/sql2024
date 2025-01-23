alter table Product
	add ListPrice2 int null
go
--select ListPrice2 from Product -- ez nem fut le r�gt�n az el�z�vel egy�tt go n�lk�l
exec('select ListPrice2 from Product') -- ez m�r lefut az el�z�vel egy�tt go n�lk�l is

alter table Product
	drop column ListPrice2

exec('select * from Product')

declare @sql nvarchar(max) --ilyen v�ltoz�ba �ll�tjuk �ssze

--set @sql = 'SELECT * FROM Product'

--exec(@sql) --�gy futtatjuk

drop table if exists #temp
create table #temp(id int)

insert into #temp values(1)

set @sql = 'SELECT * FROM #temp' -- a dinamikus sql haszn�lhatja azt a t�bl�t, amit a k�ls� kontextusban hoztunk l�tre

exec(@sql)

select * from #temp
go

-- a dinamikus sql �ltal l�trehozott temp t�bla k�v�l nem l�tszik, bel�l igen
declare @sql nvarchar(max)
set @sql ='drop table if exists #temp
create table #temp(id int)

insert into #temp values(1)
select * from #temp
'

exec(@sql)

select * from #temp
go

-- a dinamikus sql fel�l defini�lhatja a k�ls� temp t�bl�t
declare @sql nvarchar(max)
set @sql ='
--drop table if exists #temp
create table #temp(id int)

insert into #temp values(1)
select * from #temp
'

drop table if exists #temp
create table #temp(nev varchar(100))

exec(@sql)

select * from #temp
go

-- a k�ls� �s bels� v�ltoz�knak nincs k�z�k egym�shoz
declare @i int
exec('select @i')
go

declare @valtozo int = 1

exec('
declare @valtozo int = 5
select @valtozo
')

select @valtozo

