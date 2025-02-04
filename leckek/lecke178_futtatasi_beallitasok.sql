exec uspCleanupOrders

--tárolt eljárásban használva csak az elárás a hatóköre
set nocount on --kikapcsolja az érintett sorok kiírását

select * from Product

set xact_abort on --bármilyen hiba esetén megszakítja a tranzakciót és rollback-el. Ha van try-catch,az mûködik

select * from Customer where Title is null

set ansi_nulls off -- így értékként kezeli a null-t (alapértelmezott: on)
select * from Customer where Title = null
select * from Customer where null = null
select *, Title + FirstName + LastName from Customer where Title = null
if null = null print 'null'

set ansi_warnings off -- üzenetek kikapcsolása
select count(Title) from Customer --az aggregáló függvények kihagyják a null értékeket

select * from Customer
where Title is not null
go

select * from "Product"
select * from [Product]
set quoted_identifier off --így nem megy az idézõjelezés
set quoted_identifier on  --csak így
select *, ListPrice * 1.1 as "NewPrice" from "Product"
go

set ansi_padding on --kitölti space-el a maradék helyeket a nem változó hosszúságú mezõknél
set ansi_padding off -- ez meg nem
--declare @var nvarchar(10) = 'ABC'
--select '|' + @var + '|'
drop table if exists t1
create table t1(name char(10))
insert into t1 values ('ABC')

select '|' + name + '|'from t1
drop table t1
go

--nyelv beállítás (sessiuon-re érvényes)
set language Hungarian
select 1 / 0
go

set datefirst 1 --melyik a hét elsõ napja
select datepart(m,getdate()) --hányadik hónapban vagyok
select datepart(dw,getdate()) --hányadik napon vagyok a héten
