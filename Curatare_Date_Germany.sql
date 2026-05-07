
select distinct model, count (model) as numar, brand
from Germany_Cars_Cleaned
group by model
order by numar asc;

UPDATE Germany_Cars_Cleaned SET model = TRIM(SUBSTR(model, LENGTH('Mercedes-Benz') + 1)) WHERE model LIKE 'Mercedes-Benz %';
UPDATE Germany_Cars_Cleaned SET model = TRIM(SUBSTR(model, LENGTH('BMW') + 1))           WHERE model LIKE 'BMW %';
UPDATE Germany_Cars_Cleaned SET model = TRIM(SUBSTR(model, LENGTH('Audi') + 1))          WHERE model LIKE 'Audi %';
UPDATE Germany_Cars_Cleaned SET model = TRIM(SUBSTR(model, LENGTH('Volkswagen') + 1))    WHERE model LIKE 'Volkswagen %';
UPDATE Germany_Cars_Cleaned SET model = TRIM(SUBSTR(model, LENGTH('Porsche') + 1))       WHERE model LIKE 'Porsche %';
UPDATE Germany_Cars_Cleaned SET model = TRIM(SUBSTR(model, LENGTH('MINI') + 1))          WHERE model LIKE 'MINI %';
UPDATE Germany_Cars_Cleaned SET model = TRIM(SUBSTR(model, LENGTH('Opel') + 1))          WHERE model LIKE 'Opel %';
UPDATE Germany_Cars_Cleaned SET model = TRIM(SUBSTR(model, LENGTH('Peugeot') + 1))       WHERE model LIKE 'Peugeot %';
UPDATE Germany_Cars_Cleaned SET model = TRIM(SUBSTR(model, LENGTH('Renault') + 1))       WHERE model LIKE 'Renault %';
UPDATE Germany_Cars_Cleaned SET model = TRIM(SUBSTR(model, LENGTH('Fiat') + 1))          WHERE model LIKE 'Fiat %';
UPDATE Germany_Cars_Cleaned SET model = TRIM(SUBSTR(model, LENGTH('Toyota') + 1))        WHERE model LIKE 'Toyota %';
UPDATE Germany_Cars_Cleaned SET model = TRIM(SUBSTR(model, LENGTH('Ford') + 1))          WHERE model LIKE 'Ford %';
UPDATE Germany_Cars_Cleaned SET model = TRIM(SUBSTR(model, LENGTH('Skoda') + 1))         WHERE model LIKE 'Skoda %';
UPDATE Germany_Cars_Cleaned SET model = TRIM(SUBSTR(model, LENGTH('Volvo') + 1))         WHERE model LIKE 'Volvo %';
UPDATE Germany_Cars_Cleaned SET model = TRIM(SUBSTR(model, LENGTH('Hyundai') + 1))       WHERE model LIKE 'Hyundai %';
UPDATE Germany_Cars_Cleaned SET model = TRIM(SUBSTR(model, LENGTH('Kia') + 1))           WHERE model LIKE 'Kia %';
UPDATE Germany_Cars_Cleaned SET model = TRIM(SUBSTR(model, LENGTH('Seat') + 1))          WHERE model LIKE 'Seat %';
UPDATE Germany_Cars_Cleaned SET model = TRIM(SUBSTR(model, LENGTH('SEAT') + 1))          WHERE model LIKE 'SEAT %';
UPDATE Germany_Cars_Cleaned SET model = TRIM(SUBSTR(model, LENGTH('Dacia') + 1))         WHERE model LIKE 'Dacia %';
UPDATE Germany_Cars_Cleaned SET model = TRIM(SUBSTR(model, LENGTH('Alfa Romeo') + 1))    WHERE model LIKE 'Alfa Romeo %';
UPDATE Germany_Cars_Cleaned SET model = TRIM(SUBSTR(model, LENGTH('Nissan') + 1))        WHERE model LIKE 'Nissan %';
UPDATE Germany_Cars_Cleaned SET model = TRIM(SUBSTR(model, LENGTH('Honda') + 1))         WHERE model LIKE 'Honda %';
UPDATE Germany_Cars_Cleaned SET model = TRIM(SUBSTR(model, LENGTH('Mazda') + 1))         WHERE model LIKE 'Mazda %';
UPDATE Germany_Cars_Cleaned SET model = TRIM(SUBSTR(model, LENGTH('Mitsubishi') + 1))    WHERE model LIKE 'Mitsubishi %';
UPDATE Germany_Cars_Cleaned SET model = TRIM(SUBSTR(model, LENGTH('Citroen') + 1))       WHERE model LIKE 'Citroen %';
UPDATE Germany_Cars_Cleaned SET model = TRIM(SUBSTR(model, LENGTH('Land Rover') + 1))    WHERE model LIKE 'Land Rover %';
UPDATE Germany_Cars_Cleaned SET model = TRIM(SUBSTR(model, LENGTH('Jaguar') + 1))        WHERE model LIKE 'Jaguar %';
UPDATE Germany_Cars_Cleaned SET model = TRIM(SUBSTR(model, LENGTH('Jeep') + 1))          WHERE model LIKE 'Jeep %';
UPDATE Germany_Cars_Cleaned SET model = TRIM(SUBSTR(model, LENGTH('Volvo') + 1))         WHERE model LIKE 'Volvo %';
UPDATE Germany_Cars_Cleaned SET model = TRIM(SUBSTR(model, LENGTH('Lamborghini') + 1))   WHERE model LIKE 'Lamborghini %';
UPDATE Germany_Cars_Cleaned SET model = TRIM(SUBSTR(model, LENGTH('Maserati') + 1))      WHERE model LIKE 'Maserati %';
UPDATE Germany_Cars_Cleaned SET model = TRIM(SUBSTR(model, LENGTH('Bentley') + 1))       WHERE model LIKE 'Bentley %';
UPDATE Germany_Cars_Cleaned SET model = TRIM(SUBSTR(model, LENGTH('Aston Martin') + 1))  WHERE model LIKE 'Aston Martin %';
UPDATE Germany_Cars_Cleaned SET model = TRIM(SUBSTR(model, LENGTH('Ferrari') + 1))       WHERE model LIKE 'Ferrari %';
UPDATE Germany_Cars_Cleaned SET model = TRIM(SUBSTR(model, LENGTH('Lancia') + 1))        WHERE model LIKE 'Lancia %';
UPDATE Germany_Cars_Cleaned SET model = TRIM(SUBSTR(model, LENGTH('Saab') + 1))          WHERE model LIKE 'Saab %';
UPDATE Germany_Cars_Cleaned SET model = TRIM(SUBSTR(model, LENGTH('Dodge') + 1))         WHERE model LIKE 'Dodge %';
UPDATE Germany_Cars_Cleaned SET model = TRIM(SUBSTR(model, LENGTH('Chevrolet') + 1))     WHERE model LIKE 'Chevrolet %';
UPDATE Germany_Cars_Cleaned SET model = TRIM(SUBSTR(model, LENGTH('Cadillac') + 1))      WHERE model LIKE 'Cadillac %';
UPDATE Germany_Cars_Cleaned SET model = TRIM(SUBSTR(model, LENGTH('Daewoo') + 1))        WHERE model LIKE 'Daewoo %';
UPDATE Germany_Cars_Cleaned SET model = TRIM(SUBSTR(model, LENGTH('Infiniti') + 1))      WHERE model LIKE 'Infiniti %';
UPDATE Germany_Cars_Cleaned SET model = TRIM(SUBSTR(model, LENGTH('Ssangyong') + 1))     WHERE model LIKE 'Ssangyong %';
UPDATE Germany_Cars_Cleaned SET model = TRIM(SUBSTR(model, LENGTH('SsangYong') + 1))     WHERE model LIKE 'SsangYong %';
UPDATE Germany_Cars_Cleaned SET model = TRIM(SUBSTR(model, LENGTH('Rover') + 1))         WHERE model LIKE 'Rover %';
UPDATE Germany_Cars_Cleaned SET model = TRIM(SUBSTR(model, LENGTH('Lada') + 1))          WHERE model LIKE 'Lada %';
UPDATE Germany_Cars_Cleaned SET model = TRIM(SUBSTR(model, LENGTH('Daihatsu') + 1))      WHERE model LIKE 'Daihatsu %';
UPDATE Germany_Cars_Cleaned SET model = TRIM(SUBSTR(model, LENGTH('Isuzu') + 1))         WHERE model LIKE 'Isuzu %';
UPDATE Germany_Cars_Cleaned SET model = TRIM(SUBSTR(model, LENGTH('smart') + 1))         WHERE model LIKE 'smart %';
UPDATE Germany_Cars_Cleaned SET model = TRIM(SUBSTR(model, LENGTH('Chrysler') + 1))      WHERE model LIKE 'Chrysler %';
UPDATE Germany_Cars_Cleaned SET model = TRIM(SUBSTR(model, LENGTH('Proton') + 1))        WHERE model LIKE 'Proton %';

