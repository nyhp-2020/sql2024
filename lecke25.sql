select * from orders

--eladások összege nagyobb mint 100000
select * from orders
where Subtotal > 100000

--eladások összege 10-20 ezer között
select * from orders
where Subtotal between 10000 and 20000

-- 27% áfa
select *, round(Subtotal * 0.27,2) as Tax
from orders
--where Subtotal between 10000 and 20000

--10 legnagyobb összegű vásárlás
select top 10 * from Orders
ORDER BY Subtotal DESC

-- az utoló vásárlás dátuma
select top 1 * FROM Orders
ORDER BY OrderDate DESC

-- 10 sor a termék táblából
select top 10 * from Product