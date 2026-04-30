  ALTER TABLE SUA_Cars_Cleaned ADD COLUMN id INTEGER;
  UPDATE SUA_Cars_Cleaned SET id = rowid;


  SELECT distinct brand as nr FROM SUA_Cars_Cleaned ORDER BY brand;

  SELECT DISTINCT model, COUNT(*) as nr FROM SUA_Cars_Cleaned GROUP BY model ORDER BY model;

  SELECT DISTINCT model, COUNT(*) as nr
  FROM SUA_Cars_Cleaned
  WHERE brand = 'Volvo'
  GROUP BY model
  ORDER BY model ASC;

 UPDATE SUA_Cars_Cleaned SET model = '240' WHERE model LIKE '%240%';
 UPDATE SUA_Cars_Cleaned SET model = 'C30' WHERE model LIKE '%C30%';
 UPDATE SUA_Cars_Cleaned SET model = 'C40' WHERE model LIKE 'C40%';
 UPDATE SUA_Cars_Cleaned SET model = 'C70' WHERE model LIKE 'C70%';
 UPDATE SUA_Cars_Cleaned SET model = 'S40' WHERE model LIKE 'S40%';
 UPDATE SUA_Cars_Cleaned SET model = 'S60' WHERE model LIKE 'S60%';
 UPDATE SUA_Cars_Cleaned SET model = 'S70' WHERE model LIKE 'S70%';
 UPDATE SUA_Cars_Cleaned SET model = 'S80' WHERE model LIKE 'S80%';
 UPDATE SUA_Cars_Cleaned SET model = 'S90' WHERE model LIKE 'S90%';
 UPDATE SUA_Cars_Cleaned SET model = 'V40' WHERE model LIKE 'V40%';
 UPDATE SUA_Cars_Cleaned SET model = 'V50' WHERE model LIKE 'V50%';
 UPDATE SUA_Cars_Cleaned SET model = '740'WHERE model LIKE '740%' AND brand = 'Volvo';
  UPDATE SUA_Cars_Cleaned SET model = 'S60 Cross Country' WHERE model LIKE 'S60 Cross Country%' AND brand = 'Volvo';
  UPDATE SUA_Cars_Cleaned SET model = 'S60' WHERE model LIKE 'S60%' AND model NOT LIKE 'S60 Cross Country%' AND brand = 'Volvo';
  UPDATE SUA_Cars_Cleaned SET model = 'V60 Cross Country'WHERE model LIKE 'V60 Cross Country%' AND brand = 'Volvo';
  UPDATE SUA_Cars_Cleaned SET model = 'V60'WHERE model LIKE 'V60%' AND model NOT LIKE 'V60 Cross Country%' AND brand = 'Volvo';
  UPDATE SUA_Cars_Cleaned SET model = 'V70'WHERE model LIKE 'V70%' AND brand = 'Volvo';
  UPDATE SUA_Cars_Cleaned SET model = 'V90 Cross Country'WHERE model LIKE 'V90 Cross Country%' AND brand = 'Volvo';
  UPDATE SUA_Cars_Cleaned SET model = 'V90'WHERE model LIKE 'V90%' AND model NOT LIKE 'V90 Cross Country%' AND brand = 'Volvo';
  UPDATE SUA_Cars_Cleaned SET model = 'XC40'WHERE model LIKE 'XC40%' AND brand = 'Volvo';
  UPDATE SUA_Cars_Cleaned SET model = 'XC60' WHERE model LIKE 'XC60%' AND brand = 'Volvo';
  UPDATE SUA_Cars_Cleaned SET model = 'XC70' WHERE model LIKE 'XC70%' AND brand = 'Volvo';
  UPDATE SUA_Cars_Cleaned SET model = 'XC90' WHERE model LIKE 'XC90%' AND brand = 'Volvo';

SELECT DISTINCT model, COUNT(*) as nr
  FROM SUA_Cars_Cleaned
  WHERE brand = 'Acura'
  GROUP BY model
  ORDER BY model ASC;

  UPDATE SUA_Cars_Cleaned SET model = 'CL' WHERE model LIKE 'CL%' AND brand = 'Acura';
  UPDATE SUA_Cars_Cleaned SET model = 'ILX' WHERE model LIKE 'ILX%' AND brand = 'Acura';
  UPDATE SUA_Cars_Cleaned SET model = 'Integra' WHERE model LIKE 'Integra%' AND brand = 'Acura';
  UPDATE SUA_Cars_Cleaned SET model = 'Legend' WHERE model LIKE 'Legend%' AND brand = 'Acura';
  UPDATE SUA_Cars_Cleaned SET model = 'MDX' WHERE model LIKE 'MDX%' AND brand = 'Acura';
  UPDATE SUA_Cars_Cleaned SET model = 'NSX' WHERE model LIKE 'NSX%' AND brand = 'Acura';
  UPDATE SUA_Cars_Cleaned SET model = 'RDX' WHERE model LIKE 'RDX%' AND brand = 'Acura';
  UPDATE SUA_Cars_Cleaned SET model = 'RL' WHERE model LIKE 'RL%' AND model NOT LIKE 'RLX%' AND brand = 'Acura';
  UPDATE SUA_Cars_Cleaned SET model = 'RLX' WHERE model LIKE 'RLX%' AND brand = 'Acura';
  UPDATE SUA_Cars_Cleaned SET model = 'RSX' WHERE model LIKE 'RSX%' AND brand = 'Acura';
  UPDATE SUA_Cars_Cleaned SET model = 'TL' WHERE model LIKE 'TL%' AND model NOT LIKE 'TLX%' AND brand = 'Acura';
  UPDATE SUA_Cars_Cleaned SET model = 'TLX' WHERE model LIKE 'TLX%' AND brand = 'Acura';
  UPDATE SUA_Cars_Cleaned SET model = 'TSX' WHERE model LIKE 'TSX%' AND brand = 'Acura';
  UPDATE SUA_Cars_Cleaned SET model = 'ZDX' WHERE model LIKE 'ZDX%' AND brand = 'Acura';

