-- 1. dátum eltolása az ideiglenes táblában
drop table if exists #adatok

select
    OrderID,
    dateadd(year,10,OrderDate) as OrderDate,
    CustomerID,
    SalesPersonID,
    Subtotal
    into #adatok --itt hozom létre
from Orders

select * from #adatok

--Termékkategóriák
select distinct ProductSubcategoryID
from Product

--newid()
select distinct ProductSubcategoryID, left(newid(),8)
from Product

-- 2. ideiglenes tábla a kategóriákra
drop table if exists #kategoria
select distinct ProductSubcategoryID, left(newid(),8) as ProductSubCategoryName
into #kategoria
from(
    select distinct ProductSubCategoryID
    from Product
) s
where ProductSubCategoryID is not null

select * from #kategoria

-- aktuális év szűrése
select month(o.OrderDate) Month,Subtotal, k.ProductSubcategoryName
from #adatok o
inner join OrderDetail od on od.OrderID = o.OrderID
inner join Product p on p.ProductID = od.ProductID
inner join #kategoria k on k.ProductSubCategoryID = p.ProductSubcategoryID
where o.OrderDate >= datefromparts(year(getdate()),1,1) --aktuális év


--hónap számával

select ProductSubcategoryName,[1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12]
        --[1] as Jan,
        --[2] as Feb,
        --[3] as Mar,
        --[4] as Apr,
        --[5] as May,
        --[6] as Jun,
        --[7] as Jul,
        --[8] as Aug,
        --[9] as Sep,
        --[10] as Okt,
        --[11] as Nov,
        --[12] as Dec
from(
    select month(o.OrderDate) Month, o.Subtotal, k.ProductSubcategoryName
    from #adatok o
    inner join OrderDetail od on od.OrderID = o.OrderID
    inner join Product p on p.ProductID = od.ProductID
    inner join #kategoria k on k.ProductSubCategoryID = p.ProductSubcategoryID
    where o.OrderDate >= datefromparts(year(getdate()),1,1)
) s
pivot(sum(Subtotal) for Month in ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12])) p
order by 1

set language Hungarian -- nyelv állítása magyarra
set language English

-- a hónap nevével (pontos nevek kellenek!)
select ProductSubcategoryName,[January], [February], [March], [April], [May], [June], [July], [August], [September], [Oktober], [November], [December]   
from(
    select
        --month(o.OrderDate) as Month,
        --datename(month,o.OrderDate) as MonthName,
        datename(m,o.OrderDate) as MonthName,
        o.Subtotal,
        k.ProductSubcategoryName
    from #adatok o
    inner join OrderDetail od on od.OrderID = o.OrderID
    inner join Product p on p.ProductID = od.ProductID
    inner join #kategoria k on k.ProductSubCategoryID = p.ProductSubcategoryID
    where o.OrderDate >= datefromparts(year(getdate()),1,1)
) s
pivot(sum(Subtotal) for MonthName in ([January], [February], [March], [April], [May], [June], [July], [August], [September], [Oktober], [November], [December])) p
order by 1