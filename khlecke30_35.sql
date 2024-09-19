BEGIN
select count(*) from Orders
END

--if
declare @Valtozo INT = 0

if (@Valtozo = 1)
    begin --kódblokk kezdete
    select @Valtozo = count(*) from Orders
    print @Valtozo
    end -- vége
else 
    if getdate() > '2023-02-01'
        print 'Nincs adat'


-- while
declare @ciklus int = 0
while @ciklus < 10
    begin 
    print @ciklus
    set @ciklus = @ciklus + 1
    end 

-- break
while 1=1 -- végtelen ciklus
    begin
    print 'Szia!' 
    break -- kiugrás a ciklusból
    end 
-- continue ciklusfeltétel vizsgálatra ugrik

--goto NewLabel

--NewLabel:

--return