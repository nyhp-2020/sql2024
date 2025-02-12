if not exists(
select * from sys.databases
where name = 'WebDoki'
)
begin
	create database WebDoki
	CONTAINMENT = NONE
	 ON  PRIMARY 
	( NAME = N'WebDoki', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\WebDoki.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
	 LOG ON 
	( NAME = N'WebDoki_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\WebDoki_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
	 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF


	IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
	begin
	EXEC [WebDoki].[dbo].[sp_fulltext_database] @action = 'enable'
	end

	ALTER DATABASE [WebDoki] SET ANSI_NULL_DEFAULT OFF 
	ALTER DATABASE [WebDoki] SET ANSI_NULLS OFF 
	ALTER DATABASE [WebDoki] SET ANSI_PADDING OFF 
	ALTER DATABASE [WebDoki] SET ANSI_WARNINGS OFF 
	ALTER DATABASE [WebDoki] SET ARITHABORT OFF 
	ALTER DATABASE [WebDoki] SET AUTO_CLOSE OFF 
	ALTER DATABASE [WebDoki] SET AUTO_SHRINK OFF 
	ALTER DATABASE [WebDoki] SET AUTO_UPDATE_STATISTICS ON 
	ALTER DATABASE [WebDoki] SET CURSOR_CLOSE_ON_COMMIT OFF 
	ALTER DATABASE [WebDoki] SET CURSOR_DEFAULT  GLOBAL 
	ALTER DATABASE [WebDoki] SET CONCAT_NULL_YIELDS_NULL OFF 
	ALTER DATABASE [WebDoki] SET NUMERIC_ROUNDABORT OFF 
	ALTER DATABASE [WebDoki] SET QUOTED_IDENTIFIER OFF 
	ALTER DATABASE [WebDoki] SET RECURSIVE_TRIGGERS OFF 
	ALTER DATABASE [WebDoki] SET  DISABLE_BROKER 
	ALTER DATABASE [WebDoki] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
	ALTER DATABASE [WebDoki] SET DATE_CORRELATION_OPTIMIZATION OFF 
	ALTER DATABASE [WebDoki] SET TRUSTWORTHY OFF 
	ALTER DATABASE [WebDoki] SET ALLOW_SNAPSHOT_ISOLATION OFF 
	ALTER DATABASE [WebDoki] SET PARAMETERIZATION SIMPLE 
	ALTER DATABASE [WebDoki] SET READ_COMMITTED_SNAPSHOT OFF 
	ALTER DATABASE [WebDoki] SET HONOR_BROKER_PRIORITY OFF 
	ALTER DATABASE [WebDoki] SET RECOVERY FULL 
	ALTER DATABASE [WebDoki] SET  MULTI_USER 
	ALTER DATABASE [WebDoki] SET PAGE_VERIFY CHECKSUM  
	ALTER DATABASE [WebDoki] SET DB_CHAINING OFF 
	ALTER DATABASE [WebDoki] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
	ALTER DATABASE [WebDoki] SET TARGET_RECOVERY_TIME = 60 SECONDS 
	ALTER DATABASE [WebDoki] SET DELAYED_DURABILITY = DISABLED 
	ALTER DATABASE [WebDoki] SET ACCELERATED_DATABASE_RECOVERY = OFF  
	ALTER DATABASE [WebDoki] SET QUERY_STORE = ON
	ALTER DATABASE [WebDoki] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
	ALTER DATABASE [WebDoki] SET  READ_WRITE 
end
go

use WebDoki
go

alter authorization on database::[WebDoki] to sa --hogy tudjunk adatbázis diagramot csinálni
go

create table Paciensek(
	ID int not null identity(1,1),
	Nev nvarchar(100) not null,
	Webes bit not null,
	Email nvarchar(100) null,
	Jelszo nvarchar(100) null,
	Regisztralva datetime not null default getdate(),
	TAJ nvarchar(20) null constraint UK_Paciensek_TAJ unique, --másodlagos kulcs
	Bejelentkezve datetime null,
	LakcimIranyitoszam nvarchar(20) null,
	LakcimTelepules nvarchar(100) null,
	LakcimKozterulet nvarchar(100) null,
	LakcimKozteruletJelleg nvarchar(100) null,
	LakcimHazSzamEmeletAjto nvarchar(20) null,
	VezetekesTelefon nvarchar(20) null,
	MobilTelefon nvarchar(20) null,
	SzuletesiIdo date null,
	Neme tinyint null,
	SzuletesiHely nvarchar(100) null,
	AnyjaNeve nvarchar(100) null,

	constraint PK_Paciensek primary key (ID),
	constraint CK_Paciensek_Email_Webes CHECK  (( Webes = 1 and Email is not null) or Webes = 0),
	constraint CK_Paciensek_VezetekesTelefon_MobilTelefon check (not (VezetekesTelefon is null and MobilTelefon is null)),
	constraint CK_Paciensek_TAJ check (len(TAJ) = 9),
	constraint CK_Paciensek_SzuletesiIdo check (SzuletesiIdo < getdate())
)
go

create table Naptar(
	Idopont datetime constraint PK_Naptar primary key not null,
	Datum as cast(Idopont as date) persisted,	--eltárolódnak a számított oszlopok is
	Ido as cast(Idopont as time) persisted,
	Allapot tinyint default 0 not null

	constraint CK_Naptar_Allapot check (Allapot in (0,1,2,3))
)
go

create table IdopontFoglalas(
	ID int constraint PK_IdopontFoglalas primary key not null identity(1,1),
	PaciensID int not null,
	Idopont datetime not null,
	Panasz nvarchar(4000) null,
	Megjelent bit null

	constraint UK_IdopontFoglalas_PaciensID_Idopont unique (PaciensID,Idopont),
	constraint FK_IdopontFoglalas_Paciensek foreign key (PaciensID) references dbo.Paciensek(ID),
	constraint FK_IdopontFoglalas_Naptar foreign key (Idopont) references dbo.Naptar(Idopont)
)
go

create table Betegsegek(
	BNOKod nvarchar(20) constraint PK_Betegsegek primary key not null,
	Jel nvarchar(20) null,
	Nev nvarchar(100) not null,
	Nem tinyint check (Nem >= 1 and Nem <= 20) not null, -- 1-20
	KorTol tinyint check (KorTol >= 1 and KorTol <= 99) not null, -- 1-99
	KorIg tinyint check (KorIg >= 1 and KorIg <= 99) not null, -- 1-99
	ErvenyessegKezdet date not null,
	ErvenyessegVege date not null
)
go

create table Igazolvanyok(
	ID int identity(1,1) constraint PK_Igazolvanyok primary key not null,
	PaciensID int constraint FK_Igazolvanyok_Paciensek foreign key references dbo.Paciensek(ID) not null,
	Tipus nvarchar(20) not null,
	Azonosito nvarchar(20) not null,
	Ervenyesseg date null
)
go

create table Munkahelyek(
	ID int identity(1,1) constraint PK_Munkahelyek primary key not null,
	PaciensID int constraint FK_Munkahelye_Paciensek foreign key references dbo.Paciensek(ID) not null,
	MunkahelyNeve nvarchar(100) not null,
	Munkakor nvarchar(20) not null,
	Adoszam nvarchar(20) null,
	Cim nvarchar(100) null,
	Telefon nvarchar(20) null,
	AlkalmazasKezdete date null,
	AlkalmazasVege date null
)
go

create or alter function dbo.GetDayNumberInWeek(@Day date)
returns int
as
begin
	declare @dayofweek int = datepart(weekday,@Day)
	if @dayofweek between 2 and 7
		set @dayofweek = @dayofweek - 1
	else 
		set @dayofweek = 7
	return @dayofweek
end
go

create or alter function dbo.GetWeekNumberInYear(@Day date)
returns int
as
begin
	declare @dayofweek int = datepart(weekday,@Day)
	declare @weekofyear int = datepart(week,@Day)
	if @dayofweek = 1
		set @weekofyear -= 1
	return @weekofyear
end
go

create or alter function dbo.IsEven(@Num int)
returns bit
as
begin
	declare @ret bit
	if @Num % 2 = 0
		set @ret = 1
	else
		set @ret = 0
	return @ret
end
go

create or alter procedure uspNaptarFeltolt(
	@datum_kezdet date,
	@datum_veg date,
	@ido_kezdet time,
	@ido_veg time,
	@intervallum_perc tinyint = 15,
	@hetek tinyint = 0,
	@napok nvarchar(20) = '1,2,3,4,5'
)
as
if	@datum_kezdet is null or 
	@datum_veg is null or
	@ido_kezdet is null or
	@ido_veg is null or
	@intervallum_perc is null
	throw 50000,'Adja meg a kötelezõ paramétereket!', 0

if @datum_veg < @datum_kezdet -- azonos lehet
	throw 50001,'Rossz dátumintervallum!', 0

if @ido_veg <= @ido_kezdet
	throw 50002,'Rossz idõintervallum!', 0

if datediff(minute, convert(datetime, @ido_kezdet), convert(datetime, @ido_veg)) < @intervallum_perc
	throw 50003,'Az intervallum nem fér el a kezdõ és a vége idõ között!', 0

if @datum_kezdet < getdate()
	throw 50004,'Az aktuális idõpontnál késõbbi lehet kezdõ dátum!', 0

if not (@intervallum_perc >= 1 and @intervallum_perc <= 100)
	throw 50005,'Az intervallum értéke (percben) 1-100-ig lehet!', 0

if not (@hetek in (0,1,2))
	throw 50006,'A hetek értéke csak 0,1,2 lehet!', 0

if @napok = ''
	set @napok = '1,2,3,4,5'

declare @dt table(day int)

insert into @dt(day)
select distinct try_convert(int,trim(value))
from string_split(@napok, ',')

delete from @dt
where day is null or day = 0

if exists (select day from @dt
			where day not in (1,2,3,4,5,6,7))
	throw 50007,'A hét napjainak a száma 1-7-ig mehet!', 0
		   
declare @nap date = @datum_kezdet
declare @het_szama_az_evben int
declare @het_napja int

declare @insert_dt datetime,
		@nap_vege datetime

while (0 = 0)
begin
	if @nap > @datum_veg break
	set @het_szama_az_evben = dbo.GetWeekNumberInYear(@nap)
	set @het_napja = dbo.GetDayNumberInWeek(@nap)

	if	not exists(select * from dbo.Naptar where cast(Idopont as date) = @nap) and --ha nincs ilyen dátum a táblában
		@het_napja in (select * from @dt) and --benne van a meghatározott napok között
		(
		@hetek = 0 or											--minden hét
		(@hetek = 1 and dbo.IsEven(@het_szama_az_evben) = 0) or --páratlan hét
		(@hetek = 2 and dbo.IsEven(@het_szama_az_evben) = 1)	--páros hét
		)
		begin
			--napi adatok felvitele
			set @insert_dt = convert(datetime,@nap) + convert(datetime,@ido_kezdet)
			set @nap_vege = convert(datetime,@nap) + convert(datetime,@ido_veg)
			while (1 = 1)
			begin
				if @nap_vege <= @insert_dt break

				insert into dbo.Naptar(Idopont,Allapot)
				values(@insert_dt,default)

				set @insert_dt = dateadd(minute,@intervallum_perc,@insert_dt)
			end
		end
	set @nap = dateadd(day, 1, @nap) --következõ nap
end
go
/*
exec uspNaptarFeltolt
	 @datum_kezdet = '2025-02-11'
	,@datum_veg = '2025-02-12'
	,@ido_kezdet = '08:00'
	,@ido_veg = '14:00'
	,@intervallum_perc = 15
	,@hetek = 0
	,@napok = '1,2,3'

delete from dbo.Naptar
*/

create or alter procedure uspNaptarTorles(
	@datum_kezdet date,
	@datum_veg date,
	@ido_kezdet time,
	@ido_veg time,
	@hetek tinyint = 0,
	@napok nvarchar(20) = '1,2,3,4,5'
)
as
declare @foglalt_idopont datetime

if	@datum_kezdet is null or 
	@datum_veg is null or
	@ido_kezdet is null or
	@ido_veg is null
	throw 50000,'Adja meg a kötelezõ paramétereket!', 0

if @datum_kezdet < getdate()
	throw 50004,'Az aktuális idõpontnál késõbbi lehet kezdõ dátum!', 0

if @datum_veg < @datum_kezdet -- azonos lehet
	throw 50001,'Rossz dátumintervallum!', 0

if @ido_veg <= @ido_kezdet
	throw 50002,'Rossz idõintervallum!', 0

declare @dt table(day int)

insert into @dt(day)
select distinct try_convert(int,trim(value))
from string_split(@napok, ',')

delete from @dt
where day is null or day = 0

if exists (select day from @dt
			where day not in (1,2,3,4,5,6,7))
	throw 50007,'A hét napjainak a száma 1-7-ig mehet!', 0


declare @kezdet datetime = convert(datetime,@datum_kezdet) + convert(datetime,@ido_kezdet),
		@veg datetime = convert(datetime,@datum_veg) + convert(datetime,@ido_veg)

--if exists(
select top 1 @foglalt_idopont = n.Idopont
from dbo.Naptar n
left join dbo.IdopontFoglalas idfo on idfo.Idopont = n.Idopont
where n.Idopont >= @kezdet and n.Idopont < @veg and
	  idfo.Idopont is not null
order by n.Idopont
--)
if @@rowcount <> 0 --or  @foglalt_idopont is not null
	begin
		EXEC sys.sp_addmessage
		@msgnum = 50003,
		@severity = 16,
		@msgtext = N'Nem sikerült az idõpontok törlése,mert a következõ idõpont már foglalt: %s',
		@lang = 'Hungarian';

		declare @str_idopont nvarchar(20) = convert(nvarchar(100),@foglalt_idopont,20)
		set @str_idopont = substring(@str_idopont, 1, len(@str_idopont) - 3)

		declare @msg nvarchar(200) = formatmessage(50003,@str_idopont);
			
		throw 50003, @msg, 0;
	end

declare @nap date = @datum_kezdet
declare @het_szama_az_evben int
declare @het_napja int

declare @nap_eleje datetime,
		@nap_vege datetime

while (0 = 0)
begin
	if @nap > @datum_veg break
	set @het_szama_az_evben = dbo.GetWeekNumberInYear(@nap)
	set @het_napja = dbo.GetDayNumberInWeek(@nap)

	if	@het_napja in (select * from @dt) and --benne van a meghatározott napok között
		(
		@hetek = 0 or											--minden hét
		(@hetek = 1 and dbo.IsEven(@het_szama_az_evben) = 0) or --páratlan hét
		(@hetek = 2 and dbo.IsEven(@het_szama_az_evben) = 1)	--páros hét
		)
		begin
			-- törlés, ha
			set @nap_eleje = convert(datetime,@nap) + convert(datetime,@ido_kezdet)
			set @nap_vege = convert(datetime,@nap) + convert(datetime,@ido_veg)

			delete from dbo.Naptar
			where Idopont in (
			select n.Idopont
			from dbo.Naptar n
			left join dbo.IdopontFoglalas idfo on idfo.Idopont = n.Idopont
			where n.Idopont >= @nap_eleje and n.Idopont < @nap_vege and
				  idfo.Idopont is null --nincs kapcsolódó idõpontfoglalás
			)

		end
	set @nap = dateadd(day, 1, @nap) --következõ nap
end
go
/*
exec uspNaptarTorles
	 @datum_kezdet = '2025-02-11'
	,@datum_veg = '2025-02-12'
	,@ido_kezdet = '07:00'
	,@ido_veg = '12:00'	
 */

create or alter procedure uspNaptarEgyediTorles(
	@idopont datetime
)
as
if @idopont < getdate()
	throw 50004,'Az aktuális idõpontnál késõbbi lehet az idõpont!', 0

if not exists(
select *
from dbo.Naptar
where Idopont = @idopont
)
	throw 50000,'Nem létezik ilyen idõpont!', 0

if exists(
select *
from dbo.Naptar n
inner join dbo.IdopontFoglalas idfo on idfo.Idopont = n.Idopont
where idfo.Idopont = @idopont
)
	throw 50000,'Az idõpont foglalt!', 0

delete from dbo.Naptar
where Idopont = @idopont
go

--exec uspNaptarEgyediTorles @idopont = '2025-02-10 08:00'

create or alter procedure uspIdopontFoglalas(
	@email nvarchar(100) = null,
	@jelszo nvarchar(100) = null,
	@nev nvarchar(100),
	@TAJ nvarchar(9),
	@szemelyes bit,  -- 1 személyes, 0 telefonos
	@telefon nvarchar(20) = null,
	@panasz nvarchar(4000) = null,
	@idopont datetime
)
as
set xact_abort on

declare @PaciensID int

declare @tv table (
	ID int
)

begin try
	begin transaction

	if @idopont <= getdate()
		throw 50002,'A jelennél késõbbi idõpontot lehet csak megadni!', 0

	select @PaciensID = ID
	from dbo.Paciensek
	where TAJ = @TAJ

	if @@rowcount = 0  --nem talált
		begin
			if	(@nev is null or @nev = '') or
				(@jelszo is null or @jelszo = '') or
				(@email is null or @email = '') or
				(@szemelyes = 0 and (@telefon is null or @telefon = ''))
				throw 50000,'Adja meg a nevet, jelszót, emailt! Telefonos rendelésnél a telefont is!', 0

			insert into dbo.Paciensek(Nev, Webes, Email, Jelszo, Regisztralva, TAJ, VezetekesTelefon, MobilTelefon)
			output inserted.ID into @tv
			values (@nev,0,@email,@jelszo,getdate(),@TAJ, @telefon, @telefon)

			select @PaciensID = ID from @tv
		end

	if not exists(
		select Idopont
		from dbo.Naptar
		where Idopont = @idopont and Allapot = 0
	)
		throw 50001,'Idõpont nem létezik vagy nem szabad!', 0

	insert into dbo.IdopontFoglalas(PaciensID, Idopont, Panasz, Megjelent)
	values(@PaciensID, @idopont, @panasz,0)

	update dbo.Naptar
	set Allapot = 1 --foglalt
	where Idopont = @idopont

	commit transaction 
end try
begin catch
	if @@TRANCOUNT > 0 rollback;
	throw;
end catch
go
/*
exec uspIdopontFoglalas
	 @email = 'sdf@trew.com'
	,@jelszo = 'bla'
	,@nev = 'Kis Pál'
	,@TAJ = '123456789'
	,@szemelyes = 0
	,@telefon = '+36201234567'
	,@panasz = 'köhögés'
	,@idopont = '2025-02-11 08:30'
*/

create or alter procedure uspIdopontTorles(
	@email nvarchar(100),
	@jelszo nvarchar(100),
	@TAJ nvarchar(9),
	@idopont datetime
)
as
set xact_abort on

declare @PaciensID int

/*
declare @tv table (
	ID int,
	idopont datetime
)
*/

begin try
	begin transaction

	if	(@jelszo is null or @jelszo = '') or
		(@email is null or @email = '') or
		(@TAJ is null or @TAJ = '') or
		(@idopont is null or @idopont = '')
		throw 50000,'Adja meg az összes paramétert!', 0

	if @idopont <= getdate()
		throw 50001,'A jelennél késõbbi idõpontot lehet csak megadni!', 0

	select @PaciensID = ID
	from dbo.Paciensek
	where TAJ = @TAJ and email = @email and Jelszo = @jelszo

	if @@rowcount = 0  --nem talált
		throw 50002,'Nem jó az összes megadott adat!', 0

	delete from dbo.IdopontFoglalas
	--output deleted.PaciensID,deleted.Idopont into @tv
	where PaciensID = @PaciensID and Idopont = @idopont

	if @@rowcount = 0  --nem lehetett törölni
		throw 50003,'Az idõpont nem található!', 0

	update dbo.Naptar
	set Allapot = 3  --törölt
	where Idopont = @idopont

	commit transaction
end try
begin catch
	if @@TRANCOUNT > 0 rollback;
	throw;
end catch
go
