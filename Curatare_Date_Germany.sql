-- ============================================================
-- SCRIPT CURATARE DATE: Piata auto SH din Germania
-- Sursa: tabel Germany_Cars (date brute din dataset)
-- Rezultat: tabel Germany_Cars_Cleaned cu date standardizate
-- Pasi: creare tabel → eliminare invalide → combustibil →
--       engine_type (text liber → litri) → CO2 → tipuri date →
--       brand lowercase → transmisie → prefix model → modele →
--       culori (DE→EN) → imputare engine + CO2 + consum → deduplicare →
--       brand Proper Case → verificare
-- ============================================================

-- ============================================================
-- PASUL 0: CREARE TABEL CURATAT
-- Selectam coloanele relevante si le redenumim uniform
-- ============================================================

drop table if exists Germany_Cars_Cleaned;

create table Germany_Cars_Cleaned as
select ROWID                 as id,
       brand,
       model,
       color,
       year,
       registration_date,
       price_in_euro,
       power_kw,
       power_ps,
       transmission_type,
       fuel_type,
       fuel_consumption_l_100km,
       mileage_in_km         as km,
       offer_description     as engine_type,
       fuel_consumption_g_km as co2_g
from Germany_Cars;

-- ============================================================
-- PASUL 1: ELIMINARE RANDURI INVALIDE
-- Stergem: pret/km NULL, pret <= 0, km < 0, power_ps NULL/≤1
-- Corectam randuri cu fuel_type si transmission_type inversate
-- Eliminam ani imposibili (in afara 1900-2026)
-- ============================================================

delete
from Germany_Cars_Cleaned
where price_in_euro is null
   or km is null;

delete
from Germany_Cars_Cleaned
where price_in_euro <= 0;

delete
from Germany_Cars_Cleaned
where km < 0;

delete
from Germany_Cars_Cleaned
where power_ps is null
   or power_ps <= 1;

delete
from Germany_Cars_Cleaned
where fuel_type in ('Semi-automatic', 'Manual', 'Automatic');


delete
from Germany_Cars_Cleaned
where year in ('Petrol', 'Diesel', 'Electric', 'Hybrid', 'LPG', 'CNG', 'Hydrogen', 'Other', 'Ethanol', 'Diesel Hybrid');

delete
from Germany_Cars_Cleaned
where year in ('Semi-automatic', 'Manual', 'Automatic', 'Unknown');

delete
from Germany_Cars_Cleaned
where year not between 1900 and 2026;

-- ============================================================
-- PASUL 2: UNIFICARE COMBUSTIBIL
-- Diesel Hybrid -> Hybrid
-- ============================================================

UPDATE Germany_Cars_Cleaned
SET fuel_type = 'Hybrid'
WHERE fuel_type = 'Diesel Hybrid';

update Germany_Cars_Cleaned
set fuel_type='Unknown'
where fuel_type = 'Other';
-- ============================================================
-- PASUL 3: STANDARDIZARE CAPACITATE MOTOR (engine_type)
-- Extragem capacitatea cilindrica (litri) din textul liber
-- Pattern-uri: "2.0 l", "2,0l" (virgula germana), "ELEKTRO", etc.
-- Electric → NULL, restul → valoare numerica in litri
-- Fallback fara sufixul 'l' pentru cazurile fara unitate
-- ============================================================

update Germany_Cars_Cleaned
set engine_type = NULL
where Germany_Cars_Cleaned.fuel_type = 'Electric';

UPDATE Germany_Cars_Cleaned
SET engine_type = CASE
    -- ELECTRIC / BEV
                      WHEN engine_type LIKE '%ELECTRIC%' THEN null
                      WHEN engine_type LIKE '%electric%' THEN null
                      WHEN engine_type LIKE '%ELEKTRO%' THEN null
                      WHEN engine_type LIKE '%Elektro%' THEN null
                      WHEN engine_type LIKE '%ELEKTROMOTOR%' THEN null
                      WHEN engine_type LIKE '%E-TRON%' THEN null
                      WHEN engine_type LIKE '%e-tron%' THEN null
                      WHEN engine_type LIKE '%SKYACTIV-EV%' THEN null
                      WHEN engine_type LIKE '%BEV%' THEN null
                      WHEN engine_type LIKE '%ZEV%' THEN null
                      WHEN engine_type LIKE '%EQA%' THEN null
                      WHEN engine_type LIKE '%EQB%' THEN null
                      WHEN engine_type LIKE '%EQC%' THEN null
                      WHEN engine_type LIKE '%EQE%' THEN null
                      WHEN engine_type LIKE '%EQS%' THEN null
                      WHEN engine_type LIKE '%EQV%' THEN null
                      WHEN engine_type LIKE '%ID.3%' THEN null
                      WHEN engine_type LIKE '%ID.4%' THEN null
                      WHEN engine_type LIKE '%ID.5%' THEN null
                      WHEN engine_type LIKE '%ID.6%' THEN null
                      WHEN engine_type LIKE '%ID.7%' THEN null
                      WHEN engine_type LIKE '% i3%' THEN null
                      WHEN engine_type LIKE '% i4%' THEN null
                      WHEN engine_type LIKE '% i5%' THEN null
                      WHEN engine_type LIKE '% i7%' THEN null
                      WHEN engine_type LIKE '%Z.E.%' THEN null
                      WHEN engine_type LIKE '%(120 Ah)%' THEN null
                      WHEN engine_type LIKE '%(94 Ah)%' THEN null
                      WHEN engine_type LIKE '%IONIQ%' THEN null
                      WHEN engine_type LIKE '%Ioniq%' THEN null
                      WHEN engine_type LIKE '% EV %' THEN null
                      WHEN engine_type LIKE '% EV' THEN null

    -- SUB 1.0L
                      WHEN engine_type LIKE '%0.6 l%' OR engine_type LIKE '%0,6 l%'
                          OR engine_type LIKE '%0.6l%' OR engine_type LIKE '%0,6l%' THEN '0.6'
                      WHEN engine_type LIKE '%0.7 l%' OR engine_type LIKE '%0,7 l%'
                          OR engine_type LIKE '%0.7l%' OR engine_type LIKE '%0,7l%' THEN '0.7'
                      WHEN engine_type LIKE '%0.8 l%' OR engine_type LIKE '%0,8 l%'
                          OR engine_type LIKE '%0.8l%' OR engine_type LIKE '%0,8l%' THEN '0.8'
                      WHEN engine_type LIKE '%0.9 l%' OR engine_type LIKE '%0,9 l%'
                          OR engine_type LIKE '%0.9l%' OR engine_type LIKE '%0,9l%' THEN '0.9'

                      WHEN engine_type LIKE '%1.0 l%' OR engine_type LIKE '%1,0 l%'
                          OR engine_type LIKE '%1.0l%' OR engine_type LIKE '%1,0l%' THEN '1.0'

                      WHEN engine_type LIKE '%1.1 l%' OR engine_type LIKE '%1,1 l%'
                          OR engine_type LIKE '%1.1l%' OR engine_type LIKE '%1,1l%' THEN '1.1'

                      WHEN engine_type LIKE '%1.2 l%' OR engine_type LIKE '%1,2 l%'
                          OR engine_type LIKE '%1.2l%' OR engine_type LIKE '%1,2l%' THEN '1.2'

                      WHEN engine_type LIKE '%1.3 l%' OR engine_type LIKE '%1,3 l%'
                          OR engine_type LIKE '%1.3l%' OR engine_type LIKE '%1,3l%' THEN '1.3'

                      WHEN engine_type LIKE '%1.4 l%' OR engine_type LIKE '%1,4 l%'
                          OR engine_type LIKE '%1.4l%' OR engine_type LIKE '%1,4l%' THEN '1.4'

                      WHEN engine_type LIKE '%1.5 l%' OR engine_type LIKE '%1,5 l%'
                          OR engine_type LIKE '%1.5l%' OR engine_type LIKE '%1,5l%' THEN '1.5'

                      WHEN engine_type LIKE '%1.6 l%' OR engine_type LIKE '%1,6 l%'
                          OR engine_type LIKE '%1.6l%' OR engine_type LIKE '%1,6l%' THEN '1.6'

                      WHEN engine_type LIKE '%1.7 l%' OR engine_type LIKE '%1,7 l%'
                          OR engine_type LIKE '%1.7l%' OR engine_type LIKE '%1,7l%' THEN '1.7'

                      WHEN engine_type LIKE '%1.8 l%' OR engine_type LIKE '%1,8 l%'
                          OR engine_type LIKE '%1.8l%' OR engine_type LIKE '%1,8l%' THEN '1.8'

                      WHEN engine_type LIKE '%1.9 l%' OR engine_type LIKE '%1,9 l%'
                          OR engine_type LIKE '%1.9l%' OR engine_type LIKE '%1,9l%' THEN '1.9'

                      WHEN engine_type LIKE '%2.0 l%' OR engine_type LIKE '%2,0 l%'
                          OR engine_type LIKE '%2.0l%' OR engine_type LIKE '%2,0l%' THEN '2.0'

                      WHEN engine_type LIKE '%2.1 l%' OR engine_type LIKE '%2,1 l%'
                          OR engine_type LIKE '%2.1l%' OR engine_type LIKE '%2,1l%' THEN '2.1'

                      WHEN engine_type LIKE '%2.2 l%' OR engine_type LIKE '%2,2 l%'
                          OR engine_type LIKE '%2.2l%' OR engine_type LIKE '%2,2l%' THEN '2.2'

                      WHEN engine_type LIKE '%2.3 l%' OR engine_type LIKE '%2,3 l%'
                          OR engine_type LIKE '%2.3l%' OR engine_type LIKE '%2,3l%' THEN '2.3'

                      WHEN engine_type LIKE '%2.4 l%' OR engine_type LIKE '%2,4 l%'
                          OR engine_type LIKE '%2.4l%' OR engine_type LIKE '%2,4l%' THEN '2.4'

                      WHEN engine_type LIKE '%2.5 l%' OR engine_type LIKE '%2,5 l%'
                          OR engine_type LIKE '%2.5l%' OR engine_type LIKE '%2,5l%' THEN '2.5'

                      WHEN engine_type LIKE '%2.6 l%' OR engine_type LIKE '%2,6 l%'
                          OR engine_type LIKE '%2.6l%' OR engine_type LIKE '%2,6l%' THEN '2.6'

                      WHEN engine_type LIKE '%2.7 l%' OR engine_type LIKE '%2,7 l%'
                          OR engine_type LIKE '%2.7l%' OR engine_type LIKE '%2,7l%' THEN '2.7'

                      WHEN engine_type LIKE '%2.8 l%' OR engine_type LIKE '%2,8 l%'
                          OR engine_type LIKE '%2.8l%' OR engine_type LIKE '%2,8l%' THEN '2.8'

                      WHEN engine_type LIKE '%2.9 l%' OR engine_type LIKE '%2,9 l%'
                          OR engine_type LIKE '%2.9l%' OR engine_type LIKE '%2,9l%' THEN '2.9'

                      WHEN engine_type LIKE '%3.0 l%' OR engine_type LIKE '%3,0 l%'
                          OR engine_type LIKE '%3.0l%' OR engine_type LIKE '%3,0l%' THEN '3.0'

                      WHEN engine_type LIKE '%3.1 l%' OR engine_type LIKE '%3,1 l%'
                          OR engine_type LIKE '%3.1l%' OR engine_type LIKE '%3,1l%' THEN '3.1'

                      WHEN engine_type LIKE '%3.2 l%' OR engine_type LIKE '%3,2 l%'
                          OR engine_type LIKE '%3.2l%' OR engine_type LIKE '%3,2l%' THEN '3.2'

                      WHEN engine_type LIKE '%3.3 l%' OR engine_type LIKE '%3,3 l%'
                          OR engine_type LIKE '%3.3l%' OR engine_type LIKE '%3,3l%' THEN '3.3'

                      WHEN engine_type LIKE '%3.4 l%' OR engine_type LIKE '%3,4 l%'
                          OR engine_type LIKE '%3.4l%' OR engine_type LIKE '%3,4l%' THEN '3.4'

                      WHEN engine_type LIKE '%3.5 l%' OR engine_type LIKE '%3,5 l%'
                          OR engine_type LIKE '%3.5l%' OR engine_type LIKE '%3,5l%' THEN '3.5'

                      WHEN engine_type LIKE '%3.6 l%' OR engine_type LIKE '%3,6 l%'
                          OR engine_type LIKE '%3.6l%' OR engine_type LIKE '%3,6l%' THEN '3.6'

                      WHEN engine_type LIKE '%3.7 l%' OR engine_type LIKE '%3,7 l%'
                          OR engine_type LIKE '%3.7l%' OR engine_type LIKE '%3,7l%' THEN '3.7'

                      WHEN engine_type LIKE '%3.8 l%' OR engine_type LIKE '%3,8 l%'
                          OR engine_type LIKE '%3.8l%' OR engine_type LIKE '%3,8l%' THEN '3.8'

                      WHEN engine_type LIKE '%4.0 l%' OR engine_type LIKE '%4,0 l%'
                          OR engine_type LIKE '%4.0l%' OR engine_type LIKE '%4,0l%' THEN '4.0'

                      WHEN engine_type LIKE '%4.2 l%' OR engine_type LIKE '%4,2 l%'
                          OR engine_type LIKE '%4.2l%' OR engine_type LIKE '%4,2l%' THEN '4.2'

                      WHEN engine_type LIKE '%4.4 l%' OR engine_type LIKE '%4,4 l%'
                          OR engine_type LIKE '%4.4l%' OR engine_type LIKE '%4,4l%' THEN '4.4'

                      WHEN engine_type LIKE '%4.6 l%' OR engine_type LIKE '%4,6 l%'
                          OR engine_type LIKE '%4.6l%' OR engine_type LIKE '%4,6l%' THEN '4.6'

                      WHEN engine_type LIKE '%4.7 l%' OR engine_type LIKE '%4,7 l%'
                          OR engine_type LIKE '%4.7l%' OR engine_type LIKE '%4,7l%' THEN '4.7'

                      WHEN engine_type LIKE '%5.0 l%' OR engine_type LIKE '%5,0 l%'
                          OR engine_type LIKE '%5.0l%' OR engine_type LIKE '%5,0l%' THEN '5.0'

                      WHEN engine_type LIKE '%5.2 l%' OR engine_type LIKE '%5,2 l%'
                          OR engine_type LIKE '%5.2l%' OR engine_type LIKE '%5,2l%' THEN '5.2'

                      WHEN engine_type LIKE '%5.5 l%' OR engine_type LIKE '%5,5 l%'
                          OR engine_type LIKE '%5.5l%' OR engine_type LIKE '%5,5l%' THEN '5.5'

                      WHEN engine_type LIKE '%6.0 l%' OR engine_type LIKE '%6,0 l%'
                          OR engine_type LIKE '%6.0l%' OR engine_type LIKE '%6,0l%' THEN '6.0'

                      WHEN engine_type LIKE '%6.2 l%' OR engine_type LIKE '%6,2 l%'
                          OR engine_type LIKE '%6.2l%' OR engine_type LIKE '%6,2l%' THEN '6.2'

                      WHEN engine_type LIKE '%6.3 l%' OR engine_type LIKE '%6,3 l%'
                          OR engine_type LIKE '%6.3l%' OR engine_type LIKE '%6,3l%' THEN '6.3'

                      WHEN engine_type LIKE '%6.5 l%' OR engine_type LIKE '%6,5 l%'
                          OR engine_type LIKE '%6.5l%' OR engine_type LIKE '%6,5l%' THEN '6.5'

    -- FALLBACK (fara sufixul 'l')
                      WHEN engine_type LIKE '%0.6%' OR engine_type LIKE '%0,6%' THEN '0.6'
                      WHEN engine_type LIKE '%0.7%' OR engine_type LIKE '%0,7%' THEN '0.7'
                      WHEN engine_type LIKE '%0.8%' OR engine_type LIKE '%0,8%' THEN '0.8'
                      WHEN engine_type LIKE '%0.9%' OR engine_type LIKE '%0,9%' THEN '0.9'
                      WHEN engine_type LIKE '%1.0%' OR engine_type LIKE '%1,0%' THEN '1.0'
                      WHEN engine_type LIKE '%1.1%' OR engine_type LIKE '%1,1%' THEN '1.1'
                      WHEN engine_type LIKE '%1.2%' OR engine_type LIKE '%1,2%' THEN '1.2'
                      WHEN engine_type LIKE '%1.3%' OR engine_type LIKE '%1,3%' THEN '1.3'
                      WHEN engine_type LIKE '%1.4%' OR engine_type LIKE '%1,4%' THEN '1.4'
                      WHEN engine_type LIKE '%1.5%' OR engine_type LIKE '%1,5%' THEN '1.5'
                      WHEN engine_type LIKE '%1.6%' OR engine_type LIKE '%1,6%' THEN '1.6'
                      WHEN engine_type LIKE '%1.7%' OR engine_type LIKE '%1,7%' THEN '1.7'
                      WHEN engine_type LIKE '%1.8%' OR engine_type LIKE '%1,8%' THEN '1.8'
                      WHEN engine_type LIKE '%1.9%' OR engine_type LIKE '%1,9%' THEN '1.9'
                      WHEN engine_type LIKE '%2.0%' OR engine_type LIKE '%2,0%' THEN '2.0'
                      WHEN engine_type LIKE '%2.1%' OR engine_type LIKE '%2,1%' THEN '2.1'
                      WHEN engine_type LIKE '%2.2%' OR engine_type LIKE '%2,2%' THEN '2.2'
                      WHEN engine_type LIKE '%2.3%' OR engine_type LIKE '%2,3%' THEN '2.3'
                      WHEN engine_type LIKE '%2.4%' OR engine_type LIKE '%2,4%' THEN '2.4'
                      WHEN engine_type LIKE '%2.5%' OR engine_type LIKE '%2,5%' THEN '2.5'
                      WHEN engine_type LIKE '%2.6%' OR engine_type LIKE '%2,6%' THEN '2.6'
                      WHEN engine_type LIKE '%2.7%' OR engine_type LIKE '%2,7%' THEN '2.7'
                      WHEN engine_type LIKE '%2.8%' OR engine_type LIKE '%2,8%' THEN '2.8'
                      WHEN engine_type LIKE '%2.9%' OR engine_type LIKE '%2,9%' THEN '2.9'
                      WHEN engine_type LIKE '%3.0%' OR engine_type LIKE '%3,0%' THEN '3.0'
                      WHEN engine_type LIKE '%3.1%' OR engine_type LIKE '%3,1%' THEN '3.1'
                      WHEN engine_type LIKE '%3.2%' OR engine_type LIKE '%3,2%' THEN '3.2'
                      WHEN engine_type LIKE '%3.3%' OR engine_type LIKE '%3,3%' THEN '3.3'
                      WHEN engine_type LIKE '%3.4%' OR engine_type LIKE '%3,4%' THEN '3.4'
                      WHEN engine_type LIKE '%3.5%' OR engine_type LIKE '%3,5%' THEN '3.5'
                      WHEN engine_type LIKE '%3.6%' OR engine_type LIKE '%3,6%' THEN '3.6'
                      WHEN engine_type LIKE '%3.7%' OR engine_type LIKE '%3,7%' THEN '3.7'
                      WHEN engine_type LIKE '%3.8%' OR engine_type LIKE '%3,8%' THEN '3.8'
                      WHEN engine_type LIKE '%4.0%' OR engine_type LIKE '%4,0%' THEN '4.0'
                      WHEN engine_type LIKE '%4.2%' OR engine_type LIKE '%4,2%' THEN '4.2'
                      WHEN engine_type LIKE '%4.4%' OR engine_type LIKE '%4,4%' THEN '4.4'
                      WHEN engine_type LIKE '%4.6%' OR engine_type LIKE '%4,6%' THEN '4.6'
                      WHEN engine_type LIKE '%4.7%' OR engine_type LIKE '%4,7%' THEN '4.7'
                      WHEN engine_type LIKE '%5.0%' OR engine_type LIKE '%5,0%' THEN '5.0'
                      WHEN engine_type LIKE '%5.2%' OR engine_type LIKE '%5,2%' THEN '5.2'
                      WHEN engine_type LIKE '%5.5%' OR engine_type LIKE '%5,5%' THEN '5.5'
                      WHEN engine_type LIKE '%6.0%' OR engine_type LIKE '%6,0%' THEN '6.0'
                      WHEN engine_type LIKE '%6.2%' OR engine_type LIKE '%6,2%' THEN '6.2'
                      WHEN engine_type LIKE '%6.3%' OR engine_type LIKE '%6,3%' THEN '6.3'
                      WHEN engine_type LIKE '%6.5%' OR engine_type LIKE '%6,5%' THEN '6.5'

                      ELSE NULL
    END;

