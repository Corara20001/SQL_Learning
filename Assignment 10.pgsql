/* The questions in this section will require you to use the tables you created in assignment 1. 
Those tables are: students, student_enrollment, courses, professors and teach. 
Remember all assignments are mandatory, especially assignment 1.  
If you completed assignment 1, you should have these tables in your database already. 
If have not completed all of the previous assignments in this course, this section will not be feasible for you. 
Go back and complete all other problems and then come back here for a good challenge! */




-- Q1: Write a query that finds students who do not take CS180.
SELECT student_no, student_name
FROM students e1
GROUP BY student_no, student_name

EXCEPT

SELECT students.student_no, student_name
FROM students LEFT JOIN student_enrollment ON students.student_no = student_enrollment.student_no
LEFT JOIN courses ON student_enrollment.course_no = courses.course_no
WHERE student_enrollment.course_no = 'CS180' ;

-- Q2: Write a query to find students who take CS110 or CS107 but not both

SELECT student_no, student_name
FROM(
SELECT students.student_no, student_name, student_enrollment.course_no, 1 as flag
FROM students LEFT JOIN student_enrollment ON students.student_no = student_enrollment.student_no
LEFT JOIN courses ON student_enrollment.course_no = courses.course_no
WHERE student_enrollment.course_no IN ('CS110','CS107')
) as target_students
GROUP BY student_no, student_name
HAVING sum(flag) = 1;


--Q3: Write a query to find students who take CS220 and no other courses


SELECT student_no, student_name,count_courses

FROM(

SELECT students.student_no, student_name, student_enrollment.course_no ,
COUNT(student_enrollment.course_no) over(PARTITION BY students.student_no) as count_courses

FROM students LEFT JOIN student_enrollment ON students.student_no = student_enrollment.student_no
LEFT JOIN courses ON student_enrollment.course_no = courses.course_no
ORDER BY student_no
) as student_course_list

WHERE count_courses=1 and course_no = 'CS220';


--Q4: Write a query that finds those students who take at most 2 courses. 
--Your query should exclude students that don't take any courses as well as those that take more than 2 course.


SELECT student_no, student_name,count_courses

FROM(

SELECT students.student_no, student_name, student_enrollment.course_no ,
COUNT(student_enrollment.course_no) over(PARTITION BY students.student_no) as count_courses

FROM students LEFT JOIN student_enrollment ON students.student_no = student_enrollment.student_no
LEFT JOIN courses ON student_enrollment.course_no = courses.course_no

) as student_course_list

WHERE count_courses <= 2 and count_courses != 0
;

-- Q5: Write a query to find students who are older than at most two other students

SELECT student_no, student_name, age, count_no

FROM(

SELECT student_no, student_name, age,
RANK()  OVER(ORDER BY age DESC)  as count_no
FROM students

) as list_older

WHERE count_no <= 2+1

