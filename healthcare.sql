create  database HealthCare;
use HealthCare;

SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'local_infile';

CREATE TABLE health_care (
    AppointmentID BIGINT,
    Gender VARCHAR(10),
    Age INT,
    Neighbourhood VARCHAR(100),
    Scholarship TINYINT,
    Hipertension TINYINT,
    Diabetes TINYINT,
    Alcoholism TINYINT,
    Handcap TINYINT,
    SMS_received TINYINT,
    No_show VARCHAR(10),
    
    Schedule_Date DATE,
    Schedule_Time TIME,
    Schedule_DayName VARCHAR(10),
    Schedule_Month VARCHAR(10),
    Schedule_Hour INT,
    
    App_Date DATE,
    App_DayName VARCHAR(10),
    App_Month VARCHAR(10),
    App_Weekday INT,
    App_Hour INT,
    
    Is_Weekend TINYINT,
    Age_Group VARCHAR(20),
    Medical_Problems VARCHAR(100)
);

LOAD DATA LOCAL INFILE '/Users/piyushdata/Documents/project/hospital/hospital_cleaned.csv'
INTO TABLE health_care
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


select * from health_care;


-- 1 neighbourhood distinct 

SELECT DISTINCT Neighbourhood FROM health_care;

-- 2 MIN , MEDIA , AVG 

SELECT MIN(Age), MAX(Age), AVG(Age) from health_care;

-- 3 who missed apppomient 

SELECT * 
FROM health_care
where No_show = 'yes';


-- 4 senior patient 

SELECT 
AppointmentID,Gender,Age,Medical_Problems
FROM Health_Care
where age >= 60;

-- 5 count of senior citinzen 

select count(*) 
from health_care
where age >= 60;

-- 6 avg age of neighbourhood 

select Neighbourhood,round( AVG(Age),0)
FROM health_care
group by  Neighbourhood;


-- no_show rate 

select 
   count(CASE WHEN No_show = "yes" THEN 1 END ) * 100.0 / COUNT(*) AS N0_show_rate
FROM health_care;

-- sms not received. 

select SMS_received,
count(*) as total,
sum(CASE WHEN No_show = "yes" THEN 1 END ) * 100.0 / COUNT(*) AS N0_show_count
FROM health_care
group by SMS_received;

-- appoiment by week day 

select App_DayName, COUNT(*)
FROM health_care
group by App_DayName;

ALTER TABLE health_care
MODIFY COLUMN App_Hour TIME;

SET SQL_SAFE_UPDATES = 0;

UPDATE health_care
SET App_Hour = SEC_TO_TIME(App_Hour * 3600);


select App_Hour, COUNT(*)
FROM health_care
group by App_Hour
order by  COUNT(*) DESC;

-- WATING DAYS
SELECT AppointmentID,
DATEDIFF(App_Date,Schedule_Date) AS waiting_days
FROM health_care;

-- weekend vs week day

SELECT Is_Weekend, count(*)
from health_care
group by Is_Weekend;

SELECT 
    App_Hour,
    COUNT(*) AS total,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS rank_hour
FROM health_care
GROUP BY App_Hour;

-- most common medical probelm 

select Medical_Problems,
     count(*) as total_case
from  health_care
GROUP by Medical_Problems
order by total_case DESC;

select distinct Medical_Problems
from health_care;

SELECT Medical_Problems,
       COUNT(*) AS total_case
FROM health_care
WHERE TRIM(Medical_Problems) <> ''
GROUP BY Medical_Problems
ORDER BY total_case DESC;

SELECT Medical_Problems,
       ROUND(
           SUM(CASE WHEN No_show='Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
           2
       ) AS no_show_rate
FROM health_care
WHERE TRIM(Medical_Problems) <> ''
GROUP BY Medical_Problems
ORDER BY no_show_rate DESC;



SHOW VARIABLES LIKE 'secure_file_priv';

SELECT * FROM health_Care;
