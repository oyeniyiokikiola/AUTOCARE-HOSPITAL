-- Total Discharges
SELECT COUNT(*) AS Total_Discharges 
FROM vw_AdmissionData
WHERE OUTCOME = 'DISCHARGE'

-- Average Daily Discharge Rate
-- Total discharges by total length of stay
SELECT
(SELECT COUNT(*) AS Total_Discharges 
FROM vw_AdmissionData
WHERE OUTCOME = 'DISCHARGE')/
(SELECT SUM(DURATION_OF_STAY) AS Total_length_of_stay
FROM vw_AdmissionData)

-- Casting
SELECT
CAST(
	CAST((SELECT COUNT(*) AS Total_Discharges 
	FROM vw_AdmissionData
	WHERE OUTCOME = 'DISCHARGE') AS FLOAT)/
	CAST((SELECT SUM(DURATION_OF_STAY) AS Total_length_of_stay
	FROM vw_AdmissionData) AS FLOAT)
AS DECIMAL(10,2) )*100 AS Avg_DailyDischargeRate

-- Without casting
SELECT
	ROUND(SUM(CASE WHEN OUTCOME = 'DISCHARGE' THEN 1.0 ELSE 0.0 END)/
	SUM(DURATION_OF_STAY),2) * 100 AS Avg_DailyDischargeRate
FROM vw_AdmissionData

-- Average Length of Stay
-- Total length of stay by total discharges
SELECT
	ROUND(SUM(DURATION_OF_STAY)/SUM(CASE WHEN OUTCOME = 'DISCHARGE' THEN 1.0 ELSE 0.0 END),0) AS Avg_length_of_stay
FROM vw_AdmissionData

-- Distribution of discharges by Age Group
-- Grouping: >16 Pediatric
-- 16<65 Adult
-- >= 65 Senior Citizen

SELECT CASE 
	WHEN AGE <16 THEN 'Pediatric'
	WHEN AGE <65 THEN 'Adult'
	WHEN AGE >= 65 THEN 'Senior Citizen'
	ELSE 'Unknown'
  END AS Age_Group, COUNT(*) AS Age_Distribution
FROM vw_AdmissionData
WHERE OUTCOME = 'DISCHARGE'
GROUP BY CASE 
	WHEN AGE <16 THEN 'Pediatric'
	WHEN AGE <65 THEN 'Adult'
	WHEN AGE >= 65 THEN 'Senior Citizen'
	ELSE 'Unknown'
	END 
ORDER BY 2 DESC

-- Distribution of disharges by Gender
SELECT GENDER, COUNT(*) AS Gender_Distribution
FROM vw_AdmissionData
WHERE OUTCOME = 'DISCHARGE'
GROUP BY GENDER
ORDER BY 2 DESC

-- Distribution of discharge by Day of the Week
SELECT DATEPART(WEEKDAY,D_O_D) AS Day_of_Week, COUNT(*) AS Day_Distribution
FROM vw_AdmissionData
WHERE OUTCOME = 'DISCHARGE'
GROUP BY DATEPART(WEEKDAY,D_O_D)
ORDER BY 2 DESC

-- Get Date Name
SELECT FORMAT(D_O_D,'ddd') AS Day_of_Week, COUNT(*) AS Day_Distribution
FROM vw_AdmissionData
WHERE OUTCOME = 'DISCHARGE' AND D_O_D IS NOT NULL
GROUP BY FORMAT(D_O_D,'ddd')
ORDER BY 2 DESC 

