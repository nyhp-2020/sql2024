-- t�bla �tnevez�s (t�rolt elj�r�sok elromolhatnak!)
exec sp_rename 'NewProducts','NP'--,'OBJECT' -- ez alap�rtelmezett

-- �gy is lehetett volna n�v szerinti param�terekkel
exec sp_rename @objname = 'NewProducts', @newname = 'NP', @objtype = 'OBJECT'


-- oszlop �tnevez�s
exec sp_rename 'NP.ProductID', 'ID', 'COLUMN'

exec sp_rename @objname = 'NP.ProductID',@newname = 'ID', @objtype = 'COLUMN'

go

sp_refreshview -- view friss�t�se ha a benne szerepl� t�bl�k v�ltoztak

--inform�ci�k, eredm�nyhalmazokkal t�r vissza
exec sp_help 'dbo.Country'

exec sp_help 'dbo.Customer'

-- a szerveren jelenleg m�k�d� �sszes folyamat
exec sp_who

-- plusz inform�ci�kkal
exec sp_who2