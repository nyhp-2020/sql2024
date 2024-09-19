-- 2 dimenziós group by
select
    SalesPersonID,
    sum(case when year(OrderDate) = 2011 then SubTotal else 0 end) as [2011],
    sum(case when year(OrderDate) = 2012 then SubTotal else 0 end) as [2012],
    sum(case when year(OrderDate) = 2013 then SubTotal else 0 end) as [2013],
    sum(case when year(OrderDate) = 2014 then SubTotal else 0 end) as [2014],
    sum(case when year(OrderDate) = 2015 then SubTotal else 0 end) as [2015]
from Orders
group by SalesPersonID

-- privottal
select SalesPersonID, [2011], [2012], [2013], [2014], [2015]
from (
    select SalesPersonID, YEAR(OrderDate) as Year, SubTotal
    from Orders
) o
pivot(sum(SubTotal) for Year in ([2011], [2012], [2013], [2014], [2015])) p

-- Összesítsük az eladásokat évenként és országonként:
select Country, [2011], [2012], [2013], [2014], [2015]
from (
    select year(o.OrderDate) as Year, c.Country, o.SubTotal
    from Orders o
    inner join Customer c on c.CustomerID = o.CustomerID
) o
pivot(sum(SubTotal) for Year in ([2011], [2012], [2013], [2014], [2015])) p

-- transzponálva
select Year, [DE], [GB], [AU], [CA], [FR], [US], [UNKNOWN] as [NULL]
from (
    select year(o.OrderDate) as Year, month(o.OrderDate) as Month, isnull(c.Country, 'UNKNOWN') as Country, o.SubTotal
    from Orders o
    inner join Customer c on c.CustomerID = o.CustomerID
) o
pivot(sum(SubTotal) for Country in ([DE], [GB], [AU], [CA], [FR], [US], [UNKNOWN])) p

