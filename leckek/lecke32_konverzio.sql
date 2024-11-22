--declare @Datum datetime = '2000'
--declare @Datum datetime = '31/1/2023' --típus kényszerítés, implicit típus konverzió (a háttérben történik)
declare @Datum datetime = convert(datetime, '31/01/2023',103) --https://learn.microsoft.com/en-us/sql/t-sql/functions/cast-and-convert-transact-sql?view=sql-server-ver16
                                                                -- explicit típus konverzió

declare @Datum2 datetime = try_convert(datetime, '31012023',103) --nem ad hibát,ha nem sikerül, de NULL érték lesz

--declare @Datum3 datetime = cast('31/1/2023' as datetime) --explicit típus kényszerítés

declare @Datum3 datetime = try_cast('31/1/2023' as datetime) --ha nem sikerül, NULL-t ad vissza

select @Datum, @Datum2, @Datum3