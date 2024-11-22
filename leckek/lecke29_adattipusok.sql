declare @Valtozo int = 0,
        @Szam bigint = -1,
        --@Harmadik date = '1900-01-01',
        @Harmadik datetime = '1900-01-01',
        @Szoveg nvarchar(4000),     --csak a szükséges méretet foglalja le
        --@Szoveg nchar(40),        --mindig lefoglalja a megadott méretet
        @Osszeg float = 123.99,     --tizedes pont van az SQL-ben
        @Memo nvarchar(max)         --nagy szövegek használatához (max 2GB, kettő milliárd)

--egyedi értékadás
set @Valtozo = 123
set @Szam = 1

--tömeges értékadás
select @Valtozo = 333, @Szam = 0, @Harmadik = getdate()


--más változóból
set @Szam = @Valtozo

--lekérdezésből

set @Szam = (select count(*) from Customer)
set @Szam = (select top 1 CustomerID from Customer)

--selct-el 


select @Szam = CustomerID, @Szoveg = FirstName + ' ' + LastName --összes sor értékét beírja egymás után
from Customer

select
    @Valtozo as [@Valtozo],
    @Szam as [@Szam],
    @Harmadik as [@Harmadik],
    @Szoveg as [@Szoveg],
    @Osszeg as [@Osszeg]

declare @guid UNIQUEIDENTIFIER
set @guid = newid()
select @guid

select newid()

select * from sys.types --összes típus lekérdezése