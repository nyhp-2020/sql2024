
--HF 5
--I Válaszok:
/*
1. b, 2. a, 3. c, 4. a, 5. c, 6. b, 7. c, 8. a,9. b,10. c;
*/
--II 3364,14 MB a WideWorldImporters adatbázis mérete
--III lekérdezés:
  select DATEDIFF(day,oh.OrderDate,oh.ShipDate) DayCount, count(DATEDIFF(day,oh.OrderDate,oh.ShipDate)) OrderCount
  from Sales.SalesOrderHeader oh
  group by DATEDIFF(day,oh.OrderDate,oh.ShipDate)