-- ============================================================
-- PASUL 2: GRUPARE MODELE MERCEDES-BENZ
-- ATENȚIE: Ordinea contează! Clasele mai specifice (GLA, GLB,
-- GLC, GLE, GLK) trebuie procesate ÎNAINTE de GL/GLS general
-- ============================================================

-- A-Class (AMG A inclus)
UPDATE Germany_Cars_Cleaned SET model = 'A-Class'
WHERE brand = 'mercedes-benz'
  AND (model LIKE 'A %' OR model LIKE 'AMG A %' OR model = 'A-Class');

-- B-Class
UPDATE Germany_Cars_Cleaned SET model = 'B-Class'
WHERE brand = 'mercedes-benz'
  AND model LIKE 'B %';

-- C-Class (AMG C inclus)
UPDATE Germany_Cars_Cleaned SET model = 'C-Class'
WHERE brand = 'mercedes-benz'
  AND (model LIKE 'C %' OR model LIKE 'AMG C %' OR model LIKE 'C 3% AMG' OR model LIKE 'C 5% AMG');

-- E-Class (AMG E inclus)
UPDATE Germany_Cars_Cleaned SET model = 'E-Class'
WHERE brand = 'mercedes-benz'
  AND (model LIKE 'E %' OR model LIKE 'AMG E %');

-- S-Class (AMG S + Maybach S inclus)
UPDATE Germany_Cars_Cleaned SET model = 'S-Class'
WHERE brand = 'mercedes-benz'
  AND (model LIKE 'S %' OR model LIKE 'AMG S %' OR model LIKE 'Maybach S%' OR model LIKE 'Maybach S-%');

-- G-Class (AMG G inclus)
UPDATE Germany_Cars_Cleaned SET model = 'G-Class'
WHERE brand = 'mercedes-benz'
  AND (model LIKE 'G %' OR model LIKE 'AMG G %' OR model = 'G');

-- CLA
UPDATE Germany_Cars_Cleaned SET model = 'CLA'
WHERE brand = 'mercedes-benz'
  AND model LIKE 'CLA%';

-- CLK
UPDATE Germany_Cars_Cleaned SET model = 'CLK'
WHERE brand = 'mercedes-benz'
  AND model LIKE 'CLK%';

-- CLS
UPDATE Germany_Cars_Cleaned SET model = 'CLS'
WHERE brand = 'mercedes-benz'
  AND model LIKE 'CLS%';

-- CL (după CLA, CLK, CLS ca să nu le prindă)
UPDATE Germany_Cars_Cleaned SET model = 'CL'
WHERE brand = 'mercedes-benz'
  AND (model LIKE 'CL %' OR model = 'CL');

-- SLK / SLC
UPDATE Germany_Cars_Cleaned SET model = 'SLK'
WHERE brand = 'mercedes-benz'
  AND (model LIKE 'SLK%' OR model LIKE 'SLC%');

-- SL-Class (SL urmat de spațiu + număr)
UPDATE Germany_Cars_Cleaned SET model = 'SL-Class'
WHERE brand = 'mercedes-benz'
  AND model LIKE 'SL %';

-- SLS / SLR (modele speciale)
UPDATE Germany_Cars_Cleaned SET model = 'SLS'
WHERE brand = 'mercedes-benz' AND model LIKE 'SLS%';

UPDATE Germany_Cars_Cleaned SET model = 'SLR'
WHERE brand = 'mercedes-benz' AND model LIKE 'SLR%';

-- AMG GT
UPDATE Germany_Cars_Cleaned SET model = 'AMG GT'
WHERE brand = 'mercedes-benz' AND model LIKE 'AMG GT%';

-- GLA
UPDATE Germany_Cars_Cleaned SET model = 'GLA'
WHERE brand = 'mercedes-benz' AND model LIKE 'GLA%';

-- GLB
UPDATE Germany_Cars_Cleaned SET model = 'GLB'
WHERE brand = 'mercedes-benz' AND model LIKE 'GLB%';

-- GLC
UPDATE Germany_Cars_Cleaned SET model = 'GLC'
WHERE brand = 'mercedes-benz' AND model LIKE 'GLC%';

-- GLE (inclusiv ML / M-Class -> GLE)
UPDATE Germany_Cars_Cleaned SET model = 'GLE'
WHERE brand = 'mercedes-benz'
  AND (model LIKE 'GLE%' OR model LIKE 'ML %' OR model LIKE 'M %' OR model LIKE 'ML%');

-- GLK
UPDATE Germany_Cars_Cleaned SET model = 'GLK'
WHERE brand = 'mercedes-benz' AND model LIKE 'GLK%';

-- GL-Class / GLS (DUPĂ GLA, GLB, GLC, GLE, GLK!)
UPDATE Germany_Cars_Cleaned SET model = 'GLS'
WHERE brand = 'mercedes-benz'
  AND (model LIKE 'GLS%' OR model LIKE 'GL %');

-- V-Class / Vans
UPDATE Germany_Cars_Cleaned SET model = 'V-Class'
WHERE brand = 'mercedes-benz'
  AND (model LIKE 'V %' OR model = 'V' OR model LIKE 'Viano%' OR model LIKE 'Vito%');

-- EQ Familie (mașini electrice Mercedes)
UPDATE Germany_Cars_Cleaned SET model = 'EQA'  WHERE brand = 'mercedes-benz' AND model LIKE 'EQA%';
UPDATE Germany_Cars_Cleaned SET model = 'EQB'  WHERE brand = 'mercedes-benz' AND model LIKE 'EQB%';
UPDATE Germany_Cars_Cleaned SET model = 'EQC'  WHERE brand = 'mercedes-benz' AND model LIKE 'EQC%';
UPDATE Germany_Cars_Cleaned SET model = 'EQE'  WHERE brand = 'mercedes-benz' AND model LIKE 'EQE%';
UPDATE Germany_Cars_Cleaned SET model = 'EQS'  WHERE brand = 'mercedes-benz' AND model LIKE 'EQS%';
UPDATE Germany_Cars_Cleaned SET model = 'EQV'  WHERE brand = 'mercedes-benz' AND model LIKE 'EQV%';

-- R-Class
UPDATE Germany_Cars_Cleaned SET model = 'R-Class'
WHERE brand = 'mercedes-benz' AND model LIKE 'R %';

-- Modele comerciale / speciale
UPDATE Germany_Cars_Cleaned SET model = 'Sprinter' WHERE brand = 'mercedes-benz' AND model LIKE 'Sprinter%';
UPDATE Germany_Cars_Cleaned SET model = 'Citan'    WHERE brand = 'mercedes-benz' AND model LIKE 'Citan%';
UPDATE Germany_Cars_Cleaned SET model = 'Marco Polo' WHERE brand = 'mercedes-benz' AND model LIKE 'Marco Polo%';
UPDATE Germany_Cars_Cleaned SET model = 'T-Class'  WHERE brand = 'mercedes-benz' AND model LIKE 'T-Class%';
UPDATE Germany_Cars_Cleaned SET model = 'Vaneo'    WHERE brand = 'mercedes-benz' AND model LIKE 'Vaneo%';
UPDATE Germany_Cars_Cleaned SET model = 'Vario'    WHERE brand = 'mercedes-benz' AND model LIKE 'Vario%';
UPDATE Germany_Cars_Cleaned SET model = 'Atego'    WHERE brand = 'mercedes-benz' AND model LIKE 'Atego%';
UPDATE Germany_Cars_Cleaned SET model = 'X-Class'  WHERE brand = 'mercedes-benz' AND (model LIKE 'X %' OR model = 'X-Class');

