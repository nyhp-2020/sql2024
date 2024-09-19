/*
-Írjunk egy olyan lekérdezést, amely egy változó alapján (@OsszesOrszag) kilistázza az összes országot, ha a változó értéke 1
- Ha a változó értéke 0, akkor csak azokat az országokat listázza ki, ahol volt vásárlás
- Jelenítsük meg a vásárlások számát is egy külön oszlopban.
*/
declare @OsszesOrszag bit = 0
declare @SQL nvarchar(max)

--statikus sql

/*
select c.Country, count(o.OrderID) as Orders --hány rendelés van
from  Customer c 
--inner join Orders o on o.CustomerID = c.CustomerID
left join Orders o on o.CustomerID = c.CustomerID
group by c.Country
order by c.Country
*/

set @SQL = '
select c.Country, count(o.OrderID) as Orders
from  Customer c 
'+ case when @OsszesOrszag = 1 then 'left' else 'inner' end + ' join Orders o on o.CustomerID = c.CustomerID
group by c.Country
order by c.Country
'

print @SQL
exec(@SQL)