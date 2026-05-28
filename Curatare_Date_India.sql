-- ============================================================
-- SCRIPT CURATARE DATE: Piata auto SH din India
-- Sursa: tabel cars_details_merges (date brute din dataset)
-- Rezultat: tabel India_Cars_Cleaned cu date standardizate
-- Pasi: creare tabel (conversii INR→EUR, BHP→PS, cc→litri, kmpl→l/100km) →
--       eliminare invalide → corectie brand → modele →
--       culori → transmisie → combustibil → tractiune/proprietar/
--       caroserie/seller/state → imputare power_ps + engine_type +
--       consum → deduplicare → eliminare outlieri → verificare
-- ============================================================

-- ============================================================
-- PASUL 0: CREARE TABEL CURATAT
-- Selectam coloanele relevante, convertim unitati si redenumim
-- Pret: INR -> EUR (curs: 1 INR = 0.01119 EUR)
-- Putere: BHP -> PS (factor: 1.01387)
-- Cilindree: cm3 -> litri (/1000)
-- ============================================================

update cars_details_merges
set id=rowid;

drop table if exists India_Cars_Cleaned;
create table India_Cars_Cleaned
(
    id                       integer,
    brand                    text,
    model                    text,
    color                    text,
    year                     integer,
    price_in_euro            integer,
    power_ps                 integer,
    transmission_type        text,
    fuel_type                text,
    km                       integer,
    engine_type              real,
    fuel_consumption_l_100km real,
    one_owner                text,
    drivetrain               text,
    body_type                text,
    seller_type              text,
    state                    text
);

insert into India_Cars_Cleaned
select id,
       oem                                                      as brand,
       model,
       color                                                    as color,
       myear                                                    as year,
       cast(round(dynx_totalvalue_x * 0.01119, -3) as integer)  as price_in_euro,
       cast(ROUND("Max Power" * 1.01387, 0) as integer)         as power_ps,
       tt                                                       as transmission_type,
       fuel_type,
       cast(km_driven as integer)                               as km,
       cast(round(max_engine_capacity_new / 1000, 1) as double) as engine_type,
       CAST(CASE
                WHEN mileage_new LIKE '%kmpl%'
                    THEN ROUND(100.0 / NULLIF(CAST(SUBSTR(mileage_new, 1, INSTR(mileage_new, ' ') - 1) AS REAL), 0), 1)
                ELSE NULL
           END AS REAL)                                         as fuel_consumption_l_100km,
       owner_type_new                                           as one_owner,
       "Drive Type"                                             as drivetrain,
       bt                                                       as body_type,
       seller_type_new                                          as seller_type,
       state
from cars_details_merges;


-- ============================================================
-- PASUL 1b: ELIMINARE RANDURI INVALIDE
-- Stergem randuri cu valori nule, negative sau imposibile
-- ============================================================

DELETE
FROM India_Cars_Cleaned
WHERE price_in_euro IS NULL
   OR price_in_euro <= 0;

DELETE
FROM India_Cars_Cleaned
WHERE km IS NULL
   OR km < 0;

DELETE
FROM India_Cars_Cleaned
WHERE year IS NULL
   OR year NOT BETWEEN 1900 AND 2026;

-- ============================================================
-- PASUL 2: CORECTIE BRAND
-- Unificam sub-brandurile Mahindra (Mahindra Renault, Mahindra Ssangyong)
-- ============================================================
UPDATE India_Cars_Cleaned
SET brand = 'Mahindra'
WHERE brand = 'Mahindra Renault';
UPDATE India_Cars_Cleaned
SET brand = 'Mahindra'
WHERE brand = 'Mahindra Ssangyong';

UPDATE India_Cars_Cleaned
SET brand = TRIM(brand);

-- ============================================================
-- PASUL 3: STANDARDIZARE NUME MODELE
-- Eliminam variantele de echipare, sufixe si prefixe
-- Regula: variantele mai specifice se proceseaza PRIMELE
-- ============================================================

-- Standardizare variante specifice per brand
-- AUDI
UPDATE India_Cars_Cleaned
SET model = 'Audi A3'
WHERE model LIKE 'Audi A3 %'
  AND model NOT LIKE 'Audi A3 cabriolet%';

-- BMW
UPDATE India_Cars_Cleaned
SET model = 'BMW 3 Series'
WHERE model LIKE 'BMW 3 Series %'
  AND model NOT LIKE '%GT%'
  AND model NOT LIKE '%Gran Limousine%';

-- CHEVROLET
UPDATE India_Cars_Cleaned
SET model = 'Chevrolet Aveo'
WHERE model LIKE 'Chevrolet Aveo %'
  AND model NOT LIKE '%U-VA%';
UPDATE India_Cars_Cleaned
SET model = 'Chevrolet Sail'
WHERE model LIKE 'Chevrolet Sail %'
  AND model NOT LIKE '%Hatchback%';

-- FIAT
UPDATE India_Cars_Cleaned
SET model = 'Fiat Avventura'
WHERE model LIKE 'Fiat Avventura %'
  AND model NOT LIKE '%Urban Cross%';
UPDATE India_Cars_Cleaned
SET model = 'Fiat Linea'
WHERE model LIKE 'Fiat Linea %'
  AND model NOT LIKE '%Classic%';
UPDATE India_Cars_Cleaned
SET model = 'Fiat Punto'
WHERE model LIKE 'Fiat Punto %'
  AND model NOT LIKE '%Abarth%'
  AND model NOT LIKE '%EVO%'
  AND model NOT LIKE '%Pure%';

-- HYUNDAI
UPDATE India_Cars_Cleaned
SET model = 'Hyundai Grand i10'
WHERE model LIKE 'Hyundai Grand i10 %'
  AND model NOT LIKE '%Nios%';
UPDATE India_Cars_Cleaned
SET model = 'Hyundai Santro'
WHERE model LIKE 'Hyundai Santro %'
  AND model NOT LIKE '%Xing%';
UPDATE India_Cars_Cleaned
SET model = 'Hyundai i20'
WHERE model LIKE 'Hyundai i20 %'
  AND model NOT LIKE '%Active%'
  AND model NOT LIKE '%N Line%';

-- JEEP & LAMBORGHINI
UPDATE India_Cars_Cleaned
SET model = 'Jeep Compass'
WHERE model LIKE 'Jeep Compass %'
  AND model NOT LIKE '%Trailhawk%';
UPDATE India_Cars_Cleaned
SET model = 'Lamborghini Huracan'
WHERE model LIKE 'Lamborghini Huracan %'
  AND model NOT LIKE '%EVO%';

-- MAHINDRA
UPDATE India_Cars_Cleaned
SET model = 'Mahindra KUV 100'
WHERE model LIKE 'Mahindra KUV 100 %'
  AND model NOT LIKE '%NXT%';
UPDATE India_Cars_Cleaned
SET model = 'Mahindra Scorpio'
WHERE model LIKE 'Mahindra Scorpio %'
  AND model NOT LIKE '%Classic%'
  AND model NOT LIKE '%N%';
