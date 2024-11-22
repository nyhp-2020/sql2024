--1
drop table if exists #adatok
select
    OrderID,
    dateadd(year,8,OrderDate) as OrderDate,  --nevet kell adni a számított oszlopnak
    CustomerID,
    SalesPersonID,
    Subtotal
into #adatok --ideiglenes tábla
from Orders


--egyedi azonosító generálás
select distinct ProductSubcategoryID, left(newid(),8)
from Product


select ProductSubCategoryID, left(newid(),8) 
from(
    select distinct ProductSubcategoryID
    from Product
) s
where ProductSubCategoryID is not null

--temp tábla
drop table if exists #kategoria
select ProductSubCategoryID, left(newid(),8) as ProductSubCategoryName
into #kategoria
from(
    select distinct ProductSubcategoryID
    from Product
) s
where ProductSubCategoryID is not null

select * from #kategoria


-- hónap számával allekérdezés
select month(o.OrderDate) Month, o.Subtotal, k.ProductSubCategoryName
from #adatok o
inner join OrderDetail od on od.OrderID = o.OrderID
inner join Product p on p.ProductID = od.ProductID
inner join #kategoria k on k.ProductSubCategoryID = p.ProductSubCategoryID
where OrderDate >= datefromparts(year(getdate())-2,1,1)

-- hónap számával
select ProductSubcategoryName,
        [1] as Jan,
        [2] as Feb,
        [3] as Mar,
        [4] as Apr,
        [5] as May,
        [6] as Jun,
        [7] as Jul,
        [8] as Aug,
        [9] as Sep,
        [10] as Oct,
        [11] as Nov,
        [12] as Dec
from (
    select month(o.OrderDate) Month, o.Subtotal, k.ProductSubCategoryName
    from #adatok o
    inner join OrderDetail od on od.OrderID = o.OrderID
    inner join Product p on p.ProductID = od.ProductID
    inner join #kategoria k on k.ProductSubCategoryID = p.ProductSubCategoryID
    where OrderDate >= datefromparts(year(getdate())-2,1,1)
) s 
pivot(sum(SubTotal) for Month in ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])) p 
order by 1

--hónap nevével
--set language Hungarian

select ProductSubcategoryName,[January],[February],[March],[April],[May],[June],[July],[August],[September],[October],[November],[December]
        
from (
    select
        --month(o.OrderDate) as Month,
        datename(month, o.OrderDate) as MonthName,
        o.Subtotal,
        k.ProductSubCategoryName
    from #adatok o
    inner join OrderDetail od on od.OrderID = o.OrderID
    inner join Product p on p.ProductID = od.ProductID
    inner join #kategoria k on k.ProductSubCategoryID = p.ProductSubCategoryID
    where OrderDate >= datefromparts(year(getdate())-2,1,1)
) s 
pivot(sum(SubTotal) for MonthName in ([January],[February],[March],[April],[May],[June],[July],[August],[September],[October],[November],[December])) p 
order by 1