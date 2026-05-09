alter table cars_details_merges
    add column id integer;

update cars_details_merges
    set id=rowid;

drop table if exists India_Cars_Cleaned;
-- selectare coloane necesare
create table India_Cars_Cleaned as
    select
        id,
    oem as brand,
    model,
    color,
    myear as year,
    round(((dynx_totalvalue_x)*0.01119),-3) as price_in_euro,
    "Max Power" as power_ps,
    tt as transmision_type,
    fuel_type,
    km_driven as km,
    variant_name,
    max_engine_capacity_new,
    owner_type_new as one_owner,
    "Drive Type" as drivetrain,
    bt as body_type
    from cars_details_merges;

alter table India_Cars_Cleaned
 rename column transmision_type to transmission_type;

SELECT DISTINCT brand, COUNT(*) as nr FROM
  India_Cars_Cleaned GROUP BY brand ORDER BY
  brand;

 UPDATE India_Cars_Cleaned SET brand = 'Mahindra' WHERE brand = 'Mahindra Renault';
  UPDATE India_Cars_Cleaned SET brand = 'Mahindra' WHERE brand = 'Mahindra Ssangyong';


  SELECT DISTINCT model, COUNT(*) as nr, brand FROM
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

-- Pasul 1: Eliminare ani
UPDATE India_Cars_Cleaned SET model = TRIM(REPLACE(model, '2010-2013', '')) WHERE model LIKE '%2010-2013%';
UPDATE India_Cars_Cleaned SET model = TRIM(REPLACE(model, '2014-2016', '')) WHERE model LIKE '%2014-2016%';
UPDATE India_Cars_Cleaned SET model = TRIM(REPLACE(model, '2018-2021', '')) WHERE model LIKE '%2018-2021%';
UPDATE India_Cars_Cleaned SET model = TRIM(REPLACE(model, '2018', ''))      WHERE model LIKE '%Elite i20 2018%';
UPDATE India_Cars_Cleaned SET model = TRIM(REPLACE(model, '2021', ''))      WHERE model LIKE '%Alto 2021%';