UPDATE India_Cars_Cleaned
SET model = 'Mahindra TUV 300'
WHERE model LIKE 'Mahindra TUV 300 %'
  AND model NOT LIKE '%Plus%';
UPDATE India_Cars_Cleaned
SET model = 'Mahindra Verito'
WHERE model LIKE 'Mahindra Verito %'
  AND model NOT LIKE '%Vibe%';

-- MARUTI
UPDATE India_Cars_Cleaned
SET model = 'Maruti Celerio'
WHERE model LIKE 'Maruti Celerio %'
  AND model NOT LIKE '%Tour%'
  AND model NOT LIKE '%X%';
UPDATE India_Cars_Cleaned
SET model = 'Maruti Ciaz'
WHERE model LIKE 'Maruti Ciaz %'
  AND model NOT LIKE '%S%';
UPDATE India_Cars_Cleaned
SET model = 'Maruti Eeco'
WHERE model LIKE 'Maruti Eeco %'
  AND model NOT LIKE '%Cargo%';
UPDATE India_Cars_Cleaned
SET model = 'Maruti Ertiga'
WHERE model LIKE 'Maruti Ertiga %'
  AND model NOT LIKE '%Tour%';
UPDATE India_Cars_Cleaned
SET model = 'Maruti Swift Dzire'
WHERE model LIKE 'Maruti Swift Dzire %'
  AND model NOT LIKE '%Tour%';
UPDATE India_Cars_Cleaned
SET model = 'Maruti Wagon R'
WHERE model LIKE 'Maruti Wagon R %'
  AND model NOT LIKE '%Stingray%';
UPDATE India_Cars_Cleaned
SET model = 'Maruti Zen'
WHERE model LIKE 'Maruti Zen %'
  AND model NOT LIKE '%Estilo%';

-- MERCEDES-BENZ
UPDATE India_Cars_Cleaned
SET model = 'Mercedes-Benz GLA'
WHERE model LIKE 'Mercedes-Benz GLA%';
UPDATE India_Cars_Cleaned
SET model = 'Mercedes-Benz E-Class'
WHERE model LIKE 'Mercedes-Benz E-Class %'
  AND model NOT LIKE '%All-Terrain%';
UPDATE India_Cars_Cleaned
SET model = 'Mercedes-Benz GLC'
WHERE model LIKE 'Mercedes-Benz GLC %'
  AND model NOT LIKE '%Coupe%';

-- TATA
UPDATE India_Cars_Cleaned
SET model = 'Tata Indica'
WHERE model LIKE 'Tata Indica %'
  AND model NOT LIKE '%Xeta%'
  AND model NOT LIKE '%eV2%';
UPDATE India_Cars_Cleaned
SET model = 'Tata Indigo'
WHERE model LIKE 'Tata Indigo %'
  AND model NOT LIKE '%Marina%';
UPDATE India_Cars_Cleaned
SET model = 'Tata Nexon'
WHERE model LIKE 'Tata Nexon %'
  AND model NOT LIKE '%EV%';
UPDATE India_Cars_Cleaned
SET model = 'Tata Sumo'
WHERE model LIKE 'Tata Sumo %'
  AND model NOT LIKE '%Victa%';
UPDATE India_Cars_Cleaned
SET model = 'Tata Tiago'
WHERE model LIKE 'Tata Tiago %'
  AND model NOT LIKE '%NRG%';
UPDATE India_Cars_Cleaned
SET model = 'Tata Tigor'
WHERE model LIKE 'Tata Tigor %'
  AND model NOT LIKE '%EV%';

-- TOYOTA & VOLVO
UPDATE India_Cars_Cleaned
SET model = 'Toyota Corolla'
WHERE model LIKE 'Toyota Corolla %'
  AND model NOT LIKE '%Altis%';
UPDATE India_Cars_Cleaned
SET model = 'Toyota Fortuner'
WHERE model LIKE 'Toyota Fortuner %'
  AND model NOT LIKE '%Legender%';
UPDATE India_Cars_Cleaned
SET model = 'Volvo S60'
WHERE model LIKE 'Volvo S60 %'
  AND model NOT LIKE '%Cross Country%';
UPDATE India_Cars_Cleaned
SET model = 'Volvo V40'
WHERE model LIKE 'Volvo V40 %'
  AND model NOT LIKE '%Cross Country%';

-- Eliminare ani din numele modelului
UPDATE India_Cars_Cleaned
SET model = TRIM(REPLACE(model, '2010-2013', ''))
WHERE model LIKE '%2010-2013%';
UPDATE India_Cars_Cleaned
SET model = TRIM(REPLACE(model, '2014-2016', ''))
WHERE model LIKE '%2014-2016%';
UPDATE India_Cars_Cleaned
SET model = TRIM(REPLACE(model, '2018-2021', ''))
WHERE model LIKE '%2018-2021%';
UPDATE India_Cars_Cleaned
SET model = TRIM(REPLACE(model, '2018', ''))
WHERE model LIKE '%Elite i20 2018%';
UPDATE India_Cars_Cleaned
SET model = TRIM(REPLACE(model, '2021', ''))
WHERE model LIKE '%Alto 2021%';

