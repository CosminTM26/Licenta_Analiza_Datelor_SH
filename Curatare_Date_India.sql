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
-- AUDI
UPDATE India_Cars_Cleaned SET model = 'Audi A3' WHERE model LIKE 'Audi A3 %' AND model NOT LIKE 'Audi A3 cabriolet%';

-- BMW
UPDATE India_Cars_Cleaned SET model = 'BMW 3 Series' WHERE model LIKE 'BMW 3 Series %' AND model NOT LIKE '%GT%' AND model NOT LIKE '%Gran Limousine%';

-- CHEVROLET
UPDATE India_Cars_Cleaned SET model = 'Chevrolet Aveo' WHERE model LIKE 'Chevrolet Aveo %' AND model NOT LIKE '%U-VA%';
UPDATE India_Cars_Cleaned SET model = 'Chevrolet Sail' WHERE model LIKE 'Chevrolet Sail %' AND model NOT LIKE '%Hatchback%';

-- FIAT
UPDATE India_Cars_Cleaned SET model = 'Fiat Avventura' WHERE model LIKE 'Fiat Avventura %' AND model NOT LIKE '%Urban Cross%';
UPDATE India_Cars_Cleaned SET model = 'Fiat Linea' WHERE model LIKE 'Fiat Linea %' AND model NOT LIKE '%Classic%';
UPDATE India_Cars_Cleaned SET model = 'Fiat Punto' WHERE model LIKE 'Fiat Punto %' AND model NOT LIKE '%Abarth%' AND model NOT LIKE '%EVO%' AND model NOT LIKE '%Pure%';

-- HYUNDAI
UPDATE India_Cars_Cleaned SET model = 'Hyundai Grand i10' WHERE model LIKE 'Hyundai Grand i10 %' AND model NOT LIKE '%Nios%';
UPDATE India_Cars_Cleaned SET model = 'Hyundai Santro' WHERE model LIKE 'Hyundai Santro %' AND model NOT LIKE '%Xing%';
UPDATE India_Cars_Cleaned SET model = 'Hyundai i20' WHERE model LIKE 'Hyundai i20 %' AND model NOT LIKE '%Active%' AND model NOT LIKE '%N Line%';

-- JEEP & LAMBORGHINI
UPDATE India_Cars_Cleaned SET model = 'Jeep Compass' WHERE model LIKE 'Jeep Compass %' AND model NOT LIKE '%Trailhawk%';
UPDATE India_Cars_Cleaned SET model = 'Lamborghini Huracan' WHERE model LIKE 'Lamborghini Huracan %' AND model NOT LIKE '%EVO%';

-- MAHINDRA
UPDATE India_Cars_Cleaned SET model = 'Mahindra KUV 100' WHERE model LIKE 'Mahindra KUV 100 %' AND model NOT LIKE '%NXT%';
UPDATE India_Cars_Cleaned SET model = 'Mahindra Scorpio' WHERE model LIKE 'Mahindra Scorpio %' AND model NOT LIKE '%Classic%' AND model NOT LIKE '%N%';
UPDATE India_Cars_Cleaned SET model = 'Mahindra TUV 300' WHERE model LIKE 'Mahindra TUV 300 %' AND model NOT LIKE '%Plus%';
UPDATE India_Cars_Cleaned SET model = 'Mahindra Verito' WHERE model LIKE 'Mahindra Verito %' AND model NOT LIKE '%Vibe%';

-- MARUTI
UPDATE India_Cars_Cleaned SET model = 'Maruti Celerio' WHERE model LIKE 'Maruti Celerio %' AND model NOT LIKE '%Tour%' AND model NOT LIKE '%X%';
UPDATE India_Cars_Cleaned SET model = 'Maruti Ciaz' WHERE model LIKE 'Maruti Ciaz %' AND model NOT LIKE '%S%';
UPDATE India_Cars_Cleaned SET model = 'Maruti Eeco' WHERE model LIKE 'Maruti Eeco %' AND model NOT LIKE '%Cargo%';
UPDATE India_Cars_Cleaned SET model = 'Maruti Ertiga' WHERE model LIKE 'Maruti Ertiga %' AND model NOT LIKE '%Tour%';
UPDATE India_Cars_Cleaned SET model = 'Maruti Swift Dzire' WHERE model LIKE 'Maruti Swift Dzire %' AND model NOT LIKE '%Tour%';
UPDATE India_Cars_Cleaned SET model = 'Maruti Wagon R' WHERE model LIKE 'Maruti Wagon R %' AND model NOT LIKE '%Stingray%';
UPDATE India_Cars_Cleaned SET model = 'Maruti Zen' WHERE model LIKE 'Maruti Zen %' AND model NOT LIKE '%Estilo%';

-- MERCEDES-BENZ
UPDATE India_Cars_Cleaned SET model = 'Mercedes-Benz GLA' WHERE model LIKE 'Mercedes-Benz GLA%'; -- (Acesta e sigur de lăsat normal)
UPDATE India_Cars_Cleaned SET model = 'Mercedes-Benz E-Class' WHERE model LIKE 'Mercedes-Benz E-Class %' AND model NOT LIKE '%All-Terrain%';
UPDATE India_Cars_Cleaned SET model = 'Mercedes-Benz GLC' WHERE model LIKE 'Mercedes-Benz GLC %' AND model NOT LIKE '%Coupe%';

-- TATA
UPDATE India_Cars_Cleaned SET model = 'Tata Indica' WHERE model LIKE 'Tata Indica %' AND model NOT LIKE '%Xeta%' AND model NOT LIKE '%eV2%';
UPDATE India_Cars_Cleaned SET model = 'Tata Indigo' WHERE model LIKE 'Tata Indigo %' AND model NOT LIKE '%Marina%';
UPDATE India_Cars_Cleaned SET model = 'Tata Nexon' WHERE model LIKE 'Tata Nexon %' AND model NOT LIKE '%EV%';
UPDATE India_Cars_Cleaned SET model = 'Tata Sumo' WHERE model LIKE 'Tata Sumo %' AND model NOT LIKE '%Victa%';
UPDATE India_Cars_Cleaned SET model = 'Tata Tiago' WHERE model LIKE 'Tata Tiago %' AND model NOT LIKE '%NRG%';
UPDATE India_Cars_Cleaned SET model = 'Tata Tigor' WHERE model LIKE 'Tata Tigor %' AND model NOT LIKE '%EV%';

-- TOYOTA & VOLVO
UPDATE India_Cars_Cleaned SET model = 'Toyota Corolla' WHERE model LIKE 'Toyota Corolla %' AND model NOT LIKE '%Altis%';
UPDATE India_Cars_Cleaned SET model = 'Toyota Fortuner' WHERE model LIKE 'Toyota Fortuner %' AND model NOT LIKE '%Legender%';
UPDATE India_Cars_Cleaned SET model = 'Volvo S60' WHERE model LIKE 'Volvo S60 %' AND model NOT LIKE '%Cross Country%';
UPDATE India_Cars_Cleaned SET model = 'Volvo V40' WHERE model LIKE 'Volvo V40 %' AND model NOT LIKE '%Cross Country%';

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
  WHERE drivetrain IN ('AWD','All Wheel Drive','All-wheel drive with Electronic Traction','Permanent all-wheel drive quattro');
update India_Cars_Cleaned SET drivetrain = 'Unknown' where drivetrain='3' or drivetrain is null;



select count()
from India_Cars_Cleaned;

alter table India_Cars_Cleaned
add column id integer;

update India_Cars_Cleaned set id = rowid;



