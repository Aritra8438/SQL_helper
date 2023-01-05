 -- select the database 
USE olympics;

-- show the tables
SHOW tables; 

-- get the schema for the table
DESCRIBE city; 

-- selecting all columns for all entries from the table
SELECT * from city;

-- selecting a particular column for all the entries from the table
SELECT city_name FROM city;

-- selecting particular columns for all the entries from the table
SELECT city_name, id FROM city;

-- select statement without from clause works by creating a dummy table 
SELECT 46+23;
SELECT NOW();
SELECT LCASE("SQL");

-- where clause let us filter rows on some condition
SELECT * FROM  games WHERE games_year > 1992; 
SELECT * FROM games WHERE season = "winter";

-- between clause let us filter rows where column values is between lvalue and rvalue (inclusive)
SELECT * FROM games WHERE games_year BETWEEN 1988 AND 2000; 

-- in clause can merge multiple conditions joined by OR
SELECT * FROM games WHERE games_year = '2000' OR games_year ='1998';
SELECT * FROM games WHERE games_year IN ('2000','1998'); 
SELECT * FROM games WHERE games_year NOT IN ('2000','1998'); 

-- is null filters rows based on null column values
SELECT * FROM  medal WHERE medal_name IS NULL;
SELECT * FROM  medal WHERE medal_name IS NOT NULL;

-- wildcards
-- % can be replaced by any number(maybe 0) of character(s)
-- _ can be replaced by ONE character
SELECT * FROM games WHERE games_year LIKE '19%';
SELECT * FROM games WHERE games_year LIKE '_99_';
SELECT * FROM games WHERE games_year LIKE '_9%';

-- sorting - ORDER BY clause
SELECT * FROM games ORDER BY games_year; 
SELECT * FROM games ORDER BY games_year DESC; -- descending order

-- distinct keyword let us select distinct values from a group of columns
SELECT games_year from games ORDER BY games_year;
SELECT DISTINCT games_year from games ORDER BY games_year;  

-- group by clause groups column values based on aggregation function
SELECT games_year from games GROUP BY games_year; -- it will be treated like distinct as no aggregation function    
SELECT games_year, COUNT(games_year) from games GROUP BY games_year;
SELECT games_year, SUM(1)  from games GROUP BY games_year; -- will work like count
SELECT competitor_id, SUM(medal_id='1')  FROM competitor_event GROUP BY competitor_id; -- this will fetch the number of gold medals awarded to each competitor
SELECT competitor_id, COUNT(competitor_id) FROM competitor_event WHERE medal_id = '1' GROUP BY competitor_id; -- equivalent to previous one

-- having can be used with group by only, can only be used on grouped by column (here games_year) to filter based on some conditions
SELECT games_year, COUNT(games_year) AS c FROM games GROUP BY games_year HAVING c>1;
SELECT games_year, COUNT(games_year) AS c FROM games GROUP BY games_year HAVING games_year > 1980;
-- SELECT games_year, COUNT(games_year) as c from games GROUP BY games_year HAVING season = 'winter"; -- this will throw error as season is not the grouped by column


-- joins. Please consult the ER diagram for better understanding.

-- inner join -> returns a resultant table that has only matching values from both the tables
SELECT ce.competitor_id , m.medal_name from competitor_event AS ce INNER JOIN medal AS m ON m.id = ce.medal_id;
SELECT ce.competitor_id , m.id from competitor_event AS ce INNER JOIN medal AS m ON m.id = ce.medal_id ORDER BY m.id DESC;
-- notice that though 5th medal is there in the medal table, no competitor with medal_id = 5 exists, so 5th medal isn't there in the resultant table.   



-- left outer join -> returns a resultant table that has all values from left table and only matching values from right table
SELECT ce.competitor_id , m.id  from medal AS m LEFT JOIN competitor_event AS ce ON m.id = ce.medal_id ORDER BY m.id DESC; 
-- notice that 5th model is reflected in the table and corresponding competitor_id is null, as left outer join returns all the entries from left table.