SELECT DISTINCT model, COUNT(*) as nr
  FROM SUA_Cars_Cleaned
  WHERE brand = 'Audi'
  GROUP BY model
  ORDER BY model ASC;


  -- A series (allroad INAINTE de baza)
  UPDATE SUA_Cars_Cleaned SET model = 'A3' WHERE model LIKE 'A3%' AND brand = 'Audi';
  UPDATE SUA_Cars_Cleaned SET model = 'A4 allroad' WHERE model LIKE 'A4 allroad%' AND brand = 'Audi';
  UPDATE SUA_Cars_Cleaned SET model = 'A4' WHERE model LIKE 'A4%' AND model NOT LIKE 'A4 allroad%' AND brand = 'Audi';
  UPDATE SUA_Cars_Cleaned SET model = 'A5' WHERE model LIKE 'A5%' AND brand = 'Audi';
  UPDATE SUA_Cars_Cleaned SET model = 'A6 allroad' WHERE model LIKE 'A6 allroad%' AND brand = 'Audi';
  UPDATE SUA_Cars_Cleaned SET model = 'A6' WHERE model LIKE 'A6%' AND model NOT LIKE 'A6 allroad%' AND brand = 'Audi';
  UPDATE SUA_Cars_Cleaned SET model = 'A7' WHERE model LIKE 'A7%' AND brand = 'Audi';
  UPDATE SUA_Cars_Cleaned SET model = 'A8' WHERE model LIKE 'A8%' AND brand = 'Audi';

  -- Q series
  UPDATE SUA_Cars_Cleaned SET model = 'Q3' WHERE model LIKE 'Q3%' AND brand = 'Audi';
  UPDATE SUA_Cars_Cleaned SET model = 'Q4 e-tron' WHERE model LIKE 'Q4%' AND brand = 'Audi';
  UPDATE SUA_Cars_Cleaned SET model = 'Q5' WHERE model LIKE 'Q5%' AND brand = 'Audi';
  UPDATE SUA_Cars_Cleaned SET model = 'Q7' WHERE model LIKE 'Q7%' AND brand = 'Audi';
  UPDATE SUA_Cars_Cleaned SET model = 'Q8' WHERE model LIKE 'Q8%' AND brand = 'Audi';

  -- R series
  UPDATE SUA_Cars_Cleaned SET model = 'R8' WHERE model LIKE 'R8%' AND brand = 'Audi';

  -- RS series
  UPDATE SUA_Cars_Cleaned SET model = 'RS 3' WHERE model LIKE 'RS 3%' AND brand = 'Audi';
  UPDATE SUA_Cars_Cleaned SET model = 'RS 4' WHERE model LIKE 'RS 4%' AND brand = 'Audi';
  UPDATE SUA_Cars_Cleaned SET model = 'RS 5' WHERE model LIKE 'RS 5%' AND brand = 'Audi';
  UPDATE SUA_Cars_Cleaned SET model = 'RS 7' WHERE model LIKE 'RS 7%' AND brand = 'Audi';
  UPDATE SUA_Cars_Cleaned SET model = 'RS Q8' WHERE model LIKE 'RS Q8%' AND brand = 'Audi';
  UPDATE SUA_Cars_Cleaned SET model = 'RS e-tron GT' WHERE model LIKE 'RS e-tron GT%' AND brand = 'Audi';
  UPDATE SUA_Cars_Cleaned SET model = 'RS6' WHERE model LIKE 'RS6%' AND brand = 'Audi';

  -- S series
  UPDATE SUA_Cars_Cleaned SET model = 'S3' WHERE model LIKE 'S3%' AND brand = 'Audi';
  UPDATE SUA_Cars_Cleaned SET model = 'S4' WHERE model LIKE 'S4%' AND brand = 'Audi';
  UPDATE SUA_Cars_Cleaned SET model = 'S5' WHERE model LIKE 'S5%' AND brand = 'Audi';
  UPDATE SUA_Cars_Cleaned SET model = 'S6' WHERE model LIKE 'S6%' AND brand = 'Audi';
  UPDATE SUA_Cars_Cleaned SET model = 'S7' WHERE model LIKE 'S7%' AND brand = 'Audi';
  UPDATE SUA_Cars_Cleaned SET model = 'S8' WHERE model LIKE 'S8%' AND brand = 'Audi';
  UPDATE SUA_Cars_Cleaned SET model = 'SQ5' WHERE model LIKE 'SQ5%' AND brand = 'Audi';
  UPDATE SUA_Cars_Cleaned SET model = 'SQ7' WHERE model LIKE 'SQ7%' AND brand = 'Audi';

  -- TT series (RS si TTS PRIMUL)
  UPDATE SUA_Cars_Cleaned SET model = 'TT RS' WHERE model LIKE 'TT RS%' AND brand = 'Audi';
  UPDATE SUA_Cars_Cleaned SET model = 'TTS' WHERE model LIKE 'TTS%' AND brand = 'Audi';
  UPDATE SUA_Cars_Cleaned SET model = 'TT' WHERE model LIKE 'TT%' AND model NOT LIKE 'TT RS%' AND model NOT LIKE 'TTS%' AND brand =
   'Audi';

  -- e-tron (Sportback PRIMUL)

  UPDATE SUA_Cars_Cleaned SET model = 'e-tron' WHERE model LIKE 'e-tron%' AND brand =
  'Audi';

