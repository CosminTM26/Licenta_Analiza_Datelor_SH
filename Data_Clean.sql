


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
--existau un numar ridicat de coloane care aveau la year date din coloana transmissio