--- 1. 1957046 rows in the name table 
SELECT *
FROM names 

--- this gives us a number
SELECT COUNt (*)
FROM names 

--- 2. 351653025 registered people
SELECT SUM (num_registered)
FROM names

-- gives alias/ creates column name
SELECT SUM(num_registered) AS total_registered
FROM names;


---3. Linda has the most appearances 
SELECT name, year, max(num_registered)
FROM names 
GROUP BY name, year
ORDER BY max(num_registered) DESC

__this gives us just Linda
SELECT MAX(num_registered)
FROM names

SELECT *
FROM names
WHERE num_registered= 99689

---using subquery 
SELECT name
FROM names
WHERE num_registered = (SELECT MAX(num_registered) FROM names);

---4. years range between 1880 and 2018 
SELECT MAX(year), MIN(year)
FROM names

---5. highest num_registered is in 1957 
--- 4200022 is highest num_registered 
SELECT year, SUM(num_registered) AS total_registered
FROM names
GROUP BY (year)
ORDER BY (total_registered) DESC
LIMIT 1 ---limit functions as head in R and Python


---6. there are 98400 distinct names 
SELECT COUNT(DISTINCT name)
FROM names

--- 7. there are more males than females 
SELECT gender, sum (num_registered)
FROM names 
GROUP BY (gender)

--- can refer to columns by number
SELECT gender, SUM(num_registered) AS registered
FROM names
GROUP BY 1
ORDER BY 2 DESC;

---8. most popular names are James and Mary
SELECT name, gender, SUM(num_registered)
FROM names 
GROUP BY (name, gender)
ORDER BY sum (num_registered) DESC


--- 9. most popular male and female names between 2000 and 2009 are Jacob and Emily
SELECT name, gender,SUM (num_registered)
FROM names
WHERE year BETWEEN 2000 and 2009
GROUP BY name, gender 
ORDER BY SUM (num_registered) DESC
LIMIT 50


--- 10. year 2008 had the most variety in names 
SELECT year, COUNT (DISTINCT name)
FROM names 
GROUP BY year
ORDER BY (count) DESC

--- 11. The most popular female name starting with X is Ximena 
SELECT *
FROM names 
WHERE name LIKE 'X%'
ORDER BY (num_registered) DESC


SELECT SUM (num_registered), name
FROM names 
WHERE gender= 'F'AND name LIKE 'X%' ---LIKE is case sensitive
GROUP BY name
ORDER BY SUM (num_registered) DESC

SELECT SUM (num_registered), name
FROM names 
WHERE gender= 'F'AND name ILIKE 'X%' --ILIKE is not case sensitive
GROUP BY name
ORDER BY SUM (num_registered) DESC

--- 12. 537 names start with Q
SELECT COUNT (DISTINCT name)
FROM names 
WHERE name LIKE 'Q%'


--- 46 names starting with Q but not Qu 
SELECT COUNT (DISTINCT name)
FROM names 
WHERE name LIKE 'Q%'
AND name NOT LIKE 'Qu%'

SELECT name, COUNT (DISTINCT name)
FROM names 
WHERE name LIKE 'Q%' and name NOT LIKE '_u%'
GROUP BY name
ORDER BY COUNT (DISTINCT name) DESC


--- %u means 0 or more character 
--- _u means exactly one characher


--- we have Qiuana that has u somewhere 
SELECT name, COUNT (DISTINCT name)
FROM names 
WHERE name LIKE 'Q%' and name NOT LIKE '_u%' and name LIKE '%u%'
GROUP BY name

--- starts with u but there is no u in the word
SELECT name, COUNT (DISTINCT name)
FROM names 
WHERE name LIKE 'Q%' and name NOT LIKE '%u%'
GROUP BY name


---13. Steven is more popular spelling than Stephen
SELECT name, year, sum (num_registered)
FROM names 
WHERE gender= 'M' and name like 'Ste%'
GROUP BY name, year, num_registered
ORDER BY num_registered DESC


SELECT name, sum (num_registered)
FROM names
WHERE name= 'Stephen' OR name='Steven'
GROUP BY name

---need to learn how to write a code like this 
select case
           when sum(t.stephen) > sum(t.steven) then 'Stephen is more popular'
           when sum(t.stephen) < sum(t.steven) then 'Steven is more popular'
           else 'They are equally popular' end as popularity
from (select case when name = 'Stephen' then num_registered else 0 end as stephen,
             case when name = 'Steven' then num_registered else 0 end  as steven
      from names) as t;
	  
