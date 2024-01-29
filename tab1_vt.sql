-- discord name Vlaďka T. vladka_02515



CREATE OR REPLACE TABLE t_Vladislava_tonarova_project_SQL_primary_final
SELECT 	
	pri.price_year AS a_year, 
	industry, 
	avg_year_wage, 
	food, 
	avg_year_price, 
	pri.price_unit
FROM (
	SELECT 
		cp.payroll_year,  
		cib.name AS industry,
		ROUND(SUM(value * 3)) AS avg_year_wage
	FROM czechia_payroll cp 
		JOIN czechia_payroll_industry_branch cib ON cp.industry_branch_code = cib.code  
	WHERE value_type_code = 5958 AND calculation_code = 200 
	GROUP BY cib.name, 
			cp.payroll_year
	) pay
JOIN (
	SELECT 
		category_code, 
		name AS food, 
		cpc.price_unit,
		YEAR(date_from) AS price_year,
		ROUND(AVG(value), 2) AS avg_year_price
	FROM czechia_price cp 
		JOIN czechia_price_category cpc ON cp.category_code = cpc.code
	GROUP BY category_code, 
			 YEAR(date_from)
	) pri 
	ON pay.payroll_year = pri.price_year 
;
