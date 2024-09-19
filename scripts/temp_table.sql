-- ideiglenes táblák
create table [#Kulsősök] (
    [IgazolványSzám] nvarchar(10), 
    [Név] nvarchar(100)
)

select * from #Kulsősök

insert into [#Kulsősök]
values('888777YZ', 'Takács Olivér'),
      ('666555UH', 'Kiss Zoltán'),
      ('444333XA', 'Nagy János'),
      ('333222AB', 'Kopasz István'),
      ('111000AA', 'Kovács Aladár')


create table [#Belső_dolgozók] (
    [IgazolványSzám] nvarchar(10), 
    [Név] nvarchar(100)
)

insert into [#Belső_dolgozók]
values('123456AB', 'Zseni Károly'),
      ('111111FA', 'Kenyeres Gábor'),
      ('444333XA', 'Nagy János'),
      ('654321BB', 'Farkas Ádám'),
      ('111000AA', 'Kovács Aladár')

select * from #Belső_dolgozók
select * from #Kulsősök

select *
from #Belső_dolgozók
full join #Kulsősök on #Belső_dolgozók.IgazolványSzám = #Kulsősök.IgazolványSzám

-- tábla alias nevekkel
select *
from #Belső_dolgozók as b
full join #Kulsősök as k on b.IgazolványSzám = k.IgazolványSzám

-- 3 azonos lekérdezés
select *
from #Belső_dolgozók
cross join #Kulsősök
where #Belső_dolgozók.IgazolványSzám = #Kulsősök.IgazolványSzám

select *
from #Belső_dolgozók, #Kulsősök
where #Belső_dolgozók.IgazolványSzám = #Kulsősök.IgazolványSzám

select *
from #Belső_dolgozók
inner join #Kulsősök on #Belső_dolgozók.IgazolványSzám = #Kulsősök.IgazolványSzám

