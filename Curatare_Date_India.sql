 alter table India_Cars_Cleaned
 rename column transmision_type to transmission_type;

SELECT DISTINCT brand, COUNT(*) as nr FROM
  India_Cars_Cleaned GROUP BY brand ORDER BY
  brand;

 UPDATE India_Cars_Cleaned SET brand = 'Mahindra' WHERE brand = 'Mahindra Renault';
  UPDATE India_Cars_Cleaned SET brand = 'Mahindra' WHERE brand = 'Mahindra Ssangyong';


  SELECT DISTINCT model, COUNT(*) as nr FROM
  India_Cars_Cleaned GROUP BY model ORDER BY
  model;
--modificam modelele cu denumiri diferite
update India_Cars_Cleaned set model = 'Audi A3' where model like 'Audi A3%';
update India_Cars_Cleaned set model = 'BMW 3 Series' where model like 'BMW 3 Series%';
update India_Cars_Cleaned set model = 'Chevrolet Aveo' where model like 'Chevrolet Aveo%';
update India_Cars_Cleaned set model = 'Chevrolet Sail' where model like 'Chevrolet Sail%';
update India_Cars_Cleaned set model = 'Fiat Avventura' where model like 'Fiat Avventura%';
update India_Cars_Cleaned set model = 'Fiat Linea' where model like 'Fiat Linea%';
update India_Cars_Cleaned set model = 'Fiat Punto' where model like 'Fiat Punto%';
update India_Cars_Cleaned set model = 'Hyundai Grand i10' where model like 'Hyundai Grand i10%';
update India_Cars_Cleaned set model = 'Hyundai Santro' where model like 'Hyundai Santro%';
update India_Cars_Cleaned set model = 'Hyundai i20' where model like 'Hyundai i20%';
update India_Cars_Cleaned set model = 'Jeep Compass' where model like 'Jeep Compass%';
update India_Cars_Cleaned set model = 'Lamborghini Huracan' where model like 'Lamborghini Huracan%';
update India_Cars_Cleaned set model = 'Land Rover Discovery' where model like 'Land Rover Discovery%';
update India_Cars_Cleaned set model = 'Land Rover Range Rover' where model like 'Land Rover Range Rover%';
update India_Cars_Cleaned set model = 'Mahindra Bolero' where model like 'Mahindra Bolero%';
update India_Cars_Cleaned set model = 'Mahindra Bolero' where model like 'Mahindra BOLERO PIK UP Extra Strong%';
update India_Cars_Cleaned set model = 'Mahindra KUV 100' where model like 'Mahindra KUV 100%';
update India_Cars_Cleaned set model = 'Mahindra Scorpio' where model like 'Mahindra Scorpio%';
update India_Cars_Cleaned set model = 'Mahindra TUV 300' where model like 'Mahindra TUV 300%';
update India_Cars_Cleaned set model = 'Mahindra Verito' where model like 'Mahindra Verito%';
update India_Cars_Cleaned set model = 'Maruti Alto' where model like 'Maruti Alto%';
update India_Cars_Cleaned set model = 'Maruti Baleno' where model like 'Maruti Baleno%';
update India_Cars_Cleaned set model = 'Maruti Celerio' where model like 'Maruti Celerio%';
update India_Cars_Cleaned set model = 'Maruti Ciaz' where model like 'Maruti Ciaz%';
update India_Cars_Cleaned set model = 'Maruti Eeco' where model like 'Maruti Eeco%';
update India_Cars_Cleaned set model = 'Maruti Ertiga' where model like 'Maruti Ertiga%';
update India_Cars_Cleaned set model = 'Maruti Swift Dzire' where model like 'Maruti Swift Dzire%';
update India_Cars_Cleaned set model = 'Maruti Wagon R' where model like 'Maruti Wagon R%';
update India_Cars_Cleaned set model = 'Maruti Zen' where model like 'Maruti Zen%';
update India_Cars_Cleaned set model = 'Mercedes-Benz A Class' where model like 'Mercedes-Benz A Class%';
update India_Cars_Cleaned set model = 'Mercedes-Benz E-Class' where model like 'Mercedes-Benz E-Class%';
update India_Cars_Cleaned set model = 'Mercedes-Benz GLA' where model like 'Mercedes-Benz GLA%';
update India_Cars_Cleaned set model = 'Mercedes-Benz GLC' where model like 'Mercedes-Benz GLC%';
update India_Cars_Cleaned set model = 'Tata Indica' where model like 'Tata Indica%';
update India_Cars_Cleaned set model = 'Tata Indigo' where model like 'Tata Indigo%';
update India_Cars_Cleaned set model = 'Tata Nexon' where model like 'Tata Nexon%';
update India_Cars_Cleaned set model = 'Tata Sumo' where model like 'Tata Sumo%';
update India_Cars_Cleaned set model = 'Tata Tiago' where model like 'Tata Tiago%';
update India_Cars_Cleaned set model = 'Tata Tigor' where model like 'Tata Tigor%';
update India_Cars_Cleaned set model = 'Toyota Corolla' where model like 'Toyota Corolla%';
update India_Cars_Cleaned set model = 'Toyota Etios' where model like 'Toyota Etios%';
update India_Cars_Cleaned set model = 'Toyota Fortuner' where model like 'Toyota Fortuner%';
update India_Cars_Cleaned set model = 'Toyota Innova' where model like 'Toyota Innova%';
update India_Cars_Cleaned set model = 'Volvo S60' where model like 'Volvo S60%';
update India_Cars_Cleaned set model = 'Volvo V40' where model like 'Volvo V40%';

  SELECT DISTINCT color, COUNT(*) as nr FROM
  India_Cars_Cleaned GROUP BY color ORDER BY
  color;