-- ============================================================
-- PASUL 4: CURATARE CO2
-- Eliminam valorile invalide si sufixul " g/km"
-- ============================================================

update Germany_Cars_Cleaned
SET co2_g = NULL
WHERE co2_g LIKE '%-%';

UPDATE Germany_Cars_Cleaned
SET co2_g = trim(co2_g, ' g/km')
WHERE co2_g IS NOT NULL;


-- ============================================================
-- PASUL 5: RECREARE TABEL CU TIPURI CORECTE
-- Convertim coloanele la tipurile potrivite (INTEGER, REAL)
-- Eliminam coloanele neutilizate (registration_date, power_kw,
--   fuel_consumption_l_100km)
-- ============================================================

drop table if exists Germany_Cars_Cleaned1;
create table Germany_Cars_Cleaned1 as
select id,
       brand,
       model,
       color,
       cast((year) as integer)          as year,
       cast((price_in_euro) as integer) as price_in_euro,
       cast((power_ps) as integer)      as power_ps,
       transmission_type,
       fuel_type,
       cast((km) as integer)            as km,
       cast((engine_type) as real)      as engine_type,
       cast((co2_g) as real)            as co2_g,
       fuel_consumption_l_100km
from Germany_Cars_Cleaned;

drop table if exists Germany_Cars_Cleaned;

alter table Germany_Cars_Cleaned1
    rename to Germany_Cars_Cleaned;

CREATE INDEX idx_cars_lookup ON Germany_Cars_Cleaned (brand, fuel_type, power_ps);

-- ============================================================
-- PASUL 5b: STANDARDIZARE BRAND (lowercase temporar)
-- Convertim la lowercase pentru ca PASUL 7 (modele) foloseste
-- WHERE brand = 'mercedes-benz' etc. Se revine la Proper Case
-- in PASUL 10b
-- ============================================================

UPDATE Germany_Cars_Cleaned
SET brand = LOWER(TRIM(brand));

-- Inlocuim cratimele cu spatii temporar pentru brandurile care folosesc spatiu in interogari (land-rover, alfa-romeo, aston-martin)
UPDATE Germany_Cars_Cleaned
SET brand = REPLACE(brand, '-', ' ')
WHERE brand IN ('alfa-romeo', 'aston-martin', 'land-rover');

-- ============================================================
-- PASUL 5c: STANDARDIZARE TIP TRANSMISIE
-- Clasificam in: Manual, Automatic, Semi-automatic, Unknown
-- ============================================================

UPDATE Germany_Cars_Cleaned
SET transmission_type = CASE
                            WHEN UPPER(transmission_type) LIKE '%MANUAL%' THEN 'Manual'
                            WHEN UPPER(transmission_type) LIKE '%SEMI%AUTO%' OR
                                 UPPER(transmission_type) LIKE '%SEMI-AUTO%' THEN 'Semi-automatic'
                            WHEN UPPER(transmission_type) LIKE '%AUTOMATIC%' THEN 'Automatic'
                            WHEN transmission_type IS NULL OR TRIM(transmission_type) = '' THEN 'Unknown'
                            ELSE transmission_type
    END;

-- ============================================================
-- PASUL 6: ELIMINARE PREFIX BRAND DIN MODEL
-- Numele brandului apare duplicat in coloana model
-- ============================================================


-- Conversiile de brand la Proper Case au fost mutate la Pasul 10b pentru a nu strica model cleaning-ul de la Pasul 7.


UPDATE Germany_Cars_Cleaned
SET model = REPLACE(model, 'Mercedes-Benz ', '')
WHERE model LIKE 'Mercedes-Benz %';
UPDATE Germany_Cars_Cleaned
SET model = REPLACE(model, 'BMW ', '')
WHERE model LIKE 'BMW %';
UPDATE Germany_Cars_Cleaned
SET model = REPLACE(model, 'Audi ', '')
WHERE model LIKE 'Audi %';
UPDATE Germany_Cars_Cleaned
SET model = REPLACE(model, 'Volkswagen ', '')
WHERE model LIKE 'Volkswagen %';
UPDATE Germany_Cars_Cleaned
SET model = REPLACE(model, 'Porsche ', '')
WHERE model LIKE 'Porsche %';
UPDATE Germany_Cars_Cleaned
SET model = REPLACE(model, 'MINI ', '')
WHERE model LIKE 'MINI %';
UPDATE Germany_Cars_Cleaned
SET model = REPLACE(model, 'Opel ', '')
WHERE model LIKE 'Opel %';
UPDATE Germany_Cars_Cleaned
SET model = REPLACE(model, 'Peugeot ', '')
WHERE model LIKE 'Peugeot %';
UPDATE Germany_Cars_Cleaned
SET model = REPLACE(model, 'Renault ', '')
WHERE model LIKE 'Renault %';
UPDATE Germany_Cars_Cleaned
SET model = REPLACE(model, 'Fiat ', '')
WHERE model LIKE 'Fiat %';
UPDATE Germany_Cars_Cleaned
SET model = REPLACE(model, 'Toyota ', '')
WHERE model LIKE 'Toyota %';
UPDATE Germany_Cars_Cleaned
SET model = REPLACE(model, 'Ford ', '')
WHERE model LIKE 'Ford %';
UPDATE Germany_Cars_Cleaned
SET model = REPLACE(model, 'Skoda ', '')
WHERE model LIKE 'Skoda %';
UPDATE Germany_Cars_Cleaned
SET model = REPLACE(model, 'Volvo ', '')
WHERE model LIKE 'Volvo %';
UPDATE Germany_Cars_Cleaned
SET model = REPLACE(model, 'Hyundai ', '')
WHERE model LIKE 'Hyundai %';
UPDATE Germany_Cars_Cleaned
SET model = REPLACE(model, 'Kia ', '')
WHERE model LIKE 'Kia %';
UPDATE Germany_Cars_Cleaned
SET model = REPLACE(model, 'Seat ', '')
WHERE model LIKE 'Seat %';
UPDATE Germany_Cars_Cleaned
SET model = REPLACE(model, 'SEAT ', '')
WHERE model LIKE 'SEAT %';
UPDATE Germany_Cars_Cleaned
SET model = REPLACE(model, 'Dacia ', '')
WHERE model LIKE 'Dacia %';
UPDATE Germany_Cars_Cleaned
SET model = REPLACE(model, 'Alfa Romeo ', '')
WHERE model LIKE 'Alfa Romeo %';
UPDATE Germany_Cars_Cleaned
SET model = REPLACE(model, 'Nissan ', '')
WHERE model LIKE 'Nissan %';
UPDATE Germany_Cars_Cleaned
SET model = REPLACE(model, 'Honda ', '')
WHERE model LIKE 'Honda %';
UPDATE Germany_Cars_Cleaned
SET model = REPLACE(model, 'Mazda ', '')
WHERE model LIKE 'Mazda %';
UPDATE Germany_Cars_Cleaned
SET model = REPLACE(model, 'Mitsubishi ', '')
WHERE model LIKE 'Mitsubishi %';
UPDATE Germany_Cars_Cleaned
SET model = REPLACE(model, 'Citroen ', '')
WHERE model LIKE 'Citroen %';
UPDATE Germany_Cars_Cleaned
SET model = REPLACE(model, 'Land Rover ', '')
WHERE model LIKE 'Land Rover %';
UPDATE Germany_Cars_Cleaned
SET model = REPLACE(model, 'Jaguar ', '')
WHERE model LIKE 'Jaguar %';
UPDATE Germany_Cars_Cleaned
SET model = REPLACE(model, 'Jeep ', '')
WHERE model LIKE 'Jeep %';
UPDATE Germany_Cars_Cleaned
SET model = REPLACE(model, 'Lamborghini ', '')
WHERE model LIKE 'Lamborghini %';
UPDATE Germany_Cars_Cleaned
SET model = REPLACE(model, 'Maserati ', '')
WHERE model LIKE 'Maserati %';
UPDATE Germany_Cars_Cleaned
SET model = REPLACE(model, 'Bentley ', '')
WHERE model LIKE 'Bentley %';
UPDATE Germany_Cars_Cleaned
SET model = REPLACE(model, 'Aston Martin ', '')
WHERE model LIKE 'Aston Martin %';
UPDATE Germany_Cars_Cleaned
SET model = REPLACE(model, 'Ferrari ', '')
WHERE model LIKE 'Ferrari %';
UPDATE Germany_Cars_Cleaned
SET model = REPLACE(model, 'Lancia ', '')
WHERE model LIKE 'Lancia %';
UPDATE Germany_Cars_Cleaned
SET model = REPLACE(model, 'Saab ', '')
WHERE model LIKE 'Saab %';
UPDATE Germany_Cars_Cleaned
SET model = REPLACE(model, 'Dodge ', '')
WHERE model LIKE 'Dodge %';
UPDATE Germany_Cars_Cleaned
SET model = REPLACE(model, 'Chevrolet ', '')
WHERE model LIKE 'Chevrolet %';
UPDATE Germany_Cars_Cleaned
SET model = REPLACE(model, 'Cadillac ', '')
WHERE model LIKE 'Cadillac %';
UPDATE Germany_Cars_Cleaned
SET model = REPLACE(model, 'Daewoo ', '')
WHERE model LIKE 'Daewoo %';
UPDATE Germany_Cars_Cleaned
SET model = REPLACE(model, 'Infiniti ', '')
WHERE model LIKE 'Infiniti %';
UPDATE Germany_Cars_Cleaned
SET model = REPLACE(model, 'Ssangyong ', '')
WHERE model LIKE 'Ssangyong %';
UPDATE Germany_Cars_Cleaned
SET model = REPLACE(model, 'Rover ', '')
WHERE model LIKE 'Rover %';
UPDATE Germany_Cars_Cleaned
SET model = REPLACE(model, 'Lada ', '')
WHERE model LIKE 'Lada %';
UPDATE Germany_Cars_Cleaned
SET model = REPLACE(model, 'Daihatsu ', '')
WHERE model LIKE 'Daihatsu %';
UPDATE Germany_Cars_Cleaned
SET model = REPLACE(model, 'Isuzu ', '')
WHERE model LIKE 'Isuzu %';
UPDATE Germany_Cars_Cleaned
SET model = REPLACE(model, 'smart ', '')
WHERE model LIKE 'smart %';
UPDATE Germany_Cars_Cleaned
SET model = REPLACE(model, 'Chrysler ', '')
WHERE model LIKE 'Chrysler %';
UPDATE Germany_Cars_Cleaned
SET model = REPLACE(model, 'Proton ', '')
WHERE model LIKE 'Proton %';

-- Stergem randuri unde model = numele brandului (nicio informatie reala despre model)
DELETE
FROM Germany_Cars_Cleaned
WHERE LOWER(TRIM(model)) = LOWER(TRIM(brand));

