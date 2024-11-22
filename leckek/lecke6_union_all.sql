-- union / union all

-- Összefűzött lekérdezések hasonlóak. Oszlopszám egyezik, típuskonverzió lehetséges.
-- Eredmény oszlopfejléceit az első lekérdezés oszlopfejlécei határozzák meg.
select *
    from (
    VALUES(1, N'Budapest'),
        (2, N'Szeged'),
        (3, N'Miskolc'),
        (4, N'Debrecen'),
        (5, N'Győr')
    ) varos(ID, Nev)

    union all  --duplikációk
    --union      -- nincs duplikálás
    select 1, 'Budapest'

--Kényszerített típuskonverzió, több mint két halmaz,rendezés

select ID, Nev as Város
    from (
    VALUES(1, N'Budapest'),
        (2, N'Szeged'),
        (3, N'Miskolc'),
        (4, N'Debrecen'),
        (5, N'Győr')
    ) varos(ID, Nev)

    union all

    select 1 as A, cast(123.45 as nvarchar(10)) as B

    union all

    select 2, 'ABC'
    order by 2  -- teljes lekérdezésre vonatkozik. Csak a végén lehet.

--union  Teljesítmény szempontjából nem előnyös.
select *
    from (
    VALUES(1, N'Budapest'),
        (2, N'Szeged'),
        (3, N'Miskolc'),
        (4, N'Debrecen'),
        (5, N'Győr')
    ) varos(ID, Nev)

    union      -- nincs duplikálás
    
 select 1, 'Budapest'

    --vagy

select distinct *
from (              --allekérdezés
 select *
    from (
    VALUES(1, N'Budapest'),
        (2, N'Szeged'),
        (3, N'Miskolc'),
        (4, N'Debrecen'),
        (5, N'Győr')
    ) varos(ID, Nev)

    union all
    
 select 1, 'Budapest'
) s