SELECT DISTINCT model, COUNT(*) as nr
  FROM SUA_Cars_Cleaned
  WHERE brand = 'BMW'
  GROUP BY model
  ORDER BY model ASC;

  -- 1 Series
  UPDATE SUA_Cars_Cleaned SET model = '128' WHERE model LIKE '128%' AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = '135' WHERE model LIKE '135%' AND brand = 'BMW';

  -- Legacy
  UPDATE SUA_Cars_Cleaned SET model = '2002' WHERE model LIKE '2002%' AND brand = 'BMW';

  -- 2 Series
  UPDATE SUA_Cars_Cleaned SET model = '228' WHERE model LIKE '228%' AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = '230' WHERE model LIKE '230%' AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = '240' WHERE model LIKE '240%' AND brand = 'BMW';

  -- 3 Series (330e INAINTE de 330)
  UPDATE SUA_Cars_Cleaned SET model = '318' WHERE model LIKE '318%' AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = '320' WHERE model LIKE '320%' AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = '323' WHERE model LIKE '323%' AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = '325' WHERE model LIKE '325%' AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = '328' WHERE model LIKE '328%' AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = '330e' WHERE model LIKE '330e%' AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = '330' WHERE model LIKE '330%' AND model NOT LIKE '330e%' AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = '335' WHERE model LIKE '335%' AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = '340' WHERE model LIKE '340%' AND brand = 'BMW';

  -- 4 Series
  UPDATE SUA_Cars_Cleaned SET model = '428' WHERE model LIKE '428%' AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = '430' WHERE model LIKE '430%' AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = '435' WHERE model LIKE '435%' AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = '440' WHERE model LIKE '440%' AND brand = 'BMW';

  -- 5 Series (530e INAINTE de 530)
  UPDATE SUA_Cars_Cleaned SET model = '525' WHERE model LIKE '525%' AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = '528' WHERE model LIKE '528%' AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = '530e' WHERE model LIKE '530e%' AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = '530' WHERE model LIKE '530%' AND model NOT LIKE '530e%' AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = '535' WHERE model LIKE '535%' AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = '540' WHERE model LIKE '540%' AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = '550' WHERE model LIKE '550%' AND brand = 'BMW';

  -- 6 Series
  UPDATE SUA_Cars_Cleaned SET model = '640' WHERE model LIKE '640%' AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = '645' WHERE model LIKE '645%' AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = '650' WHERE model LIKE '650%' AND brand = 'BMW';

  -- 7 Series (740e si 745e INAINTE)
  UPDATE SUA_Cars_Cleaned SET model = '740e' WHERE model LIKE '740e%' AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = '740' WHERE model LIKE '740%' AND model NOT LIKE '740e%' AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = '745e' WHERE model LIKE '745e%' AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = '745' WHERE model LIKE '745%' AND model NOT LIKE '745e%' AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = '750' WHERE model LIKE '750%' AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = '760' WHERE model LIKE '760%' AND brand = 'BMW';

  -- 8 Series
  UPDATE SUA_Cars_Cleaned SET model = '840' WHERE model LIKE '840%' AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = '850' WHERE model LIKE '850%' AND brand = 'BMW';

  -- ALPINA
  UPDATE SUA_Cars_Cleaned SET model = 'ALPINA B7' WHERE model LIKE 'ALPINA B7%' AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = 'ALPINA B8' WHERE model LIKE 'ALPINA B8%' AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = 'ALPINA XB7' WHERE model LIKE 'ALPINA XB7%' AND brand = 'BMW';

  -- ActiveHybrid
  UPDATE SUA_Cars_Cleaned SET model = 'ActiveHybrid 3' WHERE model LIKE 'ActiveHybrid 3%' AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = 'ActiveHybrid 5' WHERE model LIKE 'ActiveHybrid 5%' AND brand = 'BMW';

  -- M Series (specifice INAINTE de generale)
  UPDATE SUA_Cars_Cleaned SET model = 'M235' WHERE model LIKE 'M235%' AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = 'M2' WHERE model LIKE 'M2%' AND model NOT LIKE 'M235%' AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = 'M340' WHERE model LIKE 'M340%' AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = 'M3' WHERE model LIKE 'M3%' AND model NOT LIKE 'M340%' AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = 'M440' WHERE model LIKE 'M440%' AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = 'M4' WHERE model LIKE 'M4%' AND model NOT LIKE 'M440%' AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = 'M550' WHERE model LIKE 'M550%' AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = 'M5' WHERE model LIKE 'M5%' AND model NOT LIKE 'M550%' AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = 'M6' WHERE model LIKE 'M6%' AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = 'M760' WHERE model LIKE 'M760%' AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = 'M850' WHERE model LIKE 'M850%' AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = 'M8' WHERE model LIKE 'M8%' AND model NOT LIKE 'M850%' AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = 'M' WHERE model IN ('M 3.2L','M Base','M Coupe','M M','M M 3.2L','M Roadster') AND brand =
  'BMW';

  -- X Series (M variants INAINTE)
  UPDATE SUA_Cars_Cleaned SET model = 'X1' WHERE model LIKE 'X1%' AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = 'X2' WHERE model LIKE 'X2%' AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = 'X3 M' WHERE model LIKE 'X3 M%' AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = 'X3' WHERE model LIKE 'X3%' AND model NOT LIKE 'X3 M%' AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = 'X4 M' WHERE model LIKE 'X4 M%' AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = 'X4' WHERE model LIKE 'X4%' AND model NOT LIKE 'X4 M%' AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = 'X5 M' WHERE model LIKE 'X5 M%' AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = 'X5' WHERE model LIKE 'X5%' AND model NOT LIKE 'X5 M%' AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = 'X6 M' WHERE model LIKE 'X6 M%' AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = 'X6' WHERE model LIKE 'X6%' AND model NOT LIKE 'X6 M%' AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = 'X7' WHERE model LIKE 'X7%' AND brand = 'BMW';

  -- Z Series
  UPDATE SUA_Cars_Cleaned SET model = 'Z3' WHERE model LIKE 'Z3%' AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = 'Z4' WHERE model LIKE 'Z4%' AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = 'Z8' WHERE model LIKE 'Z8%' AND brand = 'BMW';

  -- i Series
  UPDATE SUA_Cars_Cleaned SET model = 'i3' WHERE model LIKE 'i3%' AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = 'i4' WHERE model LIKE 'i4%' AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = 'i7' WHERE model LIKE 'i7%' AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = 'i8' WHERE model LIKE 'i8%' AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = 'iX' WHERE model LIKE 'iX%' AND brand = 'BMW';

 UPDATE SUA_Cars_Cleaned SET model = 'Seria 1' WHERE model IN ('128','135') AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = 'Seria 2' WHERE model IN ('228','230','240') AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = 'Seria 3' WHERE model IN
  ('318','320','323','325','328','330','330e','335','340','ActiveHybrid 3') AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = 'Seria 4' WHERE model IN ('428','430','435','440') AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = 'Seria 5' WHERE model IN ('525','528','530','530e','535','540','550','ActiveHybrid 5') AND
  brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = 'Seria 6' WHERE model IN ('640','645','650') AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = 'Seria 7' WHERE model IN ('740','740e','745','745e','750','760') AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = 'Seria 8' WHERE model IN ('840','850') AND brand = 'BMW';

  -- X Series (M variants unite cu baza)
  UPDATE SUA_Cars_Cleaned SET model = 'X3' WHERE model = 'X3 M' AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = 'X4' WHERE model = 'X4 M' AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = 'X5' WHERE model = 'X5 M' AND brand = 'BMW';
  UPDATE SUA_Cars_Cleaned SET model = 'X6' WHERE model = 'X6 M' AND brand = 'BMW';



