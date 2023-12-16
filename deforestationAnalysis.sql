-- 1. GLOBAL SITUATION 

/* a. What was the total forest area (in sq km) of the world in 1990? 
Please keep in mind that you can use the country record denoted as “World" in the region table. */

SELECT SUM(forest_area_sqkm)
FROM forestation
WHERE country_name = 'World'
	AND year = 1990


/* b. What was the total forest area (in sq km) of the world in 2016? 
Please keep in mind that you can use the country record in the table is denoted as “World.” */

SELECT SUM(forest_area_sqkm)
FROM forestation
WHERE country_name = 'World'
	AND year = 2016

/* c. What was the change (in sq km) in the forest area of the world from 1990 to 2016? */

SELECT A.forest_area_sqkm - B.forest_area_sqkm AS diff
FROM forestation A
INNER JOIN forestation B ON A.country_code = B.country_code
WHERE A.country_name = 'World'
	AND A.year = 1990
	AND B.year = 2016

/* d. What was the percent change in forest area of the world between 1990 and 2016? */

SELECT (A.forest_area_sqkm - B.forest_area_sqkm) / A.forest_area_sqkm * 100 AS perc_diff
FROM forestation A
INNER JOIN forestation B ON A.country_code = B.country_code
WHERE A.country_name = 'World'
	AND A.year = 1990
	AND B.year = 2016

/* e. If you compare the amount of forest area lost between 1990 and 2016, to which country's total area in 2016 is it closest to? */

WITH V1
AS (
	SELECT SUM(forest_area_sqkm) AS forest_area_sqkm_1990
	FROM forestation
	WHERE country_name = 'World'
		AND year = 1990
	)
	,V2
AS (
	SELECT SUM(forest_area_sqkm) AS forest_area_sqkm_2016
	FROM forestation
	WHERE country_name = 'World'
		AND year = 2016
	)
	,V3
AS (
	SELECT (forest_area_sqkm_1990 - forest_area_sqkm_2016) AS diff
	FROM V1,V2
	)
SELECT country_name
	,forest_area_sqkm
	,ABS(forest_area_sqkm - (SELECT * FROM V3)) AS diff
FROM forestation
ORDER BY 3 ASC LIMIT 1

-- 2. REGIONAL OUTLOOK

/* a. What was the percent forest of the entire world in 2016?
 Which region had the HIGHEST percent forest in 2016, and which had the LOWEST, to 2 decimal places? */

WITH V1
AS (
	SELECT region
		,year
		,ROUND(CAST(SUM(forest_area_sqkm) / SUM(total_area_sqkm) * 100 AS NUMERIC), 2) AS perc
	FROM forestation
	GROUP BY 1,2
	HAVING year >= 1990
		AND year <= 2016
	)
SELECT *
FROM V1
WHERE region = 'World'
	AND year = 2016
WITH V1 AS (
		SELECT region
			,year
			,ROUND(CAST(SUM(forest_area_sqkm) / SUM(total_area_sqkm) * 100 AS NUMERIC), 2) AS perc
		FROM forestation
		GROUP BY 1,2
		HAVING year >= 1990
			AND year <= 2016
		)

SELECT *
FROM V1
WHERE year = 2016
ORDER BY perc DESC LIMIT 1
WITH V1 AS (
		SELECT region
			,year
			,ROUND(CAST(SUM(forest_area_sqkm) / SUM(total_area_sqkm) * 100 AS NUMERIC), 2) AS perc
		FROM forestation
		GROUP BY 1,2
		HAVING year >= 1990
			AND year <= 2016
		)

SELECT *
FROM V1
WHERE year = 2016
ORDER BY perc ASC LIMIT 1


/* b. What was the percent forest of the entire world in 1990? 
Which region had the HIGHEST percent forest in 1990, and which had the LOWEST, to 2 decimal places? */

WITH V1
AS (
	SELECT region
		,year
		,ROUND(CAST(SUM(forest_area_sqkm) / SUM(total_area_sqkm) * 100 AS NUMERIC), 2) AS perc
	FROM forestation
	GROUP BY 1,2
	HAVING year >= 1990
		AND year <= 2016
	)
SELECT *
FROM V1
WHERE region = 'World'
	AND year = 1990
WITH V1 AS (
		SELECT region
			,year
			,ROUND(CAST(SUM(forest_area_sqkm) / SUM(total_area_sqkm) * 100 AS NUMERIC), 2) AS perc
		FROM forestation
		GROUP BY 1,2
		HAVING year >= 1990
			AND year <= 2016
		)

SELECT *
FROM V1
WHERE year = 1990
ORDER BY perc DESC LIMIT 1
WITH V1 AS (
		SELECT region
			,year
			,ROUND(CAST(SUM(forest_area_sqkm) / SUM(total_area_sqkm) * 100 AS NUMERIC), 2) AS perc
		FROM forestation
		GROUP BY 1,2
		HAVING year >= 1990
			AND year <= 2016
		)

SELECT *
FROM V1
WHERE year = 1990
ORDER BY perc ASC 
LIMIT 1


/* c. Based on the table you created, which regions of the world DECREASED in forest area from 1990 to 2016? */