-- Eliminare prefix brand din model
UPDATE India_Cars_Cleaned
SET model = TRIM(REPLACE(model, 'Maruti Suzuki ', ''))
WHERE model LIKE '%Maruti Suzuki %';
UPDATE India_Cars_Cleaned
SET model = TRIM(REPLACE(model, 'Maruti ', ''))
WHERE model LIKE '%Maruti %';
UPDATE India_Cars_Cleaned
SET model = TRIM(REPLACE(model, 'Hyundai ', ''))
WHERE model LIKE '%Hyundai %';
UPDATE India_Cars_Cleaned
SET model = TRIM(REPLACE(model, 'Mahindra Renault ', ''))
WHERE model LIKE '%Mahindra Renault %';
UPDATE India_Cars_Cleaned
SET model = TRIM(REPLACE(model, 'Mahindra ', ''))
WHERE model LIKE '%Mahindra %';
UPDATE India_Cars_Cleaned
SET model = TRIM(REPLACE(model, 'Tata ', ''))
WHERE model LIKE '%Tata %';
UPDATE India_Cars_Cleaned
SET model = TRIM(REPLACE(model, 'Toyota ', ''))
WHERE model LIKE '%Toyota %';
UPDATE India_Cars_Cleaned
SET model = TRIM(REPLACE(model, 'BMW ', ''))
WHERE model LIKE '%BMW %';
UPDATE India_Cars_Cleaned
SET model = TRIM(REPLACE(model, 'Audi ', ''))
WHERE model LIKE '%Audi %';
UPDATE India_Cars_Cleaned
SET model = TRIM(REPLACE(model, 'Mercedes-Benz ', ''))
WHERE model LIKE '%Mercedes-Benz %';
UPDATE India_Cars_Cleaned
SET model = TRIM(REPLACE(model, 'Volkswagen ', ''))
WHERE model LIKE '%Volkswagen %';
UPDATE India_Cars_Cleaned
SET model = TRIM(REPLACE(model, 'Skoda ', ''))
WHERE model LIKE '%Skoda %';
UPDATE India_Cars_Cleaned
SET model = TRIM(REPLACE(model, 'Chevrolet ', ''))
WHERE model LIKE '%Chevrolet %';
UPDATE India_Cars_Cleaned
SET model = TRIM(REPLACE(model, 'Ford ', ''))
WHERE model LIKE '%Ford %';
UPDATE India_Cars_Cleaned
SET model = TRIM(REPLACE(model, 'Honda ', ''))
WHERE model LIKE '%Honda %';
UPDATE India_Cars_Cleaned
SET model = TRIM(REPLACE(model, 'Renault ', ''))
WHERE model LIKE '%Renault %';
UPDATE India_Cars_Cleaned
SET model = TRIM(REPLACE(model, 'Nissan ', ''))
WHERE model LIKE '%Nissan %';
UPDATE India_Cars_Cleaned
SET model = TRIM(REPLACE(model, 'Kia ', ''))
WHERE model LIKE '%Kia %';
UPDATE India_Cars_Cleaned
SET model = TRIM(REPLACE(model, 'Jeep ', ''))
WHERE model LIKE '%Jeep %';
UPDATE India_Cars_Cleaned
SET model = TRIM(REPLACE(model, 'Land Rover ', ''))
WHERE model LIKE '%Land Rover %';
UPDATE India_Cars_Cleaned
SET model = TRIM(REPLACE(model, 'Volvo ', ''))
WHERE model LIKE '%Volvo %';
UPDATE India_Cars_Cleaned
SET model = TRIM(REPLACE(model, 'Mitsubishi ', ''))
WHERE model LIKE '%Mitsubishi %';
UPDATE India_Cars_Cleaned
SET model = TRIM(REPLACE(model, 'Porsche ', ''))
WHERE model LIKE '%Porsche %';
UPDATE India_Cars_Cleaned
SET model = TRIM(REPLACE(model, 'Jaguar ', ''))
WHERE model LIKE '%Jaguar %';
UPDATE India_Cars_Cleaned
SET model = TRIM(REPLACE(model, 'MG ', ''))
WHERE model LIKE '%MG %';
UPDATE India_Cars_Cleaned
SET model = TRIM(REPLACE(model, 'Lexus ', ''))
WHERE model LIKE '%Lexus %';
UPDATE India_Cars_Cleaned
SET model = TRIM(REPLACE(model, 'Isuzu ', ''))
WHERE model LIKE '%Isuzu %';
UPDATE India_Cars_Cleaned
SET model = TRIM(REPLACE(model, 'Datsun ', ''))
WHERE model LIKE '%Datsun %';
UPDATE India_Cars_Cleaned
SET model = TRIM(REPLACE(model, 'Fiat ', ''))
WHERE model LIKE '%Fiat %';
UPDATE India_Cars_Cleaned
SET model = TRIM(REPLACE(model, 'Force ', ''))
WHERE model LIKE '%Force %';
UPDATE India_Cars_Cleaned
SET model = TRIM(REPLACE(model, 'Mini ', ''))
WHERE model LIKE '%Mini %';

-- Unificare familii de modele

-- MARUTI
UPDATE India_Cars_Cleaned
SET model = 'Swift Dzire'
WHERE model LIKE '%Swift Dzire%';
UPDATE India_Cars_Cleaned
SET model = 'Alto'
WHERE model LIKE '%Alto 800%';
UPDATE India_Cars_Cleaned
SET model = 'Alto'
WHERE model LIKE '%Alto K10%';
UPDATE India_Cars_Cleaned
SET model = 'Baleno'
WHERE model LIKE '%Baleno RS%';
UPDATE India_Cars_Cleaned
SET model = 'Celerio'
WHERE model LIKE '%Celerio Tour%';
UPDATE India_Cars_Cleaned
SET model = 'Celerio'
WHERE model LIKE '%Celerio X%';
UPDATE India_Cars_Cleaned
SET model = 'Ciaz'
WHERE model = 'Ciaz S';
UPDATE India_Cars_Cleaned
SET model = 'Eeco'
WHERE model LIKE '%Eeco Cargo%';
UPDATE India_Cars_Cleaned
SET model = 'Ertiga'
WHERE model LIKE '%Ertiga Tour%';
UPDATE India_Cars_Cleaned
SET model = 'Wagon R'
WHERE model LIKE '%Wagon R Stingray%';
UPDATE India_Cars_Cleaned
SET model = 'Zen'
WHERE model LIKE '%Zen Estilo%';
UPDATE India_Cars_Cleaned
SET model = 'Zen'
WHERE model = 'Estilo';
UPDATE India_Cars_Cleaned
SET model = 'Brezza'
WHERE model LIKE '%Vitara Brezza%';
UPDATE India_Cars_Cleaned
SET model = 'SX4 S-Cross'
WHERE model LIKE '%SX4 S Cross%';

-- HYUNDAI
UPDATE India_Cars_Cleaned
SET model = 'i10'
WHERE model LIKE '%Grand i10%';
UPDATE India_Cars_Cleaned
SET model = 'i20'
WHERE model LIKE '%Elite i20%';
UPDATE India_Cars_Cleaned
SET model = 'i20'
WHERE model LIKE '%i20 Active%';
UPDATE India_Cars_Cleaned
SET model = 'i20'
WHERE model LIKE '%i20 N Line%';
UPDATE India_Cars_Cleaned
SET model = 'Santro'
WHERE model LIKE '%Santro Xing%';
UPDATE India_Cars_Cleaned
SET model = 'Xcent'
WHERE model LIKE '%Xcent Prime%';

-- MAHINDRA
UPDATE India_Cars_Cleaned
SET model = 'Bolero Pik Up'
WHERE model LIKE '%BOLERO PIK UP%';
UPDATE India_Cars_Cleaned
SET model = 'Bolero Pik Up'
WHERE model LIKE '%Bolero Pik Up%';
UPDATE India_Cars_Cleaned
SET model = 'Bolero Camper'
WHERE model LIKE '%Bolero Camper%';
UPDATE India_Cars_Cleaned
SET model = 'Bolero Maxi Truck'
WHERE model LIKE '%Bolero Maxi Truck%';
UPDATE India_Cars_Cleaned
SET model = 'Bolero'
WHERE model LIKE '%Bolero Power Plus%';
UPDATE India_Cars_Cleaned
SET model = 'Bolero'
WHERE model LIKE '%Bolero Neo%';
UPDATE India_Cars_Cleaned
SET model = 'KUV 100'
WHERE model LIKE '%KUV 100 NXT%';
UPDATE India_Cars_Cleaned
SET model = 'Scorpio'
WHERE model LIKE '%Scorpio Classic%';
UPDATE India_Cars_Cleaned
SET model = 'Scorpio'
WHERE model LIKE '%Scorpio N%';
UPDATE India_Cars_Cleaned
SET model = 'TUV 300'
WHERE model LIKE '%TUV 300 Plus%';
UPDATE India_Cars_Cleaned
SET model = 'e2o'
WHERE model LIKE '%e2o Plus%';
UPDATE India_Cars_Cleaned
SET model = 'Verito'
WHERE model LIKE '%Logan%';

