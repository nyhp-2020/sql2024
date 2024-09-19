--al lekérdezés a from után
select p.Name as ProductName, sum(LineTotal)
--select p.ProductId as ProductName, sum(LineTotal)
from Product p
inner join OrderDetail od on od.ProductID = p.ProductID
group by p.Name
--group by p.ProductID


select p.ProductId as ProductName, sum(LineTotal)
from Product p
inner join OrderDetail od on od.ProductID = p.ProductID
group by p.ProductID

--od.LineTotal = od.OrderQty * od.UnitPrice
select p.Name as ProductName, sum(LineTotal)
from Product p
inner join OrderDetail od on od.ProductID = p.ProductID
group by p.Name
having sum(LineTotal) > 3000000

--vagy
select p.Name as ProductName, sum(od.OrderQty * od.UnitPrice)
from Product p
inner join OrderDetail od on od.ProductID = p.ProductID
group by p.Name
having sum(od.OrderQty * od.UnitPrice) > 3000000

-- subquery
select ord.*
from(  --mintha egy tábla lenne
    select p.Name as ProductName, sum(LineTotal) as Total  -- egyedi aliasz oszlopnevek kellenek
    from Product p
    inner join OrderDetail od on od.ProductID = p.ProductID
    group by p.Name
) as ord
where ord.Total > 3000000 --ha nem lenne having, mindig így kellene csinálni

-- itt csak a nevet kérdezzük
select ord.ProductName
from(  --mintha egy tábla lenne
    select p.Name as ProductName, sum(LineTotal) as Total  -- egyedi aliasz oszlopnevek kellenek
    from Product p
    inner join OrderDetail od on od.ProductID = p.ProductID
    group by p.Name
) as ord -- kötelező aliasnév
where ord.Total > 3000000 --ha nem lenne having, mindig így kellene csinálni
--általában előszűrésre használjuk

--APPLY
select
    p.ProductID,
    p.Name as ProductName,
    o.*
from Product p
cross apply ( --ez használhat kívül definiált táblát (mert apply)
    select top 3 *
    from OrderDetail od
    where od.ProductID = p.ProductID
    order by OrderID desc
) o
where p.ProductSubcategoryID = 10
order by p.ProductID, o.OrderID desc


--hibás
select ord.*
from Product pr
inner join (  -- ez nem használhat táblát kívülről (pl. pr.ProductID)
    select p.Name as ProductName, sum(LineTotal) as Total  -- egyedi aliasz oszlopnevek kellenek
    from Product p
    inner join OrderDetail od on od.ProductID = p.ProductID
    where p.ProductID = pr.ProductID
    group by p.Name
) as ord on 1=1
where ord.Total > 3000000