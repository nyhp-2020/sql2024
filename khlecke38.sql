/*
1. Írjunk egy olyan scriptet, amelynek van egy bemeneti változója, amelyben átadjuk a teljes nevét
2. Ha a megadott teljes nevű vásárló nem létezik, akkor jelenítsünk meg egy üzenetet, hogy nincs ilyen és lépjünk ki.
3. Ha a vásárlónak nincs vásárlása, akkor jelenítsünk megy egy üzenetet, hogy nincs vásárlása és lépjünk ki.
4. Ha van vásárlás, akkor jelenítsük meg azokat eredményhalmazként
*/

declare @CustomerName nvarchar(100) = 'Jon Yang'

if not exists(select * from dbo.Customer where (FirstName + ' ' + LastName) = @CustomerName)
    begin
    print 'Nincs ilyen vásárló'
    return
    end

if not exists(
    select *
    from Orders o
    inner join Customer c on c.CustomerID = o.CustomerID
    where (c.FirstName + ' ' + c.LastName) = @CustomerName
)
    begin
    print 'Nincs vásárása !'
    return
    end
-- megjelenítés
select *
from Orders o
inner join Customer c on c.CustomerID = o.CustomerID
where (c.FirstName + ' ' + c.LastName) = @CustomerName



-- kipróbálás
select *
from Orders o
inner join Customer c on c.CustomerID = o.CustomerID
where (c.FirstName + ' ' + c.LastName) = 'Jon Yang'