-- TATA
UPDATE India_Cars_Cleaned
SET model = 'Nexon'
WHERE model LIKE '%Nexon EV%';
UPDATE India_Cars_Cleaned
SET model = 'Safari'
WHERE model LIKE '%New Safari%';
UPDATE India_Cars_Cleaned
SET model = 'Safari'
WHERE model LIKE '%Safari Storme%';
UPDATE India_Cars_Cleaned
SET model = 'Sumo'
WHERE model LIKE '%Sumo Victa%';
UPDATE India_Cars_Cleaned
SET model = 'Tiago'
WHERE model LIKE '%Tiago NRG%';
UPDATE India_Cars_Cleaned
SET model = 'Tigor'
WHERE model LIKE '%Tigor EV%';
UPDATE India_Cars_Cleaned
SET model = 'Indica'
WHERE model LIKE '%Indica Xeta%';
UPDATE India_Cars_Cleaned
SET model = 'Indica'
WHERE model LIKE '%Indica eV2%';
UPDATE India_Cars_Cleaned
SET model = 'Indigo'
WHERE model LIKE '%Indigo Marina%';

-- TOYOTA
UPDATE India_Cars_Cleaned
SET model = 'Innova'
WHERE model LIKE '%Innova Crysta%';
UPDATE India_Cars_Cleaned
SET model = 'Fortuner'
WHERE model LIKE '%Fortuner Legender%';
UPDATE India_Cars_Cleaned
SET model = 'Corolla'
WHERE model LIKE '%Corolla Altis%';
UPDATE India_Cars_Cleaned
SET model = 'Etios'
WHERE model LIKE '%Platinum Etios%';
UPDATE India_Cars_Cleaned
SET model = 'Land Cruiser Prado'
WHERE model LIKE '%prado%';
UPDATE India_Cars_Cleaned
SET model = 'Urban Cruiser'
WHERE model LIKE '%Urban cruiser%';

-- BMW
UPDATE India_Cars_Cleaned
SET model = '3 Series'
WHERE model LIKE '%3 Series GT%';
UPDATE India_Cars_Cleaned
SET model = '3 Series'
WHERE model LIKE '%3 Series Gran Limousine%';

-- MERCEDES-BENZ
UPDATE India_Cars_Cleaned
SET model = 'A-Class'
WHERE model LIKE '%A-Class Limousine%';
UPDATE India_Cars_Cleaned
SET model = 'A-Class'
WHERE model LIKE '%A Class%';
UPDATE India_Cars_Cleaned
SET model = 'GLC'
WHERE model LIKE '%GLC Coupe%';
UPDATE India_Cars_Cleaned
SET model = 'E-Class'
WHERE model LIKE '%E-Class All-Terrain%';
UPDATE India_Cars_Cleaned
SET model = 'G-Class'
WHERE model = 'G';

-- MINI
UPDATE India_Cars_Cleaned
SET model = 'Cooper'
WHERE model LIKE '%3 DOOR%';
UPDATE India_Cars_Cleaned
SET model = 'Cooper'
WHERE model LIKE '%5 DOOR%';
UPDATE India_Cars_Cleaned
SET model = 'Cooper Convertible'
WHERE model LIKE '%Cooper Convertible%';
UPDATE India_Cars_Cleaned
SET model = 'Cooper'
WHERE model LIKE '%Cooper SE%';

-- SKODA
UPDATE India_Cars_Cleaned
SET model = 'Laura'
WHERE model LIKE '%New Laura%';

-- CHEVROLET
UPDATE India_Cars_Cleaned
SET model = 'Aveo'
WHERE model LIKE '%Aveo U-VA%';
UPDATE India_Cars_Cleaned
SET model = 'Sail'
WHERE model LIKE '%Sail Hatchback%';

-- VOLVO
UPDATE India_Cars_Cleaned
SET model = 'XC90'
WHERE model LIKE '%XC 90%';
UPDATE India_Cars_Cleaned
SET model = 'S80'
WHERE model LIKE '%S 80%';

-- FIAT
UPDATE India_Cars_Cleaned
SET model = 'Punto'
WHERE model LIKE '%Grande Punto%';
UPDATE India_Cars_Cleaned
SET model = 'Punto'
WHERE model LIKE '%Punto Abarth%';
UPDATE India_Cars_Cleaned
SET model = 'Punto'
WHERE model LIKE '%Punto EVO%';
UPDATE India_Cars_Cleaned
SET model = 'Punto'
WHERE model LIKE '%Punto Pure%';
UPDATE India_Cars_Cleaned
SET model = 'Avventura'
WHERE model LIKE '%Avventura Urban Cross%';
UPDATE India_Cars_Cleaned
SET model = 'Linea'
WHERE model LIKE '%Linea Classic%';

-- NISSAN
UPDATE India_Cars_Cleaned
SET model = 'Micra'
WHERE model LIKE '%Micra Active%';

-- LAND ROVER
UPDATE India_Cars_Cleaned
SET model = 'Discovery'
WHERE model LIKE '%Discovery 4%';

-- JEEP
UPDATE India_Cars_Cleaned
SET model = 'Compass'
WHERE model LIKE '%Compass Trailhawk%';

-- ALTELE
UPDATE India_Cars_Cleaned
SET model = 'Corsa'
WHERE model LIKE '%OpelCorsa%';
UPDATE India_Cars_Cleaned
SET model = 'MU-7'
WHERE model LIKE '%MU 7%';
UPDATE India_Cars_Cleaned
SET model = 'Stile'
WHERE model LIKE '%Ashok Leyland Stile%';

