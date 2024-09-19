-- ideiglenes táblák létrehozása
create table [#Külsősök] (
    [IgazolványSzám] nvarchar(10),
    [Név] nvarchar(100)
)

select * from #Külsősök

insert into [#Külsősök]
values('888777YZ','Takács Olivér'),
    ('666555UH','Kiss Zoltán'),
    ('444333XA','Nagy Jáno'),
    ('333222AB','Kopasz István'),
    ('111000AA','Kovács Aladár')

-- pl lekérdezés eredményének ideiglenes tárolásásra jó
--tempdb adatbázisban jön létre

create table [#Belső_dolgozók] (
    [IgazolványSzám] nvarchar(10),
    [Név] nvarchar(100)
)

insert into [#Belső_dolgozók]
values('123456AB','Zseni Károily'),
    ('111111FA','Kenyeres Gábor'),
    ('444333XA','Nagy Jáno'),
    ('654321BB','Farkas Ádám'),
    ('111000AA','Kovács Aladár')

select * from [#Belső_dolgozók]
select * from #Külsősök

--full join  (inner join, left join, right join eredmények összefűzve)
select *
from #Belső_dolgozók
full join #Külsősök on #Belső_dolgozók.IgazolványSzám = #Külsősök.IgazolványSzám