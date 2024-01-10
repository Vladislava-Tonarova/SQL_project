/* Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)? */

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
) 
SELECT
   p.a_year,
    p.foodstuff,
    p.avg_year_price,
    p.procent_difference AS price_procent_difference,
    w.industry,
    w.avg_year_wage,
    w.procent_difference AS wage_procent_difference,
    (p.procent_difference - w.procent_difference) AS difference_proc
FROM
    Prices p
JOIN
    Wages w ON p.a_year = w.a_year
WHERE
    (p.procent_difference - w.procent_difference) > 10
ORDER BY
	p.a_year,    
	p.foodstuff;