-- ============================================================
-- PASUL 7: STANDARDIZARE NUME MODELE (per brand)
-- Grupam variantele de motorizare/echipare intr-un model unic
-- Regula: variantele mai specifice se proceseaza PRIMELE
-- ============================================================

-- ==================== MERCEDES-BENZ ====================

UPDATE Germany_Cars_Cleaned
SET model = 'A-Class'
WHERE brand = 'mercedes-benz'
  AND (model LIKE 'A %' OR model LIKE 'AMG A %' OR model = 'A-Class');

UPDATE Germany_Cars_Cleaned
SET model = 'B-Class'
WHERE brand = 'mercedes-benz'
  AND model LIKE 'B %';

UPDATE Germany_Cars_Cleaned
SET model = 'C-Class'
WHERE brand = 'mercedes-benz'
  AND (model LIKE 'C %' OR model LIKE 'AMG C %' OR model LIKE 'C 3% AMG' OR model LIKE 'C 5% AMG');

UPDATE Germany_Cars_Cleaned
SET model = 'E-Class'
WHERE brand = 'mercedes-benz'
  AND (model LIKE 'E %' OR model LIKE 'AMG E %');

UPDATE Germany_Cars_Cleaned
SET model = 'S-Class'
WHERE brand = 'mercedes-benz'
  AND (model LIKE 'S %' OR model LIKE 'AMG S %' OR model LIKE 'Maybach S%' OR model LIKE 'Maybach S-%');

UPDATE Germany_Cars_Cleaned
SET model = 'G-Class'
WHERE brand = 'mercedes-benz'
  AND (model LIKE 'G %' OR model LIKE 'AMG G %' OR model = 'G');

UPDATE Germany_Cars_Cleaned
SET model = 'CLA'
WHERE brand = 'mercedes-benz'
  AND model LIKE 'CLA%';

UPDATE Germany_Cars_Cleaned
SET model = 'CLK'
WHERE brand = 'mercedes-benz'
  AND model LIKE 'CLK%';

UPDATE Germany_Cars_Cleaned
SET model = 'CLS'
WHERE brand = 'mercedes-benz'
  AND model LIKE 'CLS%';

UPDATE Germany_Cars_Cleaned
SET model = 'CL'
WHERE brand = 'mercedes-benz'
  AND (model LIKE 'CL %' OR model = 'CL');

UPDATE Germany_Cars_Cleaned
SET model = 'SLK'
WHERE brand = 'mercedes-benz'
  AND (model LIKE 'SLK%' OR model LIKE 'SLC%');

UPDATE Germany_Cars_Cleaned
SET model = 'SL-Class'
WHERE brand = 'mercedes-benz'
  AND model LIKE 'SL %';

UPDATE Germany_Cars_Cleaned
SET model = 'SLS'
WHERE brand = 'mercedes-benz'
  AND model LIKE 'SLS%';

UPDATE Germany_Cars_Cleaned
SET model = 'SLR'
WHERE brand = 'mercedes-benz'
  AND model LIKE 'SLR%';

UPDATE Germany_Cars_Cleaned
SET model = 'AMG GT'
WHERE brand = 'mercedes-benz'
  AND model LIKE 'AMG GT%';

UPDATE Germany_Cars_Cleaned
SET model = 'GLA'
WHERE brand = 'mercedes-benz'
  AND model LIKE 'GLA%';

UPDATE Germany_Cars_Cleaned
SET model = 'GLB'
WHERE brand = 'mercedes-benz'
  AND model LIKE 'GLB%';

UPDATE Germany_Cars_Cleaned
SET model = 'GLC'
WHERE brand = 'mercedes-benz'
  AND model LIKE 'GLC%';

UPDATE Germany_Cars_Cleaned
SET model = 'GLE'
WHERE brand = 'mercedes-benz'
  AND (model LIKE 'GLE%' OR model LIKE 'ML %' OR model LIKE 'M %' OR model LIKE 'ML%');

UPDATE Germany_Cars_Cleaned
SET model = 'GLK'
WHERE brand = 'mercedes-benz'
  AND model LIKE 'GLK%';

UPDATE Germany_Cars_Cleaned
SET model = 'GLS'
WHERE brand = 'mercedes-benz'
  AND (model LIKE 'GLS%' OR model LIKE 'GL %');

-- Vans
UPDATE Germany_Cars_Cleaned
SET model = 'V-Class'
WHERE brand = 'mercedes-benz'
  AND (model LIKE 'V %' OR model = 'V' OR model LIKE 'Viano%' OR model LIKE 'Vito%');

-- Electrice (EQ)
UPDATE Germany_Cars_Cleaned
SET model = 'EQA'
WHERE brand = 'mercedes-benz'
  AND model LIKE 'EQA%';
UPDATE Germany_Cars_Cleaned
SET model = 'EQB'
WHERE brand = 'mercedes-benz'
  AND model LIKE 'EQB%';
UPDATE Germany_Cars_Cleaned
SET model = 'EQC'
WHERE brand = 'mercedes-benz'
  AND model LIKE 'EQC%';
UPDATE Germany_Cars_Cleaned
SET model = 'EQE'
WHERE brand = 'mercedes-benz'
  AND model LIKE 'EQE%';
UPDATE Germany_Cars_Cleaned
SET model = 'EQS'
WHERE brand = 'mercedes-benz'
  AND model LIKE 'EQS%';
UPDATE Germany_Cars_Cleaned
SET model = 'EQV'
WHERE brand = 'mercedes-benz'
  AND model LIKE 'EQV%';

UPDATE Germany_Cars_Cleaned
SET model = 'R-Class'
WHERE brand = 'mercedes-benz'
  AND model LIKE 'R %';

-- Vehicule Comerciale
UPDATE Germany_Cars_Cleaned
SET model = 'Sprinter'
WHERE brand = 'mercedes-benz'
  AND model LIKE 'Sprinter%';
UPDATE Germany_Cars_Cleaned
SET model = 'Citan'
WHERE brand = 'mercedes-benz'
  AND model LIKE 'Citan%';
UPDATE Germany_Cars_Cleaned
SET model = 'Marco Polo'
WHERE brand = 'mercedes-benz'
  AND model LIKE 'Marco Polo%';
UPDATE Germany_Cars_Cleaned
SET model = 'T-Class'
WHERE brand = 'mercedes-benz'
  AND model LIKE 'T-Class%';
UPDATE Germany_Cars_Cleaned
SET model = 'Vaneo'
WHERE brand = 'mercedes-benz'
  AND model LIKE 'Vaneo%';
UPDATE Germany_Cars_Cleaned
SET model = 'Vario'
WHERE brand = 'mercedes-benz'
  AND model LIKE 'Vario%';
UPDATE Germany_Cars_Cleaned
SET model = 'Atego'
WHERE brand = 'mercedes-benz'
  AND model LIKE 'Atego%';
UPDATE Germany_Cars_Cleaned
SET model = 'X-Class'
WHERE brand = 'mercedes-benz'
  AND (model LIKE 'X %' OR model = 'X-Class');

-- ==================== BMW ====================

UPDATE Germany_Cars_Cleaned
SET model = '1 Series'
WHERE brand = 'bmw'
  AND (
    model LIKE '11_' OR model LIKE '12_' OR model LIKE '13_' OR model LIKE '14_'
        OR model LIKE '1er%'
    );

UPDATE Germany_Cars_Cleaned
SET model = '2 Series'
WHERE brand = 'bmw'
  AND (
    model LIKE '21_' OR model LIKE '22_' OR model LIKE '23_' OR model LIKE '24_'
        OR model = 'M2' OR model LIKE 'M2 %'
    );

UPDATE Germany_Cars_Cleaned
SET model = '3 Series'
WHERE brand = 'bmw'
  AND (
    model LIKE '31_' OR model LIKE '32_' OR model LIKE '33_' OR model LIKE '34_'
        OR model = 'M3' OR model LIKE 'M3 %'
    );

UPDATE Germany_Cars_Cleaned
SET model = '4 Series'
WHERE brand = 'bmw'
  AND (
    model LIKE '41_' OR model LIKE '42_' OR model LIKE '43_' OR model LIKE '44_'
        OR model = 'M4' OR model LIKE 'M4 %'
    );

UPDATE Germany_Cars_Cleaned
SET model = '5 Series'
WHERE brand = 'bmw'
  AND (
    model LIKE '51_' OR model LIKE '52_' OR model LIKE '53_' OR model LIKE '54_' OR model LIKE '55_'
        OR model = 'M5' OR model LIKE 'M5 %' OR model LIKE 'M550%'
    );

UPDATE Germany_Cars_Cleaned
SET model = '6 Series'
WHERE brand = 'bmw'
  AND (
    model LIKE '62_' OR model LIKE '63_' OR model LIKE '64_' OR model LIKE '65_'
        OR model = 'M6' OR model LIKE 'M6 %'
    );

UPDATE Germany_Cars_Cleaned
SET model = '7 Series'
WHERE brand = 'bmw'
  AND (
    model LIKE '72_' OR model LIKE '73_' OR model LIKE '74_' OR model LIKE '75_' OR model LIKE '76_'
        OR model = 'i7' OR model LIKE 'i7 %'
    );

UPDATE Germany_Cars_Cleaned
SET model = '8 Series'
WHERE brand = 'bmw'
  AND (
    model LIKE '84_' OR model LIKE '85_'
        OR model = 'M8' OR model LIKE 'M8 %' OR model LIKE 'M850%'
    );

-- Gama X (SUV-uri)
UPDATE Germany_Cars_Cleaned
SET model = 'X1'
WHERE brand = 'bmw'
  AND (model = 'X1' OR model LIKE 'X1 %');
UPDATE Germany_Cars_Cleaned
SET model = 'X2'
WHERE brand = 'bmw'
  AND (model = 'X2' OR model LIKE 'X2 %' OR model LIKE 'X2 M%');
UPDATE Germany_Cars_Cleaned
SET model = 'X3'
WHERE brand = 'bmw'
  AND (model = 'X3' OR model LIKE 'X3 %' OR model LIKE 'X3 M%');
UPDATE Germany_Cars_Cleaned
SET model = 'X4'
WHERE brand = 'bmw'
  AND (model = 'X4' OR model LIKE 'X4 %' OR model LIKE 'X4 M%');
UPDATE Germany_Cars_Cleaned
SET model = 'X5'
WHERE brand = 'bmw'
  AND (model = 'X5' OR model LIKE 'X5 %' OR model LIKE 'X5 M%');
UPDATE Germany_Cars_Cleaned
SET model = 'X6'
WHERE brand = 'bmw'
  AND (model = 'X6' OR model LIKE 'X6 %' OR model LIKE 'X6 M%');
UPDATE Germany_Cars_Cleaned
SET model = 'X7'
WHERE brand = 'bmw'
  AND (model = 'X7' OR model LIKE 'X7 %' OR model LIKE 'X7 M%');
UPDATE Germany_Cars_Cleaned
SET model = 'XM'
WHERE brand = 'bmw'
  AND (model = 'XM' OR model LIKE 'XM %');

-- Gama Z
UPDATE Germany_Cars_Cleaned
SET model = 'Z3'
WHERE brand = 'bmw'
  AND (model = 'Z3' OR model LIKE 'Z3 %' OR model LIKE 'Z3 M%');
UPDATE Germany_Cars_Cleaned
SET model = 'Z4'
WHERE brand = 'bmw'
  AND (model = 'Z4' OR model LIKE 'Z4 %' OR model LIKE 'Z4 M%');
UPDATE Germany_Cars_Cleaned
SET model = 'Z8'
WHERE brand = 'bmw'
  AND (model = 'Z8' OR model LIKE 'Z8 %');

-- Gama i (Electrice)
UPDATE Germany_Cars_Cleaned
SET model = 'i3'
WHERE brand = 'bmw'
  AND (model = 'i3' OR model LIKE 'i3 %');
UPDATE Germany_Cars_Cleaned
SET model = 'i4'
WHERE brand = 'bmw'
  AND (model = 'i4' OR model LIKE 'i4 %');
UPDATE Germany_Cars_Cleaned
SET model = 'i5'
WHERE brand = 'bmw'
  AND (model = 'i5' OR model LIKE 'i5 %');
UPDATE Germany_Cars_Cleaned
SET model = 'i8'
WHERE brand = 'bmw'
  AND (model = 'i8' OR model LIKE 'i8 %');
UPDATE Germany_Cars_Cleaned
SET model = 'iX'
WHERE brand = 'bmw'
  AND (model = 'iX' OR model LIKE 'iX %');
UPDATE Germany_Cars_Cleaned
SET model = 'iX1'
WHERE brand = 'bmw'
  AND (model = 'iX1' OR model LIKE 'iX1 %');
UPDATE Germany_Cars_Cleaned
SET model = 'iX3'
WHERE brand = 'bmw'
  AND (model = 'iX3' OR model LIKE 'iX3 %');

-- Active Hybrid
UPDATE Germany_Cars_Cleaned
SET model = '3 Series'
WHERE brand = 'bmw'
  AND model LIKE 'Active Hybrid 3%';
UPDATE Germany_Cars_Cleaned
SET model = '5 Series'
WHERE brand = 'bmw'
  AND model LIKE 'Active Hybrid 5%';
UPDATE Germany_Cars_Cleaned
SET model = '7 Series'
WHERE brand = 'bmw'
  AND model LIKE 'Active Hybrid 7%';

-- ==================== AUDI ====================

UPDATE Germany_Cars_Cleaned
SET model = 'A1'
WHERE brand = 'audi'
  AND (model LIKE 'A1%' OR model LIKE 'S1%');

UPDATE Germany_Cars_Cleaned
SET model = 'A2'
WHERE brand = 'audi'
  AND model LIKE 'A2%';

UPDATE Germany_Cars_Cleaned
SET model = 'A3'
WHERE brand = 'audi'
  AND (model LIKE 'A3%' OR model LIKE 'S3%' OR model LIKE 'RS3%' OR model LIKE 'RS 3%');

UPDATE Germany_Cars_Cleaned
SET model = 'A4'
WHERE brand = 'audi'
  AND (model LIKE 'A4%' OR model LIKE 'S4%' OR model LIKE 'RS4%' OR model LIKE 'RS 4%' OR model LIKE 'A4 allroad%');

UPDATE Germany_Cars_Cleaned
SET model = 'A5'
WHERE brand = 'audi'
  AND (model LIKE 'A5%' OR model LIKE 'S5%' OR model LIKE 'RS5%' OR model LIKE 'RS 5%');

UPDATE Germany_Cars_Cleaned
SET model = 'A6'
WHERE brand = 'audi'
  AND (model LIKE 'A6%' OR model LIKE 'S6%' OR model LIKE 'RS6%' OR model LIKE 'RS 6%'
    OR model LIKE 'A6 allroad%' OR model = 'Allroad');

UPDATE Germany_Cars_Cleaned
SET model = 'A7'
WHERE brand = 'audi'
  AND (model LIKE 'A7%' OR model LIKE 'S7%' OR model LIKE 'RS7%' OR model LIKE 'RS 7%');

UPDATE Germany_Cars_Cleaned
SET model = 'A8'
WHERE brand = 'audi'
  AND (model LIKE 'A8%' OR model LIKE 'S8%');

UPDATE Germany_Cars_Cleaned
SET model = 'TT'
WHERE brand = 'audi'
  AND (model LIKE 'TT%');

UPDATE Germany_Cars_Cleaned
SET model = 'R8'
WHERE brand = 'audi'
  AND (model = 'R8' OR model LIKE 'R8 %');

UPDATE Germany_Cars_Cleaned
SET model = 'Q2'
WHERE brand = 'audi'
  AND (model LIKE 'Q2%' OR model LIKE 'SQ2%');

