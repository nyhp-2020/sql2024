use AdventureWorks2019

-- Skal�ris f�ggv�ny
--Orderdate: YYYY.HH.NN.
select convert(varchar(11),OrderDate,102) + '.', *
from Sales.SalesOrderHeader

-- alap�rtelmezett form�tum (opcion�lis param�ter elhagy�sa)
select convert(varchar(11),OrderDate) + '.', *
from Sales.SalesOrderHeader

--T�bla f�ggv�ny
--List�zzuk ki azokat a term�keket, amelyek tartalmazz�k a k�vetkez� szavakat:...
select *
from Production.Product
where name like '%Frame%'
or name like '%Seat%'
--...

select *
from string_split('Frame,Seat,Tire,Pedal,Tube,Tape,Lock,Race,Plate,Sheet',',')

-- a fels� kett�b�l

select *
from Production.Product p
where exists(
	select *
	from string_split('Frame,Seat,Tire,Pedal,Tube,Tape,Lock,Race,Plate,Sheet',',') s -- t�bl�val t�r vissza
	where p.Name like '%'+ s.value +'%'
)

-- Jelen�ts�nk  meg egy select-ben egyetlen oszlopban egy d�tumot, amely az aktu�lis h�nap els� napja, utols� napja,...

select datefromparts(2000,12,1), datefromparts(year(getdate()),month(getdate()),1)

select
	datefromparts(year(getdate()),month(getdate()),1), -- aktu�lis h�nap els� napja
	dateadd(day, -1,dateadd(month,1,datefromparts(year(getdate()),month(getdate()),1))) -- hozz�adtunk egy h�napot,majd kivontunk egy napot
	-- ez a h�nap utols� napja

