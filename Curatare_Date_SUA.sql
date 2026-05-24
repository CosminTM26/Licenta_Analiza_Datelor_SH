-- ============================================================
-- SCRIPT CURATARE DATE: Piata auto SH din SUA
-- Sursa: tabel SUA_Cars (date brute din dataset)
-- Rezultat: tabel SUA_Cars_Cleaned cu date standardizate
-- Pasi: creare tabel (conversii USD→EUR, mile→km, mpg→l/100km) →
--       engine_type (text → litri) → separare Electric →
--       eliminare invalide → brand → modele → corectii modele →
--       culori → transmisie → combustibil → tractiune → one_owner →
--       imputare engine + consum → deduplicare →
--       brand Proper Case → eliminare outlieri → verificare
-- ============================================================

-- ============================================================
-- PASUL 0: CREARE TABEL CURATAT
-- Selectam coloanele relevante si le redenumim uniform
-- ============================================================
drop table if exists SUA_Cars_Cleaned;
create table SUA_Cars_Cleaned as
select manufacturer   as brand,
       model,
       exterior_color as color,
       (year)         as year,
       price          as price_in_euro,
       transmission   as transmission_type,
       fuel_type,
       mileage        as km,
       engine         as engine_type,
       drivetrain,
       one_owner,
       mpg,
       accidents_or_damage
from SUA_Cars;



-- ============================================================
-- PASUL 1: STANDARDIZARE CAPACITATE MOTOR (engine_type)
-- Extragem capacitatea cilindrica (litri) din textul liber
-- Pattern-uri: "2.0L", "2.0 L", "Electric Motor", etc.
-- ============================================================
UPDATE SUA_Cars_Cleaned
SET engine_type = CASE


    -- ===== Electric / fara motor termic =====
                      WHEN engine_type LIKE '%Electric Motor%' THEN 'Electric'
                      WHEN engine_type LIKE '%AC Permanent Magnet%' THEN 'Electric'
                      WHEN engine_type LIKE '%AC Induction%' THEN 'Electric'
                      WHEN engine_type LIKE '%AC induction%' THEN 'Electric'
                      WHEN engine_type LIKE '%Battery%' THEN 'Electric'
                      WHEN engine_type LIKE '%Electric%' THEN 'Electric'
                      WHEN engine_type LIKE '%ZEV%' THEN 'Electric'
                      WHEN engine_type LIKE '% kW%' THEN 'Electric'
                      WHEN engine_type LIKE '% KW%' THEN 'Electric'
                      WHEN engine_type LIKE '%kW %' THEN 'Electric'

    -- ===== Sub 1.0L =====
                      WHEN engine_type LIKE '%0.65L%' THEN '0.65'
                      WHEN engine_type LIKE '%0.8L%' THEN '0.8'
                      WHEN engine_type LIKE '%0.8 L%' THEN '0.8'
                      WHEN engine_type LIKE '%0.9L%' THEN '0.9'
                      WHEN engine_type LIKE '%0.9 L%' THEN '0.9'

    -- ===== 1.0L =====
                      WHEN engine_type LIKE '%1.0L%' THEN '1.0'
                      WHEN engine_type LIKE '%1.0 L%' THEN '1.0'

    -- ===== 1.1L =====
                      WHEN engine_type LIKE '%1.1L%' THEN '1.1'
                      WHEN engine_type LIKE '%1.1 L%' THEN '1.1'

    -- ===== 1.2L =====
                      WHEN engine_type LIKE '%1.2L%' THEN '1.2'
                      WHEN engine_type LIKE '%1.2 L%' THEN '1.2'

    -- ===== 1.3L =====
                      WHEN engine_type LIKE '%1.3L%' THEN '1.3'
                      WHEN engine_type LIKE '%1.3 L%' THEN '1.3'

    -- ===== 1.4L =====
                      WHEN engine_type LIKE '%1.4L%' THEN '1.4'
                      WHEN engine_type LIKE '%1.4 L%' THEN '1.4'

    -- ===== 1.5L =====
                      WHEN engine_type LIKE '%1.5L%' THEN '1.5'
                      WHEN engine_type LIKE '%1.5 L%' THEN '1.5'

    -- ===== 1.6L =====
                      WHEN engine_type LIKE '%1.6L%' THEN '1.6'
                      WHEN engine_type LIKE '%1.6 L%' THEN '1.6'

    -- ===== 1.7L =====
                      WHEN engine_type LIKE '%1.79L%' THEN '1.8' -- varianta atipica
                      WHEN engine_type LIKE '%1.7L%' THEN '1.7'
                      WHEN engine_type LIKE '%1.7 L%' THEN '1.7'

    -- ===== 1.8L =====
                      WHEN engine_type LIKE '%1.8L%' THEN '1.8'
                      WHEN engine_type LIKE '%1.8 L%' THEN '1.8'

    -- ===== 1.9L =====
                      WHEN engine_type LIKE '%1.99L%' THEN '2.0' -- varianta atipica
                      WHEN engine_type LIKE '%1.9L%' THEN '1.9'
                      WHEN engine_type LIKE '%1.9 L%' THEN '1.9'

    -- ===== 2.0L =====
                      WHEN engine_type LIKE '%2.0L%' THEN '2.0'
                      WHEN engine_type LIKE '%2.0 L%' THEN '2.0'
                      WHEN engine_type LIKE '%2L %' THEN '2.0' -- ex: "MultiAir 2L I-4"

    -- ===== 2.1L =====
                      WHEN engine_type LIKE '%2.1L%' THEN '2.1'
                      WHEN engine_type LIKE '%2.1 L%' THEN '2.1'

    -- ===== 2.2L =====
                      WHEN engine_type LIKE '%2.25L%' THEN '2.2' -- varianta atipica
                      WHEN engine_type LIKE '%2.2L%' THEN '2.2'
                      WHEN engine_type LIKE '%2.2 L%' THEN '2.2'

    -- ===== 2.3L =====
                      WHEN engine_type LIKE '%2.3L%' THEN '2.3'
                      WHEN engine_type LIKE '%2.3 L%' THEN '2.3'

    -- ===== 2.4L =====
                      WHEN engine_type LIKE '%2.4L%' THEN '2.4'
                      WHEN engine_type LIKE '%2.4 L%' THEN '2.4'

    -- ===== 2.5L =====
                      WHEN engine_type LIKE '%2.5L%' THEN '2.5'
                      WHEN engine_type LIKE '%2.5 L%' THEN '2.5'

    -- ===== 2.6L =====
                      WHEN engine_type LIKE '%2.6L%' THEN '2.6'
                      WHEN engine_type LIKE '%2.6 L%' THEN '2.6'

    -- ===== 2.7L =====
                      WHEN engine_type LIKE '%2.7L%' THEN '2.7'
                      WHEN engine_type LIKE '%2.7 L%' THEN '2.7'

    -- ===== 2.8L =====
                      WHEN engine_type LIKE '%2.8L%' THEN '2.8'
                      WHEN engine_type LIKE '%2.8 L%' THEN '2.8'

    -- ===== 2.9L =====
                      WHEN engine_type LIKE '%2.9L%' THEN '2.9'
                      WHEN engine_type LIKE '%2.9 L%' THEN '2.9'

    -- ===== 3.0L =====
                      WHEN engine_type LIKE '%3.0L%' THEN '3.0'
                      WHEN engine_type LIKE '%3.0 L%' THEN '3.0'

    -- ===== 3.1L =====
                      WHEN engine_type LIKE '%3.1L%' THEN '3.1'
                      WHEN engine_type LIKE '%3.1 L%' THEN '3.1'

    -- ===== 3.2L =====
                      WHEN engine_type LIKE '%3.2L%' THEN '3.2'
                      WHEN engine_type LIKE '%3.2 L%' THEN '3.2'

    -- ===== 3.3L =====
                      WHEN engine_type LIKE '%3.3L%' THEN '3.3'
                      WHEN engine_type LIKE '%3.3 L%' THEN '3.3'

    -- ===== 3.4L =====
                      WHEN engine_type LIKE '%3.4L%' THEN '3.4'
                      WHEN engine_type LIKE '%3.4 L%' THEN '3.4'

    -- ===== 3.5L =====
                      WHEN engine_type LIKE '%3.5L%' THEN '3.5'
                      WHEN engine_type LIKE '%3.5 L%' THEN '3.5'

    -- ===== 3.6L =====
                      WHEN engine_type LIKE '%3.6L%' THEN '3.6'
                      WHEN engine_type LIKE '%3.6 L%' THEN '3.6'

    -- ===== 3.7L =====
                      WHEN engine_type LIKE '%3.7L%' THEN '3.7'
                      WHEN engine_type LIKE '%3.7 L%' THEN '3.7'

    -- ===== 3.8L =====
                      WHEN engine_type LIKE '%3.8L%' THEN '3.8'
                      WHEN engine_type LIKE '%3.8 L%' THEN '3.8'

    -- ===== 3.9L =====
                      WHEN engine_type LIKE '%3.9L%' THEN '3.9'
                      WHEN engine_type LIKE '%3.9 L%' THEN '3.9'

    -- ===== 4.0L =====
                      WHEN engine_type LIKE '%4.0L%' THEN '4.0'
                      WHEN engine_type LIKE '%4.0 L%' THEN '4.0'

    -- ===== 4.2L =====
                      WHEN engine_type LIKE '%4.2L%' THEN '4.2'
                      WHEN engine_type LIKE '%4.2 L%' THEN '4.2'

    -- ===== 4.3L =====
                      WHEN engine_type LIKE '%4.3L%' THEN '4.3'
                      WHEN engine_type LIKE '%4.3 L%' THEN '4.3'

    -- ===== 4.4L =====
                      WHEN engine_type LIKE '%4.4L%' THEN '4.4'
                      WHEN engine_type LIKE '%4.4 L%' THEN '4.4'

    -- ===== 4.5L =====
                      WHEN engine_type LIKE '%4.5L%' THEN '4.5'
                      WHEN engine_type LIKE '%4.5 L%' THEN '4.5'

    -- ===== 4.6L =====
                      WHEN engine_type LIKE '%4.6L%' THEN '4.6'
                      WHEN engine_type LIKE '%4.6 L%' THEN '4.6'

    -- ===== 4.7L =====
                      WHEN engine_type LIKE '%4.7L%' THEN '4.7'
                      WHEN engine_type LIKE '%4.7 L%' THEN '4.7'

    -- ===== 4.8L =====
                      WHEN engine_type LIKE '%4.8L%' THEN '4.8'
                      WHEN engine_type LIKE '%4.8 L%' THEN '4.8'

    -- ===== 4.9L =====
                      WHEN engine_type LIKE '%4.9L%' THEN '4.9'
                      WHEN engine_type LIKE '%4.9 L%' THEN '4.9'

    -- ===== 5.0L =====
                      WHEN engine_type LIKE '%5.0L%' THEN '5.0'
                      WHEN engine_type LIKE '%5.0 L%' THEN '5.0'

    -- ===== 5.2L =====
                      WHEN engine_type LIKE '%5.2L%' THEN '5.2'
                      WHEN engine_type LIKE '%5.2 L%' THEN '5.2'

    -- ===== 5.3L =====
                      WHEN engine_type LIKE '%5.3L%' THEN '5.3'
                      WHEN engine_type LIKE '%5.3 L%' THEN '5.3'

    -- ===== 5.4L =====
                      WHEN engine_type LIKE '%5.4L%' THEN '5.4'
                      WHEN engine_type LIKE '%5.4 L%' THEN '5.4'

    -- ===== 5.5L =====
                      WHEN engine_type LIKE '%5.5L%' THEN '5.5'
                      WHEN engine_type LIKE '%5.5 L%' THEN '5.5'

    -- ===== 5.6L =====
                      WHEN engine_type LIKE '%5.6L%' THEN '5.6'
                      WHEN engine_type LIKE '%5.6 L%' THEN '5.6'

    -- ===== 5.7L =====
                      WHEN engine_type LIKE '%5.7L%' THEN '5.7'
                      WHEN engine_type LIKE '%5.7 L%' THEN '5.7'

    -- ===== 5.8L =====
                      WHEN engine_type LIKE '%5.8L%' THEN '5.8'
                      WHEN engine_type LIKE '%5.8 L%' THEN '5.8'

    -- ===== 5.9L =====
                      WHEN engine_type LIKE '%5.9L%' THEN '5.9'
                      WHEN engine_type LIKE '%5.9 L%' THEN '5.9'

    -- ===== 6.0L =====
                      WHEN engine_type LIKE '%6.0L%' THEN '6.0'
                      WHEN engine_type LIKE '%6.0 L%' THEN '6.0'

    -- ===== 6.1L =====
                      WHEN engine_type LIKE '%6.1L%' THEN '6.1'
                      WHEN engine_type LIKE '%6.1 L%' THEN '6.1'

    -- ===== 6.2L =====
                      WHEN engine_type LIKE '%6.2L%' THEN '6.2'
                      WHEN engine_type LIKE '%6.2 L%' THEN '6.2'

    -- ===== 6.4L =====
                      WHEN engine_type LIKE '%6.4L%' THEN '6.4'
                      WHEN engine_type LIKE '%6.4 L%' THEN '6.4'

    -- ===== 6.5L =====
                      WHEN engine_type LIKE '%6.5L%' THEN '6.5'
                      WHEN engine_type LIKE '%6.5 L%' THEN '6.5'

    -- ===== 6.6L =====
                      WHEN engine_type LIKE '%6.6L%' THEN '6.6'
                      WHEN engine_type LIKE '%6.6 L%' THEN '6.6'

    -- ===== 6.7L =====
                      WHEN engine_type LIKE '%6.7L%' THEN '6.7'
                      WHEN engine_type LIKE '%6.7 L%' THEN '6.7'

    -- ===== 6.8L =====
                      WHEN engine_type LIKE '%6.8L%' THEN '6.8'
                      WHEN engine_type LIKE '%6.8 L%' THEN '6.8'

    -- ===== 7.0L =====
                      WHEN engine_type LIKE '%7.0L%' THEN '7.0'
                      WHEN engine_type LIKE '%7.0 L%' THEN '7.0'

    -- ===== 7.3L — Power Stroke Diesel =====
                      WHEN engine_type LIKE '%7.3L%' THEN '7.3'
                      WHEN engine_type LIKE '%7.3 L%' THEN '7.3'

    -- ===== 7.4L =====
                      WHEN engine_type LIKE '%7.4L%' THEN '7.4'
                      WHEN engine_type LIKE '%7.4 L%' THEN '7.4'

    -- ===== 8.0L / V10 Viper =====
                      WHEN engine_type LIKE '%8L V-10%' THEN '8.0'
                      WHEN engine_type LIKE '%8.0L%' THEN '8.0'
                      WHEN engine_type LIKE '%8.0 L%' THEN '8.0'

    -- ===== 8.4L — Viper V10 =====
                      WHEN engine_type LIKE '%8.4L%' THEN '8.4'
                      WHEN engine_type LIKE '%8.4 L%' THEN '8.4'

                      ELSE NULL
    END;

-- ============================================================
-- PASUL 2: SEPARARE VEHICULE ELECTRICE
-- Mutam "Electric" din engine_type in fuel_type (nu au cilindree)
-- ============================================================
update SUA_Cars_Cleaned
set fuel_type='Electric'
where engine_type = 'Electric';

update SUA_Cars_Cleaned
set engine_type=null
where engine_type = 'Electric';

-- ============================================================
-- PASUL 3: ELIMINARE RANDURI INVALIDE
-- Stergem randuri fara km, cu pret invalid sau an imposibil
-- ============================================================
delete
from SUA_Cars_Cleaned
where km is null;

delete
from SUA_Cars_Cleaned
where price_in_euro is null
   or price_in_euro <= 0;

delete
from SUA_Cars_Cleaned
where year is null
   or year not between 1900 and 2026;

-- ============================================================
-- PASUL 4: CONVERSIE UNITATI SI TIPURI DE DATE
-- Pret: USD -> EUR (curs: 1 USD = 0.9241 EUR)
-- Kilometraj: mile -> km (1 milă = 1.609344 km)
-- Consum: mpg -> l/100km (formula: 235.21 / mpg; NULL pentru Electric)
-- Rotunjire la sute pentru valori curate
-- ============================================================
alter table SUA_Cars_Cleaned
    add column id integer;

update SUA_Cars_Cleaned
set id=ROWID;

drop table if exists schimb;
alter table SUA_Cars_Cleaned
    rename to schimb;

drop table if exists SUA_Cars_Cleaned;
create table SUA_Cars_Cleaned
(
    id                       integer,
    brand                    text,
    model                    text,
    color                    text,
    year                     integer,
    price_in_euro            integer,
    transmission_type        text,
    fuel_type                text,
    km                       integer,
    engine_type              double,
    drivetrain               text,
    one_owner                text,
    fuel_consumption_l_100km real
);

insert into SUA_Cars_Cleaned
select id,
       brand,
       model,
       color,
       cast((year) as integer)                              as year,
       cast(round((price_in_euro * 0.9241), -2) as integer) as price_in_euro,
       transmission_type,
       fuel_type,
       cast(round((km * 1.609344), -2) as integer)          as km,
       cast((engine_type) as double)                        as engine_type,
       drivetrain,
       one_owner,
       CASE
           WHEN mpg IS NULL OR mpg = '' OR mpg = '0' OR mpg = '0-0' THEN NULL
           WHEN INSTR(mpg, '-') > 0 THEN
               CASE
                   WHEN CAST(SUBSTR(mpg, 1, INSTR(mpg, '-') - 1) AS REAL) > 0
                       AND CAST(SUBSTR(mpg, INSTR(mpg, '-') + 1) AS REAL) > 0 THEN
                       ROUND(235.21 / ((CAST(SUBSTR(mpg, 1, INSTR(mpg, '-') - 1) AS REAL) +
                                        CAST(SUBSTR(mpg, INSTR(mpg, '-') + 1) AS REAL)) / 2.0), 1)
                   WHEN CAST(SUBSTR(mpg, 1, INSTR(mpg, '-') - 1) AS REAL) > 0 THEN
                       ROUND(235.21 / CAST(SUBSTR(mpg, 1, INSTR(mpg, '-') - 1) AS REAL), 1)
                   WHEN CAST(SUBSTR(mpg, INSTR(mpg, '-') + 1) AS REAL) > 0 THEN
                       ROUND(235.21 / CAST(SUBSTR(mpg, INSTR(mpg, '-') + 1) AS REAL), 1)
                   ELSE NULL
                   END
           ELSE
               CASE
                   WHEN CAST(mpg AS REAL) > 0 THEN ROUND(235.21 / CAST(mpg AS REAL), 1)
                   ELSE NULL
                   END
           END                                              as fuel_consumption_l_100km
from schimb;

drop table if exists schimb;

-- ============================================================
-- PASUL 4b: STANDARDIZARE BRAND
-- Trim si corectii de casing pentru consistenta
-- ============================================================

UPDATE SUA_Cars_Cleaned
SET brand = TRIM(brand);

UPDATE SUA_Cars_Cleaned
SET brand = 'Mercedes-Benz'
WHERE UPPER(brand) LIKE '%MERCEDES%';

UPDATE SUA_Cars_Cleaned
SET brand = 'BMW'
WHERE UPPER(brand) = 'BMW';

UPDATE SUA_Cars_Cleaned
SET brand = 'Land Rover'
WHERE UPPER(brand) LIKE '%LAND ROVER%';

UPDATE SUA_Cars_Cleaned
SET brand = 'Ram'
WHERE UPPER(brand) = 'RAM';

UPDATE SUA_Cars_Cleaned
SET brand = 'Infiniti'
WHERE UPPER(brand) = 'INFINITI';

-- ============================================================
-- PASUL 5: STANDARDIZARE NUME MODELE (per brand)
-- Eliminam variantele de echipare/motor din numele modelului
-- Regula: variantele mai specifice se proceseaza PRIMELE
-- (ex: "330e" inainte de "330", "X5 M" inainte de "X5")
-- ============================================================

-- ==================== VOLVO ====================
UPDATE SUA_Cars_Cleaned
SET model = '240'
WHERE model LIKE '%240%';
UPDATE SUA_Cars_Cleaned
SET model = 'C30'
WHERE model LIKE '%C30%';
UPDATE SUA_Cars_Cleaned
SET model = 'C40'
WHERE model LIKE 'C40%';
UPDATE SUA_Cars_Cleaned
SET model = 'C70'
WHERE model LIKE 'C70%';
UPDATE SUA_Cars_Cleaned
SET model = 'S40'
WHERE model LIKE 'S40%';
UPDATE SUA_Cars_Cleaned
SET model = 'S60'
WHERE model LIKE 'S60%';
UPDATE SUA_Cars_Cleaned
SET model = 'S70'
WHERE model LIKE 'S70%';
UPDATE SUA_Cars_Cleaned
SET model = 'S80'
WHERE model LIKE 'S80%';
UPDATE SUA_Cars_Cleaned
SET model = 'S90'
WHERE model LIKE 'S90%';
UPDATE SUA_Cars_Cleaned
SET model = 'V40'
WHERE model LIKE 'V40%';
UPDATE SUA_Cars_Cleaned
SET model = 'V50'
WHERE model LIKE 'V50%';
UPDATE SUA_Cars_Cleaned
SET model = '740'
WHERE model LIKE '740%'
  AND brand = 'Volvo';
UPDATE SUA_Cars_Cleaned
SET model = 'S60 Cross Country'
WHERE model LIKE 'S60 Cross Country%'
  AND brand = 'Volvo';
UPDATE SUA_Cars_Cleaned
SET model = 'S60'
WHERE model LIKE 'S60%'
  AND model NOT LIKE 'S60 Cross Country%'
  AND brand = 'Volvo';
UPDATE SUA_Cars_Cleaned
SET model = 'V60 Cross Country'
WHERE model LIKE 'V60 Cross Country%'
  AND brand = 'Volvo';
UPDATE SUA_Cars_Cleaned
SET model = 'V60'
WHERE model LIKE 'V60%'
  AND model NOT LIKE 'V60 Cross Country%'
  AND brand = 'Volvo';
UPDATE SUA_Cars_Cleaned
SET model = 'V70'
WHERE model LIKE 'V70%'
  AND brand = 'Volvo';
UPDATE SUA_Cars_Cleaned
SET model = 'V90 Cross Country'
WHERE model LIKE 'V90 Cross Country%'
  AND brand = 'Volvo';
UPDATE SUA_Cars_Cleaned
SET model = 'V90'
WHERE model LIKE 'V90%'
  AND model NOT LIKE 'V90 Cross Country%'
  AND brand = 'Volvo';
UPDATE SUA_Cars_Cleaned
SET model = 'XC40'
WHERE model LIKE 'XC40%'
  AND brand = 'Volvo';
UPDATE SUA_Cars_Cleaned
SET model = 'XC60'
WHERE model LIKE 'XC60%'
  AND brand = 'Volvo';
UPDATE SUA_Cars_Cleaned
SET model = 'XC70'
WHERE model LIKE 'XC70%'
  AND brand = 'Volvo';
UPDATE SUA_Cars_Cleaned
SET model = 'XC90'
WHERE model LIKE 'XC90%'
  AND brand = 'Volvo';

-- ==================== ACURA ====================
UPDATE SUA_Cars_Cleaned
SET model = 'CL'
WHERE model LIKE 'CL%'
  AND brand = 'Acura';
UPDATE SUA_Cars_Cleaned
SET model = 'ILX'
WHERE model LIKE 'ILX%'
  AND brand = 'Acura';
UPDATE SUA_Cars_Cleaned
SET model = 'Integra'
WHERE model LIKE 'Integra%'
  AND brand = 'Acura';
UPDATE SUA_Cars_Cleaned
SET model = 'Legend'
WHERE model LIKE 'Legend%'
  AND brand = 'Acura';
UPDATE SUA_Cars_Cleaned
SET model = 'MDX'
WHERE model LIKE 'MDX%'
  AND brand = 'Acura';
UPDATE SUA_Cars_Cleaned
SET model = 'NSX'
WHERE model LIKE 'NSX%'
  AND brand = 'Acura';
UPDATE SUA_Cars_Cleaned
SET model = 'RDX'
WHERE model LIKE 'RDX%'
  AND brand = 'Acura';
UPDATE SUA_Cars_Cleaned
SET model = 'RL'
WHERE model LIKE 'RL%'
  AND model NOT LIKE 'RLX%'
  AND brand = 'Acura';
UPDATE SUA_Cars_Cleaned
SET model = 'RLX'
WHERE model LIKE 'RLX%'
  AND brand = 'Acura';
UPDATE SUA_Cars_Cleaned
SET model = 'RSX'
WHERE model LIKE 'RSX%'
  AND brand = 'Acura';
UPDATE SUA_Cars_Cleaned
SET model = 'TL'
WHERE model LIKE 'TL%'
  AND model NOT LIKE 'TLX%'
  AND brand = 'Acura';
UPDATE SUA_Cars_Cleaned
SET model = 'TLX'
WHERE model LIKE 'TLX%'
  AND brand = 'Acura';
UPDATE SUA_Cars_Cleaned
SET model = 'TSX'
WHERE model LIKE 'TSX%'
  AND brand = 'Acura';
UPDATE SUA_Cars_Cleaned
SET model = 'ZDX'
WHERE model LIKE 'ZDX%'
  AND brand = 'Acura';


-- ==================== AUDI ====================
-- A series
UPDATE SUA_Cars_Cleaned
SET model = 'A3'
WHERE model LIKE 'A3%'
  AND brand = 'Audi';
UPDATE SUA_Cars_Cleaned
SET model = 'A4 allroad'
WHERE model LIKE 'A4 allroad%'
  AND brand = 'Audi';
UPDATE SUA_Cars_Cleaned
SET model = 'A4'
WHERE model LIKE 'A4%'
  AND model NOT LIKE 'A4 allroad%'
  AND brand = 'Audi';
UPDATE SUA_Cars_Cleaned
SET model = 'A5'
WHERE model LIKE 'A5%'
  AND brand = 'Audi';
UPDATE SUA_Cars_Cleaned
SET model = 'A6 allroad'
WHERE model LIKE 'A6 allroad%'
  AND brand = 'Audi';
UPDATE SUA_Cars_Cleaned
SET model = 'A6'
WHERE model LIKE 'A6%'
  AND model NOT LIKE 'A6 allroad%'
  AND brand = 'Audi';
UPDATE SUA_Cars_Cleaned
SET model = 'A7'
WHERE model LIKE 'A7%'
  AND brand = 'Audi';
UPDATE SUA_Cars_Cleaned
SET model = 'A8'
WHERE model LIKE 'A8%'
  AND brand = 'Audi';

-- Q series
UPDATE SUA_Cars_Cleaned
SET model = 'Q3'
WHERE model LIKE 'Q3%'
  AND brand = 'Audi';
UPDATE SUA_Cars_Cleaned
SET model = 'Q4 e-tron'
WHERE model LIKE 'Q4%'
  AND brand = 'Audi';
UPDATE SUA_Cars_Cleaned
SET model = 'Q5'
WHERE model LIKE 'Q5%'
  AND brand = 'Audi';
UPDATE SUA_Cars_Cleaned
SET model = 'Q7'
WHERE model LIKE 'Q7%'
  AND brand = 'Audi';
UPDATE SUA_Cars_Cleaned
SET model = 'Q8'
WHERE model LIKE 'Q8%'
  AND brand = 'Audi';

-- R series
UPDATE SUA_Cars_Cleaned
SET model = 'R8'
WHERE model LIKE 'R8%'
  AND brand = 'Audi';

