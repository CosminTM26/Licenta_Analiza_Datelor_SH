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
  UPDATE SUA_Cars_Cleaned SET model =
      'RS 4' WHERE model LIKE 'RS 4%' AND brand = 'Audi';
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

SELECT DISTINCT model, COUNT(*) as nr
  FROM SUA_Cars_Cleaned
  WHERE brand = 'Dodge'
  GROUP BY model
  ORDER BY model ASC;

  -- Muscle Cars și Sedanuri

  -- Challenger SRT/Hellcat/Demon (PRIMUL - înainte de Challenger general)
  UPDATE SUA_Cars_Cleaned SET model = 'Challenger SRT/Hellcat/Demon' WHERE model LIKE 'Challenger%'
  AND (model LIKE '%SRT%' OR model LIKE '%Hellcat%' OR model LIKE '%Demon%') AND brand IN ('Dodge', 'Ram');
  -- Challenger (restul - exclude SRT, Hellcat, Demon)
  UPDATE SUA_Cars_Cleaned SET model = 'Challenger' WHERE model LIKE 'Challenger%' AND model NOT LIKE '%SRT%'
  AND model NOT LIKE '%Hellcat%' AND model NOT LIKE '%Demon%' AND brand IN ('Dodge', 'Ram');

  -- Charger SRT/Hellcat (PRIMUL - înainte de Charger general)
  UPDATE SUA_Cars_Cleaned SET model = 'Charger SRT/Hellcat' WHERE model LIKE 'Charger%'
  AND (model LIKE '%SRT%' OR model LIKE '%Hellcat%') AND brand IN ('Dodge', 'Ram');
  -- Charger (restul - exclude SRT, Hellcat)
  UPDATE SUA_Cars_Cleaned SET model = 'Charger' WHERE model LIKE 'Charger%' AND model NOT LIKE '%SRT%'
  AND model NOT LIKE '%Hellcat%' AND brand IN ('Dodge', 'Ram');

  UPDATE SUA_Cars_Cleaned SET model = 'Avenger' WHERE model LIKE 'Avenger%' AND brand IN ('Dodge', 'Ram');
  UPDATE SUA_Cars_Cleaned SET model = 'Dart' WHERE model LIKE 'Dart%' AND brand IN ('Dodge', 'Ram');
  UPDATE SUA_Cars_Cleaned SET model = 'Neon' WHERE model LIKE 'Neon%' AND brand IN ('Dodge', 'Ram');
  UPDATE SUA_Cars_Cleaned SET model = 'Stratus' WHERE model LIKE 'Stratus%' AND brand IN ('Dodge', 'Ram');
  UPDATE SUA_Cars_Cleaned SET model = 'Stealth' WHERE model LIKE 'Stealth%' AND brand IN ('Dodge', 'Ram');

  -- SUV-uri, Crossovere și Minivan-uri

  -- Durango SRT/Hellcat (PRIMUL - înainte de Durango general)
  UPDATE SUA_Cars_Cleaned SET model = 'Durango SRT/Hellcat' WHERE model LIKE 'Durango%'
  AND (model LIKE '%SRT%' OR model LIKE '%Hellcat%') AND brand IN ('Dodge', 'Ram');
  -- Durango (restul - exclude SRT, Hellcat)
  UPDATE SUA_Cars_Cleaned SET model = 'Durango' WHERE model LIKE 'Durango%' AND model NOT LIKE '%SRT%'
  AND model NOT LIKE '%Hellcat%' AND brand IN ('Dodge', 'Ram');

  UPDATE SUA_Cars_Cleaned SET model = 'Journey' WHERE model LIKE 'Journey%' AND brand IN ('Dodge', 'Ram');
  -- Grand Caravan (ÎNAINTE de Caravan general)
  UPDATE SUA_Cars_Cleaned SET model = 'Grand Caravan' WHERE model LIKE 'Grand Caravan%' AND brand IN ('Dodge', 'Ram');
  -- Caravan (restul - exclude Grand Caravan)
  UPDATE SUA_Cars_Cleaned SET model = 'Caravan' WHERE model LIKE 'Caravan%' AND model NOT LIKE 'Grand Caravan%'
  AND brand IN ('Dodge', 'Ram');
  UPDATE SUA_Cars_Cleaned SET model = 'Nitro' WHERE model LIKE 'Nitro%' AND brand IN ('Dodge', 'Ram');
  UPDATE SUA_Cars_Cleaned SET model = 'Caliber' WHERE model LIKE 'Caliber%' AND brand IN ('Dodge', 'Ram');
  UPDATE SUA_Cars_Cleaned SET model = 'Magnum' WHERE model LIKE 'Magnum%' AND brand IN ('Dodge', 'Ram');

  -- Pick-up-uri

  -- Ram Van și Ram Wagon (ÎNAINTE de Ram 1500/2500/3500 - altfel "Ram Van 1500" ar fi prins de Ram 1500)
  UPDATE SUA_Cars_Cleaned SET model = 'Ram Van' WHERE model LIKE 'Ram Van%' AND brand IN ('Dodge', 'Ram');
  UPDATE SUA_Cars_Cleaned SET model = 'Ram Wagon' WHERE model LIKE 'Ram Wagon%' AND brand IN ('Dodge', 'Ram');
  UPDATE SUA_Cars_Cleaned SET model = 'Ram 1500' WHERE model LIKE '%Ram 1500%' AND brand IN ('Dodge', 'Ram');
  UPDATE SUA_Cars_Cleaned SET model = 'Ram 2500' WHERE model LIKE '%Ram 2500%' AND brand IN ('Dodge', 'Ram');
  UPDATE SUA_Cars_Cleaned SET model = 'Ram 3500' WHERE model LIKE '%Ram 3500%' AND brand IN ('Dodge', 'Ram');
  UPDATE SUA_Cars_Cleaned SET model = 'Dakota' WHERE model LIKE 'Dakota%' AND brand IN ('Dodge', 'Ram');
  UPDATE SUA_Cars_Cleaned SET model = 'Ramcharger' WHERE model LIKE 'Ramcharger%' AND brand IN ('Dodge', 'Ram');
  -- D-Series (D150, D250) și W-Series (W250) - modele clasice
  UPDATE SUA_Cars_Cleaned SET model = 'D-Series' WHERE (model LIKE 'D150%' OR model LIKE 'D250%')
  AND brand IN ('Dodge', 'Ram');
  UPDATE SUA_Cars_Cleaned SET model = 'W-Series' WHERE model LIKE 'W250%' AND brand IN ('Dodge', 'Ram');

  -- Dubițe / Vans
  UPDATE SUA_Cars_Cleaned SET model = 'Sprinter' WHERE model LIKE 'Sprinter%' AND brand IN ('Dodge', 'Ram');

  -- Supercar-uri și Clasice

  -- Viper (include SRT Viper - același model, rebranded)
  UPDATE SUA_Cars_Cleaned SET model = 'Viper' WHERE (model LIKE 'Viper%' OR model LIKE 'SRT Viper%')
  AND brand IN ('Dodge', 'Ram');
  UPDATE SUA_Cars_Cleaned SET model = 'Coronet' WHERE model LIKE 'Coronet%' AND brand IN ('Dodge', 'Ram');
  UPDATE SUA_Cars_Cleaned SET model = 'Polara' WHERE model LIKE 'Polara%' AND brand IN ('Dodge', 'Ram');
  UPDATE SUA_Cars_Cleaned SET model = 'Diplomat' WHERE model LIKE 'Diplomat%' AND brand IN ('Dodge', 'Ram');
  UPDATE SUA_Cars_Cleaned SET model = 'Shadow' WHERE model LIKE 'Shadow%' AND brand IN ('Dodge', 'Ram');
  UPDATE SUA_Cars_Cleaned SET model = 'Aspen' WHERE model LIKE 'Aspen%' AND brand IN ('Dodge', 'Ram');
  -- Seria numerică (400, 600, 880)
  UPDATE SUA_Cars_Cleaned SET model = '400' WHERE model LIKE '400%' AND brand IN ('Dodge', 'Ram');
  UPDATE SUA_Cars_Cleaned SET model = '600' WHERE model LIKE '600%' AND brand IN ('Dodge', 'Ram');
  UPDATE SUA_Cars_Cleaned SET model = '880' WHERE model LIKE '880%' AND brand IN ('Dodge', 'Ram');
  -- Intrepid (model Dodge prezent în date, nemenționate în reguli)
  UPDATE SUA_Cars_Cleaned SET model = 'Intrepid' WHERE model LIKE 'Intrepid%' AND brand IN ('Dodge', 'Ram');