UPDATE Germany_Cars_Cleaned
SET model = 'Q3'
WHERE brand = 'audi'
  AND (model LIKE 'Q3%' OR model LIKE 'RS Q3%' OR model LIKE 'RSQ3%');

UPDATE Germany_Cars_Cleaned
SET model = 'Q4 e-tron'
WHERE brand = 'audi'
  AND model LIKE 'Q4%';

UPDATE Germany_Cars_Cleaned
SET model = 'Q5'
WHERE brand = 'audi'
  AND (model LIKE 'Q5%' OR model LIKE 'SQ5%');

UPDATE Germany_Cars_Cleaned
SET model = 'Q7'
WHERE brand = 'audi'
  AND (model LIKE 'Q7%' OR model LIKE 'SQ7%');

UPDATE Germany_Cars_Cleaned
SET model = 'Q8'
WHERE brand = 'audi'
  AND (model LIKE 'Q8%' OR model LIKE 'SQ8%' OR model LIKE 'RS Q8%' OR model LIKE 'RSQ8%');

UPDATE Germany_Cars_Cleaned
SET model = 'e-tron GT'
WHERE brand = 'audi'
  AND model LIKE 'e-tron GT%';

UPDATE Germany_Cars_Cleaned
SET model = 'e-tron'
WHERE brand = 'audi'
  AND (model LIKE 'e-tron%' OR model = 'e-tron');

UPDATE Germany_Cars_Cleaned
SET model = 'QUATTRO'
WHERE brand = 'audi'
  AND model LIKE 'QUATTRO%';

UPDATE Germany_Cars_Cleaned
SET model = 'Cabriolet'
WHERE brand = 'audi'
  AND model LIKE 'Cabriolet%';

-- ==================== VOLKSWAGEN ====================

UPDATE Germany_Cars_Cleaned
SET model = 'Transporter'
WHERE brand = 'volkswagen'
  AND (
    model LIKE 'T4%' OR model LIKE 'T5%' OR model LIKE 'T6%' OR model LIKE 'T7%'
        OR model LIKE 'Transporter%'
        OR model LIKE 'Multivan%'
        OR model LIKE 'Caravelle%'
        OR model LIKE 'California%'
        OR model LIKE 'Grand California%'
    );

UPDATE Germany_Cars_Cleaned
SET model = 'Golf'
WHERE brand = 'volkswagen'
  AND (model LIKE 'Golf%' OR model LIKE 'e-Golf%' OR model = 'Cross Golf');

UPDATE Germany_Cars_Cleaned
SET model = 'Passat'
WHERE brand = 'volkswagen'
  AND (model LIKE 'Passat%' OR model LIKE 'CC%');

UPDATE Germany_Cars_Cleaned
SET model = 'Polo'
WHERE brand = 'volkswagen'
  AND (model LIKE 'Polo%' OR model LIKE 'Cross Polo%');

UPDATE Germany_Cars_Cleaned
SET model = 'Beetle'
WHERE brand = 'volkswagen'
  AND (model LIKE 'Beetle%' OR model LIKE 'New Beetle%' OR model LIKE 'Käfer%');

UPDATE Germany_Cars_Cleaned
SET model = 'Tiguan'
WHERE brand = 'volkswagen'
  AND model LIKE 'Tiguan%';

UPDATE Germany_Cars_Cleaned
SET model = 'Touareg'
WHERE brand = 'volkswagen'
  AND model LIKE 'Touareg%';

UPDATE Germany_Cars_Cleaned
SET model = 'Touran'
WHERE brand = 'volkswagen'
  AND (model LIKE 'Touran%' OR model LIKE 'Cross Touran%');

UPDATE Germany_Cars_Cleaned
SET model = 'Sharan'
WHERE brand = 'volkswagen'
  AND model LIKE 'Sharan%';

-- ID Familie
UPDATE Germany_Cars_Cleaned
SET model = 'ID.3'
WHERE brand = 'volkswagen'
  AND model LIKE 'ID.3%';
UPDATE Germany_Cars_Cleaned
SET model = 'ID.4'
WHERE brand = 'volkswagen'
  AND model LIKE 'ID.4%';
UPDATE Germany_Cars_Cleaned
SET model = 'ID.5'
WHERE brand = 'volkswagen'
  AND model LIKE 'ID.5%';
UPDATE Germany_Cars_Cleaned
SET model = 'ID. Buzz'
WHERE brand = 'volkswagen'
  AND model LIKE 'ID. Buzz%';

-- Altele VW
UPDATE Germany_Cars_Cleaned
SET model = 'Caddy'
WHERE brand = 'volkswagen'
  AND model LIKE 'Caddy%';
UPDATE Germany_Cars_Cleaned
SET model = 'Crafter'
WHERE brand = 'volkswagen'
  AND model LIKE 'Crafter%';
UPDATE Germany_Cars_Cleaned
SET model = 'Amarok'
WHERE brand = 'volkswagen'
  AND model LIKE 'Amarok%';
UPDATE Germany_Cars_Cleaned
SET model = 'Arteon'
WHERE brand = 'volkswagen'
  AND model LIKE 'Arteon%';
UPDATE Germany_Cars_Cleaned
SET model = 'Taigo'
WHERE brand = 'volkswagen'
  AND model LIKE 'Taigo%';
UPDATE Germany_Cars_Cleaned
SET model = 'T-Cross'
WHERE brand = 'volkswagen'
  AND model LIKE 'T-Cross%';
UPDATE Germany_Cars_Cleaned
SET model = 'T-Roc'
WHERE brand = 'volkswagen'
  AND model LIKE 'T-Roc%';
UPDATE Germany_Cars_Cleaned
SET model = 'Scirocco'
WHERE brand = 'volkswagen'
  AND model LIKE 'Scirocco%';
UPDATE Germany_Cars_Cleaned
SET model = 'Eos'
WHERE brand = 'volkswagen'
  AND model LIKE 'Eos%';
UPDATE Germany_Cars_Cleaned
SET model = 'Phaeton'
WHERE brand = 'volkswagen'
  AND model LIKE 'Phaeton%';
UPDATE Germany_Cars_Cleaned
SET model = 'Lupo'
WHERE brand = 'volkswagen'
  AND model LIKE 'Lupo%';
UPDATE Germany_Cars_Cleaned
SET model = 'Fox'
WHERE brand = 'volkswagen'
  AND model LIKE 'Fox%';
UPDATE Germany_Cars_Cleaned
SET model = 'Jetta'
WHERE brand = 'volkswagen'
  AND model LIKE 'Jetta%';
UPDATE Germany_Cars_Cleaned
SET model = 'Bora'
WHERE brand = 'volkswagen'
  AND model LIKE 'Bora%';
UPDATE Germany_Cars_Cleaned
SET model = 'up!'
WHERE brand = 'volkswagen'
  AND (model LIKE 'up!%' OR model LIKE 'e-up!%');
UPDATE Germany_Cars_Cleaned
SET model = 'Atlas'
WHERE brand = 'volkswagen'
  AND model LIKE 'Atlas%';
UPDATE Germany_Cars_Cleaned
SET model = 'XL1'
WHERE brand = 'volkswagen'
  AND model LIKE 'XL1%';
UPDATE Germany_Cars_Cleaned
SET model = 'LT'
WHERE brand = 'volkswagen'
  AND model LIKE 'LT%';
UPDATE Germany_Cars_Cleaned
SET model = 'Bus'
WHERE brand = 'volkswagen'
  AND model LIKE 'Bus%';

-- ==================== PORSCHE ====================

UPDATE Germany_Cars_Cleaned
SET model = '911'
WHERE brand = 'porsche'
  AND (
    model LIKE '911%' OR model LIKE '991%' OR model LIKE '992%'
        OR model LIKE '993%' OR model LIKE '996%' OR model LIKE '997%'
    );

UPDATE Germany_Cars_Cleaned
SET model = '718'
WHERE brand = 'porsche'
  AND (model LIKE '718%' OR model LIKE 'Boxster%' OR model LIKE 'Cayman%');

UPDATE Germany_Cars_Cleaned
SET model = 'Cayenne'
WHERE brand = 'porsche'
  AND model LIKE 'Cayenne%';
UPDATE Germany_Cars_Cleaned
SET model = 'Panamera'
WHERE brand = 'porsche'
  AND model LIKE 'Panamera%';
UPDATE Germany_Cars_Cleaned
SET model = 'Macan'
WHERE brand = 'porsche'
  AND model LIKE 'Macan%';
UPDATE Germany_Cars_Cleaned
SET model = 'Taycan'
WHERE brand = 'porsche'
  AND model LIKE 'Taycan%';

-- Modele clasice Porsche
UPDATE Germany_Cars_Cleaned
SET model = 'Targa'
WHERE brand = 'porsche'
  AND model LIKE 'Targa%';
UPDATE Germany_Cars_Cleaned
SET model = 'Carrera GT'
WHERE brand = 'porsche'
  AND model LIKE 'Carrera GT%';
UPDATE Germany_Cars_Cleaned
SET model = '918'
WHERE brand = 'porsche'
  AND model LIKE '918%';
UPDATE Germany_Cars_Cleaned
SET model = '356'
WHERE brand = 'porsche'
  AND model LIKE '356%';

-- ==================== MINI ====================

UPDATE Germany_Cars_Cleaned
SET model = 'Countryman'
WHERE brand = 'mini'
  AND model LIKE '%Countryman%';

UPDATE Germany_Cars_Cleaned
SET model = 'Clubman'
WHERE brand = 'mini'
  AND model LIKE '%Clubman%';

UPDATE Germany_Cars_Cleaned
SET model = 'Paceman'
WHERE brand = 'mini'
  AND model LIKE '%Paceman%';

UPDATE Germany_Cars_Cleaned
SET model = 'Cabrio'
WHERE brand = 'mini'
  AND (model LIKE '%Cabrio%' OR model LIKE '%Convertible%' OR model LIKE '%Cabriolet%');

UPDATE Germany_Cars_Cleaned
SET model = 'Coupe'
WHERE brand = 'mini'
  AND (model LIKE '%Coupe%' OR model LIKE '%Roadster%');

UPDATE Germany_Cars_Cleaned
SET model = 'Hatch'
WHERE brand = 'mini'
  AND model NOT IN ('Countryman', 'Clubman', 'Paceman', 'Cabrio', 'Coupe');

-- ==================== FIAT ====================

UPDATE Germany_Cars_Cleaned
SET model = '500'
WHERE brand = 'fiat'
  AND (
    model LIKE '500%'
        OR model LIKE '595 Abarth%'
    );

UPDATE Germany_Cars_Cleaned
SET model = 'Punto'
WHERE brand = 'fiat'
  AND (model LIKE 'Punto%' OR model LIKE 'Grande Punto%');

UPDATE Germany_Cars_Cleaned
SET model = 'Panda'
WHERE brand = 'fiat'
  AND (model LIKE 'Panda%' OR model LIKE 'New Panda%');

UPDATE Germany_Cars_Cleaned
SET model = 'Tipo'
WHERE brand = 'fiat'
  AND model LIKE 'Tipo%';

UPDATE Germany_Cars_Cleaned
SET model = 'Doblo'
WHERE brand = 'fiat'
  AND (model LIKE 'Doblo%' OR model LIKE 'E-Doblo%');

UPDATE Germany_Cars_Cleaned
SET model = 'Ducato'
WHERE brand = 'fiat'
  AND model LIKE 'Ducato%';

UPDATE Germany_Cars_Cleaned
SET model = 'Bravo'
WHERE brand = 'fiat'
  AND (model LIKE 'Bravo%' OR model LIKE 'Brava%');

-- Altele Fiat
UPDATE Germany_Cars_Cleaned
SET model = 'Linea'
WHERE brand = 'fiat'
  AND model LIKE 'Linea%';
UPDATE Germany_Cars_Cleaned
SET model = 'Freemont'
WHERE brand = 'fiat'
  AND model LIKE 'Freemont%';
UPDATE Germany_Cars_Cleaned
SET model = 'Fullback'
WHERE brand = 'fiat'
  AND model LIKE 'Fullback%';
UPDATE Germany_Cars_Cleaned
SET model = 'Qubo'
WHERE brand = 'fiat'
  AND model LIKE 'Qubo%';
UPDATE Germany_Cars_Cleaned
SET model = 'Sedici'
WHERE brand = 'fiat'
  AND model LIKE 'Sedici%';
UPDATE Germany_Cars_Cleaned
SET model = 'Scudo'
WHERE brand = 'fiat'
  AND model LIKE 'Scudo%';
UPDATE Germany_Cars_Cleaned
SET model = 'Fiorino'
WHERE brand = 'fiat'
  AND model LIKE 'Fiorino%';
UPDATE Germany_Cars_Cleaned
SET model = 'Talento'
WHERE brand = 'fiat'
  AND model LIKE 'Talento%';
UPDATE Germany_Cars_Cleaned
SET model = 'Ulysse'
WHERE brand = 'fiat'
  AND model LIKE 'Ulysse%';
UPDATE Germany_Cars_Cleaned
SET model = 'Multipla'
WHERE brand = 'fiat'
  AND model LIKE 'Multipla%';
UPDATE Germany_Cars_Cleaned
SET model = 'Seicento'
WHERE brand = 'fiat'
  AND model LIKE 'Seicento%';
UPDATE Germany_Cars_Cleaned
SET model = 'Stilo'
WHERE brand = 'fiat'
  AND model LIKE 'Stilo%';
UPDATE Germany_Cars_Cleaned
SET model = 'Idea'
WHERE brand = 'fiat'
  AND model LIKE 'Idea%';
UPDATE Germany_Cars_Cleaned
SET model = 'Croma'
WHERE brand = 'fiat'
  AND model LIKE 'Croma%';
UPDATE Germany_Cars_Cleaned
SET model = 'Strada'
WHERE brand = 'fiat'
  AND model LIKE 'Strada%';
UPDATE Germany_Cars_Cleaned
SET model = '124 Spider'
WHERE brand = 'fiat'
  AND model LIKE '124 Spider%';
UPDATE Germany_Cars_Cleaned
SET model = 'Punto Evo'
WHERE brand = 'fiat'
  AND model LIKE 'Punto Evo%';

-- ==================== SMART ====================

UPDATE Germany_Cars_Cleaned
SET model = 'forTwo'
WHERE brand = 'smart'
  AND (
    model LIKE 'forTwo%'
        OR model LIKE 'smart forTwo%'
        OR model LIKE 'city-coupé%'
        OR model LIKE 'city-cabrio%'
        OR model LIKE 'brabus%'
        OR model LIKE 'smart brabus%'
        OR model LIKE 'smart city%'
    );

UPDATE Germany_Cars_Cleaned
SET model = 'forFour'
WHERE brand = 'smart'
  AND model LIKE 'forFour%';
UPDATE Germany_Cars_Cleaned
SET model = 'roadster'
WHERE brand = 'smart'
  AND model LIKE 'roadster%';
UPDATE Germany_Cars_Cleaned
SET model = '#1'
WHERE brand = 'smart'
  AND (model LIKE '#1%' OR model LIKE 'smart #1%');

-- ==================== OPEL ====================

UPDATE Germany_Cars_Cleaned
SET model = 'Corsa'
WHERE brand = 'opel'
  AND (model LIKE 'Corsa%');

UPDATE Germany_Cars_Cleaned
SET model = 'Mokka'
WHERE brand = 'opel'
  AND (model LIKE 'Mokka%');

UPDATE Germany_Cars_Cleaned
SET model = 'Astra'
WHERE brand = 'opel'
  AND model LIKE 'Astra%';

UPDATE Germany_Cars_Cleaned
SET model = 'Insignia'
WHERE brand = 'opel'
  AND model LIKE 'Insignia%';

UPDATE Germany_Cars_Cleaned
SET model = 'Zafira'
WHERE brand = 'opel'
  AND model LIKE 'Zafira%';

