-- tábla átnevezés (tárolt eljárások elromolhatnak!)
exec sp_rename 'NewProducts','NP'--,'OBJECT' -- ez alapértelmezett

-- így is lehetett volna név szerinti paraméterekkel
exec sp_rename @objname = 'NewProducts', @newname = 'NP', @objtype = 'OBJECT'


-- oszlop átnevezés
exec sp_rename 'NP.ProductID', 'ID', 'COLUMN'

exec sp_rename @objname = 'NP.ProductID',@newname = 'ID', @objtype = 'COLUMN'

go

sp_refreshview -- view frissítése ha a benne szereplõ táblák változtak

--információk, eredményhalmazokkal tér vissza
exec sp_help 'dbo.Country'

exec sp_help 'dbo.Customer'

-- a szerveren jelenleg mûködõ összes folyamat
exec sp_who

-- plusz információkkal
exec sp_who2