-- eladások 2011 első negyedévéből
SELECT * from Orders
where OrderDate BETWEEN '2011-04-01' and '2011-06-30'

--vagy

SELECT * from Orders
where OrderDate >= '2011-04-01' and  OrderDate <= '2011-06-30'

--vagy
SELECT * from Orders
where Year(OrderDate) =2011
and  Month(OrderDate) in (4,5,6)

--eladások 2012-ből és 2013-ból
SELECT * from Orders
where OrderDate between '2012-01-01' and  '2013-12-31'

--vagy
SELECT * from Orders
where Year(OrderDate) = 2012 or YEAR(OrderDate) = 2013

--vagy
SELECT * from Orders
where Year(OrderDate) between  2012 and 2013 --előbb alsó utána a felső

--vagy
SELECT * from Orders
where Year(OrderDate) in (2012,2013) 