SELECT DISTINCT model, COUNT(*) as nr
  FROM SUA_Cars_Cleaned
  WHERE brand = 'Ford'
  GROUP BY model
  ORDER BY model ASC;

  -- Familia Mustang

  -- Mustang Mach-E (PRIMUL - model electric distinct)
  UPDATE SUA_Cars_Cleaned SET model = 'Mustang Mach-E' WHERE model LIKE '%Mach-E%' AND brand = 'Ford';
  -- Mustang Shelby / SVT Cobra (PRIMUL față de Mustang general)
  UPDATE SUA_Cars_Cleaned SET model = 'Mustang Shelby/SVT Cobra' WHERE
  (model LIKE '%Shelby%' OR model LIKE '%GT350%' OR model LIKE '%GT500%' OR model LIKE '%SVT Cobra%')
  AND brand = 'Ford';
  -- Mustang (restul - exclude Mach-E, Shelby, GT350, GT500, SVT)
  UPDATE SUA_Cars_Cleaned SET model = 'Mustang' WHERE model LIKE 'Mustang%'
  AND model NOT LIKE '%Mach-E%' AND model NOT LIKE '%Shelby%' AND model NOT LIKE '%GT350%'
  AND model NOT LIKE '%GT500%' AND model NOT LIKE '%SVT%' AND brand = 'Ford';
  -- Ford GT (include GT40)
  UPDATE SUA_Cars_Cleaned SET model = 'Ford GT' WHERE model LIKE 'GT%' AND brand = 'Ford';

  -- Pick-up-uri

  -- F-150 Lightning (PRIMUL - model electric distinct)
  UPDATE SUA_Cars_Cleaned SET model = 'F-150 Lightning' WHERE model LIKE '%F-150 Lightning%' AND brand = 'Ford';
  -- F-150 (restul - exclude Lightning)
  UPDATE SUA_Cars_Cleaned SET model = 'F-150' WHERE model LIKE '%F-150%'
  AND model NOT LIKE '%Lightning%' AND brand = 'Ford';
  UPDATE SUA_Cars_Cleaned SET model = 'F-250' WHERE model LIKE '%F-250%' AND brand = 'Ford';
  UPDATE SUA_Cars_Cleaned SET model = 'F-350' WHERE model LIKE '%F-350%' AND brand = 'Ford';
  UPDATE SUA_Cars_Cleaned SET model = 'F-450' WHERE model LIKE '%F-450%' AND brand = 'Ford';
  UPDATE SUA_Cars_Cleaned SET model = 'F100' WHERE model LIKE 'F100%' AND brand = 'Ford';
  UPDATE SUA_Cars_Cleaned SET model = 'Ranger' WHERE model LIKE 'Ranger%' AND brand = 'Ford';
  UPDATE SUA_Cars_Cleaned SET model = 'Maverick' WHERE model LIKE 'Maverick%' AND brand = 'Ford';
  -- Explorer Sport Trac (pick-up, nu SUV - ÎNAINTE de Explorer)
  UPDATE SUA_Cars_Cleaned SET model = 'Explorer Sport Trac' WHERE model LIKE '%Sport Trac%' AND brand = 'Ford';

  -- SUV-uri și Crossovere

  -- Bronco Sport (PRIMUL - platformă crossover, diferită de Bronco)
  UPDATE SUA_Cars_Cleaned SET model = 'Bronco Sport' WHERE model LIKE 'Bronco Sport%' AND brand = 'Ford';
  -- Bronco II (PRIMUL - model clasic, diferit de Bronco modern)
  UPDATE SUA_Cars_Cleaned SET model = 'Bronco II' WHERE model LIKE 'Bronco II%' AND brand = 'Ford';
  -- Bronco (restul - exclude Sport, II)
  UPDATE SUA_Cars_Cleaned SET model = 'Bronco' WHERE model LIKE 'Bronco%'
  AND model NOT LIKE 'Bronco Sport%' AND model NOT LIKE 'Bronco II%' AND brand = 'Ford';
  -- Expedition MAX/EL (șasiu alungit - ÎNAINTE de Expedition general)
  UPDATE SUA_Cars_Cleaned SET model = 'Expedition MAX/EL' WHERE model LIKE 'Expedition%'
  AND (model LIKE '%EL%' OR model LIKE '%MAX%' OR model LIKE '%Max%') AND brand = 'Ford';
  -- Expedition (restul - exclude MAX, EL)
  UPDATE SUA_Cars_Cleaned SET model = 'Expedition' WHERE model LIKE 'Expedition%'
  AND model NOT LIKE '%EL%' AND model NOT LIKE '%MAX%' AND model NOT LIKE '%Max%' AND brand = 'Ford';
  -- Explorer (exclude Sport Trac)
  UPDATE SUA_Cars_Cleaned SET model = 'Explorer' WHERE model LIKE 'Explorer%'
  AND model NOT LIKE '%Sport Trac%' AND brand = 'Ford';
  UPDATE SUA_Cars_Cleaned SET model = 'Escape' WHERE model LIKE 'Escape%' AND brand = 'Ford';
  UPDATE SUA_Cars_Cleaned SET model = 'Edge' WHERE model LIKE 'Edge%' AND brand = 'Ford';
  UPDATE SUA_Cars_Cleaned SET model = 'EcoSport' WHERE model LIKE 'EcoSport%' AND brand = 'Ford';
  UPDATE SUA_Cars_Cleaned SET model = 'Excursion' WHERE model LIKE 'Excursion%' AND brand = 'Ford';
  UPDATE SUA_Cars_Cleaned SET model = 'Flex' WHERE model LIKE 'Flex%' AND brand = 'Ford';

  -- Autoutilitare și Dubițe

  -- E-Transit (PRIMUL - van electric)
  UPDATE SUA_Cars_Cleaned SET model = 'E-Transit' WHERE model LIKE 'E-Transit%' AND brand = 'Ford';
  -- Transit Connect (PRIMUL - van compact)
  UPDATE SUA_Cars_Cleaned SET model = 'Transit Connect' WHERE model LIKE 'Transit Connect%' AND brand = 'Ford';
  UPDATE SUA_Cars_Cleaned SET model = 'Transit-150' WHERE model LIKE '%Transit-150%' AND brand = 'Ford';
  UPDATE SUA_Cars_Cleaned SET model = 'Transit-250' WHERE model LIKE '%Transit-250%' AND brand = 'Ford';
  UPDATE SUA_Cars_Cleaned SET model = 'Transit-350' WHERE model LIKE '%Transit-350%' AND brand = 'Ford';
  UPDATE SUA_Cars_Cleaned SET model = 'E-150' WHERE model LIKE 'E150%' AND brand = 'Ford';
  UPDATE SUA_Cars_Cleaned SET model = 'E-250' WHERE model LIKE 'E250%' AND brand = 'Ford';
  UPDATE SUA_Cars_Cleaned SET model = 'E-350' WHERE model LIKE 'E350%' AND brand = 'Ford';
  -- MPV-uri
  UPDATE SUA_Cars_Cleaned SET model = 'Aerostar' WHERE model LIKE 'Aerostar%' AND brand = 'Ford';
  UPDATE SUA_Cars_Cleaned SET model = 'Freestar' WHERE model LIKE 'Freestar%' AND brand = 'Ford';
  UPDATE SUA_Cars_Cleaned SET model = 'Windstar' WHERE model LIKE 'Windstar%' AND brand = 'Ford';
  UPDATE SUA_Cars_Cleaned SET model = 'Club Wagon' WHERE model LIKE 'Club Wagon%' AND brand = 'Ford';

  -- Autoturisme Moderne

  UPDATE SUA_Cars_Cleaned SET model = 'C-Max' WHERE model LIKE 'C-Max%' AND brand = 'Ford';
  UPDATE SUA_Cars_Cleaned SET model = 'Focus' WHERE model LIKE 'Focus%' AND brand = 'Ford';
  UPDATE SUA_Cars_Cleaned SET model = 'Fiesta' WHERE model LIKE 'Fiesta%' AND brand = 'Ford';
  UPDATE SUA_Cars_Cleaned SET model = 'Fusion' WHERE model LIKE 'Fusion%' AND brand = 'Ford';
  UPDATE SUA_Cars_Cleaned SET model = 'Taurus' WHERE model LIKE 'Taurus%' AND brand = 'Ford';
  UPDATE SUA_Cars_Cleaned SET model = 'Crown Victoria' WHERE model LIKE 'Crown Victoria%' AND brand = 'Ford';
  UPDATE SUA_Cars_Cleaned SET model = 'Five Hundred' WHERE model LIKE 'Five Hundred%' AND brand = 'Ford';

  -- Vehicule Speciale de Poliție

  UPDATE SUA_Cars_Cleaned SET model = 'Police Interceptor Utility' WHERE model LIKE 'Utility Police Interceptor%'
  AND brand = 'Ford';
  UPDATE SUA_Cars_Cleaned SET model = 'Police Interceptor Sedan' WHERE model LIKE 'Sedan Police Interceptor%'
  AND brand = 'Ford';

  -- Modele Clasice

  UPDATE SUA_Cars_Cleaned SET model = 'Fairlane' WHERE model LIKE 'Fairlane%' AND brand = 'Ford';
  UPDATE SUA_Cars_Cleaned SET model = 'Falcon' WHERE model LIKE 'Falcon%' AND brand = 'Ford';
  UPDATE SUA_Cars_Cleaned SET model = 'Galaxie' WHERE model LIKE 'Galaxie%' AND brand = 'Ford';
  UPDATE SUA_Cars_Cleaned SET model = 'Model A' WHERE model LIKE 'Model A%' AND brand = 'Ford';
  UPDATE SUA_Cars_Cleaned SET model = 'Model T' WHERE model LIKE 'Model T%' AND brand = 'Ford';
  UPDATE SUA_Cars_Cleaned SET model = 'Ranchero' WHERE model LIKE 'Ranchero%' AND brand = 'Ford';
  UPDATE SUA_Cars_Cleaned SET model = 'Thunderbird' WHERE model LIKE 'Thunderbird%' AND brand = 'Ford';
  UPDATE SUA_Cars_Cleaned SET model = 'Torino' WHERE model LIKE 'Torino%' AND brand = 'Ford';
  UPDATE SUA_Cars_Cleaned SET model = 'Pinto' WHERE model LIKE 'Pinto%' AND brand = 'Ford';
  UPDATE SUA_Cars_Cleaned SET model = 'Probe' WHERE model LIKE 'Probe%' AND brand = 'Ford';
  UPDATE SUA_Cars_Cleaned SET model = 'Granada' WHERE model LIKE 'Granada%' AND brand = 'Ford';
  UPDATE SUA_Cars_Cleaned SET model = 'LTD' WHERE model LIKE 'LTD%' AND brand = 'Ford';
  UPDATE SUA_Cars_Cleaned SET model = 'Customline' WHERE model LIKE 'Customline%' AND brand = 'Ford';
  UPDATE SUA_Cars_Cleaned SET model = 'Crestline' WHERE model LIKE 'Crestline%' AND brand = 'Ford';
  -- Modele prezente în date, nemenționate în reguli
  UPDATE SUA_Cars_Cleaned SET model = 'Escort' WHERE model LIKE 'Escort%' AND brand = 'Ford';
  UPDATE SUA_Cars_Cleaned SET model = 'Freestyle' WHERE model LIKE 'Freestyle%' AND brand = 'Ford';

SELECT DISTINCT model, COUNT(*) as nr
  FROM SUA_Cars_Cleaned
  WHERE brand = 'GMC'
  GROUP BY model
  ORDER BY model ASC;

  -- Seria Sierra (Pick-up-uri Full-Size)

  -- Sierra 1500 (include intrările generice 1500)
  UPDATE SUA_Cars_Cleaned SET model = 'Sierra 1500' WHERE (model LIKE 'Sierra 1500%' OR model LIKE '1500%')
  AND brand = 'GMC';
  -- Sierra 2500 (include intrările generice 2500)
  UPDATE SUA_Cars_Cleaned SET model = 'Sierra 2500' WHERE (model LIKE 'Sierra 2500%' OR model LIKE '2500%')
  AND brand = 'GMC';
  -- Sierra 3500 (include intrările generice 3500)
  UPDATE SUA_Cars_Cleaned SET model = 'Sierra 3500' WHERE (model LIKE 'Sierra 3500%' OR model LIKE '3500%')
  AND brand = 'GMC';

  -- Pick-up-uri Mid-size și Clasice

  UPDATE SUA_Cars_Cleaned SET model = 'Canyon' WHERE model LIKE 'Canyon%' AND brand = 'GMC';
  UPDATE SUA_Cars_Cleaned SET model = 'Sonoma' WHERE model LIKE 'Sonoma%' AND brand = 'GMC';
  UPDATE SUA_Cars_Cleaned SET model = 'Caballero' WHERE model LIKE 'Caballero%' AND brand = 'GMC';
  UPDATE SUA_Cars_Cleaned SET model = 'Sprint' WHERE model LIKE 'Sprint%' AND brand = 'GMC';
  UPDATE SUA_Cars_Cleaned SET model = 'Pickup Truck' WHERE model LIKE 'Pickup Truck%' AND brand = 'GMC';

  -- Familia Yukon

  -- Yukon XL (PRIMUL - înainte de Yukon general)
  UPDATE SUA_Cars_Cleaned SET model = 'Yukon XL' WHERE model LIKE 'Yukon XL%' AND brand = 'GMC';
  -- Yukon (restul - exclude XL)
  UPDATE SUA_Cars_Cleaned SET model = 'Yukon' WHERE model LIKE 'Yukon%'
  AND model NOT LIKE 'Yukon XL%' AND brand = 'GMC';

  -- SUV-uri și Crossovere

  UPDATE SUA_Cars_Cleaned SET model = 'Acadia' WHERE model LIKE 'Acadia%' AND brand = 'GMC';
  UPDATE SUA_Cars_Cleaned SET model = 'Terrain' WHERE model LIKE 'Terrain%' AND brand = 'GMC';
  UPDATE SUA_Cars_Cleaned SET model = 'Envoy' WHERE model LIKE 'Envoy%' AND brand = 'GMC';
  UPDATE SUA_Cars_Cleaned SET model = 'Suburban' WHERE model LIKE 'Suburban%' AND brand = 'GMC';
  -- Typhoon (PRIMUL - model de performanță distinct față de Jimmy)
  UPDATE SUA_Cars_Cleaned SET model = 'Typhoon' WHERE model LIKE '%Typhoon%' AND brand = 'GMC';
  -- Jimmy (restul - exclude Typhoon)
  UPDATE SUA_Cars_Cleaned SET model = 'Jimmy' WHERE model LIKE 'Jimmy%'
  AND model NOT LIKE '%Typhoon%' AND brand = 'GMC';

  -- Seria Savana (Vans)

  UPDATE SUA_Cars_Cleaned SET model = 'Savana 1500' WHERE model LIKE '%Savana 1500%' AND brand = 'GMC';
  UPDATE SUA_Cars_Cleaned SET model = 'Savana 2500' WHERE model LIKE '%Savana 2500%' AND brand = 'GMC';
  UPDATE SUA_Cars_Cleaned SET model = 'Savana 3500' WHERE model LIKE '%Savana 3500%' AND brand = 'GMC';
  UPDATE SUA_Cars_Cleaned SET model = 'Safari' WHERE model LIKE 'Safari%' AND brand = 'GMC';
  UPDATE SUA_Cars_Cleaned SET model = 'Vandura' WHERE model LIKE 'Vandura%' AND brand = 'GMC';

  -- Modele Noi / Electrice

  UPDATE SUA_Cars_Cleaned SET model = 'HUMMER EV' WHERE model LIKE 'HUMMER EV%' AND brand = 'GMC';