-- Pasul 2: Eliminare brand
UPDATE India_Cars_Cleaned SET model = TRIM(REPLACE(model, 'Maruti Suzuki ', '')) WHERE model LIKE '%Maruti Suzuki %';
UPDATE India_Cars_Cleaned SET model = TRIM(REPLACE(model, 'Maruti ', ''))        WHERE model LIKE '%Maruti %';
UPDATE India_Cars_Cleaned SET model = TRIM(REPLACE(model, 'Hyundai ', ''))       WHERE model LIKE '%Hyundai %';
UPDATE India_Cars_Cleaned SET model = TRIM(REPLACE(model, 'Mahindra Renault ', '')) WHERE model LIKE '%Mahindra Renault %';
UPDATE India_Cars_Cleaned SET model = TRIM(REPLACE(model, 'Mahindra ', ''))      WHERE model LIKE '%Mahindra %';
UPDATE India_Cars_Cleaned SET model = TRIM(REPLACE(model, 'Tata ', ''))          WHERE model LIKE '%Tata %';
UPDATE India_Cars_Cleaned SET model = TRIM(REPLACE(model, 'Toyota ', ''))        WHERE model LIKE '%Toyota %';
UPDATE India_Cars_Cleaned SET model = TRIM(REPLACE(model, 'BMW ', ''))           WHERE model LIKE '%BMW %';
UPDATE India_Cars_Cleaned SET model = TRIM(REPLACE(model, 'Audi ', ''))          WHERE model LIKE '%Audi %';
UPDATE India_Cars_Cleaned SET model = TRIM(REPLACE(model, 'Mercedes-Benz ', '')) WHERE model LIKE '%Mercedes-Benz %';
UPDATE India_Cars_Cleaned SET model = TRIM(REPLACE(model, 'Volkswagen ', ''))    WHERE model LIKE '%Volkswagen %';
UPDATE India_Cars_Cleaned SET model = TRIM(REPLACE(model, 'Skoda ', ''))         WHERE model LIKE '%Skoda %';
UPDATE India_Cars_Cleaned SET model = TRIM(REPLACE(model, 'Chevrolet ', ''))     WHERE model LIKE '%Chevrolet %';
UPDATE India_Cars_Cleaned SET model = TRIM(REPLACE(model, 'Ford ', ''))          WHERE model LIKE '%Ford %';
UPDATE India_Cars_Cleaned SET model = TRIM(REPLACE(model, 'Honda ', ''))         WHERE model LIKE '%Honda %';
UPDATE India_Cars_Cleaned SET model = TRIM(REPLACE(model, 'Renault ', ''))       WHERE model LIKE '%Renault %';
UPDATE India_Cars_Cleaned SET model = TRIM(REPLACE(model, 'Nissan ', ''))        WHERE model LIKE '%Nissan %';
UPDATE India_Cars_Cleaned SET model = TRIM(REPLACE(model, 'Kia ', ''))           WHERE model LIKE '%Kia %';
UPDATE India_Cars_Cleaned SET model = TRIM(REPLACE(model, 'Jeep ', ''))          WHERE model LIKE '%Jeep %';
UPDATE India_Cars_Cleaned SET model = TRIM(REPLACE(model, 'Land Rover ', ''))    WHERE model LIKE '%Land Rover %';
UPDATE India_Cars_Cleaned SET model = TRIM(REPLACE(model, 'Volvo ', ''))         WHERE model LIKE '%Volvo %';
UPDATE India_Cars_Cleaned SET model = TRIM(REPLACE(model, 'Mitsubishi ', ''))    WHERE model LIKE '%Mitsubishi %';
UPDATE India_Cars_Cleaned SET model = TRIM(REPLACE(model, 'Porsche ', ''))       WHERE model LIKE '%Porsche %';
UPDATE India_Cars_Cleaned SET model = TRIM(REPLACE(model, 'Jaguar ', ''))        WHERE model LIKE '%Jaguar %';
UPDATE India_Cars_Cleaned SET model = TRIM(REPLACE(model, 'MG ', ''))            WHERE model LIKE '%MG %';
UPDATE India_Cars_Cleaned SET model = TRIM(REPLACE(model, 'Lexus ', ''))         WHERE model LIKE '%Lexus %';
UPDATE India_Cars_Cleaned SET model = TRIM(REPLACE(model, 'Isuzu ', ''))         WHERE model LIKE '%Isuzu %';
UPDATE India_Cars_Cleaned SET model = TRIM(REPLACE(model, 'Datsun ', ''))        WHERE model LIKE '%Datsun %';
UPDATE India_Cars_Cleaned SET model = TRIM(REPLACE(model, 'Fiat ', ''))          WHERE model LIKE '%Fiat %';
UPDATE India_Cars_Cleaned SET model = TRIM(REPLACE(model, 'Force ', ''))         WHERE model LIKE '%Force %';
UPDATE India_Cars_Cleaned SET model = TRIM(REPLACE(model, 'Mini ', ''))          WHERE model LIKE '%Mini %';

-- Pasul 3: Unificare familii (SPECIFIC inainte de GENERAL)

-- MARUTI
UPDATE India_Cars_Cleaned SET model = 'Swift Dzire' WHERE model LIKE '%Swift Dzire%';
UPDATE India_Cars_Cleaned SET model = 'Alto'        WHERE model LIKE '%Alto 800%';
UPDATE India_Cars_Cleaned SET model = 'Alto'        WHERE model LIKE '%Alto K10%';
UPDATE India_Cars_Cleaned SET model = 'Baleno'      WHERE model LIKE '%Baleno RS%';
UPDATE India_Cars_Cleaned SET model = 'Celerio'     WHERE model LIKE '%Celerio Tour%';
UPDATE India_Cars_Cleaned SET model = 'Celerio'     WHERE model LIKE '%Celerio X%';
UPDATE India_Cars_Cleaned SET model = 'Ciaz'        WHERE model = 'Ciaz S';
UPDATE India_Cars_Cleaned SET model = 'Eeco'        WHERE model LIKE '%Eeco Cargo%';
UPDATE India_Cars_Cleaned SET model = 'Ertiga'      WHERE model LIKE '%Ertiga Tour%';
UPDATE India_Cars_Cleaned SET model = 'Wagon R'     WHERE model LIKE '%Wagon R Stingray%';
UPDATE India_Cars_Cleaned SET model = 'Zen'         WHERE model LIKE '%Zen Estilo%';
UPDATE India_Cars_Cleaned SET model = 'Zen'         WHERE model = 'Estilo';
UPDATE India_Cars_Cleaned SET model = 'Brezza'      WHERE model LIKE '%Vitara Brezza%';
UPDATE India_Cars_Cleaned SET model = 'SX4 S-Cross' WHERE model LIKE '%SX4 S Cross%';