-- ============================================================
-- GRUPARE MODELE BMW
-- ============================================================

-- 1 Series: 11x, 12x, 13x, 14x, 1er M Coupé
UPDATE Germany_Cars_Cleaned SET model = '1 Series'
WHERE brand = 'bmw'
  AND (
    model LIKE '11_' OR model LIKE '12_' OR model LIKE '13_' OR model LIKE '14_'
    OR model LIKE '1er%'
  );

-- 2 Series: 21x, 22x, 23x, 24x, M2
UPDATE Germany_Cars_Cleaned SET model = '2 Series'
WHERE brand = 'bmw'
  AND (
    model LIKE '21_' OR model LIKE '22_' OR model LIKE '23_' OR model LIKE '24_'
    OR model = 'M2' OR model LIKE 'M2 %'
  );

-- 3 Series: 31x, 32x, 33x, 34x, M3
UPDATE Germany_Cars_Cleaned SET model = '3 Series'
WHERE brand = 'bmw'
  AND (
    model LIKE '31_' OR model LIKE '32_' OR model LIKE '33_' OR model LIKE '34_'
    OR model = 'M3' OR model LIKE 'M3 %'
  );

-- 4 Series: 41x, 42x, 43x, 44x, M4
UPDATE Germany_Cars_Cleaned SET model = '4 Series'
WHERE brand = 'bmw'
  AND (
    model LIKE '41_' OR model LIKE '42_' OR model LIKE '43_' OR model LIKE '44_'
    OR model = 'M4' OR model LIKE 'M4 %'
  );

-- 5 Series: 51x, 52x, 53x, 54x, 55x, M5
UPDATE Germany_Cars_Cleaned SET model = '5 Series'
WHERE brand = 'bmw'
  AND (
    model LIKE '51_' OR model LIKE '52_' OR model LIKE '53_' OR model LIKE '54_' OR model LIKE '55_'
    OR model = 'M5' OR model LIKE 'M5 %' OR model LIKE 'M550%'
  );

-- 6 Series: 62x, 63x, 64x, 65x, M6
UPDATE Germany_Cars_Cleaned SET model = '6 Series'
WHERE brand = 'bmw'
  AND (
    model LIKE '62_' OR model LIKE '63_' OR model LIKE '64_' OR model LIKE '65_'
    OR model = 'M6' OR model LIKE 'M6 %'
  );

-- 7 Series: 72x, 73x, 74x, 75x, 76x, i7
UPDATE Germany_Cars_Cleaned SET model = '7 Series'
WHERE brand = 'bmw'
  AND (
    model LIKE '72_' OR model LIKE '73_' OR model LIKE '74_' OR model LIKE '75_' OR model LIKE '76_'
    OR model = 'i7' OR model LIKE 'i7 %'
  );

-- 8 Series: 84x, 85x, M8, M850
UPDATE Germany_Cars_Cleaned SET model = '8 Series'
WHERE brand = 'bmw'
  AND (
    model LIKE '84_' OR model LIKE '85_'
    OR model = 'M8' OR model LIKE 'M8 %' OR model LIKE 'M850%'
  );

-- Gama X (eliminăm motorizarea, păstrăm X+număr)
UPDATE Germany_Cars_Cleaned SET model = 'X1'  WHERE brand = 'bmw' AND (model = 'X1'  OR model LIKE 'X1 %');
UPDATE Germany_Cars_Cleaned SET model = 'X2'  WHERE brand = 'bmw' AND (model = 'X2'  OR model LIKE 'X2 %' OR model LIKE 'X2 M%');
UPDATE Germany_Cars_Cleaned SET model = 'X3'  WHERE brand = 'bmw' AND (model = 'X3'  OR model LIKE 'X3 %' OR model LIKE 'X3 M%');
UPDATE Germany_Cars_Cleaned SET model = 'X4'  WHERE brand = 'bmw' AND (model = 'X4'  OR model LIKE 'X4 %' OR model LIKE 'X4 M%');
UPDATE Germany_Cars_Cleaned SET model = 'X5'  WHERE brand = 'bmw' AND (model = 'X5'  OR model LIKE 'X5 %' OR model LIKE 'X5 M%');
UPDATE Germany_Cars_Cleaned SET model = 'X6'  WHERE brand = 'bmw' AND (model = 'X6'  OR model LIKE 'X6 %' OR model LIKE 'X6 M%');
UPDATE Germany_Cars_Cleaned SET model = 'X7'  WHERE brand = 'bmw' AND (model = 'X7'  OR model LIKE 'X7 %' OR model LIKE 'X7 M%');
UPDATE Germany_Cars_Cleaned SET model = 'XM'  WHERE brand = 'bmw' AND (model = 'XM'  OR model LIKE 'XM %');

-- Gama Z
UPDATE Germany_Cars_Cleaned SET model = 'Z3'  WHERE brand = 'bmw' AND (model = 'Z3'  OR model LIKE 'Z3 %' OR model LIKE 'Z3 M%');
UPDATE Germany_Cars_Cleaned SET model = 'Z4'  WHERE brand = 'bmw' AND (model = 'Z4'  OR model LIKE 'Z4 %' OR model LIKE 'Z4 M%');
UPDATE Germany_Cars_Cleaned SET model = 'Z8'  WHERE brand = 'bmw' AND (model = 'Z8'  OR model LIKE 'Z8 %');

-- Gama i (electrice)
UPDATE Germany_Cars_Cleaned SET model = 'i3'  WHERE brand = 'bmw' AND (model = 'i3'  OR model LIKE 'i3 %');
UPDATE Germany_Cars_Cleaned SET model = 'i4'  WHERE brand = 'bmw' AND (model = 'i4'  OR model LIKE 'i4 %');
UPDATE Germany_Cars_Cleaned SET model = 'i5'  WHERE brand = 'bmw' AND (model = 'i5'  OR model LIKE 'i5 %');
UPDATE Germany_Cars_Cleaned SET model = 'i8'  WHERE brand = 'bmw' AND (model = 'i8'  OR model LIKE 'i8 %');
UPDATE Germany_Cars_Cleaned SET model = 'iX'  WHERE brand = 'bmw' AND (model = 'iX'  OR model LIKE 'iX %');
UPDATE Germany_Cars_Cleaned SET model = 'iX1' WHERE brand = 'bmw' AND (model = 'iX1' OR model LIKE 'iX1 %');
UPDATE Germany_Cars_Cleaned SET model = 'iX3' WHERE brand = 'bmw' AND (model = 'iX3' OR model LIKE 'iX3 %');

-- Active Hybrid
UPDATE Germany_Cars_Cleaned SET model = '3 Series' WHERE brand = 'bmw' AND model LIKE 'Active Hybrid 3%';
UPDATE Germany_Cars_Cleaned SET model = '5 Series' WHERE brand = 'bmw' AND model LIKE 'Active Hybrid 5%';
UPDATE Germany_Cars_Cleaned SET model = '7 Series' WHERE brand = 'bmw' AND model LIKE 'Active Hybrid 7%';

-- ============================================================
-- GRUPARE MODELE AUDI
-- ============================================================

-- A1
UPDATE Germany_Cars_Cleaned SET model = 'A1'
WHERE brand = 'audi' AND (model LIKE 'A1%' OR model LIKE 'S1%');

-- A2
UPDATE Germany_Cars_Cleaned SET model = 'A2'
WHERE brand = 'audi' AND model LIKE 'A2%';