-- right outer join -> returns a resultant table that has all values from right table and only matching values from left table
SELECT ce.competitor_id , m.id  from competitor_event AS ce RIGHT JOIN medal AS m ON m.id = ce.medal_id ORDER BY m.id DESC; 
-- basically left and right joins are similar if we swap the tables in the query. (a left join b) === (b right join a)

-- full outer join -> returns a resultant table that has all values from both the tables (union of right and left join)
-- but MYSQL doesnt support full outer join, so we have to use union to get full outer join
SELECT ce.competitor_id , m.id  from competitor_event AS ce LEFT JOIN medal AS m ON m.id = ce.medal_id
UNION 
SELECT ce.competitor_id , m.id  from competitor_event AS ce RIGHT JOIN medal AS m ON m.id = ce.medal_id;

-- cross join -> returns cartesian products of two tables
SELECT * FROM sport CROSS JOIN medal;


-- let's create a new table of employee to better understand self join

DROP TABLE IF EXISTS employees;

CREATE TABlE olympics.employees (
employee_id INT PRIMARY KEY,
manager_id INT NOT NULL,
salary INT NOT NULL
);

INSERT INTO olympics.employees (employee_id, manager_id, salary)
VALUES (1,1,1000),
(2,1,800),
(3,2,900),
(4,2,500),
(5,3,600),
(6,1,1100),
(7,7,1200);

COMMIT;

-- self join, some queries need same table to be joined 
SELECT e1.employee_id, e1.salary, e2.manager_id, e2.salary  FROM employees AS e1 INNER JOIN employees AS e2 ON e2.employee_id = e1.manager_id; -- this query compares the employees' salary with their managers'
SELECT e1.employee_id, e1.salary, e2.manager_id, e2.salary  FROM employees AS e1 INNER JOIN employees AS e2 ON e2.employee_id = e1.manager_id WHERE e1.salary > e2.salary; -- -- this query returns employees with higher compensation than their managers' ( utopia :-) )           

-- join can be implemented using where also
SELECT ce.competitor_id , m.medal_name FROM competitor_event AS ce , medal AS m WHERE m.id = ce.medal_id;
SELECT e1.employee_id, e1.salary, e2.manager_id, e2.salary  FROM employees AS e1, employees AS e2 WHERE e2.employee_id = e1.manager_id;

-- set operation (union, intersection, minus(difference)) 
-- the columns must be same for set operation

-- union returns all the unique entries in multiple tables combined 
-- union of resultant tables obtained from left join and right join will yield  full join
SELECT ce.competitor_id , m.id  FROM competitor_event AS ce LEFT JOIN medal AS m ON m.id = ce.medal_id
UNION 
SELECT ce.competitor_id , m.id  FROM competitor_event AS ce RIGHT JOIN medal AS m ON m.id = ce.medal_id;

-- intersection returns all the unique and common entries in multiple tables
-- intersection is emulated
SELECT e1.*  FROM employees AS e1 INNER JOIN employees AS e2 ON e1.employee_id=e2.employee_id;
SELECT e1.*  FROM employees AS e1 INNER JOIN employees AS e2 USING(employee_id); -- same as the previous one

-- subqueries
-- outer queries depend on subqueries (nested queries)
SELECT t.competitor_id, t.medal_name FROM (
	SELECT * FROM competitor_event AS ce 
	INNER JOIN medal AS m 
	ON ce.medal_id = m.id
) AS t
WHERE t.competitor_id<100 AND t.medal_name IS NOT NULL; 

-- view let us choose what columns to show and what not to
SELECT * FROM person; 

-- creating a view
DROP VIEW IF EXISTS person_view;
CREATE VIEW person_view AS SELECT id, full_name FROM person;

-- viewing from view
SELECT * FROM person_view;













