SELECT DISTINCT model, COUNT(*) as nr
  FROM SUA_Cars_Cleaned
  WHERE brand = 'Honda'
  GROUP BY model
  ORDER BY model ASC;

  -- Familia Civic

  -- Civic Type R (PRIMUL - versiune de performanță distinctă)
  UPDATE SUA_Cars_Cleaned SET model = 'Civic Type R' WHERE model LIKE '%Type R%' AND brand = 'Honda';
  -- Civic Si (PRIMUL - versiune sport distinctă)
  UPDATE SUA_Cars_Cleaned SET model = 'Civic Si' WHERE model LIKE '%Civic Si%' AND brand = 'Honda';
  -- Civic Hybrid (PRIMUL - versiune electrificată distinctă)
  UPDATE SUA_Cars_Cleaned SET model = 'Civic Hybrid' WHERE model LIKE '%Civic Hybrid%' AND brand = 'Honda';
  -- Civic Natural Gas / GX
  UPDATE SUA_Cars_Cleaned SET model = 'Civic Natural Gas/GX' WHERE (model LIKE '%Natural Gas%'
  OR model LIKE 'Civic GX%') AND brand = 'Honda';
  -- Civic (restul - exclude Type R, Si, Hybrid, Natural Gas, GX)
  UPDATE SUA_Cars_Cleaned SET model = 'Civic' WHERE model LIKE 'Civic%'
  AND model NOT LIKE '%Type R%' AND model NOT LIKE '%Civic Si%' AND model NOT LIKE '%Hybrid%'
  AND model NOT LIKE '%Natural Gas%' AND model NOT LIKE '%GX%' AND brand = 'Honda';

  -- Familia Accord și Crosstour

  -- Accord Hybrid (PRIMUL - versiune electrificată distinctă)
  UPDATE SUA_Cars_Cleaned SET model = 'Accord Hybrid' WHERE model LIKE '%Accord Hybrid%' AND brand = 'Honda';
  -- Crosstour (acoperă atât Accord Crosstour, cât și Crosstour independent - aceeași mașină)
  UPDATE SUA_Cars_Cleaned SET model = 'Crosstour' WHERE model LIKE '%Crosstour%' AND brand = 'Honda';
  -- Accord (restul - exclude Hybrid, Crosstour)
  UPDATE SUA_Cars_Cleaned SET model = 'Accord' WHERE model LIKE 'Accord%'
  AND model NOT LIKE '%Hybrid%' AND model NOT LIKE '%Crosstour%' AND brand = 'Honda';

  -- Familia CR-V

  -- CR-V Hybrid (PRIMUL - versiune electrificată distinctă)
  UPDATE SUA_Cars_Cleaned SET model = 'CR-V Hybrid' WHERE model LIKE '%CR-V Hybrid%' AND brand = 'Honda';
  -- CR-V (restul - exclude Hybrid)
  UPDATE SUA_Cars_Cleaned SET model = 'CR-V' WHERE model LIKE 'CR-V%'
  AND model NOT LIKE '%Hybrid%' AND brand = 'Honda';

  -- SUV-uri, Crossovere, Minivan și Pick-up

  UPDATE SUA_Cars_Cleaned SET model = 'Pilot' WHERE model LIKE 'Pilot%' AND brand = 'Honda';
  UPDATE SUA_Cars_Cleaned SET model = 'Passport' WHERE model LIKE 'Passport%' AND brand = 'Honda';
  UPDATE SUA_Cars_Cleaned SET model = 'HR-V' WHERE model LIKE 'HR-V%' AND brand = 'Honda';
  UPDATE SUA_Cars_Cleaned SET model = 'Element' WHERE model LIKE 'Element%' AND brand = 'Honda';
  UPDATE SUA_Cars_Cleaned SET model = 'Odyssey' WHERE model LIKE 'Odyssey%' AND brand = 'Honda';
  UPDATE SUA_Cars_Cleaned SET model = 'Ridgeline' WHERE model LIKE 'Ridgeline%' AND brand = 'Honda';

  -- Modele Compacte și Subcompacte

  UPDATE SUA_Cars_Cleaned SET model = 'Fit' WHERE model LIKE 'Fit%' AND brand = 'Honda';

  -- Vehicule Dedicate (Hibride, Electrice sau Plug-In)

  UPDATE SUA_Cars_Cleaned SET model = 'Insight' WHERE model LIKE 'Insight%' AND brand = 'Honda';
  UPDATE SUA_Cars_Cleaned SET model = 'CR-Z' WHERE model LIKE 'CR-Z%' AND brand = 'Honda';
  UPDATE SUA_Cars_Cleaned SET model = 'Clarity' WHERE model LIKE 'Clarity%' AND brand = 'Honda';

  -- Modele Sport și Clasice

  UPDATE SUA_Cars_Cleaned SET model = 'S2000' WHERE model LIKE 'S2000%' AND brand = 'Honda';
  UPDATE SUA_Cars_Cleaned SET model = 'Prelude' WHERE model LIKE 'Prelude%' AND brand = 'Honda';
  UPDATE SUA_Cars_Cleaned SET model = 'del Sol' WHERE model LIKE '%del Sol%' AND brand = 'Honda';



SELECT DISTINCT model, COUNT(*) as nr
  FROM SUA_Cars_Cleaned
  WHERE brand = 'Hyundai'
  GROUP BY model
  ORDER BY model ASC;

  -- Familia Elantra

  -- Elantra Hybrid (PRIMUL - conține HEV)
  UPDATE SUA_Cars_Cleaned SET model = 'Elantra Hybrid' WHERE model LIKE '%Elantra HEV%' AND brand = 'Hyundai';
  -- Elantra GT (PRIMUL - hatchback distinct față de sedan)
  UPDATE SUA_Cars_Cleaned SET model = 'Elantra GT' WHERE model LIKE '%Elantra GT%' AND brand = 'Hyundai';
  -- Elantra (restul - exclude Hybrid, GT)
  UPDATE SUA_Cars_Cleaned SET model = 'Elantra' WHERE model LIKE 'Elantra%'
  AND model NOT LIKE '%HEV%' AND model NOT LIKE '%Elantra GT%' AND brand = 'Hyundai';

  -- Familia IONIQ

  -- IONIQ 5 (SUV electric - distinct față de hatchback-ul IONIQ original)
  UPDATE SUA_Cars_Cleaned SET model = 'IONIQ 5' WHERE model LIKE '%IONIQ 5%' AND brand = 'Hyundai';
  -- IONIQ EV / Hybrid (hatchback-ul original)
  UPDATE SUA_Cars_Cleaned SET model = 'IONIQ EV/Hybrid' WHERE (model LIKE '%IONIQ EV%'
  OR model LIKE '%IONIQ Hybrid%') AND brand = 'Hyundai';

  -- Familia Sonata

  -- Sonata Hybrid / PHEV (PRIMUL - conține Sonata Hybrid sau Sonata Plug-In Hybrid)
  UPDATE SUA_Cars_Cleaned SET model = 'Sonata Hybrid/PHEV' WHERE (model LIKE '%Sonata Hybrid%'
  OR model LIKE '%Sonata Plug-In Hybrid%') AND brand = 'Hyundai';
  -- Sonata (restul - exclude Hybrid, Plug-In)
  UPDATE SUA_Cars_Cleaned SET model = 'Sonata' WHERE model LIKE 'Sonata%'
  AND model NOT LIKE '%Hybrid%' AND model NOT LIKE '%Plug-In%' AND brand = 'Hyundai';

  -- Familia Santa Fe (Divide pe șasiu)

  -- Santa Fe Hybrid / PHEV (PRIMUL - conține HEV sau Plug-In Hybrid)
  UPDATE SUA_Cars_Cleaned SET model = 'Santa Fe Hybrid/PHEV' WHERE (model LIKE '%Santa Fe HEV%'
  OR model LIKE '%Santa Fe Plug-In Hybrid%') AND brand = 'Hyundai';
  -- Santa Fe Sport (model scurt - platformă diferită)
  UPDATE SUA_Cars_Cleaned SET model = 'Santa Fe Sport' WHERE model LIKE '%Santa Fe Sport%' AND brand = 'Hyundai';
  -- Santa Fe XL (model lung cu 3 rânduri)
  UPDATE SUA_Cars_Cleaned SET model = 'Santa Fe XL' WHERE model LIKE '%Santa Fe XL%' AND brand = 'Hyundai';
  -- Santa Fe (restul - exclude Hybrid, PHEV, Sport, XL)
  UPDATE SUA_Cars_Cleaned SET model = 'Santa Fe' WHERE model LIKE 'Santa Fe%'
  AND model NOT LIKE '%HEV%' AND model NOT LIKE '%Plug-In%'
  AND model NOT LIKE '%Santa Fe Sport%' AND model NOT LIKE '%Santa Fe XL%' AND brand = 'Hyundai';

  -- SUV-uri și Crossovere

  -- Tucson Hybrid (PRIMUL)
  UPDATE SUA_Cars_Cleaned SET model = 'Tucson Hybrid' WHERE model LIKE '%Tucson Hybrid%' AND brand = 'Hyundai';
  -- Tucson (restul - exclude Hybrid)
  UPDATE SUA_Cars_Cleaned SET model = 'Tucson' WHERE model LIKE 'Tucson%'
  AND model NOT LIKE '%Hybrid%' AND brand = 'Hyundai';
  -- Kona EV (PRIMUL - model electric distinct)
  UPDATE SUA_Cars_Cleaned SET model = 'Kona EV' WHERE model LIKE '%Kona EV%' AND brand = 'Hyundai';
  -- Kona N (PRIMUL față de Kona general - exclude N Line care rămâne Kona)
  UPDATE SUA_Cars_Cleaned SET model = 'Kona N' WHERE model LIKE 'Kona N%'
  AND model NOT LIKE 'Kona N Line%' AND brand = 'Hyundai';
  -- Kona (restul - exclude Kona EV; Kona N Line rămâne prins aici)
  UPDATE SUA_Cars_Cleaned SET model = 'Kona' WHERE model LIKE 'Kona%'
  AND model NOT LIKE '%Kona EV%' AND model != 'Kona N' AND brand = 'Hyundai';
  UPDATE SUA_Cars_Cleaned SET model = 'Palisade' WHERE model LIKE 'Palisade%' AND brand = 'Hyundai';
  UPDATE SUA_Cars_Cleaned SET model = 'Venue' WHERE model LIKE 'Venue%' AND brand = 'Hyundai';
  UPDATE SUA_Cars_Cleaned SET model = 'Veracruz' WHERE model LIKE 'Veracruz%' AND brand = 'Hyundai';

  -- Familia Veloster

  -- Veloster N (PRIMUL - versiune de performanță distinctă)
  UPDATE SUA_Cars_Cleaned SET model = 'Veloster N' WHERE model LIKE '%Veloster N%' AND brand = 'Hyundai';
  -- Veloster (restul - exclude N, include Turbo)
  UPDATE SUA_Cars_Cleaned SET model = 'Veloster' WHERE model LIKE 'Veloster%'
  AND model NOT LIKE '%Veloster N%' AND brand = 'Hyundai';

  -- Modele de Lux și Sportive (era pre-Genesis brand)

  -- Genesis Coupe (PRIMUL - model sport cu platformă diferită față de sedan)
  UPDATE SUA_Cars_Cleaned SET model = 'Genesis Coupe' WHERE model LIKE '%Genesis Coupe%' AND brand = 'Hyundai';
  -- Genesis sedan (restul - exclude Coupe)
  UPDATE SUA_Cars_Cleaned SET model = 'Genesis' WHERE model LIKE 'Genesis%'
  AND model NOT LIKE '%Genesis Coupe%' AND brand = 'Hyundai';
  UPDATE SUA_Cars_Cleaned SET model = 'Equus' WHERE model LIKE 'Equus%' AND brand = 'Hyundai';
  UPDATE SUA_Cars_Cleaned SET model = 'Azera' WHERE model LIKE 'Azera%' AND brand = 'Hyundai';

  -- Pick-up și Modele Speciale

  UPDATE SUA_Cars_Cleaned SET model = 'Santa Cruz' WHERE model LIKE 'Santa Cruz%' AND brand = 'Hyundai';
  UPDATE SUA_Cars_Cleaned SET model = 'NEXO' WHERE model LIKE 'NEXO%' AND brand = 'Hyundai';

  -- Modele Compacte și Legacy

  UPDATE SUA_Cars_Cleaned SET model = 'Accent' WHERE model LIKE 'Accent%' AND brand = 'Hyundai';
  UPDATE SUA_Cars_Cleaned SET model = 'Tiburon' WHERE model LIKE 'Tiburon%' AND brand = 'Hyundai';
  UPDATE SUA_Cars_Cleaned SET model = 'Entourage' WHERE model LIKE 'Entourage%' AND brand = 'Hyundai';
  UPDATE SUA_Cars_Cleaned SET model = 'XG350' WHERE model LIKE 'XG350%' AND brand = 'Hyundai';

