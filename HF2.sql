SELECT *
FROM Orders
WHERE SalesPersonID IS NULL

select count(*), sum(SubTotal)
from Orders
where SubTotal >= 50000

select count(*), sum(SubTotal)
from Orders
WHERE SubTotal >= 10000 AND SubTotal <= 100000

select count(*), sum(SubTotal), AVG(SubTotal)
from Orders
WHERE SubTotal >= 10000 AND SubTotal <= 100000

select count(*) as SalesAmount, sum(SubTotal) as TotalSales, AVG(SubTotal) as AvgSales
from Orders
WHERE SubTotal >= 10000 AND SubTotal <= 100000

select
SalesPersonID,
sum(SubTotal) as [Total]
from Orders
group by SalesPersonID

select
SalesPersonID,
sum(SubTotal) as [Total]
from Orders
WHERE SalesPersonID IS NOT NULL
group by SalesPersonID

select
SalesPersonID,
sum(SubTotal) as [Total]
from Orders
WHERE SalesPersonID IS NOT NULL AND YEAR(OrderDate) = 2012
group by SalesPersonID

select
SalesPersonID,
sum(SubTotal) as [Total],
count(*) AS  SalesAmount
from Orders
WHERE SalesPersonID IS NOT NULL AND YEAR(OrderDate) = 2012
group by SalesPersonID

SELECT YEAR(OrderDate) AS Year, MONTH(OrderDate) AS Month, SUM(SubTotal) AS TotalSales
FROM Orders
GROUP BY YEAR(OrderDate),MONTH(OrderDate)
ORDER BY Year, Month

select
SalesPersonID,
sum(case when year(OrderDate) = 2011 then SubTotal end) as [2011]
from Orders
group by SalesPersonID

select
SalesPersonID,
sum(case when year(OrderDate) = 2011 then SubTotal end) as [2011],
sum(case when year(OrderDate) = 2012 then SubTotal end) as [2012],
sum(case when year(OrderDate) = 2013 then SubTotal end) as [2013],
sum(case when year(OrderDate) = 2014 then SubTotal end) as [2014],
sum(case when year(OrderDate) = 2015 then SubTotal end) as [2015],
sum(case when year(OrderDate) = 2016 then SubTotal end) as [2016],
SUM(SubTotal) AS Total
from Orders
group by SalesPersonID