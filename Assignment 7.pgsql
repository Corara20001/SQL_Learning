-- Course Content: Correlated Subqueries
-- Inner query using info from ourter query.
-- The subquries will be ran for every record in the outer query.

SELECT
first_name,
salary
FROM employees as e1
WHERE salary > (select round(AVG(salary)) 
                From employees as e2 
                WHERE e1.department = e2.department);



-- In-course Assignments:

SELECT*
from departments;

SELECT department
FROM departments
WHERE 38< (SELECT count(employee_id) FROM employees WHERE departments.department = employees.department);
-- the correlated subquery is doing group by.



SELECT
    department
    ,salary
FROM employees e1
WHERE salary = (SELECT max(salary) FROM employees e2 WHERE e1.department = e2.department)
    AND 38< (SELECT count(employee_id) FROM employees e3 WHERE e1.department = e3.department);


SELECT 
    department
    ,(SELECT max(salary) FROM employees e3 WHERE e3.department = e1.department)
FROM departments e1
WHERE 38 < (SELECT count(*) FROM employees e2 WHERE e2.department = e1.department);





-- Assignment 7:

--Q1：For each deparment, return the first name for the employees who receive highest and lowest salary and their salaries.



SELECT
    department,
    first_name,
    salary,
    case when salary >= (SELECT max(salary) FROM employees as e3 WHERE e1.department = e3.department)  then 'HIGHEST SALARY'
    else 'LOWEST SALARY' 
    end as salary_in_department


FROM employees as e1
WHERE salary >= ALL (SELECT max(salary) FROM employees as e2 WHERE e1.department = e2.department)
    or salary<= All (SELECT min(salary) FROM employees as e2 WHERE e1.department = e2.department)
ORDER BY department asc,
    salary desc;

    




 




