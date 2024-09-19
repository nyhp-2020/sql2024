SELECT 
YEAR(OrderDate) AS [Year],
MONTH(OrderDate) AS [Month],
--Subtotal,
COUNT(*) AS Orders,
MAX(Subtotal) AS Maxtotal,
AVG(SubTotal) AS Average
FROM Orders
GROUP BY YEAR(OrderDate),MONTH(OrderDate)
ORDER BY 1, 2
--Amit a group by -ba beírunk, azt nem kötelező megjeleníteni
--Amit a szelect listába beírunk mint mezőt,azt be kell írni a group by-ba is v. egy összesítő függvényen belül kell lenni a szelect listában