UPDATE Germany_Cars_Cleaned
SET model = 'Grandland'
WHERE brand = 'opel'
  AND model LIKE 'Grandland%';

UPDATE Germany_Cars_Cleaned
SET model = 'Crossland'
WHERE brand = 'opel'
  AND model LIKE 'Crossland%';

UPDATE Germany_Cars_Cleaned
SET model = 'Meriva'
WHERE brand = 'opel'
  AND model LIKE 'Meriva%';
UPDATE Germany_Cars_Cleaned
SET model = 'Adam'
WHERE brand = 'opel'
  AND model LIKE 'Adam%';
UPDATE Germany_Cars_Cleaned
SET model = 'Agila'
WHERE brand = 'opel'
  AND model LIKE 'Agila%';
UPDATE Germany_Cars_Cleaned
SET model = 'Antara'
WHERE brand = 'opel'
  AND model LIKE 'Antara%';
UPDATE Germany_Cars_Cleaned
SET model = 'Cascada'
WHERE brand = 'opel'
  AND model LIKE 'Cascada%';
UPDATE Germany_Cars_Cleaned
SET model = 'Combo'
WHERE brand = 'opel'
  AND (model LIKE 'Combo%');
UPDATE Germany_Cars_Cleaned
SET model = 'Frontera'
WHERE brand = 'opel'
  AND model LIKE 'Frontera%';
UPDATE Germany_Cars_Cleaned
SET model = 'GT'
WHERE brand = 'opel'
  AND model = 'GT';
UPDATE Germany_Cars_Cleaned
SET model = 'Karl'
WHERE brand = 'opel'
  AND model LIKE 'Karl%';
UPDATE Germany_Cars_Cleaned
SET model = 'Movano'
WHERE brand = 'opel'
  AND model LIKE 'Movano%';
UPDATE Germany_Cars_Cleaned
SET model = 'Omega'
WHERE brand = 'opel'
  AND model LIKE 'Omega%';
UPDATE Germany_Cars_Cleaned
SET model = 'Signum'
WHERE brand = 'opel'
  AND model LIKE 'Signum%';
UPDATE Germany_Cars_Cleaned
SET model = 'Speedster'
WHERE brand = 'opel'
  AND model LIKE 'Speedster%';
UPDATE Germany_Cars_Cleaned
SET model = 'Tigra'
WHERE brand = 'opel'
  AND model LIKE 'Tigra%';
UPDATE Germany_Cars_Cleaned
SET model = 'Vectra'
WHERE brand = 'opel'
  AND model LIKE 'Vectra%';
UPDATE Germany_Cars_Cleaned
SET model = 'Vivaro'
WHERE brand = 'opel'
  AND (model LIKE 'Vivaro%');
UPDATE Germany_Cars_Cleaned
SET model = 'Ampera'
WHERE brand = 'opel'
  AND (model LIKE 'Ampera%');
UPDATE Germany_Cars_Cleaned
SET model = 'Rocks-e'
WHERE brand = 'opel'
  AND model LIKE 'Rocks-e%';

-- ==================== PEUGEOT ====================

UPDATE Germany_Cars_Cleaned
SET model = '208'
WHERE brand = 'peugeot'
  AND (model LIKE '208%' OR model LIKE 'e-208%');
UPDATE Germany_Cars_Cleaned
SET model = '2008'
WHERE brand = 'peugeot'
  AND (model LIKE '2008%' OR model LIKE 'e-2008%');

-- Altele
UPDATE Germany_Cars_Cleaned
SET model = '107'
WHERE brand = 'peugeot'
  AND model LIKE '107%';
UPDATE Germany_Cars_Cleaned
SET model = '108'
WHERE brand = 'peugeot'
  AND model LIKE '108%';
UPDATE Germany_Cars_Cleaned
SET model = '206'
WHERE brand = 'peugeot'
  AND model LIKE '206%';
UPDATE Germany_Cars_Cleaned
SET model = '207'
WHERE brand = 'peugeot'
  AND model LIKE '207%';
UPDATE Germany_Cars_Cleaned
SET model = '3008'
WHERE brand = 'peugeot'
  AND model LIKE '3008%';
UPDATE Germany_Cars_Cleaned
SET model = '307'
WHERE brand = 'peugeot'
  AND model LIKE '307%';
UPDATE Germany_Cars_Cleaned
SET model = '308'
WHERE brand = 'peugeot'
  AND model LIKE '308%';
UPDATE Germany_Cars_Cleaned
SET model = '406'
WHERE brand = 'peugeot'
  AND model LIKE '406%';
UPDATE Germany_Cars_Cleaned
SET model = '407'
WHERE brand = 'peugeot'
  AND model LIKE '407%';
UPDATE Germany_Cars_Cleaned
SET model = '408'
WHERE brand = 'peugeot'
  AND model LIKE '408%';
UPDATE Germany_Cars_Cleaned
SET model = '5008'
WHERE brand = 'peugeot'
  AND model LIKE '5008%';
UPDATE Germany_Cars_Cleaned
SET model = '508'
WHERE brand = 'peugeot'
  AND model LIKE '508%';
UPDATE Germany_Cars_Cleaned
SET model = '607'
WHERE brand = 'peugeot'
  AND model LIKE '607%';
UPDATE Germany_Cars_Cleaned
SET model = '807'
WHERE brand = 'peugeot'
  AND model LIKE '807%';
UPDATE Germany_Cars_Cleaned
SET model = '1007'
WHERE brand = 'peugeot'
  AND model LIKE '1007%';
UPDATE Germany_Cars_Cleaned
SET model = '4007'
WHERE brand = 'peugeot'
  AND model LIKE '4007%';
UPDATE Germany_Cars_Cleaned
SET model = '4008'
WHERE brand = 'peugeot'
  AND model LIKE '4008%';
UPDATE Germany_Cars_Cleaned
SET model = 'Bipper'
WHERE brand = 'peugeot'
  AND model LIKE 'Bipper%';
UPDATE Germany_Cars_Cleaned
SET model = 'Boxer'
WHERE brand = 'peugeot'
  AND model LIKE 'Boxer%';
UPDATE Germany_Cars_Cleaned
SET model = 'Expert'
WHERE brand = 'peugeot'
  AND model LIKE 'Expert%';
UPDATE Germany_Cars_Cleaned
SET model = 'iOn'
WHERE brand = 'peugeot'
  AND model LIKE 'iOn%';
UPDATE Germany_Cars_Cleaned
SET model = 'Partner'
WHERE brand = 'peugeot'
  AND model LIKE 'Partner%';
UPDATE Germany_Cars_Cleaned
SET model = 'RCZ'
WHERE brand = 'peugeot'
  AND model LIKE 'RCZ%';
UPDATE Germany_Cars_Cleaned
SET model = 'Rifter'
WHERE brand = 'peugeot'
  AND model LIKE 'Rifter%';
UPDATE Germany_Cars_Cleaned
SET model = 'Traveller'
WHERE brand = 'peugeot'
  AND model LIKE 'Traveller%';
UPDATE Germany_Cars_Cleaned
SET model = 'Camper'
WHERE brand = 'peugeot'
  AND model LIKE 'Camper%';

-- ==================== RENAULT ====================

UPDATE Germany_Cars_Cleaned
SET model = 'Megane'
WHERE brand = 'renault'
  AND (model LIKE 'Megane%' OR model LIKE 'Mégane%');

-- Altele Renault
UPDATE Germany_Cars_Cleaned
SET model = 'Clio'
WHERE brand = 'renault'
  AND model LIKE 'Clio%';
UPDATE Germany_Cars_Cleaned
SET model = 'Captur'
WHERE brand = 'renault'
  AND model LIKE 'Captur%';
UPDATE Germany_Cars_Cleaned
SET model = 'Kadjar'
WHERE brand = 'renault'
  AND model LIKE 'Kadjar%';
UPDATE Germany_Cars_Cleaned
SET model = 'Koleos'
WHERE brand = 'renault'
  AND model LIKE 'Koleos%';
UPDATE Germany_Cars_Cleaned
SET model = 'Scenic'
WHERE brand = 'renault'
  AND (model LIKE 'Scenic%' OR model LIKE 'Grand Scenic%');
UPDATE Germany_Cars_Cleaned
SET model = 'Espace'
WHERE brand = 'renault'
  AND (model LIKE 'Espace%' OR model LIKE 'Grand Espace%');
UPDATE Germany_Cars_Cleaned
SET model = 'Laguna'
WHERE brand = 'renault'
  AND model LIKE 'Laguna%';
UPDATE Germany_Cars_Cleaned
SET model = 'Talisman'
WHERE brand = 'renault'
  AND model LIKE 'Talisman%';
UPDATE Germany_Cars_Cleaned
SET model = 'Twingo'
WHERE brand = 'renault'
  AND model LIKE 'Twingo%';
UPDATE Germany_Cars_Cleaned
SET model = 'ZOE'
WHERE brand = 'renault'
  AND model LIKE 'ZOE%';
UPDATE Germany_Cars_Cleaned
SET model = 'Trafic'
WHERE brand = 'renault'
  AND model LIKE 'Trafic%';
UPDATE Germany_Cars_Cleaned
SET model = 'Master'
WHERE brand = 'renault'
  AND model LIKE 'Master%';
UPDATE Germany_Cars_Cleaned
SET model = 'Kangoo'
WHERE brand = 'renault'
  AND (model LIKE 'Kangoo%');
UPDATE Germany_Cars_Cleaned
SET model = 'Modus'
WHERE brand = 'renault'
  AND (model LIKE 'Modus%' OR model LIKE 'Grand Modus%');
UPDATE Germany_Cars_Cleaned
SET model = 'Austral'
WHERE brand = 'renault'
  AND model LIKE 'Austral%';
UPDATE Germany_Cars_Cleaned
SET model = 'Arkana'
WHERE brand = 'renault'
  AND model LIKE 'Arkana%';
UPDATE Germany_Cars_Cleaned
SET model = 'Alpine A110'
WHERE brand = 'renault'
  AND model LIKE 'Alpine A110%';
UPDATE Germany_Cars_Cleaned
SET model = 'Alaskan'
WHERE brand = 'renault'
  AND model LIKE 'Alaskan%';
UPDATE Germany_Cars_Cleaned
SET model = 'Express'
WHERE brand = 'renault'
  AND model LIKE 'Express%';
UPDATE Germany_Cars_Cleaned
SET model = 'Rapid'
WHERE brand = 'renault'
  AND model LIKE 'Rapid%';
UPDATE Germany_Cars_Cleaned
SET model = 'Twizy'
WHERE brand = 'renault'
  AND model LIKE 'Twizy%';
UPDATE Germany_Cars_Cleaned
SET model = 'Wind'
WHERE brand = 'renault'
  AND model LIKE 'Wind%';
UPDATE Germany_Cars_Cleaned
SET model = 'Vel Satis'
WHERE brand = 'renault'
  AND model LIKE 'Vel Satis%';
UPDATE Germany_Cars_Cleaned
SET model = 'Latitude'
WHERE brand = 'renault'
  AND model LIKE 'Latitude%';
UPDATE Germany_Cars_Cleaned
SET model = 'Mascott'
WHERE brand = 'renault'
  AND model LIKE 'Mascott%';
UPDATE Germany_Cars_Cleaned
SET model = 'R11'
WHERE brand = 'renault'
  AND (model LIKE 'R 11%' OR model = 'R 11');
UPDATE Germany_Cars_Cleaned
SET model = 'R6'
WHERE brand = 'renault'
  AND (model LIKE 'R 6%' OR model = 'R 6');

-- ==================== TOYOTA ====================

UPDATE Germany_Cars_Cleaned
SET model = 'Yaris'
WHERE brand = 'toyota'
  AND (model LIKE 'Yaris%' OR model LIKE 'Yaris Cross%');
UPDATE Germany_Cars_Cleaned
SET model = 'Corolla'
WHERE brand = 'toyota'
  AND model LIKE 'Corolla%';
UPDATE Germany_Cars_Cleaned
SET model = 'Camry'
WHERE brand = 'toyota'
  AND model LIKE 'Camry%';
UPDATE Germany_Cars_Cleaned
SET model = 'Auris'
WHERE brand = 'toyota'
  AND model LIKE 'Auris%';
UPDATE Germany_Cars_Cleaned
SET model = 'Aygo'
WHERE brand = 'toyota'
  AND (model LIKE 'Aygo%' OR model LIKE 'AYGO%');
UPDATE Germany_Cars_Cleaned
SET model = 'RAV4'
WHERE brand = 'toyota'
  AND model LIKE 'RAV%';
UPDATE Germany_Cars_Cleaned
SET model = 'C-HR'
WHERE brand = 'toyota'
  AND model LIKE 'C-HR%';
UPDATE Germany_Cars_Cleaned
SET model = 'Land Cruiser'
WHERE brand = 'toyota'
  AND model LIKE 'Land Cruiser%';
UPDATE Germany_Cars_Cleaned
SET model = 'Hilux'
WHERE brand = 'toyota'
  AND model LIKE 'Hilux%';
UPDATE Germany_Cars_Cleaned
SET model = 'Prius'
WHERE brand = 'toyota'
  AND model LIKE 'Prius%';
UPDATE Germany_Cars_Cleaned
SET model = 'Supra'
WHERE brand = 'toyota'
  AND model LIKE 'Supra%';
UPDATE Germany_Cars_Cleaned
SET model = 'GT86'
WHERE brand = 'toyota'
  AND (model LIKE 'GT86%' OR model LIKE 'GT 86%' OR model LIKE 'GR 86%');
UPDATE Germany_Cars_Cleaned
SET model = 'Highlander'
WHERE brand = 'toyota'
  AND model LIKE 'Highlander%';
UPDATE Germany_Cars_Cleaned
SET model = 'Proace'
WHERE brand = 'toyota'
  AND model LIKE 'Proace%';
UPDATE Germany_Cars_Cleaned
SET model = 'Verso'
WHERE brand = 'toyota'
  AND model LIKE 'Verso%';
UPDATE Germany_Cars_Cleaned
SET model = 'Avensis'
WHERE brand = 'toyota'
  AND model LIKE 'Avensis%';
UPDATE Germany_Cars_Cleaned
SET model = 'bZ4X'
WHERE brand = 'toyota'
  AND model LIKE 'bZ4X%';
UPDATE Germany_Cars_Cleaned
SET model = 'Mirai'
WHERE brand = 'toyota'
  AND model LIKE 'Mirai%';

-- ==================== FORD ====================

UPDATE Germany_Cars_Cleaned
SET model = 'Fiesta'
WHERE brand = 'ford'
  AND model LIKE 'Fiesta%';
UPDATE Germany_Cars_Cleaned
SET model = 'Focus'
WHERE brand = 'ford'
  AND model LIKE 'Focus%';
UPDATE Germany_Cars_Cleaned
SET model = 'Mondeo'
WHERE brand = 'ford'
  AND model LIKE 'Mondeo%';
UPDATE Germany_Cars_Cleaned
SET model = 'Kuga'
WHERE brand = 'ford'
  AND model LIKE 'Kuga%';
UPDATE Germany_Cars_Cleaned
SET model = 'Puma'
WHERE brand = 'ford'
  AND model LIKE 'Puma%';
UPDATE Germany_Cars_Cleaned
SET model = 'EcoSport'
WHERE brand = 'ford'
  AND model LIKE 'EcoSport%';
UPDATE Germany_Cars_Cleaned
SET model = 'Explorer'
WHERE brand = 'ford'
  AND model LIKE 'Explorer%';
UPDATE Germany_Cars_Cleaned
SET model = 'Edge'
WHERE brand = 'ford'
  AND model LIKE 'Edge%';
UPDATE Germany_Cars_Cleaned
SET model = 'Mustang Mach-E'
WHERE brand = 'ford'
  AND model LIKE '%Mach-E%';
