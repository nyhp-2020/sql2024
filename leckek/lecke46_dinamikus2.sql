declare @OsszesOrszag bit = 0
declare @SQL nvarchar(max)

--statikus sql-el
--országok, ahol vásárlás volt
select c.Country, count(o.OrderID) as Orders
from Customer c 
inner join Orders o on o.CustomerID = c.CustomerID
group by c.Country
order by c.Country

--minden ország
select c.Country, count(o.OrderID) as Orders
from Customer c 
left join Orders o on o.CustomerID = c.CustomerID
group by c.Country
order by c.Country

--dinamikusan
declare @OsszesOrszag bit = 0
declare @SQL nvarchar(max)

set @SQL = '
select c.Country, count(o.OrderID) as Orders
from Customer c 
' + case when @OsszesOrszag = 1 then 'left' else 'inner' end + ' join Orders o on o.CustomerID = c.CustomerID
group by c.Country
order by c.Country
'

print @SQL
exec(@SQL)