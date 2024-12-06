--1. változat: explicit constraint-ek névvel
create table dbo.Product1(
ProductID int not null identity(1,1), -- automatikus sorszámozás
ProductName nvarchar(100) not null,
ListPrice decimal(10,4) not null,
Color nvarchar(20) null,
Size decimal(8,2) null,
CreatedDate datetime not null constraint DF_Product1_CreatedDate default (getdate()),
ProductNumber varchar(20) not null, -- nem lehet Unicode
StandardCost decimal(10,4) null,
SellStartDate datetime null,

-- A constraint-ek neveinek az egész adatbázisban egyedinek kell lenni!
constraint PK_Product1 primary key (ProductID), -- elsõdleges kulcs
constraint UK_Product_ProductName unique (ProductName), --másodlagos kulcs
constraint UK_Product_ProductNumber unique (ProductNumber),
constraint CH_Product_ListPrice check (ListPrice > 0)	-- ellenõrzés (check)

--ez így nem mûködik sajnos; az oszlop definícióba kell írni
--constraint DF_Product_CreatedDate default (getdate()) for CreatedDate --alapértelmezett érték (ha nem adják meg)
)


--2. változat: explicit constraint-ek név nélkül
create table dbo.Product2(
	ProductID int not null identity(1,1), -- automatikus sorszámozás
	ProductName nvarchar(100) not null,
	ListPrice decimal(10,4) not null,
	Color nvarchar(20) null,
	Size decimal(8,2) null,
	CreatedDate datetime not null default (getdate()),
	ProductNumber varchar(20) not null, -- nem lehet Unicode
	StandardCost decimal(10,4) null,
	SellStartDate datetime null,

	primary key (ProductID), -- elsõdleges kulcs
	unique (ProductName), --másodlagos kulcs
	unique (ProductNumber),
	check (ListPrice > 0)	-- ellenõrzés (check)
)

-- 3. változat: inline constraint-ek névvel
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
-- A constraint-ek neveinek az egész adatbázisban egyedinek kell lenni!
)

-- 4. változat: inline constraint-ek név nélkül
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

-- tábla törlése
drop table dbo.Product1

-- SQL Server 2016 óta ezt is lehet
drop table if exists dbo.Product1 --nem keletkezik hiba

-- ideiglenes táblákat is lehet így törölni