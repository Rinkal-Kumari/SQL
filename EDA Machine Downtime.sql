/*EXPLORATORY DATA ANALYSIS*/
SELECT * FROM `machine downtime`;

-- CREATING NEW TABLE LIKE MACHINE DOWNTIME--
CREATE TABLE machine_downtime LIKE `machine downtime`;
INSERT INTO machine_downtime 
SELECT * FROM `machine downtime`;

select * FROM machine_downtime;
 -- SEE THE DATASET--

SELECT * FROM machine_downtime
order by Date;                  -- STANDARDIZE THE DATA

SELECT COUNT(*) FROM machine_downtime; -- TOTAL NO. OF ROWS


select count(*) FROM machine_downtime ;

-- Dealing with null values
DELETE FROM machine_downtime
WHERE Date IS NULL
  AND Machine_ID IS NULL
  AND Assembly_Line_No IS NULL
  AND `Coolant_Pressure(bar)` IS NULL
  AND `Air_System_Pressure(bar)` IS NULL
  AND Coolant_Temperature IS NULL
  AND `Hydraulic_Oil_Temperature(Â°C)` IS NULL
  AND `Spindle_Bearing_Temperature(Â°C)` IS NULL
  AND `Spindle_Vibration(Âµm)` IS NULL
  AND `Tool_Vibration(Âµm)` IS NULL
  AND `Spindle_Speed(RPM)` IS NULL
  AND `Voltage(volts)` IS NULL
  AND `Torque(Nm)` IS NULL
  AND `Cutting(kN)` IS NULL
  AND Downtime IS NULL;


-- Checking Data types of each columns--
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'machine_downtime';

ALTER TABLE machine_downtime RENAME COLUMN `Hydraulic_Pressure(bar)` to Hydraulic_Pressure;
ALTER TABLE machine_downtime 
RENAME COLUMN `Coolant_Pressure(bar)` TO Coolant_Pressure ,
RENAME COLUMN `Air_System_Pressure(bar)` TO Air_System_Pressure,
RENAME column `Date` TO Date ,
RENAME column `Hydraulic_Oil_Temperature(Â°C)` TO  Hydraulic_Oil_Temperature,
RENAME column `Spindle_Bearing_Temperature(Â°C)` TO  Spindle_Bearing_Tem,
RENAME column `Spindle_Vibration(Âµm)` TO Spindle_Vibration ,
RENAME column `Tool_Vibration(Âµm)` TO Tool_Vibration ,
RENAME column `Spindle_Speed(RPM)` TO Spindle_Speed ,
RENAME column `Voltage(volts)` TO volts ,
RENAME column `Torque(Nm)` TO Torque ,
RENAME column `Cutting(kN)` TO Cutting 
;


/** Exploratory Data Analysis**/
select * from machine_downtime;

select * from machine_downtime order by Machine_ID asc limit 5; -- Top 5 Rows

select * from machine_downtime order by Machine_ID desc limit 5; -- Bottom 5 Rows

select * from machine_downtime order by rand() limit 5; -- Random 5 Rows

-- LETS SEE MAXIMUM Machine_Failure AND No_Machine_Failure 
SELECT count(Machine_ID),
    MAX(Hydraulic_Pressure) AS Hydraulic_Pressure,
    MAX(Coolant_Pressure) AS Coolant_Pressure,
    MAX(Air_System_Pressure) AS Air_System_Pressure,
    MAX(Coolant_Temperature) AS Coolant_Temperature,
    MAX(Hydraulic_Oil_Temperature) AS Hydraulic_Oil_Temperature,
    MAX(Spindle_Bearing_Tem) AS Spindle_Bearing_Tem,
    MAX(Spindle_Vibration) AS Spindle_Vibration,
    MAX(Tool_Vibration) AS Tool_Vibration,
    MAX(Spindle_Speed) AS Spindle_Speed,
    Downtime
FROM machine_downtime
GROUP BY Downtime;  

SELECT 
    round(avg(Hydraulic_Pressure),2) AS Hydraulic_Pressure,
    round(avg(Coolant_Pressure),2) AS Coolant_Pressure,
    round(avg(Air_System_Pressure),2) AS Air_System_Pressure,
    round(avg(Coolant_Temperature),2) AS Coolant_Temperature,
    round(avg(Hydraulic_Oil_Temperature),2) AS Hydraulic_Oil_Temperature,
    round(avg(Spindle_Bearing_Tem),2) AS Spindle_Bearing_Tem,
    round(avg(Spindle_Vibration),2) AS Spindle_Vibration,
    round(avg(Tool_Vibration),2) AS Tool_Vibration,
    round(avg(Spindle_Speed),2) AS Spindle_Speed,
    Downtime