-- HYUNDAI
UPDATE India_Cars_Cleaned SET model = 'i10' WHERE model LIKE '%Grand i10%';
UPDATE India_Cars_Cleaned SET model = 'i20' WHERE model LIKE '%Elite i20%';
UPDATE India_Cars_Cleaned SET model = 'i20' WHERE model LIKE '%i20 Active%';
UPDATE India_Cars_Cleaned SET model = 'i20' WHERE model LIKE '%i20 N Line%';
UPDATE India_Cars_Cleaned SET model = 'Santro' WHERE model LIKE '%Santro Xing%';
UPDATE India_Cars_Cleaned SET model = 'Xcent'  WHERE model LIKE '%Xcent Prime%';

-- MAHINDRA
UPDATE India_Cars_Cleaned SET model = 'Bolero Pik Up'    WHERE model LIKE '%BOLERO PIK UP%';
UPDATE India_Cars_Cleaned SET model = 'Bolero Pik Up'    WHERE model LIKE '%Bolero Pik Up%';
UPDATE India_Cars_Cleaned SET model = 'Bolero Camper'    WHERE model LIKE '%Bolero Camper%';
UPDATE India_Cars_Cleaned SET model = 'Bolero Maxi Truck' WHERE model LIKE '%Bolero Maxi Truck%';
UPDATE India_Cars_Cleaned SET model = 'Bolero'           WHERE model LIKE '%Bolero Power Plus%';
UPDATE India_Cars_Cleaned SET model = 'Bolero'           WHERE model LIKE '%Bolero Neo%';
UPDATE India_Cars_Cleaned SET model = 'KUV 100'          WHERE model LIKE '%KUV 100 NXT%';
UPDATE India_Cars_Cleaned SET model = 'Scorpio'          WHERE model LIKE '%Scorpio Classic%';
UPDATE India_Cars_Cleaned SET model = 'Scorpio'          WHERE model LIKE '%Scorpio N%';
UPDATE India_Cars_Cleaned SET model = 'TUV 300'          WHERE model LIKE '%TUV 300 Plus%';
UPDATE India_Cars_Cleaned SET model = 'e2o'              WHERE model LIKE '%e2o Plus%';
UPDATE India_Cars_Cleaned SET model = 'Verito'           WHERE model LIKE '%Logan%';

-- TATA
UPDATE India_Cars_Cleaned SET model = 'Nexon'   WHERE model LIKE '%Nexon EV%';
UPDATE India_Cars_Cleaned SET model = 'Safari'  WHERE model LIKE '%New Safari%';
UPDATE India_Cars_Cleaned SET model = 'Safari'  WHERE model LIKE '%Safari Storme%';
UPDATE India_Cars_Cleaned SET model = 'Sumo'    WHERE model LIKE '%Sumo Victa%';
UPDATE India_Cars_Cleaned SET model = 'Tiago'   WHERE model LIKE '%Tiago NRG%';
UPDATE India_Cars_Cleaned SET model = 'Tigor'   WHERE model LIKE '%Tigor EV%';
UPDATE India_Cars_Cleaned SET model = 'Indica'  WHERE model LIKE '%Indica Xeta%';
UPDATE India_Cars_Cleaned SET model = 'Indica'  WHERE model LIKE '%Indica eV2%';
UPDATE India_Cars_Cleaned SET model = 'Indigo'  WHERE model LIKE '%Indigo Marina%';

-- TOYOTA
UPDATE India_Cars_Cleaned SET model = 'Innova'              WHERE model LIKE '%Innova Crysta%';
UPDATE India_Cars_Cleaned SET model = 'Fortuner'            WHERE model LIKE '%Fortuner Legender%';
UPDATE India_Cars_Cleaned SET model = 'Corolla'             WHERE model LIKE '%Corolla Altis%';
UPDATE India_Cars_Cleaned SET model = 'Etios'               WHERE model LIKE '%Platinum Etios%';
UPDATE India_Cars_Cleaned SET model = 'Land Cruiser Prado'  WHERE model LIKE '%prado%';
UPDATE India_Cars_Cleaned SET model = 'Urban Cruiser'       WHERE model LIKE '%Urban cruiser%';

