exec uspCleanupOrders

--t�rolt elj�r�sban haszn�lva csak az el�r�s a hat�k�re
set nocount on --kikapcsolja az �rintett sorok ki�r�s�t

select * from Product

set xact_abort on --b�rmilyen hiba eset�n megszak�tja a tranzakci�t �s rollback-el. Ha van try-catch,az m�k�dik

select * from Customer where Title is null

set ansi_nulls off -- �gy �rt�kk�nt kezeli a null-t (alap�rtelmezott: on)
select * from Customer where Title = null
select * from Customer where null = null
select *, Title + FirstName + LastName from Customer where Title = null
if null = null print 'null'

set ansi_warnings off -- �zenetek kikapcsol�sa
select count(Title) from Customer --az aggreg�l� f�ggv�nyek kihagyj�k a null �rt�keket

select * from Customer
where Title is not null
go

select * from "Product"
select * from [Product]
set quoted_identifier off --�gy nem megy az id�z�jelez�s
set quoted_identifier on  --csak �gy
select *, ListPrice * 1.1 as "NewPrice" from "Product"
go

set ansi_padding on --kit�lti space-el a marad�k helyeket a nem v�ltoz� hossz�s�g� mez�kn�l
set ansi_padding off -- ez meg nem
--declare @var nvarchar(10) = 'ABC'
--select '|' + @var + '|'
drop table if exists t1
create table t1(name char(10))
insert into t1 values ('ABC')

select '|' + name + '|'from t1
drop table t1
go

--nyelv be�ll�t�s (sessiuon-re �rv�nyes)
set language Hungarian
select 1 / 0
go

set datefirst 1 --melyik a h�t els� napja
select datepart(m,getdate()) --h�nyadik h�napban vagyok
select datepart(dw,getdate()) --h�nyadik napon vagyok a h�ten
