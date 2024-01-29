/* Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)? */


WITH Prices AS (
    SELECT a_year,
		ROUND(AVG(avg_year_price)) AS avg_price,
		AVG(avg_year_price) - lag(AVG(avg_year_price)) OVER (ORDER BY a_year) AS price_difference,
		round((AVG(avg_year_price) - lag(AVG(avg_year_price)) OVER (ORDER BY a_year)) / (lag(AVG(avg_year_price)) OVER (ORDER BY a_year)) * 100, 2) AS procent_difference
	FROM t_vladislava_tonarova_project_sql_primary_final tvtpspf
GROUP BY a_year 
	) ,
Wages AS (
    SELECT a_year,
		ROUND(AVG(avg_year_wage)) AS avg_wage,
		AVG(avg_year_wage) - lag(AVG(avg_year_wage)) OVER (ORDER BY a_year) AS wage_difference,
		round((AVG(avg_year_wage) - lag(AVG(avg_year_wage)) OVER (ORDER BY a_year)) / (lag(AVG(avg_year_wage)) OVER (ORDER BY a_year)) * 100, 2) AS procent_difference
FROM t_vladislava_tonarova_project_sql_primary_final tvtpspf 
GROUP BY a_year 
	) 
SELECT
	p.a_year,
	p.avg_price,
    p.procent_difference AS price_procent_difference,
    w.avg_wage,
    w.procent_difference AS wage_procent_difference,
    (p.procent_difference - w.procent_difference) AS difference_proc
FROM
    Prices p
JOIN
    Wages w ON p.a_year = w.a_year
/*WHERE
    (p.procent_difference - w.procent_difference) > 10 */
ORDER BY 
	p.a_year 
	;