-- RS series
UPDATE SUA_Cars_Cleaned
SET model = 'RS 3'
WHERE model LIKE 'RS 3%'
  AND brand = 'Audi';
UPDATE SUA_Cars_Cleaned
SET model =
        'RS 4'
WHERE model LIKE 'RS 4%'
  AND brand = 'Audi';
UPDATE SUA_Cars_Cleaned
SET model = 'RS 5'
WHERE model LIKE 'RS 5%'
  AND brand = 'Audi';
UPDATE SUA_Cars_Cleaned
SET model = 'RS 7'
WHERE model LIKE 'RS 7%'
  AND brand = 'Audi';
UPDATE SUA_Cars_Cleaned
SET model = 'RS Q8'
WHERE model LIKE 'RS Q8%'
  AND brand = 'Audi';
UPDATE SUA_Cars_Cleaned
SET model = 'RS e-tron GT'
WHERE model LIKE 'RS e-tron GT%'
  AND brand = 'Audi';
UPDATE SUA_Cars_Cleaned
SET model = 'RS6'
WHERE model LIKE 'RS6%'
  AND brand = 'Audi';

-- S series
UPDATE SUA_Cars_Cleaned
SET model = 'S3'
WHERE model LIKE 'S3%'
  AND brand = 'Audi';
UPDATE SUA_Cars_Cleaned
SET model = 'S4'
WHERE model LIKE 'S4%'
  AND brand = 'Audi';
UPDATE SUA_Cars_Cleaned
SET model = 'S5'
WHERE model LIKE 'S5%'
  AND brand = 'Audi';
UPDATE SUA_Cars_Cleaned
SET model = 'S6'
WHERE model LIKE 'S6%'
  AND brand = 'Audi';
UPDATE SUA_Cars_Cleaned
SET model = 'S7'
WHERE model LIKE 'S7%'
  AND brand = 'Audi';
UPDATE SUA_Cars_Cleaned
SET model = 'S8'
WHERE model LIKE 'S8%'
  AND brand = 'Audi';
UPDATE SUA_Cars_Cleaned
SET model = 'SQ5'
WHERE model LIKE 'SQ5%'
  AND brand = 'Audi';
UPDATE SUA_Cars_Cleaned
SET model = 'SQ7'
WHERE model LIKE 'SQ7%'
  AND brand = 'Audi';

-- TT series
UPDATE SUA_Cars_Cleaned
SET model = 'TT RS'
WHERE model LIKE 'TT RS%'
  AND brand = 'Audi';
UPDATE SUA_Cars_Cleaned
SET model = 'TTS'
WHERE model LIKE 'TTS%'
  AND brand = 'Audi';
UPDATE SUA_Cars_Cleaned
SET model = 'TT'
WHERE model LIKE 'TT%'
  AND model NOT LIKE 'TT RS%'
  AND model NOT LIKE 'TTS%'
  AND brand =
      'Audi';

-- e-tron
UPDATE SUA_Cars_Cleaned
SET model = 'e-tron'
WHERE model LIKE 'e-tron%'
  AND brand =
      'Audi';

-- ==================== BMW ====================
-- 1 Series
UPDATE SUA_Cars_Cleaned
SET model = '128'
WHERE model LIKE '128%'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = '135'
WHERE model LIKE '135%'
  AND brand = 'BMW';

-- 2 Series
UPDATE SUA_Cars_Cleaned
SET model = '2002'
WHERE model LIKE '2002%'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = '228'
WHERE model LIKE '228%'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = '230'
WHERE model LIKE '230%'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = '240'
WHERE model LIKE '240%'
  AND brand = 'BMW';

-- 3 Series
UPDATE SUA_Cars_Cleaned
SET model = '318'
WHERE model LIKE '318%'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = '320'
WHERE model LIKE '320%'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = '323'
WHERE model LIKE '323%'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = '325'
WHERE model LIKE '325%'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = '328'
WHERE model LIKE '328%'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = '330e'
WHERE model LIKE '330e%'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = '330'
WHERE model LIKE '330%'
  AND model NOT LIKE '330e%'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = '335'
WHERE model LIKE '335%'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = '340'
WHERE model LIKE '340%'
  AND brand = 'BMW';

-- 4 Series
UPDATE SUA_Cars_Cleaned
SET model = '428'
WHERE model LIKE '428%'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = '430'
WHERE model LIKE '430%'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = '435'
WHERE model LIKE '435%'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = '440'
WHERE model LIKE '440%'
  AND brand = 'BMW';

-- 5 Series
UPDATE SUA_Cars_Cleaned
SET model = '525'
WHERE model LIKE '525%'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = '528'
WHERE model LIKE '528%'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = '530e'
WHERE model LIKE '530e%'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = '530'
WHERE model LIKE '530%'
  AND model NOT LIKE '530e%'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = '535'
WHERE model LIKE '535%'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = '540'
WHERE model LIKE '540%'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = '550'
WHERE model LIKE '550%'
  AND brand = 'BMW';

-- 6 Series
UPDATE SUA_Cars_Cleaned
SET model = '640'
WHERE model LIKE '640%'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = '645'
WHERE model LIKE '645%'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = '650'
WHERE model LIKE '650%'
  AND brand = 'BMW';

-- 7 Series
UPDATE SUA_Cars_Cleaned
SET model = '740e'
WHERE model LIKE '740e%'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = '740'
WHERE model LIKE '740%'
  AND model NOT LIKE '740e%'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = '745e'
WHERE model LIKE '745e%'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = '745'
WHERE model LIKE '745%'
  AND model NOT LIKE '745e%'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = '750'
WHERE model LIKE '750%'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = '760'
WHERE model LIKE '760%'
  AND brand = 'BMW';

-- 8 Series
UPDATE SUA_Cars_Cleaned
SET model = '840'
WHERE model LIKE '840%'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = '850'
WHERE model LIKE '850%'
  AND brand = 'BMW';

-- ALPINA
UPDATE SUA_Cars_Cleaned
SET model = 'ALPINA B7'
WHERE model LIKE 'ALPINA B7%'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = 'ALPINA B8'
WHERE model LIKE 'ALPINA B8%'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = 'ALPINA XB7'
WHERE model LIKE 'ALPINA XB7%'
  AND brand = 'BMW';

-- ActiveHybrid
UPDATE SUA_Cars_Cleaned
SET model = 'ActiveHybrid 3'
WHERE model LIKE 'ActiveHybrid 3%'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = 'ActiveHybrid 5'
WHERE model LIKE 'ActiveHybrid 5%'
  AND brand = 'BMW';

-- M Series
UPDATE SUA_Cars_Cleaned
SET model = 'M235'
WHERE model LIKE 'M235%'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = 'M2'
WHERE model LIKE 'M2%'
  AND model NOT LIKE 'M235%'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = 'M340'
WHERE model LIKE 'M340%'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = 'M3'
WHERE model LIKE 'M3%'
  AND model NOT LIKE 'M340%'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = 'M440'
WHERE model LIKE 'M440%'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = 'M4'
WHERE model LIKE 'M4%'
  AND model NOT LIKE 'M440%'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = 'M550'
WHERE model LIKE 'M550%'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = 'M5'
WHERE model LIKE 'M5%'
  AND model NOT LIKE 'M550%'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = 'M6'
WHERE model LIKE 'M6%'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = 'M760'
WHERE model LIKE 'M760%'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = 'M850'
WHERE model LIKE 'M850%'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = 'M8'
WHERE model LIKE 'M8%'
  AND model NOT LIKE 'M850%'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = 'M'
WHERE model IN ('M 3.2L', 'M Base', 'M Coupe', 'M M', 'M M 3.2L', 'M Roadster')
  AND brand =
      'BMW';

-- X Series
UPDATE SUA_Cars_Cleaned
SET model = 'X1'
WHERE model LIKE 'X1%'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = 'X2'
WHERE model LIKE 'X2%'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = 'X3 M'
WHERE model LIKE 'X3 M%'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = 'X3'
WHERE model LIKE 'X3%'
  AND model NOT LIKE 'X3 M%'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = 'X4 M'
WHERE model LIKE 'X4 M%'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = 'X4'
WHERE model LIKE 'X4%'
  AND model NOT LIKE 'X4 M%'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = 'X5 M'
WHERE model LIKE 'X5 M%'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = 'X5'
WHERE model LIKE 'X5%'
  AND model NOT LIKE 'X5 M%'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = 'X6 M'
WHERE model LIKE 'X6 M%'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = 'X6'
WHERE model LIKE 'X6%'
  AND model NOT LIKE 'X6 M%'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = 'X7'
WHERE model LIKE 'X7%'
  AND brand = 'BMW';

-- Z Series
UPDATE SUA_Cars_Cleaned
SET model = 'Z3'
WHERE model LIKE 'Z3%'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = 'Z4'
WHERE model LIKE 'Z4%'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = 'Z8'
WHERE model LIKE 'Z8%'
  AND brand = 'BMW';

-- i Series
UPDATE SUA_Cars_Cleaned
SET model = 'i3'
WHERE model LIKE 'i3%'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = 'i4'
WHERE model LIKE 'i4%'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = 'i7'
WHERE model LIKE 'i7%'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = 'i8'
WHERE model LIKE 'i8%'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = 'iX'
WHERE model LIKE 'iX%'
  AND brand = 'BMW';

UPDATE SUA_Cars_Cleaned
SET model = 'Seria 1'
WHERE model IN ('128', '135')
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = 'Seria 2'
WHERE model IN ('228', '230', '240')
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = 'Seria 3'
WHERE model IN
      ('318', '320', '323', '325', '328', '330', '330e', '335', '340', 'ActiveHybrid 3')
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = 'Seria 4'
WHERE model IN ('428', '430', '435', '440')
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = 'Seria 5'
WHERE model IN ('525', '528', '530', '530e', '535', '540', '550', 'ActiveHybrid 5')
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = 'Seria 6'
WHERE model IN ('640', '645', '650')
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = 'Seria 7'
WHERE model IN ('740', '740e', '745', '745e', '750', '760')
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = 'Seria 8'
WHERE model IN ('840', '850')
  AND brand = 'BMW';

-- Grupare X Series M in modele de baza
UPDATE SUA_Cars_Cleaned
SET model = 'X3'
WHERE model = 'X3 M'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = 'X4'
WHERE model = 'X4 M'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = 'X5'
WHERE model = 'X5 M'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = 'X6'
WHERE model = 'X6 M'
  AND brand = 'BMW';


-- ==================== BUICK ====================
UPDATE SUA_Cars_Cleaned
SET model = 'Cascada'
WHERE model LIKE 'Cascada%'
  AND brand = 'Buick';
UPDATE SUA_Cars_Cleaned
SET model = 'Centurion'
WHERE model LIKE 'Centurion%'
  AND brand = 'Buick';
UPDATE SUA_Cars_Cleaned
SET model = 'Century'
WHERE model LIKE 'Century%'
  AND brand = 'Buick';
UPDATE SUA_Cars_Cleaned
SET model = 'Electra'
WHERE model LIKE 'Electra%'
  AND brand = 'Buick';
UPDATE SUA_Cars_Cleaned
SET model = 'Enclave'
WHERE model LIKE 'Enclave%'
  AND brand = 'Buick';
UPDATE SUA_Cars_Cleaned
SET model = 'Encore GX'
WHERE model LIKE 'Encore GX%'
  AND brand = 'Buick';
UPDATE SUA_Cars_Cleaned
SET model = 'Encore'
WHERE model LIKE 'Encore%'
  AND model NOT LIKE 'Encore GX%'
  AND brand = 'Buick';
UPDATE SUA_Cars_Cleaned
SET model = 'Envision'
WHERE model LIKE 'Envision%'
  AND brand = 'Buick';
UPDATE SUA_Cars_Cleaned
SET model = 'Estate Wagon'
WHERE model LIKE 'Estate Wagon%'
  AND brand = 'Buick';
UPDATE SUA_Cars_Cleaned
SET model = 'GS'
WHERE model LIKE 'GS%'
  AND model NOT LIKE 'GSX%'
  AND brand = 'Buick';
UPDATE SUA_Cars_Cleaned
SET model = 'GSX'
WHERE model LIKE 'GSX%'
  AND brand = 'Buick';
UPDATE SUA_Cars_Cleaned
SET model = 'LaCrosse'
WHERE model LIKE 'LaCrosse%'
  AND brand = 'Buick';
UPDATE SUA_Cars_Cleaned
SET model = 'LeSabre'
WHERE model LIKE 'LeSabre%'
  AND brand = 'Buick';
UPDATE SUA_Cars_Cleaned
SET model = 'Lucerne'
WHERE model LIKE 'Lucerne%'
  AND brand = 'Buick';
UPDATE SUA_Cars_Cleaned
SET model = 'Park Avenue'
WHERE model LIKE 'Park Avenue%'
  AND brand = 'Buick';
UPDATE SUA_Cars_Cleaned
SET model = 'Rainier'
WHERE model LIKE 'Rainier%'
  AND brand = 'Buick';
UPDATE SUA_Cars_Cleaned
SET model = 'Reatta'
WHERE model LIKE 'Reatta%'
  AND brand = 'Buick';
UPDATE SUA_Cars_Cleaned
SET model = 'Regal Sportback'
WHERE model LIKE 'Regal Sportback%'
  AND brand = 'Buick';
UPDATE SUA_Cars_Cleaned
SET model = 'Regal TourX'
WHERE model LIKE 'Regal TourX%'
  AND brand = 'Buick';
UPDATE SUA_Cars_Cleaned
SET model = 'Regal'
WHERE model LIKE 'Regal%'
  AND model NOT LIKE 'Regal Sportback%'
  AND model NOT LIKE
      'Regal TourX%'
  AND brand = 'Buick';
UPDATE SUA_Cars_Cleaned
SET model = 'Rendezvous'
WHERE model LIKE 'Rendezvous%'
  AND brand = 'Buick';
UPDATE SUA_Cars_Cleaned
SET model = 'Riviera'
WHERE model LIKE 'Riviera%'
  AND brand = 'Buick';
UPDATE SUA_Cars_Cleaned
SET model = 'Roadmaster'
WHERE model LIKE 'Roadmaster%'
  AND brand = 'Buick';
UPDATE SUA_Cars_Cleaned
SET model = 'Skylark'
WHERE model LIKE 'Skylark%'
  AND brand = 'Buick';
UPDATE SUA_Cars_Cleaned
SET model = 'Special'
WHERE model LIKE 'Special%'
  AND brand = 'Buick';
UPDATE SUA_Cars_Cleaned
SET model = 'Super'
WHERE model LIKE 'Super%'
  AND brand = 'Buick';
UPDATE SUA_Cars_Cleaned
SET model = 'Terraza'
WHERE model LIKE 'Terraza%'
  AND brand = 'Buick';
UPDATE SUA_Cars_Cleaned
SET model = 'Verano'
WHERE model LIKE 'Verano%'
  AND brand = 'Buick';

-- ==================== CADILLAC ====================
-- Sedane
UPDATE SUA_Cars_Cleaned
SET model = 'ATS-V'
WHERE model LIKE 'ATS-V%'
  AND brand = 'Cadillac';
UPDATE SUA_Cars_Cleaned
SET model = 'ATS'
WHERE model LIKE 'ATS%'
  AND model NOT LIKE 'ATS-V%'
  AND brand = 'Cadillac';
UPDATE SUA_Cars_Cleaned
SET model = 'CT4-V'
WHERE (model LIKE 'CT4-V%' OR model LIKE 'CT4 V-Series%')
  AND brand = 'Cadillac';
UPDATE SUA_Cars_Cleaned
SET model = 'CT4'
WHERE model LIKE 'CT4%'
  AND model NOT LIKE 'CT4-V%'
  AND model NOT LIKE 'CT4 V-Series%'
  AND brand = 'Cadillac';
UPDATE SUA_Cars_Cleaned
SET model = 'CT5-V'
WHERE (model LIKE 'CT5-V%' OR model LIKE 'CT5 V-Series%')
  AND brand = 'Cadillac';
UPDATE SUA_Cars_Cleaned
SET model = 'CT5'
WHERE model LIKE 'CT5%'
  AND model NOT LIKE 'CT5-V%'
  AND model NOT LIKE 'CT5 V-Series%'
  AND brand = 'Cadillac';
UPDATE SUA_Cars_Cleaned
SET model = 'CT6-V'
WHERE model LIKE 'CT6-V%'
  AND brand = 'Cadillac';
UPDATE SUA_Cars_Cleaned
SET model = 'CT6'
WHERE model LIKE 'CT6%'
  AND model NOT LIKE 'CT6-V%'
  AND brand = 'Cadillac';
UPDATE SUA_Cars_Cleaned
SET model = 'CTS-V'
WHERE (model LIKE 'CTS-V%' OR model LIKE 'CTS V%')
  AND brand = 'Cadillac';
UPDATE SUA_Cars_Cleaned
SET model = 'CTS'
WHERE model LIKE 'CTS%'
  AND model NOT LIKE 'CTS-V%'
  AND model NOT LIKE 'CTS V%'
  AND brand = 'Cadillac';
UPDATE SUA_Cars_Cleaned
SET model = 'STS-V'
WHERE (model LIKE 'STS-V%' OR model LIKE 'STS V%')
  AND brand = 'Cadillac';
UPDATE SUA_Cars_Cleaned
SET model = 'STS'
WHERE model LIKE 'STS%'
  AND model NOT LIKE 'STS-V%'
  AND model NOT LIKE 'STS V%'
  AND brand = 'Cadillac';
UPDATE SUA_Cars_Cleaned
SET model = 'XTS'
WHERE model LIKE 'XTS%'
  AND brand = 'Cadillac';

-- Escalade
UPDATE SUA_Cars_Cleaned
SET model = 'Escalade-V'
WHERE model LIKE 'Escalade%'
  AND model LIKE '%V-Series%'
  AND brand = 'Cadillac';
UPDATE SUA_Cars_Cleaned
SET model = 'Escalade ESV'
WHERE model LIKE 'Escalade ESV%'
  AND brand = 'Cadillac';
UPDATE SUA_Cars_Cleaned
SET model = 'Escalade EXT'
WHERE model LIKE 'Escalade EXT%'
  AND brand = 'Cadillac';
UPDATE SUA_Cars_Cleaned
SET model = 'Escalade'
WHERE model LIKE 'Escalade%'
  AND model NOT LIKE 'Escalade ESV%'
  AND model NOT LIKE
      'Escalade EXT%'
  AND model != 'Escalade-V'
  AND brand = 'Cadillac';

-- SUV / EV
UPDATE SUA_Cars_Cleaned
SET model = 'SRX'
WHERE model LIKE 'SRX%'
  AND brand = 'Cadillac';
UPDATE SUA_Cars_Cleaned
SET model = 'XT4'
WHERE model LIKE 'XT4%'
  AND brand = 'Cadillac';
UPDATE SUA_Cars_Cleaned
SET model = 'XT5'
WHERE model LIKE 'XT5%'
  AND brand = 'Cadillac';
UPDATE SUA_Cars_Cleaned
SET model = 'XT6'
WHERE model LIKE 'XT6%'
  AND brand = 'Cadillac';
UPDATE SUA_Cars_Cleaned
SET model = 'LYRIQ'
WHERE model LIKE 'LYRIQ%'
  AND brand = 'Cadillac';
UPDATE SUA_Cars_Cleaned
SET model = 'ELR'
WHERE model LIKE 'ELR%'
  AND brand = 'Cadillac';

UPDATE SUA_Cars_Cleaned
SET model = 'Allante'
WHERE model LIKE 'Allante%'
  AND brand = 'Cadillac';
UPDATE SUA_Cars_Cleaned
SET model = 'Brougham'
WHERE model LIKE 'Brougham%'
  AND brand = 'Cadillac';
UPDATE SUA_Cars_Cleaned
SET model = 'Catera'
WHERE model LIKE 'Catera%'
  AND brand = 'Cadillac';
UPDATE SUA_Cars_Cleaned
SET model = 'DeVille'
WHERE model LIKE 'DeVille%'
  AND brand = 'Cadillac';
UPDATE SUA_Cars_Cleaned
SET model = 'DTS'
WHERE model LIKE 'DTS%'
  AND brand = 'Cadillac';
UPDATE SUA_Cars_Cleaned
SET model = 'Eldorado'
WHERE model LIKE 'Eldorado%'
  AND brand = 'Cadillac';
UPDATE SUA_Cars_Cleaned
SET model = 'Fleetwood'
WHERE model LIKE 'Fleetwood%'
  AND brand = 'Cadillac';
UPDATE SUA_Cars_Cleaned
SET model = 'Series 60'
WHERE model LIKE 'Series 60%'
  AND brand = 'Cadillac';
UPDATE SUA_Cars_Cleaned
SET model = 'Series 61'
WHERE model LIKE 'Series 61%'
  AND brand = 'Cadillac';
UPDATE SUA_Cars_Cleaned
SET model = 'Series 62'
WHERE model LIKE 'Series 62%'
  AND brand = 'Cadillac';
UPDATE SUA_Cars_Cleaned
SET model = 'Seville'
WHERE model LIKE 'Seville%'
  AND brand = 'Cadillac';
UPDATE SUA_Cars_Cleaned
SET model = 'XLR-V'
WHERE model LIKE 'XLR V%'
  AND brand = 'Cadillac';
UPDATE SUA_Cars_Cleaned
SET model = 'XLR'
WHERE model LIKE 'XLR%'
  AND model NOT LIKE 'XLR V%'
  AND brand = 'Cadillac';


-- ==================== CHEVROLET ====================
-- Vans
UPDATE SUA_Cars_Cleaned
SET model = 'Express 1500'
WHERE model LIKE 'Express 1500%'
  AND brand = 'Chevrolet';
UPDATE SUA_Cars_Cleaned
SET model = 'Express 2500'
WHERE model LIKE 'Express 2500%'
  AND brand = 'Chevrolet';
UPDATE SUA_Cars_Cleaned
SET model = 'Express 3500'
WHERE model LIKE 'Express 3500%'
  AND brand = 'Chevrolet';

-- SUV-uri
UPDATE SUA_Cars_Cleaned
SET model = 'S-10 Blazer'
WHERE model LIKE 'S-10 Blazer%'
  AND brand = 'Chevrolet';

-- Silverado
UPDATE SUA_Cars_Cleaned
SET model = 'Silverado 1500'
WHERE (model LIKE 'Silverado 1500%' OR model LIKE '1500%')
  AND brand =
      'Chevrolet';
UPDATE SUA_Cars_Cleaned
SET model = 'Silverado 2500'
WHERE (model LIKE 'Silverado 2500%' OR model LIKE '2500%')
  AND brand =
      'Chevrolet';
UPDATE SUA_Cars_Cleaned
SET model = 'Silverado 3500'
WHERE (model LIKE 'Silverado 3500%' OR model LIKE '3500%')
  AND brand =
      'Chevrolet';

-- Pick-up-uri
UPDATE SUA_Cars_Cleaned
SET model = 'Colorado'
WHERE model LIKE 'Colorado%'
  AND brand = 'Chevrolet';
UPDATE SUA_Cars_Cleaned
SET model = 'Avalanche'
WHERE model LIKE 'Avalanche%'
  AND brand = 'Chevrolet';
UPDATE SUA_Cars_Cleaned
SET model = 'C10/K10'
WHERE model LIKE 'C10/K10%'
  AND brand = 'Chevrolet';
UPDATE SUA_Cars_Cleaned
SET model = '3100'
WHERE model LIKE '3100%'
  AND brand = 'Chevrolet';
UPDATE SUA_Cars_Cleaned
SET model = 'El Camino'
WHERE model LIKE 'El Camino%'
  AND brand = 'Chevrolet';
UPDATE SUA_Cars_Cleaned
SET model = 'SSR'
WHERE model LIKE 'SSR%'
  AND brand = 'Chevrolet';

-- SUV-uri (restul)
UPDATE SUA_Cars_Cleaned
SET model = 'Blazer'
WHERE model LIKE 'Blazer%'
  AND brand = 'Chevrolet';
UPDATE SUA_Cars_Cleaned
SET model = 'Suburban'
WHERE model LIKE 'Suburban%'
  AND brand = 'Chevrolet';
UPDATE SUA_Cars_Cleaned
SET model = 'Tahoe'
WHERE model LIKE 'Tahoe%'
  AND brand = 'Chevrolet';
UPDATE SUA_Cars_Cleaned
SET model = 'Equinox'
WHERE model LIKE 'Equinox%'
  AND brand = 'Chevrolet';
UPDATE SUA_Cars_Cleaned
SET model = 'Traverse'
WHERE model LIKE 'Traverse%'
  AND brand = 'Chevrolet';
UPDATE SUA_Cars_Cleaned
SET model = 'Trailblazer'
WHERE model LIKE 'Trailblazer%'
  AND brand = 'Chevrolet';
UPDATE SUA_Cars_Cleaned
SET model = 'Trax'
WHERE model LIKE 'Trax%'
  AND brand = 'Chevrolet';
UPDATE SUA_Cars_Cleaned
SET model = 'Tracker'
WHERE model LIKE 'Tracker%'
  AND brand = 'Chevrolet';
UPDATE SUA_Cars_Cleaned
SET model = 'Captiva'
WHERE model LIKE 'Captiva%'
  AND brand = 'Chevrolet';

UPDATE SUA_Cars_Cleaned
SET model = 'Bolt EUV'
WHERE model LIKE 'Bolt EUV%'
  AND brand = 'Chevrolet';
UPDATE SUA_Cars_Cleaned
SET model = 'Bolt EV'
WHERE model LIKE 'Bolt EV%'
  AND brand = 'Chevrolet';

-- Autoturisme
UPDATE SUA_Cars_Cleaned
SET model = 'Camaro'
WHERE model LIKE 'Camaro%'
  AND brand = 'Chevrolet';
UPDATE SUA_Cars_Cleaned
SET model = 'Corvette'
WHERE model LIKE 'Corvette%'
  AND brand = 'Chevrolet';
UPDATE SUA_Cars_Cleaned
SET model = 'Malibu'
WHERE model LIKE 'Malibu%'
  AND brand = 'Chevrolet';
UPDATE SUA_Cars_Cleaned
SET model = 'Impala'
WHERE model LIKE 'Impala%'
  AND brand = 'Chevrolet';
UPDATE SUA_Cars_Cleaned
SET model = 'Cruze'
WHERE model LIKE 'Cruze%'
  AND brand = 'Chevrolet';
UPDATE SUA_Cars_Cleaned
SET model = 'Cobalt'
WHERE model LIKE 'Cobalt%'
  AND brand = 'Chevrolet';
UPDATE SUA_Cars_Cleaned
SET model = 'Cavalier'
WHERE model LIKE 'Cavalier%'
  AND brand = 'Chevrolet';
UPDATE SUA_Cars_Cleaned
SET model = 'Sonic'
WHERE model LIKE 'Sonic%'
  AND brand = 'Chevrolet';
UPDATE SUA_Cars_Cleaned
SET model = 'Spark'
WHERE model LIKE 'Spark%'
  AND brand = 'Chevrolet';
UPDATE SUA_Cars_Cleaned
SET model = 'Volt'
WHERE model LIKE 'Volt%'
  AND brand = 'Chevrolet';

-- Dubite / Vans
UPDATE SUA_Cars_Cleaned
SET model = 'Astro'
WHERE model LIKE 'Astro%'
  AND brand = 'Chevrolet';
UPDATE SUA_Cars_Cleaned
SET model = 'City Express'
WHERE model LIKE 'City Express%'
  AND brand = 'Chevrolet';
UPDATE SUA_Cars_Cleaned
SET model = 'Uplander'
WHERE model LIKE 'Uplander%'
  AND brand = 'Chevrolet';
