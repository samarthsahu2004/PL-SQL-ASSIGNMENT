-- ============================================
-- EMPLOYEE PAYROLL MANAGEMENT SYSTEM
-- Domain: HR / Corporate
-- ============================================
-- This script creates all tables, packages, procedures, functions, triggers, and indexes
-- for the Employee Payroll Management System
-- ============================================

SET SERVEROUTPUT ON;

-- ============================================
-- STEP 1: DROP EXISTING OBJECTS (IF ANY)
-- ============================================
BEGIN
    -- Drop triggers first
    EXECUTE IMMEDIATE 'DROP TRIGGER audit_salary_changes';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP PACKAGE payroll_pkg';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE salary_details';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE employees';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE salary_audit';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE departments';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

-- Drop sequences
BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE audit_seq';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE salary_seq';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE emp_seq';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE dept_seq';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

-- ============================================
-- STEP 2: CREATE TABLES
-- ============================================

-- Departments Table
CREATE TABLE departments (
    dept_id NUMBER PRIMARY KEY,
    dept_name VARCHAR2(50) NOT NULL,
    location VARCHAR2(100),
    manager_id NUMBER
);
/

-- Employees Table
CREATE TABLE employees (
    emp_id NUMBER PRIMARY KEY,
    emp_name VARCHAR2(100) NOT NULL,
    email VARCHAR2(100) UNIQUE,
    phone VARCHAR2(15),
    hire_date DATE NOT NULL,
    dept_id NUMBER NOT NULL,
    designation VARCHAR2(50),
    basic_salary NUMBER(10,2) NOT NULL CHECK (basic_salary > 0),
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);
/

-- Salary Details Table
CREATE TABLE salary_details (
    salary_id NUMBER PRIMARY KEY,
    emp_id NUMBER NOT NULL,
    salary_month NUMBER(2) NOT NULL CHECK (salary_month BETWEEN 1 AND 12),
    salary_year NUMBER(4) NOT NULL,
    basic_salary NUMBER(10,2) NOT NULL,
    hra NUMBER(10,2) DEFAULT 0,
    bonus NUMBER(10,2) DEFAULT 0,
    tax NUMBER(10,2) DEFAULT 0,
    gross_salary NUMBER(10,2),
    net_salary NUMBER(10,2),
    pay_date DATE,
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id),
    UNIQUE(emp_id, salary_month, salary_year)
);
/

-- Salary Audit Table (for trigger)
CREATE TABLE salary_audit (
    audit_id NUMBER PRIMARY KEY,
    emp_id NUMBER,
    old_salary NUMBER(10,2),
    new_salary NUMBER(10,2),
    changed_by VARCHAR2(100),
    change_date DATE,
    change_type VARCHAR2(20)
);
/

-- ============================================
-- STEP 3: CREATE SEQUENCES
-- ============================================

CREATE SEQUENCE dept_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE emp_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE salary_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE audit_seq START WITH 1 INCREMENT BY 1;
/

-- ============================================
-- STEP 4: CREATE INDEXES
-- ============================================

-- Index on employees for department lookups
CREATE INDEX idx_emp_dept ON employees(dept_id);
/

-- Index on employees for email lookups
CREATE INDEX idx_emp_email ON employees(email);
/

-- Index on salary_details for employee lookups
CREATE INDEX idx_salary_emp ON salary_details(emp_id);
/

-- Index on salary_details for month/year queries
CREATE INDEX idx_salary_month_year ON salary_details(salary_month, salary_year);
/

-- Index on employees hire_date for date range queries
CREATE INDEX idx_emp_hire_date ON employees(hire_date);
/

-- Composite index on salary_details for efficient reporting
CREATE INDEX idx_salary_composite ON salary_details(emp_id, salary_year, salary_month);
/

-- ============================================
-- STEP 5: CREATE PACKAGE SPECIFICATION
-- ============================================