FROM machine_downtime
GROUP BY Downtime;  

SELECT 
    MIN(Hydraulic_Pressure) AS Hydraulic_Pressure,
    MIN(Coolant_Pressure) AS Coolant_Pressure,
    MIN(Air_System_Pressure) AS Air_System_Pressure,
    MIN(Coolant_Temperature) AS Coolant_Temperature,
    MIN(Hydraulic_Oil_Temperature) AS Hydraulic_Oil_Temperature,
    MIN(Spindle_Bearing_Tem) AS Spindle_Bearing_Tem,
    MIN(Spindle_Vibration) AS Spindle_Vibration,
    MIN(Tool_Vibration) AS Tool_Vibration,
    MIN(Spindle_Speed) AS Spindle_Speed,
    Downtime
FROM machine_downtime
GROUP BY Downtime;


SELECT * , ROUND((freq/SUM(freq) OVER())*100,2) AS percentage 
FROM (
  SELECT Machine_ID, COUNT(Machine_ID) AS freq 
  FROM machine_downtime
  GROUP BY Machine_ID
  ORDER BY freq DESC
) t;


select * , round((freq/sum(freq) over())* 100,2) as percentage
from(
	select Assembly_Line_No, count(Assembly_Line_No) as freq
    from machine_downtime
    group by Assembly_Line_No
    order by freq desc
)t;

select * , round((freq/sum(freq) over())* 100,2) as percentage
from(
	select Downtime, count(Downtime) as freq
    from machine_downtime
    group by Downtime
    order by freq desc
)t;                               -- From result we can notice that around 51% of Machine_Failure

 

SELECT count(*)from machine_downtime;

/******************************************** Measures of Central Tendency ****************************************/
WITH Combined AS (
	SELECT Hydraulic_Pressure AS value, 'Hydraulic_Pressure' AS column_name
    FROM machine_downtime
    UNION ALL
    SELECT Coolant_Pressure AS value, 'Coolant_Pressure' AS column_name
    FROM machine_downtime
    UNION ALL
    SELECT Air_System_Pressure AS value, 'Air_System_Pressure' AS column_name
    from machine_downtime
    UNION ALL
    SELECT Coolant_Temperature AS value, 'Coolant_Temperature' AS column_name
    FROM machine_downtime
    UNION ALL 
    SELECT Hydraulic_Oil_Temperature AS value, 'Hydraulic_Oil_Temperature' AS column_name
    FROM machine_downtime
    UNION ALL    
    SELECT Spindle_Bearing_Tem AS value, 'Spindle_Bearing_Tem' AS column_name
    FROM machine_downtime
    UNION ALL     
    SELECT Spindle_Vibration AS value, 'Spindle_Vibration' AS column_name
    FROM machine_downtime
    UNION ALL
    SELECT Tool_Vibration AS value, 'Tool_Vibration' AS column_name
    FROM machine_downtime
),
Frequency AS (
    SELECT value, column_name, COUNT(*) AS frequency
    FROM Combined
    GROUP BY value, column_name
),
Mean as(
	select column_name, avg(cast(value as float)) as mean 
    from Combined
    group by column_name),

MaxFrequency AS (
    SELECT column_name, MAX(frequency) AS max_frequency
    FROM Frequency
    GROUP BY column_name
),
Median AS (
    SELECT column_name, 
           CAST(value AS FLOAT) AS value,
           ROW_NUMBER() OVER (PARTITION BY column_name ORDER BY CAST(value AS FLOAT)) AS row_num,
           COUNT(*) OVER (PARTITION BY column_name) AS total_rows
    FROM Combined
),
MedianCalc AS (
    SELECT column_name, 
           AVG(value) AS median
    FROM Median
    WHERE (row_num = FLOOR((total_rows + 1) / 2) AND total_rows % 2 = 1)
       OR (row_num IN (FLOOR((total_rows + 1) / 2), FLOOR((total_rows + 2) / 2)) AND total_rows % 2 = 0)
    GROUP BY column_name
)

SELECT f.column_name, f.value AS mode , m.mean, mc.median, f.frequency
FROM Frequency f
JOIN MaxFrequency mf ON f.column_name = mf.column_name AND f.frequency = mf.max_frequency
join mean m on f.column_name = m.column_name
JOIN MedianCalc mc ON f.column_name = mc.column_name
;    


/******************************************** Measure Of Dispersion ****************************************/
select
    MAX(Hydraulic_Pressure)- min(Hydraulic_Pressure) AS Hydraulic_Pressure_Range,
    ROUND(avg(Hydraulic_Pressure),2) as Mean,
    ROUND(stddev_samp(Hydraulic_Pressure), 2) STD_DEV,
    variance(Hydraulic_Pressure) as Variance ,
    ROUND(SUM(Hydraulic_Pressure), 2) AS Total
