exec uspUpdateProducts
--ha meg akarom adni a @DeleteMissing paramétert
-- nem kell zárójel!
-- sorrend szerint
exec uspUpdateProducts 0
exec uspUpdateProducts 1
-- név szerint
exec uspUpdateProducts @DeleteMissing = 0
exec uspUpdateProducts @DeleteMissing = 1

-- a visszatérési érték kinyerése
declare @return_value int
exec @return_value = uspUpdateProducts -- @Param1 = 1, ...
select @return_value

-- paraméterek megadása 121 lecke szerint
declare @rows int -- alapértelmezett null
exec uspUpdateProducts @DeleteMissing = 0, @RowsLoaded = 1
exec uspUpdateProducts @DeleteMissing = 0, @RowsLoaded = @rows -- itt üres változó értéket adtam meg

-- output paraméter lekérdezése
declare @rows int
set @rows = 1
exec uspUpdateProducts @DeleteMissing = 0, @RowsLoaded = @rows output --kifelé irányuló paraméter átadás (@rows kap értéket!)
select @rows