-- A3 / S3 / RS3
UPDATE Germany_Cars_Cleaned SET model = 'A3'
WHERE brand = 'audi' AND (model LIKE 'A3%' OR model LIKE 'S3%' OR model LIKE 'RS3%' OR model LIKE 'RS 3%');

-- A4 / S4 / RS4 / Allroad A4
UPDATE Germany_Cars_Cleaned SET model = 'A4'
WHERE brand = 'audi'
  AND (model LIKE 'A4%' OR model LIKE 'S4%' OR model LIKE 'RS4%' OR model LIKE 'RS 4%' OR model LIKE 'A4 allroad%');

-- A5 / S5 / RS5
UPDATE Germany_Cars_Cleaned SET model = 'A5'
WHERE brand = 'audi' AND (model LIKE 'A5%' OR model LIKE 'S5%' OR model LIKE 'RS5%' OR model LIKE 'RS 5%');

-- A6 / S6 / RS6 / Allroad A6
UPDATE Germany_Cars_Cleaned SET model = 'A6'
WHERE brand = 'audi'
  AND (model LIKE 'A6%' OR model LIKE 'S6%' OR model LIKE 'RS6%' OR model LIKE 'RS 6%'
       OR model LIKE 'A6 allroad%' OR model = 'Allroad');

-- A7 / S7 / RS7
UPDATE Germany_Cars_Cleaned SET model = 'A7'
WHERE brand = 'audi' AND (model LIKE 'A7%' OR model LIKE 'S7%' OR model LIKE 'RS7%' OR model LIKE 'RS 7%');

-- A8 / S8
UPDATE Germany_Cars_Cleaned SET model = 'A8'
WHERE brand = 'audi' AND (model LIKE 'A8%' OR model LIKE 'S8%');

-- TT / TTS / TT RS (înainte de alte reguli ca să nu fie ambiguitate)
UPDATE Germany_Cars_Cleaned SET model = 'TT'
WHERE brand = 'audi' AND (model LIKE 'TT%');

-- R8
UPDATE Germany_Cars_Cleaned SET model = 'R8'
WHERE brand = 'audi' AND (model = 'R8' OR model LIKE 'R8 %');

-- Q2
UPDATE Germany_Cars_Cleaned SET model = 'Q2'
WHERE brand = 'audi' AND (model LIKE 'Q2%' OR model LIKE 'SQ2%');

-- Q3 / RS Q3
UPDATE Germany_Cars_Cleaned SET model = 'Q3'
WHERE brand = 'audi' AND (model LIKE 'Q3%' OR model LIKE 'RS Q3%' OR model LIKE 'RSQ3%');

-- Q4 e-tron
UPDATE Germany_Cars_Cleaned SET model = 'Q4 e-tron'
WHERE brand = 'audi' AND model LIKE 'Q4%';

-- Q5 / SQ5
UPDATE Germany_Cars_Cleaned SET model = 'Q5'
WHERE brand = 'audi' AND (model LIKE 'Q5%' OR model LIKE 'SQ5%');

-- Q7 / SQ7
UPDATE Germany_Cars_Cleaned SET model = 'Q7'
WHERE brand = 'audi' AND (model LIKE 'Q7%' OR model LIKE 'SQ7%');

-- Q8 / SQ8 / RS Q8 / Q8 e-tron
UPDATE Germany_Cars_Cleaned SET model = 'Q8'
WHERE brand = 'audi'
  AND (model LIKE 'Q8%' OR model LIKE 'SQ8%' OR model LIKE 'RS Q8%' OR model LIKE 'RSQ8%');

-- e-tron GT
UPDATE Germany_Cars_Cleaned SET model = 'e-tron GT'
WHERE brand = 'audi' AND model LIKE 'e-tron GT%';

-- e-tron (general, după e-tron GT)
UPDATE Germany_Cars_Cleaned SET model = 'e-tron'
WHERE brand = 'audi' AND (model LIKE 'e-tron%' OR model = 'e-tron');

-- QUATTRO (model clasic)
UPDATE Germany_Cars_Cleaned SET model = 'QUATTRO'
WHERE brand = 'audi' AND model LIKE 'QUATTRO%';

-- Cabriolet (clasic)
UPDATE Germany_Cars_Cleaned SET model = 'Cabriolet'
WHERE brand = 'audi' AND model LIKE 'Cabriolet%';

-- ============================================================
-- GRUPARE MODELE VOLKSWAGEN
-- ============================================================

-- Transporter / Multivan / Caravelle / California (T4, T5, T6, T7)
UPDATE Germany_Cars_Cleaned SET model = 'Transporter'
WHERE brand = 'volkswagen'
  AND (
    model LIKE 'T4%' OR model LIKE 'T5%' OR model LIKE 'T6%' OR model LIKE 'T7%'
    OR model LIKE 'Transporter%'
    OR model LIKE 'Multivan%'
    OR model LIKE 'Caravelle%'
    OR model LIKE 'California%'
    OR model LIKE 'Grand California%'
  );

-- Golf (GTI, R, Plus, Sportsvan, e-Golf, Cabriolet, Variant, GTD, GTE)
UPDATE Germany_Cars_Cleaned SET model = 'Golf'
WHERE brand = 'volkswagen'
  AND (model LIKE 'Golf%' OR model LIKE 'e-Golf%' OR model = 'Cross Golf');

-- Passat (CC, Variant, Alltrack)
UPDATE Germany_Cars_Cleaned SET model = 'Passat'
WHERE brand = 'volkswagen'
  AND (model LIKE 'Passat%' OR model LIKE 'CC%');

-- Polo (GTI, Cross, Variant, R WRC)
UPDATE Germany_Cars_Cleaned SET model = 'Polo'
WHERE brand = 'volkswagen'
  AND (model LIKE 'Polo%' OR model LIKE 'Cross Polo%');

-- Beetle / New Beetle / Käfer
UPDATE Germany_Cars_Cleaned SET model = 'Beetle'
WHERE brand = 'volkswagen'
  AND (model LIKE 'Beetle%' OR model LIKE 'New Beetle%' OR model LIKE 'Käfer%');

-- Tiguan / Tiguan Allspace
UPDATE Germany_Cars_Cleaned SET model = 'Tiguan'
WHERE brand = 'volkswagen' AND model LIKE 'Tiguan%';

-- Touareg
UPDATE Germany_Cars_Cleaned SET model = 'Touareg'
WHERE brand = 'volkswagen' AND model LIKE 'Touareg%';

-- Touran / Cross Touran
UPDATE Germany_Cars_Cleaned SET model = 'Touran'
WHERE brand = 'volkswagen' AND (model LIKE 'Touran%' OR model LIKE 'Cross Touran%');

-- Sharan
UPDATE Germany_Cars_Cleaned SET model = 'Sharan'
WHERE brand = 'volkswagen' AND model LIKE 'Sharan%';

-- ID Familie
UPDATE Germany_Cars_Cleaned SET model = 'ID.3'    WHERE brand = 'volkswagen' AND model LIKE 'ID.3%';
UPDATE Germany_Cars_Cleaned SET model = 'ID.4'    WHERE brand = 'volkswagen' AND model LIKE 'ID.4%';
UPDATE Germany_Cars_Cleaned SET model = 'ID.5'    WHERE brand = 'volkswagen' AND model LIKE 'ID.5%';
UPDATE Germany_Cars_Cleaned SET model = 'ID. Buzz' WHERE brand = 'volkswagen' AND model LIKE 'ID. Buzz%';