from machine_downtime;                                    

select 
	count(Air_System_Pressure), 
    MAX(Air_System_Pressure)-min(Air_System_Pressure) as Air_System_Pressure_Range,
    ROUND(avg(Air_System_Pressure),2) Mean,
    ROUND(stddev_samp(Air_System_Pressure), 2) as STD_DEV,
    ROUND(SUM(Air_System_Pressure), 2) AS Total,
    round(variance(Air_System_Pressure ),2) as Variance 
from machine_downtime;                                    

select 
	MAX(Coolant_Temperature)-min(Coolant_Temperature) as Coolant_Temperature_Range,
    ROUND(avg(Coolant_Temperature),2) as mean,
    ROUND(stddev_samp(Coolant_Temperature), 2) as STD_DEV,
    ROUND(SUM(Coolant_Temperature), 2) as Total,
    round(variance(Coolant_Temperature),2) as Variance 
from machine_downtime;                                                                        

select 
	MAX(Hydraulic_Oil_Temperature)-min(Hydraulic_Oil_Temperature) as Hydraulic_Oil_Temperature_Range ,
    ROUND(avg(Hydraulic_Oil_Temperature),2) as Mean,
    ROUND(stddev_samp(Hydraulic_Oil_Temperature), 2) as STD_DEV,
    ROUND(SUM(Hydraulic_Oil_Temperature), 2) AS Total,
    round(variance(Hydraulic_Oil_Temperature),2) as Variance 
from machine_downtime;                                    

select 
	MAX(Spindle_Bearing_Tem)-min(Spindle_Bearing_Tem) as RANGE_,
    ROUND(avg(Spindle_Bearing_Tem),2) AS Mean,
    ROUND(stddev_samp(Spindle_Bearing_Tem), 2) AS STD_DEV,
    ROUND(SUM(Spindle_Bearing_Tem), 2) AS Total,
    round(variance(Spindle_Bearing_Tem),2) as Variance 
from machine_downtime;                                     

select 
	MAX(Spindle_Vibration)-min(Spindle_Vibration) as Range_,
    ROUND(avg(Spindle_Vibration),2) as Mean,
    ROUND(stddev_samp(Spindle_Vibration), 2) AS STD_DEV,
    ROUND(SUM(Spindle_Vibration), 2) AS Total,
    round(variance(Spindle_Vibration),2) as Variance 
from machine_downtime;                                    

select 
	MAX(Tool_Vibration)-min(Tool_Vibration) as Range_,
    ROUND(avg(Tool_Vibration),2) as Mean,
    ROUND(stddev_samp(Tool_Vibration), 2) as STD_DEV,
    ROUND(SUM(Tool_Vibration), 2) as Total,
    round(variance(Tool_Vibration),2) as Variance 
from machine_downtime;                                     

select 
	MAX(Spindle_Speed)-min(Spindle_Speed) as Range_,
    ROUND(avg(Spindle_Speed),2) as Mean,
    ROUND(stddev_samp(Spindle_Speed), 2) as STD_DEV,
    ROUND(SUM(Spindle_Speed), 2) as Total,
    round(variance(Spindle_Speed),2) as Variance 
from machine_downtime;                                    

select 
	MAX(volts)-min(volts) as Range_,
    ROUND(avg(volts),2) as Mean,
    ROUND(stddev_samp(volts), 2) as STD_DEV,
    ROUND(SUM(volts), 2) as Total,
    round(variance(volts),2) as Variance 
from machine_downtime;                                    

select 
	MAX(Torque)-min(Torque) as Range_,
    ROUND(avg(Torque),2) as Mean,
    ROUND(stddev_samp(Torque), 2) as STD_DEV,
    ROUND(SUM(Torque), 2) as Total,
    Round(variance(Torque),2) as Variance 
from machine_downtime;                                   

select 
	MAX(Cutting)-min(Cutting) as Range_,
    ROUND(avg(Cutting),2) as Mean,
    ROUND(stddev_samp(Cutting), 2) as STD_DEV,
    ROUND(SUM(Cutting), 2) as Total,
    round(variance(Cutting),2) as Variance 
from machine_downtime;                                  


/*********************************************  Skewness *********************************************/
SELECT
(
SUM(POWER(Hydraulic_Pressure- (SELECT AVG(Hydraulic_Pressure) FROM machine_downtime), 3)) /
(COUNT(*) * POWER((SELECT STDDEV(Hydraulic_Pressure) FROM machine_downtime), 3))
) AS skewness
FROM machine_downtime;

SELECT
(
SUM(POWER(Air_System_Pressure- (SELECT AVG(Air_System_Pressure) FROM machine_downtime), 3)) /
(COUNT(*) * POWER((SELECT STDDEV(Air_System_Pressure) FROM machine_downtime), 3))
) AS skewness
FROM machine_downtime;

