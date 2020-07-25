--Course Content: Window Functions public
-- Combine grouping columns with non-grouping columns



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
SUM(salary) OVER( ORDER BY hire_date ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) --The range is: 1 row before the current row and the current row
FROM employees
