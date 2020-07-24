-- Course Content: Join Tables: Join, Union, Except, Cartesian Product (Cross Join)

-- Union requires #of columns and date types to be the same
-- Order by is always at the end of the query (cannot use order by for the first data to be unioned).

--Excpet: If the second data set has any value the same as in the first data set, the record will be removed from the first data set. 

-- View: create a view. the difference between a view  and a table is whether data could be dropped or added. A view is saved as a set of code instead of an actual table.

-- Cross Join: each row in table a gets joined with each row in table b.



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



-- Q4: Get departments from employees table and departments table

SELECT department 
FROM employees
UNION -- Union Removes duplicates
SELECT department
FROM departments;


SELECT department 
FROM employees
UNION ALL -- Union All keeps all recourds (does not remove deplicates)
SELECT department
FROM departments;


-- Q5: Find all the departments that are found in the  employees table but  not in the departments table:
SELECT department
FROM employees
EXCEPT -- remove duplicate
SELECT department
FROM departments;



--Q6: Cartesian Product: Not specify join key

Select Count(*) from (

SELECT *
FROM employees, departments as a); 


Select Count(*) from (

SELECT *
FROM employees a CROSS JOIN departments b);



-- Q7: 




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


-- Q3: A list of departments with the # of employees working in the department. Add a last row as total employees

SELECT department, COUNT(employee_id) as count
FROM employees as table1
GROUP BY department 
UNION ALL
SELECT 'Total' as department,COUNT(employee_id) as count
FROM employees as table2;


-- Q4: first name, department, hire date , country for the first/last employee hired in the company.



(SELECT first_name, department, hire_date, country
FROM employees LEFT JOIN regions ON employees.region_id = regions.region_id
WHERE hire_date <= ALL (SELECT hire_date from employees)
LIMIT 1) -- have to use () for limit clause when Union

UNION ALL

SELECT first_name,department,hire_date,country
FROM employees LEFT JOIN regions ON employees.region_id = regions.region_id
WHERE hire_date >= ALL (SELECT hire_date from employees);


-- Q5: the running total of salary every 90 days since the first hire date till the last hire date

SELECT hire_date, salary,
    (SELECT sum(salary) FROM employees e2 
    WHERE e2.hire_date BETWEEN e.hire_date - 90 AND e.hire_date ) 
        as spending_pattern

FROM employees e
ORDER BY hire_date;






-- Assignments


/*The questions that follow will be related to the tables that you created in assignment one. Query those tables and try to figure out how the data is related. 
Those tables are: students, courses, student_enrollment, professors, and teach. The follow problems are related to these.*/


-- Q1: Are the tables student_enrollment and professors directly related to each other? Why or why not?


SELECT *
FROM student_enrollment;

SELECT *
FROM professors;

-- No. Beacuse there is no foregin keys.


--Q2: Write a query that shows the student's name, the courses the student is taking and the professors that teach that course. 

SELECT *
FROM teach;


SELECT *
FROM students;

SELECT *
FROM courses;


SELECT students.student_no, student_name, course_title, professors.last_name
FROM students left join student_enrollment ON students.student_no = student_enrollment.student_no
left join teach ON student_enrollment.course_no = teach.course_no
left join courses ON teach.course_no = courses.course_no
left join professors ON teach.last_name = professors.last_name
ORDER BY student_no;


-- 3 students have no courses.course_no

--Q3: If you execute the query from the previous answer, you'll notice the student_name and the course_no is being repeated. Why is this happening?

/*Because there are multiple professors teaching the same course, and multiple courses taken by the same student. 
They are one-to-many relationship.*/


--Q4: In question 3 you discovered why there is repeating data. How can we eliminate this redundancy? Let's say we only care to see a single professor teaching a course and we don't care for all the other professors that teach the particular course. Write a query that will accomplish this so that every record is distinct.

-- HINT: Using the DISTINCT keyword will not help. :-)

SELECT students.student_no, student_name, course_title, min(professors.last_name)
FROM students left join student_enrollment ON students.student_no = student_enrollment.student_no
left join teach ON student_enrollment.course_no = teach.course_no
left join courses ON teach.course_no = courses.course_no
left join professors ON teach.last_name = professors.last_name
GROUP BY students.student_no, student_name, course_title
ORDER BY student_no;


--Q5: Why are correlated subqueries slower that non-correlated subqueries and joins?

--Correlated subqueries went each row from the outer query through the subquery, however, non-correlated subqueries would only execute once at the  beginning.


-- Q6: In the video lectures, we've been discussing the employees table and the departments table. Considering those tables, write a query that returns employees whose salary is above average for their given department.

SELECT e1.employee_id, e1.salary, e1.department
FROM employees e1
WHERE salary > (SELECT avg(salary) FROM employees e2 WHERE e1.department = e2.department GROUP BY department  )


-- Q7: Write a query that returns ALL of the students as well as any courses they may or may not be taking. 

SELECT student_name, course_title
FROM students CROSS JOIN courses;

