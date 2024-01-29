/* Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd? */


SELECT 	
	a_year, 
	round(AVG(avg_year_wage)) AS avg_year_wage, 
	food, 
	avg_year_price, 
	price_unit,
	round(AVG(avg_year_wage) / avg_year_price) AS no_kg_l
FROM t_vladislava_tonarova_project_sql_primary_final tvt
WHERE (food LIKE 'Mléko%' OR food LIKE 'Chléb%') AND (a_year = '2006' OR a_year = '2018')
GROUP BY a_year, food ;



-- variabilnější volba minimálního a maximálniho roku:

SELECT 
	a_year, 
	round(AVG(avg_year_wage)) AS avg_year_wage, 
	food, 
	avg_year_price, 
	price_unit,
	round(AVG(avg_year_wage) / avg_year_price) AS no_kg_l
FROM t_vladislava_tonarova_project_sql_primary_final tvt
WHERE (food LIKE 'Mléko%' OR food LIKE 'Chléb%') AND a_year IN (SELECT MIN(a_year) FROM t_vladislava_tonarova_project_sql_primary_final UNION SELECT MAX(a_year) FROM t_vladislava_tonarova_project_sql_primary_final)
GROUP BY a_year, food ;