SELECT DISTINCT model, COUNT(*) as nr
  FROM SUA_Cars_Cleaned
  WHERE brand = 'Buick'
  GROUP BY model
  ORDER BY model ASC;


  UPDATE SUA_Cars_Cleaned SET model = 'Cascada' WHERE model LIKE 'Cascada%' AND brand = 'Buick';
  UPDATE SUA_Cars_Cleaned SET model = 'Centurion' WHERE model LIKE 'Centurion%' AND brand = 'Buick';
  UPDATE SUA_Cars_Cleaned SET model = 'Century' WHERE model LIKE 'Century%' AND brand = 'Buick';
  UPDATE SUA_Cars_Cleaned SET model = 'Electra' WHERE model LIKE 'Electra%' AND brand = 'Buick';
  UPDATE SUA_Cars_Cleaned SET model = 'Enclave' WHERE model LIKE 'Enclave%' AND brand = 'Buick';
  UPDATE SUA_Cars_Cleaned SET model = 'Encore GX' WHERE model LIKE 'Encore GX%' AND brand = 'Buick';
  UPDATE SUA_Cars_Cleaned SET model = 'Encore' WHERE model LIKE 'Encore%' AND model NOT LIKE 'Encore GX%' AND brand = 'Buick';
  UPDATE SUA_Cars_Cleaned SET model = 'Envision' WHERE model LIKE 'Envision%' AND brand = 'Buick';
  UPDATE SUA_Cars_Cleaned SET model = 'Estate Wagon' WHERE model LIKE 'Estate Wagon%' AND brand = 'Buick';
  UPDATE SUA_Cars_Cleaned SET model = 'GS' WHERE model LIKE 'GS%' AND model NOT LIKE 'GSX%' AND brand = 'Buick';
  UPDATE SUA_Cars_Cleaned SET model = 'GSX' WHERE model LIKE 'GSX%' AND brand = 'Buick';
  UPDATE SUA_Cars_Cleaned SET model = 'LaCrosse' WHERE model LIKE 'LaCrosse%' AND brand = 'Buick';
  UPDATE SUA_Cars_Cleaned SET model = 'LeSabre' WHERE model LIKE 'LeSabre%' AND brand = 'Buick';
  UPDATE SUA_Cars_Cleaned SET model = 'Lucerne' WHERE model LIKE 'Lucerne%' AND brand = 'Buick';
  UPDATE SUA_Cars_Cleaned SET model = 'Park Avenue' WHERE model LIKE 'Park Avenue%' AND brand = 'Buick';
  UPDATE SUA_Cars_Cleaned SET model = 'Rainier' WHERE model LIKE 'Rainier%' AND brand = 'Buick';
  UPDATE SUA_Cars_Cleaned SET model = 'Reatta' WHERE model LIKE 'Reatta%' AND brand = 'Buick';
  UPDATE SUA_Cars_Cleaned SET model = 'Regal Sportback' WHERE model LIKE 'Regal Sportback%' AND brand = 'Buick';
  UPDATE SUA_Cars_Cleaned SET model = 'Regal TourX' WHERE model LIKE 'Regal TourX%' AND brand = 'Buick';
  UPDATE SUA_Cars_Cleaned SET model = 'Regal' WHERE model LIKE 'Regal%' AND model NOT LIKE 'Regal Sportback%' AND model NOT LIKE
  'Regal TourX%' AND brand = 'Buick';
  UPDATE SUA_Cars_Cleaned SET model = 'Rendezvous' WHERE model LIKE 'Rendezvous%' AND brand = 'Buick';
  UPDATE SUA_Cars_Cleaned SET model = 'Riviera' WHERE model LIKE 'Riviera%' AND brand = 'Buick';
  UPDATE SUA_Cars_Cleaned SET model = 'Roadmaster' WHERE model LIKE 'Roadmaster%' AND brand = 'Buick';
  UPDATE SUA_Cars_Cleaned SET model = 'Skylark' WHERE model LIKE 'Skylark%' AND brand = 'Buick';
  UPDATE SUA_Cars_Cleaned SET model = 'Special' WHERE model LIKE 'Special%' AND brand = 'Buick';
  UPDATE SUA_Cars_Cleaned SET model = 'Super' WHERE model LIKE 'Super%' AND brand = 'Buick';
  UPDATE SUA_Cars_Cleaned SET model = 'Terraza' WHERE model LIKE 'Terraza%' AND brand = 'Buick';
  UPDATE SUA_Cars_Cleaned SET model = 'Verano' WHERE model LIKE 'Verano%' AND brand = 'Buick';

