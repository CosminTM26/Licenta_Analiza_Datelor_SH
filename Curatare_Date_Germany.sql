
select distinct model
from Germany_Cars
order by model desc;

select distinct brand
from Germany_Cars
order by brand desc;

select distinct color, count (color) as numar
from Germany_Cars
group by color
order by color desc;

select distinct registration_date,count(registration_date) as numar
from Germany_Cars
group by registration_date
order by numar asc;

select distinct year,count(year) as numar
from Germany_Cars
group by year
order by numar asc;
--exista un numar ridicat de coloane din transmission_type si fuel_type care au inversate datele cu year

select distinct price_in_euro,count(price_in_euro) as numar
from Germany_Cars
group by price_in_euro
order by numar asc;

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
--totul ok aici

select distinct fuel_consumption_l_100km,count(fuel_consumption_l_100km) as numar
from Germany_Cars
group by fuel_consumption_l_100km
order by numar asc;
--greseli neglijabile

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

update Germany_Cars
set fuel_type=fuel_consumption_g_km
where fuel_consumption_g_km in('Petrol', 'Diesel', 'Electric', 'Hybrid' );

delete from Germany_Cars
where fuel_type is null and transmission_type='Unknown';

select year, fuel_type
from Germany_Cars
where year in ('Petrol', 'Diesel','Electric', 'Hybrid', 'LPG')