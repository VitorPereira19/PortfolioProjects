SELECT *
FROM Portfolio..World

--Update Columns

EXEC sp_rename 'World.European Union and United Kingdom', 'Europe', 'Column';

EXEC sp_rename 'World.United States', 'USA', 'Column';

ALTER TABLE World
DROP COLUMN Code

UPDATE World
SET China = NULL WHERE China = 0

UPDATE World
SET USA = NULL WHERE USA = 0

UPDATE World
SET Europe = NULL WHERE Europe = 0

ALTER TABLE World
ADD EuropeGross varchar(225)

UPDATE World
SET EuropeGross = FORMAT(Europe, 'c', 'en-gb')

ALTER TABLE World
ADD USAGross varchar(225)

UPDATE World
SET USAGross = FORMAT(USA, 'c', 'en-us')

ALTER TABLE World
ADD ChinaGross varchar(225)

UPDATE World
SET ChinaGross = FORMAT(China, 'c', 'zh-cn')

ALTER TABLE World
ADD WorldGross varchar(225)

UPDATE World
SET WorldGross = FORMAT(World, 'c', 'en-us')

--Cybersecurity

SELECT Entity, Year, WorldGross, USAGross, EuropeGross, ChinaGross
, (USA/World)*100 AS USAPercent
, (Europe/World)*100 AS EuropePercent
, (China/World)*100 AS ChinaPercent
FROM Portfolio..World
WHERE Entity like '%Cybersecurity%'
and World is not null
and europe is not null
and china is not null
and USA is not null

--Data Management

SELECT Entity, Year, WorldGross, USAGross, EuropeGross, ChinaGross
, (USA/World)*100 AS USAPercent
, (Europe/World)*100 AS EuropePercent
, (China/World)*100 AS ChinaPercent
FROM Portfolio..World
WHERE Entity like '%Data Management%'
and World is not null
and Europe is not null
and China is not null
and USA is not null

--Legal Technoloy

SELECT Entity, Year, WorldGross, USAGross, EuropeGross, ChinaGross
, (USA/World)*100 AS USAPercent
, (Europe/World)*100 AS EuropePercent
, (China/World)*100 AS ChinaPercent
FROM Portfolio..World
WHERE Entity like '%Legal Technology%'
or Entity like '%Financial Technology%' 
or Entity like '%Data Management%'
or Entity like '%Cybersecurity%'
and World is not null
and Europe is not null
and China is not null
and USA is not null
ORDER BY Entity, Year

--Financial Technology

SELECT Entity, Year, WorldGross, USAGross, EuropeGross, ChinaGross
, (USA/World)*100 AS USAPercent
, (Europe/World)*100 AS EuropePercent
, (China/World)*100 AS ChinaPercent
FROM Portfolio..World
WHERE Entity like '%Financial Technology%'
and World is not null
and Europe is not null
and China is not null
and USA is not null

--Total Gross/ Percent of Gross

 SELECT Entity, FORMAT(SUM(World), 'c', 'en-us') AS TotalWorld
 , FORMAT(SUM(USA), 'c', 'en-us') AS TotalUSA
 , FORMAT(SUM(Europe), 'c', 'en-gb') AS TotalEurope 
 , FORMAT(SUM(China), 'c', 'zh-cn') AS TotalChina
 , SUM(USA)/SUM(World)*100 AS TotalPercentUSA
 , SUM(Europe)/SUM(World)*100 AS TotalPercentEurope
 , SUM(China)/SUM(World)*100 AS TotalPercentChina
 FROM Portfolio..World
WHERE Entity is not null
or World is not null
or USA is not null
or Europe is not null
or China is not null
 GROUP BY Entity

 --Total Gross Per Year/ Percent of Gross Per Year

 SELECT Year, FORMAT(SUM(World), 'c', 'en-us') AS TotalWorld
 , FORMAT(SUM(USA), 'c', 'en-us') AS TotalUSA
 , FORMAT(SUM(Europe), 'c', 'en-gb') AS TotalEurope
 , FORMAT(SUM(China), 'c', 'zh-cn') AS TotalChina
FROM Portfolio..World
WHERE Entity is not null
or World is not null
or USA is not null
or Europe is not null
or China is not null
GROUP BY Year