SELECT DISTINCT model, COUNT(*) as nr
  FROM SUA_Cars_Cleaned
  WHERE brand = 'Cadillac'
  GROUP BY model
  ORDER BY model ASC;

-- ATS (V first)
  UPDATE SUA_Cars_Cleaned SET model = 'ATS-V' WHERE model LIKE 'ATS-V%' AND brand = 'Cadillac';
  UPDATE SUA_Cars_Cleaned SET model = 'ATS' WHERE model LIKE 'ATS%' AND model NOT LIKE 'ATS-V%' AND brand = 'Cadillac';

  -- CT4 (V first)
  UPDATE SUA_Cars_Cleaned SET model = 'CT4-V' WHERE (model LIKE 'CT4-V%' OR model LIKE 'CT4 V-Series%') AND brand = 'Cadillac';
  UPDATE SUA_Cars_Cleaned SET model = 'CT4' WHERE model LIKE 'CT4%' AND model NOT LIKE 'CT4-V%' AND model NOT LIKE 'CT4 V-Series%'
  AND brand = 'Cadillac';

  -- CT5 (V first)
  UPDATE SUA_Cars_Cleaned SET model = 'CT5-V' WHERE (model LIKE 'CT5-V%' OR model LIKE 'CT5 V-Series%') AND brand = 'Cadillac';
  UPDATE SUA_Cars_Cleaned SET model = 'CT5' WHERE model LIKE 'CT5%' AND model NOT LIKE 'CT5-V%' AND model NOT LIKE 'CT5 V-Series%'
  AND brand = 'Cadillac';

  -- CT6 (V first)
  UPDATE SUA_Cars_Cleaned SET model = 'CT6-V' WHERE model LIKE 'CT6-V%' AND brand = 'Cadillac';
  UPDATE SUA_Cars_Cleaned SET model = 'CT6' WHERE model LIKE 'CT6%' AND model NOT LIKE 'CT6-V%' AND brand = 'Cadillac';

  -- CTS (V first)
  UPDATE SUA_Cars_Cleaned SET model = 'CTS-V' WHERE (model LIKE 'CTS-V%' OR model LIKE 'CTS V%') AND brand = 'Cadillac';
  UPDATE SUA_Cars_Cleaned SET model = 'CTS' WHERE model LIKE 'CTS%' AND model NOT LIKE 'CTS-V%' AND model NOT LIKE 'CTS V%' AND
  brand = 'Cadillac';

  -- STS (V first)
  UPDATE SUA_Cars_Cleaned SET model = 'STS-V' WHERE (model LIKE 'STS-V%' OR model LIKE 'STS V%') AND brand = 'Cadillac';
  UPDATE SUA_Cars_Cleaned SET model = 'STS' WHERE model LIKE 'STS%' AND model NOT LIKE 'STS-V%' AND model NOT LIKE 'STS V%' AND
  brand = 'Cadillac';

  -- XTS
  UPDATE SUA_Cars_Cleaned SET model = 'XTS' WHERE model LIKE 'XTS%' AND brand = 'Cadillac';

  -- Escalade (V-Series PRIMUL, apoi ESV, EXT, baza)
  UPDATE SUA_Cars_Cleaned SET model = 'Escalade-V' WHERE model LIKE 'Escalade%' AND model LIKE '%V-Series%' AND brand = 'Cadillac';
  UPDATE SUA_Cars_Cleaned SET model = 'Escalade ESV' WHERE model LIKE 'Escalade ESV%' AND brand = 'Cadillac';
  UPDATE SUA_Cars_Cleaned SET model = 'Escalade EXT' WHERE model LIKE 'Escalade EXT%' AND brand = 'Cadillac';
  UPDATE SUA_Cars_Cleaned SET model = 'Escalade' WHERE model LIKE 'Escalade%' AND model NOT LIKE 'Escalade ESV%' AND model NOT LIKE
   'Escalade EXT%' AND model != 'Escalade-V' AND brand = 'Cadillac';

  -- SUV / EV
  UPDATE SUA_Cars_Cleaned SET model = 'SRX' WHERE model LIKE 'SRX%' AND brand = 'Cadillac';
  UPDATE SUA_Cars_Cleaned SET model = 'XT4' WHERE model LIKE 'XT4%' AND brand = 'Cadillac';
  UPDATE SUA_Cars_Cleaned SET model = 'XT5' WHERE model LIKE 'XT5%' AND brand = 'Cadillac';
  UPDATE SUA_Cars_Cleaned SET model = 'XT6' WHERE model LIKE 'XT6%' AND brand = 'Cadillac';
  UPDATE SUA_Cars_Cleaned SET model = 'LYRIQ' WHERE model LIKE 'LYRIQ%' AND brand = 'Cadillac';
  UPDATE SUA_Cars_Cleaned SET model = 'ELR' WHERE model LIKE 'ELR%' AND brand = 'Cadillac';

  -- Classic / Legacy
  UPDATE SUA_Cars_Cleaned SET model = 'Allante' WHERE model LIKE 'Allante%' AND brand = 'Cadillac';
  UPDATE SUA_Cars_Cleaned SET model = 'Brougham' WHERE model LIKE 'Brougham%' AND brand = 'Cadillac';
  UPDATE SUA_Cars_Cleaned SET model = 'Catera' WHERE model LIKE 'Catera%' AND brand = 'Cadillac';
  UPDATE SUA_Cars_Cleaned SET model = 'DeVille' WHERE model LIKE 'DeVille%' AND brand = 'Cadillac';
  UPDATE SUA_Cars_Cleaned SET model = 'DTS' WHERE model LIKE 'DTS%' AND brand = 'Cadillac';
  UPDATE SUA_Cars_Cleaned SET model = 'Eldorado' WHERE model LIKE 'Eldorado%' AND brand = 'Cadillac';
  UPDATE SUA_Cars_Cleaned SET model = 'Fleetwood' WHERE model LIKE 'Fleetwood%' AND brand = 'Cadillac';
  UPDATE SUA_Cars_Cleaned SET model = 'Series 60' WHERE model LIKE 'Series 60%' AND brand = 'Cadillac';
  UPDATE SUA_Cars_Cleaned SET model = 'Series 61' WHERE model LIKE 'Series 61%' AND brand = 'Cadillac';
  UPDATE SUA_Cars_Cleaned SET model = 'Series 62' WHERE model LIKE 'Series 62%' AND brand = 'Cadillac';
  UPDATE SUA_Cars_Cleaned SET model = 'Seville' WHERE model LIKE 'Seville%' AND brand = 'Cadillac';
  UPDATE SUA_Cars_Cleaned SET model = 'XLR-V' WHERE model LIKE 'XLR V%' AND brand = 'Cadillac';
  UPDATE SUA_Cars_Cleaned SET model = 'XLR' WHERE model LIKE 'XLR%' AND model NOT LIKE 'XLR V%' AND brand = 'Cadillac';