CREATE OR REPLACE PACKAGE payroll_pkg AS
    -- Function to calculate tax based on gross salary
    FUNCTION calculate_tax(p_gross_salary NUMBER) RETURN NUMBER;
    
    -- Procedure to calculate salary for an employee
    PROCEDURE calculate_salary(
        p_emp_id NUMBER,
        p_salary_month NUMBER,
        p_salary_year NUMBER
    );
    
    -- Procedure to generate monthly payslip
    PROCEDURE generate_payslip(
        p_emp_id NUMBER,
        p_salary_month NUMBER,
        p_salary_year NUMBER
    );
    
    -- Procedure to generate department-wise salary report
    PROCEDURE department_salary_report(
        p_dept_id NUMBER,
        p_salary_month NUMBER,
        p_salary_year NUMBER
    );
    
    -- Procedure to add employee
    PROCEDURE add_employee(
        p_emp_name VARCHAR2,
        p_email VARCHAR2,
        p_phone VARCHAR2,
        p_hire_date DATE,
        p_dept_id NUMBER,
        p_designation VARCHAR2,
        p_basic_salary NUMBER
    );
    
    -- Procedure to add department
    PROCEDURE add_department(
        p_dept_name VARCHAR2,
        p_location VARCHAR2,
        p_manager_id NUMBER DEFAULT NULL
    );
END payroll_pkg;
/

-- ============================================
-- STEP 6: CREATE PACKAGE BODY
-- ============================================