-- ============================================================
-- PASUL 4: STANDARDIZARE CULORI
-- Mapam variantele in categorii unificate cross-market:
--   Chocolate/Bronze/Copper → Brown, Violet/Magenta/Pink → Purple,
--   Titanium/Steel/Star/Metal/Gray → Grey, Aqua/Navy/Indigo → Blue,
--   Maroon/Burgundy/Wine → Red, Beige → Beige, Cream/Ivory → White, Tan/Copper → Brown,
--   Gold/Golden/Amber → Gold, Green variants → Green
-- Culorile rare (sub top 12 ca frecventa) devin 'Unknown'
-- ============================================================
update India_Cars_Cleaned
set color = 'Unknown'
where color like '?%';
update India_Cars_Cleaned
set color = 'Red'
where color like '%red%';
update India_Cars_Cleaned
set color = 'Unknown'
where color is null;
update India_Cars_Cleaned
set color = 'Blue'
where color like '%Blue%';
update India_Cars_Cleaned
set color = 'Black'
where color like '%Black%';
update India_Cars_Cleaned
set color = 'Silver'
where color like '%Silver%';
update India_Cars_Cleaned
set color = 'Blue'
where color like '%Aqua%';
update India_Cars_Cleaned
set color = 'White'
where color like '%White%';
update India_Cars_Cleaned
set color = 'Orange'
where color like '%Orange%';
update India_Cars_Cleaned
set color = 'Brown'
where color like '%Brown%';
update India_Cars_Cleaned
set color = 'Brown'
where color like '%Chocolate%';
update India_Cars_Cleaned
set color = 'Brown'
where color like '%Bronze%';
update India_Cars_Cleaned
set color = 'Titanium'
where color like '%Titanium%';
update India_Cars_Cleaned
set color = 'Yellow'
where color like '%Yellow%';
update India_Cars_Cleaned
set color = 'Purple'
where color like '%Violet%';
update India_Cars_Cleaned
set color = 'Titanium'
where color like '%Titan%';
update India_Cars_Cleaned
set color = 'Grey'
where color like '%Grey%';
update India_Cars_Cleaned
set color = 'Grey'
where color like '%Titanium%';
update India_Cars_Cleaned
set color = 'Unknown'
where color like '%Other%';
update India_Cars_Cleaned
set color = 'Red'
where color like '%Maroon%';
update India_Cars_Cleaned
set color = 'Beige'
where color like '%Beige%';
update India_Cars_Cleaned
set color = 'Grey'
where color like '%Steel%';
update India_Cars_Cleaned
set color = 'Grey'
where color like '%Star%';
update India_Cars_Cleaned
set color = 'Grey'
where color like '%Metal%';
update India_Cars_Cleaned
set color = 'Grey'
where color like '%Gray%';
update India_Cars_Cleaned
set color = 'Gold'
where color like '%Gold%';
update India_Cars_Cleaned
set color = 'Green'
where color like '%Green%';
update India_Cars_Cleaned
set color = 'Gold'
where color like '%Amber%';
update India_Cars_Cleaned
set color = 'Red'
where color like '%Burgundy%'
   or color like '%Wine%';
update India_Cars_Cleaned
set color = 'White'
where color like '%Ivory%'
   or color like '%Cream%';
update India_Cars_Cleaned
set color = 'Blue'
where color like '%Navy%'
   or color like '%Indigo%'
   or color like '%Cobalt%';
update India_Cars_Cleaned
set color = 'Purple'
where color like '%Magenta%'
   or color like '%Pink%';
update India_Cars_Cleaned
set color = 'Brown'
where color like '%Copper%'
   or color like '%Tan%';

update India_Cars_Cleaned
set color = 'Grey'
where color like '%Misty Lake%';

drop table if exists temp_top_colors;
create temp table temp_top_colors as
select color
from India_Cars_Cleaned
where color <> 'Unknown'
group by color
order by count(color) desc
limit 12;

update India_Cars_Cleaned
set color = 'Unknown'
where color not in (select color from temp_top_colors);

drop table if exists temp_top_colors;


-- ============================================================
-- PASUL 5-6: STANDARDIZARE TIP TRANSMISIE
-- Clasificam in: Manual, Automatic, Unknown
-- (AMT, CVT, DCT → Automatic; MT → Manual)
-- ============================================================


UPDATE India_Cars_Cleaned
SET transmission_type = CASE
                            WHEN UPPER(TRIM(transmission_type)) IN ('MANUAL', 'MT') THEN 'Manual'
                            WHEN UPPER(TRIM(transmission_type)) IN ('AUTOMATIC', 'AT', 'AUTO', 'CVT', 'DCT', 'AMT')
                                THEN 'Automatic'
                            WHEN transmission_type IS NULL OR TRIM(transmission_type) = '' THEN 'Unknown'
                            ELSE transmission_type
    END;

-- ============================================================
-- PASUL 7: STANDARDIZARE TIP COMBUSTIBIL
-- Unificam variantele in: Petrol, Diesel, CNG, LPG, Electric, Hybrid
-- ============================================================

UPDATE India_Cars_Cleaned
SET fuel_type = CASE
                    WHEN UPPER(TRIM(fuel_type)) LIKE '%PETROL%' OR UPPER(TRIM(fuel_type)) = 'GASOLINE' THEN 'Petrol'
                    WHEN UPPER(TRIM(fuel_type)) LIKE '%DIESEL%' THEN 'Diesel'
                    WHEN UPPER(TRIM(fuel_type)) LIKE '%CNG%' OR UPPER(TRIM(fuel_type)) LIKE '%PETROL + CNG%'
                        THEN 'CNG'
                    WHEN UPPER(TRIM(fuel_type)) LIKE '%LPG%' OR UPPER(TRIM(fuel_type)) LIKE '%PETROL + LPG%'
                        THEN 'LPG'
                    WHEN UPPER(TRIM(fuel_type)) LIKE '%ELECTRIC%' THEN 'Electric'
                    WHEN UPPER(TRIM(fuel_type)) LIKE '%HYBRID%' THEN 'Hybrid'
                    WHEN fuel_type IS NULL OR TRIM(fuel_type) = '' THEN 'Unknown'
                    ELSE fuel_type
    END;

-- ============================================================
-- PASUL 8: STANDARDIZARE TRACTIUNE, PROPRIETAR, CAROSERIE,
--          SELLER_TYPE, STATE
-- Drivetrain: "4 WD"/"4X4"/"4*4" → "4WD", etc.
-- One_owner: "first" → "Yes", rest → "No", NULL → "Unknown"
-- Body_type: "MUV"/"Minivans" → "Minivan"
-- Seller_type: Dealer/Individual/Unknown
-- State: trim si NULL → "Unknown"
-- ============================================================

UPDATE India_Cars_Cleaned
SET drivetrain = '2WD'
WHERE drivetrain IN ('2 WD', '2WD', '2wd', 'Two Wheel Drive', 'Two Whhel Drive', '4X2', '4x2');
UPDATE India_Cars_Cleaned
SET drivetrain = 'FWD'
WHERE TRIM(drivetrain) = 'FWD'
   OR drivetrain = 'Front Wheel Drive';
UPDATE India_Cars_Cleaned
SET drivetrain = 'RWD'
WHERE drivetrain IN ('RWD', 'RWD(with MTT)', 'Rear Wheel Drive with ESP', 'Rear-wheel drive with ESP');
UPDATE India_Cars_Cleaned
SET drivetrain = '4WD'
WHERE drivetrain IN ('4 WD', '4WD', '4X4', '4x4', 'Four Whell Drive');
UPDATE India_Cars_Cleaned
SET drivetrain = 'AWD'
WHERE drivetrain IN
      ('AWD', 'All Wheel Drive', 'All-wheel drive with Electronic Traction', 'Permanent all-wheel drive quattro');
update India_Cars_Cleaned
SET drivetrain = 'Unknown'
where drivetrain = '3'
   or drivetrain is null;


UPDATE India_Cars_Cleaned
SET one_owner = CASE
                    WHEN one_owner = 'first' THEN 'Yes'
                    WHEN one_owner IS NULL THEN 'Unknown'
                    ELSE 'No'
    END;


UPDATE India_Cars_Cleaned
SET body_type = 'Minivan'
WHERE body_type = 'MUV';
UPDATE India_Cars_Cleaned
SET body_type = 'Minivan'
WHERE body_type = 'Minivans';

