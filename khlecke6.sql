-- ablakozó függvények

--ID szerinti sorszám
select row_number() over(order by CustomerID) as Sorszám, *
from Customer
where Country = 'HU'

--FirstName szerinti sorszám
select row_number() over(order by FirstName) as Sorszám, *
from Customer
where Country = 'HU'
order by CustomerID

--
select row_number() over(partition by Country order by FirstName) as Sorszám, *
from Customer
--where Country = 'HU'
order by CustomerID

--partition by mikor induljon újra a sorszám az over-ben lévő order by szerint
select row_number() over(partition by Country order by FirstName) as Sorszám, *
from Customer
where Country is not null
order by Country, FirstName

select row_number() over(partition by Country order by FirstName) as Sorszám, *
from Customer
where Country is not null
order by CustomerID --a lekérdezés rendezettsége független az ablakozástól