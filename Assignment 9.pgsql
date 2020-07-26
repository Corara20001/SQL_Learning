--Course Content: Window Functions public, PARTITION, Order BY (ROWS BETWEEN)
-- Combine grouping columns with non-grouping columns
-- LEAD(the next row) and LAG (the previous row)
-- Rollups and Cubes: GROUPING SETS, ROLLUP,CUBE



-- Q1: Show a list of employee names and the department they work in with the no. of employees in that department.

(SELECT first_name, department, (select count(*) FROM employees e1 WHERE e1.department = e2.department)
FROM employees e2
ORDER BY department)

-- The complexity of running the correlated subquery is high, can use window function to simplify.
EXCEPT

SELECT first_name, department, 
COUNT(*) OVER(PARTITION BY department)
FROM employees;

-- Count function is proceeded within the over section. If put nothing, will be the from table (employees without group by).
-- PARTITION is similar to Group by.

--Q2: Running  total for each hire_date

SELECT first_name, hire_date, salary, 
    SUM(salary) OVER(ORDER BY hire_date RANGE BETWEEN UNBOUNDED PRECEDING --The range is: All rows before the current row and the current row
    AND CURRENT ROW) as running_total
FROM employees;


-- Q3: Running total for each hire_date within each department
SELECT first_name, hire_date, department, salary, 
    SUM(salary) OVER(PARTITION BY department ORDER BY hire_date) as running_total -- could delete "RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW" as it is default.
FROM employees;

-- Q4: Add adjacent salary when employee table is ordered by hire_date 

SELECT first_name, hire_date, department, salary, 
    SUM(salary) OVER( ORDER BY hire_date ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) as adj_salary --The range is: 1 row before the current row and the current row
FROM employees；

-- Q5: Rank the salary for each employee within each department

SELECT first_name, department, salary,
RANK() OVER(PARTITION BY department ORDER BY salary DESC) as rank_employees
FROM employees;

-- Q6: Rank the salary for each employee within each department. Keep 5 employees for each rank group.
-- NTILE

SELECT first_name, department, salary,
NTILE(5) OVER(PARTITION BY department ORDER BY salary DESC) --use nitile to replace rank, set 5 as bracket for 5 employees
FROM employees；

-- Q7: Get the list of employees and their departments with the biggest salary for each departments

(SELECT first_name,department,salary,
first_value(salary) OVER(PARTITION BY department ORDER BY salary DESC) as first_value
FROM employees)

EXCEPT

SELECT first_name,department,salary,
MAX(salary) OVER(PARTITION BY department ORDER BY salary DESC) as first_value
FROM employees;

-- Q8:Get the list of employees and their departments with the 8th biggest salary for each departments

SELECT first_name, department, salary,
nth_value(salary, 8) OVER(PARTITION BY department ORDER BY salary desc) as eighth_value
FROM employees;


-- Q9： Find the  closest higher/lower Salary to each employees

SELECT first_name, salary, 
LAG(salary) OVER(ORDER BY salary desc)  next_higher_salary, -- Previous row
LEAD(salary) OVER(ORDER BY salary desc) next_lower_salary -- The next row
FROM employees;


-- Q10: Creat a new table:

CREATE TABLE sales
(
continent varchar(20),
country varchar(20),
city varchar(20),
units_sold integer
);

INSERT INTO sales VALUES ('North America', 'Canada', 'Toronto', 10000);
INSERT INTO sales VALUES ('North America', 'Canada', 'Montreal', 5000);
INSERT INTO sales VALUES ('North America', 'Canada', 'Vancouver', 15000);
INSERT INTO sales VALUES ('Asia', 'China', 'Hong Kong', 7000);
INSERT INTO sales VALUES ('Asia', 'China', 'Shanghai', 3000);
INSERT INTO sales VALUES ('Asia', 'Japan', 'Tokyo', 5000);
INSERT INTO sales VALUES ('Europe', 'UK', 'London', 6000);
INSERT INTO sales VALUES ('Europe', 'UK', 'Manchester', 12000);
INSERT INTO sales VALUES ('Europe', 'France', 'Paris', 5000);

SELECT *
FROM sales;


-- Q11: Get the total units sold for each continent, country and city.

SELECT continent, country, city, sum(units_sold)
FROM sales
GROUP BY GROUPING SETS(continent, country, city,()); -- the empty bracket returns another row that shows the total if there is no group by.
-- Group by each elements in the bracket

SELECT continent, country, city, sum(units_sold)
FROM sales
GROUP BY ROLLUP(continent, country, city); 
-- Group by nothing, all3, 2 of them, only 1



SELECT continent, country, city, sum(units_sold)
FROM sales
GROUP BY CUBE(continent, country, city); 
-- Group by all possible ways of combination 