CREATE OR REPLACE PACKAGE BODY payroll_pkg AS
    
    -- Function to calculate tax (Indian tax slabs simplified)
    FUNCTION calculate_tax(p_gross_salary NUMBER) RETURN NUMBER IS
        v_tax NUMBER := 0;
        v_annual_salary NUMBER;
    BEGIN
        -- Convert monthly to annual for tax calculation
        v_annual_salary := p_gross_salary * 12;
        
        -- Tax calculation (simplified Indian tax structure)
        IF v_annual_salary <= 250000 THEN
            v_tax := 0;
        ELSIF v_annual_salary <= 500000 THEN
            v_tax := (v_annual_salary - 250000) * 0.05;
        ELSIF v_annual_salary <= 1000000 THEN
            v_tax := 12500 + (v_annual_salary - 500000) * 0.20;
        ELSE
            v_tax := 112500 + (v_annual_salary - 1000000) * 0.30;
        END IF;
        
        -- Return monthly tax
        RETURN ROUND(v_tax / 12, 2);
    END calculate_tax;
    
    -- Procedure to calculate salary
    PROCEDURE calculate_salary(
        p_emp_id NUMBER,
        p_salary_month NUMBER,
        p_salary_year NUMBER
    ) IS
        v_basic_salary NUMBER;
        v_hra NUMBER;
        v_bonus NUMBER;
        v_gross_salary NUMBER;
        v_tax NUMBER;
        v_net_salary NUMBER;
        v_count NUMBER;
    BEGIN
        -- Get employee basic salary
        SELECT basic_salary INTO v_basic_salary
        FROM employees
        WHERE emp_id = p_emp_id;
        
        -- Calculate HRA (40% of basic salary)
        v_hra := v_basic_salary * 0.40;
        
        -- Calculate bonus (10% of basic salary for this example)
        v_bonus := v_basic_salary * 0.10;
        
        -- Calculate gross salary
        v_gross_salary := v_basic_salary + v_hra + v_bonus;
        
        -- Calculate tax
        v_tax := calculate_tax(v_gross_salary);
        
        -- Calculate net salary
        v_net_salary := v_gross_salary - v_tax;
        
        -- Check if salary record already exists
        SELECT COUNT(*) INTO v_count
        FROM salary_details
        WHERE emp_id = p_emp_id
        AND salary_month = p_salary_month
        AND salary_year = p_salary_year;
        
        IF v_count > 0 THEN
            -- Update existing record
            UPDATE salary_details
            SET basic_salary = v_basic_salary,
                hra = v_hra,
                bonus = v_bonus,
                tax = v_tax,
                gross_salary = v_gross_salary,
                net_salary = v_net_salary,
                pay_date = SYSDATE
            WHERE emp_id = p_emp_id
            AND salary_month = p_salary_month
            AND salary_year = p_salary_year;
            
            DBMS_OUTPUT.PUT_LINE('Salary updated for Employee ID: ' || p_emp_id);
        ELSE
            -- Insert new record
            INSERT INTO salary_details (
                salary_id, emp_id, salary_month, salary_year,
                basic_salary, hra, bonus, tax,
                gross_salary, net_salary, pay_date
            ) VALUES (
                salary_seq.NEXTVAL, p_emp_id, p_salary_month, p_salary_year,
                v_basic_salary, v_hra, v_bonus, v_tax,
                v_gross_salary, v_net_salary, SYSDATE
            );
            
            DBMS_OUTPUT.PUT_LINE('Salary calculated and saved for Employee ID: ' || p_emp_id);
        END IF;
        
        COMMIT;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Error: Employee ID ' || p_emp_id || ' not found');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error calculating salary: ' || SQLERRM);
            ROLLBACK;
    END calculate_salary;
    
    -- Procedure to generate payslip
    PROCEDURE generate_payslip(
        p_emp_id NUMBER,
        p_salary_month NUMBER,
        p_salary_year NUMBER
    ) IS
        v_emp_name VARCHAR2(100);
        v_dept_name VARCHAR2(50);
        v_designation VARCHAR2(50);
        v_basic_salary NUMBER;
        v_hra NUMBER;
        v_bonus NUMBER;
        v_tax NUMBER;
        v_gross_salary NUMBER;
        v_net_salary NUMBER;
        v_month_name VARCHAR2(20);
    BEGIN
        -- Get employee and salary details
        SELECT e.emp_name, d.dept_name, e.designation,
               s.basic_salary, s.hra, s.bonus, s.tax,
               s.gross_salary, s.net_salary
        INTO v_emp_name, v_dept_name, v_designation,
             v_basic_salary, v_hra, v_bonus, v_tax,
             v_gross_salary, v_net_salary
        FROM employees e
        JOIN departments d ON e.dept_id = d.dept_id
        JOIN salary_details s ON e.emp_id = s.emp_id
        WHERE e.emp_id = p_emp_id
        AND s.salary_month = p_salary_month
        AND s.salary_year = p_salary_year;
        
        -- Get month name
        SELECT TO_CHAR(TO_DATE(p_salary_month, 'MM'), 'Month') INTO v_month_name FROM DUAL;
        
        -- Display payslip
        DBMS_OUTPUT.PUT_LINE('========================================');
        DBMS_OUTPUT.PUT_LINE('           PAYSLIP');
        DBMS_OUTPUT.PUT_LINE('========================================');
        DBMS_OUTPUT.PUT_LINE('Employee ID: ' || p_emp_id);
        DBMS_OUTPUT.PUT_LINE('Employee Name: ' || v_emp_name);
        DBMS_OUTPUT.PUT_LINE('Department: ' || v_dept_name);
        DBMS_OUTPUT.PUT_LINE('Designation: ' || v_designation);
        DBMS_OUTPUT.PUT_LINE('Month: ' || RTRIM(v_month_name) || ' ' || p_salary_year);
        DBMS_OUTPUT.PUT_LINE('----------------------------------------');
        DBMS_OUTPUT.PUT_LINE('EARNINGS:');
        DBMS_OUTPUT.PUT_LINE('  Basic Salary:    Rs. ' || TO_CHAR(v_basic_salary, '999,999.99'));
        DBMS_OUTPUT.PUT_LINE('  HRA:             Rs. ' || TO_CHAR(v_hra, '999,999.99'));
        DBMS_OUTPUT.PUT_LINE('  Bonus:           Rs. ' || TO_CHAR(v_bonus, '999,999.99'));
        DBMS_OUTPUT.PUT_LINE('  Gross Salary:    Rs. ' || TO_CHAR(v_gross_salary, '999,999.99'));
        DBMS_OUTPUT.PUT_LINE('----------------------------------------');
        DBMS_OUTPUT.PUT_LINE('DEDUCTIONS:');
        DBMS_OUTPUT.PUT_LINE('  Tax:             Rs. ' || TO_CHAR(v_tax, '999,999.99'));
        DBMS_OUTPUT.PUT_LINE('----------------------------------------');
        DBMS_OUTPUT.PUT_LINE('NET SALARY:        Rs. ' || TO_CHAR(v_net_salary, '999,999.99'));
        DBMS_OUTPUT.PUT_LINE('========================================');
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Error: Salary details not found for Employee ID ' || p_emp_id || 
                                ' for ' || p_salary_month || '/' || p_salary_year);
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error generating payslip: ' || SQLERRM);
    END generate_payslip;
    
    -- Procedure to generate department-wise salary report using cursor
    PROCEDURE department_salary_report(
        p_dept_id NUMBER,
        p_salary_month NUMBER,
        p_salary_year NUMBER
    ) IS
        CURSOR c_dept_salary IS
            SELECT e.emp_id, e.emp_name, e.designation,
                   s.basic_salary, s.hra, s.bonus, s.tax,
                   s.gross_salary, s.net_salary
            FROM employees e
            JOIN salary_details s ON e.emp_id = s.emp_id
            WHERE e.dept_id = p_dept_id
            AND s.salary_month = p_salary_month
            AND s.salary_year = p_salary_year
            ORDER BY s.net_salary DESC;
        
        v_dept_name VARCHAR2(50);
        v_total_net_salary NUMBER := 0;
        v_emp_count NUMBER := 0;
        v_month_name VARCHAR2(20);
    BEGIN
        -- Get department name
        SELECT dept_name INTO v_dept_name
        FROM departments
        WHERE dept_id = p_dept_id;
        
        -- Get month name
        SELECT TO_CHAR(TO_DATE(p_salary_month, 'MM'), 'Month') INTO v_month_name FROM DUAL;
        
        DBMS_OUTPUT.PUT_LINE('========================================');
        DBMS_OUTPUT.PUT_LINE('   DEPARTMENT SALARY REPORT');
        DBMS_OUTPUT.PUT_LINE('========================================');
        DBMS_OUTPUT.PUT_LINE('Department: ' || v_dept_name);
        DBMS_OUTPUT.PUT_LINE('Month: ' || RTRIM(v_month_name) || ' ' || p_salary_year);
        DBMS_OUTPUT.PUT_LINE('----------------------------------------');
        DBMS_OUTPUT.PUT_LINE(RPAD('Emp ID', 10) || RPAD('Name', 25) || 
                           RPAD('Designation', 20) || RPAD('Net Salary', 15));
        DBMS_OUTPUT.PUT_LINE('----------------------------------------');
        
        -- Loop through cursor
        FOR rec IN c_dept_salary LOOP
            DBMS_OUTPUT.PUT_LINE(RPAD(rec.emp_id, 10) || 
                               RPAD(rec.emp_name, 25) || 
                               RPAD(rec.designation, 20) || 
                               RPAD('Rs. ' || TO_CHAR(rec.net_salary, '999,999.99'), 15));
            v_total_net_salary := v_total_net_salary + rec.net_salary;
            v_emp_count := v_emp_count + 1;
        END LOOP;
        
        DBMS_OUTPUT.PUT_LINE('----------------------------------------');
        DBMS_OUTPUT.PUT_LINE('Total Employees: ' || v_emp_count);
        DBMS_OUTPUT.PUT_LINE('Total Net Salary: Rs. ' || TO_CHAR(v_total_net_salary, '999,999.99'));
        DBMS_OUTPUT.PUT_LINE('Average Net Salary: Rs. ' || 
                           TO_CHAR(v_total_net_salary / NULLIF(v_emp_count, 0), '999,999.99'));
        DBMS_OUTPUT.PUT_LINE('========================================');
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Error: Department ID ' || p_dept_id || ' not found');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error generating report: ' || SQLERRM);
    END department_salary_report;
    
    -- Procedure to add employee
    PROCEDURE add_employee(
        p_emp_name VARCHAR2,
        p_email VARCHAR2,
        p_phone VARCHAR2,
        p_hire_date DATE,
        p_dept_id NUMBER,
        p_designation VARCHAR2,
        p_basic_salary NUMBER
    ) IS
        v_dept_exists NUMBER;
    BEGIN
        -- Check if department exists
        SELECT COUNT(*) INTO v_dept_exists
        FROM departments
        WHERE dept_id = p_dept_id;
        
        IF v_dept_exists = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Error: Department ID ' || p_dept_id || ' does not exist');
            RETURN;
        END IF;
        
        INSERT INTO employees (
            emp_id, emp_name, email, phone, hire_date,
            dept_id, designation, basic_salary
        ) VALUES (
            emp_seq.NEXTVAL, p_emp_name, p_email, p_phone, p_hire_date,
            p_dept_id, p_designation, p_basic_salary
        );
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Employee added successfully');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error adding employee: ' || SQLERRM);
            ROLLBACK;
    END add_employee;
    
    -- Procedure to add department
    PROCEDURE add_department(
        p_dept_name VARCHAR2,
        p_location VARCHAR2,
        p_manager_id NUMBER DEFAULT NULL
    ) IS
    BEGIN
        INSERT INTO departments (dept_id, dept_name, location, manager_id)
        VALUES (dept_seq.NEXTVAL, p_dept_name, p_location, p_manager_id);
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Department added successfully');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error adding department: ' || SQLERRM);
            ROLLBACK;
    END add_department;
    
