alter table Product
	add ListPrice2 int null
go
--select ListPrice2 from Product -- ez nem fut le rögtön az elõzõvel együtt go nélkül
exec('select ListPrice2 from Product') -- ez már lefut az elõzõvel együtt go nélkül is

alter table Product
	drop column ListPrice2

exec('select * from Product')

declare @sql nvarchar(max) --ilyen változóba állítjuk össze

--set @sql = 'SELECT * FROM Product'

--exec(@sql) --így futtatjuk

drop table if exists #temp
create table #temp(id int)

insert into #temp values(1)

set @sql = 'SELECT * FROM #temp' -- a dinamikus sql használhatja azt a táblát, amit a külsõ kontextusban hoztunk létre

exec(@sql)

select * from #temp
go

-- a dinamikus sql által létrehozott temp tábla kívül nem látszik, belül igen
declare @sql nvarchar(max)
set @sql ='drop table if exists #temp
create table #temp(id int)

insert into #temp values(1)
select * from #temp
'

exec(@sql)

select * from #temp
go

-- a dinamikus sql felül definiálhatja a külsõ temp táblát
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

-- a külsõ és belsõ változóknak nincs közük egymáshoz
declare @i int
exec('select @i')
go

declare @valtozo int = 1

exec('
declare @valtozo int = 5
select @valtozo
')

select @valtozo

