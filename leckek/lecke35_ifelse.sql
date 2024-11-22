declare @Valtozo int = 0

if @Valtozo = 1
    select count(*) from Orders


if @Valtozo = 1
    begin
    select @Valtozo = count(*) from Orders
    print @Valtozo
    end
else 
    print 'Nincs adat'

--beágyazott if
if @Valtozo = 1
    begin
    select @Valtozo = count(*) from Orders
    print @Valtozo
    end
else 
    if getdate() > '2024-10-02'
        print 'Nincs adat'