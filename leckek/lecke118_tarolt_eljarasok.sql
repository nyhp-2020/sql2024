use MyDB
go

create or alter procedure uspFirstProc
	@param1 int
as
go -- eddig tart az elj�r�s k�dja


create or alter procedure uspFirstProc
	@param1 int = 0 --alap�rtelmezett �rt�k
as
go -- eddig tart az elj�r�s k�dja

--h�v�s param�terral
exec uspFirstProc @param1 = 1 --n�v szerinti param�ter megad�s (sorrend mindegy)

-- ha van alap�rtelmezett �rt�ke a param�ternek, elhagyhatom a megad�s�t
exec uspFirstProc

exec uspFirstProc 1  --sorrend szerinti param�ter megad�s (sorrend fontos!)