SELECT DISTINCT model, COUNT(*) as nr
  FROM SUA_Cars_Cleaned
  WHERE brand = 'INFINITI'
  GROUP BY model
  ORDER BY model ASC;

  -- Familia Q50

  -- Q50 Red Sport 400 (PRIMUL - înainte de Q50 Hybrid și Q50 general)
  UPDATE SUA_Cars_Cleaned SET model = 'Q50 Red Sport 400'
  WHERE ((model LIKE '%Q50%' AND model LIKE '%Red Sport%') OR model LIKE 'Q50 400%')
  AND brand = 'INFINITI';
  -- Q50 Hybrid (PRIMUL față de Q50 general)
  UPDATE SUA_Cars_Cleaned SET model = 'Q50 Hybrid' WHERE model LIKE '%Q50 Hybrid%' AND brand = 'INFINITI';
  -- Q50 (restul - exclude Red Sport și Hybrid)
  UPDATE SUA_Cars_Cleaned SET model = 'Q50' WHERE model LIKE 'Q50%'
  AND model NOT LIKE '%Red Sport%' AND model NOT LIKE '%Hybrid%' AND brand = 'INFINITI';

  -- Familia Q60

  -- Q60 Red Sport 400 (PRIMUL - înainte de Q60 general)
  UPDATE SUA_Cars_Cleaned SET model = 'Q60 Red Sport 400'
  WHERE ((model LIKE '%Q60%' AND model LIKE '%Red Sport%') OR model LIKE 'Q60 400%')
  AND brand = 'INFINITI';
  -- Q60 (restul - exclude Red Sport)
  UPDATE SUA_Cars_Cleaned SET model = 'Q60' WHERE model LIKE 'Q60%'
  AND model NOT LIKE '%Red Sport%' AND brand = 'INFINITI';

  -- Familia Q70

  -- Q70L (PRIMUL - versiune alungită, înainte de Q70 general)
  UPDATE SUA_Cars_Cleaned SET model = 'Q70L' WHERE model LIKE 'Q70L%' AND brand = 'INFINITI';
  -- Q70 (restul - exclude Q70L)
  UPDATE SUA_Cars_Cleaned SET model = 'Q70' WHERE model LIKE 'Q70%'
  AND model NOT LIKE 'Q70L%' AND brand = 'INFINITI';

  -- Seria Q (Q40, Q45)

  UPDATE SUA_Cars_Cleaned SET model = 'Q40' WHERE model LIKE 'Q40%' AND brand = 'INFINITI';
  UPDATE SUA_Cars_Cleaned SET model = 'Q45' WHERE model LIKE 'Q45%' AND brand = 'INFINITI';

  -- Familia G37

  -- G37 IPL (PRIMUL - versiune de performanță, înainte de G37 general)
  UPDATE SUA_Cars_Cleaned SET model = 'G37 IPL'
  WHERE (model LIKE '%G37 IPL%' OR model LIKE '%IPL G%') AND brand = 'INFINITI';
  -- G37 (restul - exclude IPL)
  UPDATE SUA_Cars_Cleaned SET model = 'G37' WHERE model LIKE 'G37%'
  AND model NOT LIKE '%IPL%' AND brand = 'INFINITI';

  -- Seria G (G20, G25, G35)

  UPDATE SUA_Cars_Cleaned SET model = 'G35' WHERE model LIKE 'G35%' AND brand = 'INFINITI';
  UPDATE SUA_Cars_Cleaned SET model = 'G25' WHERE model LIKE 'G25%' AND brand = 'INFINITI';
  UPDATE SUA_Cars_Cleaned SET model = 'G20' WHERE model LIKE 'G20%' AND brand = 'INFINITI';

  -- Seria M (M30–M56)

  UPDATE SUA_Cars_Cleaned SET model = 'M56' WHERE model LIKE 'M56%' AND brand = 'INFINITI';
  UPDATE SUA_Cars_Cleaned SET model = 'M45' WHERE model LIKE 'M45%' AND brand = 'INFINITI';
  UPDATE SUA_Cars_Cleaned SET model = 'M37' WHERE model LIKE 'M37%' AND brand = 'INFINITI';
  UPDATE SUA_Cars_Cleaned SET model = 'M35' WHERE model LIKE 'M35%' AND brand = 'INFINITI';
  UPDATE SUA_Cars_Cleaned SET model = 'M30' WHERE model LIKE 'M30%' AND brand = 'INFINITI';

  -- Seria I și J (modele vechi)

  UPDATE SUA_Cars_Cleaned SET model = 'I30' WHERE model LIKE 'I30%' AND brand = 'INFINITI';
  UPDATE SUA_Cars_Cleaned SET model = 'I35' WHERE model LIKE 'I35%' AND brand = 'INFINITI';
  UPDATE SUA_Cars_Cleaned SET model = 'J30' WHERE model LIKE 'J30%' AND brand = 'INFINITI';

  -- Familia QX modernă (QX30–QX80)

  UPDATE SUA_Cars_Cleaned SET model = 'QX80' WHERE model LIKE 'QX80%' AND brand = 'INFINITI';
  UPDATE SUA_Cars_Cleaned SET model = 'QX70' WHERE model LIKE 'QX70%' AND brand = 'INFINITI';
  -- QX60 Hybrid (PRIMUL - înainte de QX60 general)
  UPDATE SUA_Cars_Cleaned SET model = 'QX60 Hybrid' WHERE model LIKE 'QX60%'
  AND model LIKE '%Hybrid%' AND brand = 'INFINITI';
  -- QX60 (restul - exclude Hybrid)
  UPDATE SUA_Cars_Cleaned SET model = 'QX60' WHERE model LIKE 'QX60%'
  AND model NOT LIKE '%Hybrid%' AND brand = 'INFINITI';
  UPDATE SUA_Cars_Cleaned SET model = 'QX55' WHERE model LIKE 'QX55%' AND brand = 'INFINITI';
  UPDATE SUA_Cars_Cleaned SET model = 'QX50' WHERE model LIKE 'QX50%' AND brand = 'INFINITI';
  UPDATE SUA_Cars_Cleaned SET model = 'QX30' WHERE model LIKE 'QX30%' AND brand = 'INFINITI';
  UPDATE SUA_Cars_Cleaned SET model = 'QX56' WHERE model LIKE 'QX56%' AND brand = 'INFINITI';

  -- Seria FX (SUV-uri clasice)

  UPDATE SUA_Cars_Cleaned SET model = 'FX35' WHERE model LIKE 'FX35%' AND brand = 'INFINITI';
  UPDATE SUA_Cars_Cleaned SET model = 'FX37' WHERE model LIKE 'FX37%' AND brand = 'INFINITI';
  UPDATE SUA_Cars_Cleaned SET model = 'FX45' WHERE model LIKE 'FX45%' AND brand = 'INFINITI';
  UPDATE SUA_Cars_Cleaned SET model = 'FX50' WHERE model LIKE 'FX50%' AND brand = 'INFINITI';

  -- EX, JX și QX4

  UPDATE SUA_Cars_Cleaned SET model = 'EX35' WHERE model LIKE 'EX35%' AND brand = 'INFINITI';
  UPDATE SUA_Cars_Cleaned SET model = 'EX37' WHERE model LIKE 'EX37%' AND brand = 'INFINITI';
  UPDATE SUA_Cars_Cleaned SET model = 'JX35' WHERE model LIKE 'JX35%' AND brand = 'INFINITI';
  UPDATE SUA_Cars_Cleaned SET model = 'QX4' WHERE model LIKE 'QX4%' AND brand = 'INFINITI';

