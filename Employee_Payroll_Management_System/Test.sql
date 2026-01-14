-- ============================================
-- TEST SCRIPT FOR EMPLOYEE PAYROLL MANAGEMENT SYSTEM
-- ============================================
-- This script tests all functionalities of the payroll system
-- ============================================

SET SERVEROUTPUT ON;

-- ============================================
-- TEST 1: Display all departments
-- ============================================
PROMPT ============================================
PROMPT TEST 1: Display all departments
PROMPT ============================================

SELECT dept_id AS "Dept ID", 
       dept_name AS "Department Name", 
       location AS "Location"
FROM departments
ORDER BY dept_id;

-- ============================================
-- TEST 2: Display all employees
-- ============================================
PROMPT 
PROMPT ============================================
PROMPT TEST 2: Display all employees
PROMPT ============================================

SELECT e.emp_id AS "Emp ID",
       e.emp_name AS "Employee Name",
       d.dept_name AS "Department",
       e.designation AS "Designation",
       e.basic_salary AS "Basic Salary",
       e.hire_date AS "Hire Date"
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
ORDER BY e.emp_id;

-- ============================================
-- TEST 3: Test Tax Calculation Function
-- ============================================
PROMPT 
PROMPT ============================================
PROMPT TEST 3: Test Tax Calculation Function
PROMPT ============================================

DECLARE
    v_tax NUMBER;
    v_gross_salary NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Testing tax calculation for different salary ranges:');
    DBMS_OUTPUT.PUT_LINE('');
    
    -- Test with 30000 monthly (360000 annual)
    v_gross_salary := 30000;
    v_tax := payroll_pkg.calculate_tax(v_gross_salary);
    DBMS_OUTPUT.PUT_LINE('Gross Salary: Rs. ' || TO_CHAR(v_gross_salary, '999,999.99') || 
                        ' | Monthly Tax: Rs. ' || TO_CHAR(v_tax, '999,999.99'));
    
    -- Test with 50000 monthly (600000 annual)
    v_gross_salary := 50000;
    v_tax := payroll_pkg.calculate_tax(v_gross_salary);
    DBMS_OUTPUT.PUT_LINE('Gross Salary: Rs. ' || TO_CHAR(v_gross_salary, '999,999.99') || 
                        ' | Monthly Tax: Rs. ' || TO_CHAR(v_tax, '999,999.99'));
    
    -- Test with 100000 monthly (1200000 annual)
    v_gross_salary := 100000;
    v_tax := payroll_pkg.calculate_tax(v_gross_salary);
    DBMS_OUTPUT.PUT_LINE('Gross Salary: Rs. ' || TO_CHAR(v_gross_salary, '999,999.99') || 
                        ' | Monthly Tax: Rs. ' || TO_CHAR(v_tax, '999,999.99'));
END;
/

-- ============================================
-- TEST 4: Calculate salary for a specific employee
-- ============================================
PROMPT 
PROMPT ============================================
PROMPT TEST 4: Calculate salary for Employee ID 1
PROMPT ============================================

BEGIN
    payroll_pkg.calculate_salary(1, EXTRACT(MONTH FROM SYSDATE), EXTRACT(YEAR FROM SYSDATE));
END;
/

-- ============================================
-- TEST 5: Generate Payslip for Employee ID 1
-- ============================================
PROMPT 
PROMPT ============================================
PROMPT TEST 5: Generate Payslip for Employee ID 1
PROMPT ============================================

BEGIN
    payroll_pkg.generate_payslip(1, EXTRACT(MONTH FROM SYSDATE), EXTRACT(YEAR FROM SYSDATE));
END;
/

-- ============================================
-- TEST 6: Generate Payslip for Employee ID 3
-- ============================================
PROMPT 
PROMPT ============================================
PROMPT TEST 6: Generate Payslip for Employee ID 3
PROMPT ============================================

BEGIN
    payroll_pkg.generate_payslip(3, EXTRACT(MONTH FROM SYSDATE), EXTRACT(YEAR FROM SYSDATE));
END;
/

-- ============================================
-- TEST 7: Department-wise Salary Report - IT Department
-- ============================================
PROMPT 
PROMPT ============================================
PROMPT TEST 7: Department-wise Salary Report - IT Department
PROMPT ============================================

BEGIN
    payroll_pkg.department_salary_report(2, EXTRACT(MONTH FROM SYSDATE), EXTRACT(YEAR FROM SYSDATE));
END;
/

-- ============================================
-- TEST 8: Department-wise Salary Report - Finance Department
-- ============================================
PROMPT 
PROMPT ============================================
PROMPT TEST 8: Department-wise Salary Report - Finance Department
PROMPT ============================================

BEGIN
    payroll_pkg.department_salary_report(3, EXTRACT(MONTH FROM SYSDATE), EXTRACT(YEAR FROM SYSDATE));
END;
/

-- ============================================
-- TEST 9: Add a new employee
-- ============================================
PROMPT 
PROMPT ============================================
PROMPT TEST 9: Add a new employee
PROMPT ============================================

BEGIN
    payroll_pkg.add_employee(
        'Sandeep Menon',
        'sandeep.menon@company.com',
        '9876543223',
        SYSDATE,
        2,
        'Junior Developer',
        45000
    );
END;
/

-- Calculate salary for the new employee
BEGIN
    payroll_pkg.calculate_salary(
        (SELECT MAX(emp_id) FROM employees),
        EXTRACT(MONTH FROM SYSDATE),
        EXTRACT(YEAR FROM SYSDATE)
    );
END;
/

