/* Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)? */

SELECT 
	b.a_year, 
	b.food, 
	avg_year_price,
	b.avg_year_price - LAG(b.avg_year_price) OVER (PARTITION BY b.food ORDER BY b.a_year) AS price_difference,
	ROUND((b.avg_year_price - LAG(b.avg_year_price) OVER (PARTITION BY b.food ORDER BY b.a_year)) / LAG(b.avg_year_price) OVER (PARTITION BY b.food ORDER BY b.a_year) * 100, 2) AS procent_difference
FROM (
	SELECT 
		a_year, 
		food, 
		avg_year_price
	FROM t_vladislava_tonarova_project_sql_primary_final tvt 
	GROUP BY food, 
			a_year 
	) b
ORDER BY 
    b.food,
    b.a_year;