UPDATE SUA_Cars_Cleaned
SET model = 'Venture'
WHERE model LIKE 'Venture%'
  AND brand = 'Chevrolet';

-- Clasice
UPDATE SUA_Cars_Cleaned
SET model = 'Chevelle'
WHERE model LIKE 'Chevelle%'
  AND brand = 'Chevrolet';
UPDATE SUA_Cars_Cleaned
SET model = 'Nova'
WHERE (model LIKE 'Nova%' OR model LIKE 'Chevy II%')
  AND brand = 'Chevrolet';
UPDATE SUA_Cars_Cleaned
SET model = 'Bel Air'
WHERE model LIKE 'Bel Air%'
  AND brand = 'Chevrolet';
UPDATE SUA_Cars_Cleaned
SET model = 'Biscayne'
WHERE model LIKE 'Biscayne%'
  AND brand = 'Chevrolet';
UPDATE SUA_Cars_Cleaned
SET model = 'Caprice'
WHERE model LIKE 'Caprice%'
  AND brand = 'Chevrolet';
UPDATE SUA_Cars_Cleaned
SET model = 'Vega'
WHERE model LIKE 'Vega%'
  AND brand = 'Chevrolet';

UPDATE SUA_Cars_Cleaned
SET model = 'Fleetmaster'
WHERE model LIKE 'Fleetmaster%'
  AND brand = 'Chevrolet';
UPDATE SUA_Cars_Cleaned
SET model = 'Stylemaster'
WHERE model LIKE 'Stylemaster%'
  AND brand = 'Chevrolet';
UPDATE SUA_Cars_Cleaned
SET model = 'Styleline'
WHERE model LIKE 'Styleline%'
  AND brand = 'Chevrolet';
UPDATE SUA_Cars_Cleaned
SET model = 'Master Deluxe'
WHERE model LIKE 'Master Deluxe%'
  AND brand = 'Chevrolet';
UPDATE SUA_Cars_Cleaned
SET model = 'Confederate'
WHERE model LIKE 'Confederate%'
  AND brand = 'Chevrolet';
UPDATE SUA_Cars_Cleaned
SET model = 'Apache'
WHERE model LIKE 'Apache%'
  AND brand = 'Chevrolet';
UPDATE SUA_Cars_Cleaned
SET model = 'Superior'
WHERE model LIKE 'Superior%'
  AND brand = 'Chevrolet';

-- ==================== CHRYSLER ====================
UPDATE SUA_Cars_Cleaned
SET model = '300M'
WHERE model LIKE '300M%'
  AND brand = 'Chrysler';
UPDATE SUA_Cars_Cleaned
SET model = '300C'
WHERE model LIKE '300C%'
  AND brand = 'Chrysler';
UPDATE SUA_Cars_Cleaned
SET model = '300'
WHERE model LIKE '300%'
  AND model NOT LIKE '300M%'
  AND model NOT LIKE '300C%'
  AND brand
    = 'Chrysler';
UPDATE SUA_Cars_Cleaned
SET model = '200'
WHERE model LIKE '200%'
  AND brand = 'Chrysler';

-- Minivan-uri
UPDATE SUA_Cars_Cleaned
SET model = 'Pacifica Hybrid'
WHERE model LIKE 'Pacifica Hybrid%'
  AND brand = 'Chrysler';
UPDATE SUA_Cars_Cleaned
SET model = 'Pacifica'
WHERE model LIKE 'Pacifica%'
  AND model NOT LIKE 'Pacifica Hybrid%'
  AND brand =
      'Chrysler';
UPDATE SUA_Cars_Cleaned
SET model = 'Town & Country'
WHERE model LIKE 'Town & Country%'
  AND brand = 'Chrysler';
UPDATE SUA_Cars_Cleaned
SET model = 'Voyager'
WHERE model LIKE 'Voyager%'
  AND brand = 'Chrysler';

-- SUV-uri / Unicat
UPDATE SUA_Cars_Cleaned
SET model = 'PT Cruiser'
WHERE model LIKE 'PT Cruiser%'
  AND brand = 'Chrysler';
UPDATE SUA_Cars_Cleaned
SET model = 'Aspen'
WHERE model LIKE 'Aspen%'
  AND brand = 'Chrysler';
UPDATE SUA_Cars_Cleaned
SET model = 'Crossfire'
WHERE model LIKE 'Crossfire%'
  AND brand = 'Chrysler';
UPDATE SUA_Cars_Cleaned
SET model = 'Prowler'
WHERE model LIKE 'Prowler%'
  AND brand = 'Chrysler';

-- Sedanuri clasice
UPDATE SUA_Cars_Cleaned
SET model = 'Sebring'
WHERE model LIKE 'Sebring%'
  AND brand = 'Chrysler';
UPDATE SUA_Cars_Cleaned
SET model = 'Concorde'
WHERE model LIKE 'Concorde%'
  AND brand = 'Chrysler';
UPDATE SUA_Cars_Cleaned
SET model = 'LHS'
WHERE model LIKE 'LHS%'
  AND brand = 'Chrysler';
UPDATE SUA_Cars_Cleaned
SET model = 'LeBaron'
WHERE model LIKE 'LeBaron%'
  AND brand = 'Chrysler';
UPDATE SUA_Cars_Cleaned
SET model = 'New Yorker'
WHERE model LIKE 'New Yorker%'
  AND brand = 'Chrysler';
UPDATE SUA_Cars_Cleaned
SET model = 'Cordoba'
WHERE model LIKE 'Cordoba%'
  AND brand = 'Chrysler';
UPDATE SUA_Cars_Cleaned
SET model = 'Fifth Avenue'
WHERE model LIKE 'Fifth Avenue%'
  AND brand = 'Chrysler';
UPDATE SUA_Cars_Cleaned
SET model = 'Newport'
WHERE model LIKE 'Newport%'
  AND brand = 'Chrysler';
UPDATE SUA_Cars_Cleaned
SET model = 'TC by Maserati'
WHERE model LIKE 'TC by Maserati%'
  AND brand = 'Chrysler';

-- ==================== DODGE / RAM ====================
UPDATE SUA_Cars_Cleaned
SET model = 'Challenger SRT/Hellcat/Demon'
WHERE model LIKE 'Challenger%'
  AND (model LIKE '%SRT%' OR model LIKE '%Hellcat%' OR model LIKE '%Demon%')
  AND brand IN ('Dodge', 'Ram');
UPDATE SUA_Cars_Cleaned
SET model = 'Challenger'
WHERE model LIKE 'Challenger%'
  AND model NOT LIKE '%SRT%'
  AND model NOT LIKE '%Hellcat%'
  AND model NOT LIKE '%Demon%'
  AND brand IN ('Dodge', 'Ram');

UPDATE SUA_Cars_Cleaned
SET model = 'Charger SRT/Hellcat'
WHERE model LIKE 'Charger%'
  AND (model LIKE '%SRT%' OR model LIKE '%Hellcat%')
  AND brand IN ('Dodge', 'Ram');
UPDATE SUA_Cars_Cleaned
SET model = 'Charger'
WHERE model LIKE 'Charger%'
  AND model NOT LIKE '%SRT%'
  AND model NOT LIKE '%Hellcat%'
  AND brand IN ('Dodge', 'Ram');

UPDATE SUA_Cars_Cleaned
SET model = 'Avenger'
WHERE model LIKE 'Avenger%'
  AND brand IN ('Dodge', 'Ram');
UPDATE SUA_Cars_Cleaned
SET model = 'Dart'
WHERE model LIKE 'Dart%'
  AND brand IN ('Dodge', 'Ram');
UPDATE SUA_Cars_Cleaned
SET model = 'Neon'
WHERE model LIKE 'Neon%'
  AND brand IN ('Dodge', 'Ram');
UPDATE SUA_Cars_Cleaned
SET model = 'Stratus'
WHERE model LIKE 'Stratus%'
  AND brand IN ('Dodge', 'Ram');
UPDATE SUA_Cars_Cleaned
SET model = 'Stealth'
WHERE model LIKE 'Stealth%'
  AND brand IN ('Dodge', 'Ram');

-- SUV-uri, Crossovere și Minivan-uri

UPDATE SUA_Cars_Cleaned
SET model = 'Durango SRT/Hellcat'
WHERE model LIKE 'Durango%'
  AND (model LIKE '%SRT%' OR model LIKE '%Hellcat%')
  AND brand IN ('Dodge', 'Ram');
UPDATE SUA_Cars_Cleaned
SET model = 'Durango'
WHERE model LIKE 'Durango%'
  AND model NOT LIKE '%SRT%'
  AND model NOT LIKE '%Hellcat%'
  AND brand IN ('Dodge', 'Ram');

UPDATE SUA_Cars_Cleaned
SET model = 'Journey'
WHERE model LIKE 'Journey%'
  AND brand IN ('Dodge', 'Ram');
UPDATE SUA_Cars_Cleaned
SET model = 'Grand Caravan'
WHERE model LIKE 'Grand Caravan%'
  AND brand IN ('Dodge', 'Ram');
UPDATE SUA_Cars_Cleaned
SET model = 'Caravan'
WHERE model LIKE 'Caravan%'
  AND model NOT LIKE 'Grand Caravan%'
  AND brand IN ('Dodge', 'Ram');
UPDATE SUA_Cars_Cleaned
SET model = 'Nitro'
WHERE model LIKE 'Nitro%'
  AND brand IN ('Dodge', 'Ram');
UPDATE SUA_Cars_Cleaned
SET model = 'Caliber'
WHERE model LIKE 'Caliber%'
  AND brand IN ('Dodge', 'Ram');
UPDATE SUA_Cars_Cleaned
SET model = 'Magnum'
WHERE model LIKE 'Magnum%'
  AND brand IN ('Dodge', 'Ram');

-- Pick-up-uri

UPDATE SUA_Cars_Cleaned
SET model = 'Ram Van'
WHERE model LIKE 'Ram Van%'
  AND brand IN ('Dodge', 'Ram');
UPDATE SUA_Cars_Cleaned
SET model = 'Ram Wagon'
WHERE model LIKE 'Ram Wagon%'
  AND brand IN ('Dodge', 'Ram');
UPDATE SUA_Cars_Cleaned
SET model = 'Ram 1500'
WHERE model LIKE '%Ram 1500%'
  AND brand IN ('Dodge', 'Ram');
UPDATE SUA_Cars_Cleaned
SET model = 'Ram 2500'
WHERE model LIKE '%Ram 2500%'
  AND brand IN ('Dodge', 'Ram');
UPDATE SUA_Cars_Cleaned
SET model = 'Ram 3500'
WHERE model LIKE '%Ram 3500%'
  AND brand IN ('Dodge', 'Ram');
UPDATE SUA_Cars_Cleaned
SET model = 'Dakota'
WHERE model LIKE 'Dakota%'
  AND brand IN ('Dodge', 'Ram');
UPDATE SUA_Cars_Cleaned
SET model = 'Ramcharger'
WHERE model LIKE 'Ramcharger%'
  AND brand IN ('Dodge', 'Ram');
UPDATE SUA_Cars_Cleaned
SET model = 'D-Series'
WHERE (model LIKE 'D150%' OR model LIKE 'D250%')
  AND brand IN ('Dodge', 'Ram');
UPDATE SUA_Cars_Cleaned
SET model = 'W-Series'
WHERE model LIKE 'W250%'
  AND brand IN ('Dodge', 'Ram');

UPDATE SUA_Cars_Cleaned
SET model = 'Sprinter'
WHERE model LIKE 'Sprinter%'
  AND brand IN ('Dodge', 'Ram');


UPDATE SUA_Cars_Cleaned
SET model = 'Viper'
WHERE (model LIKE 'Viper%' OR model LIKE 'SRT Viper%')
  AND brand IN ('Dodge', 'Ram');
UPDATE SUA_Cars_Cleaned
SET model = 'Coronet'
WHERE model LIKE 'Coronet%'
  AND brand IN ('Dodge', 'Ram');
UPDATE SUA_Cars_Cleaned
SET model = 'Polara'
WHERE model LIKE 'Polara%'
  AND brand IN ('Dodge', 'Ram');
UPDATE SUA_Cars_Cleaned
SET model = 'Diplomat'
WHERE model LIKE 'Diplomat%'
  AND brand IN ('Dodge', 'Ram');
UPDATE SUA_Cars_Cleaned
SET model = 'Shadow'
WHERE model LIKE 'Shadow%'
  AND brand IN ('Dodge', 'Ram');
UPDATE SUA_Cars_Cleaned
SET model = 'Aspen'
WHERE model LIKE 'Aspen%'
  AND brand IN ('Dodge', 'Ram');
UPDATE SUA_Cars_Cleaned
SET model = '400'
WHERE model LIKE '400%'
  AND brand IN ('Dodge', 'Ram');
UPDATE SUA_Cars_Cleaned
SET model = '600'
WHERE model LIKE '600%'
  AND brand IN ('Dodge', 'Ram');
UPDATE SUA_Cars_Cleaned
SET model = '880'
WHERE model LIKE '880%'
  AND brand IN ('Dodge', 'Ram');
UPDATE SUA_Cars_Cleaned
SET model = 'Intrepid'
WHERE model LIKE 'Intrepid%'
  AND brand IN ('Dodge', 'Ram');

-- ==================== FORD ====================
UPDATE SUA_Cars_Cleaned
SET model = 'Mustang Mach-E'
WHERE model LIKE '%Mach-E%'
  AND brand = 'Ford';
UPDATE SUA_Cars_Cleaned
SET model = 'Mustang Shelby/SVT Cobra'
WHERE (model LIKE '%Shelby%' OR model LIKE '%GT350%' OR model LIKE '%GT500%' OR model LIKE '%SVT Cobra%')
  AND brand = 'Ford';
UPDATE SUA_Cars_Cleaned
SET model = 'Mustang'
WHERE model LIKE 'Mustang%'
  AND model NOT LIKE '%Mach-E%'
  AND model NOT LIKE '%Shelby%'
  AND model NOT LIKE '%GT350%'
  AND model NOT LIKE '%GT500%'
  AND model NOT LIKE '%SVT%'
  AND brand = 'Ford';
UPDATE SUA_Cars_Cleaned
SET model = 'Ford GT'
WHERE model LIKE 'GT%'
  AND brand = 'Ford';

-- Pick-up-uri

UPDATE SUA_Cars_Cleaned
SET model = 'F-150 Lightning'
WHERE model LIKE '%F-150 Lightning%'
  AND brand = 'Ford';
UPDATE SUA_Cars_Cleaned
SET model = 'F-150'
WHERE model LIKE '%F-150%'
  AND model NOT LIKE '%Lightning%'
  AND brand = 'Ford';
UPDATE SUA_Cars_Cleaned
SET model = 'F-250'
WHERE model LIKE '%F-250%'
  AND brand = 'Ford';
UPDATE SUA_Cars_Cleaned
SET model = 'F-350'
WHERE model LIKE '%F-350%'
  AND brand = 'Ford';
UPDATE SUA_Cars_Cleaned
SET model = 'F-450'
WHERE model LIKE '%F-450%'
  AND brand = 'Ford';
UPDATE SUA_Cars_Cleaned
SET model = 'F100'
WHERE model LIKE 'F100%'
  AND brand = 'Ford';
UPDATE SUA_Cars_Cleaned
SET model = 'Ranger'
WHERE model LIKE 'Ranger%'
  AND brand = 'Ford';
UPDATE SUA_Cars_Cleaned
SET model = 'Maverick'
WHERE model LIKE 'Maverick%'
  AND brand = 'Ford';
UPDATE SUA_Cars_Cleaned
SET model = 'Explorer Sport Trac'
WHERE model LIKE '%Sport Trac%'
  AND brand = 'Ford';

-- SUV-uri și Crossovere

UPDATE SUA_Cars_Cleaned
SET model = 'Bronco Sport'
WHERE model LIKE 'Bronco Sport%'
  AND brand = 'Ford';
UPDATE SUA_Cars_Cleaned
SET model = 'Bronco II'
WHERE model LIKE 'Bronco II%'
  AND brand = 'Ford';
UPDATE SUA_Cars_Cleaned
SET model = 'Bronco'
WHERE model LIKE 'Bronco%'
  AND model NOT LIKE 'Bronco Sport%'
  AND model NOT LIKE 'Bronco II%'
  AND brand = 'Ford';
UPDATE SUA_Cars_Cleaned
SET model = 'Expedition MAX/EL'
WHERE model LIKE 'Expedition%'
  AND (model LIKE '%EL%' OR model LIKE '%MAX%' OR model LIKE '%Max%')
  AND brand = 'Ford';
UPDATE SUA_Cars_Cleaned
SET model = 'Expedition'
WHERE model LIKE 'Expedition%'
  AND model NOT LIKE '%EL%'
  AND model NOT LIKE '%MAX%'
  AND model NOT LIKE '%Max%'
  AND brand = 'Ford';
UPDATE SUA_Cars_Cleaned
SET model = 'Explorer'
WHERE model LIKE 'Explorer%'
  AND model NOT LIKE '%Sport Trac%'
  AND brand = 'Ford';
UPDATE SUA_Cars_Cleaned
SET model = 'Escape'
WHERE model LIKE 'Escape%'
  AND brand = 'Ford';
UPDATE SUA_Cars_Cleaned
SET model = 'Edge'
WHERE model LIKE 'Edge%'
  AND brand = 'Ford';
UPDATE SUA_Cars_Cleaned
SET model = 'EcoSport'
WHERE model LIKE 'EcoSport%'
  AND brand = 'Ford';
UPDATE SUA_Cars_Cleaned
SET model = 'Excursion'
WHERE model LIKE 'Excursion%'
  AND brand = 'Ford';
UPDATE SUA_Cars_Cleaned
SET model = 'Flex'
WHERE model LIKE 'Flex%'
  AND brand = 'Ford';


UPDATE SUA_Cars_Cleaned
SET model = 'E-Transit'
WHERE model LIKE 'E-Transit%'
  AND brand = 'Ford';
UPDATE SUA_Cars_Cleaned
SET model = 'Transit Connect'
WHERE model LIKE 'Transit Connect%'
  AND brand = 'Ford';
UPDATE SUA_Cars_Cleaned
SET model = 'Transit-150'
WHERE model LIKE '%Transit-150%'
  AND brand = 'Ford';
UPDATE SUA_Cars_Cleaned
SET model = 'Transit-250'
WHERE model LIKE '%Transit-250%'
  AND brand = 'Ford';
UPDATE SUA_Cars_Cleaned
SET model = 'Transit-350'
WHERE model LIKE '%Transit-350%'
  AND brand = 'Ford';
UPDATE SUA_Cars_Cleaned
SET model = 'E-150'
WHERE model LIKE 'E150%'
  AND brand = 'Ford';
UPDATE SUA_Cars_Cleaned
SET model = 'E-250'
WHERE model LIKE 'E250%'
  AND brand = 'Ford';
UPDATE SUA_Cars_Cleaned
SET model = 'E-350'
WHERE model LIKE 'E350%'
  AND brand = 'Ford';
-- MPV-uri
UPDATE SUA_Cars_Cleaned
SET model = 'Aerostar'
WHERE model LIKE 'Aerostar%'
  AND brand = 'Ford';
UPDATE SUA_Cars_Cleaned
SET model = 'Freestar'
WHERE model LIKE 'Freestar%'
  AND brand = 'Ford';
UPDATE SUA_Cars_Cleaned
SET model = 'Windstar'
WHERE model LIKE 'Windstar%'
  AND brand = 'Ford';
UPDATE SUA_Cars_Cleaned
SET model = 'Club Wagon'
WHERE model LIKE 'Club Wagon%'
  AND brand = 'Ford';

-- Autoturisme Moderne

UPDATE SUA_Cars_Cleaned
SET model = 'C-Max'
WHERE model LIKE 'C-Max%'
  AND brand = 'Ford';
UPDATE SUA_Cars_Cleaned
SET model = 'Focus'
WHERE model LIKE 'Focus%'
  AND brand = 'Ford';
UPDATE SUA_Cars_Cleaned
SET model = 'Fiesta'
WHERE model LIKE 'Fiesta%'
  AND brand = 'Ford';
UPDATE SUA_Cars_Cleaned
SET model = 'Fusion'
WHERE model LIKE 'Fusion%'
  AND brand = 'Ford';
UPDATE SUA_Cars_Cleaned
SET model = 'Taurus'
WHERE model LIKE 'Taurus%'
  AND brand = 'Ford';
UPDATE SUA_Cars_Cleaned
SET model = 'Crown Victoria'
WHERE model LIKE 'Crown Victoria%'
  AND brand = 'Ford';
UPDATE SUA_Cars_Cleaned
SET model = 'Five Hundred'
WHERE model LIKE 'Five Hundred%'
  AND brand = 'Ford';


UPDATE SUA_Cars_Cleaned
SET model = 'Police Interceptor Utility'
WHERE model LIKE 'Utility Police Interceptor%'
  AND brand = 'Ford';
UPDATE SUA_Cars_Cleaned
SET model = 'Police Interceptor Sedan'
WHERE model LIKE 'Sedan Police Interceptor%'
  AND brand = 'Ford';


UPDATE SUA_Cars_Cleaned
SET model = 'Fairlane'
WHERE model LIKE 'Fairlane%'
  AND brand = 'Ford';
UPDATE SUA_Cars_Cleaned
SET model = 'Falcon'
WHERE model LIKE 'Falcon%'
  AND brand = 'Ford';
UPDATE SUA_Cars_Cleaned
SET model = 'Galaxie'
WHERE model LIKE 'Galaxie%'
  AND brand = 'Ford';
UPDATE SUA_Cars_Cleaned
SET model = 'Model A'
WHERE model LIKE 'Model A%'
  AND brand = 'Ford';
UPDATE SUA_Cars_Cleaned
SET model = 'Model T'
WHERE model LIKE 'Model T%'
  AND brand = 'Ford';
UPDATE SUA_Cars_Cleaned
SET model = 'Ranchero'
WHERE model LIKE 'Ranchero%'
  AND brand = 'Ford';
UPDATE SUA_Cars_Cleaned
SET model = 'Thunderbird'
WHERE model LIKE 'Thunderbird%'
  AND brand = 'Ford';
UPDATE SUA_Cars_Cleaned
SET model = 'Torino'
WHERE model LIKE 'Torino%'
  AND brand = 'Ford';
UPDATE SUA_Cars_Cleaned
SET model = 'Pinto'
WHERE model LIKE 'Pinto%'
  AND brand = 'Ford';
UPDATE SUA_Cars_Cleaned
SET model = 'Probe'
WHERE model LIKE 'Probe%'
  AND brand = 'Ford';
UPDATE SUA_Cars_Cleaned
SET model = 'Granada'
WHERE model LIKE 'Granada%'
  AND brand = 'Ford';
UPDATE SUA_Cars_Cleaned
SET model = 'LTD'
WHERE model LIKE 'LTD%'
  AND brand = 'Ford';
UPDATE SUA_Cars_Cleaned
SET model = 'Customline'
WHERE model LIKE 'Customline%'
  AND brand = 'Ford';
UPDATE SUA_Cars_Cleaned
SET model = 'Crestline'
WHERE model LIKE 'Crestline%'
  AND brand = 'Ford';
UPDATE SUA_Cars_Cleaned
SET model = 'Escort'
WHERE model LIKE 'Escort%'
  AND brand = 'Ford';
UPDATE SUA_Cars_Cleaned
SET model = 'Freestyle'
WHERE model LIKE 'Freestyle%'
  AND brand = 'Ford';

-- ==================== GMC ====================
UPDATE SUA_Cars_Cleaned
SET model = 'Sierra 1500'
WHERE (model LIKE 'Sierra 1500%' OR model LIKE '1500%')
  AND brand = 'GMC';
UPDATE SUA_Cars_Cleaned
SET model = 'Sierra 2500'
WHERE (model LIKE 'Sierra 2500%' OR model LIKE '2500%')
  AND brand = 'GMC';
UPDATE SUA_Cars_Cleaned
SET model = 'Sierra 3500'
WHERE (model LIKE 'Sierra 3500%' OR model LIKE '3500%')
  AND brand = 'GMC';

-- Pick-up-uri Mid-size și Clasice

UPDATE SUA_Cars_Cleaned
SET model = 'Canyon'
WHERE model LIKE 'Canyon%'
  AND brand = 'GMC';
UPDATE SUA_Cars_Cleaned
SET model = 'Sonoma'
WHERE model LIKE 'Sonoma%'
  AND brand = 'GMC';
UPDATE SUA_Cars_Cleaned
SET model = 'Caballero'
WHERE model LIKE 'Caballero%'
  AND brand = 'GMC';
UPDATE SUA_Cars_Cleaned
SET model = 'Sprint'
WHERE model LIKE 'Sprint%'
  AND brand = 'GMC';
UPDATE SUA_Cars_Cleaned
SET model = 'Pickup Truck'
WHERE model LIKE 'Pickup Truck%'
  AND brand = 'GMC';


UPDATE SUA_Cars_Cleaned
SET model = 'Yukon XL'
WHERE model LIKE 'Yukon XL%'
  AND brand = 'GMC';
UPDATE SUA_Cars_Cleaned
SET model = 'Yukon'
WHERE model LIKE 'Yukon%'
  AND model NOT LIKE 'Yukon XL%'
  AND brand = 'GMC';

-- SUV-uri și Crossovere

UPDATE SUA_Cars_Cleaned
SET model = 'Acadia'
WHERE model LIKE 'Acadia%'
  AND brand = 'GMC';
UPDATE SUA_Cars_Cleaned
SET model = 'Terrain'
WHERE model LIKE 'Terrain%'
  AND brand = 'GMC';
UPDATE SUA_Cars_Cleaned
SET model = 'Envoy'
WHERE model LIKE 'Envoy%'
  AND brand = 'GMC';
UPDATE SUA_Cars_Cleaned
SET model = 'Suburban'
WHERE model LIKE 'Suburban%'
  AND brand = 'GMC';
UPDATE SUA_Cars_Cleaned
SET model = 'Typhoon'
WHERE model LIKE '%Typhoon%'
  AND brand = 'GMC';
UPDATE SUA_Cars_Cleaned
SET model = 'Jimmy'
WHERE model LIKE 'Jimmy%'
  AND model NOT LIKE '%Typhoon%'
  AND brand = 'GMC';


UPDATE SUA_Cars_Cleaned
SET model = 'Savana 1500'
WHERE model LIKE '%Savana 1500%'
  AND brand = 'GMC';
UPDATE SUA_Cars_Cleaned
SET model = 'Savana 2500'
WHERE model LIKE '%Savana 2500%'
  AND brand = 'GMC';
UPDATE SUA_Cars_Cleaned
SET model = 'Savana 3500'
WHERE model LIKE '%Savana 3500%'
  AND brand = 'GMC';
UPDATE SUA_Cars_Cleaned
SET model = 'Safari'
WHERE model LIKE 'Safari%'
  AND brand = 'GMC';
UPDATE SUA_Cars_Cleaned
SET model = 'Vandura'
WHERE model LIKE 'Vandura%'
  AND brand = 'GMC';


UPDATE SUA_Cars_Cleaned
SET model = 'HUMMER EV'
WHERE model LIKE 'HUMMER EV%'
  AND brand = 'GMC';

-- ==================== HONDA ====================
UPDATE SUA_Cars_Cleaned
SET model = 'Civic Type R'
WHERE model LIKE '%Type R%'
  AND brand = 'Honda';
UPDATE SUA_Cars_Cleaned
SET model = 'Civic Si'
WHERE model LIKE '%Civic Si%'
  AND brand = 'Honda';
