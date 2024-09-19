declare @Valtozo int
declare @Szam bigint

--változó lekérdezése
select @Valtozo

-- egy sorban többet
declare @Valtozo int, @Szam bigint, @Harmadik date

--kezdeti értékadás
declare  @Valtozo int =0,
         @Szam bigint = -1,
         @Harmadik date ='1900-01-01',
         @Szoveg nvarchar(100)

select @Valtozo, @Szam,@Harmadik

--értékadás egyenként
set @Valtozo = 123
set @Szam = 1

--értékadás csoportosan
select @Valtozo =333,@Szam =0, @Harmadik = '2023-01-01'

set @Szam = @Valtozo

-- egy lekérdezés eredményének változóba helyezése
-- egy értéket szabad visszaadnia
set @Szam = (select count(*) from Customer)
set @Szam = (select top 1 CustomerID from Customer)

select @Valtozo as [@Valtozo], @Szam as [@Szam],@Harmadik as [@Harmadik]

--declare @Szam bigint

-- összes érték belekerül, végül az utolsó marad bent
select @Szam = CustomerID
from Customer

-- több mezőt adok értékül egy szelect-ben
select @Szam = CustomerID, @Szoveg = FirstName + ' ' + LastName
from Customer

--select @Szam

select @Valtozo as [@Valtozo], @Szam as [@Szam],@Harmadik as [@Harmadik], @Szoveg as [@Szoveg]

--kezdeti értékadás
declare  @Valtozo int =0,
         @Szam bigint = -1,
         @Harmadik datetime = getdate(),
         @Szoveg nvarchar(100) = 'Ez szöveg',
         @Osszeg float = 123.99,
         @Memo nvarchar(max)  --max 2 GB szöveg

select 
    @Valtozo as [@Valtozo],
    @Szam as [@Szam],
    @Harmadik as [@Harmadik], 
    @Szoveg as [@Szoveg],
    @Osszeg as [@Osszeg]

declare @guid UNIQUEIDENTIFIER
select @guid = newid()
select @guid

--típusok lekérdezése
select * from sys.types