UPDATE India_Cars_Cleaned
SET body_type = NULL
WHERE body_type IN ('Hybrids', 'Luxury Vehicles');
UPDATE India_Cars_Cleaned
SET body_type = 'Unknown'
WHERE body_type is null;

-- Standardizare seller_type
UPDATE India_Cars_Cleaned
SET seller_type = CASE
                      WHEN UPPER(TRIM(seller_type)) LIKE '%DEALER%' OR UPPER(TRIM(seller_type)) LIKE '%CERTIFIED%'
                          THEN 'Dealer'
                      WHEN UPPER(TRIM(seller_type)) LIKE '%INDIVIDUAL%' OR UPPER(TRIM(seller_type)) LIKE '%PRIVATE%'
                          THEN 'Individual'
                      WHEN seller_type IS NULL OR TRIM(seller_type) = '' THEN 'Unknown'
                      ELSE seller_type
    END;

-- Standardizare state (trim si curat)
UPDATE India_Cars_Cleaned
SET state = TRIM(state);
UPDATE India_Cars_Cleaned
SET state = 'Unknown'
WHERE state IS NULL
   OR TRIM(state) = '';



DELETE
FROM India_Cars_Cleaned
WHERE id NOT IN (SELECT MIN(id)
                 FROM India_Cars_Cleaned
                 GROUP BY brand, model, color, year, price_in_euro, power_ps, transmission_type, fuel_type, km,
                          engine_type, one_owner, drivetrain, body_type);

-- ============================================================
-- PASUL 9: IMPUTARE PUTERE MOTOR LIPSA (power_ps)
-- Strategie in 3 pasi (de la specific la general):
--   1. Media pe brand + model + engine_type (fereastra ±0.3L)
--   2. Media pe brand + engine_type (fereastra ±0.3L)
--   3. Media pe engine_type (fereastra ±0.4L)
-- ============================================================

CREATE INDEX idx_cars_lookup_India ON India_Cars_Cleaned (brand, model, engine_type);

UPDATE India_Cars_Cleaned
SET power_ps = (SELECT ROUND(MEDIAN(sub.power_ps))
                FROM India_Cars_Cleaned AS sub
                WHERE sub.brand = India_Cars_Cleaned.brand
                  AND sub.model = India_Cars_Cleaned.model
                  AND sub.engine_type BETWEEN India_Cars_Cleaned.engine_type - 0.3
                    AND India_Cars_Cleaned.engine_type + 0.3
                  AND sub.power_ps > 5)
WHERE power_ps IS NULL
   OR power_ps < 5;

drop index idx_cars_lookup_India;
CREATE INDEX idx_cars_lookup_India ON India_Cars_Cleaned (brand, engine_type);

UPDATE India_Cars_Cleaned
SET power_ps = (SELECT ROUND(MEDIAN(sub.power_ps))
                FROM India_Cars_Cleaned AS sub
                WHERE sub.brand = India_Cars_Cleaned.brand
                  AND sub.engine_type BETWEEN India_Cars_Cleaned.engine_type - 0.3
                    AND India_Cars_Cleaned.engine_type + 0.3
                  AND sub.power_ps > 5)
WHERE power_ps IS NULL
   OR power_ps < 5;

drop index idx_cars_lookup_India;
CREATE INDEX idx_cars_lookup_India ON India_Cars_Cleaned (engine_type);

UPDATE India_Cars_Cleaned
SET power_ps = (SELECT ROUND(MEDIAN(sub.power_ps))
                FROM India_Cars_Cleaned AS sub
                where sub.engine_type BETWEEN India_Cars_Cleaned.engine_type - 0.4
                    AND India_Cars_Cleaned.engine_type + 0.4
                  AND sub.power_ps > 5)
WHERE power_ps IS NULL
   OR power_ps < 5;

DELETE
FROM India_Cars_Cleaned
WHERE power_ps IS NULL
   OR power_ps < 15;

-- ============================================================
-- PASUL 10: IMPUTARE CAPACITATE MOTOR LIPSA (engine_type)
-- Strategie in 3 pasi (de la specific la general):
--   1. Media pe brand + model + body_type (fereastra ±10 PS)
--   2. Media pe brand + fuel_type (fereastra ±10 PS)
--   3. Media pe fuel_type (fallback global)
-- Excludem vehiculele electrice (nu au cilindree)
-- ============================================================

update India_Cars_Cleaned
set engine_type=null
where fuel_type = 'Electric';

drop index idx_cars_lookup_India;
CREATE INDEX idx_cars_lookup1_India ON India_Cars_Cleaned (brand, model, body_type, power_ps);

UPDATE India_Cars_Cleaned
SET engine_type = (SELECT ROUND(MEDIAN(sub.engine_type), 1)
                   FROM India_Cars_Cleaned AS sub
                   WHERE sub.brand = India_Cars_Cleaned.brand
                     AND sub.model = India_Cars_Cleaned.model
                     and sub.body_type = India_Cars_Cleaned.body_type
                     and sub.power_ps between India_Cars_Cleaned.power_ps - 10 and India_Cars_Cleaned.power_ps + 10
                     AND sub.engine_type IS NOT NULL
                     and sub.body_type <> 'Unknown'
                     and sub.fuel_type <> 'Unknown'
                     AND sub.fuel_type <> 'Electric')
WHERE (engine_type IS NULL OR engine_type < 0.5)
  AND fuel_type <> 'Electric';

-- Imputare engine_type — Pas suplimentar (brand + fuel_type, fara model)
drop index idx_cars_lookup1_India;
CREATE INDEX idx_cars_lookup1_India ON India_Cars_Cleaned (brand, fuel_type, power_ps);

UPDATE India_Cars_Cleaned
SET engine_type = (SELECT ROUND(MEDIAN(sub.engine_type), 1)
                   FROM India_Cars_Cleaned AS sub
                   WHERE sub.brand = India_Cars_Cleaned.brand
                     AND sub.fuel_type = India_Cars_Cleaned.fuel_type
                     AND sub.power_ps BETWEEN India_Cars_Cleaned.power_ps - 10 AND India_Cars_Cleaned.power_ps + 10
                     AND sub.engine_type IS NOT NULL
                     and sub.fuel_type <> 'Unknown'
                     AND sub.fuel_type <> 'Electric')
WHERE (engine_type IS NULL OR engine_type < 0.5)
  AND fuel_type <> 'Electric';

-- Imputare engine_type — Fallback global (fuel_type)
drop index idx_cars_lookup1_India;
CREATE INDEX idx_cars_lookup1_India ON India_Cars_Cleaned (fuel_type);

UPDATE India_Cars_Cleaned
SET engine_type = (SELECT ROUND(MEDIAN(sub.engine_type), 1)
                   FROM India_Cars_Cleaned AS sub
                   WHERE sub.fuel_type = India_Cars_Cleaned.fuel_type
                     AND sub.engine_type IS NOT NULL
                     AND sub.fuel_type <> 'Electric')
