/* Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd? */


SELECT a_year, tvt.industry, avg_year_wage, food, avg_year_price, tvt.price_unit,
	round(avg_year_wage / avg_year_price) AS no_kg_l
FROM t_vladislava_tonarova_project_sql_primary_final tvt
JOIN (
    SELECT industry, MIN(a_year) AS min_year, MAX(a_year) AS max_year
    FROM t_vladislava_tonarova_project_sql_primary_final
    GROUP BY industry
	) minmax 
	ON tvt.industry = minmax.industry AND (tvt.a_year = minmax.min_year OR tvt.a_year = minmax.max_year)
WHERE food LIKE 'Mléko%' OR food LIKE 'Chléb%'
;


SELECT 	a_year, 
	round(AVG(avg_year_wage)) AS avg_year_wage, 
	food, 
	avg_year_price, 
	price_unit,
	round(AVG(avg_year_wage) / avg_year_price) AS no_kg_l
FROM t_vladislava_tonarova_project_sql_primary_final tvt
WHERE (food LIKE 'Mléko%' OR food LIKE 'Chléb%') AND (a_year = '2006' OR a_year = '2018')
GROUP BY a_year, food ;