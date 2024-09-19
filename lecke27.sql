SELECT Country
from customer
GROUP BY Country

SELECT Country, COUNT(CustomerID) --Ha valahol NULL érték van, azt a Count nem számolja
from customer
GROUP BY Country

SELECT Country, COUNT(*) -- Ez mindent számol
from customer
GROUP BY Country

SELECT Country, COUNT(*), count(Title) --Ahol a Title ki van töltve
from customer
GROUP BY Country

-- Hány és milyen országok vannak és hány vásárló van bennük
SELECT Country, COUNT(*) as Customers -- A countnak megadhatunk oszlopnevet, *-ot, sztringet,... null-t nem!
from customer
GROUP BY Country

--Hány sor van az Orders táblában?
select COUNT(*)
from Orders --Ha nem írok Group by-t, egyetlen nagy csoport lesz az egész táble

--Bontsuk le a darabszámot évenként, mekkora volt az össz vásárlás évemként
select COUNT(*)
from Orders
GROUP BY Year(OrderDate) -- A csoportot nem kötelező megjeleníteni

-- Itt az évek is látszanak mint csoportok
select Year(OrderDate) as [Year],COUNT(*) as [count] -- szögletes zárójelek kiküszöbölik a kulcszóval ütközés problémákat
from Orders
GROUP BY Year(OrderDate)
ORDER BY 1 --első oszlop szerint (év) rendez

--vagy
select Year(OrderDate) as [Year],COUNT(*) as [count] -- szögletes zárójelek kiküszöbölik a kulcszóval ütközés problémákat
from Orders
GROUP BY Year(OrderDate)
ORDER BY [Year] --A megadott nevű (alias) oszlop szerint rendez (alias akár szöletes zárójelben)

-- + évenkénti össz vásárlás
select Year(OrderDate) as [Year],COUNT(*) as [count], sum(subtotal) as Total
from Orders
GROUP BY Year(OrderDate)
ORDER BY [Year]

-- + évenkénti össz vásárlás + a legnagyobb vásárlás + átlag
select
    Year(OrderDate) as [Year],
    COUNT(*) as [count],
    sum(subtotal) as Total,
    max(SubTotal) as MaxTotal,
    avg(Subtotal) as AvgTotal
from Orders
GROUP BY Year(OrderDate)
ORDER BY [Year]