UPDATE SUA_Cars_Cleaned
SET model = 'Civic Hybrid'
WHERE model LIKE '%Civic Hybrid%'
  AND brand = 'Honda';
UPDATE SUA_Cars_Cleaned
SET model = 'Civic Natural Gas/GX'
WHERE (model LIKE '%Natural Gas%'
    OR model LIKE 'Civic GX%')
  AND brand = 'Honda';
UPDATE SUA_Cars_Cleaned
SET model = 'Civic'
WHERE model LIKE 'Civic%'
  AND model NOT LIKE '%Type R%'
  AND model NOT LIKE '%Civic Si%'
  AND model NOT LIKE '%Hybrid%'
  AND model NOT LIKE '%Natural Gas%'
  AND model NOT LIKE '%GX%'
  AND brand = 'Honda';


UPDATE SUA_Cars_Cleaned
SET model = 'Accord Hybrid'
WHERE model LIKE '%Accord Hybrid%'
  AND brand = 'Honda';
UPDATE SUA_Cars_Cleaned
SET model = 'Crosstour'
WHERE model LIKE '%Crosstour%'
  AND brand = 'Honda';
UPDATE SUA_Cars_Cleaned
SET model = 'Accord'
WHERE model LIKE 'Accord%'
  AND model NOT LIKE '%Hybrid%'
  AND model NOT LIKE '%Crosstour%'
  AND brand = 'Honda';


UPDATE SUA_Cars_Cleaned
SET model = 'CR-V Hybrid'
WHERE model LIKE '%CR-V Hybrid%'
  AND brand = 'Honda';
UPDATE SUA_Cars_Cleaned
SET model = 'CR-V'
WHERE model LIKE 'CR-V%'
  AND model NOT LIKE '%Hybrid%'
  AND brand = 'Honda';

-- SUV-uri, Crossovere, Minivan și Pick-up

UPDATE SUA_Cars_Cleaned
SET model = 'Pilot'
WHERE model LIKE 'Pilot%'
  AND brand = 'Honda';
UPDATE SUA_Cars_Cleaned
SET model = 'Passport'
WHERE model LIKE 'Passport%'
  AND brand = 'Honda';
UPDATE SUA_Cars_Cleaned
SET model = 'HR-V'
WHERE model LIKE 'HR-V%'
  AND brand = 'Honda';
UPDATE SUA_Cars_Cleaned
SET model = 'Element'
WHERE model LIKE 'Element%'
  AND brand = 'Honda';
UPDATE SUA_Cars_Cleaned
SET model = 'Odyssey'
WHERE model LIKE 'Odyssey%'
  AND brand = 'Honda';
UPDATE SUA_Cars_Cleaned
SET model = 'Ridgeline'
WHERE model LIKE 'Ridgeline%'
  AND brand = 'Honda';


UPDATE SUA_Cars_Cleaned
SET model = 'Fit'
WHERE model LIKE 'Fit%'
  AND brand = 'Honda';


UPDATE SUA_Cars_Cleaned
SET model = 'Insight'
WHERE model LIKE 'Insight%'
  AND brand = 'Honda';
UPDATE SUA_Cars_Cleaned
SET model = 'CR-Z'
WHERE model LIKE 'CR-Z%'
  AND brand = 'Honda';
UPDATE SUA_Cars_Cleaned
SET model = 'Clarity'
WHERE model LIKE 'Clarity%'
  AND brand = 'Honda';


UPDATE SUA_Cars_Cleaned
SET model = 'S2000'
WHERE model LIKE 'S2000%'
  AND brand = 'Honda';
UPDATE SUA_Cars_Cleaned
SET model = 'Prelude'
WHERE model LIKE 'Prelude%'
  AND brand = 'Honda';
UPDATE SUA_Cars_Cleaned
SET model = 'del Sol'
WHERE model LIKE '%del Sol%'
  AND brand = 'Honda';


-- ==================== HYUNDAI ====================
UPDATE SUA_Cars_Cleaned
SET model = 'Elantra Hybrid'
WHERE model LIKE '%Elantra HEV%'
  AND brand = 'Hyundai';
UPDATE SUA_Cars_Cleaned
SET model = 'Elantra GT'
WHERE model LIKE '%Elantra GT%'
  AND brand = 'Hyundai';
UPDATE SUA_Cars_Cleaned
SET model = 'Elantra'
WHERE model LIKE 'Elantra%'
  AND model NOT LIKE '%HEV%'
  AND model NOT LIKE '%Elantra GT%'
  AND brand = 'Hyundai';


UPDATE SUA_Cars_Cleaned
SET model = 'IONIQ 5'
WHERE model LIKE '%IONIQ 5%'
  AND brand = 'Hyundai';
UPDATE SUA_Cars_Cleaned
SET model = 'IONIQ EV/Hybrid'
WHERE (model LIKE '%IONIQ EV%'
    OR model LIKE '%IONIQ Hybrid%')
  AND brand = 'Hyundai';


UPDATE SUA_Cars_Cleaned
SET model = 'Sonata Hybrid/PHEV'
WHERE (model LIKE '%Sonata Hybrid%'
    OR model LIKE '%Sonata Plug-In Hybrid%')
  AND brand = 'Hyundai';
UPDATE SUA_Cars_Cleaned
SET model = 'Sonata'
WHERE model LIKE 'Sonata%'
  AND model NOT LIKE '%Hybrid%'
  AND model NOT LIKE '%Plug-In%'
  AND brand = 'Hyundai';


UPDATE SUA_Cars_Cleaned
SET model = 'Santa Fe Hybrid/PHEV'
WHERE (model LIKE '%Santa Fe HEV%'
    OR model LIKE '%Santa Fe Plug-In Hybrid%')
  AND brand = 'Hyundai';
UPDATE SUA_Cars_Cleaned
SET model = 'Santa Fe Sport'
WHERE model LIKE '%Santa Fe Sport%'
  AND brand = 'Hyundai';
UPDATE SUA_Cars_Cleaned
SET model = 'Santa Fe XL'
WHERE model LIKE '%Santa Fe XL%'
  AND brand = 'Hyundai';
UPDATE SUA_Cars_Cleaned
SET model = 'Santa Fe'
WHERE model LIKE 'Santa Fe%'
  AND model NOT LIKE '%HEV%'
  AND model NOT LIKE '%Plug-In%'
  AND model NOT LIKE '%Santa Fe Sport%'
  AND model NOT LIKE '%Santa Fe XL%'
  AND brand = 'Hyundai';

-- SUV-uri și Crossovere

UPDATE SUA_Cars_Cleaned
SET model = 'Tucson Hybrid'
WHERE model LIKE '%Tucson Hybrid%'
  AND brand = 'Hyundai';
UPDATE SUA_Cars_Cleaned
SET model = 'Tucson'
WHERE model LIKE 'Tucson%'
  AND model NOT LIKE '%Hybrid%'
  AND brand = 'Hyundai';
UPDATE SUA_Cars_Cleaned
SET model = 'Kona EV'
WHERE model LIKE '%Kona EV%'
  AND brand = 'Hyundai';
UPDATE SUA_Cars_Cleaned
SET model = 'Kona N'
WHERE model LIKE 'Kona N%'
  AND model NOT LIKE 'Kona N Line%'
  AND brand = 'Hyundai';
UPDATE SUA_Cars_Cleaned
SET model = 'Kona'
WHERE model LIKE 'Kona%'
  AND model NOT LIKE '%Kona EV%'
  AND model != 'Kona N'
  AND brand = 'Hyundai';
UPDATE SUA_Cars_Cleaned
SET model = 'Palisade'
WHERE model LIKE 'Palisade%'
  AND brand = 'Hyundai';
UPDATE SUA_Cars_Cleaned
SET model = 'Venue'
WHERE model LIKE 'Venue%'
  AND brand = 'Hyundai';
UPDATE SUA_Cars_Cleaned
SET model = 'Veracruz'
WHERE model LIKE 'Veracruz%'
  AND brand = 'Hyundai';


UPDATE SUA_Cars_Cleaned
SET model = 'Veloster N'
WHERE model LIKE '%Veloster N%'
  AND brand = 'Hyundai';
UPDATE SUA_Cars_Cleaned
SET model = 'Veloster'
WHERE model LIKE 'Veloster%'
  AND model NOT LIKE '%Veloster N%'
  AND brand = 'Hyundai';


UPDATE SUA_Cars_Cleaned
SET model = 'Genesis Coupe'
WHERE model LIKE '%Genesis Coupe%'
  AND brand = 'Hyundai';
UPDATE SUA_Cars_Cleaned
SET model = 'Genesis'
WHERE model LIKE 'Genesis%'
  AND model NOT LIKE '%Genesis Coupe%'
  AND brand = 'Hyundai';
UPDATE SUA_Cars_Cleaned
SET model = 'Equus'
WHERE model LIKE 'Equus%'
  AND brand = 'Hyundai';
UPDATE SUA_Cars_Cleaned
SET model = 'Azera'
WHERE model LIKE 'Azera%'
  AND brand = 'Hyundai';

-- Pick-up și Modele Speciale

UPDATE SUA_Cars_Cleaned
SET model = 'Santa Cruz'
WHERE model LIKE 'Santa Cruz%'
  AND brand = 'Hyundai';
UPDATE SUA_Cars_Cleaned
SET model = 'NEXO'
WHERE model LIKE 'NEXO%'
  AND brand = 'Hyundai';


UPDATE SUA_Cars_Cleaned
SET model = 'Accent'
WHERE model LIKE 'Accent%'
  AND brand = 'Hyundai';
UPDATE SUA_Cars_Cleaned
SET model = 'Tiburon'
WHERE model LIKE 'Tiburon%'
  AND brand = 'Hyundai';
UPDATE SUA_Cars_Cleaned
SET model = 'Entourage'
WHERE model LIKE 'Entourage%'
  AND brand = 'Hyundai';
UPDATE SUA_Cars_Cleaned
SET model = 'XG350'
WHERE model LIKE 'XG350%'
  AND brand = 'Hyundai';

-- ==================== INFINITI ====================
UPDATE SUA_Cars_Cleaned
SET model = 'Q50 Red Sport 400'
WHERE ((model LIKE '%Q50%' AND model LIKE '%Red Sport%') OR model LIKE 'Q50 400%')
  AND brand = 'INFINITI';
UPDATE SUA_Cars_Cleaned
SET model = 'Q50 Hybrid'
WHERE model LIKE '%Q50 Hybrid%'
  AND brand = 'INFINITI';
UPDATE SUA_Cars_Cleaned
SET model = 'Q50'
WHERE model LIKE 'Q50%'
  AND model NOT LIKE '%Red Sport%'
  AND model NOT LIKE '%Hybrid%'
  AND brand = 'INFINITI';


UPDATE SUA_Cars_Cleaned
SET model = 'Q60 Red Sport 400'
WHERE ((model LIKE '%Q60%' AND model LIKE '%Red Sport%') OR model LIKE 'Q60 400%')
  AND brand = 'INFINITI';
UPDATE SUA_Cars_Cleaned
SET model = 'Q60'
WHERE model LIKE 'Q60%'
  AND model NOT LIKE '%Red Sport%'
  AND brand = 'INFINITI';


UPDATE SUA_Cars_Cleaned
SET model = 'Q70L'
WHERE model LIKE 'Q70L%'
  AND brand = 'INFINITI';
UPDATE SUA_Cars_Cleaned
SET model = 'Q70'
WHERE model LIKE 'Q70%'
  AND model NOT LIKE 'Q70L%'
  AND brand = 'INFINITI';


UPDATE SUA_Cars_Cleaned
SET model = 'Q40'
WHERE model LIKE 'Q40%'
  AND brand = 'INFINITI';
UPDATE SUA_Cars_Cleaned
SET model = 'Q45'
WHERE model LIKE 'Q45%'
  AND brand = 'INFINITI';


UPDATE SUA_Cars_Cleaned
SET model = 'G37 IPL'
WHERE (model LIKE '%G37 IPL%' OR model LIKE '%IPL G%')
  AND brand = 'INFINITI';
UPDATE SUA_Cars_Cleaned
SET model = 'G37'
WHERE model LIKE 'G37%'
  AND model NOT LIKE '%IPL%'
  AND brand = 'INFINITI';


UPDATE SUA_Cars_Cleaned
SET model = 'G35'
WHERE model LIKE 'G35%'
  AND brand = 'INFINITI';
UPDATE SUA_Cars_Cleaned
SET model = 'G25'
WHERE model LIKE 'G25%'
  AND brand = 'INFINITI';
UPDATE SUA_Cars_Cleaned
SET model = 'G20'
WHERE model LIKE 'G20%'
  AND brand = 'INFINITI';


UPDATE SUA_Cars_Cleaned
SET model = 'M56'
WHERE model LIKE 'M56%'
  AND brand = 'INFINITI';
UPDATE SUA_Cars_Cleaned
SET model = 'M45'
WHERE model LIKE 'M45%'
  AND brand = 'INFINITI';
UPDATE SUA_Cars_Cleaned
SET model = 'M37'
WHERE model LIKE 'M37%'
  AND brand = 'INFINITI';
UPDATE SUA_Cars_Cleaned
SET model = 'M35'
WHERE model LIKE 'M35%'
  AND brand = 'INFINITI';
UPDATE SUA_Cars_Cleaned
SET model = 'M30'
WHERE model LIKE 'M30%'
  AND brand = 'INFINITI';


UPDATE SUA_Cars_Cleaned
SET model = 'I30'
WHERE model LIKE 'I30%'
  AND brand = 'INFINITI';
UPDATE SUA_Cars_Cleaned
SET model = 'I35'
WHERE model LIKE 'I35%'
  AND brand = 'INFINITI';
UPDATE SUA_Cars_Cleaned
SET model = 'J30'
WHERE model LIKE 'J30%'
  AND brand = 'INFINITI';


UPDATE SUA_Cars_Cleaned
SET model = 'QX80'
WHERE model LIKE 'QX80%'
  AND brand = 'INFINITI';
UPDATE SUA_Cars_Cleaned
SET model = 'QX70'
WHERE model LIKE 'QX70%'
  AND brand = 'INFINITI';
UPDATE SUA_Cars_Cleaned
SET model = 'QX60 Hybrid'
WHERE model LIKE 'QX60%'
  AND model LIKE '%Hybrid%'
  AND brand = 'INFINITI';
UPDATE SUA_Cars_Cleaned
SET model = 'QX60'
WHERE model LIKE 'QX60%'
  AND model NOT LIKE '%Hybrid%'
  AND brand = 'INFINITI';
UPDATE SUA_Cars_Cleaned
SET model = 'QX55'
WHERE model LIKE 'QX55%'
  AND brand = 'INFINITI';
UPDATE SUA_Cars_Cleaned
SET model = 'QX50'
WHERE model LIKE 'QX50%'
  AND brand = 'INFINITI';
UPDATE SUA_Cars_Cleaned
SET model = 'QX30'
WHERE model LIKE 'QX30%'
  AND brand = 'INFINITI';
UPDATE SUA_Cars_Cleaned
SET model = 'QX56'
WHERE model LIKE 'QX56%'
  AND brand = 'INFINITI';


UPDATE SUA_Cars_Cleaned
SET model = 'FX35'
WHERE model LIKE 'FX35%'
  AND brand = 'INFINITI';
UPDATE SUA_Cars_Cleaned
SET model = 'FX37'
WHERE model LIKE 'FX37%'
  AND brand = 'INFINITI';
UPDATE SUA_Cars_Cleaned
SET model = 'FX45'
WHERE model LIKE 'FX45%'
  AND brand = 'INFINITI';
UPDATE SUA_Cars_Cleaned
SET model = 'FX50'
WHERE model LIKE 'FX50%'
  AND brand = 'INFINITI';


UPDATE SUA_Cars_Cleaned
SET model = 'EX35'
WHERE model LIKE 'EX35%'
  AND brand = 'INFINITI';
UPDATE SUA_Cars_Cleaned
SET model = 'EX37'
WHERE model LIKE 'EX37%'
  AND brand = 'INFINITI';
UPDATE SUA_Cars_Cleaned
SET model = 'JX35'
WHERE model LIKE 'JX35%'
  AND brand = 'INFINITI';
UPDATE SUA_Cars_Cleaned
SET model = 'QX4'
WHERE model LIKE 'QX4%'
  AND brand = 'INFINITI';

-- ==================== JAGUAR ====================
UPDATE SUA_Cars_Cleaned
SET model = 'F-PACE SVR'
WHERE model LIKE '%F-PACE%'
  AND model LIKE '%SVR%'
  AND brand = 'Jaguar';
UPDATE SUA_Cars_Cleaned
SET model = 'F-PACE'
WHERE model LIKE 'F-PACE%'
  AND model NOT LIKE '%SVR%'
  AND brand = 'Jaguar';
UPDATE SUA_Cars_Cleaned
SET model = 'E-PACE'
WHERE model LIKE 'E-PACE%'
  AND brand = 'Jaguar';
UPDATE SUA_Cars_Cleaned
SET model = 'I-PACE'
WHERE model LIKE 'I-PACE%'
  AND brand = 'Jaguar';

-- Sedane Moderne (XE, XF, XJ)

UPDATE SUA_Cars_Cleaned
SET model = 'XE SV Project 8'
WHERE (model LIKE '%XE SV%' OR model LIKE '%Project 8%')
  AND brand = 'Jaguar';
UPDATE SUA_Cars_Cleaned
SET model = 'XE'
WHERE model LIKE 'XE%'
  AND model NOT LIKE '%SV%'
  AND brand = 'Jaguar';
UPDATE SUA_Cars_Cleaned
SET model = 'XF Sportbrake'
WHERE model LIKE '%XF Sportbrake%'
  AND brand = 'Jaguar';
UPDATE SUA_Cars_Cleaned
SET model = 'XF'
WHERE model LIKE 'XF%'
  AND model NOT LIKE '%Sportbrake%'
  AND brand = 'Jaguar';
UPDATE SUA_Cars_Cleaned
SET model = 'XJ6'
WHERE model LIKE 'XJ6%'
  AND brand = 'Jaguar';
UPDATE SUA_Cars_Cleaned
SET model = 'XJ8'
WHERE model LIKE '%XJ8%'
  AND brand = 'Jaguar';
UPDATE SUA_Cars_Cleaned
SET model = 'XJR'
WHERE model LIKE '%XJR%'
  AND brand = 'Jaguar';
UPDATE SUA_Cars_Cleaned
SET model = 'XJ'
WHERE model LIKE 'XJ%'
  AND model NOT LIKE 'XJ6%'
  AND model NOT LIKE 'XJ8%'
  AND model NOT LIKE 'XJR%'
  AND brand = 'Jaguar';


UPDATE SUA_Cars_Cleaned
SET model = 'F-TYPE SVR'
WHERE model LIKE '%F-TYPE%'
  AND model LIKE '%SVR%'
  AND brand = 'Jaguar';
UPDATE SUA_Cars_Cleaned
SET model = 'F-TYPE'
WHERE model LIKE 'F-TYPE%'
  AND model NOT LIKE '%SVR%'
  AND brand = 'Jaguar';
UPDATE SUA_Cars_Cleaned
SET model = 'XKR-S'
WHERE model LIKE '%XK%'
  AND model LIKE '%R-S%'
  AND brand = 'Jaguar';
UPDATE SUA_Cars_Cleaned
SET model = 'XKE'
WHERE model LIKE 'XKE%'
  AND brand = 'Jaguar';
UPDATE SUA_Cars_Cleaned
SET model = 'XKR'
WHERE (model LIKE '%XKR%' OR model LIKE 'XK R%')
  AND model NOT LIKE '%R-S%'
  AND brand = 'Jaguar';
UPDATE SUA_Cars_Cleaned
SET model = 'XK8'
WHERE model LIKE '%XK8%'
  AND brand = 'Jaguar';
UPDATE SUA_Cars_Cleaned
SET model = 'XK 120'
WHERE model LIKE 'XK 120%'
  AND brand = 'Jaguar';
UPDATE SUA_Cars_Cleaned
SET model = 'XK 140'
WHERE model LIKE 'XK 140%'
  AND brand = 'Jaguar';
UPDATE SUA_Cars_Cleaned
SET model = 'XK 150'
WHERE model LIKE 'XK 150%'
  AND brand = 'Jaguar';
UPDATE SUA_Cars_Cleaned
SET model = 'XK'
WHERE model LIKE 'XK%'
  AND model NOT LIKE 'XKE%'
  AND model NOT LIKE '%XKR%'
  AND model NOT LIKE '%XK8%'
  AND model NOT LIKE 'XK 1%'
  AND brand = 'Jaguar';


UPDATE SUA_Cars_Cleaned
SET model = 'S-Type'
WHERE model LIKE 'S-Type%'
  AND brand = 'Jaguar';
UPDATE SUA_Cars_Cleaned
SET model = 'X-Type'
WHERE model LIKE 'X-Type%'
  AND brand = 'Jaguar';
UPDATE SUA_Cars_Cleaned
SET model = 'XJS'
WHERE model LIKE 'XJS%'
  AND brand = 'Jaguar';

-- Clasice și Heritage

UPDATE SUA_Cars_Cleaned
SET model = 'Mark VIII'
WHERE model LIKE 'Mark VIII%'
  AND brand = 'Jaguar';
UPDATE SUA_Cars_Cleaned
SET model = 'Mark V'
WHERE model LIKE 'Mark V%'
  AND model NOT LIKE 'Mark VIII%'
  AND brand = 'Jaguar';
UPDATE SUA_Cars_Cleaned
SET model = 'Mark II'
WHERE model LIKE 'Mark II%'
  AND brand = 'Jaguar';
UPDATE SUA_Cars_Cleaned
SET model = '420'
WHERE model LIKE '420%'
  AND brand = 'Jaguar';
UPDATE SUA_Cars_Cleaned
SET model = 'D-Type'
WHERE model LIKE 'D-Type%'
  AND brand = 'Jaguar';
UPDATE SUA_Cars_Cleaned
SET model = 'Vanden Plas'
WHERE model LIKE 'Vanden Plas%'
  AND brand = 'Jaguar';

-- ==================== JEEP ====================
UPDATE SUA_Cars_Cleaned
SET model = 'Grand Cherokee 4xe'
WHERE model LIKE '%Grand Cherokee%'
  AND model LIKE '%4xe%'
  AND brand = 'Jeep';
UPDATE SUA_Cars_Cleaned
SET model = 'Grand Cherokee SRT/Trackhawk'
WHERE model LIKE '%Grand Cherokee%'
  AND (model LIKE '%SRT%' OR model LIKE '%Trackhawk%')
  AND brand = 'Jeep';
UPDATE SUA_Cars_Cleaned
SET model = 'Grand Cherokee L'
WHERE model LIKE 'Grand Cherokee L %'
  AND brand = 'Jeep';
UPDATE SUA_Cars_Cleaned
SET model = 'Grand Cherokee'
WHERE model LIKE 'Grand Cherokee%'
  AND model NOT LIKE '%4xe%'
  AND model NOT LIKE '%SRT%'
  AND model NOT LIKE '%Trackhawk%'
  AND model != 'Grand Cherokee L'
  AND brand = 'Jeep';


UPDATE SUA_Cars_Cleaned
SET model = 'Wrangler 4xe'
WHERE model LIKE '%Wrangler%'
  AND model LIKE '%4xe%'
  AND brand = 'Jeep';
UPDATE SUA_Cars_Cleaned
SET model = 'Wrangler Rubicon 392'
WHERE model LIKE '%Wrangler%'
  AND model LIKE '%392%'
  AND brand = 'Jeep';
UPDATE SUA_Cars_Cleaned
SET model = 'Wrangler Unlimited'
WHERE model LIKE '%Wrangler%'
  AND (model LIKE '%Unlimited%' OR model LIKE '%4-Door%')
  AND model NOT LIKE '%4xe%'
  AND brand = 'Jeep';
UPDATE SUA_Cars_Cleaned
SET model = 'Wrangler'
WHERE model LIKE 'Wrangler%'
  AND model NOT LIKE '%4xe%'
  AND model NOT LIKE '%392%'
  AND model NOT LIKE '%Unlimited%'
  AND brand = 'Jeep';

-- SUV-uri și Crossovere Moderne

UPDATE SUA_Cars_Cleaned
SET model = 'Gladiator'
WHERE model LIKE 'Gladiator%'
  AND brand = 'Jeep';
UPDATE SUA_Cars_Cleaned
SET model = 'Cherokee'
WHERE model LIKE 'Cherokee%'
  AND brand = 'Jeep';
UPDATE SUA_Cars_Cleaned
SET model = 'Compass'
WHERE (model LIKE 'Compass%' OR model LIKE 'New Compass%')
  AND brand = 'Jeep';
UPDATE SUA_Cars_Cleaned
SET model = 'Renegade'
WHERE model LIKE 'Renegade%'
  AND brand = 'Jeep';


UPDATE SUA_Cars_Cleaned
SET model = 'Grand Wagoneer'
WHERE model LIKE 'Grand Wagoneer%'
  AND brand = 'Jeep';
UPDATE SUA_Cars_Cleaned
SET model = 'Wagoneer'
WHERE model LIKE 'Wagoneer%'
  AND brand = 'Jeep';


UPDATE SUA_Cars_Cleaned
SET model = 'Liberty'
WHERE model LIKE 'Liberty%'
  AND brand = 'Jeep';
UPDATE SUA_Cars_Cleaned
SET model = 'Patriot'
WHERE model LIKE 'Patriot%'
  AND brand = 'Jeep';
UPDATE SUA_Cars_Cleaned
SET model = 'Commander'
WHERE model LIKE 'Commander%'
  AND brand = 'Jeep';

-- Clasice și Heritage

UPDATE SUA_Cars_Cleaned
SET model = 'CJ-5'
WHERE model LIKE 'CJ-5%'
  AND brand = 'Jeep';
UPDATE SUA_Cars_Cleaned
SET model = 'CJ-7'
WHERE model LIKE 'CJ-7%'
  AND brand = 'Jeep';
UPDATE SUA_Cars_Cleaned
SET model = 'Scrambler'
WHERE model LIKE '%Scrambler%'
  AND brand = 'Jeep';
UPDATE SUA_Cars_Cleaned
SET model = 'Comanche'
WHERE model LIKE 'Comanche%'
  AND brand = 'Jeep';
UPDATE SUA_Cars_Cleaned
SET model = 'J10'
WHERE model LIKE 'J10%'
  AND brand = 'Jeep';
UPDATE SUA_Cars_Cleaned
SET model = 'Jeepster'
WHERE model LIKE 'Jeepster%'
  AND brand = 'Jeep';

-- ==================== KIA ====================

-- Electrice si Hibride
UPDATE SUA_Cars_Cleaned
SET model = 'EV6 GT/GT-Line'
WHERE model LIKE 'EV6%'
  AND model LIKE '%GT%'
  AND brand = 'Kia';
UPDATE SUA_Cars_Cleaned
SET model = 'EV6'
WHERE model LIKE 'EV6%'
  AND model NOT LIKE '%GT%'
  AND brand = 'Kia';
UPDATE SUA_Cars_Cleaned
SET model = 'Niro EV'
WHERE model LIKE 'Niro EV%'
  AND brand = 'Kia';
UPDATE SUA_Cars_Cleaned
SET model = 'Niro Plug-In Hybrid'
WHERE model LIKE 'Niro Plug-In%'
  AND brand = 'Kia';
UPDATE SUA_Cars_Cleaned
SET model = 'Niro Hybrid'
WHERE model LIKE 'Niro%'
  AND model NOT LIKE 'Niro EV%'
  AND model NOT LIKE 'Niro Plug-In%'
  AND brand = 'Kia';
