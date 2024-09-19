-- Számítsuk ki, hogy az egyes vásárlók vásárlásai között hány nap telt el.
-- dátum függvények: datediff
select *, datediff(day, OrderDate, NextOrderDate) Days
from (
    select 
        OrderID,
        CustomerId,
        OrderDate,
        lead(OrderDate) over(partition by CustomerID order by OrderDate) as NextOrderDate
    from Orders
) o
order by CustomerID, OrderDate, OrderID

-- hány hét telt el
select *, datediff(week, OrderDate, NextOrderDate) Weeks
from (
    select 
        OrderID,
        CustomerId,
        OrderDate,
        lead(OrderDate) over(partition by CustomerID order by OrderDate) as NextOrderDate
    from Orders
) o
order by CustomerID, OrderDate, OrderID

-- hány óra telt el
select *, datediff(hour, OrderDate, NextOrderDate) Hours
from (
    select 
        OrderID,
        CustomerId,
        OrderDate,
        lead(OrderDate) over(partition by CustomerID order by OrderDate) as NextOrderDate
    from Orders
) o
order by CustomerID, OrderDate, OrderID

--szöveg függvények:
-- Mutassuk ki, hogy hányféle domain van az Email oszlopban a Customer táblában.
select distinct
    --Email, CHARINDEX('@',Email),LEN(Email),LEN(Email)-CHARINDEX('@',Email),
    RIGHT(Email, LEN(Email)-CHARINDEX('@',Email))
from Customer




-- Duplikátumok a Customer táblában FirstName,LastName szerint
select FirstName, LastName, count(*)
from Customer
group by FirstName, LastName
having count(*) > 1
order by 1,2

-- Duplikátumok a Customer táblában Country szerint
select Country, count(*)
from Customer
group by Country
having count(*) > 1
order by 1

-- Duplikátumok a Customer táblában City szerint
select City, count(*) as cnt
from Customer
group by City
having count(*) > 1
order by 1

--számlálók több szempont szerint ablakozó függvényekkel
select *,
    count(*) over(partition by FirstName,LastName) FullNameCnt, --hány ilyen FullName van
    count(*) over(partition by Country) CountryCnt,     --Hány ilyen Country van
    count(*) over(partition by City) CityCnt            --Hány ilyen City van
from Customer

--cte
with counters as(
    select *,
    count(*) over(partition by FirstName,LastName) FullNameCnt, --hány ilyen FullName van
    count(*) over(partition by Country) CountryCnt,     --Hány ilyen Country van
    count(*) over(partition by City) CityCnt            --Hány ilyen City van
from Customer
)
select *
from counters
where FullNameCnt > 1 --duplicátum

union all

select *
from counters
where CountryCnt > 1

union all

select *
from counters
where CityCnt > 1


--cte union
with counters as(
    select FirstName,LastName,Country,City,
    count(*) over(partition by FirstName,LastName) FullNameCnt, --hány ilyen FullName van
    count(*) over(partition by Country) CountryCnt,     --Hány ilyen Country van
    count(*) over(partition by City) CityCnt            --Hány ilyen City van
from Customer
)
select *
from counters
where FullNameCnt > 1 --duplicátum

union

select *
from counters
where CountryCnt > 1

union

select *
from counters
where CityCnt > 1