-- celková tabulka meziročních změn v platech v jednotlivých obdobích

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
    b.a_year;

-- vypise pouze roky a odvetvi, kdy doslo k poklesu
  
SELECT *
FROM (
	SELECT b.a_year , b.industry ,
		b.avg_year_wage - LAG(b.avg_year_wage) OVER (PARTITION BY b.industry ORDER BY b.a_year) AS wage_difference,
		round( (b.avg_year_wage - LAG(b.avg_year_wage) OVER (PARTITION BY b.industry ORDER BY b.a_year)) / LAG(b.avg_year_wage) OVER (PARTITION BY b.industry ORDER BY b.a_year) * 100 , 2) AS procent_difference,
		IF((b.avg_year_wage - LAG(b.avg_year_wage) OVER (PARTITION BY b.industry ORDER BY b.a_year)) < 0, 1, 0) AS decrease
	FROM (
		SELECT a_year , industry , avg_year_wage
		FROM t_vladislava_tonarova_project_sql_primary_final tvtpspf 
		GROUP BY industry,  a_year 
		) b
	ORDER BY 
    	b.industry,
	    b.a_year
	) sel
WHERE sel.decrease = 1;




