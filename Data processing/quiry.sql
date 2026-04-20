select * from `workspace`.`default`.`viewership_bright_tv` limit 1000;

select * from `workspace`.`default`.`user_profile_bright_tv` limit 1000;

---checking if all colums that  I am going to quiry on viewership_bright_tv
select DISTINCT userID
from `workspace`.`default`.`viewership_bright_tv`;

select channel2
from `workspace`.`default`.`viewership_bright_tv`;

select DISTINCT RecordDate2
from `workspace`.`default`.`viewership_bright_tv`;



Select DISTINCT `Duration 2`
from `workspace`.`default`.`viewership_bright_tv`;

---checking all the columns that I am going to use on user_profile_Bright_TV
select COUNT(DISTINCT userID)
from `workspace`.`default`.`user_profile_bright_tv`;

select DISTINCT Gender
from `workspace`.`default`.`user_profile_bright_tv`;

select DISTINCT Race
from `workspace`.`default`.`user_profile_bright_tv`;

---there are 4Races mentioned and one is unknown

select DISTINCT Age
from `workspace`.`default`.`user_profile_bright_tv`;

select DISTINCT Province
from `workspace`.`default`.`user_profile_bright_tv`;

---There are 9 provinces mentions and the 10th one is unknown

---LEFT JOIN two datasets (Viewership and User Profile)
SELECT Viewers.UserID,
       Channel2,
       RecordDate2,
       `Duration 2`,
       Gender,
       Race,
       Age,
       Province
from `workspace`.`default`.viewership_Bright_tv AS Viewers
Left Join `workspace`.`default`.user_profile_bright_tv AS UP
ON Viewers.UserID=UP.UserID;

---changing UTC time to South African time
select *,
       from_utc_timestamp(TO_TIMESTAMP(viewers.RecordDATE2, 'yyyy/MM/dd HH:mm'), 'Africa/Johannesburg') AS sast_timestamp
from `workspace`.`default`.viewership_Bright_tv AS Viewers;

select Gender,
     COUNT(Viewers.UserID) AS Male_female_split
from `workspace`.`default`.viewership_Bright_tv AS Viewers
Left Join `workspace`.`default`.user_profile_bright_tv AS UP
ON Viewers.UserID=UP.UserID
GROUP BY Gender
ORDER BY Male_Female_split DESC;

---ChecKIng null IDs
select COUNT(*)
from `workspace`.`default`.viewership_Bright_tv AS Viewers
Left Join `workspace`.`default`.user_profile_bright_tv AS UP
ON Viewers.UserID=UP.UserID
WHERE (Viewers.UserID,Channel2,RecordDate2,`Duration 2`,Gender,Race,Age,Province) IS NULL;

---BIG QUIRY
---Joining two datasets(Viewweship and User Profile with Sa timestamp
select DISTINCT Viewers.UserID,
       Channel2,
       `Duration 2`,
       Gender,
       Race,
       Age,
       Province,
       from_utc_timestamp(Viewers.RecordDate2, 'Africa/Johannesburg') AS sast_timestamp,
       CASE
         WHEN `Duration 2` BETWEEN '05:00:00' AND '11:59:59' THEN 'Early_bird'
         WHEN `Duration 2` BETWEEN '12:00:00' AND '17:59:59' THEN 'Afternoon_viewers'
         WHEN `Duration 2` BETWEEN '18:00:00' AND '21:59:59' THEN 'Evening_viewers'
         ELSE 'Midnight_starring'
       END AS viewing_period,
       CASE 
         WHEN Age < 13 THEN 'kids'
         WHEN Age BETWEEN 13 AND 17 THEN 'Teen'
         WHEN Age BETWEEN 18 AND 24 THEN 'Young_adult'
         WHEN Age BETWEEN 25 AND 34 THEN 'Adult'
         WHEN Age BETWEEN 35 AND 54 THEN 'Middle_Aged'
         WHEN Age >= 55 THEN 'Senior'
         ELSE 'other'
       END AS Age_group,
       CASE 
         WHEN Race IN ('black', 'white', 'coloured', 'indian_asian') THEN Race
         WHEN Race = 'other' THEN 'Other'
         WHEN Race = 'None' OR Race IS NULL THEN 'Unknown'
         ELSE 'Other'
       END AS Race_classification,
       CASE
         WHEN DAYNAME(RecordDate2) IS NOT NULL THEN DAYNAME(RecordDate2)
         WHEN MONTHNAME(RecordDate2) IS NOT NULL THEN MONTHNAME(RecordDate2)
         ELSE 'Unknown'
       END AS Date,
       CASE
        WHEN MONTHNAME(RecordDate2) IS NOT NULL THEN MONTHNAME(RecordDate2)
         ELSE 'Unknown'
       END AS Month  
from `workspace`.`default`.viewership_Bright_tv AS Viewers
Left Join `workspace`.`default`.user_profile_bright_tv AS UP
ON Viewers.UserID=UP.UserID;
