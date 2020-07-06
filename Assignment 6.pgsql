-- Course Content: CASE Clause, Transpose

SELECT first_name,
    salary,
    CASE 
        WHEN salary < 100000 THEN 'Underpaid'
        WHEN salary > 100000 THEN 'Paid Well'
        WHEN salary > 160000 THEN 'Executive'
        ELSE 'Unpaid'
    END
FROM employees
ORDER BY salary desc;

SELECT department, count(*)
FROM employees
WHERE department IN ('Sports','Tools','Clothing','Computers')
GROUP BY department;



-- In course assignment:

SELECT 
    category,
    count(first_name)

FROM (SELECT first_name,
        salary,
    CASE 
        WHEN salary < 100000 THEN 'Underpaid'
        WHEN salary > 100000 and salary < 160000 THEN 'Paid Well'
        WHEN salary > 160000 THEN 'Executive'
        ELSE 'Unpaid'
    END as category
FROM employees
ORDER BY salary desc) as a

GROUP BY a.category;


SELECT 
    SUM(
        CASE 
            WHEN department = 'Tools' THEN 1
            ELSE 0
        END) as Tools_Employees,
    SUM(
        CASE
            WHEN department = 'Sports' THEN 1
            ELSE 0
        END
        ),
    SUM(
        CASE
            WHEN department = 'Clothing' THEN 1
            ELSE 0
        END
        ),
    SUM(
        CASE
            WHEN department = 'Computers' THEN 1
            ELSE 0
        END
        )
FROM employees;



SELECT *
FROM employees;

SELECT *
FROM regions;

SELECT  first_name,
    CASE WHEN region_id = 1 THEN (SELECT country FROM regions where region_id = 1) ELSE NULL END as region_1, 
    CASE WHEN region_id = 2 THEN (SELECT country FROM regions where region_id = 2) ELSE NULL END as region_2, 
    CASE WHEN region_id = 3 THEN (SELECT country FROM regions where region_id = 3) ELSE NULL END as region_3, 
    CASE WHEN region_id = 4 THEN (SELECT country FROM regions where region_id = 4) ELSE NULL END as region_4, 
    CASE WHEN region_id = 5 THEN (SELECT country FROM regions where region_id = 5) ELSE NULL END as region_5, 
    CASE WHEN region_id = 6 THEN (SELECT country FROM regions where region_id = 6) ELSE NULL END as region_6, 
    CASE WHEN region_id = 7 THEN (SELECT country FROM regions where region_id = 7) ELSE NULL END as region_7

FROM employees;



SELECT 
    count(a.region_1) + count(a.region_2) + count(a.region_3) as united_states
FROM 
(SELECT  first_name,
    CASE WHEN region_id = 1 THEN (SELECT country FROM regions where region_id = 1) ELSE NULL END as region_1, 
    CASE WHEN region_id = 2 THEN (SELECT country FROM regions where region_id = 2) ELSE NULL END as region_2, 
    CASE WHEN region_id = 3 THEN (SELECT country FROM regions where region_id = 3) ELSE NULL END as region_3, 
    CASE WHEN region_id = 4 THEN (SELECT country FROM regions where region_id = 4) ELSE NULL END as region_4, 
    CASE WHEN region_id = 5 THEN (SELECT country FROM regions where region_id = 5) ELSE NULL END as region_5, 
    CASE WHEN region_id = 6 THEN (SELECT country FROM regions where region_id = 6) ELSE NULL END as region_6, 
    CASE WHEN region_id = 7 THEN (SELECT country FROM regions where region_id = 7) ELSE NULL END as region_7
FROM employees) as a


-- Assignment 6 

SELECT *
FROM fruit_imports;

-- Q1 :

SELECT 
    name,
    sum(supply),
    CASE 
        WHEN sum(supply) < 20000 THEN 'LOW'
        WHEN sum(supply) < 50000  AND sum(supply) >= 20000 THEN 'ENOUGH'
        WHEN sum(supply) >= 50000 THEN 'FULL'
    END as category
FROM fruit_imports
GROUP BY name;




SELECT by_name.name,
    by_name.total_supply,
    CASE 
        WHEN total_supply < 20000 THEN 'LOW'
        WHEN total_supply< 50000  AND total_supply >= 20000 THEN 'ENOUGH'
        ELSE 'FULL'
    END as category

FROM(
SELECT 
    name,
    sum(supply) as total_supply
FROM fruit_imports
GROUP BY name) as by_name;


-- Q2


SELECT
    round(sum(CASE WHEN season = 'Winter' THEN total_cost ELSE 0 END),2) as Winter,
    round(sum(CASE WHEN season = 'Summer' THEN total_cost ELSE 0 END),2) as Winter,
    round(sum(CASE WHEN season = 'All Year' THEN total_cost ELSE 0 END),2) as Winter,
    round(sum(CASE WHEN season = 'Spring' THEN total_cost ELSE 0 END),2) as Winter,
    round(sum(CASE WHEN season = 'Fall' THEN total_cost ELSE 0 END),2) as Winter

FROM(       
SELECT 
    season,
    sum(supply * cost_per_unit) as total_cost
FROM fruit_imports
GROUP BY season) as seasonlvl;




