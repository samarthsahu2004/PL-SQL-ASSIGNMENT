-- 09_tests.sql
-- Comprehensive end-to-end test script for Employee Management System (Snowflake).
-- This script tests:
--   * Tables & constraints
--   * Sequences
--   * UDFs
--   * Stored procedures
--   * Views
--   * Stream + task-based salary audit
--   * Complex analytical queries

USE DATABASE EMP_MGMT_DB;
USE SCHEMA EMP_MGMT;

---------------------------------------
-- 1. Basic sanity checks on tables
---------------------------------------
SELECT COUNT(*) AS DEPARTMENT_COUNT FROM DEPARTMENTS;
SELECT COUNT(*) AS EMPLOYEE_COUNT FROM EMPLOYEES;
SELECT * FROM DEPARTMENTS ORDER BY DEPARTMENT_ID LIMIT 10;
SELECT * FROM EMPLOYEES ORDER BY EMPLOYEE_ID LIMIT 10;

---------------------------------------
-- 2. Test sequences directly
---------------------------------------
SELECT SEQ_EMPLOYEE_ID.NEXTVAL       AS NEXT_EMP_ID;
SELECT SEQ_SALARY_HISTORY_ID.NEXTVAL AS NEXT_HISTORY_ID;

---------------------------------------
-- 3. Test hire_employee procedure
--    (explicit ID so we can easily track this test employee)
---------------------------------------
SET TEST_EMP_ID = 2001;

CALL EMP_MANAGEMENT__HIRE_EMPLOYEE(
  $TEST_EMP_ID,
  'John',
  'Doe',
  'john.doe.test@example.com',
  50000,
  10,
  '2022-05-10'
);

-- Verify employee was inserted
SELECT * FROM EMPLOYEES WHERE EMPLOYEE_ID = $TEST_EMP_ID;
SELECT * FROM V_EMPLOYEE_DETAILS WHERE EMPLOYEE_ID = $TEST_EMP_ID;

---------------------------------------
-- 4. Test CALCULATE_BONUS UDF
---------------------------------------
SELECT
  EMPLOYEE_ID,
  FIRST_NAME,
  LAST_NAME,
  SALARY,
  CALCULATE_BONUS(EMPLOYEE_ID, 0.15) AS BONUS_15_PCT
FROM EMPLOYEES
WHERE EMPLOYEE_ID = $TEST_EMP_ID;

---------------------------------------
-- 4.b Test additional UDF utilities
---------------------------------------
SELECT
  $TEST_EMP_ID                                     AS EMPLOYEE_ID,
  GET_EMP_FULL_NAME($TEST_EMP_ID)                  AS FULL_NAME,
  GET_ANNUAL_SALARY($TEST_EMP_ID)                  AS ANNUAL_SALARY,
  GET_SALARY_GRADE((SELECT SALARY FROM EMPLOYEES WHERE EMPLOYEE_ID = $TEST_EMP_ID)) AS SALARY_GRADE,
  GET_DEPT_AVG_SALARY((SELECT DEPARTMENT_ID FROM EMPLOYEES WHERE EMPLOYEE_ID = $TEST_EMP_ID)) AS DEPT_AVG_SALARY,
  GET_PCT_ABOVE_DEPT_AVG($TEST_EMP_ID)             AS PCT_ABOVE_DEPT_AVG,
  GET_EMAIL_DOMAIN((SELECT EMAIL FROM EMPLOYEES WHERE EMPLOYEE_ID = $TEST_EMP_ID)) AS EMAIL_DOMAIN,
  GET_TENURE_YEARS($TEST_EMP_ID)                   AS TENURE_YEARS;

---------------------------------------
-- 5. Test UPDATE_SALARY procedure
--    (this should generate a row in the salary history via stream+task)
---------------------------------------
CALL EMP_MANAGEMENT__UPDATE_SALARY(
  $TEST_EMP_ID,
  55000
);

-- Optional: execute task immediately (instead of waiting for the schedule)
ALTER TASK TASK_EMP_SALARY_AUDIT EXECUTE IMMEDIATE;

-- Check salary_history for the change
SELECT * FROM SALARY_HISTORY
WHERE EMPLOYEE_ID = $TEST_EMP_ID
ORDER BY CHANGE_DATE DESC;

-- View-based check for salary changes
SELECT * FROM V_SALARY_CHANGES
WHERE EMPLOYEE_ID = $TEST_EMP_ID
ORDER BY CHANGE_DATE DESC;

---------------------------------------
-- 6. Test TERMINATE_EMPLOYEE procedure
---------------------------------------
CALL EMP_MANAGEMENT__TERMINATE_EMPLOYEE(
  $TEST_EMP_ID
);

-- Verify deletion
SELECT * FROM EMPLOYEES WHERE EMPLOYEE_ID = $TEST_EMP_ID;

---------------------------------------
-- 7. Test views for general data
---------------------------------------
SELECT * FROM V_EMPLOYEE_DETAILS ORDER BY DEPARTMENT_ID, EMPLOYEE_ID LIMIT 20;
SELECT * FROM V_SALARY_CHANGES ORDER BY CHANGE_DATE DESC LIMIT 20;

---------------------------------------
-- 8. Complex queries with subqueries and window functions
---------------------------------------

-- 8.a Employees earning above department average
SELECT
  e.FIRST_NAME,
  e.LAST_NAME,
  e.SALARY,
  e.DEPARTMENT_ID,
  (
    SELECT AVG(SALARY)
    FROM EMPLOYEES
    WHERE DEPARTMENT_ID = e.DEPARTMENT_ID
  ) AS DEPT_AVG
FROM EMPLOYEES e
WHERE e.SALARY > (
  SELECT AVG(SALARY)
  FROM EMPLOYEES
  WHERE DEPARTMENT_ID = e.DEPARTMENT_ID)
ORDER BY e.DEPARTMENT_ID, e.SALARY DESC;

-- 8.b Rank employees by salary within department
SELECT
  e.EMPLOYEE_ID,
  e.FIRST_NAME,
  e.LAST_NAME,
  e.DEPARTMENT_ID,
  e.SALARY,
  RANK() OVER (PARTITION BY e.DEPARTMENT_ID ORDER BY e.SALARY DESC) AS RANK_IN_DEPT
FROM EMPLOYEES e
ORDER BY e.DEPARTMENT_ID, RANK_IN_DEPT;

---------------------------------------
-- 9. Bonus report by department (cursor-style procedure)
---------------------------------------
CALL EMP_MANAGEMENT__BONUS_REPORT_BY_DEPT(30, 0.10);

---------------------------------------
-- 10. (Optional) Constraint negative tests
--     These are EXPECTED to fail with errors. Run separately if needed.
---------------------------------------
-- Example: salary must be > 0
-- INSERT INTO EMPLOYEES (
--   EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, SALARY, DEPARTMENT_ID, HIRE_DATE
-- ) VALUES (
--   9999, 'Bad', 'Salary', 'bad.salary@example.com', -1000, 10, CURRENT_DATE()
-- );
--
-- Example: hire date cannot be in the future
-- INSERT INTO EMPLOYEES (
--   EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, SALARY, DEPARTMENT_ID, HIRE_DATE
-- ) VALUES (
--   10000, 'Future', 'Hire', 'future.hire@example.com', 40000, 10, DATEADD(day, 10, CURRENT_DATE())
-- );

