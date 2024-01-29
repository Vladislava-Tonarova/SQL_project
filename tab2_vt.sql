CREATE OR REPLACE TABLE t_Vladislava_tonarova_project_SQL_secondary_final
SELECT year AS b_year, 
		c.country, 
		GDP
FROM countries c 
	JOIN economies e ON c.country = e.country
WHERE continent LIKE 'Europe' AND year BETWEEN '2006' AND '2018'
ORDER BY country, 
		YEAR;