
-- Az utolsó 3 vásárlás
SELECT top 3 *
from OrderDetails
WHERE ProductID = 751
order by OrderID desc

-- a 10-es termékkategória tételei
SELECT *
FROM Product
WHERE   ProductSubcategoryID =10

SELECT *
FROM Product p
CROSS APPLY(   -- csak akkor van eredménye a külső lekérdezésnek, ha a belső ad vissza sort
    SELECT top 3 *
    from OrderDetails od
    WHERE od.ProductID = p.ProductID
    order by OrderID desc
) AS top3  -- kell adni aliasnevet az allekérdezésnek
WHERE    p.ProductSubcategoryID =10

SELECT *
FROM Product p
CROSS APPLY(
    SELECT top 3 *
    from OrderDetails od
    WHERE od.ProductID = p.ProductID 
    and 1 = 0  --ha a belső lekérdezés nem ad vissza sort, akkor a külső sem
    order by OrderID desc
) AS top3  -- kell adni aliasnevet az allekérdezésnek
WHERE    p.ProductSubcategoryID =10

-- cross apply -- inner join szerű
-- Csak akkor van eredmény, ha a belső lekérdezés legalább 1 sorral visszatér
-- pl 803 ProductID-hez nincs eladás, arra nem jönnek vissza sorok
SELECT *
FROM Product p
CROSS APPLY(
    SELECT top 3 LineTotal, OrderQty
    from OrderDetails od
    WHERE od.ProductID = p.ProductID
    order by OrderID desc
) AS top3
WHERE    p.ProductSubcategoryID =10

-- itt nem jön egy sor sem belül, így kívül sem
SELECT *
FROM Product p
CROSS APPLY(
    SELECT top 3 LineTotal, OrderQty
    from OrderDetails od
    WHERE od.ProductID = p.ProductID
    AND 1 =0
    order by OrderID desc
) AS top3
WHERE    p.ProductSubcategoryID =10


-- outer apply --outer join szerű
--Akkor is van eredmény (1 sor), ha a belső lekérdezés nem tér vissz egy sorral sem
SELECT *
FROM Product p
OUTER APPLY(    -- outer joinhoz v. left joinhoz hasonlít (ha a belső lekérdezés nem ad vissza sorokat, null értékeket ír a mezőkbe)
    SELECT top 3 LineTotal, OrderQty
    from OrderDetails od
    WHERE od.ProductID = p.ProductID
    order by OrderID desc
) AS top3
WHERE    p.ProductSubcategoryID = 10

SELECT p.Name, top3.OrderQty  -- így hivatkozom az alias-os lekérdezés névre
FROM Product p
OUTER APPLY(
    SELECT top 3 LineTotal, OrderQty
    from OrderDetails od
    WHERE od.ProductID = p.ProductID
    order by OrderID desc
) AS top3
WHERE    p.ProductSubcategoryID =10

SELECT p.Name
FROM Product p
OUTER APPLY(
    SELECT top 3 LineTotal, OrderQty
    from OrderDetails od
    WHERE od.ProductID = p.ProductID
    order by OrderID desc
) AS top3 -- itt kötelező az aliasnév!
WHERE    p.ProductSubcategoryID = 10


