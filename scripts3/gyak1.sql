-- Gyakorlat 1.
-- Mutassuk ki, hogy a Customer táblában a duplikátumokat a következők szerint:
-- Csak FirstName és LastName szerint
-- Bővítsük Country-ra is
-- Bővítsük City-re is
-- Jelenítsünk meg mident egyben és a Customer tábla összes oszlopát.
-- group by + join
select c.*
from (
    select FirstName, LastName, count(*) c
    from Customer
    group by FirstName, LastName
    having count(*) > 1
) dupl
inner join Customer c on c.FirstName = dupl.FirstName and c.LastName = dupl.LastName
order by c.FirstName, c.LastName

select *
from (
    select *, count(*) over(partition by FirstName, LastName, Country, City) as count
    from Customer
) c
where [count] > 1
order by FirstName, LastName

-- 2. Listázzuk ki azokat a vásárlókat, akik a tavalyi évben vásároltak, de az idén még nem.
-- Szimuláljuk az adatokat 2018 és 2022 között
-- Mutassuk meg az érintett vásárlók utolsó vásárlását az előző évből (dátum, összeg).
drop table if exists #adatok
select
    OrderID,
    dateadd(year, 8, OrderDate) as OrderDate,
    CustomerID,
    SalesPersonID,
    SubTotal
into #adatok
from Orders

select Customer.CustomerID, last_order.OrderDate, last_order.SubTotal
from (
    select distinct CustomerID
    from #adatok
    --where OrderDate between '2021-01-01' and '2021-12-31'
    where OrderDate between datefromparts(year(getdate()) - 1, 1, 1) and datefromparts(year(getdate()) - 1, 12, 31)

    except

    select distinct CustomerID
    from #adatok
    --where OrderDate between '2022-01-01' and '2022-12-31'
    where OrderDate between datefromparts(year(getdate()), 1, 1) and datefromparts(year(getdate()), 12, 31)
) c
join Customer on Customer.CustomerID = c.CustomerID
outer apply (
    select top 1 *
    from #adatok o
    where o.CustomerID = c.CustomerID
    order by OrderDate desc
) last_order

-- 3. Keressük ki azokat a vásárlókat, amelyek utóneve a következő listában van:
-- “Keil,Gage,Amland,Emanuel,Gates,Koch,Bourne,Colvin,Chambers,Ruth,Benson,Ray,West”
-- közvetlen string_split-el
select * 
from string_split('Keil,Gage,Amland,Emanuel,Gates,Koch,Bourne,Colvin,Chambers,Ruth,Benson,Ray,West', ',') s
inner join Customer c on c.LastName = s.value

drop table if exists #nevek
select value as Nev
into #nevek
from string_split('Keil,Gage,Amland,Emanuel,Gates,Koch,Bourne,Colvin,Chambers,Ruth,Benson,Ray,West', ',') s

select c.*
from #nevek s
inner join Customer c on c.LastName = s.Nev