SELECT
(
SUM(POWER(Coolant_Temperature- (SELECT AVG(Coolant_Temperature) FROM machine_downtime), 3)) /
(COUNT(*) * POWER((SELECT STDDEV(Coolant_Temperature) FROM machine_downtime), 3))
) AS skewness
FROM machine_downtime;

SELECT
(
SUM(POWER(Hydraulic_Oil_Temperature- (SELECT AVG(Hydraulic_Oil_Temperature) FROM machine_downtime), 3)) /
(COUNT(*) * POWER((SELECT STDDEV(Hydraulic_Oil_Temperature) FROM machine_downtime), 3))
) AS skewness
FROM machine_downtime;

SELECT
(
SUM(POWER(Spindle_Bearing_Tem- (SELECT AVG(Spindle_Bearing_Tem) FROM machine_downtime), 3)) /
(COUNT(*) * POWER((SELECT STDDEV(Spindle_Bearing_Tem) FROM machine_downtime), 3))
) AS skewness
FROM machine_downtime;

SELECT
(
SUM(POWER(Spindle_Vibration- (SELECT AVG(Spindle_Vibration) FROM machine_downtime), 3)) /
(COUNT(*) * POWER((SELECT STDDEV(Spindle_Vibration) FROM machine_downtime), 3))
) AS skewness
FROM machine_downtime;

SELECT
(
SUM(POWER(Tool_Vibration- (SELECT AVG(Tool_Vibration) FROM machine_downtime), 3)) /
(COUNT(*) * POWER((SELECT STDDEV(Tool_Vibration) FROM machine_downtime), 3))
) AS skewness
FROM machine_downtime;

SELECT
(
SUM(POWER(Spindle_Speed- (SELECT AVG(Spindle_Speed) FROM machine_downtime), 3)) /
(COUNT(*) * POWER((SELECT STDDEV(Spindle_Speed) FROM machine_downtime), 3))
) AS skewness
FROM machine_downtime;

SELECT
(
SUM(POWER(Torque- (SELECT AVG(Torque) FROM machine_downtime), 3)) /
(COUNT(*) * POWER((SELECT STDDEV(Torque) FROM machine_downtime), 3))
) AS skewness
FROM machine_downtime;

SELECT
(
SUM(POWER(volts- (SELECT AVG(volts) FROM machine_downtime), 3)) /
(COUNT(*) * POWER((SELECT STDDEV(volts) FROM machine_downtime), 3))
) AS skewness
FROM machine_downtime;

SELECT
(
SUM(POWER(Cutting- (SELECT AVG(Cutting) FROM machine_downtime), 3)) /
(COUNT(*) * POWER((SELECT STDDEV(Cutting) FROM machine_downtime), 3))
) AS skewness
FROM machine_downtime;


/*********************************************  Kurtosis *********************************************/
WITH Combined AS (
    SELECT Hydraulic_Pressure AS value, 'Hydraulic_Pressure' AS column_name
    FROM machine_downtime
    UNION ALL
    SELECT Coolant_Pressure AS value, 'Coolant_Pressure' AS column_name
    FROM machine_downtime
    UNION ALL
    SELECT Air_System_Pressure AS value, 'Air_System_Pressure' AS column_name
    FROM machine_downtime
    UNION ALL
    SELECT Coolant_Temperature AS value, 'Coolant_Temperature' AS column_name
    FROM machine_downtime
    UNION ALL 
    SELECT Hydraulic_Oil_Temperature AS value, 'Hydraulic_Oil_Temperature' AS column_name
    FROM machine_downtime
    UNION ALL    
    SELECT Spindle_Bearing_Tem AS value, 'Spindle_Bearing_Tem' AS column_name
    FROM machine_downtime
    UNION ALL     
    SELECT Spindle_Vibration AS value, 'Spindle_Vibration' AS column_name
    FROM machine_downtime
    UNION ALL
    SELECT Tool_Vibration AS value, 'Tool_Vibration' AS column_name
    FROM machine_downtime
),
Stats AS (
    SELECT
        column_name,
        AVG(value) AS mean,
        STDDEV(value) AS stddev,
        COUNT(*) AS n
    FROM Combined
    GROUP BY column_name
),
Kurtosis AS (
    SELECT
        c.column_name,
        SUM(POWER(c.value - s.mean, 4)) / (s.n * POWER(s.stddev, 4)) - 3 AS kurtosis
    FROM Combined c
    JOIN Stats s ON c.column_name = s.column_name
    GROUP BY c.column_name, s.mean, s.stddev, s.n
)
SELECT * FROM Kurtosis;
    
    







    