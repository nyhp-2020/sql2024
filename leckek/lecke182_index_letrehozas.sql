select *
from Customer
where FirstName = 'Laura'

create index ix_FirstName on Customer(FirstName)

select CustomerID
from Customer
where FirstName = 'Laura'

select CustomerID, FirstName, LastName
from Customer
where FirstName = 'Laura'

select *
from Product
where ProductName like 'Road%'

select *
from Product
where ProductName like 'Chain'

--statisztika frissítés
update statistics dbo.Product([IX_Product_ProductName]) --with fullscan