SELECT DISTINCT model, COUNT(*) as nr
  FROM SUA_Cars_Cleaned
  WHERE brand = 'Chevrolet'
  GROUP BY model
  ORDER BY model ASC;


  -- Express (PRIMUL — inainte de 1500/2500/3500 generale)
  UPDATE SUA_Cars_Cleaned SET model = 'Express 1500' WHERE model LIKE 'Express 1500%' AND brand = 'Chevrolet';
  UPDATE SUA_Cars_Cleaned SET model = 'Express 2500' WHERE model LIKE 'Express 2500%' AND brand = 'Chevrolet';
  UPDATE SUA_Cars_Cleaned SET model = 'Express 3500' WHERE model LIKE 'Express 3500%' AND brand = 'Chevrolet';

  -- S-10 Blazer (INAINTE de Blazer)
  UPDATE SUA_Cars_Cleaned SET model = 'S-10 Blazer' WHERE model LIKE 'S-10 Blazer%' AND brand = 'Chevrolet';

  -- Silverado (include si bare 1500/2500/3500)
  UPDATE SUA_Cars_Cleaned SET model = 'Silverado 1500' WHERE (model LIKE 'Silverado 1500%' OR model LIKE '1500%') AND brand =
  'Chevrolet';
  UPDATE SUA_Cars_Cleaned SET model = 'Silverado 2500' WHERE (model LIKE 'Silverado 2500%' OR model LIKE '2500%') AND brand =
  'Chevrolet';
  UPDATE SUA_Cars_Cleaned SET model = 'Silverado 3500' WHERE (model LIKE 'Silverado 3500%' OR model LIKE '3500%') AND brand =
  'Chevrolet';

  -- Pick-up-uri
  UPDATE SUA_Cars_Cleaned SET model = 'Colorado' WHERE model LIKE 'Colorado%' AND brand = 'Chevrolet';
  UPDATE SUA_Cars_Cleaned SET model = 'Avalanche' WHERE model LIKE 'Avalanche%' AND brand = 'Chevrolet';
  UPDATE SUA_Cars_Cleaned SET model = 'C10/K10' WHERE model LIKE 'C10/K10%' AND brand = 'Chevrolet';
  UPDATE SUA_Cars_Cleaned SET model = '3100' WHERE model LIKE '3100%' AND brand = 'Chevrolet';
  UPDATE SUA_Cars_Cleaned SET model = 'El Camino' WHERE model LIKE 'El Camino%' AND brand = 'Chevrolet';
  UPDATE SUA_Cars_Cleaned SET model = 'SSR' WHERE model LIKE 'SSR%' AND brand = 'Chevrolet';

  -- SUV-uri (S-10 Blazer deja facut)
  UPDATE SUA_Cars_Cleaned SET model = 'Blazer' WHERE model LIKE 'Blazer%' AND brand = 'Chevrolet';
  UPDATE SUA_Cars_Cleaned SET model = 'Suburban' WHERE model LIKE 'Suburban%' AND brand = 'Chevrolet';
  UPDATE SUA_Cars_Cleaned SET model = 'Tahoe' WHERE model LIKE 'Tahoe%' AND brand = 'Chevrolet';
  UPDATE SUA_Cars_Cleaned SET model = 'Equinox' WHERE model LIKE 'Equinox%' AND brand = 'Chevrolet';
  UPDATE SUA_Cars_Cleaned SET model = 'Traverse' WHERE model LIKE 'Traverse%' AND brand = 'Chevrolet';
  UPDATE SUA_Cars_Cleaned SET model = 'Trailblazer' WHERE model LIKE 'Trailblazer%' AND brand = 'Chevrolet';
  UPDATE SUA_Cars_Cleaned SET model = 'Trax' WHERE model LIKE 'Trax%' AND brand = 'Chevrolet';
  UPDATE SUA_Cars_Cleaned SET model = 'Tracker' WHERE model LIKE 'Tracker%' AND brand = 'Chevrolet';
  UPDATE SUA_Cars_Cleaned SET model = 'Captiva' WHERE model LIKE 'Captiva%' AND brand = 'Chevrolet';

  -- EV (separate)
  UPDATE SUA_Cars_Cleaned SET model = 'Bolt EUV' WHERE model LIKE 'Bolt EUV%' AND brand = 'Chevrolet';
  UPDATE SUA_Cars_Cleaned SET model = 'Bolt EV' WHERE model LIKE 'Bolt EV%' AND brand = 'Chevrolet';

  -- Autoturisme
  UPDATE SUA_Cars_Cleaned SET model = 'Camaro' WHERE model LIKE 'Camaro%' AND brand = 'Chevrolet';
  UPDATE SUA_Cars_Cleaned SET model = 'Corvette' WHERE model LIKE 'Corvette%' AND brand = 'Chevrolet';
  UPDATE SUA_Cars_Cleaned SET model = 'Malibu' WHERE model LIKE 'Malibu%' AND brand = 'Chevrolet';
  UPDATE SUA_Cars_Cleaned SET model = 'Impala' WHERE model LIKE 'Impala%' AND brand = 'Chevrolet';
  UPDATE SUA_Cars_Cleaned SET model = 'Cruze' WHERE model LIKE 'Cruze%' AND brand = 'Chevrolet';
  UPDATE SUA_Cars_Cleaned SET model = 'Cobalt' WHERE model LIKE 'Cobalt%' AND brand = 'Chevrolet';
  UPDATE SUA_Cars_Cleaned SET model = 'Cavalier' WHERE model LIKE 'Cavalier%' AND brand = 'Chevrolet';
  UPDATE SUA_Cars_Cleaned SET model = 'Sonic' WHERE model LIKE 'Sonic%' AND brand = 'Chevrolet';
  UPDATE SUA_Cars_Cleaned SET model = 'Spark' WHERE model LIKE 'Spark%' AND brand = 'Chevrolet';
  UPDATE SUA_Cars_Cleaned SET model = 'Volt' WHERE model LIKE 'Volt%' AND brand = 'Chevrolet';

  -- Dubite / Vans
  UPDATE SUA_Cars_Cleaned SET model = 'Astro' WHERE model LIKE 'Astro%' AND brand = 'Chevrolet';
  UPDATE SUA_Cars_Cleaned SET model = 'City Express' WHERE model LIKE 'City Express%' AND brand = 'Chevrolet';
  UPDATE SUA_Cars_Cleaned SET model = 'Uplander' WHERE model LIKE 'Uplander%' AND brand = 'Chevrolet';
  UPDATE SUA_Cars_Cleaned SET model = 'Venture' WHERE model LIKE 'Venture%' AND brand = 'Chevrolet';

  -- Clasice
  UPDATE SUA_Cars_Cleaned SET model = 'Chevelle' WHERE model LIKE 'Chevelle%' AND brand = 'Chevrolet';
  UPDATE SUA_Cars_Cleaned SET model = 'Nova' WHERE (model LIKE 'Nova%' OR model LIKE 'Chevy II%') AND brand = 'Chevrolet';
  UPDATE SUA_Cars_Cleaned SET model = 'Bel Air' WHERE model LIKE 'Bel Air%' AND brand = 'Chevrolet';
  UPDATE SUA_Cars_Cleaned SET model = 'Biscayne' WHERE model LIKE 'Biscayne%' AND brand = 'Chevrolet';
  UPDATE SUA_Cars_Cleaned SET model = 'Caprice' WHERE model LIKE 'Caprice%' AND brand = 'Chevrolet';
  UPDATE SUA_Cars_Cleaned SET model = 'Vega' WHERE model LIKE 'Vega%' AND brand = 'Chevrolet';

  -- Pre-1950
  UPDATE SUA_Cars_Cleaned SET model = 'Fleetmaster' WHERE model LIKE 'Fleetmaster%' AND brand = 'Chevrolet';
  UPDATE SUA_Cars_Cleaned SET model = 'Stylemaster' WHERE model LIKE 'Stylemaster%' AND brand = 'Chevrolet';
  UPDATE SUA_Cars_Cleaned SET model = 'Styleline' WHERE model LIKE 'Styleline%' AND brand = 'Chevrolet';
  UPDATE SUA_Cars_Cleaned SET model = 'Master Deluxe' WHERE model LIKE 'Master Deluxe%' AND brand = 'Chevrolet';
  UPDATE SUA_Cars_Cleaned SET model = 'Confederate' WHERE model LIKE 'Confederate%' AND brand = 'Chevrolet';
  UPDATE SUA_Cars_Cleaned SET model = 'Apache' WHERE model LIKE 'Apache%' AND brand = 'Chevrolet';
  UPDATE SUA_Cars_Cleaned SET model = 'Superior' WHERE model LIKE 'Superior%' AND brand = 'Chevrolet';

