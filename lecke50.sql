-- inline subselect a select után

select o.*, c.FirstName, c.LastName
from Orders o
inner join Customer c on c.CustomerID = o.CustomerID

select
        o.*,
        (select c.FirstName from Customer c where c.CustomerID = o.CustomerID) as FirstName
from Orders O
--subselect csak egy oszloppal és egy sorral térhet vissza

-- ha több sor van, hibaüzenet jön futás közben
select
        o.*,
        (select c.FirstName from Customer c where 1 = 1) as FirstName
from Orders O

--ha egy sorral sem térvissza az allekérdezés, null kerül a mezőbe
select
        o.*,
        (select c.FirstName from Customer c where 1 = 0) as FirstName
from Orders O

-- ha több oszlop van, hibaüzenet jön
select
        o.*,
        (select c.FirstName, c.LastName from Customer c where c.CustomerID = o.CustomerID) as FirstName
from Orders O

-- az egy oszlop, ami lehet, lehet számított is
select
        o.*,
        (select c.FirstName + ' ' + c.LastName from Customer c where c.CustomerID = o.CustomerID) as CustomerName
from Orders O

--belül is lehet aliasnevet adni, de felesleges
select
        o.*,
        (select c.FirstName + ' ' + c.LastName as A from Customer c where c.CustomerID = o.CustomerID) as CustomerName
from Orders O

-- a left join kiváltására is használható
-- illetve a left joint használjuk ennek a kiváltására...
select o.*, c.FirstName, c.LastName
from Orders o
left join Customer c on c.CustomerID = o.CustomerID

-- inline subquery
select
        o.*,
        (select c.FirstName + ' ' + c.LastName as A from Customer c where c.CustomerID = o.CustomerID) as CustomerName, -- ez vesz át paramétert kívülről
        (select count(*) from Customer) as AllCustomers --ez külső tábláktól független allekérdezés
from Orders O

-- ha több mezővel akarunk visszatérni, mindegyikre külön allekérdezés kell
select
        o.*,
        (select c.FirstName + ' ' + c.LastName as A from Customer c where c.CustomerID = o.CustomerID) as CustomerName,
        (select c.FirstName  from Customer c where c.CustomerID = o.CustomerID) as FirstName,
        (select c.LastName from Customer c where c.CustomerID = o.CustomerID) as LastName
from Orders O
-- akkor inkább left join v. rendes allekérdezés