-- 0. Listázzuk ki a vásárlókat a következő formátumban: CustomerID - Title FirstName LastName ( Country, City )
select 
    CustomerID, 
    cast(CustomerID as varchar(10)) + ' - ' + isnull(Title + ' ', '') + FirstName + ' ' + LastName + isnull(' (' + Country + ',' + City + ')', ''),
    concat(CustomerID, ' - ', Title + ' ', '', FirstName, ' ', LastName, ' (' + Country + ',' + City + ')')
from Customer

-- 1. A termék táblában az összes termék listaárát csökkentsük 10%-al. Az eredmény 2 tizedes pontosságú legyen:
select 
    ProductID, Name, ListPrice, 
    round(ListPrice * 0.9, 2),
    cast(ListPrice * 0.9 as decimal(16,2))
from Product

-- 2. Számoljuk meg, hogy hány tagból áll a termék ProductNumber oszlopa (hány kötőjel van benne):
-- Hány kötőjel van a szövegben
--select * from Product
select 
    ProductID, 
    Name, 
    ProductNumber, 
    len(ProductNumber), 
    replace(ProductNumber, '-', ''),
    len(replace(ProductNumber, '-', '')),
    len(ProductNumber) - len(replace(ProductNumber, '-', '')) + 1 as parts
from Product

-- 4. A vásárlás részletezésénél jelenítsük meg %-os formában, 
-- hogy az adott termék sor hány százalékát teszi ki a teljes vásárlásnak.
select o.OrderID, o.SubTotal, od.OrderDetailID, LineTotal, format(LineTotal / SubTotal, 'P2')
from OrderDetail od
inner join Orders o on o.OrderID = od.OrderID