END payroll_pkg;
/

-- ============================================
-- STEP 7: CREATE TRIGGER FOR AUDIT
-- ============================================

CREATE OR REPLACE TRIGGER audit_salary_changes
BEFORE UPDATE OR INSERT ON employees
FOR EACH ROW
DECLARE
    v_username VARCHAR2(100);
BEGIN
    -- Get current user
    SELECT USER INTO v_username FROM DUAL;
    
    IF UPDATING THEN
        -- Audit salary changes
        IF :OLD.basic_salary != :NEW.basic_salary THEN
            INSERT INTO salary_audit (
                audit_id, emp_id, old_salary, new_salary,
                changed_by, change_date, change_type
            ) VALUES (
                audit_seq.NEXTVAL, :NEW.emp_id, :OLD.basic_salary, :NEW.basic_salary,
                v_username, SYSDATE, 'UPDATE'
            );
        END IF;
    ELSIF INSERTING THEN
        -- Audit new employee salary
        INSERT INTO salary_audit (
            audit_id, emp_id, old_salary, new_salary,
            changed_by, change_date, change_type
        ) VALUES (
            audit_seq.NEXTVAL, :NEW.emp_id, NULL, :NEW.basic_salary,
            v_username, SYSDATE, 'INSERT'
        );
    END IF;
