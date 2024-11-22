--while 1 = 1 -- végtelen ciklus
--   print getdate()

declare @ciklus int = 0
while @ciklus < 10
    BEGIN
        print @ciklus
        set @ciklus = @ciklus + 1
    END

declare @ciklus int = 0
while @ciklus < 10
    BEGIN
        if  @ciklus > 5
            break
        print @ciklus
        set @ciklus = @ciklus + 1
    END