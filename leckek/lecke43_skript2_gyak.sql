--gyak2
declare @CustomerName nvarchar(100) = 'János Horváth'

if not exists(select * from dbo.Customer where (FirstName + ' ' + LastName) = @CustomerName)
    begin
        print 'Noncs ilyen vásárló!'
        return
    end

if not exists(
    select *
    from Orders o 
    inner join Customer c on c.CustomerID = o.CustomerID
    where (c.FirstName + ' ' + c.LastName) = @CustomerName
)
    begin
        print 'Noncs vásárlása!'
        return
    end

-- ha van vásásrlás, itt megjelenik
select *
from Orders o 
inner join Customer c on c.CustomerID = o.CustomerID
where (c.FirstName + ' ' + c.LastName) = @CustomerName