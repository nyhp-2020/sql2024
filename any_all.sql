SELECT *
FROM Product
WHERE ProductID = ANY (SELECT ProductID FROM OrderDetail WHERE OrderQty = 10)

SELECT *
FROM Product
WHERE ProductID = SOME (SELECT ProductID FROM OrderDetail WHERE OrderQty = 10)

SELECT *
FROM Product
WHERE ProductID IN (SELECT ProductID FROM OrderDetail WHERE OrderQty = 10)

SELECT *
FROM Product
WHERE ProductID < ALL (SELECT ProductID FROM OrderDetail WHERE OrderQty = 10)

SELECT *
FROM Product
WHERE ProductID > ALL (SELECT ProductID FROM OrderDetail WHERE OrderQty = 10)

SELECT *
FROM OrderDetail

SELECT distinct ProductID FROM OrderDetail WHERE OrderQty = 10