--Cwiczenia 3

--1
SELECT *
FROM employees
CONNECT BY PRIOR employee_id=manager_id --znajdŸ takie rekordy, gdzie manager_id jest równe employee_id poprzedniego rekordu
START WITH employee_id=100;

--2
SELECT employee_id, first_name, last_name, job_id, PRIOR employee_id AS "Superior ID", PRIOR job_id AS "Superior job ID"
FROM employees
CONNECT BY PRIOR employee_id=manager_id
START WITH employee_id=100;

--3
SELECT *
FROM employees
CONNECT BY PRIOR employee_id = manager_id
START WITH last_name='Greenberg';

--4
SELECT *
FROM employees
CONNECT BY PRIOR manager_id=employee_id
START WITH last_name='Greenberg';

--5
SELECT last_name || ' -> ' || PRIOR last_name AS "podwladny -> przelozony"
FROM employees
CONNECT BY PRIOR employee_id = manager_id
START WITH last_name='Greenberg';

--6
SELECT *
FROM employees
CONNECT BY PRIOR manager_id=employee_id
START WITH employee_id=105;

--7
SELECT first_name || ' ' || last_name, level
FROM employees
CONNECT BY PRIOR employee_id=manager_id
START WITH manager_id IS NULL;

--8
SELECT first_name || ' ' || last_name, level
FROM employees
CONNECT BY PRIOR manager_id=employee_id
START WITH employee_id=105;

--9
SELECT level, employee_id, last_name, sys_connect_by_path(last_name,'*')
FROM employees
CONNECT BY PRIOR employee_id=manager_id
START WITH manager_id IS NULL;

--10
SELECT level, employee_id, last_name, CONNECT_BY_ROOT last_name AS "Boss"
FROM employees
CONNECT BY PRIOR employee_id=manager_id
START WITH manager_id IS NULL;

--11
SELECT level, employee_id, last_name, CONNECT_BY_ROOT first_name || ' ' || CONNECT_BY_ROOT last_name AS "Boss"
FROM employees
CONNECT BY PRIOR employee_id=manager_id
START WITH manager_id IS NULL;

--12
SELECT LPAD(' ',3*(level-1)) || first_name || ' ' || last_name
FROM employees
CONNECT BY PRIOR employee_id=manager_id
START WITH manager_id IS NULL;

--13
SELECT LPAD(' ',3*(level-1)) || first_name || ' ' || last_name
FROM employees
WHERE last_name!='Higgins'
CONNECT BY PRIOR employee_id=manager_id
START WITH manager_id IS NULL;

--14
SELECT LPAD(' ',3*(level-1)) || first_name || ' ' || last_name
FROM employees
CONNECT BY PRIOR employee_id=manager_id AND last_name!='Higgins'
START WITH manager_id IS NULL;