SELECT DISTINCT model, COUNT(*) as nr
  FROM SUA_Cars_Cleaned
  WHERE brand = 'Jaguar'
  GROUP BY model
  ORDER BY model ASC;

  -- SUV-uri (Seria PACE)

  -- F-PACE SVR (PRIMUL - înaintea F-PACE general)
  UPDATE SUA_Cars_Cleaned SET model = 'F-PACE SVR'
  WHERE model LIKE '%F-PACE%' AND model LIKE '%SVR%'
  AND brand = 'Jaguar';
  -- F-PACE (restul - exclude SVR)
  UPDATE SUA_Cars_Cleaned SET model = 'F-PACE' WHERE model LIKE 'F-PACE%'
  AND model NOT LIKE '%SVR%' AND brand = 'Jaguar';
  UPDATE SUA_Cars_Cleaned SET model = 'E-PACE' WHERE model LIKE 'E-PACE%' AND brand = 'Jaguar';
  UPDATE SUA_Cars_Cleaned SET model = 'I-PACE' WHERE model LIKE 'I-PACE%' AND brand = 'Jaguar';

  -- Sedane Moderne (XE, XF, XJ)

  -- XE SV Project 8 (PRIMUL - ediție specială, înaintea XE general)
  UPDATE SUA_Cars_Cleaned SET model = 'XE SV Project 8'
  WHERE (model LIKE '%XE SV%' OR model LIKE '%Project 8%')
  AND brand = 'Jaguar';
  -- XE (restul - exclude SV)
  UPDATE SUA_Cars_Cleaned SET model = 'XE' WHERE model LIKE 'XE%'
  AND model NOT LIKE '%SV%' AND brand = 'Jaguar';
  -- XF Sportbrake (PRIMUL - variantă break, înaintea XF general)
  UPDATE SUA_Cars_Cleaned SET model = 'XF Sportbrake'
  WHERE model LIKE '%XF Sportbrake%' AND brand = 'Jaguar';
  -- XF (restul - exclude Sportbrake; include XFR, XFR-S)
  UPDATE SUA_Cars_Cleaned SET model = 'XF' WHERE model LIKE 'XF%'
  AND model NOT LIKE '%Sportbrake%' AND brand = 'Jaguar';
  -- XJ6, XJ8, XJR (PRIMELE - generații anterioare, înaintea XJ general)
  UPDATE SUA_Cars_Cleaned SET model = 'XJ6' WHERE model LIKE 'XJ6%' AND brand = 'Jaguar';
  UPDATE SUA_Cars_Cleaned SET model = 'XJ8' WHERE model LIKE '%XJ8%' AND brand = 'Jaguar';
  UPDATE SUA_Cars_Cleaned SET model = 'XJR' WHERE model LIKE '%XJR%' AND brand = 'Jaguar';
  -- XJ (restul - exclude XJ6, XJ8, XJR)
  UPDATE SUA_Cars_Cleaned SET model = 'XJ' WHERE model LIKE 'XJ%'
  AND model NOT LIKE 'XJ6%' AND model NOT LIKE 'XJ8%' AND model NOT LIKE 'XJR%'
  AND brand = 'Jaguar';

  -- Mașini Sport (F-TYPE și Seria XK)

  -- F-TYPE SVR (PRIMUL - înaintea F-TYPE general)
  UPDATE SUA_Cars_Cleaned SET model = 'F-TYPE SVR'
  WHERE model LIKE '%F-TYPE%' AND model LIKE '%SVR%'
  AND brand = 'Jaguar';
  -- F-TYPE (restul - exclude SVR)
  UPDATE SUA_Cars_Cleaned SET model = 'F-TYPE' WHERE model LIKE 'F-TYPE%'
  AND model NOT LIKE '%SVR%' AND brand = 'Jaguar';
  -- XKR-S (PRIMUL - versiunea extremă, înaintea XKR și XK general)
  UPDATE SUA_Cars_Cleaned SET model = 'XKR-S'
  WHERE model LIKE '%XK%' AND model LIKE '%R-S%'
  AND brand = 'Jaguar';
  -- XKE (PRIMUL față de XK general - cunoscut și ca E-Type clasic)
  UPDATE SUA_Cars_Cleaned SET model = 'XKE' WHERE model LIKE 'XKE%' AND brand = 'Jaguar';
  -- XKR (PRIMUL față de XK general - include XK R; exclude R-S)
  UPDATE SUA_Cars_Cleaned SET model = 'XKR'
  WHERE (model LIKE '%XKR%' OR model LIKE 'XK R%')
  AND model NOT LIKE '%R-S%' AND brand = 'Jaguar';
  -- XK8 (PRIMUL față de XK general)
  UPDATE SUA_Cars_Cleaned SET model = 'XK8' WHERE model LIKE '%XK8%' AND brand = 'Jaguar';
  -- XK 120, 140, 150 (PRIMELE față de XK general - modele clasice)
  UPDATE SUA_Cars_Cleaned SET model = 'XK 120' WHERE model LIKE 'XK 120%' AND brand = 'Jaguar';
  UPDATE SUA_Cars_Cleaned SET model = 'XK 140' WHERE model LIKE 'XK 140%' AND brand = 'Jaguar';
  UPDATE SUA_Cars_Cleaned SET model = 'XK 150' WHERE model LIKE 'XK 150%' AND brand = 'Jaguar';
  -- XK (restul - exclude XKE, XKR/XKR-S, XK8, XK 120/140/150)
  UPDATE SUA_Cars_Cleaned SET model = 'XK' WHERE model LIKE 'XK%'
  AND model NOT LIKE 'XKE%' AND model NOT LIKE '%XKR%'
  AND model NOT LIKE '%XK8%' AND model NOT LIKE 'XK 1%'
  AND brand = 'Jaguar';

  -- Modele Legacy

  UPDATE SUA_Cars_Cleaned SET model = 'S-Type' WHERE model LIKE 'S-Type%' AND brand = 'Jaguar';
  UPDATE SUA_Cars_Cleaned SET model = 'X-Type' WHERE model LIKE 'X-Type%' AND brand = 'Jaguar';
  UPDATE SUA_Cars_Cleaned SET model = 'XJS' WHERE model LIKE 'XJS%' AND brand = 'Jaguar';

  -- Clasice și Heritage

  -- Mark VIII (PRIMUL - altfel LIKE 'Mark V%' prinde și Mark VIII)
  UPDATE SUA_Cars_Cleaned SET model = 'Mark VIII' WHERE model LIKE 'Mark VIII%' AND brand = 'Jaguar';
  -- Mark V (restul - exclude Mark VIII)
  UPDATE SUA_Cars_Cleaned SET model = 'Mark V' WHERE model LIKE 'Mark V%'
  AND model NOT LIKE 'Mark VIII%' AND brand = 'Jaguar';
  UPDATE SUA_Cars_Cleaned SET model = 'Mark II' WHERE model LIKE 'Mark II%' AND brand = 'Jaguar';
  UPDATE SUA_Cars_Cleaned SET model = '420' WHERE model LIKE '420%' AND brand = 'Jaguar';
  UPDATE SUA_Cars_Cleaned SET model = 'D-Type' WHERE model LIKE 'D-Type%' AND brand = 'Jaguar';
  UPDATE SUA_Cars_Cleaned SET model = 'Vanden Plas' WHERE model LIKE 'Vanden Plas%' AND brand = 'Jaguar';


SELECT DISTINCT model, COUNT(*) as nr
  FROM SUA_Cars_Cleaned
  WHERE brand = 'Jeep'
  GROUP BY model
  ORDER BY model ASC;

  -- Familia Grand Cherokee

  -- Grand Cherokee 4xe (PRIMUL - PHEV, înaintea celorlalte variante Grand Cherokee)
  UPDATE SUA_Cars_Cleaned SET model = 'Grand Cherokee 4xe'
  WHERE model LIKE '%Grand Cherokee%' AND model LIKE '%4xe%'
  AND brand = 'Jeep';
  -- Grand Cherokee SRT/Trackhawk (PRIMUL - versiuni de performanță)
  UPDATE SUA_Cars_Cleaned SET model = 'Grand Cherokee SRT/Trackhawk'
  WHERE model LIKE '%Grand Cherokee%'
  AND (model LIKE '%SRT%' OR model LIKE '%Trackhawk%')
  AND brand = 'Jeep';
  -- Grand Cherokee L (PRIMUL - versiunea cu 3 rânduri, înaintea Grand Cherokee general)
  UPDATE SUA_Cars_Cleaned SET model = 'Grand Cherokee L'
  WHERE model LIKE 'Grand Cherokee L %' AND brand = 'Jeep';
  -- Grand Cherokee (restul - include WK; exclude 4xe, SRT/Trackhawk, L)
  UPDATE SUA_Cars_Cleaned SET model = 'Grand Cherokee' WHERE model LIKE 'Grand Cherokee%'
  AND model NOT LIKE '%4xe%' AND model NOT LIKE '%SRT%' AND model NOT LIKE '%Trackhawk%'
  AND model != 'Grand Cherokee L' AND brand = 'Jeep';

  -- Familia Wrangler

  -- Wrangler 4xe (PRIMUL - hibrid plug-in, înaintea Unlimited și general)
  UPDATE SUA_Cars_Cleaned SET model = 'Wrangler 4xe'
  WHERE model LIKE '%Wrangler%' AND model LIKE '%4xe%'
  AND brand = 'Jeep';
  -- Wrangler Rubicon 392 (PRIMUL - motorizare V8, înaintea Unlimited)
  UPDATE SUA_Cars_Cleaned SET model = 'Wrangler Rubicon 392'
  WHERE model LIKE '%Wrangler%' AND model LIKE '%392%'
  AND brand = 'Jeep';
  -- Wrangler Unlimited (PRIMUL față de Wrangler general - 4 uși; exclude 4xe)
  UPDATE SUA_Cars_Cleaned SET model = 'Wrangler Unlimited'
  WHERE model LIKE '%Wrangler%'
  AND (model LIKE '%Unlimited%' OR model LIKE '%4-Door%')
  AND model NOT LIKE '%4xe%' AND brand = 'Jeep';
  -- Wrangler (restul - modele cu 2 uși/base)
  UPDATE SUA_Cars_Cleaned SET model = 'Wrangler' WHERE model LIKE 'Wrangler%'
  AND model NOT LIKE '%4xe%' AND model NOT LIKE '%392%' AND model NOT LIKE '%Unlimited%'
  AND brand = 'Jeep';

  -- SUV-uri și Crossovere Moderne

  UPDATE SUA_Cars_Cleaned SET model = 'Gladiator' WHERE model LIKE 'Gladiator%' AND brand = 'Jeep';
  UPDATE SUA_Cars_Cleaned SET model = 'Cherokee' WHERE model LIKE 'Cherokee%' AND brand = 'Jeep';
  -- Compass (include intrările cu prefix 'New Compass' din perioada de reînnoire model)
  UPDATE SUA_Cars_Cleaned SET model = 'Compass'
  WHERE (model LIKE 'Compass%' OR model LIKE 'New Compass%') AND brand = 'Jeep';
  UPDATE SUA_Cars_Cleaned SET model = 'Renegade' WHERE model LIKE 'Renegade%' AND brand = 'Jeep';

  -- Noile Modele Premium (Wagoneer)

  -- Grand Wagoneer (PRIMUL - înaintea Wagoneer general)
  UPDATE SUA_Cars_Cleaned SET model = 'Grand Wagoneer' WHERE model LIKE 'Grand Wagoneer%' AND brand = 'Jeep';
  -- Wagoneer (restul - LIKE 'Wagoneer%' nu prinde 'Grand Wagoneer' deoarece începe cu 'Grand')
  UPDATE SUA_Cars_Cleaned SET model = 'Wagoneer' WHERE model LIKE 'Wagoneer%' AND brand = 'Jeep';

  -- Modele Legacy

  UPDATE SUA_Cars_Cleaned SET model = 'Liberty' WHERE model LIKE 'Liberty%' AND brand = 'Jeep';
  UPDATE SUA_Cars_Cleaned SET model = 'Patriot' WHERE model LIKE 'Patriot%' AND brand = 'Jeep';
  UPDATE SUA_Cars_Cleaned SET model = 'Commander' WHERE model LIKE 'Commander%' AND brand = 'Jeep';

  -- Clasice și Heritage

  UPDATE SUA_Cars_Cleaned SET model = 'CJ-5' WHERE model LIKE 'CJ-5%' AND brand = 'Jeep';
  UPDATE SUA_Cars_Cleaned SET model = 'CJ-7' WHERE model LIKE 'CJ-7%' AND brand = 'Jeep';
  UPDATE SUA_Cars_Cleaned SET model = 'Scrambler' WHERE model LIKE '%Scrambler%' AND brand = 'Jeep';
  UPDATE SUA_Cars_Cleaned SET model = 'Comanche' WHERE model LIKE 'Comanche%' AND brand = 'Jeep';
  UPDATE SUA_Cars_Cleaned SET model = 'J10' WHERE model LIKE 'J10%' AND brand = 'Jeep';
  UPDATE SUA_Cars_Cleaned SET model = 'Jeepster' WHERE model LIKE 'Jeepster%' AND brand = 'Jeep';

