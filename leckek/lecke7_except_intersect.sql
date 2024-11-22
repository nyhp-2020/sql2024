--except,intersect
select ID, Nev as Város
    from (
    VALUES(1, N'Budapest'),
        (2, N'Szeged'),
        (3, N'Miskolc'),
        (4, N'Debrecen'),
        (5, N'Győr')
    ) varos(ID, Nev)

    except          --kivonás, kivétel
                    -- oracle,mysql minus

    select 1, 'Budapest'

-- vagy left join + is null szűrés a jobb oldali táblára
select s.*--,a.*
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

    intersect       --metszet

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

--példa
select distinct Country
from Customer
where Country is not null
--Egészítsük ki ezt a listát néhány elemmel anélkül, hogy beszurnánk őket a Country táblába.

union all

select 'IT'

union all

select 'NL'

--vagy

select distinct Country
from Customer
where Country is not null

union all select 'IT'
union all select 'NL'
union all select 'RS'
union all select 'RO'
union all select 'HR'
union all select 'AA'
union all select 'ES'

--Ne használjun uniont, ha egyedi értékeket adunk meg. Feleslegesen terheljük a szervert...
--Csak akkor, ha nem vagyunk biztosak benne, hogy a megadott értékek nem szerepelnek a táblában.