UPDATE SUA_Cars_Cleaned
SET model = 'Sorento Hybrid/PHEV'
WHERE model LIKE '%Sorento%'
  AND (model LIKE '%Hybrid%' OR model LIKE '%Plug-In%')
  AND brand = 'Kia';
UPDATE SUA_Cars_Cleaned
SET model = 'Sportage Hybrid/PHEV'
WHERE model LIKE '%Sportage%'
  AND (model LIKE '%Hybrid%' OR model LIKE '%Plug-In%')
  AND brand = 'Kia';
UPDATE SUA_Cars_Cleaned
SET model = 'Optima Hybrid/PHEV'
WHERE model LIKE '%Optima%'
  AND (model LIKE '%Hybrid%' OR model LIKE '%Plug-In%')
  AND brand = 'Kia';
UPDATE SUA_Cars_Cleaned
SET model = 'Soul EV'
WHERE model LIKE 'Soul EV%'
  AND brand = 'Kia';

-- Sedane și Performance

UPDATE SUA_Cars_Cleaned
SET model = 'Stinger GT'
WHERE model LIKE 'Stinger%'
  AND model LIKE '%GT%'
  AND model NOT LIKE '%GT-Line%'
  AND brand = 'Kia';
UPDATE SUA_Cars_Cleaned
SET model = 'Stinger'
WHERE model LIKE 'Stinger%'
  AND model != 'Stinger GT'
  AND brand = 'Kia';
UPDATE SUA_Cars_Cleaned
SET model = 'K5 GT/GT-Line'
WHERE model LIKE 'K5%'
  AND model LIKE '%GT%'
  AND brand = 'Kia';
UPDATE SUA_Cars_Cleaned
SET model = 'K5'
WHERE model LIKE 'K5%'
  AND model NOT LIKE '%GT%'
  AND brand = 'Kia';
UPDATE SUA_Cars_Cleaned
SET model = 'Forte GT/GT-Line'
WHERE model LIKE 'Forte%'
  AND model LIKE '%GT%'
  AND brand = 'Kia';
UPDATE SUA_Cars_Cleaned
SET model = 'Forte'
WHERE model LIKE 'Forte%'
  AND model NOT LIKE '%GT%'
  AND brand = 'Kia';
UPDATE SUA_Cars_Cleaned
SET model = 'Optima'
WHERE model LIKE 'Optima%'
  AND model NOT LIKE '%Hybrid%'
  AND model NOT LIKE '%Plug-In%'
  AND brand = 'Kia';

-- SUV-uri și Crossovere

UPDATE SUA_Cars_Cleaned
SET model = 'Telluride'
WHERE model LIKE 'Telluride%'
  AND brand = 'Kia';
UPDATE SUA_Cars_Cleaned
SET model = 'Sorento'
WHERE model LIKE 'Sorento%'
  AND model NOT LIKE '%Hybrid%'
  AND model NOT LIKE '%Plug-In%'
  AND brand = 'Kia';
UPDATE SUA_Cars_Cleaned
SET model = 'Sportage'
WHERE model LIKE 'Sportage%'
  AND model NOT LIKE '%Hybrid%'
  AND model NOT LIKE '%Plug-In%'
  AND brand = 'Kia';
UPDATE SUA_Cars_Cleaned
SET model = 'Seltos'
WHERE model LIKE 'Seltos%'
  AND brand = 'Kia';
UPDATE SUA_Cars_Cleaned
SET model = 'Soul'
WHERE model LIKE 'Soul%'
  AND model NOT LIKE '%EV%'
  AND brand = 'Kia';
UPDATE SUA_Cars_Cleaned
SET model = 'Borrego'
WHERE model LIKE 'Borrego%'
  AND brand = 'Kia';


UPDATE SUA_Cars_Cleaned
SET model = 'Rio5'
WHERE model LIKE '%Rio5%'
  AND brand = 'Kia';
UPDATE SUA_Cars_Cleaned
SET model = 'Rio'
WHERE model LIKE 'Rio%'
  AND model NOT LIKE '%Rio5%'
  AND brand = 'Kia';
UPDATE SUA_Cars_Cleaned
SET model = 'Spectra5'
WHERE model LIKE '%Spectra5%'
  AND brand = 'Kia';
UPDATE SUA_Cars_Cleaned
SET model = 'Spectra'
WHERE model LIKE 'Spectra%'
  AND model NOT LIKE '%Spectra5%'
  AND brand = 'Kia';

-- Minivan și MPV

UPDATE SUA_Cars_Cleaned
SET model = 'Carnival'
WHERE model LIKE 'Carnival%'
  AND brand = 'Kia';
UPDATE SUA_Cars_Cleaned
SET model = 'Sedona'
WHERE model LIKE 'Sedona%'
  AND brand = 'Kia';
UPDATE SUA_Cars_Cleaned
SET model = 'Rondo'
WHERE model LIKE 'Rondo%'
  AND brand = 'Kia';


UPDATE SUA_Cars_Cleaned
SET model = 'K900'
WHERE model LIKE 'K900%'
  AND brand = 'Kia';
UPDATE SUA_Cars_Cleaned
SET model = 'Cadenza'
WHERE model LIKE 'Cadenza%'
  AND brand = 'Kia';
UPDATE SUA_Cars_Cleaned
SET model = 'Amanti'
WHERE model LIKE 'Amanti%'
  AND brand = 'Kia';
UPDATE SUA_Cars_Cleaned
SET model = 'Sephia'
WHERE model LIKE 'Sephia%'
  AND brand = 'Kia';

-- ==================== LAND ROVER ====================
UPDATE SUA_Cars_Cleaned
SET model = 'Defender 90'
WHERE model LIKE 'Defender 90%'
  AND brand = 'Land Rover';
UPDATE SUA_Cars_Cleaned
SET model = 'Defender 110'
WHERE model LIKE 'Defender 110%'
  AND brand = 'Land Rover';
UPDATE SUA_Cars_Cleaned
SET model = 'Defender 130'
WHERE model LIKE 'Defender 130%'
  AND brand = 'Land Rover';
UPDATE SUA_Cars_Cleaned
SET model = 'Defender Classic'
WHERE model LIKE 'Defender%'
  AND (model LIKE '%TDI%' OR model LIKE '%COLLECTOR%' OR model LIKE '%ARKONIK%')
  AND brand = 'Land Rover';
UPDATE SUA_Cars_Cleaned
SET model = 'Defender'
WHERE model LIKE 'Defender%'
  AND model != 'Defender 90'
  AND model != 'Defender 110'
  AND model != 'Defender 130'
  AND model != 'Defender Classic'
  AND brand = 'Land Rover';


UPDATE SUA_Cars_Cleaned
SET model = 'Range Rover Sport SVR'
WHERE model LIKE '%Range Rover Sport%'
  AND model LIKE '%SVR%'
  AND brand = 'Land Rover';
UPDATE SUA_Cars_Cleaned
SET model = 'Range Rover Sport'
WHERE model LIKE '%Range Rover Sport%'
  AND model NOT LIKE '%SVR%'
  AND brand = 'Land Rover';
UPDATE SUA_Cars_Cleaned
SET model = 'Range Rover Velar'
WHERE model LIKE '%Range Rover Velar%'
  AND brand = 'Land Rover';
UPDATE SUA_Cars_Cleaned
SET model = 'Range Rover Evoque'
WHERE model LIKE '%Range Rover Evoque%'
  AND brand = 'Land Rover';
UPDATE SUA_Cars_Cleaned
SET model = 'Range Rover Classic'
WHERE model LIKE '%Range Rover%'
  AND (model LIKE '%County%' OR model LIKE '%Classic%' OR model LIKE '%2.5DSE%')
  AND brand = 'Land Rover';
UPDATE SUA_Cars_Cleaned
SET model = 'Range Rover LWB'
WHERE model LIKE '%Range Rover%'
  AND model LIKE '%LWB%'
  AND brand = 'Land Rover';
UPDATE SUA_Cars_Cleaned
SET model = 'Range Rover'
WHERE model LIKE 'Range Rover%'
  AND model NOT LIKE '%Sport%'
  AND model NOT LIKE '%Velar%'
  AND model NOT LIKE '%Evoque%'
  AND model != 'Range Rover Classic'
  AND model != 'Range Rover LWB'
  AND brand = 'Land Rover';


UPDATE SUA_Cars_Cleaned
SET model = 'Discovery Sport'
WHERE model LIKE '%Discovery Sport%'
  AND brand = 'Land Rover';
UPDATE SUA_Cars_Cleaned
SET model = 'Discovery'
WHERE model LIKE 'Discovery%'
  AND model NOT LIKE '%Discovery Sport%'
  AND brand = 'Land Rover';


UPDATE SUA_Cars_Cleaned
SET model = 'LR4'
WHERE model LIKE 'LR4%'
  AND brand = 'Land Rover';
UPDATE SUA_Cars_Cleaned
SET model = 'LR3'
WHERE model LIKE 'LR3%'
  AND brand = 'Land Rover';
UPDATE SUA_Cars_Cleaned
SET model = 'LR2'
WHERE model LIKE 'LR2%'
  AND brand = 'Land Rover';

-- Clasice și Heritage

UPDATE SUA_Cars_Cleaned
SET model = 'Series III'
WHERE model LIKE 'Series III%'
  AND brand = 'Land Rover';
UPDATE SUA_Cars_Cleaned
SET model = 'Series II'
WHERE model LIKE 'Series II%'
  AND model NOT LIKE 'Series III%'
  AND brand = 'Land Rover';

-- ==================== LEXUS ====================
UPDATE SUA_Cars_Cleaned
SET model = 'IS F/IS 500'
WHERE model LIKE 'IS%'
  AND (model LIKE '%IS-F%' OR model LIKE '%IS F%' OR model LIKE '%IS 500%')
  AND brand = 'Lexus';
UPDATE SUA_Cars_Cleaned
SET model = 'IS'
WHERE model LIKE 'IS%'
  AND model NOT LIKE '%IS-F%'
  AND model NOT LIKE '%IS F%'
  AND model NOT LIKE '%IS 500%'
  AND brand = 'Lexus';
UPDATE SUA_Cars_Cleaned
SET model = 'ES Hybrid'
WHERE model LIKE '%ES 300h%'
  AND brand = 'Lexus';
UPDATE SUA_Cars_Cleaned
SET model = 'ES'
WHERE model LIKE 'ES%'
  AND model NOT LIKE '%300h%'
  AND model NOT LIKE '%Hybrid%'
  AND brand = 'Lexus';
UPDATE SUA_Cars_Cleaned
SET model = 'GS F'
WHERE model LIKE '%GS F%'
  AND brand = 'Lexus';
UPDATE SUA_Cars_Cleaned
SET model = 'GS Hybrid'
WHERE model LIKE '%GS 450h%'
  AND brand = 'Lexus';
UPDATE SUA_Cars_Cleaned
SET model = 'GS'
WHERE model LIKE 'GS%'
  AND model NOT LIKE '%GS F%'
  AND model NOT LIKE '%Hybrid%'
  AND model NOT LIKE '%450h%'
  AND brand = 'Lexus';
UPDATE SUA_Cars_Cleaned
SET model = 'LS L'
WHERE (model LIKE 'LS 460 L%' OR model LIKE 'LS 600h L%')
  AND brand = 'Lexus';
UPDATE SUA_Cars_Cleaned
SET model = 'LS Hybrid'
WHERE model LIKE 'LS%'
  AND (model LIKE '%LS 500h%' OR model LIKE '%LS 600h%')
  AND brand = 'Lexus';
UPDATE SUA_Cars_Cleaned
SET model = 'LS'
WHERE model LIKE 'LS%'
  AND model NOT LIKE '%500h%'
  AND model NOT LIKE '%600h%'
  AND model NOT LIKE '%Hybrid%'
  AND model != 'LS L'
  AND brand = 'Lexus';
UPDATE SUA_Cars_Cleaned
SET model = 'RC F'
WHERE model LIKE '%RC F%'
  AND brand = 'Lexus';
UPDATE SUA_Cars_Cleaned
SET model = 'RC'
WHERE model LIKE 'RC%'
  AND model NOT LIKE '%RC F%'
  AND brand = 'Lexus';
UPDATE SUA_Cars_Cleaned
SET model = 'LC Hybrid'
WHERE model LIKE '%LC 500h%'
  AND brand = 'Lexus';
UPDATE SUA_Cars_Cleaned
SET model = 'LC'
WHERE model LIKE 'LC%'
  AND model NOT LIKE '%500h%'
  AND model NOT LIKE '%Hybrid%'
  AND brand = 'Lexus';

-- SUV-uri și Crossovere

UPDATE SUA_Cars_Cleaned
SET model = 'RX L'
WHERE (model LIKE 'RX 350L%' OR model LIKE 'RX 450hL%')
  AND brand = 'Lexus';
UPDATE SUA_Cars_Cleaned
SET model = 'RX Hybrid'
WHERE model LIKE 'RX%'
  AND (model LIKE '%350h%' OR model LIKE '%400h%' OR model LIKE '%450h%' OR model LIKE '%500h%')
  AND brand = 'Lexus';
UPDATE SUA_Cars_Cleaned
SET model = 'RX'
WHERE model LIKE 'RX%'
  AND model NOT LIKE '%Hybrid%'
  AND model != 'RX L'
  AND brand = 'Lexus';
UPDATE SUA_Cars_Cleaned
SET model = 'NX Hybrid/PHEV'
WHERE model LIKE 'NX%'
  AND (model LIKE '%300h%' OR model LIKE '%350h%' OR model LIKE '%450h%')
  AND brand = 'Lexus';
UPDATE SUA_Cars_Cleaned
SET model = 'NX'
WHERE model LIKE 'NX%'
  AND model NOT LIKE '%Hybrid%'
  AND model NOT LIKE '%300h%'
  AND model NOT LIKE '%350h%'
  AND model NOT LIKE '%450h%'
  AND brand = 'Lexus';
UPDATE SUA_Cars_Cleaned
SET model = 'UX Hybrid'
WHERE model LIKE '%UX 250h%'
  AND brand = 'Lexus';
UPDATE SUA_Cars_Cleaned
SET model = 'UX'
WHERE model LIKE 'UX%'
  AND model NOT LIKE '%250h%'
  AND model NOT LIKE '%Hybrid%'
  AND brand = 'Lexus';
UPDATE SUA_Cars_Cleaned
SET model = 'GX'
WHERE model LIKE 'GX%'
  AND brand = 'Lexus';
UPDATE SUA_Cars_Cleaned
SET model = 'LX'
WHERE model LIKE 'LX%'
  AND brand = 'Lexus';


UPDATE SUA_Cars_Cleaned
SET model = 'CT Hybrid'
WHERE model LIKE 'CT 200h%'
  AND brand = 'Lexus';
UPDATE SUA_Cars_Cleaned
SET model = 'HS Hybrid'
WHERE model LIKE 'HS 250h%'
  AND brand = 'Lexus';
UPDATE SUA_Cars_Cleaned
SET model = 'SC'
WHERE model LIKE 'SC%'
  AND brand = 'Lexus';

-- ==================== LINCOLN ====================
UPDATE SUA_Cars_Cleaned
SET model = 'Navigator L'
WHERE model LIKE '%Navigator L%'
  AND brand = 'Lincoln';
UPDATE SUA_Cars_Cleaned
SET model = 'Navigator'
WHERE model LIKE 'Navigator%'
  AND model NOT LIKE '%Navigator L%'
  AND brand = 'Lincoln';

UPDATE SUA_Cars_Cleaned
SET model = 'Aviator Grand Touring'
WHERE model LIKE 'Aviator%'
  AND model LIKE '%Grand Touring%'
  AND brand = 'Lincoln';
UPDATE SUA_Cars_Cleaned
SET model = 'Aviator'
WHERE model LIKE 'Aviator%'
  AND model NOT LIKE '%Grand Touring%'
  AND brand = 'Lincoln';

UPDATE SUA_Cars_Cleaned
SET model = 'Corsair Grand Touring'
WHERE model LIKE 'Corsair%'
  AND model LIKE '%Grand Touring%'
  AND brand = 'Lincoln';
UPDATE SUA_Cars_Cleaned
SET model = 'Corsair'
WHERE model LIKE 'Corsair%'
  AND model NOT LIKE '%Grand Touring%'
  AND brand = 'Lincoln';

UPDATE SUA_Cars_Cleaned
SET model = 'Nautilus'
WHERE model LIKE 'Nautilus%'
  AND brand = 'Lincoln';


UPDATE SUA_Cars_Cleaned
SET model = 'MKZ Hybrid'
WHERE model LIKE 'MKZ%'
  AND model LIKE '%Hybrid%'
  AND brand = 'Lincoln';
UPDATE SUA_Cars_Cleaned
SET model = 'MKZ'
WHERE model LIKE 'MKZ%'
  AND model NOT LIKE '%Hybrid%'
  AND brand = 'Lincoln';

UPDATE SUA_Cars_Cleaned
SET model = 'MKC'
WHERE model LIKE 'MKC%'
  AND brand = 'Lincoln';
UPDATE SUA_Cars_Cleaned
SET model = 'MKS'
WHERE model LIKE 'MKS%'
  AND brand = 'Lincoln';
UPDATE SUA_Cars_Cleaned
SET model = 'MKT'
WHERE model LIKE 'MKT%'
  AND brand = 'Lincoln';
UPDATE SUA_Cars_Cleaned
SET model = 'MKX'
WHERE model LIKE 'MKX%'
  AND brand = 'Lincoln';


UPDATE SUA_Cars_Cleaned
SET model = 'Mark VIII'
WHERE model LIKE '%Mark VIII%'
  AND brand = 'Lincoln';
UPDATE SUA_Cars_Cleaned
SET model = 'Mark VII'
WHERE model LIKE '%Mark VII%'
  AND model NOT LIKE '%Mark VIII%'
  AND brand = 'Lincoln';
UPDATE SUA_Cars_Cleaned
SET model = 'Mark VI'
WHERE model LIKE '%Mark VI%'
  AND model NOT LIKE '%Mark VII%'
  AND model NOT LIKE '%Mark VIII%'
  AND brand = 'Lincoln';
UPDATE SUA_Cars_Cleaned
SET model = 'Mark V'
WHERE model LIKE '%Mark V%'
  AND model NOT LIKE '%Mark VI%'
  AND model NOT LIKE '%Mark VII%'
  AND model NOT LIKE '%Mark VIII%'
  AND brand = 'Lincoln';
UPDATE SUA_Cars_Cleaned
SET model = 'Mark IV'
WHERE model LIKE '%Mark IV%'
  AND brand = 'Lincoln';
UPDATE SUA_Cars_Cleaned
SET model = 'Mark III'
WHERE model LIKE '%Mark III%'
  AND brand = 'Lincoln';
UPDATE SUA_Cars_Cleaned
SET model = 'Mark II'
WHERE model LIKE '%Mark II%'
  AND model NOT LIKE '%Mark III%'
  AND brand = 'Lincoln';
UPDATE SUA_Cars_Cleaned
SET model = 'Mark LT'
WHERE model LIKE 'Mark LT%'
  AND brand = 'Lincoln';

-- Sedane și modele legendare

UPDATE SUA_Cars_Cleaned
SET model = 'Continental'
WHERE model LIKE 'Continental%'
  AND model NOT LIKE '%Mark%'
  AND brand = 'Lincoln';
UPDATE SUA_Cars_Cleaned
SET model = 'Town Car'
WHERE model LIKE 'Town Car%'
  AND brand = 'Lincoln';
UPDATE SUA_Cars_Cleaned
SET model = 'LS'
WHERE model LIKE 'LS%'
  AND brand = 'Lincoln';
UPDATE SUA_Cars_Cleaned
SET model = 'Zephyr'
WHERE model LIKE 'Zephyr%'
  AND brand = 'Lincoln';


UPDATE SUA_Cars_Cleaned
SET model = 'Blackwood'
WHERE model LIKE 'Blackwood%'
  AND brand = 'Lincoln';
UPDATE SUA_Cars_Cleaned
SET model = 'Capri'
WHERE model LIKE 'Capri%'
  AND brand = 'Lincoln';
UPDATE SUA_Cars_Cleaned
SET model = 'Cosmopolitan'
WHERE model LIKE 'Cosmopolitan%'
  AND brand = 'Lincoln';
UPDATE SUA_Cars_Cleaned
SET model = 'Versailles'
WHERE model LIKE 'Versailles%'
  AND brand = 'Lincoln';

-- ==================== MAZDA ====================
UPDATE SUA_Cars_Cleaned
SET model = 'CX-90'
WHERE model LIKE 'CX-90%'
  AND brand = 'Mazda';
UPDATE SUA_Cars_Cleaned
SET model = 'CX-9'
WHERE model LIKE 'CX-9%'
  AND model NOT LIKE 'CX-90%'
  AND brand = 'Mazda';
UPDATE SUA_Cars_Cleaned
SET model = 'CX-50'
WHERE model LIKE 'CX-50%'
  AND brand = 'Mazda';
UPDATE SUA_Cars_Cleaned
SET model = 'CX-5'
WHERE model LIKE 'CX-5%'
  AND model NOT LIKE 'CX-50%'
  AND brand = 'Mazda';
UPDATE SUA_Cars_Cleaned
SET model = 'CX-30'
WHERE model LIKE 'CX-30%'
  AND brand = 'Mazda';
UPDATE SUA_Cars_Cleaned
SET model = 'CX-7'
WHERE model LIKE 'CX-7%'
  AND brand = 'Mazda';
UPDATE SUA_Cars_Cleaned
SET model = 'CX-3'
WHERE model LIKE 'CX-3%'
  AND model NOT LIKE 'CX-30%'
  AND brand = 'Mazda';


UPDATE SUA_Cars_Cleaned
SET model = 'MazdaSpeed Miata'
WHERE model LIKE 'MazdaSpeed Miata%'
  AND brand = 'Mazda';
UPDATE SUA_Cars_Cleaned
SET model = 'MazdaSpeed3'
WHERE model LIKE 'MazdaSpeed3%'
  AND brand = 'Mazda';
UPDATE SUA_Cars_Cleaned
SET model = 'MazdaSpeed6'
WHERE model LIKE 'MazdaSpeed6%'
  AND brand = 'Mazda';


UPDATE SUA_Cars_Cleaned
SET model = 'Mazda2'
WHERE model LIKE 'Mazda2%'
  AND brand = 'Mazda';
UPDATE SUA_Cars_Cleaned
SET model = 'Mazda3'
WHERE model LIKE 'Mazda3%'
  AND brand = 'Mazda';
UPDATE SUA_Cars_Cleaned
SET model = 'Mazda5'
WHERE model LIKE 'Mazda5%'
  AND brand = 'Mazda';
UPDATE SUA_Cars_Cleaned
SET model = 'Mazda6'
WHERE model LIKE 'Mazda6%'
  AND brand = 'Mazda';

-- Sport și Rotary

UPDATE SUA_Cars_Cleaned
SET model = 'MX-5 Miata'
WHERE (model LIKE 'MX-5%' OR model LIKE '%Miata%')
  AND model NOT LIKE '%MazdaSpeed%'
  AND brand = 'Mazda';
UPDATE SUA_Cars_Cleaned
SET model = 'RX-7'
WHERE model LIKE 'RX-7%'
  AND brand = 'Mazda';
UPDATE SUA_Cars_Cleaned
SET model = 'RX-8'
WHERE model LIKE 'RX-8%'
  AND brand = 'Mazda';


UPDATE SUA_Cars_Cleaned
SET model = 'MX-30'
WHERE model LIKE 'MX-30%'
  AND brand = 'Mazda';
UPDATE SUA_Cars_Cleaned
SET model = 'MX-3'
WHERE model LIKE 'MX-3%'
  AND model NOT LIKE 'MX-30%'
  AND brand = 'Mazda';
UPDATE SUA_Cars_Cleaned
SET model = 'B2000'
WHERE model LIKE 'B2000%'
  AND brand = 'Mazda';
UPDATE SUA_Cars_Cleaned
SET model = 'B2200'
WHERE model LIKE 'B2200%'
  AND brand = 'Mazda';
UPDATE SUA_Cars_Cleaned
SET model = 'B2300'
WHERE model LIKE 'B2300%'
  AND brand = 'Mazda';
UPDATE SUA_Cars_Cleaned
SET model = 'B3000'
WHERE model LIKE 'B3000%'
  AND brand = 'Mazda';
UPDATE SUA_Cars_Cleaned
SET model = 'B4000'
WHERE model LIKE 'B4000%'
  AND brand = 'Mazda';
UPDATE SUA_Cars_Cleaned
SET model = '626'
WHERE model LIKE '626%'
  AND brand = 'Mazda';
UPDATE SUA_Cars_Cleaned
SET model = '929'
WHERE model LIKE '929%'
  AND brand = 'Mazda';
UPDATE SUA_Cars_Cleaned
SET model = 'Millenia'
WHERE model LIKE 'Millenia%'
  AND brand = 'Mazda';
UPDATE SUA_Cars_Cleaned
SET model = 'Protege5'
WHERE model LIKE 'Protege5%'
  AND brand = 'Mazda';
UPDATE SUA_Cars_Cleaned
SET model = 'Protege'
WHERE model LIKE 'Protege%'
  AND model NOT LIKE 'Protege5%'
  AND brand = 'Mazda';
UPDATE SUA_Cars_Cleaned
SET model = 'Tribute'
WHERE model LIKE 'Tribute%'
  AND brand = 'Mazda';
UPDATE SUA_Cars_Cleaned
SET model = 'MPV'
WHERE model LIKE 'MPV%'
  AND brand = 'Mazda';

-- ==================== MERCEDES-BENZ ====================
UPDATE SUA_Cars_Cleaned
SET model = 'Maybach S-Class'
WHERE model LIKE 'Maybach S%'
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = 'Maybach GLS'
WHERE model LIKE 'Maybach GLS%'
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = 'SLR McLaren'
WHERE model LIKE '%SLR McLaren%'
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = 'SLS AMG'
WHERE model LIKE '%SLS AMG%'
  AND brand = 'Mercedes-Benz';

-- AMG GT (Supercar)
UPDATE SUA_Cars_Cleaned
SET model = 'AMG GT 43'
WHERE model LIKE 'AMG GT 43%'
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = 'AMG GT 53'
WHERE model LIKE 'AMG GT 53%'
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = 'AMG GT 63'
WHERE model LIKE 'AMG GT 63%'
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = 'AMG GT'
WHERE model LIKE 'AMG GT%'
  AND model NOT LIKE 'AMG GT 43%'
  AND model NOT LIKE 'AMG GT 53%'
  AND model NOT LIKE 'AMG GT 63%'
  AND brand = 'Mercedes-Benz';