WHERE (engine_type IS NULL OR engine_type < 0.5)
  AND fuel_type <> 'Electric';

drop index idx_cars_lookup1_India;

-- ============================================================
-- PASUL 10b: IMPUTARE CONSUM COMBUSTIBIL LIPSA
-- Strategie in 4 pasi (de la specific la general):
--   1. Media pe brand + model + fuel_type + transmission + drivetrain (fereastra ±2 ani)
--   2. Media pe brand + fuel_type + transmission_type (fereastra ±10 PS)
--   3. Media pe fuel_type (fereastra ±0.4L engine)
--   4. Media pe fuel_type (fallback global)
-- km/kg (CNG) → NULL la creare (nu e comparabil cu l/100km)
-- ============================================================


CREATE INDEX idx_cars_lookup1_India ON India_Cars_Cleaned (brand, model, fuel_type, transmission_type, drivetrain, year);

update India_Cars_Cleaned
set fuel_consumption_l_100km=null
where fuel_type = 'Electric'
   or India_Cars_Cleaned.fuel_type = 'CNG';

UPDATE India_Cars_Cleaned
SET fuel_consumption_l_100km = (SELECT ROUND(MEDIAN(sub.fuel_consumption_l_100km), 1)
                                FROM India_Cars_Cleaned AS sub
                                WHERE sub.brand = India_Cars_Cleaned.brand
                                  AND sub.model = India_Cars_Cleaned.model
                                  AND sub.fuel_type = India_Cars_Cleaned.fuel_type
                                  AND sub.transmission_type = India_Cars_Cleaned.transmission_type
                                  AND sub.drivetrain = India_Cars_Cleaned.drivetrain
                                  AND sub.year BETWEEN India_Cars_Cleaned.year - 2 AND India_Cars_Cleaned.year + 2
                                  AND sub.fuel_consumption_l_100km IS NOT NULL
                                  and sub.fuel_type <> 'Unknown'
                                  AND sub.drivetrain <> 'Unknown'
                                  AND sub.transmission_type <> 'Unknown')
WHERE (fuel_consumption_l_100km IS NULL OR fuel_consumption_l_100km = 0)
  AND fuel_type NOT IN ('Electric', 'CNG');

drop index idx_cars_lookup1_India;
CREATE INDEX idx_cars_lookup1_India ON India_Cars_Cleaned (brand, fuel_type, transmission_type, power_ps);

UPDATE India_Cars_Cleaned
SET fuel_consumption_l_100km = (SELECT ROUND(MEDIAN(sub.fuel_consumption_l_100km), 1)
                                FROM India_Cars_Cleaned AS sub
                                WHERE sub.brand = India_Cars_Cleaned.brand
                                  AND sub.fuel_type = India_Cars_Cleaned.fuel_type
                                  AND sub.transmission_type = India_Cars_Cleaned.transmission_type
                                  AND sub.power_ps BETWEEN India_Cars_Cleaned.power_ps - 10 AND India_Cars_Cleaned.power_ps + 10
                                  AND sub.fuel_consumption_l_100km IS NOT NULL
                                  and sub.fuel_type <> 'Unknown'
                                  AND sub.transmission_type <> 'Unknown')
WHERE (fuel_consumption_l_100km IS NULL OR fuel_consumption_l_100km = 0)
  AND fuel_type NOT IN ('Electric', 'CNG');

drop index idx_cars_lookup1_India;
CREATE INDEX idx_cars_lookup1_India ON India_Cars_Cleaned (fuel_type, engine_type);

UPDATE India_Cars_Cleaned
SET fuel_consumption_l_100km = (SELECT ROUND(MEDIAN(sub.fuel_consumption_l_100km), 1)
                                FROM India_Cars_Cleaned AS sub
                                WHERE sub.fuel_type = India_Cars_Cleaned.fuel_type
                                  AND sub.engine_type BETWEEN India_Cars_Cleaned.engine_type - 0.4 AND India_Cars_Cleaned.engine_type + 0.4
                                  AND sub.fuel_consumption_l_100km IS NOT NULL)
WHERE (fuel_consumption_l_100km IS NULL OR fuel_consumption_l_100km = 0)
  AND fuel_type NOT IN ('Electric', 'CNG');

drop index idx_cars_lookup1_India;
CREATE INDEX idx_cars_lookup1_India ON India_Cars_Cleaned (fuel_type);

UPDATE India_Cars_Cleaned
SET fuel_consumption_l_100km = (SELECT ROUND(MEDIAN(sub.fuel_consumption_l_100km), 1)
                                FROM India_Cars_Cleaned AS sub
                                WHERE sub.fuel_type = India_Cars_Cleaned.fuel_type
                                  AND sub.fuel_consumption_l_100km IS NOT NULL)
WHERE (fuel_consumption_l_100km IS NULL OR fuel_consumption_l_100km = 0)
  AND fuel_type NOT IN ('Electric', 'CNG');

drop index idx_cars_lookup1_India;
-- ============================================================
-- IMPUTARE CATEGORIALE PRIN IERARHIE (MODE) - INDIA
-- Ierarhie: 1. Brand + Model | 2. Model | 3. Global
-- ============================================================

-- Creare indecsi temporari pentru optimizare viteza
CREATE INDEX IF NOT EXISTS temp_idx_ind_bm ON India_Cars_Cleaned (brand, model);
CREATE INDEX IF NOT EXISTS temp_idx_ind_m ON India_Cars_Cleaned (model);

-- ------------------------------------------------------------
-- A. Imputare body_type
-- ------------------------------------------------------------

-- Pas 1: Modul pe Brand + Model
UPDATE India_Cars_Cleaned
SET body_type = (SELECT sub.body_type
                 FROM India_Cars_Cleaned AS sub
                 WHERE sub.brand = India_Cars_Cleaned.brand
                   AND sub.model = India_Cars_Cleaned.model
                   AND sub.body_type IS NOT NULL
                   AND sub.body_type <> 'Unknown'
                   AND sub.body_type <> ''
                 GROUP BY sub.body_type
                 ORDER BY COUNT(*) DESC, sub.body_type
                 LIMIT 1)
WHERE body_type IS NULL
   OR body_type = 'Unknown'
;

-- Pas 2: Modul pe Model
UPDATE India_Cars_Cleaned
SET body_type = (SELECT sub.body_type
                 FROM India_Cars_Cleaned AS sub
                 WHERE sub.model = India_Cars_Cleaned.model
                   AND sub.body_type IS NOT NULL
                   AND sub.body_type <> 'Unknown'
                   AND sub.body_type <> ''
                 GROUP BY sub.body_type
                 ORDER BY COUNT(*) DESC, sub.body_type
                 LIMIT 1)
WHERE body_type IS NULL
   OR body_type = 'Unknown'
;

-- Pas 3: Modul Global
UPDATE India_Cars_Cleaned
SET body_type = (SELECT sub.body_type
                 FROM India_Cars_Cleaned AS sub
                 WHERE sub.body_type IS NOT NULL
                   AND sub.body_type <> 'Unknown'
                   AND sub.body_type <> ''
                 GROUP BY sub.body_type
                 ORDER BY COUNT(*) DESC, sub.body_type
                 LIMIT 1)
