select City, FirstName + ' ' + LastName as FullName
from Customer
where City in ('Seattle', 'Portland')
order by City, FullName



select City, FirstName + ' ' + LastName as FullName
from Customer
where (City = 'seattle' and FirstName like '%')
or
(City = 'Portland' and FirstName like 'F%')
order by City, FullName

select getdate(), year(getdate())

-- Ez a lekérdezés szűri a városokat
select City, FirstName + ' ' + LastName as FullName
from Customer
where City in ('Seattle', 'Portland')
order by City, FullName desc

select * from Customer where City is not null

select City, isnull(Title, '') + ' ' + FirstName + ' ' + LastName as FullName
from Customer