-- BMW
UPDATE India_Cars_Cleaned SET model = '3 Series' WHERE model LIKE '%3 Series GT%';
UPDATE India_Cars_Cleaned SET model = '3 Series' WHERE model LIKE '%3 Series Gran Limousine%';

-- MERCEDES-BENZ
UPDATE India_Cars_Cleaned SET model = 'A-Class'  WHERE model LIKE '%A-Class Limousine%';
UPDATE India_Cars_Cleaned SET model = 'A-Class'  WHERE model LIKE '%A Class%';
UPDATE India_Cars_Cleaned SET model = 'GLC'      WHERE model LIKE '%GLC Coupe%';
UPDATE India_Cars_Cleaned SET model = 'E-Class'  WHERE model LIKE '%E-Class All-Terrain%';
UPDATE India_Cars_Cleaned SET model = 'G-Class'  WHERE model = 'G';

-- MINI
UPDATE India_Cars_Cleaned SET model = 'Cooper'            WHERE model LIKE '%3 DOOR%';
UPDATE India_Cars_Cleaned SET model = 'Cooper'            WHERE model LIKE '%5 DOOR%';
UPDATE India_Cars_Cleaned SET model = 'Cooper Convertible' WHERE model LIKE '%Cooper Convertible%';
UPDATE India_Cars_Cleaned SET model = 'Cooper'            WHERE model LIKE '%Cooper SE%';

-- SKODA
UPDATE India_Cars_Cleaned SET model = 'Laura' WHERE model LIKE '%New Laura%';

-- CHEVROLET
UPDATE India_Cars_Cleaned SET model = 'Aveo' WHERE model LIKE '%Aveo U-VA%';
UPDATE India_Cars_Cleaned SET model = 'Sail' WHERE model LIKE '%Sail Hatchback%';

-- VOLVO
UPDATE India_Cars_Cleaned SET model = 'XC90' WHERE model LIKE '%XC 90%';
UPDATE India_Cars_Cleaned SET model = 'S80'  WHERE model LIKE '%S 80%';

-- FIAT
UPDATE India_Cars_Cleaned SET model = 'Punto'      WHERE model LIKE '%Grande Punto%';
UPDATE India_Cars_Cleaned SET model = 'Punto'      WHERE model LIKE '%Punto Abarth%';
UPDATE India_Cars_Cleaned SET model = 'Punto'      WHERE model LIKE '%Punto EVO%';
UPDATE India_Cars_Cleaned SET model = 'Punto'      WHERE model LIKE '%Punto Pure%';
UPDATE India_Cars_Cleaned SET model = 'Avventura'  WHERE model LIKE '%Avventura Urban Cross%';
UPDATE India_Cars_Cleaned SET model = 'Linea'      WHERE model LIKE '%Linea Classic%';

-- NISSAN
UPDATE India_Cars_Cleaned SET model = 'Micra' WHERE model LIKE '%Micra Active%';

-- LAND ROVER
UPDATE India_Cars_Cleaned SET model = 'Discovery' WHERE model LIKE '%Discovery 4%';

-- JEEP
UPDATE India_Cars_Cleaned SET model = 'Compass' WHERE model LIKE '%Compass Trailhawk%';

-- ALTELE
UPDATE India_Cars_Cleaned SET model = 'Corsa'  WHERE model LIKE '%OpelCorsa%';
UPDATE India_Cars_Cleaned SET model = 'MU-7'   WHERE model LIKE '%MU 7%';
UPDATE India_Cars_Cleaned SET model = 'Stile'  WHERE model LIKE '%Ashok Leyland Stile%';

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

select distinct fuel_type from India_Cars_Cleaned group by fuel_type;

select count()
from India_Cars_Cleaned;

alter table India_Cars
add column id integer;

update India_Cars set id = rowid;

alter table India_Cars_Cleaned rename to rezerva;

-- test înainte să modifici


update India_Cars_Cleaned
    set power_ps=CAST(SUBSTR(power_ps, 1, INSTR(power_ps, 'bhp') - 3) as real);

UPDATE India_Cars_Cleaned
SET power_ps = ROUND(India_Cars_Cleaned.power_ps * 1.01387, 1);

UPDATE India_Cars_Cleaned
SET power_ps = ROUND (India_Cars_Cleaned.power_ps , 0);

alter table  India_Cars_Cleaned rename to rezerva;