update India_Cars_Cleaned set color = 'Unknown' where color like '?%';
update India_Cars_Cleaned set color = 'Red' where color like '%red%';
update India_Cars_Cleaned set color = 'Unknown' where color is null;
update India_Cars_Cleaned set color = 'Blue' where color like '%Blue%';
update India_Cars_Cleaned set color = 'Black' where color like '%Black%';
update India_Cars_Cleaned set color = 'Silver' where color like '%Silver%';
update India_Cars_Cleaned set color = 'Blue' where color like '%Aqua%';
update India_Cars_Cleaned set color = 'White' where color like '%White%';
update India_Cars_Cleaned set color = 'Orange' where color like '%Orange%';
update India_Cars_Cleaned set color = 'Brown' where color like '%Brown%';
update India_Cars_Cleaned set color = 'Brown' where color like '%Chocolate%';
update India_Cars_Cleaned set color = 'Bronze' where color like '%Bronze%';
update India_Cars_Cleaned set color = 'Titanium' where color like '%Titanium%';
update India_Cars_Cleaned set color = 'Yellow' where color like '%Yellow%';
update India_Cars_Cleaned set color = 'Violet' where color like '%Violet%';
update India_Cars_Cleaned set color = 'Titanium' where color like '%Titan%';
update India_Cars_Cleaned set color = 'Grey' where color like '%Grey%';
update India_Cars_Cleaned set color = 'Grey' where color like '%Titanium%';
update India_Cars_Cleaned set color = 'Unknown' where color like '%Other%';
update India_Cars_Cleaned set color = 'Red' where color like '%Maroon%';
update India_Cars_Cleaned set color = 'Brown' where color like '%Beige%';
update India_Cars_Cleaned set color = 'Grey' where color like '%Steel%';
update India_Cars_Cleaned set color = 'Grey' where color like '%Star%';
update India_Cars_Cleaned set color = 'Grey' where color like '%Metal%';
update India_Cars_Cleaned set color = 'Unknown' where color not in (select India_Cars_Cleaned.Color
from India_Cars_Cleaned
group by Color
order by count(Color) desc
LIMIT 14);

select India_Cars_Cleaned.Color, count()
from India_Cars_Cleaned
group by Color
order by count(Color) desc;

  SELECT DISTINCT year, COUNT(*) as nr FROM
  India_Cars_Cleaned GROUP BY year ORDER BY year;

  SELECT DISTINCT transmission_type, COUNT(*) as
  nr FROM India_Cars_Cleaned GROUP BY
  transmission_type ORDER BY transmission_type;

  SELECT DISTINCT fuel_type, COUNT(*) as nr FROM
  India_Cars_Cleaned GROUP BY fuel_type ORDER BY
  fuel_type;

  SELECT DISTINCT one_owner, COUNT(*) as nr FROM
  India_Cars_Cleaned GROUP BY one_owner ORDER BY
  one_owner;

select one_owner
from India_Cars_Cleaned
where one_owner='first';

UPDATE India_Cars_Cleaned
SET one_owner = CASE
    WHEN one_owner = 'first' THEN 'Yes'
    ELSE 'No'
END;

  SELECT DISTINCT body_type, COUNT(*) as nr FROM
  India_Cars_Cleaned GROUP BY body_type ORDER BY
  body_type;

UPDATE India_Cars_Cleaned SET body_type = 'Minivan' WHERE body_type = 'MUV';
UPDATE India_Cars_Cleaned SET body_type = 'Minivan' WHERE body_type = 'Minivans';

  UPDATE India_Cars_Cleaned SET body_type = NULL WHERE body_type IN ('Hybrids', 'Luxury Vehicles');
  UPDATE India_Cars_Cleaned SET body_type = 'Unknown' WHERE body_type is null;

  SELECT DISTINCT drivetrain, COUNT(*) as nr FROM
  India_Cars_Cleaned GROUP BY drivetrain ORDER BY
  drivetrain;
 UPDATE India_Cars_Cleaned SET drivetrain = '2WD'
  WHERE drivetrain IN ('2 WD','2WD','2wd','Two Wheel Drive','Two Whhel Drive','4X2','4x2');
 UPDATE India_Cars_Cleaned SET drivetrain = 'FWD'
  WHERE TRIM(drivetrain) = 'FWD' OR drivetrain = 'Front Wheel Drive';
 UPDATE India_Cars_Cleaned SET drivetrain = 'RWD'
  WHERE drivetrain IN ('RWD','RWD(with MTT)','Rear Wheel Drive with ESP','Rear-wheel drive with ESP');
 UPDATE India_Cars_Cleaned SET drivetrain = '4*4'
  WHERE drivetrain IN ('4 WD','4WD','4X4','4x4','Four Whell Drive');
 UPDATE India_Cars_Cleaned SET drivetrain = 'AWD'
  WHERE drivetrain IN ('AWD','All Wheel Drive','All-wheel drive with Electronic Traction','Permanent all-wheel drive quattro')
update India_Cars_Cleaned SET drivetrain = 'Unknown' where drivetrain='3' or drivetrain is null



select count()
from India_Cars_Cleaned;

alter table India_Cars_Cleaned
add column id integer;

update India_Cars_Cleaned set id = rowid;

drop table if exists India_Cars_Cleaned1;
create table India_Cars_Cleaned1 as
    select
        id,
   brand,
    model,
    color,
    year,
    price_in_euro,
    power_ps,
    transmission_type,
    fuel_type,
    km,
    variant_name,
    max_engine_capacity_new,
    one_owner,
    drivetrain,
    body_type
    from India_Cars_Cleaned;

drop table if exists India_Cars_Cleaned;
alter table India_Cars_Cleaned1
rename to India_Cars_Cleaned;


