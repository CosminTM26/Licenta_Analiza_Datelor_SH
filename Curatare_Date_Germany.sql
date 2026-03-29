
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


--transmisia are deja valoriile, asa ca stergem year
update Germany_Cars
set year=null
where year in ('Semi-automatic', 'Manual', 'Automatic', 'Unknown');

--testam
select year
from Germany_Cars
where year not between 1800 and 2026;

--inlocuim valoriile anormale cu NULL
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

