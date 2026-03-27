
--redenumire de coloane
alter table Germany_Cars rename column fuel_consumption_l_100km to fuel_consumption_g_km;
select *
from Germany_Cars
where year in ('Automatic' , 'Manual');
--w5y
-- transformare din string in double
update cars_details_merges
set price=
    CAST(
        (REPLACE(REPLACE(price, '₹ ', ''), ' Lakh', ''))
    AS double);
-- transformare din string in integer
update cars_details_merges
    set "Max Power" = round(CAST("Max Power" AS REAL),0);

drop table if exists India_Cars_Cleaned;
-- selectare coloane necesare
create table India_Cars_Cleaned as
    select
    oem as brand,
    model,
    color,
    myear as year,
    round(((dynx_totalvalue_x)*0.01119),-3) as price_in_euro,
    "Max Power" as power_ps,
    tt as transmision_type,
    fuel_type,
    km,
    variant_name,
    max_engine_capacity_new,
    owner_type_new as one_owner,
    "Drive Type" as drivetrain,
    bt as body_type
    from cars_details_merges;

drop table if exists Germany_Cars_Cleaned;

create table Germany_Cars_Cleaned as
    select brand, model, color, year, price_in_euro, power_ps, transmission_type, fuel_type, mileage_in_km as km, offer_description as engine_type
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