SELECT DISTINCT model, COUNT(*) as nr
  FROM SUA_Cars_Cleaned
  WHERE brand = 'Kia'
  GROUP BY model
  ORDER BY model ASC;

  -- Modele Electrice și Hibride

  -- EV6 GT/GT-Line (PRIMUL - înaintea EV6 general)
  UPDATE SUA_Cars_Cleaned SET model = 'EV6 GT/GT-Line'
  WHERE model LIKE 'EV6%' AND model LIKE '%GT%'
  AND brand = 'Kia';
  -- EV6 (restul - Wind, Light etc.)
  UPDATE SUA_Cars_Cleaned SET model = 'EV6' WHERE model LIKE 'EV6%'
  AND model NOT LIKE '%GT%' AND brand = 'Kia';
  -- Niro EV (PRIMUL față de Niro Plug-In și Niro Hybrid)
  UPDATE SUA_Cars_Cleaned SET model = 'Niro EV' WHERE model LIKE 'Niro EV%' AND brand = 'Kia';
  -- Niro Plug-In Hybrid (PRIMUL față de Niro Hybrid general)
  UPDATE SUA_Cars_Cleaned SET model = 'Niro Plug-In Hybrid'
  WHERE model LIKE 'Niro Plug-In%' AND brand = 'Kia';
  -- Niro Hybrid (restul - LX, EX, FE, Touring; toate Niro-urile de bază sunt hibride)
  UPDATE SUA_Cars_Cleaned SET model = 'Niro Hybrid' WHERE model LIKE 'Niro%'
  AND model NOT LIKE 'Niro EV%' AND model NOT LIKE 'Niro Plug-In%'
  AND brand = 'Kia';
  -- Sorento Hybrid/PHEV (PRIMUL față de Sorento general)
  UPDATE SUA_Cars_Cleaned SET model = 'Sorento Hybrid/PHEV'
  WHERE model LIKE '%Sorento%'
  AND (model LIKE '%Hybrid%' OR model LIKE '%Plug-In%')
  AND brand = 'Kia';
  -- Sportage Hybrid/PHEV (PRIMUL față de Sportage general)
  UPDATE SUA_Cars_Cleaned SET model = 'Sportage Hybrid/PHEV'
  WHERE model LIKE '%Sportage%'
  AND (model LIKE '%Hybrid%' OR model LIKE '%Plug-In%')
  AND brand = 'Kia';
  -- Optima Hybrid/PHEV (PRIMUL față de Optima general)
  UPDATE SUA_Cars_Cleaned SET model = 'Optima Hybrid/PHEV'
  WHERE model LIKE '%Optima%'
  AND (model LIKE '%Hybrid%' OR model LIKE '%Plug-In%')
  AND brand = 'Kia';
  -- Soul EV (PRIMUL față de Soul general)
  UPDATE SUA_Cars_Cleaned SET model = 'Soul EV' WHERE model LIKE 'Soul EV%' AND brand = 'Kia';

  -- Sedane și Performance

  -- Stinger GT (PRIMUL - include GT, GT1, GT2, GTS; exclude GT-Line)
  UPDATE SUA_Cars_Cleaned SET model = 'Stinger GT'
  WHERE model LIKE 'Stinger%' AND model LIKE '%GT%'
  AND model NOT LIKE '%GT-Line%' AND brand = 'Kia';
  -- Stinger (restul - Base, Premium, GT-Line)
  UPDATE SUA_Cars_Cleaned SET model = 'Stinger' WHERE model LIKE 'Stinger%'
  AND model != 'Stinger GT' AND brand = 'Kia';
  -- K5 GT/GT-Line (PRIMUL față de K5 general)
  UPDATE SUA_Cars_Cleaned SET model = 'K5 GT/GT-Line'
  WHERE model LIKE 'K5%' AND model LIKE '%GT%'
  AND brand = 'Kia';
  -- K5 (restul - LX, EX, LXS)
  UPDATE SUA_Cars_Cleaned SET model = 'K5' WHERE model LIKE 'K5%'
  AND model NOT LIKE '%GT%' AND brand = 'Kia';
  -- Forte GT/GT-Line (PRIMUL față de Forte general)
  UPDATE SUA_Cars_Cleaned SET model = 'Forte GT/GT-Line'
  WHERE model LIKE 'Forte%' AND model LIKE '%GT%'
  AND brand = 'Kia';
  -- Forte (restul - include Koup, LXS, FE, S, SX)
  UPDATE SUA_Cars_Cleaned SET model = 'Forte' WHERE model LIKE 'Forte%'
  AND model NOT LIKE '%GT%' AND brand = 'Kia';
  -- Optima (restul - exclude Hybrid și Plug-In deja procesate)
  UPDATE SUA_Cars_Cleaned SET model = 'Optima' WHERE model LIKE 'Optima%'
  AND model NOT LIKE '%Hybrid%' AND model NOT LIKE '%Plug-In%'
  AND brand = 'Kia';

  -- SUV-uri și Crossovere

  UPDATE SUA_Cars_Cleaned SET model = 'Telluride' WHERE model LIKE 'Telluride%' AND brand = 'Kia';
  -- Sorento (restul - exclude Hybrid/PHEV deja procesate)
  UPDATE SUA_Cars_Cleaned SET model = 'Sorento' WHERE model LIKE 'Sorento%'
  AND model NOT LIKE '%Hybrid%' AND model NOT LIKE '%Plug-In%'
  AND brand = 'Kia';
  -- Sportage (restul - exclude Hybrid/PHEV deja procesate)
  UPDATE SUA_Cars_Cleaned SET model = 'Sportage' WHERE model LIKE 'Sportage%'
  AND model NOT LIKE '%Hybrid%' AND model NOT LIKE '%Plug-In%'
  AND brand = 'Kia';
  UPDATE SUA_Cars_Cleaned SET model = 'Seltos' WHERE model LIKE 'Seltos%' AND brand = 'Kia';
  -- Soul (restul - exclude Soul EV deja procesat)
  UPDATE SUA_Cars_Cleaned SET model = 'Soul' WHERE model LIKE 'Soul%'
  AND model NOT LIKE '%EV%' AND brand = 'Kia';
  UPDATE SUA_Cars_Cleaned SET model = 'Borrego' WHERE model LIKE 'Borrego%' AND brand = 'Kia';

  -- Modele Compacte și Subcompacte

  -- Rio5 (PRIMUL - variantă hatchback, înaintea Rio sedan)
  UPDATE SUA_Cars_Cleaned SET model = 'Rio5' WHERE model LIKE '%Rio5%' AND brand = 'Kia';
  -- Rio (restul - sedan)
  UPDATE SUA_Cars_Cleaned SET model = 'Rio' WHERE model LIKE 'Rio%'
  AND model NOT LIKE '%Rio5%' AND brand = 'Kia';
  -- Spectra5 (PRIMUL - hatchback, înaintea Spectra)
  UPDATE SUA_Cars_Cleaned SET model = 'Spectra5' WHERE model LIKE '%Spectra5%' AND brand = 'Kia';
  -- Spectra (restul)
  UPDATE SUA_Cars_Cleaned SET model = 'Spectra' WHERE model LIKE 'Spectra%'
  AND model NOT LIKE '%Spectra5%' AND brand = 'Kia';

  -- Minivan și MPV

  UPDATE SUA_Cars_Cleaned SET model = 'Carnival' WHERE model LIKE 'Carnival%' AND brand = 'Kia';
  UPDATE SUA_Cars_Cleaned SET model = 'Sedona' WHERE model LIKE 'Sedona%' AND brand = 'Kia';
  UPDATE SUA_Cars_Cleaned SET model = 'Rondo' WHERE model LIKE 'Rondo%' AND brand = 'Kia';

  -- Modele de Lux și Legacy

  UPDATE SUA_Cars_Cleaned SET model = 'K900' WHERE model LIKE 'K900%' AND brand = 'Kia';
  UPDATE SUA_Cars_Cleaned SET model = 'Cadenza' WHERE model LIKE 'Cadenza%' AND brand = 'Kia';
  UPDATE SUA_Cars_Cleaned SET model = 'Amanti' WHERE model LIKE 'Amanti%' AND brand = 'Kia';
  UPDATE SUA_Cars_Cleaned SET model = 'Sephia' WHERE model LIKE 'Sephia%' AND brand = 'Kia';

SELECT DISTINCT model, COUNT(*) as nr
  FROM SUA_Cars_Cleaned
  WHERE brand = 'Land Rover'
  GROUP BY model
  ORDER BY model ASC;

  -- Familia Defender

  -- Defender 90, 110, 130 (PRIMELE - pe dimensiunea șasiului)
  UPDATE SUA_Cars_Cleaned SET model = 'Defender 90' WHERE model LIKE 'Defender 90%' AND brand = 'Land Rover';
  UPDATE SUA_Cars_Cleaned SET model = 'Defender 110' WHERE model LIKE 'Defender 110%' AND brand = 'Land Rover';
  UPDATE SUA_Cars_Cleaned SET model = 'Defender 130' WHERE model LIKE 'Defender 130%' AND brand = 'Land Rover';
  -- Defender Classic (TDI, COLLECTOR SERIES, ARKONIK - modele vechi/restaurate fără 90/110/130)
  UPDATE SUA_Cars_Cleaned SET model = 'Defender Classic'
  WHERE model LIKE 'Defender%'
  AND (model LIKE '%TDI%' OR model LIKE '%COLLECTOR%' OR model LIKE '%ARKONIK%')
  AND brand = 'Land Rover';
  -- Defender (restul - modern 2020+; exclude 90/110/130/Classic)
  UPDATE SUA_Cars_Cleaned SET model = 'Defender' WHERE model LIKE 'Defender%'
  AND model != 'Defender 90' AND model != 'Defender 110' AND model != 'Defender 130'
  AND model != 'Defender Classic' AND brand = 'Land Rover';

  -- Familia Range Rover

  -- Range Rover Sport SVR (PRIMUL - înaintea Range Rover Sport general)
  UPDATE SUA_Cars_Cleaned SET model = 'Range Rover Sport SVR'
  WHERE model LIKE '%Range Rover Sport%' AND model LIKE '%SVR%'
  AND brand = 'Land Rover';
  -- Range Rover Sport (restul - exclude SVR)
  UPDATE SUA_Cars_Cleaned SET model = 'Range Rover Sport'
  WHERE model LIKE '%Range Rover Sport%'
  AND model NOT LIKE '%SVR%' AND brand = 'Land Rover';
  -- Range Rover Velar
  UPDATE SUA_Cars_Cleaned SET model = 'Range Rover Velar'
  WHERE model LIKE '%Range Rover Velar%' AND brand = 'Land Rover';
  -- Range Rover Evoque
  UPDATE SUA_Cars_Cleaned SET model = 'Range Rover Evoque'
  WHERE model LIKE '%Range Rover Evoque%' AND brand = 'Land Rover';
  -- Range Rover Classic (PRIMUL față de LWB și general - era County/Classic anii '70-'90)
  UPDATE SUA_Cars_Cleaned SET model = 'Range Rover Classic'
  WHERE model LIKE '%Range Rover%'
  AND (model LIKE '%County%' OR model LIKE '%Classic%' OR model LIKE '%2.5DSE%')
  AND brand = 'Land Rover';
  -- Range Rover LWB (flagship lung - înaintea Range Rover general SWB)
  UPDATE SUA_Cars_Cleaned SET model = 'Range Rover LWB'
  WHERE model LIKE '%Range Rover%' AND model LIKE '%LWB%'
  AND brand = 'Land Rover';
  -- Range Rover (restul flagship SWB - exclude Sport, Velar, Evoque, Classic, LWB)
  UPDATE SUA_Cars_Cleaned SET model = 'Range Rover' WHERE model LIKE 'Range Rover%'
  AND model NOT LIKE '%Sport%' AND model NOT LIKE '%Velar%' AND model NOT LIKE '%Evoque%'
  AND model != 'Range Rover Classic' AND model != 'Range Rover LWB'
  AND brand = 'Land Rover';

  -- Familia Discovery

  -- Discovery Sport (PRIMUL - modelul compact, înaintea Discovery general)
  UPDATE SUA_Cars_Cleaned SET model = 'Discovery Sport'
  WHERE model LIKE '%Discovery Sport%' AND brand = 'Land Rover';
  -- Discovery (restul - include Series II, HSE, Landmark)
  UPDATE SUA_Cars_Cleaned SET model = 'Discovery' WHERE model LIKE 'Discovery%'
  AND model NOT LIKE '%Discovery Sport%' AND brand = 'Land Rover';

  -- Modelele Numerice

  UPDATE SUA_Cars_Cleaned SET model = 'LR4' WHERE model LIKE 'LR4%' AND brand = 'Land Rover';
  UPDATE SUA_Cars_Cleaned SET model = 'LR3' WHERE model LIKE 'LR3%' AND brand = 'Land Rover';
  UPDATE SUA_Cars_Cleaned SET model = 'LR2' WHERE model LIKE 'LR2%' AND brand = 'Land Rover';

  -- Clasice și Heritage

  -- Series III (PRIMUL - altfel LIKE 'Series II%' prinde și Series III)
  UPDATE SUA_Cars_Cleaned SET model = 'Series III' WHERE model LIKE 'Series III%' AND brand = 'Land Rover';
  -- Series II (restul - exclude Series III)
  UPDATE SUA_Cars_Cleaned SET model = 'Series II' WHERE model LIKE 'Series II%'
  AND model NOT LIKE 'Series III%' AND brand = 'Land Rover';