-- AMG Performance
UPDATE SUA_Cars_Cleaned
SET model = 'AMG A 35'
WHERE (model LIKE 'AMG A 35%' OR model LIKE 'A-Class AMG A 35%')
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = 'AMG C 43'
WHERE (model LIKE 'AMG C 43%' OR (model LIKE 'C-Class%' AND (model LIKE '%C 43%' OR model LIKE '%C450%')))
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = 'AMG C 63'
WHERE (model LIKE 'AMG C 63%' OR model LIKE 'AMG C AMG C 63%' OR model LIKE 'AMG C S%' OR
       (model LIKE 'C-Class%' AND (model LIKE '%C 63 AMG%' OR model LIKE '%AMG C 63%')))
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = 'AMG CLA 35'
WHERE model LIKE 'AMG CLA 35%'
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = 'AMG CLA 45'
WHERE (model LIKE 'AMG CLA 45%' OR (model LIKE 'CLA-Class%' AND model LIKE '%CLA 45 AMG%'))
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = 'AMG CLS 53'
WHERE model LIKE 'AMG CLS 53%'
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = 'AMG CLS 63'
WHERE (model LIKE 'AMG CLS 63%' OR model LIKE 'AMG CLS AMG CLS 63%' OR
       (model LIKE 'CLS-Class%' AND (model LIKE '%CLS 63%' OR model LIKE '%CLS55 AMG%')))
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = 'AMG E 43'
WHERE (model LIKE 'AMG E 43%' OR (model LIKE 'E-Class%' AND model LIKE '%AMG E 43%'))
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = 'AMG E 53'
WHERE (model LIKE 'AMG E 53%' OR (model LIKE 'E-Class%' AND model LIKE '%AMG E 53%'))
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = 'AMG E 63'
WHERE (model LIKE 'AMG E 63%' OR
       (model LIKE 'E-Class%' AND (model LIKE '%E 63 AMG%' OR model LIKE '%AMG E 63%' OR model LIKE '%E55 AMG%')))
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = 'AMG EQS'
WHERE model LIKE 'AMG EQS%'
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = 'AMG G 63'
WHERE (model LIKE 'AMG G 63%' OR model LIKE 'AMG G 4MATIC%' OR model LIKE 'AMG G AMG G 63%' OR
       (model LIKE 'G-Class%' AND (model LIKE '%G 63 AMG%' OR model LIKE '%AMG G 63%')))
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = 'AMG G 65'
WHERE (model LIKE 'AMG G AMG G 65%' OR (model LIKE 'G-Class%' AND model LIKE '%G 65%'))
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = 'AMG GLA 35'
WHERE model LIKE 'AMG GLA 35%'
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = 'AMG GLA 45'
WHERE (model LIKE 'AMG GLA 45%' OR model LIKE 'AMG GLA AMG GLA 45%' OR
       (model LIKE 'GLA-Class%' AND model LIKE '%GLA 45 AMG%'))
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = 'AMG GLB 35'
WHERE model LIKE 'AMG GLB 35%'
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = 'AMG GLC 43'
WHERE model LIKE 'AMG GLC 43%'
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = 'AMG GLC 63'
WHERE model LIKE 'AMG GLC 63%'
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = 'AMG GLE 43'
WHERE model LIKE 'AMG GLE 43%'
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = 'AMG GLE 53'
WHERE model LIKE 'AMG GLE 53%'
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = 'AMG GLE 63'
WHERE (model LIKE 'AMG GLE 63%' OR model LIKE 'AMG GLE AMG GLE 63%' OR
       (model LIKE 'M-Class%' AND (model LIKE '%ML 63 AMG%' OR model LIKE '%ML63 AMG%' OR model LIKE '%ML55 AMG%')))
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = 'AMG GLS 63'
WHERE (model LIKE 'AMG GLS 63%' OR (model LIKE 'GL-Class%' AND model LIKE '%GL 63 AMG%'))
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = 'AMG S 63'
WHERE (model LIKE 'AMG S 63%' OR model LIKE 'AMG S AMG S 63%' OR (model LIKE 'S-Class%' AND
                                                                  (model LIKE '%AMG S 63%' OR model LIKE '%S 63 AMG%' OR
                                                                   model LIKE '%S55 AMG%' OR
                                                                   model LIKE '%6.0L V12 AMG%' OR
                                                                   model LIKE '%6.3L V8 AMG%')))
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = 'AMG S 65'
WHERE (model LIKE 'AMG S 65%' OR model LIKE 'AMG S AMG S 65%' OR
       (model LIKE 'S-Class%' AND (model LIKE '%S 65 AMG%' OR model LIKE '%S65 AMG%')))
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = 'AMG SL 55'
WHERE (model LIKE 'AMG SL 55%' OR (model LIKE 'SL-Class%' AND (model LIKE '%SL55 AMG%' OR model LIKE '%SL 55 AMG%')))
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = 'AMG SL 63'
WHERE (model LIKE 'AMG SL 63%' OR (model LIKE 'SL-Class%' AND (model LIKE '%SL63 AMG%' OR model LIKE '%SL 63 AMG%')))
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = 'AMG SL 65'
WHERE (model LIKE 'SL-Class%' AND (model LIKE '%SL65 AMG%' OR model LIKE '%SL 65 AMG%'))
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = 'AMG SLC 43'
WHERE (model LIKE 'AMG SLC 43%' OR (model LIKE 'SLK-Class%' AND model LIKE '%SLK32 AMG%'))
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = 'AMG CL 63'
WHERE (model LIKE 'CL-Class%' AND (model LIKE '%CL 63 AMG%' OR model LIKE '%CL63 AMG%'))
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = 'AMG CL 65'
WHERE (model LIKE 'CL-Class%' AND (model LIKE '%CL 65 AMG%' OR model LIKE '%CL65 AMG%'))
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = 'AMG CLK 63'
WHERE (model LIKE 'CLK-Class%' AND (model LIKE '%CLK 63 AMG%' OR model LIKE '%CLK63 AMG%'))
  AND brand = 'Mercedes-Benz';

-- Electrice (EQ)
UPDATE SUA_Cars_Cleaned
SET model = 'AMG EQS'
WHERE model LIKE 'AMG EQS%'
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = 'EQS'
WHERE model LIKE 'EQS%'
  AND model NOT LIKE 'AMG EQS%'
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = 'EQE'
WHERE model LIKE 'EQE%'
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = 'EQB'
WHERE model LIKE 'EQB%'
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = 'B-Class Electric'
WHERE (model LIKE 'B-Class%' OR model LIKE '%B 250e%')
  AND brand = 'Mercedes-Benz';

-- SUV-uri
UPDATE SUA_Cars_Cleaned
SET model = 'G-Class'
WHERE (model LIKE 'G-Class%' OR model LIKE 'G 550%' OR model LIKE '%G500%' OR model LIKE '%G 550%')
  AND model NOT LIKE '%AMG G 63%'
  AND model NOT LIKE '%AMG G 65%'
  AND model NOT LIKE '%G 63 AMG%'
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = 'GLS / GL-Class'
WHERE (model LIKE 'GLS%' OR model LIKE 'GL-Class%')
  AND model NOT LIKE '%AMG GLS%'
  AND model NOT LIKE '%GL 63 AMG%'
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = 'GLE / M-Class'
WHERE (model LIKE 'GLE%' OR model LIKE 'GLE-Class%' OR model LIKE 'M-Class%')
  AND model NOT LIKE '%AMG GLE%'
  AND model NOT LIKE '%ML 63 AMG%'
  AND model NOT LIKE '%ML55 AMG%'
  AND model NOT LIKE '%ML63 AMG%'
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = 'GLC / GLK'
WHERE (model LIKE 'GLC%' OR model LIKE 'GLK-Class%' OR model LIKE 'GLC-Class%')
  AND model NOT LIKE '%AMG GLC%'
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = 'GLB'
WHERE model LIKE 'GLB%'
  AND model NOT LIKE '%AMG GLB%'
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = 'GLA'
WHERE (model LIKE 'GLA%' OR model LIKE 'GLA-Class%')
  AND model NOT LIKE '%AMG GLA%'
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = 'R-Class'
WHERE model LIKE 'R-Class%'
  AND brand = 'Mercedes-Benz';

-- Sedane, Coupe-uri si Cabrio-uri
UPDATE SUA_Cars_Cleaned
SET model = 'S-Class'
WHERE (model LIKE 'S-Class%' OR model LIKE 'S %')
  AND model NOT LIKE '%Maybach%'
  AND model NOT LIKE '%AMG S%'
  AND model NOT LIKE '%S 63 AMG%'
  AND model NOT LIKE '%S 65 AMG%'
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = 'E-Class'
WHERE (model LIKE 'E-Class%' OR model LIKE 'E %')
  AND model NOT LIKE '%AMG E%'
  AND model NOT LIKE '%E 63 AMG%'
  AND model NOT LIKE '%E55 AMG%'
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = 'C-Class'
WHERE (model LIKE 'C-Class%' OR model LIKE 'C30%' OR model LIKE 'C2%' OR model LIKE 'C3%' OR model LIKE 'C4%')
  AND model NOT LIKE '%AMG C%'
  AND model NOT LIKE '%C 63 AMG%'
  AND model NOT LIKE '%C55 AMG%'
  AND model NOT LIKE '%C450 AMG%'
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = 'CLS'
WHERE (model LIKE 'CLS%' OR model LIKE 'CLS-Class%')
  AND model NOT LIKE '%AMG CLS%'
  AND model NOT LIKE '%CLS 63%'
  AND model NOT LIKE '%CLS55 AMG%'
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = 'CLA'
WHERE (model LIKE 'CLA%' OR model LIKE 'CLA-Class%')
  AND model NOT LIKE '%AMG CLA%'
  AND model NOT LIKE '%CLA 45 AMG%'
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = 'CL-Class'
WHERE model LIKE 'CL-Class%'
  AND model NOT LIKE '%AMG%'
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = 'CLK-Class'
WHERE model LIKE 'CLK-Class%'
  AND model NOT LIKE '%AMG%'
  AND model NOT LIKE '%CLK63 AMG%'
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = 'A-Class'
WHERE model LIKE 'A-Class%'
  AND model NOT LIKE '%AMG A%'
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = 'SL-Class'
WHERE (model LIKE 'SL-Class%' OR model LIKE 'SL 4%' OR model LIKE 'SL 5%')
  AND model NOT LIKE '%AMG SL%'
  AND model NOT LIKE '%SL55 AMG%'
  AND model NOT LIKE '%SL63 AMG%'
  AND model NOT LIKE '%SL65 AMG%'
  AND model NOT LIKE '%SLR McLaren%'
  AND model NOT LIKE '%SLS AMG%'
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = 'SLC'
WHERE model LIKE 'SLC%'
  AND model NOT LIKE '%AMG SLC%'
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = 'SLK-Class'
WHERE model LIKE 'SLK-Class%'
  AND model NOT LIKE '%SLK32 AMG%'
  AND model NOT LIKE '%SLK55 AMG%'
  AND brand = 'Mercedes-Benz';

-- Vehicule Comerciale
UPDATE SUA_Cars_Cleaned
SET model = 'Sprinter 4500'
WHERE model LIKE 'Sprinter 4500%'
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = 'Sprinter 3500XD'
WHERE model LIKE 'Sprinter 3500XD%'
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = 'Sprinter 3500'
WHERE model LIKE 'Sprinter 3500%'
  AND model NOT LIKE 'Sprinter 3500XD%'
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = 'Sprinter 2500'
WHERE model LIKE 'Sprinter 2500%'
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = 'Sprinter 1500'
WHERE model LIKE 'Sprinter 1500%'
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = 'Sprinter'
WHERE model LIKE 'Sprinter%'
  AND model NOT LIKE 'Sprinter 1500%'
  AND model NOT LIKE 'Sprinter 2500%'
  AND model NOT LIKE 'Sprinter 3500%'
  AND model NOT LIKE 'Sprinter 4500%'
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = 'Metris'
WHERE model LIKE 'Metris%'
  AND brand = 'Mercedes-Benz';

-- Clasice
UPDATE SUA_Cars_Cleaned
SET model = '190SL'
WHERE model LIKE '190SL%'
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = '230SL'
WHERE model LIKE '230SL%'
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = '240'
WHERE model LIKE '240%'
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = '280SE'
WHERE model LIKE '280SE%'
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = '280SL'
WHERE model LIKE '280SL%'
  AND brand = 'Mercedes-Benz';
UPDATE SUA_Cars_Cleaned
SET model = '450SL'
WHERE model LIKE '450SL%'
  AND brand = 'Mercedes-Benz';

-- ==================== MITSUBISHI ====================

UPDATE SUA_Cars_Cleaned
SET model = 'Eclipse Cross'
WHERE model LIKE 'Eclipse Cross%'
  AND brand = 'Mitsubishi';

UPDATE SUA_Cars_Cleaned
SET model = 'Outlander PHEV'
WHERE model LIKE 'Outlander PHEV%'
  AND brand = 'Mitsubishi';

UPDATE SUA_Cars_Cleaned
SET model = 'Outlander Sport'
WHERE model LIKE 'Outlander Sport%'
  AND brand = 'Mitsubishi';

UPDATE SUA_Cars_Cleaned
SET model = 'Outlander'
WHERE model LIKE 'Outlander%'
  AND model NOT LIKE 'Outlander PHEV%'
  AND model NOT LIKE 'Outlander Sport%'
  AND brand = 'Mitsubishi';

UPDATE SUA_Cars_Cleaned
SET model = 'Montero Sport'
WHERE model LIKE 'Montero Sport%'
  AND brand = 'Mitsubishi';

UPDATE SUA_Cars_Cleaned
SET model = 'Montero'
WHERE model LIKE 'Montero%'
  AND model NOT LIKE 'Montero Sport%'
  AND brand = 'Mitsubishi';

UPDATE SUA_Cars_Cleaned
SET model = 'Endeavor'
WHERE model LIKE 'Endeavor%'
  AND brand = 'Mitsubishi';


UPDATE SUA_Cars_Cleaned
SET model = 'Lancer Evolution'
WHERE model LIKE 'Lancer Evolution%'
  AND brand = 'Mitsubishi';
UPDATE SUA_Cars_Cleaned
SET model = '3000GT'
WHERE model LIKE '3000GT%'
  AND brand = 'Mitsubishi';

UPDATE SUA_Cars_Cleaned
SET model = 'Eclipse'
WHERE model LIKE 'Eclipse%'
  AND model NOT LIKE 'Eclipse Cross%'
  AND brand = 'Mitsubishi';


UPDATE SUA_Cars_Cleaned
SET model = 'Lancer Sportback'
WHERE model LIKE 'Lancer Sportback%'
  AND brand = 'Mitsubishi';

UPDATE SUA_Cars_Cleaned
SET model = 'Lancer'
WHERE model LIKE 'Lancer%'
  AND model NOT LIKE 'Lancer Evolution%'
  AND model NOT LIKE 'Lancer Sportback%'
  AND brand = 'Mitsubishi';

UPDATE SUA_Cars_Cleaned
SET model = 'Mirage G4'
WHERE model LIKE 'Mirage G4%'
  AND brand = 'Mitsubishi';

UPDATE SUA_Cars_Cleaned
SET model = 'Mirage'
WHERE model LIKE 'Mirage%'
  AND model NOT LIKE 'Mirage G4%'
  AND brand = 'Mitsubishi';

UPDATE SUA_Cars_Cleaned
SET model = 'Galant'
WHERE model LIKE 'Galant%'
  AND brand = 'Mitsubishi';
UPDATE SUA_Cars_Cleaned
SET model = 'Diamante'
WHERE model LIKE 'Diamante%'
  AND brand = 'Mitsubishi';

-- Electrice
UPDATE SUA_Cars_Cleaned
SET model = 'i-MiEV'
WHERE model LIKE 'i-MiEV%'
  AND brand = 'Mitsubishi';

UPDATE SUA_Cars_Cleaned
SET model = 'Raider'
WHERE model LIKE 'Raider%'
  AND brand = 'Mitsubishi';
UPDATE SUA_Cars_Cleaned
SET model = 'Sigma'
WHERE model LIKE 'Sigma%'
  AND brand = 'Mitsubishi';
UPDATE SUA_Cars_Cleaned
SET model = 'Pickup Truck'
WHERE model LIKE 'Pickup Truck%'
  AND brand = 'Mitsubishi';

-- ==================== NISSAN ====================

UPDATE SUA_Cars_Cleaned
SET model = 'GT-R'
WHERE model LIKE 'GT-R%'
  AND brand = 'Nissan';
UPDATE SUA_Cars_Cleaned
SET model = '370Z'
WHERE model LIKE '370Z%'
  AND brand = 'Nissan';
UPDATE SUA_Cars_Cleaned
SET model = '350Z'
WHERE model LIKE '350Z%'
  AND brand = 'Nissan';
UPDATE SUA_Cars_Cleaned
SET model = '300ZX'
WHERE model LIKE '300ZX%'
  AND brand = 'Nissan';
UPDATE SUA_Cars_Cleaned
SET model = 'Z'
WHERE (model LIKE 'Z Performance%' OR model LIKE 'Z Proto%' OR model LIKE 'Z Sport%')
  AND brand = 'Nissan';
UPDATE SUA_Cars_Cleaned
SET model = '280ZX'
WHERE model LIKE '280ZX%'
  AND brand = 'Nissan';
UPDATE SUA_Cars_Cleaned
SET model = '240'
WHERE model LIKE '240%'
  AND brand = 'Nissan';
UPDATE SUA_Cars_Cleaned
SET model = '200SX'
WHERE model LIKE '200SX%'
  AND brand = 'Nissan';

-- SUV-uri si Crossovere

UPDATE SUA_Cars_Cleaned
SET model = 'Rogue Sport'
WHERE model LIKE 'Rogue Sport%'
  AND brand = 'Nissan';
UPDATE SUA_Cars_Cleaned
SET model = 'Rogue'
WHERE model LIKE 'Rogue%'
  AND model NOT LIKE 'Rogue Sport%'
  AND brand = 'Nissan';
UPDATE SUA_Cars_Cleaned
SET model = 'Pathfinder Hybrid'
WHERE model LIKE 'Pathfinder Hybrid%'
  AND brand = 'Nissan';
UPDATE SUA_Cars_Cleaned
SET model = 'Pathfinder'
WHERE model LIKE 'Pathfinder%'
  AND model NOT LIKE 'Pathfinder Hybrid%'
  AND brand = 'Nissan';
UPDATE SUA_Cars_Cleaned
SET model = 'Murano'
WHERE model LIKE 'Murano%'
  AND brand = 'Nissan';
UPDATE SUA_Cars_Cleaned
SET model = 'Armada'
WHERE model LIKE 'Armada%'
  AND brand = 'Nissan';
UPDATE SUA_Cars_Cleaned
SET model = 'Kicks'
WHERE model LIKE 'Kicks%'
  AND brand = 'Nissan';
UPDATE SUA_Cars_Cleaned
SET model = 'Juke'
WHERE model LIKE 'Juke%'
  AND brand = 'Nissan';
UPDATE SUA_Cars_Cleaned
SET model = 'Xterra'
WHERE model LIKE 'Xterra%'
  AND brand = 'Nissan';


UPDATE SUA_Cars_Cleaned
SET model = 'Altima Hybrid'
WHERE model LIKE 'Altima Hybrid%'
  AND brand = 'Nissan';
UPDATE SUA_Cars_Cleaned
SET model = 'Altima'
WHERE model LIKE 'Altima%'
  AND model NOT LIKE 'Altima Hybrid%'
  AND brand = 'Nissan';
UPDATE SUA_Cars_Cleaned
SET model = 'Maxima'
WHERE model LIKE 'Maxima%'
  AND brand = 'Nissan';
UPDATE SUA_Cars_Cleaned
SET model = 'Sentra'
WHERE model LIKE 'Sentra%'
  AND brand = 'Nissan';
UPDATE SUA_Cars_Cleaned
SET model = 'Versa Note'
WHERE model LIKE 'Versa Note%'
  AND brand = 'Nissan';
UPDATE SUA_Cars_Cleaned
SET model = 'Versa'
WHERE model LIKE 'Versa%'
  AND model NOT LIKE 'Versa Note%'
  AND brand = 'Nissan';

-- Electrice

UPDATE SUA_Cars_Cleaned
SET model = 'Leaf'
WHERE model LIKE 'Leaf%'
  AND brand = 'Nissan';
UPDATE SUA_Cars_Cleaned
SET model = 'Ariya'
WHERE model LIKE 'ARIYA%'
  AND brand = 'Nissan';


UPDATE SUA_Cars_Cleaned
SET model = 'Titan XD'
WHERE model LIKE 'Titan XD%'
  AND brand = 'Nissan';
UPDATE SUA_Cars_Cleaned
SET model = 'Titan'
WHERE model LIKE 'Titan%'
  AND model NOT LIKE 'Titan XD%'
  AND brand = 'Nissan';
UPDATE SUA_Cars_Cleaned
SET model = 'Frontier'
WHERE model LIKE 'Frontier%'
  AND brand = 'Nissan';


UPDATE SUA_Cars_Cleaned
SET model = 'NV Passenger'
WHERE model LIKE 'NV Passenger%'
  AND brand = 'Nissan';
UPDATE SUA_Cars_Cleaned
SET model = 'NV Cargo'
WHERE model LIKE 'NV Cargo%'
  AND brand = 'Nissan';
UPDATE SUA_Cars_Cleaned
SET model = 'NV200'
WHERE model LIKE 'NV200%'
  AND brand = 'Nissan';
UPDATE SUA_Cars_Cleaned
SET model = 'Quest'
WHERE model LIKE 'Quest%'
  AND brand = 'Nissan';
UPDATE SUA_Cars_Cleaned
SET model = 'Cube'
WHERE model LIKE 'Cube%'
  AND brand = 'Nissan';

-- Clasice / Diverse

UPDATE SUA_Cars_Cleaned
SET model = 'NX'
WHERE model LIKE 'NX%'
  AND brand = 'Nissan';

-- ==================== PORSCHE ====================

UPDATE SUA_Cars_Cleaned
SET model = '911 GT'
WHERE model LIKE '911%'
  AND (model LIKE '%GT2%' OR model LIKE '%GT3%' OR model LIKE '%GT4%' OR model LIKE '%Cup%' OR model LIKE '%RSR%')
  AND brand = 'Porsche';
UPDATE SUA_Cars_Cleaned
SET model = '911 Turbo'
WHERE model LIKE '911%'
  AND model LIKE '%Turbo%'
  AND brand = 'Porsche';
UPDATE SUA_Cars_Cleaned
SET model = '911 Targa'
WHERE model LIKE '911%'
  AND model LIKE '%Targa%'
  AND brand = 'Porsche';
UPDATE SUA_Cars_Cleaned
SET model = '911 Carrera'
WHERE model LIKE '911%'
  AND model NOT LIKE '%GT2%'
  AND model NOT LIKE '%GT3%'
  AND model NOT LIKE '%GT4%'
  AND model NOT LIKE '%Cup%'
  AND model NOT LIKE '%RSR%'
  AND model NOT LIKE '%Turbo%'
  AND model NOT LIKE '%Targa%'
  AND brand = 'Porsche';


UPDATE SUA_Cars_Cleaned
SET model = '718 Spyder'
WHERE model LIKE '718 Spyder%'
  AND brand = 'Porsche';
UPDATE SUA_Cars_Cleaned
SET model = '718 Cayman'
WHERE model LIKE '718 Cayman%'
  AND brand = 'Porsche';
UPDATE SUA_Cars_Cleaned
SET model = '718 Boxster'
WHERE model LIKE '718 Boxster%'
  AND brand = 'Porsche';

UPDATE SUA_Cars_Cleaned
SET model = 'Boxster'
WHERE model LIKE 'Boxster%'
  AND model NOT LIKE '718%'
  AND brand = 'Porsche';
UPDATE SUA_Cars_Cleaned
SET model = 'Cayman'
WHERE model LIKE 'Cayman%'
  AND model NOT LIKE '718%'
  AND brand = 'Porsche';


UPDATE SUA_Cars_Cleaned
SET model = 'Panamera Sport Turismo'
WHERE model LIKE 'Panamera%'
  AND model LIKE '%Sport Turismo%'
  AND brand = 'Porsche';
UPDATE SUA_Cars_Cleaned
SET model = 'Panamera Executive'
WHERE model LIKE 'Panamera%'
  AND model LIKE '%Executive%'
  AND model NOT LIKE '%Sport Turismo%'
  AND brand = 'Porsche';
UPDATE SUA_Cars_Cleaned
SET model = 'Panamera Hybrid'
WHERE model LIKE 'Panamera%'
  AND (model LIKE '%E-Hybrid%' OR model LIKE '%Hybrid S%')
  AND model NOT LIKE '%Sport Turismo%'
  AND model NOT LIKE '%Executive%'
  AND brand = 'Porsche';
UPDATE SUA_Cars_Cleaned
SET model = 'Panamera'
WHERE model LIKE 'Panamera%'
  AND model NOT LIKE '%Sport Turismo%'
  AND model NOT LIKE '%Executive%'
  AND model NOT LIKE '%E-Hybrid%'
  AND model NOT LIKE '%Hybrid S%'
  AND brand = 'Porsche';


UPDATE SUA_Cars_Cleaned
SET model = 'Taycan Cross Turismo'
WHERE model LIKE 'Taycan%'
  AND model LIKE '%Cross Turismo%'
  AND brand = 'Porsche';
UPDATE SUA_Cars_Cleaned
SET model = 'Taycan'
WHERE model LIKE 'Taycan%'
  AND model NOT LIKE '%Cross Turismo%'
  AND brand = 'Porsche';

-- SUV-uri

UPDATE SUA_Cars_Cleaned
SET model = 'Cayenne Coupe'
WHERE model LIKE 'Cayenne%'
  AND model LIKE '%Coupe%'
  AND brand = 'Porsche';
UPDATE SUA_Cars_Cleaned
SET model = 'Cayenne Hybrid'
WHERE model LIKE 'Cayenne%'
  AND (model LIKE '%E-Hybrid%' OR model LIKE '%Hybrid S%')
  AND model NOT LIKE '%Coupe%'
  AND brand = 'Porsche';
UPDATE SUA_Cars_Cleaned
SET model = 'Cayenne'
WHERE model LIKE 'Cayenne%'
  AND model NOT LIKE '%Coupe%'
  AND model NOT LIKE '%E-Hybrid%'
  AND model NOT LIKE '%Hybrid S%'
  AND brand = 'Porsche';
UPDATE SUA_Cars_Cleaned
SET model = 'Macan'
WHERE model LIKE 'Macan%'
  AND brand = 'Porsche';


UPDATE SUA_Cars_Cleaned
SET model = 'Carrera GT'
WHERE model LIKE 'Carrera GT%'
  AND brand = 'Porsche';
UPDATE SUA_Cars_Cleaned
SET model = '918 Spyder'
WHERE model LIKE '918%'
  AND brand = 'Porsche';
UPDATE SUA_Cars_Cleaned
SET model = '356'
WHERE model LIKE '356%'
  AND brand = 'Porsche';
UPDATE SUA_Cars_Cleaned
SET model = '912'
WHERE model LIKE '912%'
  AND brand = 'Porsche';
UPDATE SUA_Cars_Cleaned
SET model = '914'
WHERE model LIKE '914%'
  AND brand = 'Porsche';
UPDATE SUA_Cars_Cleaned
SET model = '924'
WHERE model LIKE '924%'
  AND brand = 'Porsche';
UPDATE SUA_Cars_Cleaned
SET model = '928'
WHERE model LIKE '928%'
  AND brand = 'Porsche';
UPDATE SUA_Cars_Cleaned
SET model = '930'
WHERE model LIKE '930%'
  AND brand = 'Porsche';
UPDATE SUA_Cars_Cleaned
SET model = '944'
WHERE model LIKE '944%'
  AND brand = 'Porsche';
UPDATE SUA_Cars_Cleaned
SET model = '968'
WHERE model LIKE '968%'
  AND brand = 'Porsche';

-- ==================== RAM ====================
UPDATE SUA_Cars_Cleaned
SET model = '1500 Classic'
WHERE (model LIKE '1500 Classic%' OR model LIKE '1500 Warlock%')
  AND brand = 'Ram';

UPDATE SUA_Cars_Cleaned
SET model = '1500 TRX'
WHERE model LIKE '1500 TRX%'
  AND brand = 'Ram';