-- Altele VW
UPDATE Germany_Cars_Cleaned SET model = 'Caddy'    WHERE brand = 'volkswagen' AND model LIKE 'Caddy%';
UPDATE Germany_Cars_Cleaned SET model = 'Crafter'  WHERE brand = 'volkswagen' AND model LIKE 'Crafter%';
UPDATE Germany_Cars_Cleaned SET model = 'Amarok'   WHERE brand = 'volkswagen' AND model LIKE 'Amarok%';
UPDATE Germany_Cars_Cleaned SET model = 'Arteon'   WHERE brand = 'volkswagen' AND model LIKE 'Arteon%';
UPDATE Germany_Cars_Cleaned SET model = 'Taigo'    WHERE brand = 'volkswagen' AND model LIKE 'Taigo%';
UPDATE Germany_Cars_Cleaned SET model = 'T-Cross'  WHERE brand = 'volkswagen' AND model LIKE 'T-Cross%';
UPDATE Germany_Cars_Cleaned SET model = 'T-Roc'    WHERE brand = 'volkswagen' AND model LIKE 'T-Roc%';
UPDATE Germany_Cars_Cleaned SET model = 'Scirocco' WHERE brand = 'volkswagen' AND model LIKE 'Scirocco%';
UPDATE Germany_Cars_Cleaned SET model = 'Eos'      WHERE brand = 'volkswagen' AND model LIKE 'Eos%';
UPDATE Germany_Cars_Cleaned SET model = 'Phaeton'  WHERE brand = 'volkswagen' AND model LIKE 'Phaeton%';
UPDATE Germany_Cars_Cleaned SET model = 'Lupo'     WHERE brand = 'volkswagen' AND model LIKE 'Lupo%';
UPDATE Germany_Cars_Cleaned SET model = 'Fox'      WHERE brand = 'volkswagen' AND model LIKE 'Fox%';
UPDATE Germany_Cars_Cleaned SET model = 'Jetta'    WHERE brand = 'volkswagen' AND model LIKE 'Jetta%';
UPDATE Germany_Cars_Cleaned SET model = 'Bora'     WHERE brand = 'volkswagen' AND model LIKE 'Bora%';
UPDATE Germany_Cars_Cleaned SET model = 'up!'      WHERE brand = 'volkswagen' AND (model LIKE 'up!%' OR model LIKE 'e-up!%');
UPDATE Germany_Cars_Cleaned SET model = 'Atlas'    WHERE brand = 'volkswagen' AND model LIKE 'Atlas%';
UPDATE Germany_Cars_Cleaned SET model = 'XL1'      WHERE brand = 'volkswagen' AND model LIKE 'XL1%';
UPDATE Germany_Cars_Cleaned SET model = 'LT'       WHERE brand = 'volkswagen' AND model LIKE 'LT%';
UPDATE Germany_Cars_Cleaned SET model = 'Bus'      WHERE brand = 'volkswagen' AND model LIKE 'Bus%';

-- ============================================================
-- GRUPARE MODELE PORSCHE
-- ============================================================

-- 911: 991, 992, 993, 996, 997, classic 911
UPDATE Germany_Cars_Cleaned SET model = '911'
WHERE brand = 'porsche'
  AND (
    model LIKE '911%' OR model LIKE '991%' OR model LIKE '992%'
    OR model LIKE '993%' OR model LIKE '996%' OR model LIKE '997%'
  );

-- 718 / Boxster / Cayman
UPDATE Germany_Cars_Cleaned SET model = '718'
WHERE brand = 'porsche'
  AND (model LIKE '718%' OR model LIKE 'Boxster%' OR model LIKE 'Cayman%');

-- Cayenne, Panamera, Macan, Taycan (directe)
UPDATE Germany_Cars_Cleaned SET model = 'Cayenne'   WHERE brand = 'porsche' AND model LIKE 'Cayenne%';
UPDATE Germany_Cars_Cleaned SET model = 'Panamera'  WHERE brand = 'porsche' AND model LIKE 'Panamera%';
UPDATE Germany_Cars_Cleaned SET model = 'Macan'     WHERE brand = 'porsche' AND model LIKE 'Macan%';
UPDATE Germany_Cars_Cleaned SET model = 'Taycan'    WHERE brand = 'porsche' AND model LIKE 'Taycan%';

-- Modele clasice Porsche
UPDATE Germany_Cars_Cleaned SET model = 'Targa'      WHERE brand = 'porsche' AND model LIKE 'Targa%';
UPDATE Germany_Cars_Cleaned SET model = 'Carrera GT' WHERE brand = 'porsche' AND model LIKE 'Carrera GT%';
UPDATE Germany_Cars_Cleaned SET model = '918'        WHERE brand = 'porsche' AND model LIKE '918%';
UPDATE Germany_Cars_Cleaned SET model = '356'        WHERE brand = 'porsche' AND model LIKE '356%';

-- ============================================================
-- GRUPARE MODELE MINI
-- ============================================================

-- Countryman (orice MINI cu Countryman)
UPDATE Germany_Cars_Cleaned SET model = 'Countryman'
WHERE brand = 'mini' AND model LIKE '%Countryman%';

-- Clubman (orice MINI cu Clubman)
UPDATE Germany_Cars_Cleaned SET model = 'Clubman'
WHERE brand = 'mini' AND model LIKE '%Clubman%';

-- Paceman (orice MINI cu Paceman)
UPDATE Germany_Cars_Cleaned SET model = 'Paceman'
WHERE brand = 'mini' AND model LIKE '%Paceman%';

-- Cabrio / Convertible
UPDATE Germany_Cars_Cleaned SET model = 'Cabrio'
WHERE brand = 'mini'
  AND (model LIKE '%Cabrio%' OR model LIKE '%Convertible%' OR model LIKE '%Cabriolet%');

-- Coupe / Roadster
UPDATE Germany_Cars_Cleaned SET model = 'Coupe'
WHERE brand = 'mini'
  AND (model LIKE '%Coupe%' OR model LIKE '%Roadster%');

-- Hatch / Hardtop (toate celelalte)
UPDATE Germany_Cars_Cleaned SET model = 'Hatch'
WHERE brand = 'mini'
  AND model NOT IN ('Countryman','Clubman','Paceman','Cabrio','Coupe');

-- ============================================================
-- GRUPARE MODELE FIAT
-- ============================================================

-- 500 (inclusiv 500X, 500L, 500C, 500e, 595 Abarth)
UPDATE Germany_Cars_Cleaned SET model = '500'
WHERE brand = 'fiat'
  AND (
    model LIKE '500%'
    OR model LIKE '595 Abarth%'
  );

-- Punto (Grande Punto, Punto Evo, Punto Abarth, Punto Pure)
UPDATE Germany_Cars_Cleaned SET model = 'Punto'
WHERE brand = 'fiat'
  AND (model LIKE 'Punto%' OR model LIKE 'Grande Punto%');

-- Panda (New Panda inclus)
UPDATE Germany_Cars_Cleaned SET model = 'Panda'
WHERE brand = 'fiat' AND (model LIKE 'Panda%' OR model LIKE 'New Panda%');

-- Tipo
UPDATE Germany_Cars_Cleaned SET model = 'Tipo' WHERE brand = 'fiat' AND model LIKE 'Tipo%';

-- Doblo / E-Doblo
UPDATE Germany_Cars_Cleaned SET model = 'Doblo'
WHERE brand = 'fiat' AND (model LIKE 'Doblo%' OR model LIKE 'E-Doblo%');

-- Ducato
UPDATE Germany_Cars_Cleaned SET model = 'Ducato' WHERE brand = 'fiat' AND model LIKE 'Ducato%';

-- Bravo / Brava
UPDATE Germany_Cars_Cleaned SET model = 'Bravo' WHERE brand = 'fiat' AND (model LIKE 'Bravo%' OR model LIKE 'Brava%');

