/*SELECT avg(salary)
FROM employees
WHERE salary NOT IN  (SELECT min(salary) from employees)
    and salary NOT IN (SELECT max(salary) from employees)*/


-- Section 5 Assignment

-- Q1:
-- No. Student_no is directly related to course_no and then related to course_table.
-- Q2:
SELECT student_name
FROM Students
WHERE Student_no IN 
    (SELECT Student_no FROM Student_enrollment WHERE course_no IN 
        (SELECT course_no FROM courses WHERE course_title IN ('US History','Physics') ));


-- Q3:

SELECT student_name
FROM Students
WHERE student_no IN (SELECT student_no FROM Student_enrollment GROUP BY student_no ORDER BY count(course_no) desc limit 1);

-- Q4: Subqueries can be used in the FROM clause and the WHERE clause but cannot be sued in the SELECT clause. (TRUE OR FALSE)
-- FALSE

--Q5:
SELECT *
FROM students
WHERE age >= ALL (SELECT age FROM students);
