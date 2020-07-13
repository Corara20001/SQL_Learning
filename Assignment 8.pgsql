-- Course Content: Join Tables



-- Q1: Find the country of each employees 

SELECT first_name, country

FROM employees,regions

WHERE employees.region_id = regions.region_id;


-- Q2: use join to find country, and in another set of code, find email/ division,country for each employee(not null in email).

SELECT first_name, country
FROM employees INNER JOIN regions
ON employees.region_id = regions.region_id;

SELECT first_name, email, division, country
FROM employees INNER JOIN departments
ON employees.department = departments.department  -- this first join happens first and then the result tgt join with  the next one.
INNER JOIN regions ON employees.region_id = regions.region_id
WHERE email IS NOT NULL;

--Q3: Find the departments that exist in employees table but does not exist in the departments table.
-- left join give preference to left table and right join gives preference to the right table.
-- FULL OUTER JOIN : all

SELECT DISTINCT department FROM employees;
-- 27 departments

SELECT DISTINCT department FROM departments;
-- 24 departments

SELECT DISTINCT employees.department
FROM employees LEFT JOIN departments ON employees.department = departments.department
WHERE departments.department ISNULL;








-- In-course Assignments:
-- Q1: Create a report that gives the first name of the employee, their email address and division (from departments), country (from regions table). The table should only include the employees with an email address.

SELECT first_name, email, division, country
FROM employees, departments, regions

WHERE employees.department = departments.department
    AND employees.region_id = regions.region_id
    AND email is not null ;
    -- Nulls cannot be compared with nulls. so cannot use =

-- Q2: country and the total count of employees assigned to that country.

SELECT country, count(employee_id)
FROM regions, employees
WHERE employees.region_id = regions.region_id
GROUP BY country;





