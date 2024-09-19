Select
SalesPersonID,
SUM(case when year(OrderDate) = 2011 then SubTotal end) as [2011],
SUM(case when year(OrderDate) = 2012 then SubTotal end) as [2012],
SUM(case when year(OrderDate) = 2013 then SubTotal end) as [2013],
SUM(case when year(OrderDate) = 2014 then SubTotal end) as [2014],
SUM(case when year(OrderDate) = 2015 then SubTotal end) as [2015],
SUM(case when year(OrderDate) = 2016 then SubTotal end) as [2016]
from Orders
group by SalesPersonID



Select
SalesPersonID,
OrderDate,
case when year(OrderDate) = 2011 then SubTotal end as [2011],
case when year(OrderDate) = 2012 then SubTotal end as [2012],
case when year(OrderDate) = 2013 then SubTotal end as [2013],
case when year(OrderDate) = 2014 then SubTotal end as [2014],
case when year(OrderDate) = 2015 then SubTotal end as [2015],
case when year(OrderDate) = 2016 then SubTotal end as [2016]
from Orders

-- case when
SELECT CustomerID, FirstName, LastName, Country,
    case 
        --when  1 = 1 then 'United States' -- ha egy sor igaz, nem megy a többire
        when Country = 'US' then 'United States' --itt összetett feltételt is megadhatunk
        when Country = 'DE' then 'Germany'
        when Country = 'HU' then 'Hungary'
        else 'Other' --else ág hiányában null-t ad vissza
    end as CountryName
from Customer

--group by a case- re
SELECT --CustomerID, FirstName, LastName, Country,
    case Country
        when  'US' then 'United States' -- itt egyenlőség vizsgálat van
        when  'DE' then 'Germany'
        when  'HU' then 'Hungary'
        else 'Other' --else ág hiányában null-t ad vissza
    end as CountryName,
    count(*) as Count
from Customer
group by case Country
        when  'US' then 'United States' -- itt egyenlőség vizsgálat van
        when  'DE' then 'Germany'
        when  'HU' then 'Hungary'
        else 'Other' --else ág hiányában null-t ad vissza
    end

--vagy
SELECT CustomerID, FirstName, LastName, Country,
    case Country
        when  'US' then 'United States' -- itt egyenlőség vizsgálat van
        when  'DE' then 'Germany'
        when  'HU' then 'Hungary'
        else 'Other' --else ág hiányában null-t ad vissza
    end as CountryName
from Customer

--group by a case -re
SELECT --CustomerID, FirstName, LastName, Country,
    case Country
        when  'US' then 'United States' -- itt egyenlőség vizsgálat van
        when  'DE' then 'Germany'
        when  'HU' then 'Hungary'
        else 'Other' --else ág hiányában null-t ad vissza
    end as CountryName
from Customer
group by case Country
        when  'US' then 'United States' -- itt egyenlőség vizsgálat van
        when  'DE' then 'Germany'
        when  'HU' then 'Hungary'
        else 'Other' --else ág hiányában null-t ad vissza
    end

--IIF
SELECT CustomerID, FirstName, LastName, Country,
    IIF(Country = 'US', 'United States', 'Other') as CountryName --kétirányú elágazásokhoz
from Customer

--group by az iif-re
SELECT --CustomerID, FirstName, LastName, Country,
    IIF(Country = 'US', 'United States', 'Other') as CountryName, --kétirányú elágazásokhoz
    count(*)
from Customer
group by IIF(Country = 'US', 'United States', 'Other')