---14. 10773 names are unisex
SELECT DISTINCT(names1.name), names1.gender AS gender1, names2.gender AS gender2
FROM names AS names1
INNER JOIN names AS names2 
ON names1.name = names2.name
WHERE names1.gender <> names2.gender AND names1.gender= 'F'


SELECT name, COUNT(DISTINCT gender)
FROM names
GROUP BY name
HAVING COUNT (DISTINCT gender)=2

---10 percent of names are unisex
SELECT 10773.0/98400.0


SELECT COUNT(unisex_counts)*100.00/COUNT(*)
FROM (SELECT CASE 
	  WHEN (COUNT( DISTINCT gender)>1) THEN 1 
	  END AS unisex_counts
	FROM names
	GROUP BY name) AS unisex


WITH male AS 
	(SELECT DISTINCT(name) AS distinct_name
	 FROM names WHERE gender = 'M'),
	 female AS 
	 (SELECT DISTINCT(name) AS distinct_name
	 FROM names WHERE gender = 'F')
SELECT (COUNT(DISTINCT(f.distinct_name))::float / (SELECT COUNT(DISTINCT(name)) FROM names)) * 100
FROM female f
JOIN male m ON f.distinct_name = m.distinct_name;


--- 15. 132 names have appeared every year since 1880
SELECT name, COUNT(name)
FROM names 
GROUP BY name
HAVING COUNT (name)>=2018-1880 AND COUNT (DISTINCT gender)=1
ORDER BY name

---can remove 'distinct' becase group by removes duplicates 
---136 names
SELECT name, COUNT(name)
FROM names
GROUP BY name
HAVING COUNT(name) = 139
ORDER BY name

SELECT *
FROM names
WHERE name='Abe'
ORDER BY year

---921 names
SELECT name, COUNT(DISTINCT year)
FROM names
GROUP BY name
HAVING COUNT(DISTINCT year) = 139;


---using distinct for 2 columns
SELECT DISTINCT name, year
FROM names
ORDER BY name, year

--concat two columns 
SELECT COUNT(distinct name || year) 
from names

---COUNT(name) counts all non-null values
---COUNT(*) counts all inputs/ null and non-null


--- filtering to name Diana used ad male name 
SELECT *
FROM names
WHERE name = 'Diana' AND gender = 'M';


--- 16. 21123 names have only appeared in one year
SELECT name, COUNT (DISTINCT year)
FROM names
GROUP BY name
HAVING COUNT (DISTINCT year) = 1

---using subquery 
select count(distinct name_per_year.name)
from (select name, count(year) as num_years, count(distinct year) as dist_years
	  from names 
	  group by name) as name_per_year
where name_per_year.num_years > 1
AND name_per_year.dist_years =1 


--- 17. 661 names only appeared in the 1950s
SELECT COUNT (DISTINCT name) 
FROM names
WHERE year between 1950 and 1959
  and name not in
      (SELECT DISTINCT name 
	   FROM names 
	   WHERE year < 1950 OR year > 1959);


SELECT COUNT(distinct_name)
FROM (
	SELECT 
		name AS distinct_name,
		MIN(year) AS min_year,
		MAX(year) AS max_year
	FROM names
	GROUP BY 1) AS start_year
WHERE min_year BETWEEN 1950 AND 1959
AND max_year BETWEEN 1950 AND 1959

---18. 11270  names made their first appearance in the 2010s
SELECT name, MIN(year)
FROM names
GROUP BY name
HAVING MIN(year) >= 2010;


SELECT COUNT(DISTINCT name) AS name_cnt 
	FROM names
	WHERE name IN
		(SELECT name
		FROM names
		GROUP BY name
		HAVING min(year) > 2009)
		


---using = for a single value in the subquerry 
SELECT name
FROM names
WHERE num_registered = (SELECT MAX(num_registered) FROM names)

  
  
---19. 98400 names have not been used in the longest 

SELECT name, MAX(year) AS most_rec_year
	FROM names
	GROUP BY name
	ORDER BY most_rec_year
	LIMIT 10;
	
	
SELECT name, 2018 - MAX(year) AS years_since_named
FROM names
GROUP BY name
ORDER BY years_since_named DESC;
	
	
SELECT name, max_year AS last_year
FROM (
	SELECT name, MAX(year) AS max_year
	FROM names
	GROUP by 1 ) as start_year
	ORDER BY 2


