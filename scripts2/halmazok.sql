-- union / union all
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
    order by 2

-- except

    select ID, Nev as Város
    from (
    VALUES(1, N'Budapest'),
        (2, N'Szeged'),
        (3, N'Miskolc'),
        (4, N'Debrecen'),
        (5, N'Győr')
    ) varos(ID, Nev)

    except

    select 1, 'Budapest'
-- vagy left join + is null szűrés a jobb oldali táblára
select s.*
from (
    select ID, Nev as Város
    from (
    VALUES(1, N'Budapest'),
        (2, N'Szeged'),
        (3, N'Miskolc'),
        (4, N'Debrecen'),
        (5, N'Győr')
    ) varos(ID, Nev)
) s
left join (
    select 1 as ID, 'Budapest' as Nev
) a on s.ID = a.ID and s.Város = a.Nev
where a.ID is null

-- instersect
    select ID, Nev as Város
    from (
    VALUES(1, N'Budapest'),
        (2, N'Szeged'),
        (3, N'Miskolc'),
        (4, N'Debrecen'),
        (5, N'Győr')
    ) varos(ID, Nev)

    intersect

    select 1 as A, 'Budapest' as B

-- vagy
select s.*
from (
        select ID, Nev as Város
        from (
        VALUES(1, N'Budapest'),
            (2, N'Szeged'),
            (3, N'Miskolc'),
            (4, N'Debrecen'),
            (5, N'Győr')
        ) varos(ID, Nev)        
) s
inner join (
    select 1 as ID, 'Budapest' as Nev
) a on s.ID = a.ID and s.Város = a.Nev


