exec uspUpdateProducts
--ha meg akarom adni a @DeleteMissing param�tert
-- nem kell z�r�jel!
-- sorrend szerint
exec uspUpdateProducts 0
exec uspUpdateProducts 1
-- n�v szerint
exec uspUpdateProducts @DeleteMissing = 0
exec uspUpdateProducts @DeleteMissing = 1

-- a visszat�r�si �rt�k kinyer�se
declare @return_value int
exec @return_value = uspUpdateProducts -- @Param1 = 1, ...
select @return_value

-- param�terek megad�sa 121 lecke szerint
declare @rows int -- alap�rtelmezett null
exec uspUpdateProducts @DeleteMissing = 0, @RowsLoaded = 1
exec uspUpdateProducts @DeleteMissing = 0, @RowsLoaded = @rows -- itt �res v�ltoz� �rt�ket adtam meg

-- output param�ter lek�rdez�se
declare @rows int
set @rows = 1
exec uspUpdateProducts @DeleteMissing = 0, @RowsLoaded = @rows output --kifel� ir�nyul� param�ter �tad�s (@rows kap �rt�ket!)
select @rows