WITH V1
AS (
	SELECT region
		,year
		,ROUND(CAST(SUM(forest_area_sqkm) / SUM(total_area_sqkm) * 100 AS NUMERIC), 2) AS perc
	FROM forestation
	GROUP BY 1,2
	HAVING year >= 1990
		AND year <= 2016
	)
	,V2
AS (
	SELECT *
	FROM V1
	WHERE year = 1990
	)
	,V3
AS (
	SELECT *
	FROM V1
	WHERE year = 2016
	)
SELECT V2.region
	,V2.perc AS perc_1990
	,V3.perc AS perc_2016
	,(V3.perc - V2.perc) AS diff
FROM V2
INNER JOIN V3 ON V2.region = V3.region
ORDER BY 4 ASC



-- 3. COUNTRY-LEVEL DETAIL

/* a. Which 5 countries saw the largest amount decrease in forest area from 1990 to 2016? 
What was the difference in forest area for each? */

WITH V1
AS (
	SELECT country_name
		,year
		,region
		,SUM(forest_area_sqkm) AS forest_area_sqkm_1990
	FROM forestation
	GROUP BY 1,2,3
	HAVING year = 1990
	)
	,V2
AS (
	SELECT country_name
		,year
		,region
		,SUM(forest_area_sqkm) AS forest_area_sqkm_2016
	FROM forestation
	GROUP BY 1,2,3
	HAVING year = 2016
	)
SELECT V1.country_name
	,V1.region
	,V1.forest_area_sqkm_1990
	,V2.forest_area_sqkm_2016
	,(V1.forest_area_sqkm_1990 - V2.forest_area_sqkm_2016) AS diff
	,(V1.forest_area_sqkm_1990 - V2.forest_area_sqkm_2016) / V1.forest_area_sqkm_1990 * 100 AS perc
FROM V1
INNER JOIN V2 ON V1.country_name = V2.country_name
WHERE V1.forest_area_sqkm_1990 IS NOT NULL
	AND V2.forest_area_sqkm_2016 IS NOT NULL
ORDER BY 5 DESC


/* b. Which 5 countries saw the largest percent decrease in forest area from 1990 to 2016? 
What was the percent change to 2 decimal places for each? */

WITH V1
AS (
	SELECT country_name
		,year
		,region
		,SUM(forest_area_sqkm) AS forest_area_sqkm_1990
	FROM forestation
	GROUP BY 1,2,3
	HAVING year = 1990
	)
	,V2
AS (
	SELECT country_name
		,year
		,region
		,SUM(forest_area_sqkm) AS forest_area_sqkm_2016
	FROM forestation
	GROUP BY 1,2,3
	HAVING year = 2016
	)
SELECT V1.country_name
	,V1.region
	,V1.forest_area_sqkm_1990
	,V2.forest_area_sqkm_2016
	,(V1.forest_area_sqkm_1990 - V2.forest_area_sqkm_2016) AS diff
	,ROUND(CAST((V1.forest_area_sqkm_1990 - V2.forest_area_sqkm_2016) / V1.forest_area_sqkm_1990 * 100 AS NUMERIC), 2) AS perc
FROM V1
INNER JOIN V2 ON V1.country_name = V2.country_name
WHERE V1.forest_area_sqkm_1990 IS NOT NULL
	AND V2.forest_area_sqkm_2016 IS NOT NULL
ORDER BY 6 DESC


/* c. If countries were grouped by percent forestation in quartiles, which group had the most countries in it in 2016? */

WITH V1
AS (
	SELECT country_name
		,CASE 
			WHEN perc_forest_area < 25
				THEN '0-25%'
			WHEN perc_forest_area >= 25
				AND perc_forest_area < 50
				THEN '25-50%'
			WHEN perc_forest_area >= 50
				AND perc_forest_area < 75
				THEN '50-75%'
			ELSE '75-100%'
			END AS percentiles
	FROM forestation
	WHERE year = 2016
	)
SELECT percentiles
	,COUNT(*)
FROM V1
GROUP BY 1
ORDER BY 2 DESC


/* d. List all of the countries that were in the 4th quartile (percent forest > 75%) in 2016. */

WITH V1
AS (
	SELECT country_name
		,region
		,perc_forest_area
		,CASE 
			WHEN perc_forest_area < 25
				THEN '0-25%'
			WHEN perc_forest_area >= 25
				AND perc_forest_area < 50
				THEN '25-50%'
			WHEN perc_forest_area >= 50
				AND perc_forest_area < 75
				THEN '50-75%'
			ELSE '75-100%'
			END AS percentiles
	FROM forestation
	WHERE year = 2016
		AND perc_forest_area IS NOT NULL
	)
SELECT *
FROM V1
WHERE percentiles = '75-100%'
ORDER BY 3 DESC

/* e. How many countries had a percent forestation higher than the United States in 2016?  */

WITH V1
AS (
	SELECT perc_forest_area
	FROM forestation
	WHERE year = 2016
		AND country_name = 'United States'
	)
SELECT COUNT(*)
FROM forestation
WHERE perc_forest_area > (SELECT * FROM V1)
