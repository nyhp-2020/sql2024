use MyDB

create table dbo.ErrorLog(
ID int not null constraint PK_ErrorLog primary key identity(1,1),
[Date] datetime not null,
ErrorNumber int not null,
[Procedure] nvarchar(512) not null,
ErrorLine int not null,
ErrorMessage nvarchar(4000) not null,
UserName nvarchar(128) not null
)

go