UPDATE Germany_Cars_Cleaned
SET model = 'Mustang'
WHERE brand = 'ford'
  AND model LIKE 'Mustang%'
  AND model NOT LIKE '%Mach-E%';
UPDATE Germany_Cars_Cleaned
SET model = 'Galaxy'
WHERE brand = 'ford'
  AND model LIKE 'Galaxy%';
UPDATE Germany_Cars_Cleaned
SET model = 'S-Max'
WHERE brand = 'ford'
  AND model LIKE 'S-Max%';
UPDATE Germany_Cars_Cleaned
SET model = 'C-Max'
WHERE brand = 'ford'
  AND model LIKE 'C-Max%';
UPDATE Germany_Cars_Cleaned
SET model = 'B-Max'
WHERE brand = 'ford'
  AND model LIKE 'B-Max%';
UPDATE Germany_Cars_Cleaned
SET model = 'Ka'
WHERE brand = 'ford'
  AND (model LIKE 'Ka%' OR model LIKE 'Ka+%');
UPDATE Germany_Cars_Cleaned
SET model = 'Ranger'
WHERE brand = 'ford'
  AND model LIKE 'Ranger%';
UPDATE Germany_Cars_Cleaned
SET model = 'Transit'
WHERE brand = 'ford'
  AND model LIKE 'Transit%';
UPDATE Germany_Cars_Cleaned
SET model = 'Tourneo'
WHERE brand = 'ford'
  AND model LIKE 'Tourneo%';

-- ==================== HYUNDAI ====================

UPDATE Germany_Cars_Cleaned
SET model = 'i10'
WHERE brand = 'hyundai'
  AND model LIKE 'i10%';
UPDATE Germany_Cars_Cleaned
SET model = 'i20'
WHERE brand = 'hyundai'
  AND model LIKE 'i20%';
UPDATE Germany_Cars_Cleaned
SET model = 'i30'
WHERE brand = 'hyundai'
  AND model LIKE 'i30%';
UPDATE Germany_Cars_Cleaned
SET model = 'i40'
WHERE brand = 'hyundai'
  AND model LIKE 'i40%';
UPDATE Germany_Cars_Cleaned
SET model = 'Tucson'
WHERE brand = 'hyundai'
  AND model LIKE 'Tucson%';
UPDATE Germany_Cars_Cleaned
SET model = 'Kona'
WHERE brand = 'hyundai'
  AND model LIKE 'Kona%';
UPDATE Germany_Cars_Cleaned
SET model = 'Santa Fe'
WHERE brand = 'hyundai'
  AND model LIKE 'Santa Fe%';
UPDATE Germany_Cars_Cleaned
SET model = 'IONIQ 5'
WHERE brand = 'hyundai'
  AND model LIKE 'IONIQ 5%';
UPDATE Germany_Cars_Cleaned
SET model = 'IONIQ 6'
WHERE brand = 'hyundai'
  AND model LIKE 'IONIQ 6%';
UPDATE Germany_Cars_Cleaned
SET model = 'IONIQ'
WHERE brand = 'hyundai'
  AND model LIKE 'IONIQ%'
  AND model NOT LIKE 'IONIQ 5%'
  AND model NOT LIKE 'IONIQ 6%';
UPDATE Germany_Cars_Cleaned
SET model = 'Bayon'
WHERE brand = 'hyundai'
  AND model LIKE 'Bayon%';
UPDATE Germany_Cars_Cleaned
SET model = 'ix20'
WHERE brand = 'hyundai'
  AND model LIKE 'ix20%';
UPDATE Germany_Cars_Cleaned
SET model = 'ix35'
WHERE brand = 'hyundai'
  AND model LIKE 'ix35%';
UPDATE Germany_Cars_Cleaned
SET model = 'ix55'
WHERE brand = 'hyundai'
  AND model LIKE 'ix55%';
UPDATE Germany_Cars_Cleaned
SET model = 'Veloster'
WHERE brand = 'hyundai'
  AND model LIKE 'Veloster%';
UPDATE Germany_Cars_Cleaned
SET model = 'Genesis'
WHERE brand = 'hyundai'
  AND model LIKE 'Genesis%';
UPDATE Germany_Cars_Cleaned
SET model = 'STARIA'
WHERE brand = 'hyundai'
  AND model LIKE 'STARIA%';

-- ==================== KIA ====================

UPDATE Germany_Cars_Cleaned
SET model = 'Picanto'
WHERE brand = 'kia'
  AND model LIKE 'Picanto%';
UPDATE Germany_Cars_Cleaned
SET model = 'Rio'
WHERE brand = 'kia'
  AND model LIKE 'Rio%';
UPDATE Germany_Cars_Cleaned
SET model = 'Ceed'
WHERE brand = 'kia'
  AND (model LIKE 'Ceed%' OR model LIKE 'cee''d%' OR model LIKE 'Pro Cee%' OR model LIKE 'ProCeed%');
UPDATE Germany_Cars_Cleaned
SET model = 'Sportage'
WHERE brand = 'kia'
  AND model LIKE 'Sportage%';
UPDATE Germany_Cars_Cleaned
SET model = 'Sorento'
WHERE brand = 'kia'
  AND model LIKE 'Sorento%';
UPDATE Germany_Cars_Cleaned
SET model = 'Niro'
WHERE brand = 'kia'
  AND model LIKE 'Niro%';
UPDATE Germany_Cars_Cleaned
SET model = 'EV6'
WHERE brand = 'kia'
  AND model LIKE 'EV6%';
UPDATE Germany_Cars_Cleaned
SET model = 'Stonic'
WHERE brand = 'kia'
  AND model LIKE 'Stonic%';
UPDATE Germany_Cars_Cleaned
SET model = 'XCeed'
WHERE brand = 'kia'
  AND model LIKE 'XCeed%';
UPDATE Germany_Cars_Cleaned
SET model = 'Stinger'
WHERE brand = 'kia'
  AND model LIKE 'Stinger%';
UPDATE Germany_Cars_Cleaned
SET model = 'Optima'
WHERE brand = 'kia'
  AND model LIKE 'Optima%';
UPDATE Germany_Cars_Cleaned
SET model = 'Venga'
WHERE brand = 'kia'
  AND model LIKE 'Venga%';
UPDATE Germany_Cars_Cleaned
SET model = 'Soul'
WHERE brand = 'kia'
  AND model LIKE 'Soul%';
UPDATE Germany_Cars_Cleaned
SET model = 'Carnival'
WHERE brand = 'kia'
  AND model LIKE 'Carnival%';
UPDATE Germany_Cars_Cleaned
SET model = 'Carens'
WHERE brand = 'kia'
  AND model LIKE 'Carens%';

-- ==================== SKODA ====================

UPDATE Germany_Cars_Cleaned
SET model = 'Octavia'
WHERE brand = 'skoda'
  AND model LIKE 'Octavia%';
UPDATE Germany_Cars_Cleaned
SET model = 'Superb'
WHERE brand = 'skoda'
  AND model LIKE 'Superb%';
UPDATE Germany_Cars_Cleaned
SET model = 'Fabia'
WHERE brand = 'skoda'
  AND model LIKE 'Fabia%';
UPDATE Germany_Cars_Cleaned
SET model = 'Kodiaq'
WHERE brand = 'skoda'
  AND model LIKE 'Kodiaq%';
UPDATE Germany_Cars_Cleaned
SET model = 'Karoq'
WHERE brand = 'skoda'
  AND model LIKE 'Karoq%';
UPDATE Germany_Cars_Cleaned
SET model = 'Kamiq'
WHERE brand = 'skoda'
  AND model LIKE 'Kamiq%';
UPDATE Germany_Cars_Cleaned
SET model = 'Scala'
WHERE brand = 'skoda'
  AND model LIKE 'Scala%';
UPDATE Germany_Cars_Cleaned
SET model = 'Rapid'
WHERE brand = 'skoda'
  AND model LIKE 'Rapid%';
UPDATE Germany_Cars_Cleaned
SET model = 'Citigo'
WHERE brand = 'skoda'
  AND model LIKE 'Citigo%';
UPDATE Germany_Cars_Cleaned
SET model = 'Roomster'
WHERE brand = 'skoda'
  AND model LIKE 'Roomster%';
UPDATE Germany_Cars_Cleaned
SET model = 'Yeti'
WHERE brand = 'skoda'
  AND model LIKE 'Yeti%';
UPDATE Germany_Cars_Cleaned
SET model = 'Enyaq'
WHERE brand = 'skoda'
  AND model LIKE 'Enyaq%';

-- ==================== DACIA ====================

UPDATE Germany_Cars_Cleaned
SET model = 'Sandero'
WHERE brand = 'dacia'
  AND model LIKE 'Sandero%';
UPDATE Germany_Cars_Cleaned
SET model = 'Duster'
WHERE brand = 'dacia'
  AND model LIKE 'Duster%';
UPDATE Germany_Cars_Cleaned
SET model = 'Logan'
WHERE brand = 'dacia'
  AND model LIKE 'Logan%';
UPDATE Germany_Cars_Cleaned
SET model = 'Spring'
WHERE brand = 'dacia'
  AND model LIKE 'Spring%';
UPDATE Germany_Cars_Cleaned
SET model = 'Jogger'
WHERE brand = 'dacia'
  AND model LIKE 'Jogger%';
UPDATE Germany_Cars_Cleaned
SET model = 'Dokker'
WHERE brand = 'dacia'
  AND model LIKE 'Dokker%';
UPDATE Germany_Cars_Cleaned
SET model = 'Lodgy'
WHERE brand = 'dacia'
  AND model LIKE 'Lodgy%';

-- ==================== VOLVO ====================

UPDATE Germany_Cars_Cleaned
SET model = 'XC90'
WHERE brand = 'volvo'
  AND model LIKE 'XC90%';
UPDATE Germany_Cars_Cleaned
SET model = 'XC60'
WHERE brand = 'volvo'
  AND model LIKE 'XC60%';
UPDATE Germany_Cars_Cleaned
SET model = 'XC40'
WHERE brand = 'volvo'
  AND model LIKE 'XC40%';
UPDATE Germany_Cars_Cleaned
SET model = 'V90'
WHERE brand = 'volvo'
  AND model LIKE 'V90%';
UPDATE Germany_Cars_Cleaned
SET model = 'V60'
WHERE brand = 'volvo'
  AND model LIKE 'V60%';
UPDATE Germany_Cars_Cleaned
SET model = 'V40'
WHERE brand = 'volvo'
  AND model LIKE 'V40%';
UPDATE Germany_Cars_Cleaned
SET model = 'S90'
WHERE brand = 'volvo'
  AND model LIKE 'S90%';
UPDATE Germany_Cars_Cleaned
SET model = 'S60'
WHERE brand = 'volvo'
  AND model LIKE 'S60%';
UPDATE Germany_Cars_Cleaned
SET model = 'C40'
WHERE brand = 'volvo'
  AND model LIKE 'C40%';
UPDATE Germany_Cars_Cleaned
SET model = 'C30'
WHERE brand = 'volvo'
  AND model LIKE 'C30%';

-- ==================== NISSAN ====================

UPDATE Germany_Cars_Cleaned
SET model = 'Qashqai'
WHERE brand = 'nissan'
  AND model LIKE 'Qashqai%';
UPDATE Germany_Cars_Cleaned
SET model = 'Juke'
WHERE brand = 'nissan'
  AND model LIKE 'Juke%';
UPDATE Germany_Cars_Cleaned
SET model = 'Micra'
WHERE brand = 'nissan'
  AND model LIKE 'Micra%';
UPDATE Germany_Cars_Cleaned
SET model = 'X-Trail'
WHERE brand = 'nissan'
  AND model LIKE 'X-Trail%';
UPDATE Germany_Cars_Cleaned
SET model = 'Leaf'
WHERE brand = 'nissan'
  AND model LIKE 'Leaf%';
UPDATE Germany_Cars_Cleaned
SET model = 'Note'
WHERE brand = 'nissan'
  AND model LIKE 'Note%';
UPDATE Germany_Cars_Cleaned
SET model = 'Navara'
WHERE brand = 'nissan'
  AND model LIKE 'Navara%';
UPDATE Germany_Cars_Cleaned
SET model = 'Pulsar'
WHERE brand = 'nissan'
  AND model LIKE 'Pulsar%';
UPDATE Germany_Cars_Cleaned
SET model = 'GT-R'
WHERE brand = 'nissan'
  AND model LIKE 'GT-R%';
UPDATE Germany_Cars_Cleaned
SET model = '370Z'
WHERE brand = 'nissan'
  AND model LIKE '370Z%';
UPDATE Germany_Cars_Cleaned
SET model = 'Ariya'
WHERE brand = 'nissan'
  AND model LIKE 'Ariya%';
UPDATE Germany_Cars_Cleaned
SET model = 'Townstar'
WHERE brand = 'nissan'
  AND model LIKE 'Townstar%';

-- ==================== HONDA ====================

UPDATE Germany_Cars_Cleaned
SET model = 'Civic'
WHERE brand = 'honda'
  AND model LIKE 'Civic%';
UPDATE Germany_Cars_Cleaned
SET model = 'Jazz'
WHERE brand = 'honda'
  AND model LIKE 'Jazz%';
UPDATE Germany_Cars_Cleaned
SET model = 'CR-V'
WHERE brand = 'honda'
  AND model LIKE 'CR-V%';
UPDATE Germany_Cars_Cleaned
SET model = 'HR-V'
WHERE brand = 'honda'
  AND model LIKE 'HR-V%';
UPDATE Germany_Cars_Cleaned
SET model = 'Accord'
WHERE brand = 'honda'
  AND model LIKE 'Accord%';
UPDATE Germany_Cars_Cleaned
SET model = 'e'
WHERE brand = 'honda'
  AND (model = 'e' OR model LIKE 'Honda e%');
UPDATE Germany_Cars_Cleaned
SET model = 'ZR-V'
WHERE brand = 'honda'
  AND model LIKE 'ZR-V%';

-- ==================== MAZDA ====================

UPDATE Germany_Cars_Cleaned
SET model = 'Mazda3'
WHERE brand = 'mazda'
  AND (model LIKE 'Mazda3%' OR model LIKE '3 %' OR model = '3');
UPDATE Germany_Cars_Cleaned
SET model = 'Mazda2'
WHERE brand = 'mazda'
  AND (model LIKE 'Mazda2%' OR model LIKE '2 %' OR model = '2');
UPDATE Germany_Cars_Cleaned
SET model = 'Mazda6'
WHERE brand = 'mazda'
  AND (model LIKE 'Mazda6%' OR model LIKE '6 %' OR model = '6');
UPDATE Germany_Cars_Cleaned
SET model = 'CX-3'
WHERE brand = 'mazda'
  AND model LIKE 'CX-3%';
UPDATE Germany_Cars_Cleaned
SET model = 'CX-5'
WHERE brand = 'mazda'
  AND model LIKE 'CX-5%';
UPDATE Germany_Cars_Cleaned
SET model = 'CX-30'
WHERE brand = 'mazda'
  AND model LIKE 'CX-30%';
UPDATE Germany_Cars_Cleaned
SET model = 'CX-60'
WHERE brand = 'mazda'
  AND model LIKE 'CX-60%';
UPDATE Germany_Cars_Cleaned
SET model = 'MX-5'
WHERE brand = 'mazda'
  AND model LIKE 'MX-5%';
UPDATE Germany_Cars_Cleaned
SET model = 'MX-30'
WHERE brand = 'mazda'
  AND model LIKE 'MX-30%';

-- ==================== SEAT ====================

UPDATE Germany_Cars_Cleaned
SET model = 'Leon'
WHERE brand = 'seat'
  AND model LIKE 'Leon%';
