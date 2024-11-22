--declare @Valtozo int 
--declare @Szam bigint

--kezdeti értékadás
declare @Valtozo int = 0,
        @Szam bigint = -1,
        @Harmadik date = '1900-01-01',
        @Szoveg nvarchar(100)

--kezdeti érték NULL, ha nem adunk meg semmit a declare-ben

--egyedi értékadás
set @Valtozo = 123
set @Szam = 1

--tömeges értékadás
select @Valtozo = 333, @Szam = 0, @Harmadik = '2023-01-01'


--más változóból
set @Szam = @Valtozo

--lekérdezésből

set @Szam = (select count(*) from Customer)
set @Szam = (select top 1 CustomerID from Customer)

--selct-el 


select @Szam = CustomerID, @Szoveg = FirstName + ' ' + LastName --összes sor értékét beírja egymás után
from Customer

select @Valtozo as [@Valtozo],@Szam as [@Szam], @Harmadik as [@Harmadik], @Szoveg as [@Szoveg] 
