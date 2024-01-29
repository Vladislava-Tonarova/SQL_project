/* Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem? */


-- tabulka ukazujicí změnu HDP v průběhu let
SELECT 
	b_year, 
	country, 
	ROUND(GDP) AS GDP,
	ROUND(GDP - lag(GDP) OVER (PARTITION BY country ORDER BY b_year)) AS GDP_difference,
	ROUND((GDP - lag(GDP) OVER (PARTITION BY country ORDER BY b_year)) / lag(GDP) OVER (PARTITION BY country ORDER BY b_year) * 100 , 2) AS procent_difference
FROM t_vladislava_tonarova_project_sql_secondary_final tvtpssf 
WHERE country = 'Czech Republic';


WITH Prices AS (
    SELECT a_year,
		AVG(avg_year_price) AS avg_price,
		AVG(avg_year_price) - lag(AVG(avg_year_price)) OVER (ORDER BY a_year) AS price_difference,
		round((AVG(avg_year_price) - lag(AVG(avg_year_price)) OVER (ORDER BY a_year)) / (lag(AVG(avg_year_price)) OVER (ORDER BY a_year)) * 100, 2) AS procent_price_difference
	FROM t_vladislava_tonarova_project_sql_primary_final tvtpspf
	GROUP BY a_year 
	) ,
Wages AS (
    SELECT a_year,
		AVG(avg_year_wage) AS avg_wage,
		AVG(avg_year_wage) - lag(AVG(avg_year_wage)) OVER (ORDER BY a_year) AS wage_difference,
		round((AVG(avg_year_wage) - lag(AVG(avg_year_wage)) OVER (ORDER BY a_year)) / (lag(AVG(avg_year_wage)) OVER (ORDER BY a_year)) * 100, 2) AS procent_wage_difference
	FROM t_vladislava_tonarova_project_sql_primary_final tvtpspf 
	GROUP BY a_year 
	) ,
GDP AS (
	SELECT b_year , country , GDP ,
		round(GDP - lag(GDP) OVER (PARTITION BY country ORDER BY b_year)) AS GDP_difference,
		round((GDP - lag(GDP) OVER (PARTITION BY country ORDER BY b_year)) / lag(GDP) OVER (PARTITION BY country ORDER BY b_year) * 100 , 2) AS procent_gdp_difference
	FROM t_vladislava_tonarova_project_sql_secondary_final tvtpssf 
	WHERE country = 'Czech Republic'
	)
SELECT
    p.a_year,
    p.procent_price_difference,
    w.procent_wage_difference,
    g.procent_gdp_difference
FROM Prices p
	JOIN Wages w ON p.a_year = w.a_year
	JOIN GDP g ON p.a_year = g.b_year
ORDER BY
    p.a_year;