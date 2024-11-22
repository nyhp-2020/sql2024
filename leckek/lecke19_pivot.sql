select * from Orders

select SalesPersonID,sum(Subtotal)
from Orders
group by SalesPersonID

-- 2 dimenziós group by
select SalesPersonID,
sum(case when year(orderdate) = 2011 then Subtotal end) as [2011],
sum(case when year(orderdate) = 2012 then Subtotal end) as [2012],
sum(case when year(orderdate) = 2013 then Subtotal end) as [2013],
sum(case when year(orderdate) = 2014 then Subtotal end) as [2014],
sum(case when year(orderdate) = 2015 then Subtotal else 0 end) as [2015],
--sum(case when year(orderdate) = 2016 then Subtotal else 0 end) as [2016],
sum(Subtotal) as Totalsales
from Orders
group by SalesPersonID

--pivot
-- 1 mi legyen a sor fejlécekben, a sorok elején
-- 2 mik az oszlop fejlécek
-- 3 milyen összesítő függvényt használunk a metszéspontokban
-- 4 melyik oszlopra használjuk az összesítőfüggvényt

--allekérdezés
select
    SalesPersonID, --1 sorfejléc
    year(orderdate) as Year, --2 oszlopfejléc
    Subtotal --4 melyik oszlopot összesítjük
from Orders

--pivottal
select SalesPersonID,[2011],[2012],[2013],[2014],[2015]
from(
    select
        SalesPersonID, --1 sorfejléc
        year(orderdate) as Year, --2 oszlopfejléc
        Subtotal --4 melyik oszlopot összesítjük
    from Orders
) o
pivot(sum(Subtotal) for Year in ([2011],[2012],[2013],[2014],[2015]) ) p


select SalesPersonID,isnull([2011],0) as [2011],[2012],[2013],[2014],[2015]
from(
    select
        SalesPersonID, --1 sorfejléc
        year(orderdate) as Year, --2 oszlopfejléc
        Subtotal --4 melyik oszlopot összesítjük
    from Orders
) o
pivot(sum(Subtotal) for Year in ([2011],[2012],[2013],[2014],[2015]) ) p

--Összesítrsük az eladásokat évenként és országonként
-- ez a szűk halmazunk
select year(o.Orderdate) as Year, c.Country, o.Subtotal
from Orders o 
inner join Customer c on c.CustomerID = o.CustomerID


--pivot
select Country,[2011],[2012],[2013],[2014],[2015]
from(
    select year(o.Orderdate) as Year, c.Country, o.Subtotal
    from Orders o 
    inner join Customer c on c.CustomerID = o.CustomerID
) o
pivot(sum(Subtotal) for Year in ([2011],[2012],[2013],[2014],[2015])) p

--transzponálás sor-oszlop csere

select Year,[DE],[GB],[AU],[CA],[FR],[US]
from(
    select year(o.Orderdate) as Year, c.Country, o.Subtotal
    from Orders o 
    inner join Customer c on c.CustomerID = o.CustomerID
) o
pivot(sum(Subtotal) for Country in ([DE],[GB],[AU],[CA],[FR],[US])) p


select Year,[DE],[GB],[AU],[CA],[FR],[US],[UNKNOWN] as [NULL]
from(
    select year(o.Orderdate) as Year, isnull(c.Country,'UNKNOWN') as Country, o.Subtotal
    from Orders o 
    inner join Customer c on c.CustomerID = o.CustomerID
) o
pivot(sum(Subtotal) for Country in ([DE],[GB],[AU],[CA],[FR],[US],[UNKNOWN])) p

-- month
select Year,Month,[DE],[GB],[AU],[CA],[FR],[US],[UNKNOWN] as [NULL]
from(
    select year(o.Orderdate) as Year, month(o.Orderdate) as Month, isnull(c.Country,'UNKNOWN') as Country, o.Subtotal
    from Orders o 
    inner join Customer c on c.CustomerID = o.CustomerID
) o
pivot(sum(Subtotal) for Country in ([DE],[GB],[AU],[CA],[FR],[US],[UNKNOWN])) p
order by 1,2
-- minden oszlop, ami visszajön a subquery-ből, automatikusan a group by részévé válik


