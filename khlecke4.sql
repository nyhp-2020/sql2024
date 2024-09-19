--union all (közös előfordulások duplázódnak)
select *
from (
    VALUES(1,'Budapest'),
            (1,'Szeged'),
            (1,'Miskolc'),
            (1,'Debrecen'),
            (1,'Győr')
) varos(ID,Nev)

union ALL

select 1, 'Budapest'

--union (csak egy előfordulás); ez teljesítmény igényesebb
select *
from (
    VALUES(1,'Budapest'),
            (1,'Szeged'),
            (1,'Miskolc'),
            (1,'Debrecen'),
            (1,'Győr')
) varos(ID,Nev)

union

select 1, 'Budapest'

-- distinct-el
select distinct *
from(
    select *
    from (
    VALUES(1,'Budapest'),
            (1,'Szeged'),
            (1,'Miskolc'),
            (1,'Debrecen'),
            (1,'Győr')
    ) varos(ID,Nev)

    union ALL

    select 1, 'Budapest'
) s




-- a lekérdezések szerkezetének hasonlítania kell egymáshoz (oszlopszám, típus,...) Típuskonverziók lehetségesek.

select *
from (
    VALUES(1,N'Budapest'), --nvarchar típus
            (1,N'Szeged'),
            (1,N'Miskolc'),
            (1,N'Debrecen'),
            (1,N'Győr')
) varos(ID,Nev)

union ALL

select 1, cast(123.45 as nvarchar(10) ) --kézi típuskonverzió

union all  --több lekérdezést is összefűzhetek

select 2, 'ABS'

order by 2 --ez az egész union-al összekapcsolt lekérdezésre vonatkozik és csak a legvégén lehet





--implicit rendezés az union miatt
select *
from (
    VALUES(1,N'Budapest'), --nvarchar típus
            (1,N'Szeged'),
            (1,N'Miskolc'),
            (1,N'Debrecen'),
            (1,N'Győr')
) varos(ID,Nev)

union 

select 1, cast(123.45 as nvarchar(10) ) --kézi típuskonverzió

union  --több lekérdezést is összefűzhetek

select 2, 'ABS'

-- az oszlop fejléceket a legelső lekérdezés határozza meg