UPDATE SUA_Cars_Cleaned
SET model = '1500'
WHERE model LIKE '1500%'
  AND model NOT LIKE '1500 Classic%'
  AND model NOT LIKE '1500 Warlock%'
  AND model NOT LIKE '1500 TRX%'
  AND brand = 'Ram';


UPDATE SUA_Cars_Cleaned
SET model = '2500'
WHERE model LIKE '2500%'
  AND brand = 'Ram';
UPDATE SUA_Cars_Cleaned
SET model = '3500'
WHERE model LIKE '3500%'
  AND brand = 'Ram';


UPDATE SUA_Cars_Cleaned
SET model = 'ProMaster City'
WHERE model LIKE 'ProMaster City%'
  AND brand = 'Ram';

UPDATE SUA_Cars_Cleaned
SET model = 'ProMaster 1500'
WHERE model LIKE 'ProMaster 1500%'
  AND brand = 'Ram';
UPDATE SUA_Cars_Cleaned
SET model = 'ProMaster 2500'
WHERE model LIKE 'ProMaster 2500%'
  AND brand = 'Ram';
UPDATE SUA_Cars_Cleaned
SET model = 'ProMaster 3500'
WHERE model LIKE 'ProMaster 3500%'
  AND brand = 'Ram';

UPDATE SUA_Cars_Cleaned
SET model = 'Cargo C/V'
WHERE (model LIKE 'Cargo C/V%' OR model LIKE 'Cargo Tradesman%')
  AND brand = 'Ram';


-- ==================== SUBARU ====================

UPDATE SUA_Cars_Cleaned
SET model = 'WRX STI'
WHERE (model LIKE '%WRX STI%' OR model LIKE '%WRX STi%' OR model LIKE '%STI S209%' OR model LIKE '%WRX S209%' OR
       model LIKE 'STI S209%')
  AND brand = 'Subaru';
UPDATE SUA_Cars_Cleaned
SET model = 'WRX'
WHERE (model LIKE 'WRX%' OR model LIKE 'Impreza WRX%')
  AND model NOT LIKE '%STI%'
  AND model NOT LIKE '%STi%'
  AND model NOT LIKE '%S209%'
  AND brand = 'Subaru';

-- SUV-uri

UPDATE SUA_Cars_Cleaned
SET model = 'Outback'
WHERE (model LIKE 'Outback%' OR model LIKE 'Legacy Outback%' OR model LIKE 'Impreza Outback%')
  AND brand = 'Subaru';

UPDATE SUA_Cars_Cleaned
SET model = 'Crosstrek'
WHERE (model LIKE 'Crosstrek%' OR model LIKE 'XV Crosstrek%')
  AND brand = 'Subaru';

UPDATE SUA_Cars_Cleaned
SET model = 'Forester'
WHERE model LIKE 'Forester%'
  AND brand = 'Subaru';
UPDATE SUA_Cars_Cleaned
SET model = 'Ascent'
WHERE model LIKE 'Ascent%'
  AND brand = 'Subaru';

UPDATE SUA_Cars_Cleaned
SET model = 'Tribeca'
WHERE (model LIKE 'Tribeca%' OR model LIKE 'B9 Tribeca%')
  AND brand = 'Subaru';

-- Sedane si Hatchback-uri

UPDATE SUA_Cars_Cleaned
SET model = 'Impreza'
WHERE model LIKE 'Impreza%'
  AND model NOT LIKE '%WRX%'
  AND model NOT LIKE '%STI%'
  AND model NOT LIKE '%STi%'
  AND model NOT LIKE '%Outback%'
  AND brand = 'Subaru';

-- Sedane
UPDATE SUA_Cars_Cleaned
SET model = 'Legacy'
WHERE model LIKE 'Legacy%'
  AND model NOT LIKE 'Legacy Outback%'
  AND brand = 'Subaru';


UPDATE SUA_Cars_Cleaned
SET model = 'BRZ'
WHERE model LIKE 'BRZ%'
  AND brand = 'Subaru';
UPDATE SUA_Cars_Cleaned
SET model = 'Solterra'
WHERE model LIKE 'Solterra%'
  AND brand = 'Subaru';
UPDATE SUA_Cars_Cleaned
SET model = 'Baja'
WHERE model LIKE 'Baja%'
  AND brand = 'Subaru';
UPDATE SUA_Cars_Cleaned
SET model = 'Brat'
WHERE model LIKE 'Brat%'
  AND brand = 'Subaru';
UPDATE SUA_Cars_Cleaned
SET model = 'SVX'
WHERE model LIKE 'SVX%'
  AND brand = 'Subaru';
UPDATE SUA_Cars_Cleaned
SET model = 'DL'
WHERE model LIKE 'DL%'
  AND brand = 'Subaru';

-- ==================== TESLA ====================

UPDATE SUA_Cars_Cleaned
SET model = 'Model 3'
WHERE model LIKE 'Model 3%'
  AND brand = 'Tesla';
UPDATE SUA_Cars_Cleaned
SET model = 'Model S'
WHERE model LIKE 'Model S%'
  AND brand = 'Tesla';
UPDATE SUA_Cars_Cleaned
SET model = 'Model X'
WHERE model LIKE 'Model X%'
  AND brand = 'Tesla';
UPDATE SUA_Cars_Cleaned
SET model = 'Model Y'
WHERE model LIKE 'Model Y%'
  AND brand = 'Tesla';
UPDATE SUA_Cars_Cleaned
SET model = 'Roadster'
WHERE model LIKE 'Roadster%'
  AND brand = 'Tesla';

-- ==================== TOYOTA ====================

UPDATE SUA_Cars_Cleaned
SET model = 'Prius Prime'
WHERE (model LIKE 'Prius Prime%' OR model LIKE 'Prius Plug-in%')
  AND brand = 'Toyota';
UPDATE SUA_Cars_Cleaned
SET model = 'Prius c'
WHERE model LIKE 'Prius c%'
  AND brand = 'Toyota';
UPDATE SUA_Cars_Cleaned
SET model = 'Prius v'
WHERE model LIKE 'Prius v%'
  AND brand = 'Toyota';
UPDATE SUA_Cars_Cleaned
SET model = 'Prius'
WHERE model LIKE 'Prius%'
  AND model NOT LIKE 'Prius Prime%'
  AND model NOT LIKE 'Prius Plug-in%'
  AND model NOT LIKE 'Prius c%'
  AND model NOT LIKE 'Prius v%'
  AND brand = 'Toyota';


UPDATE SUA_Cars_Cleaned
SET model = 'Corolla Cross'
WHERE model LIKE 'Corolla Cross%'
  AND brand = 'Toyota';
UPDATE SUA_Cars_Cleaned
SET model = 'GR Corolla'
WHERE model LIKE 'GR Corolla%'
  AND brand = 'Toyota';
UPDATE SUA_Cars_Cleaned
SET model = 'Corolla Hatchback'
WHERE (model LIKE 'Corolla Hatchback%' OR model LIKE 'Corolla iM%')
  AND brand = 'Toyota';
UPDATE SUA_Cars_Cleaned
SET model = 'Corolla Hybrid'
WHERE model LIKE 'Corolla Hybrid%'
  AND brand = 'Toyota';
UPDATE SUA_Cars_Cleaned
SET model = 'Corolla'
WHERE model LIKE 'Corolla%'
  AND model NOT LIKE 'Corolla Cross%'
  AND model NOT LIKE 'Corolla Hatchback%'
  AND model NOT LIKE 'Corolla iM%'
  AND model NOT LIKE 'Corolla Hybrid%'
  AND brand = 'Toyota';


UPDATE SUA_Cars_Cleaned
SET model = 'Camry Solara'
WHERE model LIKE 'Camry Solara%'
  AND brand = 'Toyota';
UPDATE SUA_Cars_Cleaned
SET model = 'Camry Hybrid'
WHERE model LIKE 'Camry Hybrid%'
  AND brand = 'Toyota';
UPDATE SUA_Cars_Cleaned
SET model = 'Camry'
WHERE model LIKE 'Camry%'
  AND model NOT LIKE 'Camry Solara%'
  AND model NOT LIKE 'Camry Hybrid%'
  AND brand = 'Toyota';

-- SUV-uri si Crossovere

UPDATE SUA_Cars_Cleaned
SET model = 'RAV4 Prime'
WHERE model LIKE 'RAV4 Prime%'
  AND brand = 'Toyota';
UPDATE SUA_Cars_Cleaned
SET model = 'RAV4 Hybrid'
WHERE (model LIKE 'RAV4 Hybrid%' OR model LIKE 'RAV4 EV%')
  AND brand = 'Toyota';
UPDATE SUA_Cars_Cleaned
SET model = 'RAV4'
WHERE model LIKE 'RAV4%'
  AND model NOT LIKE 'RAV4 Prime%'
  AND model NOT LIKE 'RAV4 Hybrid%'
  AND model NOT LIKE 'RAV4 EV%'
  AND brand = 'Toyota';

UPDATE SUA_Cars_Cleaned
SET model = 'Highlander Hybrid'
WHERE model LIKE 'Highlander Hybrid%'
  AND brand = 'Toyota';
UPDATE SUA_Cars_Cleaned
SET model = 'Highlander'
WHERE model LIKE 'Highlander%'
  AND model NOT LIKE 'Highlander Hybrid%'
  AND brand = 'Toyota';

UPDATE SUA_Cars_Cleaned
SET model = 'Land Cruiser'
WHERE model LIKE 'Land Cruiser%'
  AND brand = 'Toyota';
UPDATE SUA_Cars_Cleaned
SET model = 'bZ4X'
WHERE model LIKE 'bZ4X%'
  AND brand = 'Toyota';
UPDATE SUA_Cars_Cleaned
SET model = 'C-HR'
WHERE model LIKE 'C-HR%'
  AND brand = 'Toyota';
UPDATE SUA_Cars_Cleaned
SET model = 'Venza'
WHERE model LIKE 'Venza%'
  AND brand = 'Toyota';
UPDATE SUA_Cars_Cleaned
SET model = 'Sequoia'
WHERE model LIKE 'Sequoia%'
  AND brand = 'Toyota';
UPDATE SUA_Cars_Cleaned
SET model = '4Runner'
WHERE model LIKE '4Runner%'
  AND brand = 'Toyota';
UPDATE SUA_Cars_Cleaned
SET model = 'FJ Cruiser'
WHERE model LIKE 'FJ Cruiser%'
  AND brand = 'Toyota';


UPDATE SUA_Cars_Cleaned
SET model = 'Tundra Hybrid'
WHERE model LIKE 'Tundra Hybrid%'
  AND brand = 'Toyota';
UPDATE SUA_Cars_Cleaned
SET model = 'Tundra'
WHERE model LIKE 'Tundra%'
  AND model NOT LIKE 'Tundra Hybrid%'
  AND brand = 'Toyota';
UPDATE SUA_Cars_Cleaned
SET model = 'Tacoma'
WHERE model LIKE 'Tacoma%'
  AND brand = 'Toyota';
UPDATE SUA_Cars_Cleaned
SET model = 'T100'
WHERE model LIKE 'T100%'
  AND brand = 'Toyota';
UPDATE SUA_Cars_Cleaned
SET model = 'Pickup Truck'
WHERE model LIKE 'Pickup Truck%'
  AND brand = 'Toyota';


UPDATE SUA_Cars_Cleaned
SET model = 'Supra'
WHERE model LIKE 'Supra%'
  AND brand = 'Toyota';
UPDATE SUA_Cars_Cleaned
SET model = 'GR86'
WHERE model LIKE 'GR86%'
  AND brand = 'Toyota';
UPDATE SUA_Cars_Cleaned
SET model = '86'
WHERE model LIKE '86%'
  AND model NOT LIKE 'GR86%'
  AND brand = 'Toyota';
UPDATE SUA_Cars_Cleaned
SET model = 'Celica'
WHERE model LIKE 'Celica%'
  AND brand = 'Toyota';
UPDATE SUA_Cars_Cleaned
SET model = 'MR2'
WHERE model LIKE 'MR2%'
  AND brand = 'Toyota';

-- Sedane, Hatchback-uri si Minivan-uri

UPDATE SUA_Cars_Cleaned
SET model = 'Avalon Hybrid'
WHERE model LIKE 'Avalon Hybrid%'
  AND brand = 'Toyota';
UPDATE SUA_Cars_Cleaned
SET model = 'Avalon'
WHERE model LIKE 'Avalon%'
  AND model NOT LIKE 'Avalon Hybrid%'
  AND brand = 'Toyota';

UPDATE SUA_Cars_Cleaned
SET model = 'Crown'
WHERE model LIKE 'Crown%'
  AND brand = 'Toyota';
UPDATE SUA_Cars_Cleaned
SET model = 'Mirai'
WHERE model LIKE 'Mirai%'
  AND brand = 'Toyota';
UPDATE SUA_Cars_Cleaned
SET model = 'Matrix'
WHERE model LIKE 'Matrix%'
  AND brand = 'Toyota';
UPDATE SUA_Cars_Cleaned
SET model = 'Sienna'
WHERE model LIKE 'Sienna%'
  AND brand = 'Toyota';

UPDATE SUA_Cars_Cleaned
SET model = 'Yaris'
WHERE (model LIKE 'Yaris%' OR model LIKE 'ECHO%')
  AND brand = 'Toyota';

UPDATE SUA_Cars_Cleaned
SET model = 'Tercel'
WHERE model LIKE 'Tercel%'
  AND brand = 'Toyota';
UPDATE SUA_Cars_Cleaned
SET model = 'Corona'
WHERE model LIKE 'Corona%'
  AND brand = 'Toyota';
UPDATE SUA_Cars_Cleaned
SET model = 'Cressida'
WHERE model LIKE 'Cressida%'
  AND brand = 'Toyota';
UPDATE SUA_Cars_Cleaned
SET model = 'Previa'
WHERE model LIKE 'Previa%'
  AND brand = 'Toyota';
UPDATE SUA_Cars_Cleaned
SET model = 'Paseo'
WHERE model LIKE 'Paseo%'
  AND brand = 'Toyota';

-- ==================== VOLKSWAGEN ====================

UPDATE SUA_Cars_Cleaned
SET model = 'Atlas Cross Sport'
WHERE model LIKE 'Atlas Cross Sport%'
  AND brand = 'Volkswagen';
UPDATE SUA_Cars_Cleaned
SET model = 'Atlas'
WHERE model LIKE 'Atlas%'
  AND model NOT LIKE 'Atlas Cross Sport%'
  AND brand = 'Volkswagen';

UPDATE SUA_Cars_Cleaned
SET model = 'Tiguan'
WHERE model LIKE 'Tiguan%'
  AND brand = 'Volkswagen';
UPDATE SUA_Cars_Cleaned
SET model = 'Taos'
WHERE model LIKE 'Taos%'
  AND brand = 'Volkswagen';
UPDATE SUA_Cars_Cleaned
SET model = 'Touareg'
WHERE model LIKE 'Touareg%'
  AND brand = 'Volkswagen';
UPDATE SUA_Cars_Cleaned
SET model = 'ID.4'
WHERE model LIKE 'ID.4%'
  AND brand = 'Volkswagen';


UPDATE SUA_Cars_Cleaned
SET model = 'GTI'
WHERE (model LIKE 'Golf GTI%' OR model LIKE 'GTI%')
  AND brand = 'Volkswagen';

UPDATE SUA_Cars_Cleaned
SET model = 'Golf R'
WHERE (model LIKE 'Golf R%' OR model LIKE 'R32%')
  AND brand = 'Volkswagen';

UPDATE SUA_Cars_Cleaned
SET model = 'Golf Wagon'
WHERE (model LIKE 'Golf SportWagen%' OR model LIKE 'Golf Alltrack%')
  AND brand = 'Volkswagen';

UPDATE SUA_Cars_Cleaned
SET model = 'e-Golf'
WHERE model LIKE 'e-Golf%'
  AND brand = 'Volkswagen';

UPDATE SUA_Cars_Cleaned
SET model = 'Golf'
WHERE model LIKE 'Golf%'
  AND model NOT LIKE 'Golf GTI%'
  AND model NOT LIKE 'Golf R%'
  AND model NOT LIKE 'Golf SportWagen%'
  AND model NOT LIKE 'Golf Alltrack%'
  AND brand = 'Volkswagen';

UPDATE SUA_Cars_Cleaned
SET model = 'Golf'
WHERE model LIKE 'Rabbit%'
  AND brand = 'Volkswagen';

-- Sedane

UPDATE SUA_Cars_Cleaned
SET model = 'Jetta GLI'
WHERE (model LIKE 'Jetta GLI%' OR model LIKE 'Jetta 2.0T GLI%')
  AND brand = 'Volkswagen';

UPDATE SUA_Cars_Cleaned
SET model = 'Jetta'
WHERE model LIKE 'Jetta%'
  AND model NOT LIKE 'Jetta GLI%'
  AND model NOT LIKE 'Jetta 2.0T GLI%'
  AND brand = 'Volkswagen';

UPDATE SUA_Cars_Cleaned
SET model = 'Passat'
WHERE model LIKE 'Passat%'
  AND brand = 'Volkswagen';
UPDATE SUA_Cars_Cleaned
SET model = 'Arteon'
WHERE model LIKE 'Arteon%'
  AND brand = 'Volkswagen';
UPDATE SUA_Cars_Cleaned
SET model = 'CC'
WHERE model LIKE 'CC%'
  AND brand = 'Volkswagen';
UPDATE SUA_Cars_Cleaned
SET model = 'Phaeton'
WHERE model LIKE 'Phaeton%'
  AND brand = 'Volkswagen';


UPDATE SUA_Cars_Cleaned
SET model = 'Beetle'
WHERE (model LIKE 'Beetle%' OR model LIKE 'New Beetle%' OR model LIKE 'Super Beetle%' OR model LIKE '1600 Squareback%')
  AND brand = 'Volkswagen';

UPDATE SUA_Cars_Cleaned
SET model = 'Eos'
WHERE model LIKE 'Eos%'
  AND brand = 'Volkswagen';
UPDATE SUA_Cars_Cleaned
SET model = 'Karmann Ghia'
WHERE (model LIKE 'Karmann Ghia%' OR model LIKE 'Cabrio%' OR model LIKE 'Cabriolet%')
  AND brand = 'Volkswagen';
UPDATE SUA_Cars_Cleaned
SET model = 'Thing'
WHERE model LIKE 'Thing%'
  AND brand = 'Volkswagen';
UPDATE SUA_Cars_Cleaned
SET model = 'Corrado'
WHERE model LIKE 'Corrado%'
  AND brand = 'Volkswagen';


UPDATE SUA_Cars_Cleaned
SET model = 'Routan'
WHERE model LIKE 'Routan%'
  AND brand = 'Volkswagen';
UPDATE SUA_Cars_Cleaned
SET model = 'Eurovan'
WHERE model LIKE 'Eurovan%'
  AND brand = 'Volkswagen';
UPDATE SUA_Cars_Cleaned
SET model = 'Vanagon'
WHERE model LIKE 'Vanagon%'
  AND brand = 'Volkswagen';
UPDATE SUA_Cars_Cleaned
SET model = 'Microbus'
WHERE (model LIKE 'Microbus%')
  AND brand = 'Volkswagen';



-- ============================================================
-- PASUL 6: CORECTII SUPLIMENTARE MODELE
-- Prinde cazuri ratate la prima trecere (text nestandard, aliasuri, rebrand-uri)
-- ============================================================

-- Mercedes-Benz
UPDATE SUA_Cars_Cleaned
SET model = 'Maybach S-Class'
WHERE model LIKE '%S-Class Maybach%'
  AND brand = 'Mercedes-Benz';

UPDATE SUA_Cars_Cleaned
SET model = 'AMG C 55'
WHERE model LIKE '%C-Class C55 AMG%'
  AND brand = 'Mercedes-Benz';

UPDATE SUA_Cars_Cleaned
SET model = 'AMG CL 55'
WHERE model LIKE '%CL-Class CL55 AMG%'
  AND brand = 'Mercedes-Benz';

UPDATE SUA_Cars_Cleaned
SET model = 'AMG CL 63'
WHERE model LIKE '%CL-Class 6.3L V8 AMG%'
  AND brand = 'Mercedes-Benz';

UPDATE SUA_Cars_Cleaned
SET model = 'AMG CL-Class'
WHERE model LIKE '%CL-Class AMG%'
  AND model NOT LIKE '%CL55 AMG%'
  AND model NOT LIKE '%6.3L V8 AMG%'
  AND brand = 'Mercedes-Benz';

UPDATE SUA_Cars_Cleaned
SET model = 'AMG CLK 55'
WHERE model LIKE '%CLK-Class CLK55 AMG%'
  AND brand = 'Mercedes-Benz';

UPDATE SUA_Cars_Cleaned
SET model = 'AMG CLK 63'
WHERE model LIKE '%CLK-Class 63 AMG%'
  AND brand = 'Mercedes-Benz';

UPDATE SUA_Cars_Cleaned
SET model = 'AMG CLK-Class'
WHERE model LIKE '%CLK-Class AMG%'
  AND model NOT LIKE '%CLK55 AMG%'
  AND model NOT LIKE '%63 AMG%'
  AND brand = 'Mercedes-Benz';

UPDATE SUA_Cars_Cleaned
SET model = 'AMG SL 63'
WHERE model LIKE '%SL-Class AMG SL 63%'
  AND brand = 'Mercedes-Benz';

UPDATE SUA_Cars_Cleaned
SET model = 'AMG SLK 55'
WHERE model LIKE '%SLK-Class SLK55 AMG%'
  AND brand = 'Mercedes-Benz';

-- Chevrolet
UPDATE SUA_Cars_Cleaned
SET model = '150'
WHERE model LIKE '150%'
  AND brand = 'Chevrolet';

UPDATE SUA_Cars_Cleaned
SET model = 'Lumina'
WHERE model LIKE 'Lumina%'
  AND brand = 'Chevrolet';

UPDATE SUA_Cars_Cleaned
SET model = 'Classic'
WHERE model LIKE 'Classic%'
  AND brand = 'Chevrolet';

UPDATE SUA_Cars_Cleaned
SET model = 'Master Series'
WHERE model IN (
                'Master Deluxe', 'Master Series DA', 'Master Street Gasser',
                'Panel CUSTOM', 'Independence Coupe'
    )
  AND brand = 'Chevrolet';

UPDATE SUA_Cars_Cleaned
SET model = 'Pickup Truck'
WHERE model LIKE 'Pickup Truck%'
  AND brand = 'Chevrolet';

-- Ford
UPDATE SUA_Cars_Cleaned
SET model = 'F-150 Lightning'
WHERE model LIKE '%SVT Lightning%'
  AND brand = 'Ford';

UPDATE SUA_Cars_Cleaned
SET model = 'Sunliner'
WHERE model LIKE 'Sunliner%'
  AND brand = 'Ford';

UPDATE SUA_Cars_Cleaned
SET model = 'Ford Early V8'
WHERE (model LIKE 'Coupe%'
    OR model LIKE 'Roadster%'
    OR model LIKE 'Sedan Delivery%'
    OR model LIKE 'Model 18%'
    OR model LIKE 'Model 48%'
    OR model LIKE 'Model B%')
  AND brand = 'Ford';

-- Land Rover
UPDATE SUA_Cars_Cleaned
SET model = 'Range Rover'
WHERE model LIKE '%Range Rover 4dr%'
  AND brand = 'Land Rover';

-- Mazda
UPDATE SUA_Cars_Cleaned
SET model = 'B-Series'
WHERE (model LIKE 'B2000%'
    OR model LIKE 'B2200%'
    OR model LIKE 'B2300%'
    OR model LIKE 'B3000%'
    OR model LIKE 'B4000%')
  AND brand = 'Mazda';

-- BMW (traducere Seria -> Series)
UPDATE SUA_Cars_Cleaned
SET model = '1 Series'
WHERE model = 'Seria 1'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = '2 Series'
WHERE model = 'Seria 2'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = '3 Series'
WHERE model = 'Seria 3'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = '4 Series'
WHERE model = 'Seria 4'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = '5 Series'
WHERE model = 'Seria 5'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = '6 Series'
WHERE model = 'Seria 6'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = '7 Series'
WHERE model = 'Seria 7'
  AND brand = 'BMW';
UPDATE SUA_Cars_Cleaned
SET model = '8 Series'
WHERE model = 'Seria 8'
  AND brand = 'BMW';

-- Dodge -> RAM (rebrand)
UPDATE SUA_Cars_Cleaned
SET brand = 'Ram',
    model = '1500'
WHERE model LIKE 'Ram 1500%'
  AND brand = 'Dodge';

UPDATE SUA_Cars_Cleaned
SET brand = 'Ram',
    model = '2500'
WHERE model LIKE 'Ram 2500%'
  AND brand = 'Dodge';

UPDATE SUA_Cars_Cleaned
SET brand = 'Ram',
    model = '3500'
WHERE model LIKE 'Ram 3500%'
  AND brand = 'Dodge';


UPDATE SUA_Cars_Cleaned
SET brand = 'Ford'
WHERE model = 'Ford Early V8'
  AND brand = 'Chevrolet';

UPDATE SUA_Cars_Cleaned
SET model = 'Ford Early V8'
WHERE brand = 'Ford'
  AND (model LIKE '%Restomod%' OR model LIKE '%Bagged Show Truck%');

UPDATE SUA_Cars_Cleaned
SET model = 'E-150'
WHERE brand = 'Ford'
  AND model LIKE '%Van CUSTOM%';

