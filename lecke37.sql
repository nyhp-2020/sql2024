select ProductID, Name
from Product
where ProductSubcategoryID = 17

--left join bal oldalról kérek mindent
select Product.ProductID, Name, Count(*)  -- ez minen Product sort is megszámol, ha nem volt eladás, akkor is
from Product
left join OrderDetail on Product.ProductID = OrderDetail.ProductID
where ProductSubcategoryID = 17
group by Product.ProductID, Name

select Product.ProductID, Name, Count(OrderDetail.OrderID) -- ahol nem volt eladás ez 0-t ad vissza
from Product
left join OrderDetail on Product.ProductID = OrderDetail.ProductID
where ProductSubcategoryID = 17
group by Product.ProductID, Name

--distinct
select distinct Product.ProductID, Name --ekkor nem összesíthetünk 
from Product
left join OrderDetail on Product.ProductID = OrderDetail.ProductID
where ProductSubcategoryID = 17

--distinct-el egyedi sorokat kapok vissza
select distinct City
from Customer

--right join nem használatos...
-- minden sor a jobb oldali táblából
--distnct right join-al
select distinct Product.ProductID, Name --ekkor nem összesíthetünk 
from OrderDetail
right join Product on Product.ProductID = OrderDetail.ProductID
where ProductSubcategoryID = 17