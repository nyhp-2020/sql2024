select
    SalesPersonId,
    sum(case when year(OrderDate) = 2011 then SubTotal end) as [2011],
    sum(case when year(OrderDate) = 2012 then SubTotal end) as [2012],
    sum(case when year(OrderDate) = 2013 then SubTotal end) as [2013],
    sum(case when year(OrderDate) = 2014 then SubTotal end) as [2014],
    sum(case when year(OrderDate) = 2015 then SubTotal end) as [2015],
    sum(case when year(OrderDate) = 2016 then SubTotal end) as [2016],
    sum(Subtotal) as TotalSales
from Orders
group by SalesPersonID

-- 2 dimenziós group by
select
    SalesPersonID,
    sum(case when year(OrderDate) = 2011 then Subtotal else 0 end) as [2011],
    sum(case when year(OrderDate) = 2012 then Subtotal else 0 end) as [2012],
    sum(case when year(OrderDate) = 2013 then Subtotal else 0 end) as [2013],
    sum(case when year(OrderDate) = 2014 then Subtotal else 0 end) as [2014],
    sum(case when year(OrderDate) = 2015 then Subtotal else 0 end) as [2015]
from Orders
group by SalesPersonID

--pivot 1.sorfejlécek 2.oszlopfejlécek 3.Összesítőfüggvény a metszéspontokban 4.Melyik oszlopra használjuk az összesítő függvényt
--kétdimenziós group by
--pivottal
select SalesPersonID,[2011],[2012],[2013],[2014],[2015]
from(
    select SalesPersonID, year(OrderDate) as Year, SubTotal
    from Orders
) o
pivot(sum(SubTotal) for Year in ([2011],[2012],[2013],[2014],[2015])) p

--null-ok eltüntetése isnull függvénnyel
select SalesPersonID,isnull([2011],0) as [2011],isnull([2012],0) as [2012],isnull([2013],0) as [2013],isnull([2014],0) as [2014],isnull([2015],0) as [2015]
from(
    select SalesPersonID, year(OrderDate) as Year, SubTotal
    from Orders
) o
pivot(sum(SubTotal) for Year in ([2011],[2012],[2013],[2014],[2015])) p

--Összesítsük az eladásokat évenként és országonként
select Country,[2011],[2012],[2013],[2014],[2015]
from (
    select year(o.OrderDate) as Year,c.Country,o.Subtotal
    from Orders o
    inner join Customer c on c.CustomerID = o.CustomerID
) o
pivot(sum(SubTotal) for Year in([2011],[2012],[2013],[2014],[2015])) p

-- tábla "elforgatása"
-- transzponálás
select Year,[DE],[GB],[AU],[CA],[FR],[US]
from (
    select year(o.OrderDate) as Year,c.Country,o.Subtotal
    from Orders o
    inner join Customer c on c.CustomerID = o.CustomerID
) o
pivot(sum(SubTotal) for Country in([DE],[GB],[AU],[CA],[FR],[US])) p

-- a null értékek megjelenítése, ahol nem volt kitöltve országkód a Customerben
select Year,[DE],[GB],[AU],[CA],[FR],[US],[UNKNOWN] as [NULL]
from (
    select year(o.OrderDate) as Year,isnull(c.Country,'UNKNOWN') as Country,o.Subtotal
    from Orders o
    inner join Customer c on c.CustomerID = o.CustomerID
) o
pivot(sum(SubTotal) for Country in([DE],[GB],[AU],[CA],[FR],[US],[UNKNOWN])) p

-- Month hozzáadása
select Year,Month,[DE],[GB],[AU],[CA],[FR],[US],[UNKNOWN] as [NULL]
-- Minden oszlop, ami visszajön a subquery-ből az automatikusan a group by részévé válik
-- tehát az (subquery) ne adja vissza, azokat a mezőket, amire nincs szükségem a pivotban!
from (
    -- ami itt megjelenik az csoportot képez, oszlopfejléc és további csoportot képez, használják a csoportos műveletekhez (pl. sum)
    select year(o.OrderDate) as Year,month(o.OrderDate) as Month,isnull(c.Country,'UNKNOWN') as Country,o.Subtotal
    from Orders o
    inner join Customer c on c.CustomerID = o.CustomerID
) o
pivot(sum(SubTotal) for Country in([DE],[GB],[AU],[CA],[FR],[US],[UNKNOWN])) p
order by 1,2

--
select Year,Month,[GB],[AU],[CA],[FR],[US],[UNKNOWN] as [NULL]
from (
    select year(o.OrderDate) as Year,month(o.OrderDate) as Month,isnull(c.Country,'UNKNOWN') as Country,o.Subtotal
    from Orders o
    inner join Customer c on c.CustomerID = o.CustomerID
) o
pivot(sum(SubTotal) for Country in([DE],[GB],[AU],[CA],[FR],[US],[UNKNOWN])) p -- amit itt felsorolok nem kötelező megjeleníteni a select listában, de ott csak az lehet, ami itt is van...
order by 1,2