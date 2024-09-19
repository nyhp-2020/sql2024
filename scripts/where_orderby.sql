select * from Customer

select FirstName, LastName, City from Customer

select FirstName + ' ' + LastName as FullName, City as Város from Customer

select City, FirstName, LastName, FirstName + ' ' + LastName as FullName 
from Customer

select City, FirstName, LastName, FirstName + ' ' + LastName as FullName 
from Customer
where City = 'Portland' or City = 'Seattle'

select * from Customer where Title is not null




select City, FirstName, LastName, FirstName + ' ' + LastName as FullName 
from Customer
where City in ('Portland', 'Seattle')

-- különböző order by lehetőségek (azonos eredménnyel)
select City, FirstName, LastName, FirstName + ' ' + LastName as FullName 
from Customer
where City in ('Portland', 'Seattle')
order by City, FullName
-- vagy
select City, FirstName, LastName, FirstName + ' ' + LastName as FullName 
from Customer
where City in ('Portland', 'Seattle')
order by City, FirstName + ' ' + LastName
-- vagy
select City, FirstName, LastName, FirstName + ' ' + LastName as FullName 
from Customer
where City in ('Portland', 'Seattle')
order by 1, 4

select City, FirstName, LastName, FirstName + ' ' + LastName as FullName 
from Customer
where (City = 'Portland' and FirstName like 'F%') 
or 
(City = 'Seattle' and FirstName like 'A%')
order by City asc, FullName desc


select * from Customer where not Title is null