-- Altele Fiat
UPDATE Germany_Cars_Cleaned SET model = 'Linea'     WHERE brand = 'fiat' AND model LIKE 'Linea%';
UPDATE Germany_Cars_Cleaned SET model = 'Freemont'  WHERE brand = 'fiat' AND model LIKE 'Freemont%';
UPDATE Germany_Cars_Cleaned SET model = 'Fullback'  WHERE brand = 'fiat' AND model LIKE 'Fullback%';
UPDATE Germany_Cars_Cleaned SET model = 'Qubo'      WHERE brand = 'fiat' AND model LIKE 'Qubo%';
UPDATE Germany_Cars_Cleaned SET model = 'Sedici'    WHERE brand = 'fiat' AND model LIKE 'Sedici%';
UPDATE Germany_Cars_Cleaned SET model = 'Scudo'     WHERE brand = 'fiat' AND model LIKE 'Scudo%';
UPDATE Germany_Cars_Cleaned SET model = 'Fiorino'   WHERE brand = 'fiat' AND model LIKE 'Fiorino%';
UPDATE Germany_Cars_Cleaned SET model = 'Talento'   WHERE brand = 'fiat' AND model LIKE 'Talento%';
UPDATE Germany_Cars_Cleaned SET model = 'Ulysse'    WHERE brand = 'fiat' AND model LIKE 'Ulysse%';
UPDATE Germany_Cars_Cleaned SET model = 'Multipla'  WHERE brand = 'fiat' AND model LIKE 'Multipla%';
UPDATE Germany_Cars_Cleaned SET model = 'Seicento'  WHERE brand = 'fiat' AND model LIKE 'Seicento%';
UPDATE Germany_Cars_Cleaned SET model = 'Stilo'     WHERE brand = 'fiat' AND model LIKE 'Stilo%';
UPDATE Germany_Cars_Cleaned SET model = 'Idea'      WHERE brand = 'fiat' AND model LIKE 'Idea%';
UPDATE Germany_Cars_Cleaned SET model = 'Croma'     WHERE brand = 'fiat' AND model LIKE 'Croma%';
UPDATE Germany_Cars_Cleaned SET model = 'Strada'    WHERE brand = 'fiat' AND model LIKE 'Strada%';
UPDATE Germany_Cars_Cleaned SET model = '124 Spider' WHERE brand = 'fiat' AND model LIKE '124 Spider%';
UPDATE Germany_Cars_Cleaned SET model = 'Punto Evo' WHERE brand = 'fiat' AND model LIKE 'Punto Evo%';
-- Nota: Punto Evo deja prins de Punto mai sus, dar dacă vrei separat decomentează și elimină LIKE 'Punto Evo%' din Punto

-- ============================================================
-- GRUPARE MODELE SMART
-- ============================================================

UPDATE Germany_Cars_Cleaned SET model = 'forTwo'
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

UPDATE Germany_Cars_Cleaned SET model = 'forFour'  WHERE brand = 'smart' AND model LIKE 'forFour%';
UPDATE Germany_Cars_Cleaned SET model = 'roadster' WHERE brand = 'smart' AND model LIKE 'roadster%';
UPDATE Germany_Cars_Cleaned SET model = '#1'       WHERE brand = 'smart' AND (model LIKE '#1%' OR model LIKE 'smart #1%');

-- ============================================================
-- GRUPARE MODELE OPEL
-- ============================================================

-- Corsa (Corsa-e inclus)
UPDATE Germany_Cars_Cleaned SET model = 'Corsa'
WHERE brand = 'opel' AND (model LIKE 'Corsa%');

-- Mokka (Mokka-E, Mokka X inclus)
UPDATE Germany_Cars_Cleaned SET model = 'Mokka'
WHERE brand = 'opel' AND (model LIKE 'Mokka%');

-- Astra
UPDATE Germany_Cars_Cleaned SET model = 'Astra'
WHERE brand = 'opel' AND model LIKE 'Astra%';

-- Insignia
UPDATE Germany_Cars_Cleaned SET model = 'Insignia'
WHERE brand = 'opel' AND model LIKE 'Insignia%';

-- Zafira (Zafira Tourer, Zafira Life)
UPDATE Germany_Cars_Cleaned SET model = 'Zafira'
WHERE brand = 'opel' AND model LIKE 'Zafira%';

-- Grandland (Grandland X)
UPDATE Germany_Cars_Cleaned SET model = 'Grandland'
WHERE brand = 'opel' AND model LIKE 'Grandland%';

-- Crossland (Crossland X)
UPDATE Germany_Cars_Cleaned SET model = 'Crossland'
WHERE brand = 'opel' AND model LIKE 'Crossland%';

-- Meriva
UPDATE Germany_Cars_Cleaned SET model = 'Meriva'  WHERE brand = 'opel' AND model LIKE 'Meriva%';
UPDATE Germany_Cars_Cleaned SET model = 'Adam'    WHERE brand = 'opel' AND model LIKE 'Adam%';
UPDATE Germany_Cars_Cleaned SET model = 'Agila'   WHERE brand = 'opel' AND model LIKE 'Agila%';
UPDATE Germany_Cars_Cleaned SET model = 'Antara'  WHERE brand = 'opel' AND model LIKE 'Antara%';
UPDATE Germany_Cars_Cleaned SET model = 'Cascada' WHERE brand = 'opel' AND model LIKE 'Cascada%';
UPDATE Germany_Cars_Cleaned SET model = 'Combo'   WHERE brand = 'opel' AND (model LIKE 'Combo%');
UPDATE Germany_Cars_Cleaned SET model = 'Frontera' WHERE brand = 'opel' AND model LIKE 'Frontera%';
UPDATE Germany_Cars_Cleaned SET model = 'GT'      WHERE brand = 'opel' AND model = 'GT';
UPDATE Germany_Cars_Cleaned SET model = 'Karl'    WHERE brand = 'opel' AND model LIKE 'Karl%';
UPDATE Germany_Cars_Cleaned SET model = 'Movano'  WHERE brand = 'opel' AND model LIKE 'Movano%';
UPDATE Germany_Cars_Cleaned SET model = 'Omega'   WHERE brand = 'opel' AND model LIKE 'Omega%';
UPDATE Germany_Cars_Cleaned SET model = 'Signum'  WHERE brand = 'opel' AND model LIKE 'Signum%';
UPDATE Germany_Cars_Cleaned SET model = 'Speedster' WHERE brand = 'opel' AND model LIKE 'Speedster%';
UPDATE Germany_Cars_Cleaned SET model = 'Tigra'   WHERE brand = 'opel' AND model LIKE 'Tigra%';
UPDATE Germany_Cars_Cleaned SET model = 'Vectra'  WHERE brand = 'opel' AND model LIKE 'Vectra%';
UPDATE Germany_Cars_Cleaned SET model = 'Vivaro'  WHERE brand = 'opel' AND (model LIKE 'Vivaro%');
UPDATE Germany_Cars_Cleaned SET model = 'Ampera'  WHERE brand = 'opel' AND (model LIKE 'Ampera%');
UPDATE Germany_Cars_Cleaned SET model = 'Rocks-e' WHERE brand = 'opel' AND model LIKE 'Rocks-e%';

-- ============================================================
-- GRUPARE MODELE PEUGEOT
-- ============================================================

-- e-208 -> 208 / e-2008 -> 2008
UPDATE Germany_Cars_Cleaned SET model = '208'  WHERE brand = 'peugeot' AND (model LIKE '208%'  OR model LIKE 'e-208%');
UPDATE Germany_Cars_Cleaned SET model = '2008' WHERE brand = 'peugeot' AND (model LIKE '2008%' OR model LIKE 'e-2008%');

