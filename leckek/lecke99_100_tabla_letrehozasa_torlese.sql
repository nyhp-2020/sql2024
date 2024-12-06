--1. v�ltozat: explicit constraint-ek n�vvel
create table dbo.Product1(
ProductID int not null identity(1,1), -- automatikus sorsz�moz�s
ProductName nvarchar(100) not null,
ListPrice decimal(10,4) not null,
Color nvarchar(20) null,
Size decimal(8,2) null,
CreatedDate datetime not null constraint DF_Product1_CreatedDate default (getdate()),
ProductNumber varchar(20) not null, -- nem lehet Unicode
StandardCost decimal(10,4) null,
SellStartDate datetime null,

-- A constraint-ek neveinek az eg�sz adatb�zisban egyedinek kell lenni!
constraint PK_Product1 primary key (ProductID), -- els�dleges kulcs
constraint UK_Product_ProductName unique (ProductName), --m�sodlagos kulcs
constraint UK_Product_ProductNumber unique (ProductNumber),
constraint CH_Product_ListPrice check (ListPrice > 0)	-- ellen�rz�s (check)

--ez �gy nem m�k�dik sajnos; az oszlop defin�ci�ba kell �rni
--constraint DF_Product_CreatedDate default (getdate()) for CreatedDate --alap�rtelmezett �rt�k (ha nem adj�k meg)
)


--2. v�ltozat: explicit constraint-ek n�v n�lk�l
create table dbo.Product2(
	ProductID int not null identity(1,1), -- automatikus sorsz�moz�s
	ProductName nvarchar(100) not null,
	ListPrice decimal(10,4) not null,
	Color nvarchar(20) null,
	Size decimal(8,2) null,
	CreatedDate datetime not null default (getdate()),
	ProductNumber varchar(20) not null, -- nem lehet Unicode
	StandardCost decimal(10,4) null,
	SellStartDate datetime null,

	primary key (ProductID), -- els�dleges kulcs
	unique (ProductName), --m�sodlagos kulcs
	unique (ProductNumber),
	check (ListPrice > 0)	-- ellen�rz�s (check)
)

-- 3. v�ltozat: inline constraint-ek n�vvel
create table dbo.Product1(
	ProductID int not null identity(1,1) constraint PK_Product1 primary key (ProductID), 
	ProductName nvarchar(100) not null constraint UK_Product_ProductName unique (ProductName),
	ListPrice decimal(10,4) not null constraint CH_Product_ListPrice check (ListPrice > 0),
	Color nvarchar(20) null,
	Size decimal(8,2) null,
	CreatedDate datetime not null constraint DF_Product1_CreatedDate default (getdate()),
	ProductNumber varchar(20) not null constraint UK_Product_ProductNumber unique (ProductNumber),
	StandardCost decimal(10,4) null,
	SellStartDate datetime null,
-- A constraint-ek neveinek az eg�sz adatb�zisban egyedinek kell lenni!
)

-- 4. v�ltozat: inline constraint-ek n�v n�lk�l
create table dbo.Product2(
	ProductID int not null identity(1,1) primary key (ProductID), 
	ProductName nvarchar(100) not null unique (ProductName),
	ListPrice decimal(10,4) not null check (ListPrice > 0),
	Color nvarchar(20) null,
	Size decimal(8,2) null,
	CreatedDate datetime not null default (getdate()),
	ProductNumber varchar(20) not null unique (ProductNumber),
	StandardCost decimal(10,4) null,
	SellStartDate datetime null,
)

-- t�bla t�rl�se
drop table dbo.Product1

-- SQL Server 2016 �ta ezt is lehet
drop table if exists dbo.Product1 --nem keletkezik hiba

-- ideiglenes t�bl�kat is lehet �gy t�r�lni