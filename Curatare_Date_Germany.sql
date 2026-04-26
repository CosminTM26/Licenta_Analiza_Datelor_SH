
select distinct model
from Germany_Cars
order by model desc;
--totul ok aici

select distinct brand
from Germany_Cars
order by brand desc;
--totul ok aici

select distinct color, count (color) as numar
from Germany_Cars
group by color
order by color desc;
--totul ok aici

select distinct registration_date,count(registration_date) as numar
from Germany_Cars
group by registration_date
order by numar asc;
--totul ok aici

select distinct year,count(year) as numar
from Germany_Cars
group by year
order by numar asc;
--exista un numar ridicat de coloane din transmission_type si fuel_type care au inversate datele cu year

select distinct price_in_euro,count(price_in_euro) as numar
from Germany_Cars
group by price_in_euro
order by numar asc;
--totul ok aici

select distinct power_kw,count(power_kw) as numar
from Germany_Cars
group by power_kw
order by numar asc;
--exista inregistrari care au inversate valoarea cu transmission_type sau fuel_type

select distinct power_ps,count(power_ps) as numar
from Germany_Cars
group by power_ps
order by power_ps desc;
-- cantitate neglijabila de erori, se vor sterge inregistrarile si inlocuite cu NULL

select distinct transmission_type,count(transmission_type) as numar
from Germany_Cars
group by transmission_type
order by numar asc;
--totul ok aici

select distinct fuel_type,count(fuel_type) as numar
from Germany_Cars
group by fuel_type
order by numar asc;
--exista inregistrari care ar trebui sa fie in transmission_type

select distinct fuel_consumption_g_km,count(fuel_consumption_g_km) as numar
from Germany_Cars
group by fuel_consumption_g_km
order by numar asc;
--totul ok aici, coloana va fi stearsa

select distinct fuel_consumption_l_100km,count(fuel_consumption_l_100km) as numar
from Germany_Cars
group by fuel_consumption_l_100km
order by numar asc;
--greseli neglijabile,coloana va fi stearsa

select distinct mileage_in_km,count(mileage_in_km) as numar
from Germany_Cars
group by mileage_in_km
order by mileage_in_km asc;
--totul ok aici


select Germany_Cars.fuel_type
from Germany_Cars
where Germany_Cars.fuel_type in ('Semi-automatic', 'Manual', 'Automatic', 'Unknown');
--verificam daca exista inregistrari care au inversate valoarea cu fuel_type
update Germany_Cars
set transmission_type=fuel_type,
 fuel_type=Null
where fuel_type in ('Semi-automatic', 'Manual', 'Automatic', 'Unknown') ;
--schimbam valoarea cu fuel_type cu valoarea cu transmission_type

select *
from Germany_Cars
where fuel_type is null;

--stergem inregistrarile care nu pot fi inversate
update Germany_Cars
set fuel_type=null
where fuel_type not in ('Petrol', 'Diesel','Electric', 'Hybrid', 'LPG','CNG','Hydrogen' , 'Other', 'Ethanol', 'Diesel Hybrid' );

--verificam interogarea
select fuel_type
from Germany_Cars
 where fuel_type not in ('Petrol', 'Diesel','Electric', 'Hybrid', 'LPG','CNG','Hydrogen' , 'Other', 'Ethanol', 'Diesel Hybrid' );


update Germany_Cars
set fuel_type=fuel_consumption_g_km
where fuel_consumption_g_km in('Petrol', 'Diesel', 'Electric', 'Hybrid' );

delete from Germany_Cars
where fuel_type is null and transmission_type='Unknown';

--inlocuim valorile cu year cu valoarea cu fuel_type
update Germany_Cars
set fuel_type=year,
 year=null
where year in ('Petrol', 'Diesel','Electric', 'Hybrid', 'LPG','CNG','Hydrogen' , 'Other', 'Ethanol', 'Diesel Hybrid' );


--verificam
select year, fuel_type
from Germany_Cars
where year in ('Petrol', 'Diesel','Electric', 'Hybrid', 'LPG','CNG','Hydrogen' , 'Other', 'Ethanol', 'Diesel Hybrid' );

--verificam
select year, transmission_type
from Germany_Cars
where year in ('Semi-automatic', 'Manual', 'Automatic', 'Unknown');


