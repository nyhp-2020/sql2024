-- ld. khlecke11 is
--Gyakorlat 1.
--Mutassuk ki a Customer táblában a duplikátumokat a következők szerint:
--Csak FirstName és LastName szerint
--Bővítsük Country-ra is
--Bővítsük City-re is
--Jelenítsünk meg mindent egyben és a Customer tábla összes oszlopát

-- duplikátumok FullName szerint
select FirstName,LastName,count(*)
from Customer
group by FirstName,LastName
having count(*) > 1

--group by + join
select c.*
from(
    select FirstName,LastName,count(*) c
    from Customer
    group by FirstName,LastName
    having count(*) > 1 
)dupl
inner join Customer c on c.FirstName = dupl.FirstName and c.LastName = dupl.LastName
order by c.FirstName,c.LastName -- rendezzük, hogy lássuk a duplikátumokat

--group by join + Country (bővíteni kell a belő lekérdezés selct listát, group by listát,inner join feltételt)
select c.*
from(
    select FirstName,LastName,Country,count(*) c
    from Customer
    group by FirstName,LastName,Country
    having count(*) > 1 
)dupl
inner join Customer c on c.FirstName = dupl.FirstName and c.LastName = dupl.LastName and c.Country = dupl.Country
order by c.FirstName,c.LastName

--group by join + Country + City (bővíteni kell a belő lekérdezés selct listát, group by listát,inner join feltételt)
select c.*
from(
    select FirstName,LastName,Country,City,count(*) c
    from Customer
    group by FirstName,LastName,Country,City
    having count(*) > 1 
)dupl
inner join Customer c on c.FirstName = dupl.FirstName and c.LastName = dupl.LastName and c.Country = dupl.Country and c.City = dupl.City
order by c.FirstName,c.LastName


--megszámoljuk hány db van
select *, count(*) over(partition by FirstName, LastName)
from Customer
--where (count(*) over(partition by FirstName, LastName)) > 1 --a where-ben nem lehet ablakozó függvény

--ezért allekérdezésbe tesszük
-- ablakozó allekérdezés (ennek jobb a teljesítménye)
select *
from(
    select *, count(*) over(partition by FirstName, LastName) as count
    from Customer
) c
where [count] > 1
order by FirstName,LastName

--Vegyük be az egyediségbe még a Country-t is
select *
from(
    select *, count(*) over(partition by FirstName, LastName, Country) as count
    from Customer
) c
where [count] > 1
order by FirstName,LastName

--Vegyük bele a City-t is az egyediségbe
select *
from(
    select *, count(*) over(partition by FirstName, LastName, Country,City) as count
    from Customer
) c
where [count] > 1
order by FirstName,LastName