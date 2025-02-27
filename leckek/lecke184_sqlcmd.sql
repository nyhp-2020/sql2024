-- sqlcmd.exe Ez a parancssoros kliens
/*
select db_name()
2> go

1> select name from sys.databases
2> go

> use MyDB
2> go

1> select ProductName from Product
2> go

exit

sqlcmd -?

sqlcmd -dMyDB -Q"select * from Customer"

sqlcmd -dMyDB -Q"select * from Customer" -oC:\temp\Customer.csv -s;

exec uspAddToInventory @ProductID = 1 @uantity = 3 @Shelf = 'XX'

sqlcmd -dMyDB -Q"exec uspAddToInventory @ProductID = 1 @uantity = 3 @Shelf = 'XX'" -- ez van benne

cd temp
ProcTest.cmd


osql.exe --elavultabb
osql -?
osql -E
*/