use MyDB
go

create or alter procedure uspFirstProc
	@param1 int
as
go -- eddig tart az eljárás kódja


create or alter procedure uspFirstProc
	@param1 int = 0 --alapértelmezett érték
as
go -- eddig tart az eljárás kódja

--hívás paraméterral
exec uspFirstProc @param1 = 1 --név szerinti paraméter megadás (sorrend mindegy)

-- ha van alapértelmezett értéke a paraméternek, elhagyhatom a megadását
exec uspFirstProc

exec uspFirstProc 1  --sorrend szerinti paraméter megadás (sorrend fontos!)