SELECT DISTINCT model, COUNT(*) as nr
  FROM SUA_Cars_Cleaned
  WHERE brand = 'Lexus'
  GROUP BY model
  ORDER BY model ASC;

  -- Sedane și Coupe-uri

  -- IS F / IS 500 (PRIMUL - V8 performanță, înaintea IS general; include IS-F cu liniuță)
  UPDATE SUA_Cars_Cleaned SET model = 'IS F/IS 500'
  WHERE model LIKE 'IS%'
  AND (model LIKE '%IS-F%' OR model LIKE '%IS F%' OR model LIKE '%IS 500%')
  AND brand = 'Lexus';
  -- IS (restul - 200t, 250, 300, 350, SportCross)
  UPDATE SUA_Cars_Cleaned SET model = 'IS' WHERE model LIKE 'IS%'
  AND model NOT LIKE '%IS-F%' AND model NOT LIKE '%IS F%' AND model NOT LIKE '%IS 500%'
  AND brand = 'Lexus';
  -- ES Hybrid / ES 300h (PRIMUL față de ES general)
  UPDATE SUA_Cars_Cleaned SET model = 'ES Hybrid'
  WHERE model LIKE '%ES 300h%' AND brand = 'Lexus';
  -- ES (restul - 250, 300, 330, 350)
  UPDATE SUA_Cars_Cleaned SET model = 'ES' WHERE model LIKE 'ES%'
  AND model NOT LIKE '%300h%' AND model NOT LIKE '%Hybrid%'
  AND brand = 'Lexus';
  -- GS F (PRIMUL față de GS Hybrid și GS general)
  UPDATE SUA_Cars_Cleaned SET model = 'GS F'
  WHERE model LIKE '%GS F%' AND brand = 'Lexus';
  -- GS Hybrid / GS 450h (PRIMUL față de GS general)
  UPDATE SUA_Cars_Cleaned SET model = 'GS Hybrid'
  WHERE model LIKE '%GS 450h%' AND brand = 'Lexus';
  -- GS (restul - 200t, 300, 350, 400, 430)
  UPDATE SUA_Cars_Cleaned SET model = 'GS' WHERE model LIKE 'GS%'
  AND model NOT LIKE '%GS F%' AND model NOT LIKE '%Hybrid%' AND model NOT LIKE '%450h%'
  AND brand = 'Lexus';
  -- LS L (PRIMUL - ampatament lung; include LS 460 L și LS 600h L)
  UPDATE SUA_Cars_Cleaned SET model = 'LS L'
  WHERE (model LIKE 'LS 460 L%' OR model LIKE 'LS 600h L%')
  AND brand = 'Lexus';
  -- LS Hybrid (PRIMUL față de LS general - LS 500h și LS 600h)
  UPDATE SUA_Cars_Cleaned SET model = 'LS Hybrid'
  WHERE model LIKE 'LS%'
  AND (model LIKE '%LS 500h%' OR model LIKE '%LS 600h%')
  AND brand = 'Lexus';
  -- LS (restul - 400, 430, 460, 500)
  UPDATE SUA_Cars_Cleaned SET model = 'LS' WHERE model LIKE 'LS%'
  AND model NOT LIKE '%500h%' AND model NOT LIKE '%600h%'
  AND model NOT LIKE '%Hybrid%' AND model != 'LS L'
  AND brand = 'Lexus';
  -- RC F (PRIMUL față de RC general)
  UPDATE SUA_Cars_Cleaned SET model = 'RC F'
  WHERE model LIKE '%RC F%' AND brand = 'Lexus';
  -- RC (restul - 200t, 300, 350)
  UPDATE SUA_Cars_Cleaned SET model = 'RC' WHERE model LIKE 'RC%'
  AND model NOT LIKE '%RC F%' AND brand = 'Lexus';
  -- LC Hybrid / LC 500h (PRIMUL față de LC general)
  UPDATE SUA_Cars_Cleaned SET model = 'LC Hybrid'
  WHERE model LIKE '%LC 500h%' AND brand = 'Lexus';
  -- LC (restul - LC 500)
  UPDATE SUA_Cars_Cleaned SET model = 'LC' WHERE model LIKE 'LC%'
  AND model NOT LIKE '%500h%' AND model NOT LIKE '%Hybrid%'
  AND brand = 'Lexus';

  -- SUV-uri și Crossovere

  -- RX L (PRIMUL - versiuni cu 3 rânduri: RX 350L și RX 450hL)
  UPDATE SUA_Cars_Cleaned SET model = 'RX L'
  WHERE (model LIKE 'RX 350L%' OR model LIKE 'RX 450hL%')
  AND brand = 'Lexus';
  -- RX Hybrid (PRIMUL față de RX general - 350h, 400h, 450h, 500h; exclude 450hL deja procesat)
  UPDATE SUA_Cars_Cleaned SET model = 'RX Hybrid'
  WHERE model LIKE 'RX%'
  AND (model LIKE '%350h%' OR model LIKE '%400h%' OR model LIKE '%450h%' OR model LIKE '%500h%')
  AND brand = 'Lexus';
  -- RX (restul - 300, 330, 350)
  UPDATE SUA_Cars_Cleaned SET model = 'RX' WHERE model LIKE 'RX%'
  AND model NOT LIKE '%Hybrid%' AND model != 'RX L'
  AND brand = 'Lexus';
  -- NX Hybrid/PHEV (PRIMUL față de NX general - 300h, 350h, 450h+)
  UPDATE SUA_Cars_Cleaned SET model = 'NX Hybrid/PHEV'
  WHERE model LIKE 'NX%'
  AND (model LIKE '%300h%' OR model LIKE '%350h%' OR model LIKE '%450h%')
  AND brand = 'Lexus';
  -- NX (restul - 200t, 250, 300, 350)
  UPDATE SUA_Cars_Cleaned SET model = 'NX' WHERE model LIKE 'NX%'
  AND model NOT LIKE '%Hybrid%' AND model NOT LIKE '%300h%'
  AND model NOT LIKE '%350h%' AND model NOT LIKE '%450h%'
  AND brand = 'Lexus';
  -- UX Hybrid / UX 250h (PRIMUL față de UX general)
  UPDATE SUA_Cars_Cleaned SET model = 'UX Hybrid'
  WHERE model LIKE '%UX 250h%' AND brand = 'Lexus';
  -- UX (restul - UX 200)
  UPDATE SUA_Cars_Cleaned SET model = 'UX' WHERE model LIKE 'UX%'
  AND model NOT LIKE '%250h%' AND model NOT LIKE '%Hybrid%'
  AND brand = 'Lexus';
  UPDATE SUA_Cars_Cleaned SET model = 'GX' WHERE model LIKE 'GX%' AND brand = 'Lexus';
  UPDATE SUA_Cars_Cleaned SET model = 'LX' WHERE model LIKE 'LX%' AND brand = 'Lexus';

  -- Modele Hibride dedicate și Legacy

  UPDATE SUA_Cars_Cleaned SET model = 'CT Hybrid' WHERE model LIKE 'CT 200h%' AND brand = 'Lexus';
  UPDATE SUA_Cars_Cleaned SET model = 'HS Hybrid' WHERE model LIKE 'HS 250h%' AND brand = 'Lexus';
  UPDATE SUA_Cars_Cleaned SET model = 'SC' WHERE model LIKE 'SC%' AND brand = 'Lexus';