--transmisia are deja valoriile, așa ca stergem year
update Germany_Cars
set year=null
where year in ('Semi-automatic', 'Manual', 'Automatic', 'Unknown');

--testam
select year
from Germany_Cars
where year not between 1800 and 2026;

--înlocuim valoriile anormale cu NULL
update Germany_Cars
set year=null
where year not between 1800 and 2026;

--sunt putine, doar 199 deci le stergem pe toate
select *
from Germany_Cars
where year is null;

--anul este foarte important, stergem inregistrarile care nu au anul
delete from Germany_Cars
where year is null;

alter table Germany_Cars
rename column mileage_in_km to km;

alter table Germany_Cars
rename column offer_description to engine_type;


--verificam duplicatele
 SELECT brand, model, color,year, price_in_euro,power_ps,transmission_type,fuel_type, km,engine_type, COUNT(*) as nr
  FROM Germany_Cars
  GROUP BY brand, model, color, year, price_in_euro,power_ps,transmission_type,fuel_type, km, engine_type
  HAVING COUNT(*) > 1
order by nr desc;


alter table Germany_Cars
add column id INTEGER;

update Germany_Cars
set id=rowid;

 SELECT COUNT(*) FROM Germany_Cars
  WHERE id NOT IN (
      SELECT MIN(id)
      FROM Germany_Cars
      GROUP BY brand, model, color, year, price_in_euro,power_ps,transmission_type,fuel_type, km, engine_type
  );

--STERGEM dublurile
delete from Germany_Cars
where id not in(SELECT MIN(id)
      FROM Germany_Cars
      GROUP BY brand, model, color, year, price_in_euro,power_ps,transmission_type,fuel_type, km, engine_type);

select count() from Germany_Cars;


--verificam valoriile nule
  SELECT
    SUM(CASE WHEN brand IS NULL THEN 1 ELSE 0 END) as brand_null,
    SUM(CASE WHEN model IS NULL THEN 1 ELSE 0 END) as model_null,
    SUM(CASE WHEN color IS NULL THEN 1 ELSE 0 END) as color_null,
    SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) as year_null,
    SUM(CASE WHEN price_in_euro IS NULL THEN 1 ELSE 0 END) as price_null,
    SUM(CASE WHEN power_ps IS NULL THEN 1 ELSE 0 END) as power_null,
    SUM(CASE WHEN transmission_type IS NULL THEN 1 ELSE 0 END) as trans_null,
    SUM(CASE WHEN fuel_type IS NULL THEN 1 ELSE 0 END) as fuel_null,
    SUM(CASE WHEN km IS NULL THEN 1 ELSE 0 END) as km_null
  FROM Germany_Cars;

--km sunt imortanti deci stergem ce este null
 DELETE FROM Germany_Cars WHERE km IS NULL;

--culoarea nu este importanta, pastram inregistrarile
UPDATE Germany_Cars SET color = 'Unknown' WHERE color IS NULL;


--inlocuim valoriile nule cu media
 UPDATE Germany_Cars
  SET power_ps = (SELECT ROUND(AVG(power_ps), 0) FROM Germany_Cars_Cleaned WHERE power_ps IS NOT NULL)
  WHERE power_ps IS NULL;

 SELECT DISTINCT brand, COUNT(*) as nr FROM Germany_Cars GROUP BY brand ORDER BY brand;
  SELECT DISTINCT color, COUNT(*) as nr FROM Germany_Cars GROUP BY color ORDER BY color;
SELECT DISTINCT transmission_type, COUNT(*) as nr FROM Germany_Cars GROUP BY transmission_type ORDER
  BY transmission_type;
SELECT DISTINCT fuel_type, COUNT(*) as nr FROM Germany_Cars GROUP BY fuel_type ORDER BY fuel_type;

--exista atat diesel hybrid cat si hybrid, le unificam
UPDATE Germany_Cars SET fuel_type = 'Hybrid' WHERE fuel_type = 'Diesel Hybrid';

drop table if exists Germany_Cars_Cleaned;
create table Germany_Cars_Cleaned as
    select id, brand, model, color, year, price_in_euro, power_ps, transmission_type, fuel_type,km,engine_type
    from Germany_Cars;