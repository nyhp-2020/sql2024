select ROW_NUMBER() OVER(order by CustomerID) as Sorszám, *
from customer
where Country = 'HU'


select ROW_NUMBER() OVER(order by FirstName) as Sorszám, *
from customer
where Country = 'HU'
order by CustomerID

--itt minden Country -nek külön sorszámozása van FirsName szerint (belső rendezettség)
select ROW_NUMBER() OVER(partition by Country order by FirstName) as Sorszám, * --kötött szórend
from customer
where Country is not null
order by Country, Firstname --(külső rendezés)