-- ============================================
-- TEST 10: Test Trigger - Update Employee Salary
-- ============================================
PROMPT 
PROMPT ============================================
PROMPT TEST 10: Test Trigger - Update Employee Salary (should create audit record)
PROMPT ============================================

DECLARE
    v_old_salary NUMBER;
    v_new_salary NUMBER := 55000;
    v_emp_id NUMBER := 1;
BEGIN
    -- Get current salary
    SELECT basic_salary INTO v_old_salary
    FROM employees
    WHERE emp_id = v_emp_id;
    
    DBMS_OUTPUT.PUT_LINE('Updating salary for Employee ID: ' || v_emp_id);
    DBMS_OUTPUT.PUT_LINE('Old Salary: Rs. ' || TO_CHAR(v_old_salary, '999,999.99'));
    DBMS_OUTPUT.PUT_LINE('New Salary: Rs. ' || TO_CHAR(v_new_salary, '999,999.99'));
    
    -- Update salary (trigger will fire)
    UPDATE employees
    SET basic_salary = v_new_salary
    WHERE emp_id = v_emp_id;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Salary updated successfully. Check salary_audit table.');
    
    -- Recalculate salary with new basic
    payroll_pkg.calculate_salary(v_emp_id, EXTRACT(MONTH FROM SYSDATE), EXTRACT(YEAR FROM SYSDATE));
END;
/

-- ============================================
-- TEST 11: Display Salary Audit Records
-- ============================================
PROMPT 
PROMPT ============================================
PROMPT TEST 11: Display Salary Audit Records
PROMPT ============================================

SELECT audit_id AS "Audit ID",
       emp_id AS "Emp ID",
       old_salary AS "Old Salary",
       new_salary AS "New Salary",
       changed_by AS "Changed By",
       TO_CHAR(change_date, 'DD-MON-YYYY HH24:MI:SS') AS "Change Date",
       change_type AS "Change Type"
FROM salary_audit
ORDER BY audit_id DESC
FETCH FIRST 10 ROWS ONLY;

-- ============================================
-- TEST 12: Display all salary details for current month
-- ============================================
PROMPT 
PROMPT ============================================
PROMPT TEST 12: Display all salary details for current month
PROMPT ============================================

SELECT s.salary_id AS "Salary ID",
       e.emp_id AS "Emp ID",
       e.emp_name AS "Employee Name",
       s.salary_month || '/' || s.salary_year AS "Month/Year",
       s.basic_salary AS "Basic",
       s.hra AS "HRA",
       s.bonus AS "Bonus",
       s.tax AS "Tax",
       s.gross_salary AS "Gross",
       s.net_salary AS "Net Salary"
FROM salary_details s
JOIN employees e ON s.emp_id = e.emp_id
WHERE s.salary_month = EXTRACT(MONTH FROM SYSDATE)
AND s.salary_year = EXTRACT(YEAR FROM SYSDATE)
ORDER BY s.net_salary DESC;

-- ============================================
-- TEST 13: Calculate salary for previous month
-- ============================================
PROMPT 
PROMPT ============================================
PROMPT TEST 13: Calculate salary for previous month (Employee ID 2)
PROMPT ============================================

DECLARE
    v_prev_month NUMBER;
    v_year NUMBER;
BEGIN
    v_prev_month := EXTRACT(MONTH FROM ADD_MONTHS(SYSDATE, -1));
    v_year := EXTRACT(YEAR FROM ADD_MONTHS(SYSDATE, -1));
    
    DBMS_OUTPUT.PUT_LINE('Calculating salary for month: ' || v_prev_month || '/' || v_year);
    payroll_pkg.calculate_salary(2, v_prev_month, v_year);
    payroll_pkg.generate_payslip(2, v_prev_month, v_year);
END;
/

-- ============================================
-- TEST 14: Summary Statistics
-- ============================================
PROMPT 
PROMPT ============================================
PROMPT TEST 14: Summary Statistics
PROMPT ============================================

SELECT 
    COUNT(DISTINCT e.emp_id) AS "Total Employees",
    COUNT(DISTINCT d.dept_id) AS "Total Departments",
    COUNT(s.salary_id) AS "Salary Records (Current Month)",
    SUM(s.net_salary) AS "Total Net Salary",
    ROUND(AVG(s.net_salary), 2) AS "Average Net Salary",
    MAX(s.net_salary) AS "Highest Net Salary",
    MIN(s.net_salary) AS "Lowest Net Salary"
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id
LEFT JOIN salary_details s ON e.emp_id = s.emp_id 
    AND s.salary_month = EXTRACT(MONTH FROM SYSDATE)
    AND s.salary_year = EXTRACT(YEAR FROM SYSDATE);

-- ============================================
-- TEST 15: Department-wise summary
-- ============================================
PROMPT 
PROMPT ============================================
PROMPT TEST 15: Department-wise summary
PROMPT ============================================

SELECT 
    d.dept_name AS "Department",
    COUNT(e.emp_id) AS "Employee Count",
    SUM(s.net_salary) AS "Total Net Salary",
    ROUND(AVG(s.net_salary), 2) AS "Average Net Salary"
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id
LEFT JOIN salary_details s ON e.emp_id = s.emp_id 
    AND s.salary_month = EXTRACT(MONTH FROM SYSDATE)
    AND s.salary_year = EXTRACT(YEAR FROM SYSDATE)
GROUP BY d.dept_name
ORDER BY SUM(s.net_salary) DESC NULLS LAST;

PROMPT 
PROMPT ============================================
PROMPT ALL TESTS COMPLETED!
PROMPT ============================================

