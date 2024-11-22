--gyakorlat 1
-- duplikátumok FirsName,LastName szerint

select FirstName,LastName, count(*)
from Customer
group by FirstName, LastName
having count(*) > 1

-- group by + join
select c.*
from(
    select FirstName,LastName, count(*) c
    from Customer
    group by FirstName, LastName
    having count(*) > 1
) dupl
inner join Customer c on c.FirstName = dupl.FirstName and c.LastName = dupl.LastName
order by c.FirstName, c.LastName

--
select *,
    count(*) over(partition by FirstName,LastName) --ezt nem lehet where-be tenni
from Customer

-- ablakozó
select *
from(
select *,
    count(*) over(partition by FirstName,LastName) as count
from Customer
) c 
where [count] > 1
order by FirstName, LastName

--Vegyük be az egyediségbe a Country-t is

select *
from(
select *,
    count(*) over(partition by FirstName,LastName,Country) as count
from Customer
) c 
where [count] > 1
order by FirstName, LastName,Country

--Vegyük bele a City-t is

select *
from(
select *,
    count(*) over(partition by FirstName,LastName,Country,City) as count
from Customer
) c 
where [count] > 1
order by FirstName, LastName