-- Restul modelelor Peugeot (directe)
UPDATE Germany_Cars_Cleaned SET model = '107'    WHERE brand = 'peugeot' AND model LIKE '107%';
UPDATE Germany_Cars_Cleaned SET model = '108'    WHERE brand = 'peugeot' AND model LIKE '108%';
UPDATE Germany_Cars_Cleaned SET model = '206'    WHERE brand = 'peugeot' AND model LIKE '206%';
UPDATE Germany_Cars_Cleaned SET model = '207'    WHERE brand = 'peugeot' AND model LIKE '207%';
UPDATE Germany_Cars_Cleaned SET model = '3008'   WHERE brand = 'peugeot' AND model LIKE '3008%';
UPDATE Germany_Cars_Cleaned SET model = '307'    WHERE brand = 'peugeot' AND model LIKE '307%';
UPDATE Germany_Cars_Cleaned SET model = '308'    WHERE brand = 'peugeot' AND model LIKE '308%';
UPDATE Germany_Cars_Cleaned SET model = '406'    WHERE brand = 'peugeot' AND model LIKE '406%';
UPDATE Germany_Cars_Cleaned SET model = '407'    WHERE brand = 'peugeot' AND model LIKE '407%';
UPDATE Germany_Cars_Cleaned SET model = '408'    WHERE brand = 'peugeot' AND model LIKE '408%';
UPDATE Germany_Cars_Cleaned SET model = '5008'   WHERE brand = 'peugeot' AND model LIKE '5008%';
UPDATE Germany_Cars_Cleaned SET model = '508'    WHERE brand = 'peugeot' AND model LIKE '508%';
UPDATE Germany_Cars_Cleaned SET model = '607'    WHERE brand = 'peugeot' AND model LIKE '607%';
UPDATE Germany_Cars_Cleaned SET model = '807'    WHERE brand = 'peugeot' AND model LIKE '807%';
UPDATE Germany_Cars_Cleaned SET model = '1007'   WHERE brand = 'peugeot' AND model LIKE '1007%';
UPDATE Germany_Cars_Cleaned SET model = '4007'   WHERE brand = 'peugeot' AND model LIKE '4007%';
UPDATE Germany_Cars_Cleaned SET model = '4008'   WHERE brand = 'peugeot' AND model LIKE '4008%';
UPDATE Germany_Cars_Cleaned SET model = 'Bipper' WHERE brand = 'peugeot' AND model LIKE 'Bipper%';
UPDATE Germany_Cars_Cleaned SET model = 'Boxer'  WHERE brand = 'peugeot' AND model LIKE 'Boxer%';
UPDATE Germany_Cars_Cleaned SET model = 'Expert' WHERE brand = 'peugeot' AND model LIKE 'Expert%';
UPDATE Germany_Cars_Cleaned SET model = 'iOn'    WHERE brand = 'peugeot' AND model LIKE 'iOn%';
UPDATE Germany_Cars_Cleaned SET model = 'Partner' WHERE brand = 'peugeot' AND model LIKE 'Partner%';
UPDATE Germany_Cars_Cleaned SET model = 'RCZ'    WHERE brand = 'peugeot' AND model LIKE 'RCZ%';
UPDATE Germany_Cars_Cleaned SET model = 'Rifter' WHERE brand = 'peugeot' AND model LIKE 'Rifter%';
UPDATE Germany_Cars_Cleaned SET model = 'Traveller' WHERE brand = 'peugeot' AND model LIKE 'Traveller%';
UPDATE Germany_Cars_Cleaned SET model = 'Camper' WHERE brand = 'peugeot' AND model LIKE 'Camper%';

-- ============================================================
-- GRUPARE MODELE RENAULT
-- ============================================================

-- Megane E-Tech -> Megane
UPDATE Germany_Cars_Cleaned SET model = 'Megane'
WHERE brand = 'renault' AND (model LIKE 'Megane%' OR model LIKE 'Mégane%');

-- Altele Renault
UPDATE Germany_Cars_Cleaned SET model = 'Clio'         WHERE brand = 'renault' AND model LIKE 'Clio%';
UPDATE Germany_Cars_Cleaned SET model = 'Captur'       WHERE brand = 'renault' AND model LIKE 'Captur%';
UPDATE Germany_Cars_Cleaned SET model = 'Kadjar'       WHERE brand = 'renault' AND model LIKE 'Kadjar%';
UPDATE Germany_Cars_Cleaned SET model = 'Koleos'       WHERE brand = 'renault' AND model LIKE 'Koleos%';
UPDATE Germany_Cars_Cleaned SET model = 'Scenic'       WHERE brand = 'renault' AND (model LIKE 'Scenic%' OR model LIKE 'Grand Scenic%');
UPDATE Germany_Cars_Cleaned SET model = 'Espace'       WHERE brand = 'renault' AND (model LIKE 'Espace%' OR model LIKE 'Grand Espace%');
UPDATE Germany_Cars_Cleaned SET model = 'Laguna'       WHERE brand = 'renault' AND model LIKE 'Laguna%';
UPDATE Germany_Cars_Cleaned SET model = 'Talisman'     WHERE brand = 'renault' AND model LIKE 'Talisman%';
UPDATE Germany_Cars_Cleaned SET model = 'Twingo'       WHERE brand = 'renault' AND model LIKE 'Twingo%';
UPDATE Germany_Cars_Cleaned SET model = 'ZOE'          WHERE brand = 'renault' AND model LIKE 'ZOE%';
UPDATE Germany_Cars_Cleaned SET model = 'Trafic'       WHERE brand = 'renault' AND model LIKE 'Trafic%';
UPDATE Germany_Cars_Cleaned SET model = 'Master'       WHERE brand = 'renault' AND model LIKE 'Master%';
UPDATE Germany_Cars_Cleaned SET model = 'Kangoo'       WHERE brand = 'renault' AND (model LIKE 'Kangoo%');
UPDATE Germany_Cars_Cleaned SET model = 'Modus'        WHERE brand = 'renault' AND (model LIKE 'Modus%' OR model LIKE 'Grand Modus%');
UPDATE Germany_Cars_Cleaned SET model = 'Austral'      WHERE brand = 'renault' AND model LIKE 'Austral%';
UPDATE Germany_Cars_Cleaned SET model = 'Arkana'       WHERE brand = 'renault' AND model LIKE 'Arkana%';
UPDATE Germany_Cars_Cleaned SET model = 'Alpine A110'  WHERE brand = 'renault' AND model LIKE 'Alpine A110%';
UPDATE Germany_Cars_Cleaned SET model = 'Alaskan'      WHERE brand = 'renault' AND model LIKE 'Alaskan%';
UPDATE Germany_Cars_Cleaned SET model = 'Express'      WHERE brand = 'renault' AND model LIKE 'Express%';
UPDATE Germany_Cars_Cleaned SET model = 'Rapid'        WHERE brand = 'renault' AND model LIKE 'Rapid%';
UPDATE Germany_Cars_Cleaned SET model = 'Twizy'        WHERE brand = 'renault' AND model LIKE 'Twizy%';
UPDATE Germany_Cars_Cleaned SET model = 'Wind'         WHERE brand = 'renault' AND model LIKE 'Wind%';
UPDATE Germany_Cars_Cleaned SET model = 'Vel Satis'    WHERE brand = 'renault' AND model LIKE 'Vel Satis%';
UPDATE Germany_Cars_Cleaned SET model = 'Latitude'     WHERE brand = 'renault' AND model LIKE 'Latitude%';
UPDATE Germany_Cars_Cleaned SET model = 'Mascott'      WHERE brand = 'renault' AND model LIKE 'Mascott%';
UPDATE Germany_Cars_Cleaned SET model = 'R11'          WHERE brand = 'renault' AND (model LIKE 'R 11%' OR model = 'R 11');
UPDATE Germany_Cars_Cleaned SET model = 'R6'           WHERE brand = 'renault' AND (model LIKE 'R 6%'  OR model = 'R 6');

-- ============================================================
-- FIN
-- ============================================================

select distinct brand
from Germany_Cars
order by brand desc;
--totul ok aici

select distinct color, count (color) as numar
from Germany_Cars
group by color
order by color desc;
--totul ok aici

select distinct registration_date,count(registration_date) as numar
from Germany_Cars
group by registration_date
order by numar asc;
--totul ok aici

select distinct year,count(year) as numar
from Germany_Cars
group by year
order by numar asc;
--exista un numar ridicat de coloane din transmission_type si fuel_type care au inversate datele cu year

select distinct price_in_euro,count(price_in_euro) as numar
from Germany_Cars
group by price_in_euro
order by numar asc;
--totul ok aici

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
--totul ok aici, coloana va fi stearsa

select distinct fuel_consumption_l_100km,count(fuel_consumption_l_100km) as numar
from Germany_Cars
group by fuel_consumption_l_100km
order by numar asc;
--greseli neglijabile,coloana va fi stearsa

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

--stergem inregistrarile care nu pot fi inversate
update Germany_Cars
set fuel_type=null
where fuel_type not in ('Petrol', 'Diesel','Electric', 'Hybrid', 'LPG','CNG','Hydrogen' , 'Other', 'Ethanol', 'Diesel Hybrid' );

