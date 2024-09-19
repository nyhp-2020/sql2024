--0. Listázzuk ki a vásárlókat a következő formátumban: CustomerID, Title FirstName LastName (Country, City)
select CustomerId,
       isnull(Title + ' ','') + FirstName +' '+ LastName + isnull(' (' + Country +',' + City + ')',''),
       concat(isnull(Title + ' ',''),FirstName,' ',LastName,isnull(' (' + Country +',' + City + ')',''))
from Customer
--where country is null

select CustomerId,
       cast(CustomerID as varchar(10)) +' - '+ isnull(Title + ' ','') + FirstName +' '+ LastName + isnull(' (' + Country +',' + City + ')',''),
       concat(CustomerId,' - ',Title + ' ','',FirstName,' ',LastName,' (' + Country +',' + City + ')','')
from Customer
--where country is not null

-- 1. A termék táblában az összes termék listaárát csökkentsük 10%-al. Az eredmény 2 tizedes pontosságú legyen:
select ProductID, Name, ListPrice,
    round(ListPrice * 0.9, 2),
    cast(ListPrice * 0.9 as decimal(16,2))   
from Product


--2. Számoljuk meg, hogy hány tagból áll a termék ProductNumber oszlopa (hány kötőjel van benne):
-- Hány kötőjel van a szövegben
select
    ProductID,
    Name,
    ProductNumber,
    len(ProductNumber),
    replace(ProductNumber,'-',''),
    len(replace(ProductNumber,'-','')),
    len(ProductNumber) - len(replace(ProductNumber,'-','')) + 1 as parts
from Product

-- 4. A vásárlás részletezésénél jelenítsük meg %-os formában,
-- hohy az adott termék sor hány százalékát teszi ki a teljes vásárlásnak.
select o.OrderID, o.SubTotal, od.OrderDetailID, od.LineTotal, format(LineTotal / SubTotal,'P2') --formázás százalék, 2 tizedes pontosság
from OrderDetail od
inner join Orders o on o.OrderId = od.OrderID