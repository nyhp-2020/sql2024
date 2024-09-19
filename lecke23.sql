-- van-e Title = NULL
SELECT * from Customer WHERE Title is NULL
--nem NULL
SELECT * from Customer WHERE Title is not NULL

SELECT * from Customer WHERE not Title is NULL

-- van Csty = NULL
SELECT * from Customer WHERE City is NULL
-- van Email = NULL
SELECT * from Customer WHERE Email is NULL

--Title + FullName
select 
    Title,
    --isnull(Title,'') + ' '+ FirstName + ' ' +LastName as FullName,
    isnull(Title + ' ','') +  FirstName + ' ' +LastName as FullName,
    concat(Title + ' ', FirstName, ' ', LastName) as FullName2,
    City
    from Customer
    --where Title is not NULL

    --NULLIF függvény