END;
/

-- ============================================
-- STEP 8: INSERT SAMPLE DATA
-- ============================================

-- Insert Departments
BEGIN
    payroll_pkg.add_department('Human Resources', 'Mumbai');
    payroll_pkg.add_department('Information Technology', 'Bangalore');
    payroll_pkg.add_department('Finance', 'Delhi');
    payroll_pkg.add_department('Marketing', 'Pune');
    payroll_pkg.add_department('Operations', 'Hyderabad');
    payroll_pkg.add_department('Sales', 'Chennai');
END;
/

-- Insert Employees with Indian Names
BEGIN
    -- IT Department
    payroll_pkg.add_employee('Rajesh Kumar', 'rajesh.kumar@company.com', '9876543210', 
                             TO_DATE('2023-01-15', 'YYYY-MM-DD'), 2, 'Software Engineer', 50000);
    payroll_pkg.add_employee('Priya Sharma', 'priya.sharma@company.com', '9876543211', 
                             TO_DATE('2023-02-20', 'YYYY-MM-DD'), 2, 'Senior Developer', 75000);
    payroll_pkg.add_employee('Amit Patel', 'amit.patel@company.com', '9876543212', 
                             TO_DATE('2022-06-10', 'YYYY-MM-DD'), 2, 'Tech Lead', 100000);
    
    -- HR Department
    payroll_pkg.add_employee('Sunita Reddy', 'sunita.reddy@company.com', '9876543213', 
                             TO_DATE('2023-03-05', 'YYYY-MM-DD'), 1, 'HR Executive', 35000);
    payroll_pkg.add_employee('Vikram Singh', 'vikram.singh@company.com', '9876543214', 
                             TO_DATE('2022-08-15', 'YYYY-MM-DD'), 1, 'HR Manager', 80000);
    
    -- Finance Department
    payroll_pkg.add_employee('Anjali Desai', 'anjali.desai@company.com', '9876543215', 
                             TO_DATE('2023-04-01', 'YYYY-MM-DD'), 3, 'Accountant', 40000);
    payroll_pkg.add_employee('Rohit Gupta', 'rohit.gupta@company.com', '9876543216', 
                             TO_DATE('2022-05-20', 'YYYY-MM-DD'), 3, 'Finance Manager', 85000);
    
    -- Marketing Department
    payroll_pkg.add_employee('Neha Verma', 'neha.verma@company.com', '9876543217', 
                             TO_DATE('2023-05-10', 'YYYY-MM-DD'), 4, 'Marketing Executive', 38000);
    payroll_pkg.add_employee('Karan Malhotra', 'karan.malhotra@company.com', '9876543218', 
                             TO_DATE('2022-09-01', 'YYYY-MM-DD'), 4, 'Marketing Manager', 78000);
    
    -- Operations Department
    payroll_pkg.add_employee('Deepak Joshi', 'deepak.joshi@company.com', '9876543219', 
                             TO_DATE('2023-06-15', 'YYYY-MM-DD'), 5, 'Operations Executive', 32000);
    payroll_pkg.add_employee('Meera Nair', 'meera.nair@company.com', '9876543220', 
                             TO_DATE('2022-07-10', 'YYYY-MM-DD'), 5, 'Operations Manager', 72000);
    
    -- Sales Department
    payroll_pkg.add_employee('Arjun Iyer', 'arjun.iyer@company.com', '9876543221', 
                             TO_DATE('2023-07-01', 'YYYY-MM-DD'), 6, 'Sales Executive', 36000);
    payroll_pkg.add_employee('Kavita Rao', 'kavita.rao@company.com', '9876543222', 
                             TO_DATE('2022-10-15', 'YYYY-MM-DD'), 6, 'Sales Manager', 76000);
