use AdventureWorks2019

-- Skaláris függvény
--Orderdate: YYYY.HH.NN.
select convert(varchar(11),OrderDate,102) + '.', *
from Sales.SalesOrderHeader

-- alapértelmezett formátum (opcionális paraméter elhagyása)
select convert(varchar(11),OrderDate) + '.', *
from Sales.SalesOrderHeader

--Tábla függvény
--Listázzuk ki azokat a termékeket, amelyek tartalmazzák a következõ szavakat:...
select *
from Production.Product
where name like '%Frame%'
or name like '%Seat%'
--...

select *
from string_split('Frame,Seat,Tire,Pedal,Tube,Tape,Lock,Race,Plate,Sheet',',')

-- a felsõ kettõbõl

select *
from Production.Product p
where exists(
	select *
	from string_split('Frame,Seat,Tire,Pedal,Tube,Tape,Lock,Race,Plate,Sheet',',') s -- táblával tér vissza
	where p.Name like '%'+ s.value +'%'
)

-- Jelenítsünk  meg egy select-ben egyetlen oszlopban egy dátumot, amely az aktuális hónap elsõ napja, utolsó napja,...

select datefromparts(2000,12,1), datefromparts(year(getdate()),month(getdate()),1)

select
	datefromparts(year(getdate()),month(getdate()),1), -- aktuális hónap elsõ napja
	dateadd(day, -1,dateadd(month,1,datefromparts(year(getdate()),month(getdate()),1))) -- hozzáadtunk egy hónapot,majd kivontunk egy napot
	-- ez a hónap utolsó napja

