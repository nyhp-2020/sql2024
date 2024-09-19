-- except (kivéve)  (ma már nem használatos)
select *
from (
    VALUES(1,N'Budapest'), --nvarchar típus
            (1,N'Szeged'),
            (1,N'Miskolc'),
            (1,N'Debrecen'),
            (1,N'Győr')
) varos(ID,Nev)

except  --az oracle-ben, mysql-ben ez minus

select 1, 'Budapest'


-- vagy left join-al + is null szűrés a jobb oldali táblára
select s.*--, a.*
from (
    select ID, Nev as Város
    from (
    VALUES(1,N'Budapest'), --nvarchar típus
            (1,N'Szeged'),
            (1,N'Miskolc'),
            (1,N'Debrecen'),
            (1,N'Győr')
    ) varos(ID,Nev)

) s
left join (
    select 1 as ID, 'Budapest' as Nev
) a on s.ID = a.ID and s.Város = a.Nev
where a.ID is null

--vagy not exist-el is


--intersect (metszet)
select ID, Nev as Város
from (
    VALUES(1,N'Budapest'), --nvarchar típus
            (1,N'Szeged'),
            (1,N'Miskolc'),
            (1,N'Debrecen'),
            (1,N'Győr')
) varos(ID,Nev)

intersect

select 1 as A, 'Budapest' as B

--intersect inner join-al
select s.*
from (
    select ID, Nev as Város
    from (
    VALUES(1,N'Budapest'),
            (1,N'Szeged'),
            (1,N'Miskolc'),
            (1,N'Debrecen'),
            (1,N'Győr')
    ) varos(ID,Nev)

) s
inner join (
    select 1 as ID, 'Budapest' as Nev
) a on s.ID = a.ID and s.Város = a.Nev


-- nem létező elemek hozzáadása a lekérdezéshez
select distinct Country
from Customer
where Country is not null
-- lehetőleg union all-t használjunk
union all select 'IT'
union all select 'NL'
union all select 'RS'
union all select 'RO'
union all select 'HR'
union all select 'AA'
union all select 'ES'
-- union-t csak akkor, ha nem vagyunk biztosak benne, hogy a megadott értékek nem fordulhatnak elő a lisában