WHERE body_type IS NULL
   OR body_type = 'Unknown'
;


-- ------------------------------------------------------------
-- B. Imputare drivetrain
-- ------------------------------------------------------------

-- Pas 1: Modul pe Brand + Model
UPDATE India_Cars_Cleaned
SET drivetrain = (SELECT sub.drivetrain
                  FROM India_Cars_Cleaned AS sub
                  WHERE sub.brand = India_Cars_Cleaned.brand
                    AND sub.model = India_Cars_Cleaned.model
                    AND sub.drivetrain IS NOT NULL
                    AND sub.drivetrain <> 'Unknown'
                    AND sub.drivetrain <> ''
                  GROUP BY sub.drivetrain
                  ORDER BY COUNT(*) DESC, sub.drivetrain
                  LIMIT 1)
WHERE drivetrain IS NULL
   OR drivetrain = 'Unknown'
;

-- Pas 2: Modul pe Model
UPDATE India_Cars_Cleaned
SET drivetrain = (SELECT sub.drivetrain
                  FROM India_Cars_Cleaned AS sub
                  WHERE sub.model = India_Cars_Cleaned.model
                    AND sub.drivetrain IS NOT NULL
                    AND sub.drivetrain <> 'Unknown'
                    AND sub.drivetrain <> ''
                  GROUP BY sub.drivetrain
                  ORDER BY COUNT(*) DESC, sub.drivetrain
                  LIMIT 1)
WHERE drivetrain IS NULL
   OR drivetrain = 'Unknown'
;

-- Pas 3: Modul Global
UPDATE India_Cars_Cleaned
SET drivetrain = (SELECT sub.drivetrain
                  FROM India_Cars_Cleaned AS sub
                  WHERE sub.drivetrain IS NOT NULL
                    AND sub.drivetrain <> 'Unknown'
                    AND sub.drivetrain <> ''
                  GROUP BY sub.drivetrain
                  ORDER BY COUNT(*) DESC, sub.drivetrain
                  LIMIT 1)
WHERE drivetrain IS NULL
   OR drivetrain = 'Unknown'
;


-- ------------------------------------------------------------
-- C. Imputare fuel_type
-- ------------------------------------------------------------

-- Pas 1: Modul pe Brand + Model
UPDATE India_Cars_Cleaned
SET fuel_type = (SELECT sub.fuel_type
                 FROM India_Cars_Cleaned AS sub
                 WHERE sub.brand = India_Cars_Cleaned.brand
                   AND sub.model = India_Cars_Cleaned.model
                   AND sub.fuel_type IS NOT NULL
                   AND sub.fuel_type <> 'Unknown'
                   AND sub.fuel_type <> ''
                 GROUP BY sub.fuel_type
                 ORDER BY COUNT(*) DESC, sub.fuel_type
                 LIMIT 1)
WHERE fuel_type IS NULL
   OR fuel_type = 'Unknown'
;

-- Pas 2: Modul pe Model
UPDATE India_Cars_Cleaned
SET fuel_type = (SELECT sub.fuel_type
                 FROM India_Cars_Cleaned AS sub
                 WHERE sub.model = India_Cars_Cleaned.model
                   AND sub.fuel_type IS NOT NULL
                   AND sub.fuel_type <> 'Unknown'
                   AND sub.fuel_type <> ''
                 GROUP BY sub.fuel_type
                 ORDER BY COUNT(*) DESC, sub.fuel_type
                 LIMIT 1)
WHERE fuel_type IS NULL
   OR fuel_type = 'Unknown'
;

-- Pas 3: Modul Global
UPDATE India_Cars_Cleaned
SET fuel_type = (SELECT sub.fuel_type
                 FROM India_Cars_Cleaned AS sub
                 WHERE sub.fuel_type IS NOT NULL
                   AND sub.fuel_type <> 'Unknown'
                   AND sub.fuel_type <> ''
                 GROUP BY sub.fuel_type
                 ORDER BY COUNT(*) DESC, sub.fuel_type
                 LIMIT 1)
WHERE fuel_type IS NULL
   OR fuel_type = 'Unknown'
;


-- ------------------------------------------------------------
-- D. Imputare transmission_type
-- ------------------------------------------------------------

-- Pas 1: Modul pe Brand + Model
UPDATE India_Cars_Cleaned
SET transmission_type = (SELECT sub.transmission_type
                         FROM India_Cars_Cleaned AS sub
                         WHERE sub.brand = India_Cars_Cleaned.brand
                           AND sub.model = India_Cars_Cleaned.model
                           AND sub.transmission_type IS NOT NULL
                           AND sub.transmission_type <> 'Unknown'
                           AND sub.transmission_type <> ''
                         GROUP BY sub.transmission_type
                         ORDER BY COUNT(*) DESC, sub.transmission_type
                         LIMIT 1)
WHERE transmission_type IS NULL
   OR transmission_type = 'Unknown'
   OR transmission_type = '';

-- Pas 2: Modul pe Model
UPDATE India_Cars_Cleaned
SET transmission_type = (SELECT sub.transmission_type
                         FROM India_Cars_Cleaned AS sub
                         WHERE sub.model = India_Cars_Cleaned.model
                           AND sub.transmission_type IS NOT NULL
                           AND sub.transmission_type <> 'Unknown'
                           AND sub.transmission_type <> ''
                         GROUP BY sub.transmission_type
                         ORDER BY COUNT(*) DESC, sub.transmission_type
                         LIMIT 1)
WHERE transmission_type IS NULL
   OR transmission_type = 'Unknown'
;

-- Pas 3: Modul Global
UPDATE India_Cars_Cleaned
SET transmission_type = (SELECT sub.transmission_type
                         FROM India_Cars_Cleaned AS sub
                         WHERE sub.transmission_type IS NOT NULL
                           AND sub.transmission_type <> 'Unknown'
                           AND sub.transmission_type <> ''
                         GROUP BY sub.transmission_type
                         ORDER BY COUNT(*) DESC, sub.transmission_type
                         LIMIT 1)
WHERE transmission_type IS NULL
   OR transmission_type = 'Unknown'
;

-- Stergere indecsi temporari
DROP INDEX IF EXISTS temp_idx_ind_bm;
DROP INDEX IF EXISTS temp_idx_ind_m;
-- ============================================================
-- PASUL 11: ELIMINARE OUTLIERI
-- Praguri asimetrice P0.1 / P99.9 per piata
-- ============================================================

-- Praguri P0.1 / P99.9 recalculate
DELETE
FROM India_Cars_Cleaned
WHERE km > 324049
   OR engine_type > 4.15
   OR power_ps > 383
   OR price_in_euro < 579
   OR price_in_euro > 124662
   OR fuel_consumption_l_100km < 3.5
   OR fuel_consumption_l_100km > 11.6;

select count(*)
from India_Cars_Cleaned;

select *
from India_Cars_Cleaned
where body_type = 'Convertibles'