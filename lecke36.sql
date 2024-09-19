select *
from Orders
--join Customer on 1 = 1 --ez minden sort minden sorral illeszt a két táblából
join Customer on Orders.CustomerID = Customer.CustomerID --igaz-hamis kifejezés

select Orders.CustomerID, OrderDate, FirstName, LastName --meg kell adni a táblanevet is az egyértelműség kedvéért (minősítés)
from Orders
join Customer on Orders.CustomerID = Customer.CustomerID

select Customer.CustomerID, OrderDate, FirstName, LastName
from Orders
join Customer on Orders.CustomerID = Customer.CustomerID

select Customer.CustomerID, OrderDate, FirstName, LastName
from Orders
inner join Customer on Orders.CustomerID = Customer.CustomerID -- join inner join
where FirstName like 'A%'  --A-val kezdődő nevek