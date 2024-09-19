-- cte common table expression

-- egy termékenként az összes eladás
select ProductID, sum(LineTotal)
from OrderDetail
group by ProductID

--termékenkénti össz eladás
with termek as (
select ProductID, sum(LineTotal) as SumLineTotal
from OrderDetail
group by ProductID
)
select *
from termek

-- átlagos eladás
with termek as (
select ProductID, sum(LineTotal) as SumLineTotal
from OrderDetail
group by ProductID
)
select avg(SumLineTotal)
from termek

--kérdezzük le azon termékeke lisáját, amelyek eladásai átlagon felüliek
with termek as (
select ProductID, sum(LineTotal) as SumLineTotal
from OrderDetail
group by ProductID
)
select *
from termek
where SumLineTotal > (select avg(SumLineTotal) from termek)

-- hozzákapcsolva a Product tábla
with termek as (
select ProductID, sum(LineTotal) as SumLineTotal
from OrderDetail
group by ProductID
)
select p.*, termek.SumLineTotal
from termek
inner join Product p on p.ProductID = termek.ProductID
where SumLineTotal > (select avg(SumLineTotal) from termek)
--a subquery eredményét többször is felhasználom

--rekurzív lekérdezéseket is lehet csinálni
with CTE as (
    select cast('2010-01-01' as date) as [Date]
    union ALL
    select dateadd(day, 1,[Date]) from CTE
    where [Date] < getdate()
)
select [Date] from CTE 
option (maxrecursion 10000)
-- dátumlistát állít elő a megadott dátumtól mostanáig