--verificam interogarea
select fuel_type
from Germany_Cars
 where fuel_type not in ('Petrol', 'Diesel','Electric', 'Hybrid', 'LPG','CNG','Hydrogen' , 'Other', 'Ethanol', 'Diesel Hybrid' );


update Germany_Cars
set fuel_type=fuel_consumption_g_km
where fuel_consumption_g_km in('Petrol', 'Diesel', 'Electric', 'Hybrid' );

delete from Germany_Cars
where fuel_type is null and transmission_type='Unknown';

--inlocuim valorile cu year cu valoarea cu fuel_type
update Germany_Cars
set fuel_type=year,
 year=null
where year in ('Petrol', 'Diesel','Electric', 'Hybrid', 'LPG','CNG','Hydrogen' , 'Other', 'Ethanol', 'Diesel Hybrid' );


--verificam
select year, fuel_type
from Germany_Cars
where year in ('Petrol', 'Diesel','Electric', 'Hybrid', 'LPG','CNG','Hydrogen' , 'Other', 'Ethanol', 'Diesel Hybrid' );

--verificam
select year, transmission_type
from Germany_Cars
where year in ('Semi-automatic', 'Manual', 'Automatic', 'Unknown');


--transmisia are deja valoriile, așa ca stergem year
update Germany_Cars
set year=null
where year in ('Semi-automatic', 'Manual', 'Automatic', 'Unknown');

--testam
select year
from Germany_Cars
where year not between 1800 and 2026;

--înlocuim valoriile anormale cu NULL
update Germany_Cars
set year=null
where year not between 1800 and 2026;

--sunt putine, doar 199 deci le stergem pe toate
select *
from Germany_Cars
where year is null;

--anul este foarte important, stergem inregistrarile care nu au anul
delete from Germany_Cars
where year is null;

alter table Germany_Cars
rename column mileage_in_km to km;

alter table Germany_Cars
rename column offer_description to engine_type;


--verificam duplicatele
 SELECT brand, model, color,year, price_in_euro,power_ps,transmission_type,fuel_type, km,engine_type, COUNT(*) as nr
  FROM Germany_Cars
  GROUP BY brand, model, color, year, price_in_euro,power_ps,transmission_type,fuel_type, km, engine_type
  HAVING COUNT(*) > 1
order by nr desc;


alter table Germany_Cars
add column id INTEGER;

update Germany_Cars
set id=rowid;

 SELECT COUNT(*) FROM Germany_Cars
  WHERE id NOT IN (
      SELECT MIN(id)
      FROM Germany_Cars
      GROUP BY brand, model, color, year, price_in_euro,power_ps,transmission_type,fuel_type, km, engine_type
  );

--STERGEM dublurile
delete from Germany_Cars
where id not in(SELECT MIN(id)
      FROM Germany_Cars
      GROUP BY brand, model, color, year, price_in_euro,power_ps,transmission_type,fuel_type, km, engine_type);

select count() from Germany_Cars

--km sunt imortanti deci stergem ce este null
 DELETE FROM Germany_Cars WHERE km IS NULL;

--culoarea nu este importanta, pastram inregistrarile
UPDATE Germany_Cars SET color = 'Unknown' WHERE color IS NULL;


--inlocuim valoriile nule cu media
 UPDATE Germany_Cars
  SET power_ps = (SELECT ROUND(AVG(power_ps), 0) FROM Germany_Cars_Cleaned WHERE power_ps IS NOT NULL)
  WHERE power_ps IS NULL;

 SELECT DISTINCT brand, COUNT(*) as nr FROM Germany_Cars GROUP BY brand ORDER BY brand;
  SELECT DISTINCT color, COUNT(*) as nr FROM Germany_Cars GROUP BY color ORDER BY color;
SELECT DISTINCT transmission_type, COUNT(*) as nr FROM Germany_Cars GROUP BY transmission_type ORDER
  BY transmission_type;
SELECT DISTINCT fuel_type, COUNT(*) as nr FROM Germany_Cars GROUP BY fuel_type ORDER BY fuel_type;



--exista atat diesel hybrid cat si hybrid, le unificam
UPDATE Germany_Cars SET fuel_type = 'Hybrid' WHERE fuel_type = 'Diesel Hybrid';

 SELECT DISTINCT model, COUNT(*) as nr
  FROM Germany_Cars_Cleaned GROUP BY model ORDER BY model;

drop table if exists Germany_Cars_Cleaned;
create table Germany_Cars_Cleaned as
    select id, brand, model, color, year, price_in_euro, power_ps, transmission_type, fuel_type,km,engine_type
    from Germany_Cars;

select distinct Germany_Cars_Cleaned.engine_type from Germany_Cars_Cleaned group by engine_type;

-- ============================================================
-- EXTRAGERE LITRAJ (engine_liters) -- SQLite
-- Aplica pe coloana engine_type (sau inlocuieste cu title)
-- ============================================================


UPDATE Germany_Cars_Cleaned
SET engine_type =CASE

  WHEN engine_type LIKE '%0.8%' THEN '0.8'
  WHEN engine_type LIKE '%1.0%' THEN '1.0'
  WHEN engine_type LIKE '%1.1%' THEN '1.1'
  WHEN engine_type LIKE '%1.2%' THEN '1.2'
  WHEN engine_type LIKE '%1.3%' THEN '1.3'
  WHEN engine_type LIKE '%1.4%' THEN '1.4'
  WHEN engine_type LIKE '%1.5%' THEN '1.5'
  WHEN engine_type LIKE '%1.6%' THEN '1.6'
  WHEN engine_type LIKE '%1.7%' THEN '1.7'
  WHEN engine_type LIKE '%1.8%' THEN '1.8'
  WHEN engine_type LIKE '%1.9%' THEN '1.9'
  WHEN engine_type LIKE '%2.0%' THEN '2.0'
  WHEN engine_type LIKE '%2.2%' THEN '2.2'
  WHEN engine_type LIKE '%2.3%' THEN '2.3'
  WHEN engine_type LIKE '%2.4%' THEN '2.4'
  WHEN engine_type LIKE '%2.5%' THEN '2.5'
  WHEN engine_type LIKE '%2.7%' THEN '2.7'
  WHEN engine_type LIKE '%2.8%' THEN '2.8'
  WHEN engine_type LIKE '%2.9%' THEN '2.9'
  WHEN engine_type LIKE '%3.0%' THEN '3.0'
  WHEN engine_type LIKE '%3.2%' THEN '3.2'
  WHEN engine_type LIKE '%3.5%' THEN '3.5'
  WHEN engine_type LIKE '%3.6%' THEN '3.6'
  WHEN engine_type LIKE '%4.0%' THEN '4.0'
  WHEN engine_type LIKE '%4.2%' THEN '4.2'
  WHEN engine_type LIKE '%4.4%' THEN '4.4'
  WHEN engine_type LIKE '%4.7%' THEN '4.7'
  WHEN engine_type LIKE '%5.0%' THEN '5.0'
  WHEN engine_type LIKE '%5.2%' THEN '5.2'
  WHEN engine_type LIKE '%5.5%' THEN '5.5'
  WHEN engine_type LIKE '%6.0%' THEN '6.0'
  WHEN engine_type LIKE '%6.2%' THEN '6.2'

  WHEN engine_type LIKE '%ELECTRIC%'     THEN 'Electric'
  WHEN engine_type LIKE '%ELEKTRO%'      THEN 'Electric'
  WHEN engine_type LIKE '%E-TRON%'       THEN 'Electric'
  WHEN engine_type LIKE '%ELEKTROMOTOR%' THEN 'Electric'
  WHEN engine_type LIKE '%SKYACTIV-EV%'  THEN 'Electric'
  WHEN engine_type LIKE '% EV %'         THEN 'Electric'

  ELSE 'Unknown'

END;

-- ============================================================
-- VERIFICARE distributie dupa aplicare
-- ============================================================
SELECT engine_type, COUNT(*) AS cnt
FROM Germany_Cars_Cleaned
GROUP BY engine_type