SELECT DISTINCT model, COUNT(*) as nr
  FROM SUA_Cars_Cleaned
  WHERE brand = 'Chrysler'
  GROUP BY model
  ORDER BY model ASC;

 -- Seria 300 (specifice PRIMUL)
  UPDATE SUA_Cars_Cleaned SET model = '300M' WHERE model LIKE '300M%' AND brand = 'Chrysler';
  UPDATE SUA_Cars_Cleaned SET model = '300C' WHERE model LIKE '300C%' AND brand = 'Chrysler';
  UPDATE SUA_Cars_Cleaned SET model = '300' WHERE model LIKE '300%' AND model NOT LIKE '300M%' AND model NOT LIKE '300C%' AND brand
   = 'Chrysler';
  UPDATE SUA_Cars_Cleaned SET model = '200' WHERE model LIKE '200%' AND brand = 'Chrysler';

  -- Minivan-uri (Hybrid PRIMUL)
  UPDATE SUA_Cars_Cleaned SET model = 'Pacifica Hybrid' WHERE model LIKE 'Pacifica Hybrid%' AND brand = 'Chrysler';
  UPDATE SUA_Cars_Cleaned SET model = 'Pacifica' WHERE model LIKE 'Pacifica%' AND model NOT LIKE 'Pacifica Hybrid%' AND brand =
  'Chrysler';
  UPDATE SUA_Cars_Cleaned SET model = 'Town & Country' WHERE model LIKE 'Town & Country%' AND brand = 'Chrysler';
  UPDATE SUA_Cars_Cleaned SET model = 'Voyager' WHERE model LIKE 'Voyager%' AND brand = 'Chrysler';

  -- SUV-uri / Unicat
  UPDATE SUA_Cars_Cleaned SET model = 'PT Cruiser' WHERE model LIKE 'PT Cruiser%' AND brand = 'Chrysler';
  UPDATE SUA_Cars_Cleaned SET model = 'Aspen' WHERE model LIKE 'Aspen%' AND brand = 'Chrysler';
  UPDATE SUA_Cars_Cleaned SET model = 'Crossfire' WHERE model LIKE 'Crossfire%' AND brand = 'Chrysler';
  UPDATE SUA_Cars_Cleaned SET model = 'Prowler' WHERE model LIKE 'Prowler%' AND brand = 'Chrysler';

  -- Sedanuri clasice
  UPDATE SUA_Cars_Cleaned SET model = 'Sebring' WHERE model LIKE 'Sebring%' AND brand = 'Chrysler';
  UPDATE SUA_Cars_Cleaned SET model = 'Concorde' WHERE model LIKE 'Concorde%' AND brand = 'Chrysler';
  UPDATE SUA_Cars_Cleaned SET model = 'LHS' WHERE model LIKE 'LHS%' AND brand = 'Chrysler';
  UPDATE SUA_Cars_Cleaned SET model = 'LeBaron' WHERE model LIKE 'LeBaron%' AND brand = 'Chrysler';
  UPDATE SUA_Cars_Cleaned SET model = 'New Yorker' WHERE model LIKE 'New Yorker%' AND brand = 'Chrysler';
  UPDATE SUA_Cars_Cleaned SET model = 'Cordoba' WHERE model LIKE 'Cordoba%' AND brand = 'Chrysler';
  UPDATE SUA_Cars_Cleaned SET model = 'Fifth Avenue' WHERE model LIKE 'Fifth Avenue%' AND brand = 'Chrysler';
  UPDATE SUA_Cars_Cleaned SET model = 'Newport' WHERE model LIKE 'Newport%' AND brand = 'Chrysler';
  UPDATE SUA_Cars_Cleaned SET model = 'TC by Maserati' WHERE model LIKE 'TC by Maserati%' AND brand = 'Chrysler';




  SELECT DISTINCT color, COUNT(*) as nr FROM SUA_Cars_Cleaned GROUP BY color ORDER BY color;

  SELECT DISTINCT year, COUNT(*) as nr FROM SUA_Cars_Cleaned GROUP BY year ORDER BY year;
  SELECT DISTINCT transmission_type, COUNT(*) as nr FROM SUA_Cars_Cleaned GROUP BY transmission_type
  ORDER BY transmission_type;
  SELECT DISTINCT fuel_type, COUNT(*) as nr FROM SUA_Cars_Cleaned GROUP BY fuel_type ORDER BY fuel_type;
  SELECT DISTINCT drivetrain, COUNT(*) as nr FROM SUA_Cars_Cleaned GROUP BY drivetrain ORDER BY
  drivetrain;
  SELECT DISTINCT one_owner, COUNT(*) as nr FROM SUA_Cars_Cleaned GROUP BY one_owner ORDER BY one_owner;
  SELECT DISTINCT accidents_or_damage, COUNT(*) as nr FROM SUA_Cars_Cleaned GROUP BY accidents_or_damage
   ORDER BY accidents_or_damage;