UPDATE Germany_Cars_Cleaned
SET model = 'Ibiza'
WHERE brand = 'seat'
  AND model LIKE 'Ibiza%';
UPDATE Germany_Cars_Cleaned
SET model = 'Ateca'
WHERE brand = 'seat'
  AND model LIKE 'Ateca%';
UPDATE Germany_Cars_Cleaned
SET model = 'Arona'
WHERE brand = 'seat'
  AND model LIKE 'Arona%';
UPDATE Germany_Cars_Cleaned
SET model = 'Tarraco'
WHERE brand = 'seat'
  AND model LIKE 'Tarraco%';
UPDATE Germany_Cars_Cleaned
SET model = 'Alhambra'
WHERE brand = 'seat'
  AND model LIKE 'Alhambra%';
UPDATE Germany_Cars_Cleaned
SET model = 'Mii'
WHERE brand = 'seat'
  AND model LIKE 'Mii%';
UPDATE Germany_Cars_Cleaned
SET model = 'Toledo'
WHERE brand = 'seat'
  AND model LIKE 'Toledo%';

-- ==================== CITROEN ====================

UPDATE Germany_Cars_Cleaned
SET model = 'C3'
WHERE brand = 'citroen'
  AND model LIKE 'C3%'
  AND model NOT LIKE 'C3 Aircross%';
UPDATE Germany_Cars_Cleaned
SET model = 'C3 Aircross'
WHERE brand = 'citroen'
  AND model LIKE 'C3 Aircross%';
UPDATE Germany_Cars_Cleaned
SET model = 'C4'
WHERE brand = 'citroen'
  AND model LIKE 'C4%'
  AND model NOT LIKE 'C4 Cactus%';
UPDATE Germany_Cars_Cleaned
SET model = 'C4 Cactus'
WHERE brand = 'citroen'
  AND model LIKE 'C4 Cactus%';
UPDATE Germany_Cars_Cleaned
SET model = 'C5'
WHERE brand = 'citroen'
  AND model LIKE 'C5%'
  AND model NOT LIKE 'C5 Aircross%';
UPDATE Germany_Cars_Cleaned
SET model = 'C5 Aircross'
WHERE brand = 'citroen'
  AND model LIKE 'C5 Aircross%';
UPDATE Germany_Cars_Cleaned
SET model = 'C1'
WHERE brand = 'citroen'
  AND model LIKE 'C1%';
UPDATE Germany_Cars_Cleaned
SET model = 'C2'
WHERE brand = 'citroen'
  AND model LIKE 'C2%';
UPDATE Germany_Cars_Cleaned
SET model = 'Berlingo'
WHERE brand = 'citroen'
  AND model LIKE 'Berlingo%';
UPDATE Germany_Cars_Cleaned
SET model = 'DS3'
WHERE brand = 'citroen'
  AND model LIKE 'DS3%';
UPDATE Germany_Cars_Cleaned
SET model = 'DS4'
WHERE brand = 'citroen'
  AND model LIKE 'DS4%';
UPDATE Germany_Cars_Cleaned
SET model = 'DS5'
WHERE brand = 'citroen'
  AND model LIKE 'DS5%';
UPDATE Germany_Cars_Cleaned
SET model = 'DS7'
WHERE brand = 'citroen'
  AND model LIKE 'DS7%';
UPDATE Germany_Cars_Cleaned
SET model = 'SpaceTourer'
WHERE brand = 'citroen'
  AND model LIKE 'SpaceTourer%';
UPDATE Germany_Cars_Cleaned
SET model = 'Jumpy'
WHERE brand = 'citroen'
  AND model LIKE 'Jumpy%';

-- ==================== LAND ROVER ====================

UPDATE Germany_Cars_Cleaned
SET model = 'Range Rover Evoque'
WHERE brand = 'land rover'
  AND model LIKE '%Evoque%';
UPDATE Germany_Cars_Cleaned
SET model = 'Range Rover Sport'
WHERE brand = 'land rover'
  AND model LIKE '%Range Rover Sport%';
UPDATE Germany_Cars_Cleaned
SET model = 'Range Rover Velar'
WHERE brand = 'land rover'
  AND model LIKE '%Velar%';
UPDATE Germany_Cars_Cleaned
SET model = 'Range Rover'
WHERE brand = 'land rover'
  AND model LIKE 'Range Rover%'
  AND model NOT LIKE '%Evoque%'
  AND model NOT LIKE '%Sport%'
  AND model NOT LIKE '%Velar%';
UPDATE Germany_Cars_Cleaned
SET model = 'Discovery Sport'
WHERE brand = 'land rover'
  AND model LIKE 'Discovery Sport%';
UPDATE Germany_Cars_Cleaned
SET model = 'Discovery'
WHERE brand = 'land rover'
  AND model LIKE 'Discovery%'
  AND model NOT LIKE 'Discovery Sport%';
UPDATE Germany_Cars_Cleaned
SET model = 'Defender'
WHERE brand = 'land rover'
  AND model LIKE 'Defender%';
UPDATE Germany_Cars_Cleaned
SET model = 'Freelander'
WHERE brand = 'land rover'
  AND model LIKE 'Freelander%';

-- ==================== CUPRA ====================

UPDATE Germany_Cars_Cleaned
SET model = 'Formentor'
WHERE brand = 'cupra'
  AND model LIKE 'Formentor%';
UPDATE Germany_Cars_Cleaned
SET model = 'Born'
WHERE brand = 'cupra'
  AND model LIKE 'Born%';
UPDATE Germany_Cars_Cleaned
SET model = 'Leon'
WHERE brand = 'cupra'
  AND model LIKE 'Leon%';
UPDATE Germany_Cars_Cleaned
SET model = 'Ateca'
WHERE brand = 'cupra'
  AND model LIKE 'Ateca%';

-- ==================== TESLA ====================

UPDATE Germany_Cars_Cleaned
SET model = 'Model 3'
WHERE brand = 'tesla'
  AND model LIKE 'Model 3%';
UPDATE Germany_Cars_Cleaned
SET model = 'Model Y'
WHERE brand = 'tesla'
  AND model LIKE 'Model Y%';
UPDATE Germany_Cars_Cleaned
SET model = 'Model S'
WHERE brand = 'tesla'
  AND model LIKE 'Model S%';
UPDATE Germany_Cars_Cleaned
SET model = 'Model X'
WHERE brand = 'tesla'
  AND model LIKE 'Model X%';

-- ==================== SUZUKI ====================

UPDATE Germany_Cars_Cleaned
SET model = 'Swift'
WHERE brand = 'suzuki'
  AND model LIKE 'Swift%';
UPDATE Germany_Cars_Cleaned
SET model = 'Vitara'
WHERE brand = 'suzuki'
  AND model LIKE 'Vitara%';
UPDATE Germany_Cars_Cleaned
SET model = 'SX4 S-Cross'
WHERE brand = 'suzuki'
  AND (model LIKE 'SX4 S-Cross%' OR model LIKE 'S-Cross%');
UPDATE Germany_Cars_Cleaned
SET model = 'SX4'
WHERE brand = 'suzuki'
  AND model LIKE 'SX4%'
  AND model NOT LIKE 'SX4 S-Cross%';
UPDATE Germany_Cars_Cleaned
SET model = 'Jimny'
WHERE brand = 'suzuki'
  AND model LIKE 'Jimny%';
UPDATE Germany_Cars_Cleaned
SET model = 'Ignis'
WHERE brand = 'suzuki'
  AND model LIKE 'Ignis%';
UPDATE Germany_Cars_Cleaned
SET model = 'Baleno'
WHERE brand = 'suzuki'
  AND model LIKE 'Baleno%';
UPDATE Germany_Cars_Cleaned
SET model = 'Swace'
WHERE brand = 'suzuki'
  AND model LIKE 'Swace%';
UPDATE Germany_Cars_Cleaned
SET model = 'Across'
WHERE brand = 'suzuki'
  AND model LIKE 'Across%';

-- ==================== MITSUBISHI ====================

UPDATE Germany_Cars_Cleaned
SET model = 'Outlander'
WHERE brand = 'mitsubishi'
  AND model LIKE 'Outlander%';
UPDATE Germany_Cars_Cleaned
SET model = 'ASX'
WHERE brand = 'mitsubishi'
  AND model LIKE 'ASX%';
UPDATE Germany_Cars_Cleaned
SET model = 'Eclipse Cross'
WHERE brand = 'mitsubishi'
  AND model LIKE 'Eclipse Cross%';
UPDATE Germany_Cars_Cleaned
SET model = 'Space Star'
WHERE brand = 'mitsubishi'
  AND model LIKE 'Space Star%';
UPDATE Germany_Cars_Cleaned
SET model = 'L200'
WHERE brand = 'mitsubishi'
  AND model LIKE 'L200%';
UPDATE Germany_Cars_Cleaned
SET model = 'Pajero'
WHERE brand = 'mitsubishi'
  AND model LIKE 'Pajero%';
UPDATE Germany_Cars_Cleaned
SET model = 'Colt'
WHERE brand = 'mitsubishi'
  AND model LIKE 'Colt%';
UPDATE Germany_Cars_Cleaned
SET model = 'Lancer'
WHERE brand = 'mitsubishi'
  AND model LIKE 'Lancer%';

-- ==================== JEEP ====================

UPDATE Germany_Cars_Cleaned
SET model = 'Compass'
WHERE brand = 'jeep'
  AND model LIKE 'Compass%';
UPDATE Germany_Cars_Cleaned
SET model = 'Renegade'
WHERE brand = 'jeep'
  AND model LIKE 'Renegade%';
UPDATE Germany_Cars_Cleaned
SET model = 'Grand Cherokee'
WHERE brand = 'jeep'
  AND model LIKE 'Grand Cherokee%';
UPDATE Germany_Cars_Cleaned
SET model = 'Cherokee'
WHERE brand = 'jeep'
  AND model LIKE 'Cherokee%'
  AND model NOT LIKE 'Grand Cherokee%';
UPDATE Germany_Cars_Cleaned
SET model = 'Wrangler'
WHERE brand = 'jeep'
  AND model LIKE 'Wrangler%';
UPDATE Germany_Cars_Cleaned
SET model = 'Avenger'
WHERE brand = 'jeep'
  AND model LIKE 'Avenger%';

DELETE
FROM Germany_Cars_Cleaned
WHERE TRIM(model) = TRIM(brand);


delete
from Germany_Cars_Cleaned
where Germany_Cars_Cleaned.model is NULL;

-- ============================================================
-- PASUL b: CONVERSIE BRAND LA PROPER CASE
-- Pentru consistenta cross-market (India si SUA sunt deja Proper Case)
-- ============================================================

UPDATE Germany_Cars_Cleaned
SET brand = 'Mercedes-Benz'
WHERE brand = 'mercedes-benz';
UPDATE Germany_Cars_Cleaned
SET brand = 'BMW'
WHERE brand = 'bmw';
UPDATE Germany_Cars_Cleaned
SET brand = 'Audi'
WHERE brand = 'audi';
UPDATE Germany_Cars_Cleaned
SET brand = 'Volkswagen'
WHERE brand = 'volkswagen';
UPDATE Germany_Cars_Cleaned
SET brand = 'Porsche'
WHERE brand = 'porsche';
UPDATE Germany_Cars_Cleaned
SET brand = 'Mini'
WHERE brand = 'mini';
UPDATE Germany_Cars_Cleaned
SET brand = 'Fiat'
WHERE brand = 'fiat';
UPDATE Germany_Cars_Cleaned
SET brand = 'Smart'
WHERE brand = 'smart';
UPDATE Germany_Cars_Cleaned
SET brand = 'Opel'
WHERE brand = 'opel';
UPDATE Germany_Cars_Cleaned
SET brand = 'Peugeot'
WHERE brand = 'peugeot';
UPDATE Germany_Cars_Cleaned
SET brand = 'Renault'
WHERE brand = 'renault';
UPDATE Germany_Cars_Cleaned
SET brand = 'Toyota'
WHERE brand = 'toyota';
UPDATE Germany_Cars_Cleaned
SET brand = 'Ford'
WHERE brand = 'ford';
UPDATE Germany_Cars_Cleaned
SET brand = 'Hyundai'
WHERE brand = 'hyundai';
UPDATE Germany_Cars_Cleaned
SET brand = 'Kia'
WHERE brand = 'kia';
UPDATE Germany_Cars_Cleaned
SET brand = 'Skoda'
WHERE brand = 'skoda';
UPDATE Germany_Cars_Cleaned
SET brand = 'Dacia'
WHERE brand = 'dacia';
UPDATE Germany_Cars_Cleaned
SET brand = 'Volvo'
WHERE brand = 'volvo';
UPDATE Germany_Cars_Cleaned
SET brand = 'Nissan'
WHERE brand = 'nissan';
UPDATE Germany_Cars_Cleaned
SET brand = 'Honda'
WHERE brand = 'honda';
UPDATE Germany_Cars_Cleaned
SET brand = 'Mazda'
WHERE brand = 'mazda';
UPDATE Germany_Cars_Cleaned
SET brand = 'Seat'
WHERE brand = 'seat';
UPDATE Germany_Cars_Cleaned
SET brand = 'Citroen'
WHERE brand = 'citroen';
UPDATE Germany_Cars_Cleaned
SET brand = 'Land Rover'
WHERE brand = 'land rover';
UPDATE Germany_Cars_Cleaned
SET brand = 'Cupra'
WHERE brand = 'cupra';
UPDATE Germany_Cars_Cleaned
SET brand = 'Tesla'
WHERE brand = 'tesla';
UPDATE Germany_Cars_Cleaned
SET brand = 'Suzuki'
WHERE brand = 'suzuki';
UPDATE Germany_Cars_Cleaned
SET brand = 'Mitsubishi'
WHERE brand = 'mitsubishi';
UPDATE Germany_Cars_Cleaned
SET brand = 'Jeep'
WHERE brand = 'jeep';
UPDATE Germany_Cars_Cleaned
SET brand = 'Alfa Romeo'
WHERE brand = 'alfa romeo';
UPDATE Germany_Cars_Cleaned
SET brand = 'Jaguar'
WHERE brand = 'jaguar';
UPDATE Germany_Cars_Cleaned
SET brand = 'Lamborghini'
WHERE brand = 'lamborghini';
UPDATE Germany_Cars_Cleaned
SET brand = 'Maserati'
WHERE brand = 'maserati';
UPDATE Germany_Cars_Cleaned
SET brand = 'Bentley'
WHERE brand = 'bentley';
UPDATE Germany_Cars_Cleaned
SET brand = 'Aston Martin'
WHERE brand = 'aston martin';
UPDATE Germany_Cars_Cleaned
SET brand = 'Ferrari'
WHERE brand = 'ferrari';
UPDATE Germany_Cars_Cleaned
SET brand = 'Lancia'
WHERE brand = 'lancia';
UPDATE Germany_Cars_Cleaned
SET brand = 'Saab'
WHERE brand = 'saab';
UPDATE Germany_Cars_Cleaned
SET brand = 'Dodge'
WHERE brand = 'dodge';
UPDATE Germany_Cars_Cleaned
SET brand = 'Chevrolet'
WHERE brand = 'chevrolet';
UPDATE Germany_Cars_Cleaned
SET brand = 'Cadillac'
WHERE brand = 'cadillac';
UPDATE Germany_Cars_Cleaned
SET brand = 'Daewoo'
WHERE brand = 'daewoo';
UPDATE Germany_Cars_Cleaned
SET brand = 'Infiniti'
WHERE brand = 'infiniti';
UPDATE Germany_Cars_Cleaned
SET brand = 'Ssangyong'
WHERE brand = 'ssangyong';
UPDATE Germany_Cars_Cleaned
SET brand = 'Rover'
WHERE brand = 'rover';
UPDATE Germany_Cars_Cleaned
SET brand = 'Lada'
WHERE brand = 'lada';
UPDATE Germany_Cars_Cleaned
SET brand = 'Daihatsu'
WHERE brand = 'daihatsu';
UPDATE Germany_Cars_Cleaned
SET brand = 'Isuzu'
WHERE brand = 'isuzu';
UPDATE Germany_Cars_Cleaned
SET brand = 'Chrysler'
WHERE brand = 'chrysler';
UPDATE Germany_Cars_Cleaned
SET brand = 'Proton'
WHERE brand = 'proton';