SELECT DISTINCT model, COUNT(*) as nr
  FROM SUA_Cars_Cleaned
  WHERE brand = 'Lincoln'
  GROUP BY model
  ORDER BY model ASC;

  -- SUV-uri și Crossovere Moderne

  -- Navigator L (PRIMUL - ampatament lung)
  UPDATE SUA_Cars_Cleaned SET model = 'Navigator L'
  WHERE model LIKE '%Navigator L%' AND brand = 'Lincoln';
  -- Navigator (restul)
  UPDATE SUA_Cars_Cleaned SET model = 'Navigator' WHERE model LIKE 'Navigator%'
  AND model NOT LIKE '%Navigator L%' AND brand = 'Lincoln';

  -- Aviator Grand Touring (PRIMUL - versiune Plug-In Hybrid)
  UPDATE SUA_Cars_Cleaned SET model = 'Aviator Grand Touring'
  WHERE model LIKE 'Aviator%' AND model LIKE '%Grand Touring%' AND brand = 'Lincoln';
  -- Aviator (restul)
  UPDATE SUA_Cars_Cleaned SET model = 'Aviator' WHERE model LIKE 'Aviator%'
  AND model NOT LIKE '%Grand Touring%' AND brand = 'Lincoln';

  -- Corsair Grand Touring (PRIMUL - versiune Plug-In Hybrid)
  UPDATE SUA_Cars_Cleaned SET model = 'Corsair Grand Touring'
  WHERE model LIKE 'Corsair%' AND model LIKE '%Grand Touring%' AND brand = 'Lincoln';
  -- Corsair (restul)
  UPDATE SUA_Cars_Cleaned SET model = 'Corsair' WHERE model LIKE 'Corsair%'
  AND model NOT LIKE '%Grand Touring%' AND brand = 'Lincoln';

  UPDATE SUA_Cars_Cleaned SET model = 'Nautilus' WHERE model LIKE 'Nautilus%' AND brand = 'Lincoln';

  -- Seria MK

  -- MKZ Hybrid (PRIMUL față de MKZ general)
  UPDATE SUA_Cars_Cleaned SET model = 'MKZ Hybrid'
  WHERE model LIKE 'MKZ%' AND model LIKE '%Hybrid%' AND brand = 'Lincoln';
  -- MKZ (restul)
  UPDATE SUA_Cars_Cleaned SET model = 'MKZ' WHERE model LIKE 'MKZ%'
  AND model NOT LIKE '%Hybrid%' AND brand = 'Lincoln';

  UPDATE SUA_Cars_Cleaned SET model = 'MKC' WHERE model LIKE 'MKC%' AND brand = 'Lincoln';
  UPDATE SUA_Cars_Cleaned SET model = 'MKS' WHERE model LIKE 'MKS%' AND brand = 'Lincoln';
  UPDATE SUA_Cars_Cleaned SET model = 'MKT' WHERE model LIKE 'MKT%' AND brand = 'Lincoln';
  UPDATE SUA_Cars_Cleaned SET model = 'MKX' WHERE model LIKE 'MKX%' AND brand = 'Lincoln';

  -- Seria clasică "Mark" (de la cel mai specific la cel mai general)

  -- Mark VIII (PRIMUL - altfel LIKE '%Mark VII%' prinde și Mark VIII)
  UPDATE SUA_Cars_Cleaned SET model = 'Mark VIII'
  WHERE model LIKE '%Mark VIII%' AND brand = 'Lincoln';
  -- Mark VII (NOT LIKE '%Mark VIII%' - altfel prinde și Mark VIII)
  UPDATE SUA_Cars_Cleaned SET model = 'Mark VII'
  WHERE model LIKE '%Mark VII%' AND model NOT LIKE '%Mark VIII%' AND brand = 'Lincoln';
  -- Mark VI (NOT LIKE '%Mark VII%' AND NOT LIKE '%Mark VIII%')
  UPDATE SUA_Cars_Cleaned SET model = 'Mark VI'
  WHERE model LIKE '%Mark VI%'
  AND model NOT LIKE '%Mark VII%' AND model NOT LIKE '%Mark VIII%' AND brand = 'Lincoln';
  -- Mark V (NOT LIKE '%Mark VI%' ... - prinde și Continental Mark V)
  UPDATE SUA_Cars_Cleaned SET model = 'Mark V'
  WHERE model LIKE '%Mark V%'
  AND model NOT LIKE '%Mark VI%' AND model NOT LIKE '%Mark VII%' AND model NOT LIKE '%Mark VIII%'
  AND brand = 'Lincoln';
  -- Mark IV (safe - 'IV' nu se confundă cu 'V...'; prinde și Continental Mark IV)
  UPDATE SUA_Cars_Cleaned SET model = 'Mark IV'
  WHERE model LIKE '%Mark IV%' AND brand = 'Lincoln';
  -- Mark III (PRIMUL față de Mark II - altfel LIKE '%Mark II%' prinde și Mark III)
  UPDATE SUA_Cars_Cleaned SET model = 'Mark III'
  WHERE model LIKE '%Mark III%' AND brand = 'Lincoln';
  -- Mark II (NOT LIKE '%Mark III%')
  UPDATE SUA_Cars_Cleaned SET model = 'Mark II'
  WHERE model LIKE '%Mark II%' AND model NOT LIKE '%Mark III%' AND brand = 'Lincoln';
  -- Mark LT (pickup truck)
  UPDATE SUA_Cars_Cleaned SET model = 'Mark LT' WHERE model LIKE 'Mark LT%' AND brand = 'Lincoln';

  -- Sedane și modele legendare

  -- Continental (exclude înregistrările de tip Mark, ex: Continental Mark IV/V)
  UPDATE SUA_Cars_Cleaned SET model = 'Continental' WHERE model LIKE 'Continental%'
  AND model NOT LIKE '%Mark%' AND brand = 'Lincoln';
  UPDATE SUA_Cars_Cleaned SET model = 'Town Car' WHERE model LIKE 'Town Car%' AND brand = 'Lincoln';
  UPDATE SUA_Cars_Cleaned SET model = 'LS' WHERE model LIKE 'LS%' AND brand = 'Lincoln';
  UPDATE SUA_Cars_Cleaned SET model = 'Zephyr' WHERE model LIKE 'Zephyr%' AND brand = 'Lincoln';

  -- Modele istorice

  UPDATE SUA_Cars_Cleaned SET model = 'Blackwood' WHERE model LIKE 'Blackwood%' AND brand = 'Lincoln';
  UPDATE SUA_Cars_Cleaned SET model = 'Capri' WHERE model LIKE 'Capri%' AND brand = 'Lincoln';
  UPDATE SUA_Cars_Cleaned SET model = 'Cosmopolitan' WHERE model LIKE 'Cosmopolitan%' AND brand = 'Lincoln';
  UPDATE SUA_Cars_Cleaned SET model = 'Versailles' WHERE model LIKE 'Versailles%' AND brand = 'Lincoln';

SELECT DISTINCT model, COUNT(*) as nr
  FROM SUA_Cars_Cleaned
  WHERE brand = 'Mazda'
  GROUP BY model
  ORDER BY model ASC;

  -- Familia CX (SUV-uri și Crossovere)

  -- CX-90 (PRIMUL față de CX-9 - 'CX-9%' prinde și CX-90)
  UPDATE SUA_Cars_Cleaned SET model = 'CX-90' WHERE model LIKE 'CX-90%' AND brand = 'Mazda';
  -- CX-9 (restul)
  UPDATE SUA_Cars_Cleaned SET model = 'CX-9' WHERE model LIKE 'CX-9%'
  AND model NOT LIKE 'CX-90%' AND brand = 'Mazda';
  -- CX-50 (PRIMUL față de CX-5 - 'CX-5%' prinde și CX-50)
  UPDATE SUA_Cars_Cleaned SET model = 'CX-50' WHERE model LIKE 'CX-50%' AND brand = 'Mazda';
  -- CX-5 (restul)
  UPDATE SUA_Cars_Cleaned SET model = 'CX-5' WHERE model LIKE 'CX-5%'
  AND model NOT LIKE 'CX-50%' AND brand = 'Mazda';
  -- CX-30 (PRIMUL față de CX-3 - 'CX-3%' prinde și CX-30)
  UPDATE SUA_Cars_Cleaned SET model = 'CX-30' WHERE model LIKE 'CX-30%' AND brand = 'Mazda';
  UPDATE SUA_Cars_Cleaned SET model = 'CX-7' WHERE model LIKE 'CX-7%' AND brand = 'Mazda';
  -- CX-3 (restul)
  UPDATE SUA_Cars_Cleaned SET model = 'CX-3' WHERE model LIKE 'CX-3%'
  AND model NOT LIKE 'CX-30%' AND brand = 'Mazda';

  -- MazdaSpeed (PRIMELE - înaintea modelelor standard; versiuni de înaltă performanță)

  UPDATE SUA_Cars_Cleaned SET model = 'MazdaSpeed Miata' WHERE model LIKE 'MazdaSpeed Miata%' AND brand = 'Mazda';
  UPDATE SUA_Cars_Cleaned SET model = 'MazdaSpeed3' WHERE model LIKE 'MazdaSpeed3%' AND brand = 'Mazda';
  UPDATE SUA_Cars_Cleaned SET model = 'MazdaSpeed6' WHERE model LIKE 'MazdaSpeed6%' AND brand = 'Mazda';

  -- Familia Mazda "Number" (Sedane și Hatchback-uri)

  UPDATE SUA_Cars_Cleaned SET model = 'Mazda2' WHERE model LIKE 'Mazda2%' AND brand = 'Mazda';
  UPDATE SUA_Cars_Cleaned SET model = 'Mazda3' WHERE model LIKE 'Mazda3%' AND brand = 'Mazda';
  UPDATE SUA_Cars_Cleaned SET model = 'Mazda5' WHERE model LIKE 'Mazda5%' AND brand = 'Mazda';
  UPDATE SUA_Cars_Cleaned SET model = 'Mazda6' WHERE model LIKE 'Mazda6%' AND brand = 'Mazda';

  -- Sport și Rotary

  -- MX-5 Miata (NOT LIKE '%MazdaSpeed%' - '%Miata%' ar prinde și MazdaSpeed Miata)
  UPDATE SUA_Cars_Cleaned SET model = 'MX-5 Miata'
  WHERE (model LIKE 'MX-5%' OR model LIKE '%Miata%')
  AND model NOT LIKE '%MazdaSpeed%' AND brand = 'Mazda';
  UPDATE SUA_Cars_Cleaned SET model = 'RX-7' WHERE model LIKE 'RX-7%' AND brand = 'Mazda';
  UPDATE SUA_Cars_Cleaned SET model = 'RX-8' WHERE model LIKE 'RX-8%' AND brand = 'Mazda';

  -- Modele Legacy / Clasice

  -- MX-30 (PRIMUL față de MX-3 - 'MX-3%' prinde și MX-30)
  UPDATE SUA_Cars_Cleaned SET model = 'MX-30' WHERE model LIKE 'MX-30%' AND brand = 'Mazda';
  -- MX-3 (NOT LIKE 'MX-30%')
  UPDATE SUA_Cars_Cleaned SET model = 'MX-3' WHERE model LIKE 'MX-3%'
  AND model NOT LIKE 'MX-30%' AND brand = 'Mazda';
  UPDATE SUA_Cars_Cleaned SET model = 'B2000' WHERE model LIKE 'B2000%' AND brand = 'Mazda';
  UPDATE SUA_Cars_Cleaned SET model = 'B2200' WHERE model LIKE 'B2200%' AND brand = 'Mazda';
  UPDATE SUA_Cars_Cleaned SET model = 'B2300' WHERE model LIKE 'B2300%' AND brand = 'Mazda';
  UPDATE SUA_Cars_Cleaned SET model = 'B3000' WHERE model LIKE 'B3000%' AND brand = 'Mazda';
  UPDATE SUA_Cars_Cleaned SET model = 'B4000' WHERE model LIKE 'B4000%' AND brand = 'Mazda';
  UPDATE SUA_Cars_Cleaned SET model = '626' WHERE model LIKE '626%' AND brand = 'Mazda';
  UPDATE SUA_Cars_Cleaned SET model = '929' WHERE model LIKE '929%' AND brand = 'Mazda';
  UPDATE SUA_Cars_Cleaned SET model = 'Millenia' WHERE model LIKE 'Millenia%' AND brand = 'Mazda';
  -- Protege5 (PRIMUL față de Protege - 'Protege%' prinde și Protege5)
  UPDATE SUA_Cars_Cleaned SET model = 'Protege5' WHERE model LIKE 'Protege5%' AND brand = 'Mazda';
  -- Protege (restul)
  UPDATE SUA_Cars_Cleaned SET model = 'Protege' WHERE model LIKE 'Protege%'
  AND model NOT LIKE 'Protege5%' AND brand = 'Mazda';
  UPDATE SUA_Cars_Cleaned SET model = 'Tribute' WHERE model LIKE 'Tribute%' AND brand = 'Mazda';
  UPDATE SUA_Cars_Cleaned SET model = 'MPV' WHERE model LIKE 'MPV%' AND brand = 'Mazda';

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
