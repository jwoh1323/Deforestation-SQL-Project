-- create forest_area table
CREATE TABLE "forest_area"(
    "country_code" VARCHAR,
    "country_name" VARCHAR,
    "year" SMALLINT,
    "forest_area_sqkm" DECIMAL
);
-- create land_area table
CREATE TABLE "land_area"(
    "country_code" VARCHAR,
    "country_name" VARCHAR,
    "year" SMALLINT,
    "total_area_sq_mi" DECIMAL
);
-- create regions table
CREATE TABLE "regions"(
    "country_name" VARCHAR,
    "country_code" VARCHAR,
    "region" VARCHAR,
    "income_group" VARCHAR
);



-- Create a View
CREATE VIEW forestation
AS
SELECT f.country_code
	,f.country_name
	,f.year
	,f.forest_area_sqkm
	,l.total_area_sq_mi * 2.59 AS total_area_sqkm
	,r.region
	,r.income_group
	,(f.forest_area_sqkm / (l.total_area_sq_mi * 2.59)) * 100 AS perc_forest_area
FROM forest_area f
INNER JOIN land_area l ON f.country_code = l.country_code
	AND f.year = l.year
INNER JOIN regions r ON r.country_code = f.country_code
