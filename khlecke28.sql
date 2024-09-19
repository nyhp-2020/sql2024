declare @Datum datetime = '2000'

declare @Datum datetime = '31/1/2023' --típus kényszerítés, implicit típus konverzió (a háttérben történik), típus castolás

declare @Datum datetime = convert(datetime,'31/01/2023',103) -- explicit típus konverzió (én rendelkezem róla)

declare @Datum datetime = convert(datetime,'31012023',103)

declare @Datum datetime = try_convert(datetime,'31012023',103) -- ha nem lehet konvertálni, akkor is sikeres futás lesz, null eredménnyel

declare @Datum datetime = cast('31/01/2023' as datetime) -- explicit típus kényszerítés

declare @Datum datetime = try_cast('31/01/2023' as datetime) -- ha nem sikerül, null érték

select @Datum