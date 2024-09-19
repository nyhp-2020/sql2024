
drop table if exists #adatok
select
    OrderID,
    dateadd(year, 8, OrderDate) as OrderDate,
    CustomerID,
    SalesPersonID,
    SubTotal
into #adatok
from Orders

drop table if exists #kategoria
select ProductSubCategoryID, left(newid(), 8) as ProductSubCategoryName
into #kategoria
from (
    select distinct ProductSubCategoryID
    from Product
) s
where ProductSubcategoryID is not null

-- hónap számával
select 
    ProductSubCategoryName, 
    [1] as Jan, 
    [2] as Feb, 
    [3] as Mar, -- stb.
    [4], [5], [6], [7], [8], [9], [10], [11], [12] 
from (
    select 
        month(o.OrderDate) as Month, 
        --datename(m, o.OrderDate) as MonthName,
        o.SubTotal, 
        k.ProductSubCategoryName
    from #adatok o
    inner join OrderDetail od on od.OrderID = o.OrderID
    inner join Product p on p.ProductID = od.ProductID
    inner join #kategoria k on k.ProductSubcategoryID = p.ProductSubcategoryID
    where o.OrderDate >= datefromparts(year(getdate()), 1, 1)
) s
pivot(sum(SubTotal) for Month in ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12])) p
order by 1
