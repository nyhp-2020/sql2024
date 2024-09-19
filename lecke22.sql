SELECT  City,FirstName + ' ' +LastName as FullName
from Customer
WHERE Country = 'US' --nem is szerepel a megjelenített mezők között
ORDER BY 1 DESC, 2 ASC

SELECT
    City,
    FirstName + ' ' +LastName as FullName,
    Country
from Customer
WHERE (Country = 'US' or Country = 'AU' or Country = 'GB')
    and FirstName like 'A%'-- 'A_' csak egy 'A[%]%' A%-al kezdődik,'[a-c0-9]___9'
ORDER BY 1 DESC, 2 ASC

SELECT
    City,
    FirstName + ' ' +LastName as FullName,
    Country
from Customer
WHERE Country in ('US' ,'AU' , 'GB')
and FirstName like 'A%'
ORDER BY 1 DESC, 2 ASC

-- a FirstName A vagy S betűvel kezdődjön
SELECT *
FROM Customer
WHERE Country in ('US' ,'AU' , 'GB')
AND FirstName like '[a,s]%'
--vagy
SELECT *
FROM Customer
WHERE Country in ('US' ,'AU' , 'GB')
AND (FirstName like 'a%' or FirstName like 's%')

-- + a LastName 'Johnson'-ra végződik
SELECT *
FROM Customer
WHERE Country in ('US' ,'AU' , 'GB')
AND (FirstName like 'a%' or FirstName like 's%')
AND LastName like '%Johnson'

--bármi lehet a LastName
SELECT *
FROM Customer
WHERE Country in ('US' ,'AU' , 'GB')
AND (FirstName like 'a%' or FirstName like 's%')
AND LastName like '%%' --szűrő mező értékét a %-ok közé szúrhatjuk
-- like '%'+ @var +'%'