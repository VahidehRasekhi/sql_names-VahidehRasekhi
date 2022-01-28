--- 1. 1957046 rows in the name table 
SELECT *
FROM names 

--- 2. 351653025 registered people
SELECT sum(num_registered)
FROM names

---3. Zzyzx has the most appearances 
SELECT max(name)
FROM names 

---4. years range between 1880 and 2018 
SELECT max(year), min(year)
FROM names

---5. highest num_registered is in 1957 
--- 4200022 is highest num_registered 
--- 
SELECT year, sum(num_registered)
FROM names
GROUP BY (year)
ORDER BY  sum(num_registered) DESC

---6 there are 98400 distinct names 
SELECT COUNT (DISTINCT name)
FROM names

--- 7 there are 1156527 females and 800519 males 
SELECT gender, COUNT (*)
FROM names 
GROUP BY (gender)

---8 most common names
SELECT name, COUNT(num_registered)
FROM names 
GROUP BY (name)
ORDER BY (count) DESC


--- 9 most popular male and female names between 2000 and 2009
SELECT name, year, COUNT(num_registered)
FROM names
WHERE year BETWEEN 2000 and 2009
GROUP BY 1,2
--name, year
ORDER BY (count) DESC


--- 10 year 2008 had the most variety in names 
SELECT year, COUNT (DISTINCT name)
FROM names 
GROUP BY year
ORDER BY (count) DESC

--- 11 The most popular female name starting with X is Ximena 
SELECT *
FROM names 
WHERE name LIKE 'X%'
ORDER BY (num_registered) DESC

--- 12 537 names start with Q
SELECT COUNT (DISTINCT name)
FROM names 
WHERE name LIKE 'Q_%'

--- 45 names starting with Q but not Qu 
SELECT COUNT (DISTINCT name)
FROM names 
WHERE name LIKE 'Q%' and name NOT LIKE '%u%'