-- ============================================================
-- PASUL 7: STANDARDIZARE CULORI
-- Grupam sute de variante in ~14 categorii unificate cross-market:
--   Gray/Charcoal/Graphite → Grey, Bronze/Copper → Brown,
--   Tan/Sand/Champagne → Beige, Pink/Violet → Purple
-- Culorile rare (sub top 12 ca frecventa) devin 'Unknown'
-- ============================================================
UPDATE SUA_Cars_Cleaned
SET color = CASE
    -- Culori specifice cu slash care nu sunt two-tone (trebuie prinse inainte de regula /)
                WHEN UPPER(color) LIKE '%BEIGE%' AND UPPER(color) LIKE '%TAN%' THEN 'Beige'
                WHEN UPPER(color) LIKE '%BRONZE%' AND UPPER(color) LIKE '%COPPER%' THEN 'Brown'
    -- Two-Tone
                WHEN UPPER(color) LIKE '%/%' OR UPPER(color) LIKE '% WITH %' OR UPPER(color) LIKE '% & %' OR
                     UPPER(color) LIKE '%TWO TONE%' OR UPPER(color) LIKE '%TWO-TONE%' OR UPPER(color) LIKE '%2 TONE%' OR
                     UPPER(color) LIKE '% ROOF%' OR UPPER(color) LIKE '% TOP%' THEN 'Two-Tone'

    -- Purple
                WHEN UPPER(color) LIKE '%PINK%' OR UPPER(color) LIKE '%PURPLE%' OR UPPER(color) LIKE '%VIOLET%' OR
                     UPPER(color) LIKE '%AMETHYST%' OR UPPER(color) LIKE '%PLUM%' OR UPPER(color) LIKE '%FUCHSIA%' OR
                     UPPER(color) LIKE '%LAVENDER%' OR UPPER(color) LIKE '%ORCHID%' THEN 'Purple'

    -- Orange
                WHEN UPPER(color) LIKE '%ORANGE%' OR UPPER(color) LIKE '%MANGO%' OR UPPER(color) LIKE '%TANGERINE%' OR
                     UPPER(color) LIKE '%PAPAYA%' OR UPPER(color) LIKE '%VITAMIN C%' THEN 'Orange'

    -- Yellow
                WHEN UPPER(color) LIKE '%YELLOW%' OR UPPER(color) LIKE '%LEMON%' OR UPPER(color) LIKE '%MUSTARD%'
                    THEN 'Yellow'

    -- Gold
                WHEN UPPER(color) LIKE '%GOLD%' OR UPPER(color) LIKE '%AURUM%' THEN 'Gold'

    -- Brown (Bronze / Copper)
                WHEN UPPER(color) LIKE '%BRONZE%' OR UPPER(color) LIKE '%COPPER%' OR UPPER(color) LIKE '%CHESTNUT%'
                    THEN 'Brown'

    -- Brown
                WHEN UPPER(color) LIKE '%BROWN%' OR UPPER(color) LIKE '%ESPRESSO%' OR UPPER(color) LIKE '%MOCHA%' OR
                     UPPER(color) LIKE '%CHOCOLATE%' OR UPPER(color) LIKE '%MAHOGANY%' OR
                     UPPER(color) LIKE '%WALNUT%' OR UPPER(color) LIKE '%CARAMEL%' OR UPPER(color) LIKE '%TOFFEE%' OR
                     UPPER(color) LIKE '%COCOA%' THEN 'Brown'

    -- Beige
                WHEN UPPER(color) LIKE '%BEIGE%' OR UPPER(color) LIKE '%SAND%' OR UPPER(color) LIKE '%KHAKI%' OR
                     UPPER(color) LIKE '%CHAMPAGNE%' OR UPPER(color) LIKE '%PARCHMENT%' OR UPPER(color) LIKE '%DUNE%' OR
                     UPPER(color) LIKE '%GOBI%' OR UPPER(color) = 'TAN' OR UPPER(color) LIKE '% TAN%' OR
                     UPPER(color) LIKE 'TAN %' THEN 'Beige'

    -- Green
                WHEN UPPER(color) LIKE '%GREEN%' OR UPPER(color) LIKE '%EMERALD%' OR UPPER(color) LIKE '%OLIVE%' OR
                     UPPER(color) LIKE '%TEAL%' OR UPPER(color) LIKE '%MINT%' OR UPPER(color) LIKE '%SAGE%' OR
                     UPPER(color) LIKE '%LIME%' OR UPPER(color) LIKE '%CACTUS%' OR UPPER(color) LIKE '%SPRUCE%' OR
                     UPPER(color) LIKE '%ALOE%' THEN 'Green'

    -- Red
                WHEN UPPER(color) LIKE '%RED%' OR UPPER(color) LIKE '%CRIMSON%' OR UPPER(color) LIKE '%BURGUNDY%' OR
                     UPPER(color) LIKE '%MAROON%' OR UPPER(color) LIKE '%RUBY%' OR UPPER(color) LIKE '%GARNET%' OR
                     UPPER(color) LIKE '%CHERRY%' OR UPPER(color) LIKE '%SCARLET%' OR UPPER(color) LIKE '%WINE%' OR
                     UPPER(color) LIKE '%ROUGE%' OR UPPER(color) LIKE '%CARMINE%' OR UPPER(color) LIKE '%TORRED%'
                    THEN 'Red'

    -- Blue
                WHEN UPPER(color) LIKE '%BLUE%' OR UPPER(color) LIKE '%NAVY%' OR UPPER(color) LIKE '%AZURE%' OR
                     UPPER(color) LIKE '%SAPPHIRE%' OR UPPER(color) LIKE '%OCEAN%' OR UPPER(color) LIKE '%AQUA%' OR
                     UPPER(color) LIKE '%BLAU%' OR UPPER(color) LIKE '%CAVALRY%' OR UPPER(color) LIKE '%BLUEPRINT%'
                    THEN 'Blue'

    -- Grey
                WHEN UPPER(color) LIKE '%GRAY%' OR UPPER(color) LIKE '%GREY%' OR UPPER(color) LIKE '%CHARCOAL%' OR
                     UPPER(color) LIKE '%GRAPHITE%' OR UPPER(color) LIKE '%GRANITE%' OR
                     UPPER(color) LIKE '%GUNMETAL%' OR UPPER(color) LIKE '%SLATE%' OR UPPER(color) LIKE '%TITANIUM%' OR
                     UPPER(color) LIKE '%CEMENT%' OR UPPER(color) LIKE '%NARDO%' OR UPPER(color) LIKE '%BOULDER%' OR
                     UPPER(color) LIKE '%MAGNETIC%' OR UPPER(color) LIKE '%AREA 51%' OR UPPER(color) LIKE '%SMOKE%' OR
                     UPPER(color) LIKE '%ANVIL%' OR UPPER(color) LIKE '%CARBON%' OR UPPER(color) LIKE '%TUNGSTEN%' OR
                     UPPER(color) LIKE '%CELESTITE%' THEN 'Grey'

    -- Silver
                WHEN UPPER(color) LIKE '%SILVER%' OR UPPER(color) LIKE '%PLATINUM%' OR UPPER(color) LIKE '%BILLET%' OR
                     UPPER(color) LIKE '%PEWTER%' OR UPPER(color) LIKE '%ALUMINUM%' OR UPPER(color) LIKE '%INGOT%' OR
                     UPPER(color) LIKE '%QUICKSILVER%' THEN 'Silver'

    -- Black
                WHEN UPPER(color) LIKE '%BLACK%' OR UPPER(color) LIKE '%OBSIDIAN%' OR UPPER(color) LIKE '%EBONY%' OR
                     UPPER(color) LIKE '%ONYX%' OR UPPER(color) LIKE '%MIDNIGHT%' OR UPPER(color) LIKE '%RAVEN%' OR
                     UPPER(color) LIKE '%CAVIAR%' OR UPPER(color) LIKE '%SCHWARZ%' THEN 'Black'

    -- White
                WHEN UPPER(color) LIKE '%WHITE%' OR UPPER(color) LIKE '%IVORY%' OR UPPER(color) LIKE '%BLIZZARD%' OR
                     UPPER(color) LIKE '%ALABASTER%' OR UPPER(color) LIKE '%FROST%' OR UPPER(color) LIKE '%CHALK%' OR
                     UPPER(color) LIKE '%SNOW%' OR UPPER(color) LIKE '%WEISS%' OR UPPER(color) LIKE '%BLANC%' OR
                     UPPER(color) LIKE '%STARFIRE%' OR UPPER(color) LIKE '%WIND CHILL%' THEN 'White'

    -- Unknown
                ELSE 'Unknown'
    END;

-- Culorile rare (sub top 12 ca frecventa non-Unknown) devin 'Unknown'
drop table if exists temp_top_colors;
create temp table temp_top_colors as
select color
from SUA_Cars_Cleaned
where color <> 'Unknown'
group by color
order by count(color) desc
limit 12;

update SUA_Cars_Cleaned
set color = 'Unknown'
where color not in (select color from temp_top_colors);

drop table if exists temp_top_colors;

-- ============================================================
-- PASUL 8: STANDARDIZARE TIP TRANSMISIE
-- Clasificam in: Manual, Automatic, Unknown
-- Include si cutii clasice (TH350, Muncie, etc.)
-- ============================================================
UPDATE SUA_Cars_Cleaned
SET transmission_type = CASE
    -- 1. Lipsă de date / Erori
                            WHEN transmission_type IN ('-', '0', 'UNKNOWN', 'NOT SPECIFIED', 'OTHER') OR
                                 UPPER(transmission_type) LIKE '%UNKNOWN%' OR transmission_type IS NULL THEN 'Unknown'

    -- 1.5. SEMI-AUTOMATIC
                            WHEN UPPER(transmission_type) LIKE '%SEMI%AUTO%'
                                OR UPPER(transmission_type) LIKE '%SEMI-AUTO%'
                                OR UPPER(transmission_type) LIKE '%SEMI_AUTO%'
                                OR UPPER(transmission_type) LIKE '%SEMI AUTOMATIC%' THEN 'Semi-automatic'

    -- 2. MANUALE
                            WHEN UPPER(transmission_type) LIKE '%M/T%'
                                OR UPPER(transmission_type) LIKE '%STICKSHIFT%'
                                OR UPPER(transmission_type) LIKE '%MUNCIE%'
                                OR UPPER(transmission_type) LIKE '%ROCK CRUSHER%'
                                OR UPPER(transmission_type) LIKE '%TREMEC%'
                                OR UPPER(transmission_type) LIKE '%ON THE TREE%'
                                OR UPPER(transmission_type) LIKE '%T-56%'
                                OR UPPER(transmission_type) LIKE '%T56%'
                                OR UPPER(transmission_type) LIKE '%TR6060%'
                                OR UPPER(transmission_type) LIKE '%NV3550%'
                                OR UPPER(transmission_type) LIKE '%TOP LOADER%'
                                OR UPPER(transmission_type) LIKE '%PISTOL GRIP%' THEN 'Manual'

                            WHEN UPPER(transmission_type) LIKE '%MANUAL%' AND UPPER(transmission_type) NOT LIKE '%AUTO%'
                                THEN 'Manual'

    -- 3. AUTOMATE
                            WHEN UPPER(transmission_type) LIKE '%AUTO%'
                                OR UPPER(transmission_type) LIKE '%A/T%'
                                OR UPPER(transmission_type) LIKE '%CVT%'
                                OR UPPER(transmission_type) LIKE '%IVT%'
                                OR UPPER(transmission_type) LIKE '%VARIABLE%'
                                OR UPPER(transmission_type) LIKE '%XTRONIC%'
                                OR UPPER(transmission_type) LIKE '%DUAL CLUTCH%'
                                OR UPPER(transmission_type) LIKE '%DOUBLE CLUTCH%'
                                OR UPPER(transmission_type) LIKE '%DCT%'
                                OR UPPER(transmission_type) LIKE '%DSG%'
                                OR UPPER(transmission_type) LIKE '%PDK%'
                                OR UPPER(transmission_type) LIKE '%DOPPELKUPPLUNG%'
                                OR UPPER(transmission_type) LIKE '%TIPTRONIC%'
                                OR UPPER(transmission_type) LIKE '%STEPTRONIC%'
                                OR UPPER(transmission_type) LIKE '%SHIFTRONIC%'
                                OR UPPER(transmission_type) LIKE '%SEQUENTIAL%'
                                OR UPPER(transmission_type) LIKE '%1-SPEED%'
                                OR UPPER(transmission_type) LIKE '%1 SPEED%'
                                OR UPPER(transmission_type) LIKE '%SINGLE SPEED%'
                                OR UPPER(transmission_type) LIKE '%REDUCER%'
                                OR UPPER(transmission_type) LIKE '%TH350%'
                                OR UPPER(transmission_type) LIKE '%TH400%'
                                OR UPPER(transmission_type) LIKE '%TURBO 350%'
                                OR UPPER(transmission_type) LIKE '%TURBO 400%'
                                OR UPPER(transmission_type) LIKE '%POWERGLIDE%'
                                OR UPPER(transmission_type) LIKE '%700R4%'
                                OR UPPER(transmission_type) LIKE '%700 R4%'
                                OR UPPER(transmission_type) LIKE '%4L60%'
                                OR UPPER(transmission_type) LIKE '%4L80%'
                                OR UPPER(transmission_type) LIKE '%AOD%'
                                OR UPPER(transmission_type) LIKE '%4R70%'
                                OR UPPER(transmission_type) LIKE '%727%'
                                OR UPPER(transmission_type) LIKE '%TORQUEFLITE%'
                                OR UPPER(transmission_type) LIKE '% C4%'
                                OR UPPER(transmission_type) LIKE '% C6%' THEN 'Automatic'

    -- 4. FALLBACK SPEED/SPD
                            WHEN UPPER(transmission_type) LIKE '%SPEED%' OR UPPER(transmission_type) LIKE '%SPD%'
                                THEN 'Automatic'

                            ELSE 'Unknown'
    END;

-- ============================================================
-- PASUL 9: STANDARDIZARE TIP COMBUSTIBIL
-- Ordinea conteaza: Hybrid inainte de Electric/Petrol
-- ============================================================
UPDATE SUA_Cars_Cleaned
SET fuel_type = CASE
    -- 1. Erori, Lipsă Date și Valori Ambigue
                    WHEN fuel_type IN ('', '-', '0', 'Unknown', 'Unspecified', 'Other', 'Automatic', 'B', 'Bi-Fuel') OR
                         fuel_type IS NULL THEN 'Unknown'

    -- 2. Hybrid (PHEV, MHEV, Gas/Electric)
    -- Această regulă TREBUIE să fie prima pentru a prinde combinațiile "Electric/Gas" înainte să ajungă la secțiunile separate
                    WHEN UPPER(fuel_type) LIKE '%HYBRID%' OR UPPER(fuel_type) LIKE '%PHEV%' OR
                         UPPER(fuel_type) LIKE '%PLUG-IN%' THEN 'Hybrid'

    -- 3. Electric (100% BEV)
                    WHEN UPPER(fuel_type) LIKE '%ELECTRIC%' THEN 'Electric'

    -- 4. Ethanol (E85 / Flex Fuel)
                    WHEN UPPER(fuel_type) LIKE '%E85%' OR UPPER(fuel_type) LIKE '%FLEX%' THEN 'Ethanol'

    -- 5. Diesel & Biodiesel
                    WHEN UPPER(fuel_type) LIKE '%DIESEL%' THEN 'Diesel'

    -- 6. CNG (Compressed Natural Gas)
                    WHEN UPPER(fuel_type) LIKE '%NATURAL GAS%' OR UPPER(fuel_type) LIKE '%CNG%' OR
                         UPPER(fuel_type) LIKE '%GASEOUS%' THEN 'CNG'

    -- 7. Hydrogen (Fuel Cell)
                    WHEN UPPER(fuel_type) LIKE '%HYDROGEN%' OR UPPER(fuel_type) LIKE '%FUEL CELL%' THEN 'Hydrogen'

    -- 8. LPG (Propane - Adăugat preventiv pentru robustețea bazei de date)
                    WHEN UPPER(fuel_type) LIKE '%LPG%' OR UPPER(fuel_type) LIKE '%PROPANE%' THEN 'LPG'

    -- 9. Petrol / Gasoline
                    WHEN UPPER(fuel_type) LIKE '%GAS%' OR UPPER(fuel_type) LIKE '%PREMIUM%' OR
                         UPPER(fuel_type) LIKE '%UNLEADED%' OR fuel_type = 'G' THEN 'Petrol'

    -- 10. Fallback
                    ELSE 'Unknown'
    END;


-- ============================================================
-- PASUL 10: STANDARDIZARE TRACTIUNE (drivetrain)
-- Clasificam in: AWD, 4WD, FWD, RWD, 2WD, Unknown
-- ============================================================
UPDATE SUA_Cars_Cleaned
SET drivetrain = CASE
    -- 1. Erori, Lipsă Date și zgomot de date (Informații despre motor trecute greșit aici)
                     WHEN drivetrain IN ('', '-', '0', 'Unknown') OR UPPER(drivetrain) LIKE '%ENGINE:%' OR
                          drivetrain IS NULL THEN 'Unknown'

    -- 2. AWD (All-Wheel Drive)
                     WHEN UPPER(drivetrain) LIKE '%AWD%' OR UPPER(drivetrain) LIKE '%ALL%WHEEL%' THEN 'AWD'

    -- 3. 4WD (Four-Wheel Drive)
                     WHEN UPPER(drivetrain) LIKE '%4WD%' OR UPPER(drivetrain) LIKE '%4X4%' OR
                          UPPER(drivetrain) LIKE '%FOUR%WHEEL%' THEN '4WD'

    -- 4. FWD (Front-Wheel Drive)
                     WHEN UPPER(drivetrain) LIKE '%FWD%' OR UPPER(drivetrain) LIKE '%FRONT%WHEEL%' THEN 'FWD'

    -- 5. RWD (Rear-Wheel Drive)
                     WHEN UPPER(drivetrain) LIKE '%RWD%' OR UPPER(drivetrain) LIKE '%REAR%WHEEL%' THEN 'RWD'

    -- 6. 2WD (Generic 2-Wheel Drive / 4x2)
    -- Aceasta trebuie să fie ultima dintre tracțiuni pentru a nu intercepta accidental alte valori.
                     WHEN UPPER(drivetrain) LIKE '%2WD%' OR UPPER(drivetrain) LIKE '%4X2%' THEN '2WD'

    -- 7. Fallback pentru orice altceva
                     ELSE 'Unknown'
    END;

-- ============================================================
-- PASUL 11: STANDARDIZARE NUMAR PROPRIETARI (one_owner)
-- Convertim 1.0/0.0 in Yes/No
-- ============================================================
UPDATE SUA_Cars_Cleaned
SET one_owner = CASE
    -- 1. Un singur proprietar (1.0 = True)
                    WHEN one_owner = '1.0' THEN 'Yes'

    -- 2. Mai mulți proprietari (0.0 = False)
                    WHEN one_owner = '0.0' THEN 'No'

    -- 3. Valori lipsă sau erori
                    ELSE 'Unknown'
    END;

DELETE
FROM SUA_Cars_Cleaned
WHERE id NOT IN (SELECT MIN(id)
                 FROM SUA_Cars_Cleaned
                 GROUP BY brand, model, color, year, price_in_euro, transmission_type, fuel_type, km, engine_type,
                          drivetrain, one_owner);


-- ============================================================
-- PASUL 12: IMPUTARE CAPACITATE MOTOR LIPSA
-- Strategie in 3 pasi (de la specific la general):
--   1. Media pe brand + model + fuel_type (fereastra ±2 ani)
--   2. Media pe brand + fuel_type (daca pasul 1 nu a gasit)
--   3. Media pe fuel_type (fallback general)
-- Excludem vehiculele electrice (nu au cilindree)
-- ============================================================
UPDATE SUA_Cars_Cleaned
SET engine_type = NULL
WHERE fuel_type = 'Electric'
   OR fuel_type = 'Hydrogen';


CREATE INDEX idx_cars_lookup_SUA ON SUA_Cars_Cleaned (brand, model, fuel_type, year);

-- Pas 1: imputare pe brand + model + fuel_type (fereastra ±2 ani)
UPDATE SUA_Cars_Cleaned
SET engine_type = (SELECT ROUND(MEDIAN(sub.engine_type), 1)
                   FROM SUA_Cars_Cleaned AS sub
                   where sub.brand = SUA_Cars_Cleaned.brand
                     AND sub.model = SUA_Cars_Cleaned.model
                     AND sub.fuel_type = SUA_Cars_Cleaned.fuel_type
                     and sub.year between SUA_Cars_Cleaned.year - 2 and SUA_Cars_Cleaned.year + 2
                     AND sub.engine_type IS NOT NULL
                     and sub.fuel_type <> 'Unknown'
                     and sub.fuel_type NOT IN ('Electric', 'Hydrogen'))
WHERE (engine_type IS NULL OR engine_type = 0)
  AND fuel_type NOT IN ('Electric', 'Hydrogen');

-- Pas 2: imputare pe brand + fuel_type (fara restrictie de model)
drop index idx_cars_lookup_SUA;
CREATE INDEX idx_cars_lookup_SUA ON SUA_Cars_Cleaned (brand, fuel_type);

UPDATE SUA_Cars_Cleaned
SET engine_type = (SELECT ROUND(MEDIAN(sub.engine_type), 1)
                   FROM SUA_Cars_Cleaned AS sub
                   where sub.brand = SUA_Cars_Cleaned.brand
                     AND sub.fuel_type = SUA_Cars_Cleaned.fuel_type
                     AND sub.engine_type IS NOT NULL
                     and sub.fuel_type <> 'Unknown'
                     and sub.fuel_type NOT IN ('Electric', 'Hydrogen'))
WHERE (engine_type IS NULL OR engine_type = 0)
  AND fuel_type NOT IN ('Electric', 'Hydrogen');

-- Pas 3: fallback global pe fuel_type
drop index idx_cars_lookup_SUA;
CREATE INDEX idx_cars_lookup_SUA ON SUA_Cars_Cleaned (fuel_type);

UPDATE SUA_Cars_Cleaned
SET engine_type = (SELECT ROUND(MEDIAN(sub.engine_type), 1)
                   FROM SUA_Cars_Cleaned AS sub
                   WHERE sub.fuel_type = SUA_Cars_Cleaned.fuel_type
                     AND sub.engine_type IS NOT NULL
                     and sub.fuel_type NOT IN ('Electric', 'Hydrogen'))
WHERE (engine_type IS NULL OR engine_type = 0)
  AND fuel_type NOT IN ('Electric', 'Hydrogen');

drop index idx_cars_lookup_SUA;

-- ============================================================
-- PASUL 12b: IMPUTARE CONSUM COMBUSTIBIL LIPSA
-- Strategie in 4 pasi (de la specific la general):
--   1. Media pe brand + model + fuel_type + transmission + drivetrain (fereastra ±2 ani, engine exact)
--   2. Media pe brand + fuel_type + transmission + drivetrain (fereastra ±4 ani, engine ±0.2L)
--   3. Media pe fuel_type + drivetrain (fereastra ±0.4L engine)
--   4. Media pe fuel_type (fereastra ±0.9L engine)
-- Excludem vehiculele electrice, hydrogen si CNG (consum incomparabil sau 0)
-- ============================================================

CREATE INDEX idx_cars_lookup1_SUA ON SUA_Cars_Cleaned (brand, model, fuel_type, year, transmission_type, drivetrain,
                                                       engine_type);

UPDATE SUA_Cars_Cleaned
SET fuel_consumption_l_100km = NULL
WHERE fuel_type = 'Electric'
   OR fuel_type = 'Hydrogen'
   OR fuel_type = 'CNG';

-- Pas 1: imputare pe brand + model + fuel_type + transmission + drivetrain (fereastra ±2 ani)
UPDATE SUA_Cars_Cleaned
SET fuel_consumption_l_100km = (SELECT ROUND(MEDIAN(sub.fuel_consumption_l_100km), 1)
                                FROM SUA_Cars_Cleaned AS sub
                                where sub.brand = SUA_Cars_Cleaned.brand
                                  AND sub.model = SUA_Cars_Cleaned.model
                                  AND sub.fuel_type = SUA_Cars_Cleaned.fuel_type
                                  and sub.transmission_type = SUA_Cars_Cleaned.transmission_type
                                  and sub.year between SUA_Cars_Cleaned.year - 2 and SUA_Cars_Cleaned.year + 2
                                  AND sub.engine_type = SUA_Cars_Cleaned.engine_type
                                  and sub.drivetrain = SUA_Cars_Cleaned.drivetrain
                                  and sub.fuel_consumption_l_100km is not null
                                  and sub.fuel_type NOT IN ('Electric', 'Hydrogen', 'CNG')
                                  and sub.drivetrain <> 'Unknown'
                                  and sub.transmission_type <> 'Unknown'
                                  and sub.fuel_type <> 'Unknown')
WHERE (fuel_consumption_l_100km IS NULL OR fuel_consumption_l_100km = 0)
  AND fuel_type NOT IN ('Electric', 'Hydrogen', 'CNG');

-- Pas 2: imputare pe brand + fuel_type + transmission + drivetrain (fereastra ±4 ani, engine ±0.2L)
drop index idx_cars_lookup1_SUA;

CREATE INDEX idx_cars_lookup1_SUA ON SUA_Cars_Cleaned (brand, fuel_type, year, transmission_type, drivetrain,
                                                       engine_type);

UPDATE SUA_Cars_Cleaned
SET fuel_consumption_l_100km = (SELECT ROUND(MEDIAN(sub.fuel_consumption_l_100km), 1)
                                FROM SUA_Cars_Cleaned AS sub
                                WHERE sub.brand = SUA_Cars_Cleaned.brand
                                  AND sub.fuel_type = SUA_Cars_Cleaned.fuel_type
                                  AND sub.transmission_type = SUA_Cars_Cleaned.transmission_type
                                  AND (sub.drivetrain = SUA_Cars_Cleaned.drivetrain and
                                       SUA_Cars_Cleaned.drivetrain <> 'Unknown')
                                  AND sub.year BETWEEN SUA_Cars_Cleaned.year - 4 AND SUA_Cars_Cleaned.year + 4
                                  AND sub.engine_type BETWEEN SUA_Cars_Cleaned.engine_type - 0.2 AND SUA_Cars_Cleaned.engine_type + 0.2
                                  AND sub.fuel_consumption_l_100km IS NOT NULL
                                  AND sub.fuel_type NOT IN ('Electric', 'Hydrogen', 'CNG')
                                  and sub.drivetrain <> 'Unknown'
                                  and sub.transmission_type <> 'Unknown'
                                  and sub.fuel_type <> 'Unknown')
WHERE (fuel_consumption_l_100km IS NULL OR fuel_consumption_l_100km = 0)
  AND fuel_type NOT IN ('Electric', 'Hydrogen', 'CNG');

-- Pas 3: fallback pe fuel_type + drivetrain (fereastra ±0.4L engine)
drop index idx_cars_lookup1_SUA;
CREATE INDEX idx_cars_lookup1_SUA ON SUA_Cars_Cleaned (fuel_type, drivetrain, engine_type);

UPDATE SUA_Cars_Cleaned
SET fuel_consumption_l_100km = (SELECT ROUND(MEDIAN(sub.fuel_consumption_l_100km), 1)
                                FROM SUA_Cars_Cleaned AS sub
                                WHERE sub.fuel_type = SUA_Cars_Cleaned.fuel_type
                                  AND sub.drivetrain = SUA_Cars_Cleaned.drivetrain
                                  AND sub.engine_type BETWEEN SUA_Cars_Cleaned.engine_type - 0.4 AND SUA_Cars_Cleaned.engine_type + 0.4
                                  AND sub.fuel_consumption_l_100km IS NOT NULL
                                  AND sub.fuel_type NOT IN ('Electric', 'Hydrogen', 'CNG'))
WHERE (fuel_consumption_l_100km IS NULL OR fuel_consumption_l_100km = 0)
  AND fuel_type NOT IN ('Electric', 'Hydrogen', 'CNG');

-- Pas 4: fallback global pe fuel_type (fereastra ±0.9L engine)
UPDATE SUA_Cars_Cleaned
SET fuel_consumption_l_100km = (SELECT ROUND(MEDIAN(sub.fuel_consumption_l_100km), 1)
                                FROM SUA_Cars_Cleaned AS sub
                                WHERE sub.fuel_type = SUA_Cars_Cleaned.fuel_type
                                  AND sub.engine_type BETWEEN SUA_Cars_Cleaned.engine_type - 0.9 AND SUA_Cars_Cleaned.engine_type + 0.9
                                  AND sub.fuel_consumption_l_100km IS NOT NULL
                                  AND sub.fuel_type NOT IN ('Electric', 'Hydrogen', 'CNG'))
WHERE (fuel_consumption_l_100km IS NULL OR fuel_consumption_l_100km = 0)
  AND fuel_type NOT IN ('Electric', 'Hydrogen', 'CNG');

drop index idx_cars_lookup1_SUA;

-- ============================================================
-- PASUL 13: ELIMINARE OUTLIERI
-- Praguri asimetrice P0.1 / P99.9 per piata
-- ============================================================

-- Praguri P0.1 / P99.9 recalculate
DELETE
FROM SUA_Cars_Cleaned
WHERE km > 442816
   OR engine_type > 7.3
   OR price_in_euro < 2772
   OR price_in_euro > 221777
   OR fuel_consumption_l_100km < 0.9
   OR fuel_consumption_l_100km > 19.6;

-- ============================================================
-- PASUL 14: VERIFICARE FINALA
-- Numar total de randuri dupa curatare
-- ============================================================
select count(*)
from SUA_Cars_Cleaned;