END;
/

-- Calculate salaries for current month for all employees
DECLARE
    v_current_month NUMBER := EXTRACT(MONTH FROM SYSDATE);
    v_current_year NUMBER := EXTRACT(YEAR FROM SYSDATE);
    CURSOR c_emp IS SELECT emp_id FROM employees;
BEGIN
    FOR emp_rec IN c_emp LOOP
        payroll_pkg.calculate_salary(emp_rec.emp_id, v_current_month, v_current_year);
    END LOOP;
END;
/

-- Display setup completion message
BEGIN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('========================================');
    DBMS_OUTPUT.PUT_LINE('EMPLOYEE PAYROLL MANAGEMENT SYSTEM');
    DBMS_OUTPUT.PUT_LINE('Setup completed successfully!');
    DBMS_OUTPUT.PUT_LINE('========================================');
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('Tables created:');
    DBMS_OUTPUT.PUT_LINE('- departments');
    DBMS_OUTPUT.PUT_LINE('- employees');
    DBMS_OUTPUT.PUT_LINE('- salary_details');
    DBMS_OUTPUT.PUT_LINE('- salary_audit');
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('Package created: payroll_pkg');
    DBMS_OUTPUT.PUT_LINE('Trigger created: audit_salary_changes');
    DBMS_OUTPUT.PUT_LINE('Indexes created: 6 indexes');
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('Sample data inserted:');
    DBMS_OUTPUT.PUT_LINE('- 6 departments');
    DBMS_OUTPUT.PUT_LINE('- 14 employees with Indian names');
    DBMS_OUTPUT.PUT_LINE('- Salary details for current month');
    DBMS_OUTPUT.PUT_LINE('========================================');
END;
/

