--Cwiczenia 2

--GROUP BY ROLLUP(a,b,c) =>
--	GROUP BY null,
--	GROUP BY a,
--	GROUP BY a,b,
--	GROUP BY a,b,c
--GROUP BY CUBE(a,b,c) =>
--	GROUP BY null,
--	GROUP BY a,
--	GROUP BY a,b
--	GROUP BY a,c
--	GROUP BY a,b,c
--	GROUP BY b,
--	GROUP BY b,c
--	GROUP BY c
--GROUP BY GROUPING SETS(a,b,c) =>
--	GROUP BY a,null,null
--	GROUP BY null, b, null
--	GROUP BY null, null, c
	

--1
SELECT
    emp.department_id,
    ROUND(AVG(emp.salary),0)
FROM employees emp
GROUP BY emp.department_id;

--2
SELECT 
    emp.department_id,
    ROUND(AVG(emp.salary),0)
FROM employees emp
GROUP BY ROLLUP(emp.department_id);

--3
SELECT
    emp.department_id,
    emp.job_id,
    SUM(emp.salary)
FROM employees emp
GROUP BY emp.department_id, emp.job_id;

--4
SELECT
    emp.department_id,
    emp.job_id,
    SUM(emp.salary)
FROM employees emp
    JOIN departments dep ON emp.department_id=dep.department_id
GROUP BY ROLLUP(emp.job_id,emp.department_id);

--5
SELECT
    emp.department_id,
    emp.job_id,
    SUM(emp.salary)
FROM employees emp
GROUP BY CUBE(emp.job_id,emp.department_id);

--6
SELECT
    dep.department_name,
    job.job_title,
    SUM(emp.salary)
FROM employees emp
    JOIN departments dep ON emp.department_id=dep.department_id
    JOIN jobs job ON job.job_id=emp.job_id
GROUP BY CUBE(job.job_title,dep.department_name);

--7,8
SELECT
    CASE GROUPING(job.job_title) WHEN 1 THEN 'Razem' ELSE job.job_title END AS Stanowisko,
    SUM(emp.salary)
FROM employees emp
    JOIN jobs job ON job.job_id=emp.job_id
GROUP BY ROLLUP(job.job_title);

--9
SELECT
    CASE GROUPING(job.job_title) WHEN 1 THEN 'Wszystkie stanowiska' ELSE job.job_title END AS Stanowisko,
    CASE GROUPING(dep.department_name) WHEN 1 THEN 'Wszystkie dzialy' ELSE dep.department_name END AS Dzial,
    MIN(emp.salary),
    MAX(emp.salary)
FROM employees emp
    JOIN departments dep ON emp.department_id=dep.department_id
    JOIN jobs job ON job.job_id=emp.job_id
GROUP BY ROLLUP(job.job_title,dep.department_name);

--10
    SELECT
        job.job_title,
        null AS "DEPARTMENT_NAME",
        SUM(emp.salary)
    FROM employees emp
        JOIN jobs job ON job.job_id=emp.job_id
    GROUP BY job.job_title
UNION ALL
    SELECT
        null,
        dep.department_name,
        SUM(emp.salary)
    FROM employees emp
        JOIN departments dep ON emp.department_id=dep.department_id
    GROUP BY dep.department_name;
    
SELECT
    job.job_title,
    dep.department_name,
    SUM(emp.salary)
FROM employees emp
    JOIN jobs job ON job.job_id=emp.job_id
    JOIN departments dep ON emp.department_id=dep.department_id
GROUP BY GROUPING SETS (job.job_title,dep.department_name)
