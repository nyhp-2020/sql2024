SELECT CustomerId,
        SUM(Subtotal) AS Total
FROM Orders
WHERE YEAR(OrderDate) = 2011
GROUP BY CustomerId
HAVING SUM(Subtotal) > 700  --itt nem lehet használni az alias-okat, csak az ORDER BY-nál
--HAVING Total > 700 -- ez nem működik

SELECT CustomerId,
        MAX(Subtotal) AS Total
FROM Orders
WHERE YEAR(OrderDate) > 2013
GROUP BY CustomerId
--HAVING SUM(Subtotal) > 2000 --A HAVING -ben szereplő értéknek nem kötelező szerepelni a SELECT utáni listában
--HAVING COUNT(*) > 1 -- egynél több tagú csoportok
HAVING SUM(Subtotal) > 2000 AND COUNT(*) > 1