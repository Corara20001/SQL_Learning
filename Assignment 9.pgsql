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