CREATE TABLE India_Cars_Cleaned
(
    id                      INTEGER,
    brand                   TEXT,
    model                   TEXT,
    color                   TEXT,
    year                    INTEGER,    -- an fabricatie => intreg
    price_in_euro           INTEGER,       -- pret => zecimale
    power_ps                INTEGER,    -- cai putere => intreg
    transmission_type       TEXT,
    fuel_type               TEXT,
    km                      INTEGER,    -- kilometraj => intreg
    variant_name            TEXT,
    max_engine_capacity_new INTEGER,       -- capacitate motor => zecimale (ex. 1.6, 2.0)
    one_owner  \             text,    -- boolean: 0 sau 1
    drivetrain              TEXT,
    body_type               TEXT
);

INSERT INTO India_Cars_Cleaned
SELECT
    CAST(id AS INTEGER),
    brand,
    model,
    color,
    CAST(year AS INTEGER),
    CAST(price_in_euro AS REAL),
    CAST(power_ps AS INTEGER),
    transmission_type,
    fuel_type,
    CAST(km AS INTEGER),
    variant_name,
    CAST(max_engine_capacity_new AS REAL),
    one_owner,
    drivetrain,
    body_type
FROM rezerva;

drop table rezerva;

SELECT
    COUNT(*)                          AS total_randuri,
    COUNT(*) - COUNT(brand)           AS null_brand,
    COUNT(*) - COUNT(model)           AS null_model,
    COUNT(*) - COUNT(Color)           AS null_color,
    COUNT(*) - COUNT(year)            AS null_year,
    COUNT(*) - COUNT(price_in_euro)   AS null_price,
    COUNT(*) - COUNT(power_ps)        AS null_power_ps,
    COUNT(*) - COUNT(transmission_type) AS null_transmission,
    COUNT(*) - COUNT(fuel_type)       AS null_fuel_type,
    COUNT(*) - COUNT(km)              AS null_km,
    COUNT(*) - COUNT(variant_name)    AS null_variant,
    COUNT(*) - COUNT(max_engine_capacity_new) AS null_engine_capacity,
    COUNT(*) - COUNT(one_owner)       AS null_one_owner,
    COUNT(*) - COUNT(drivetrain)      AS null_drivetrain,
    COUNT(*) - COUNT(body_type)       AS null_body_type
FROM India_Cars_Cleaned;

-- power_ps per brand + model+body_type
UPDATE India_Cars_Cleaned
SET power_ps = (
    SELECT ROUND(AVG(power_ps))
    FROM India_Cars_Cleaned AS sub
    WHERE sub.brand = sub.brand
      AND sub.model = sub.model
      and sub.max_engine_capacity_new between sub.max_engine_capacity_new-10 and sub.max_engine_capacity_new+10
      AND sub.power_ps>10
)
WHERE power_ps is null or power_ps < 10;

delete from India_Cars_Cleaned where power_ps is null;

-- max_engine_capacity_new per brand + model+body_type+year
UPDATE India_Cars_Cleaned
SET max_engine_capacity_new = (
    SELECT ROUND(AVG(max_engine_capacity_new), 1)
    FROM India_Cars_Cleaned AS sub
    WHERE sub.brand = India_Cars_Cleaned.brand
      AND sub.model = India_Cars_Cleaned.model
        and sub.body_type= India_Cars_Cleaned.body_type
      and sub.year between India_Cars_Cleaned.year-2 and India_Cars_Cleaned.year+2
      AND sub.max_engine_capacity_new IS NOT NULL

)
WHERE max_engine_capacity_new IS NULL or max_engine_capacity_new<500;

--cele ramase
UPDATE India_Cars_Cleaned
SET max_engine_capacity_new = (
    SELECT ROUND(AVG(max_engine_capacity_new), 1)
    FROM India_Cars_Cleaned AS sub
    WHERE sub.brand = sub.brand
      AND sub.model = sub.model
        and sub.body_type= sub.body_type
      AND sub.max_engine_capacity_new IS NOT NULL
    and fuel_type<>'electric'

)
WHERE max_engine_capacity_new IS NULL or max_engine_capacity_new<500;

update India_Cars_Cleaned set max_engine_capacity_new=null where max_engine_capacity_new<>0 and fuel_type='electric';

select * from India_Cars_Cleaned where max_engine_capacity_new is null;
select * from India_Cars_Cleaned where fuel_type='electric';

select * from India_Cars_Cleaned where power_ps is null;
