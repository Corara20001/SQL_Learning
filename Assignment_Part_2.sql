SELECT avg(salary)
FROM employees
WHERE salary NOT IN  (SELECT min(salary) from employees)
    and salary NOT IN (SELECT max(salary) from employees)
