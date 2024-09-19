select      
    SalesPersonID,    
    sum(case when year(OrderDate) = 2011 then cast(SubTotal as decimal(16, 2)) end) as [2011],    
    sum(case when year(OrderDate) = 2012 then SubTotal end) as [2012],    
    sum(case when year(OrderDate) = 2013 then SubTotal end) as [2013],    
    sum(case when year(OrderDate) = 2014 then SubTotal end) as [2014],    
    sum(case when year(OrderDate) = 2015 then SubTotal end) as [2015],    
    sum(case when year(OrderDate) = 2016 then SubTotal end) as [2016]
from Orders
group by SalesPersonID


select --CustomerID, FirstName, LastName, Country,
    case 
        when Country = 'US' then 'United States'
        when Country = 'DE' then 'Germany'
        when Country = 'HU' then 'Hungary'
        else 'Other'
    end as CountryName,
    count(*) as Count
from Customer
group by case 
           when Country = 'US' then 'United States'
           when Country = 'DE' then 'Germany'
           when Country = 'HU' then 'Hungary'
           else 'Other'
         end

select CustomerID, FirstName, LastName, Country,
    case Country 
        when 'US' then 'United States'
        when 'DE' then 'Germany'
        when 'HU' then 'Hungary'
        else 'Other'
    end as CountryName
from Customer

select --CustomerID, FirstName, LastName, Country,
    IIF(Country = 'US', 'United States', 'Other') as CountryName,
    count(*)
from Customer
group by IIF(Country = 'US', 'United States', 'Other')

select Country, string_agg(cast(City as nvarchar(max)), ';')
from Customer
group by Country