-- Dupa Proper Case, stergem si randurile unde model = brand (ex. "Alfa Romeo"/"Alfa Romeo")
-- Nu au informatii reale despre model; cratime vs spatiu nu mai e problema aici


-- ============================================================
-- PASUL 8: STANDARDIZARE CULORI
-- Mapam culorile din germana si engleza in categorii unificate:
--   Schwarz→Black, Weiß→White, Grau/Anthrazit→Grey, Silber→Silver,
--   Blau→Blue, Rot/Burgundy→Red, Grün→Green, Braun/Bronze→Brown,
--   Gelb→Yellow, Gold, Violett/Lila→Purple, Beige, Orange
-- Culorile rare (sub top 14 ca frecventa) devin 'Unknown'
-- ============================================================

UPDATE Germany_Cars_Cleaned
SET color = 'Unknown'
WHERE color IS NULL;

UPDATE Germany_Cars_Cleaned
SET color = CASE
                WHEN UPPER(color) LIKE '%SCHWARZ%' OR UPPER(color) LIKE '%BLACK%' THEN 'Black'
                WHEN UPPER(color) LIKE '%WEISS%' OR UPPER(color) LIKE '%WEIß%' OR UPPER(color) LIKE '%WHITE%'
                    THEN 'White'
                WHEN UPPER(color) LIKE '%GRAU%' OR UPPER(color) LIKE '%GREY%' OR UPPER(color) LIKE '%GRAY%'
                    OR UPPER(color) LIKE '%ANTHRAZIT%' OR UPPER(color) LIKE '%GRAPHIT%' THEN 'Grey'
                WHEN UPPER(color) LIKE '%SILBER%' OR UPPER(color) LIKE '%SILVER%' THEN 'Silver'
                WHEN UPPER(color) LIKE '%BLAU%' OR UPPER(color) LIKE '%BLUE%' THEN 'Blue'
                WHEN UPPER(color) LIKE '%ROT%' OR UPPER(color) LIKE '%RED%' OR UPPER(color) LIKE '%BURGUNDY%'
                    OR UPPER(color) LIKE '%MAROON%' THEN 'Red'
                WHEN UPPER(color) LIKE '%GRÜN%' OR UPPER(color) LIKE '%GRUN%' OR UPPER(color) LIKE '%GREEN%'
                    THEN 'Green'
                WHEN UPPER(color) LIKE '%BRAUN%' OR UPPER(color) LIKE '%BROWN%' OR UPPER(color) LIKE '%BRONZE%'
                    THEN 'Brown'
                WHEN UPPER(color) LIKE '%BEIGE%' THEN 'Beige'
                WHEN UPPER(color) LIKE '%ORANGE%' THEN 'Orange'
                WHEN UPPER(color) LIKE '%GELB%' OR UPPER(color) LIKE '%YELLOW%' THEN 'Yellow'
                WHEN UPPER(color) LIKE '%GOLD%' THEN 'Gold'
                WHEN UPPER(color) LIKE '%VIOLET%' OR UPPER(color) LIKE '%PURPLE%' OR UPPER(color) LIKE '%LILA%'
                    THEN 'Purple'
                ELSE 'Unknown'
    END
WHERE color <> 'Unknown';

UPDATE Germany_Cars_Cleaned
SET color = 'Unknown'
WHERE color NOT IN (SELECT color
                    FROM Germany_Cars_Cleaned
                    GROUP BY color
                    ORDER BY COUNT(color) DESC
                    LIMIT 13);

-- ============================================================
-- PASUL 9: IMPUTARE CAPACITATE MOTOR LIPSA
-- Strategie in 4 pasi (de la specific la general):
--   1. Media pe brand + model + fuel_type (fereastra ±10 PS)
--   2. Media pe brand + fuel_type (fereastra ±10 PS)
--   3. Media pe fuel_type (fereastra ±10 PS)
--   4. Media pe fuel_type (fara restrictie PS)
-- Excludem vehiculele electrice (nu au cilindree)
-- ============================================================

CREATE INDEX idx_cars_lookup1 ON Germany_Cars_Cleaned (brand, model, fuel_type, power_ps);

UPDATE Germany_Cars_Cleaned
SET engine_type = (SELECT ROUND(AVG(sub.engine_type), 1)
                   FROM Germany_Cars_Cleaned AS sub
                   where sub.power_ps between Germany_Cars_Cleaned.power_ps - 10 and Germany_Cars_Cleaned.power_ps + 10
                     and sub.brand = Germany_Cars_Cleaned.brand
                     AND sub.model = Germany_Cars_Cleaned.model
                     AND sub.fuel_type = Germany_Cars_Cleaned.fuel_type
                     AND sub.engine_type IS NOT NULL
                     and sub.fuel_type <> 'Unknown'
                     and sub.fuel_type <> 'Electric')
WHERE (engine_type IS NULL OR engine_type = 0)
  AND fuel_type <> 'Electric';

drop index idx_cars_lookup1;
CREATE INDEX idx_cars_lookup1 ON Germany_Cars_Cleaned (brand, fuel_type, power_ps);

UPDATE Germany_Cars_Cleaned
SET engine_type = (SELECT ROUND(AVG(sub.engine_type), 1)
                   FROM Germany_Cars_Cleaned AS sub
                   where sub.power_ps between Germany_Cars_Cleaned.power_ps - 10 and Germany_Cars_Cleaned.power_ps + 10
                     and sub.brand = Germany_Cars_Cleaned.brand
                     AND sub.fuel_type = Germany_Cars_Cleaned.fuel_type
                     AND sub.engine_type IS NOT NULL
                     and sub.fuel_type <> 'Unknown'
                     and sub.fuel_type <> 'Electric')
WHERE (engine_type IS NULL OR engine_type = 0)
  AND fuel_type <> 'Electric';

drop index idx_cars_lookup1;
CREATE INDEX idx_cars_lookup1 ON Germany_Cars_Cleaned (fuel_type, power_ps);

UPDATE Germany_Cars_Cleaned
SET engine_type = (SELECT ROUND(AVG(sub.engine_type), 1)
                   FROM Germany_Cars_Cleaned AS sub
                   WHERE sub.fuel_type = Germany_Cars_Cleaned.fuel_type
                     AND sub.power_ps BETWEEN Germany_Cars_Cleaned.power_ps - 10 AND Germany_Cars_Cleaned.power_ps + 10
                     AND sub.engine_type IS NOT NULL
                     and sub.fuel_type <> 'Electric')
WHERE (engine_type IS NULL OR engine_type = 0)
  AND fuel_type <> 'Electric';

drop index idx_cars_lookup1;
CREATE INDEX idx_cars_lookup1 ON Germany_Cars_Cleaned (fuel_type);

UPDATE Germany_Cars_Cleaned
SET engine_type = (SELECT ROUND(AVG(sub.engine_type), 1)
                   FROM Germany_Cars_Cleaned AS sub
                   where sub.fuel_type = Germany_Cars_Cleaned.fuel_type)
WHERE (engine_type IS NULL OR engine_type = 0)
  AND fuel_type <> 'Electric';

-- ============================================================
-- PASUL 9b: IMPUTARE CO2 LIPSA
-- Strategie in 3 pasi (de la specific la general):
--   1. Media pe brand + model + fuel_type (fereastra ±10 PS)
--   2. Media pe brand + fuel_type (fereastra ±10 PS)
--   3. Media pe fuel_type (fara restrictie PS)
-- Excludem vehiculele electrice (co2 = 0 prin definitie)
-- ============================================================

UPDATE Germany_Cars_Cleaned
SET co2_g = NULL
WHERE fuel_type = 'Electric';

drop index idx_cars_lookup1;
CREATE INDEX idx_cars_lookup1 ON Germany_Cars_Cleaned (brand, model, fuel_type, power_ps);

UPDATE Germany_Cars_Cleaned
SET co2_g = (SELECT ROUND(AVG(sub.co2_g), 0)
             FROM Germany_Cars_Cleaned AS sub
             WHERE sub.brand = Germany_Cars_Cleaned.brand
               AND sub.model = Germany_Cars_Cleaned.model
               AND sub.fuel_type = Germany_Cars_Cleaned.fuel_type
               AND sub.power_ps BETWEEN Germany_Cars_Cleaned.power_ps - 10 AND Germany_Cars_Cleaned.power_ps + 10
               AND sub.co2_g IS NOT NULL
               and sub.fuel_type <> 'Unknown'
               AND sub.fuel_type <> 'Electric')
WHERE co2_g IS NULL
  AND fuel_type <> 'Electric';

drop index idx_cars_lookup1;
CREATE INDEX idx_cars_lookup1 ON Germany_Cars_Cleaned (brand, fuel_type, power_ps);

UPDATE Germany_Cars_Cleaned
SET co2_g = (SELECT ROUND(AVG(sub.co2_g), 0)
             FROM Germany_Cars_Cleaned AS sub
             WHERE sub.brand = Germany_Cars_Cleaned.brand
               AND sub.fuel_type = Germany_Cars_Cleaned.fuel_type
               AND sub.power_ps BETWEEN Germany_Cars_Cleaned.power_ps - 10 AND Germany_Cars_Cleaned.power_ps + 10
               AND sub.co2_g IS NOT NULL
               and sub.fuel_type <> 'Unknown'
               AND sub.fuel_type <> 'Electric')
WHERE co2_g IS NULL
  AND fuel_type <> 'Electric';

drop index idx_cars_lookup1;
CREATE INDEX idx_cars_lookup1 ON Germany_Cars_Cleaned (fuel_type);

UPDATE Germany_Cars_Cleaned
SET co2_g = (SELECT ROUND(AVG(sub.co2_g), 0)
             FROM Germany_Cars_Cleaned AS sub
             WHERE sub.fuel_type = Germany_Cars_Cleaned.fuel_type
               AND sub.co2_g IS NOT NULL
               AND sub.fuel_type <> 'Electric')
WHERE co2_g IS NULL
  AND fuel_type <> 'Electric';


drop index idx_cars_lookup1;

-- ============================================================
-- PASUL 9c: IMPUTARE CONSUM COMBUSTIBIL LIPSA
-- Strategie in 4 pasi (de la specific la general):
--   1. Media pe brand + model + fuel_type + transmission_type (fereastra ±2 ani)
--   2. Media pe brand + fuel_type + transmission_type (fereastra ±10 PS)
--   3. Media pe fuel_type (fereastra ±0.4L engine)
--   4. Media pe fuel_type (fallback global)
-- Excludem vehiculele electrice (consum = 0 prin definitie)
-- ============================================================

UPDATE Germany_Cars_Cleaned
SET fuel_consumption_l_100km = NULL
WHERE fuel_type = 'Electric';

CREATE INDEX idx_cars_lookup1 ON Germany_Cars_Cleaned (brand, model, fuel_type, transmission_type, year);

UPDATE Germany_Cars_Cleaned
SET fuel_consumption_l_100km = (SELECT ROUND(AVG(sub.fuel_consumption_l_100km), 1)
                                FROM Germany_Cars_Cleaned AS sub
                                WHERE sub.brand = Germany_Cars_Cleaned.brand
                                  AND sub.model = Germany_Cars_Cleaned.model
                                  AND sub.fuel_type = Germany_Cars_Cleaned.fuel_type
                                  AND sub.transmission_type = Germany_Cars_Cleaned.transmission_type
                                  AND sub.year BETWEEN Germany_Cars_Cleaned.year - 2 AND Germany_Cars_Cleaned.year + 2
                                  AND sub.fuel_consumption_l_100km IS NOT NULL
                                  and sub.fuel_type <> 'Unknown'
                                  AND sub.fuel_type <> 'Electric'
                                  AND sub.transmission_type <> 'Unknown')
WHERE (fuel_consumption_l_100km IS NULL OR fuel_consumption_l_100km = 0)
  AND fuel_type <> 'Electric';

drop index idx_cars_lookup1;
CREATE INDEX idx_cars_lookup1 ON Germany_Cars_Cleaned (brand, fuel_type, transmission_type, power_ps);

UPDATE Germany_Cars_Cleaned
SET fuel_consumption_l_100km = (SELECT ROUND(AVG(sub.fuel_consumption_l_100km), 1)
                                FROM Germany_Cars_Cleaned AS sub
                                WHERE sub.brand = Germany_Cars_Cleaned.brand
                                  AND sub.fuel_type = Germany_Cars_Cleaned.fuel_type
                                  AND sub.transmission_type = Germany_Cars_Cleaned.transmission_type
                                  AND sub.power_ps BETWEEN Germany_Cars_Cleaned.power_ps - 10 AND Germany_Cars_Cleaned.power_ps + 10
                                  AND sub.fuel_consumption_l_100km IS NOT NULL
                                  AND sub.fuel_type <> 'Electric'
                                  and sub.fuel_type <> 'Unknown'
                                  AND sub.transmission_type <> 'Unknown')
WHERE (fuel_consumption_l_100km IS NULL OR fuel_consumption_l_100km = 0)
  AND fuel_type <> 'Electric';

drop index idx_cars_lookup1;
CREATE INDEX idx_cars_lookup1 ON Germany_Cars_Cleaned (fuel_type, engine_type);

UPDATE Germany_Cars_Cleaned
SET fuel_consumption_l_100km = (SELECT ROUND(AVG(sub.fuel_consumption_l_100km), 1)
                                FROM Germany_Cars_Cleaned AS sub
                                WHERE sub.fuel_type = Germany_Cars_Cleaned.fuel_type
                                  AND sub.engine_type BETWEEN Germany_Cars_Cleaned.engine_type - 0.4 AND Germany_Cars_Cleaned.engine_type + 0.4
                                  AND sub.fuel_consumption_l_100km IS NOT NULL
                                  AND sub.fuel_type <> 'Electric')
WHERE (fuel_consumption_l_100km IS NULL OR fuel_consumption_l_100km = 0)
  AND fuel_type <> 'Electric';

drop index idx_cars_lookup1;
CREATE INDEX idx_cars_lookup1 ON Germany_Cars_Cleaned (fuel_type);

UPDATE Germany_Cars_Cleaned
SET fuel_consumption_l_100km = (SELECT ROUND(AVG(sub.fuel_consumption_l_100km), 1)
                                FROM Germany_Cars_Cleaned AS sub
                                WHERE sub.fuel_type = Germany_Cars_Cleaned.fuel_type
                                  AND sub.fuel_consumption_l_100km IS NOT NULL
                                  AND sub.fuel_type <> 'Electric')
WHERE (fuel_consumption_l_100km IS NULL OR fuel_consumption_l_100km = 0)
  AND fuel_type <> 'Electric';

drop index idx_cars_lookup1;

-- ============================================================
-- PASUL 10: DEDUPLICARE
-- Pastram doar primul rand din fiecare grup de duplicate
-- ============================================================

delete
from Germany_Cars_Cleaned
where id not in (SELECT MIN(id)
                 FROM Germany_Cars_Cleaned
                 GROUP BY brand, model, color, year, price_in_euro, power_ps, transmission_type, fuel_type, km,
                          engine_type, co2_g);


-- ============================================================
-- PASUL 11: VERIFICARE FINALA
-- Numar total de randuri dupa curatare
-- ============================================================

select count(*)
from Germany_Cars_Cleaned;

select fuel_type, count(*)
from Germany_Cars_Cleaned
group by fuel_type