create view OrderDetail
as
select OrderID,ProductID,sum(Quantity) as Quantity
from OrderLines
group by OrderID, ProductID
go

--
select * from OrderDetail

select *
from OrderLines
order by OrderID,InventoryID,ProductID

select OrderID,ProductID,sum(Quantity) as Quantity
from OrderLines
group by OrderID, ProductID

select o.OrderID,ol.ProductID,sum(Quantity) as Quantity
from Orders o
left join OrderLines ol on ol.OrderID = o.OrderID
group by o.OrderID, ol.ProductID