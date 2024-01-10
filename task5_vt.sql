/* Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem? */


-- tabulka ukazujicí změnu HDP v průběhu let
SELECT b_year , country , GDP ,
	round( GDP - lag(GDP) OVER (PARTITION BY country ORDER BY b_year)) AS GDP_difference,
	round( (GDP - lag(GDP) OVER (PARTITION BY country ORDER BY b_year)) / lag(GDP) OVER (PARTITION BY country ORDER BY b_year) * 100 , 2) AS procent_difference
FROM t_vladislava_tonarova_project_sql_secondary_final tvtpssf 
WHERE country = 'Czech Republic';


-- tabulka ukazující ceny a jejich procentuální změnu a mzdy a jejich procentuální změnu v letech, kdy došlo k nárůstu HDP více než o pět procent
WITH Prices AS (
    SELECT b.a_year , b.foodstuff , avg_year_price,
		b.avg_year_price - LAG(b.avg_year_price) OVER (PARTITION BY b.foodstuff ORDER BY b.a_year) AS price_difference,
		round( (b.avg_year_price - LAG(b.avg_year_price) OVER (PARTITION BY b.foodstuff ORDER BY b.a_year)) / LAG(b.avg_year_price) OVER (PARTITION BY b.foodstuff ORDER BY b.a_year) * 100 , 2) AS procent_difference
	FROM (
		SELECT a_year , foodstuff , avg_year_price
		FROM t_vladislava_tonarova_project_sql_primary_final tvt 
		GROUP BY foodstuff,  a_year 
		) b
	ORDER BY 
    	b.foodstuff,
	    b.a_year
	) ,
Wages AS (
    SELECT b.a_year , b.industry , avg_year_wage,
		b.avg_year_wage - LAG(b.avg_year_wage) OVER (PARTITION BY b.industry ORDER BY b.a_year) AS wage_difference,
		round( (b.avg_year_wage - LAG(b.avg_year_wage) OVER (PARTITION BY b.industry ORDER BY b.a_year)) / LAG(b.avg_year_wage) OVER (PARTITION BY b.industry ORDER BY b.a_year) * 100 , 2) AS procent_difference
	FROM (
		SELECT a_year , industry , avg_year_wage
		FROM t_vladislava_tonarova_project_sql_primary_final tvtpspf 
		GROUP BY industry,  a_year 
	) b
	ORDER BY 
    	b.industry,
	    b.a_year
) ,
GDP AS (
	SELECT b_year , country , GDP ,
		round( GDP - lag(GDP) OVER (PARTITION BY country ORDER BY b_year)) AS GDP_difference,
		round( (GDP - lag(GDP) OVER (PARTITION BY country ORDER BY b_year)) / lag(GDP) OVER (PARTITION BY country ORDER BY b_year) * 100 , 2) AS procent_difference
	FROM t_vladislava_tonarova_project_sql_secondary_final tvtpssf 
	WHERE country = 'Czech Republic'
)
SELECT
    p.a_year,
    p.foodstuff,
    p.avg_year_price,
    p.procent_difference AS price_procent_difference,
    w.industry,
    w.avg_year_wage,
    w.procent_difference AS wage_procent_difference,
    g.GDP,
    g.GDP_difference,
    g.procent_difference AS gdp_procent_difference
FROM
    Prices p
JOIN
    Wages w ON p.a_year = w.a_year
JOIN GDP g ON p.a_year = g.b_year
 WHERE
  g.procent_difference > 5
ORDER BY
    p.a_year;
    
   
   
   
   -- tabulka ukazující ceny a jejich procentuální změnu a mzdy a jejich procentuální změnu v letech, kdy došlo k nárůstu HDP více než o pět procent a v roce následujícím
   
   WITH Prices AS (
    SELECT b.a_year , b.foodstuff , avg_year_price,
		b.avg_year_price - LAG(b.avg_year_price) OVER (PARTITION BY b.foodstuff ORDER BY b.a_year) AS price_difference,
		round( (b.avg_year_price - LAG(b.avg_year_price) OVER (PARTITION BY b.foodstuff ORDER BY b.a_year)) / LAG(b.avg_year_price) OVER (PARTITION BY b.foodstuff ORDER BY b.a_year) * 100 , 2) AS procent_difference
	FROM (
		SELECT a_year , foodstuff , avg_year_price
		FROM t_vladislava_tonarova_project_sql_primary_final tvt 
		GROUP BY foodstuff,  a_year 
		) b
	ORDER BY 
    	b.foodstuff,
	    b.a_year
	) ,
Wages AS (
    SELECT b.a_year , b.industry , avg_year_wage,
		b.avg_year_wage - LAG(b.avg_year_wage) OVER (PARTITION BY b.industry ORDER BY b.a_year) AS wage_difference,
		round( (b.avg_year_wage - LAG(b.avg_year_wage) OVER (PARTITION BY b.industry ORDER BY b.a_year)) / LAG(b.avg_year_wage) OVER (PARTITION BY b.industry ORDER BY b.a_year) * 100 , 2) AS procent_difference
	FROM (
		SELECT a_year , industry , avg_year_wage
		FROM t_vladislava_tonarova_project_sql_primary_final tvtpspf 
		GROUP BY industry,  a_year 
	) b
	ORDER BY 
    	b.industry,
	    b.a_year
) ,
GDP AS (
	SELECT b_year , country , GDP ,
		round( GDP - lag(GDP) OVER (PARTITION BY country ORDER BY b_year)) AS GDP_difference,
		round( (GDP - lag(GDP) OVER (PARTITION BY country ORDER BY b_year)) / lag(GDP) OVER (PARTITION BY country ORDER BY b_year) * 100 , 2) AS procent_difference
	FROM t_vladislava_tonarova_project_sql_secondary_final tvtpssf 
	WHERE country = 'Czech Republic'
)
SELECT
    p.a_year,
    p.foodstuff,
    p.avg_year_price,
    p.procent_difference AS price_procent_difference,
    w.industry,
    w.avg_year_wage,
    w.procent_difference AS wage_procent_difference,
    g.GDP,
    g.GDP_difference,
    g.procent_difference AS gdp_procent_difference
FROM
    Prices p
JOIN
    Wages w ON p.a_year = w.a_year
JOIN GDP g ON p.a_year = g.b_year
 WHERE
  p.a_year BETWEEN 2007 AND 2008 OR p.a_year BETWEEN  2015 AND 2018
 ORDER BY
    p.a_year;