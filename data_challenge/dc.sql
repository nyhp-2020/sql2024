select * from movies
--genres oszlopban a műfajok

select * from movies where title = 'Titanic' --'The Holiday'

select * from cast where film_id = 597  --szereplőgárda

select *
from cast
join persons on persons.person_id = cast.person_id
where film_id = 597


select *
from crew
join persons on persons.person_id = crew.person_id
join positions on positions.position_id = crew.position_id
where film_id = 1581 --'The Holiday'
and position.position_name = 'Writer'


--'The Matrix' 603
--'Dumb and Dumber' 8464

select 
    c.film_id, p.person_name,
    row_number() over(partition by c.film_id order by c.sequence, c.cast_id) as sequence 
into #actor --ideiglenes tábla
from cast c 
join persons p on p.person_id = c.person_id

select * from #actor


select 
    c.film_id, p.person_name, pos.category,
    row_number() over(partition by c.film_id, pos.category order by pos.prio, c.crew_id) as sequence 
into #staff
from crew c 
join persons p on p.person_id = c.person_id
join positions o on o.position_id = c.position_id
join (
    values 
    ('director', 'Director', 1),
    ('director', 'Co-Director', 2),
    ('director', '%director%', 3),
    ('writer', 'Writer', 1),
    ('writer', 'Story', 2),
    ('writer', 'Screenplay', 3),
    ('writer', '%writer%', 4),
    ('writer', '%story%', 5),
    ('writer', '%screen%', 6)
) pos(category, position, prio) on o.position_name like position

select * from #staff

select * from positions

select * from geners --műfajok

-- ennek a lekérdezésnek az eredményéz exportáljuk (de kellenek hozzá az előzők is)
select
    --m.film_id,
    m.imdb_id,
    m.title,
    m.duration_minutes,
    m.year_released,
    m.genres,
    m.popularity,
    m.average_rating,
    m.production_cost,
    m.box_office_revenue,
    a1.person_name as actor1,
    a2.person_name as actor2,
    a3.person_name as actor3,
    s1.person_name as director,
    s2.person_name as writer,
    prod.production_company_name as production_company
from movies m
left join #actor a1 on a1.film_id = m.film_id and a1.sequence = 1
left join #actor a2 on a2.film_id = m.film_id and a2.sequence = 2
left join #actor a3 on a3.film_id = m.film_id and a3.sequence = 3
left join #staff s1 on s1.film_id = m.film_id and s1.category = 'director' and s1.sequence = 1
left join #staff s2 on s2.film_id = m.film_id and s2.category = 'writer' and s2.sequence = 1
outer apply ( --ha a belső lekérdezés nem ad vissza sort, a külső akkor is ad vissza egyet (null mezők, ld. left join)
    select top 1 pc.production_company_name
    from string_split(m.production_companies, '/', 1) s --ordinal oszlop engedélyezése (rész sztring pozícióját tartalmazza)
    join production_companies pc on pc.production_company_id = cast(s.value as int)
    order by s.ordinal
) prod
where m.year_released between 2006 and 2016
and m.original_language = 'en'
and m.genres like '%/ro/%'
--and m.average_rating >= 7
and m.box_office_revenue is not null
--and m.production_cost is null



