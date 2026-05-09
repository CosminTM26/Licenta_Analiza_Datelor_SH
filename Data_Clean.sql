
--redenumire de coloane
alter table Germany_Cars rename column fuel_consumption_l_100km to fuel_consumption_g_km;
select *
from Germany_Cars
where year in ('Automatic' , 'Manual');

drop table if exists Germany_Cars_Cleaned;

create table Germany_Cars_Cleaned as
    select id, brand, model, color, year, price_in_euro, power_ps, transmission_type, fuel_type,km, engine_type
    from Germany_Cars;

drop table if exists SUA_cars_Cleaned;

create table SUA_cars_Cleaned as
    select manufacturer as brand,
    model,
    exterior_color as color,
    year,
    round((price* 0.9241),-2) as price_in_euro,
    transmission as transmission_type,
    fuel_type,
    round((mileage*1.609344),-2) as km,
    engine as engine_type,
    drivetrain,
    one_owner,
    accidents_or_damage

    from SUA_Cars;
--existau un numar ridicat de coloane care aveau la year date din coloana transmission
update  Germany_Cars
set
    registration_date=fuel_consumption_g_km,
    price=registration_date,
    year=power_kw,
    mileage=fuel_Type,
    fuel_type=fuel_consumption_l_100km

where year in ('Automatic' , 'Manual');



update  Germany_Cars
set
    transmission_type=year
where transmission_type in('Automatic' , 'Manual');

select count(year) as numar, year
from Germany_Cars
group by year
order by numar;

--existau un numar ridicat de coloane care aveau inversata valoarea year cu fuel_consumption_g_km
update  Germany_Cars
set
    fuel_consumption_g_km=year,
    year=fuel_consumption_g_km
where year in('Petrol', 'Diesel', 'Hibrid', 'Electric', 'Hybrid');




DELETE FROM Germany_Cars
WHERE year IS NULL;

select *
from Germany_Cars
where year='04/2017'