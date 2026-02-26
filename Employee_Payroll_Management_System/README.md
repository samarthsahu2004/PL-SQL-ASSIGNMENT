# Employee Payroll Management System

A comprehensive PL/SQL-based Employee Payroll Management System designed for HR and Corporate domains. This system automates salary calculations, generates payslips, and provides department-wise salary reports.

## 📋 Table of Contents

- [Features](#features)
- [Database Schema](#database-schema)
- [PL/SQL Concepts Used](#plsql-concepts-used)
- [Installation](#installation)
- [Usage](#usage)
- [File Structure](#file-structure)
- [Database Objects](#database-objects)
- [Examples](#examples)

## ✨ Features

- **Employee Details Management**: Add and manage employee information including name, email, phone, hire date, department, designation, and basic salary
- **Salary Calculation**: Automated calculation of:
  - Basic Salary
  - HRA (House Rent Allowance) - 40% of basic salary
  - Bonus - 10% of basic salary
  - Tax (based on Indian tax slabs)
  - Gross Salary (Basic + HRA + Bonus)
  - Net Salary (Gross Salary - Tax)
- **Monthly Payslip Generation**: Generate detailed payslips for any employee for any month
- **Department-wise Salary Report**: Generate comprehensive reports showing all employees in a department with their salary details
- **Salary Audit Trail**: Automatic tracking of all salary changes through triggers

## 🗄️ Database Schema

### Tables

#### 1. `departments`
Stores department information.

| Column | Type | Description |
|--------|------|-------------|
| dept_id | NUMBER | Primary Key |
| dept_name | VARCHAR2(50) | Department name |
| location | VARCHAR2(100) | Department location |
| manager_id | NUMBER | Manager employee ID |

#### 2. `employees`
Stores employee information.

| Column | Type | Description |
|--------|------|-------------|
| emp_id | NUMBER | Primary Key |
| emp_name | VARCHAR2(100) | Employee name |
| email | VARCHAR2(100) | Email address (Unique) |
| phone | VARCHAR2(15) | Phone number |
| hire_date | DATE | Date of hire |
| dept_id | NUMBER | Foreign Key to departments |
| designation | VARCHAR2(50) | Job designation |
| basic_salary | NUMBER(10,2) | Basic salary amount |

#### 3. `salary_details`
Stores monthly salary calculations for each employee.

| Column | Type | Description |
|--------|------|-------------|
| salary_id | NUMBER | Primary Key |
| emp_id | NUMBER | Foreign Key to employees |
| salary_month | NUMBER(2) | Month (1-12) |
| salary_year | NUMBER(4) | Year |
| basic_salary | NUMBER(10,2) | Basic salary |
| hra | NUMBER(10,2) | House Rent Allowance |
| bonus | NUMBER(10,2) | Bonus amount |
| tax | NUMBER(10,2) | Tax deducted |
| gross_salary | NUMBER(10,2) | Gross salary (Basic + HRA + Bonus) |
| net_salary | NUMBER(10,2) | Net salary (Gross - Tax) |
| pay_date | DATE | Date of salary calculation |

#### 4. `salary_audit`
Stores audit trail of salary changes (populated by trigger).

| Column | Type | Description |
|--------|------|-------------|
| audit_id | NUMBER | Primary Key |
| emp_id | NUMBER | Employee ID |
| old_salary | NUMBER(10,2) | Previous salary |
| new_salary | NUMBER(10,2) | New salary |
| changed_by | VARCHAR2(100) | User who made the change |
| change_date | DATE | Date and time of change |
| change_type | VARCHAR2(20) | Type of change (INSERT/UPDATE) |

## 🔧 PL/SQL Concepts Used

### 1. **Packages** (`payroll_pkg`)
The system uses a package to group related procedures and functions:
- **Package Specification**: Declares all public procedures and functions
- **Package Body**: Contains the implementation of all procedures and functions

### 2. **Procedures**
- `calculate_salary`: Calculates and stores salary for an employee for a specific month
- `generate_payslip`: Generates and displays a detailed payslip
- `department_salary_report`: Generates department-wise salary report using cursors
- `add_employee`: Adds a new employee to the system
- `add_department`: Adds a new department to the system

### 3. **Functions**
- `calculate_tax`: Calculates tax based on Indian tax slabs (simplified):
  - 0% for annual salary ≤ ₹2,50,000
  - 5% for annual salary ₹2,50,001 - ₹5,00,000
  - 20% for annual salary ₹5,00,001 - ₹10,00,000
  - 30% for annual salary > ₹10,00,000

### 4. **Cursors**
- Used in `department_salary_report` procedure to iterate through employees and generate reports

### 5. **Triggers**
- `audit_salary_changes`: Automatically tracks all salary changes (INSERT/UPDATE) in the `salary_audit` table

### 6. **Indexes**
The system includes multiple indexes for performance optimization:
- `idx_emp_dept`: Index on employees(dept_id)
- `idx_emp_email`: Index on employees(email)
- `idx_salary_emp`: Index on salary_details(emp_id)
- `idx_salary_month_year`: Index on salary_details(salary_month, salary_year)
- `idx_emp_hire_date`: Index on employees(hire_date)
- `idx_salary_composite`: Composite index on salary_details(emp_id, salary_year, salary_month)

## 🚀 Installation

### Prerequisites
- Oracle Database (11g or higher)
- SQL*Plus or SQL Developer
- Database user with necessary privileges

### Setup Steps

1. **Connect to Oracle Database**:
   ```sql
   CONNECT username/password@database;
   ```

2. **Grant Required Privileges** (if needed):
   ```sql
   GRANT CONNECT, RESOURCE TO your_user;
   GRANT CREATE SESSION TO your_user;
   GRANT CREATE TABLE TO your_user;
   GRANT CREATE PROCEDURE TO your_user;
   GRANT CREATE FUNCTION TO your_user;
   GRANT CREATE PACKAGE TO your_user;
   GRANT CREATE TRIGGER TO your_user;
   GRANT CREATE SEQUENCE TO your_user;
   GRANT UNLIMITED TABLESPACE TO your_user;
   ```

3. **Run the Main Script**:
   ```sql
   @Main.sql
   ```
   Or using SQL*Plus:
   ```bash
   sqlplus username/password@database @Main.sql
   ```

4. **Run the Test Script** (Optional):
   ```sql
   @Test.sql
   ```

## 📖 Usage

### Enable Server Output
```sql
SET SERVEROUTPUT ON;
```

### Calculate Salary for an Employee
```sql
BEGIN
    payroll_pkg.calculate_salary(
        p_emp_id => 1,                    -- Employee ID
        p_salary_month => 12,             -- Month (1-12)
        p_salary_year => 2024             -- Year
    );
END;
/
```

### Generate Payslip
```sql
BEGIN
    payroll_pkg.generate_payslip(
        p_emp_id => 1,                    -- Employee ID
        p_salary_month => 12,             -- Month (1-12)
        p_salary_year => 2024             -- Year
    );
END;
/
```

### Generate Department Salary Report
```sql
BEGIN
    payroll_pkg.department_salary_report(
        p_dept_id => 2,                   -- Department ID
        p_salary_month => 12,             -- Month (1-12)
        p_salary_year => 2024             -- Year
    );
END;
/
```

### Add New Employee
```sql
BEGIN
    payroll_pkg.add_employee(
        p_emp_name => 'Rajesh Kumar',
        p_email => 'rajesh.kumar@company.com',
        p_phone => '9876543210',
        p_hire_date => SYSDATE,
        p_dept_id => 2,                   -- Department ID
        p_designation => 'Software Engineer',
        p_basic_salary => 50000
    );
END;
/
```

### Add New Department
```sql
BEGIN
    payroll_pkg.add_department(
        p_dept_name => 'Research & Development',
        p_location => 'Bangalore',
        p_manager_id => NULL              -- Optional manager ID
    );
END;
/
```

### Query Salary Details
```sql
SELECT e.emp_name, s.salary_month, s.salary_year,
       s.basic_salary, s.hra, s.bonus, s.tax,
       s.gross_salary, s.net_salary
FROM salary_details s
JOIN employees e ON s.emp_id = e.emp_id
WHERE s.salary_month = 12
AND s.salary_year = 2024;
```

### View Audit Trail
```sql
SELECT * FROM salary_audit
ORDER BY change_date DESC;
```

## 📁 File Structure

```
Employee_Payroll_Management_System/
├── Main.sql          # Main PL/SQL script with all database objects
├── Test.sql          # Test script to verify functionality
└── README.md         # This file
```

## 🗃️ Database Objects

### Sequences
- `dept_seq`: For department IDs
- `emp_seq`: For employee IDs
- `salary_seq`: For salary detail IDs
- `audit_seq`: For audit record IDs

### Package
- `payroll_pkg`: Main package containing all business logic

### Trigger
- `audit_salary_changes`: Audit trigger on employees table

## 📊 Sample Data

The system comes pre-loaded with:
- **6 Departments**: Human Resources, Information Technology, Finance, Marketing, Operations, Sales
- **14+ Employees**: With Indian names and various designations
- **Sample Salary Records**: For the current month

### Sample Departments
1. Human Resources (Mumbai)
2. Information Technology (Bangalore)
3. Finance (Delhi)
4. Marketing (Pune)
5. Operations (Hyderabad)
6. Sales (Chennai)

### Sample Employees (Indian Names)
- Rajesh Kumar, Priya Sharma, Amit Patel (IT)
- Sunita Reddy, Vikram Singh (HR)
- Anjali Desai, Rohit Gupta (Finance)
- Neha Verma, Karan Malhotra (Marketing)
- Deepak Joshi, Meera Nair (Operations)
- Arjun Iyer, Kavita Rao (Sales)
- And more...

## 💡 Examples

### Example 1: Calculate Salary for Current Month
```sql
DECLARE
    v_month NUMBER := EXTRACT(MONTH FROM SYSDATE);
    v_year NUMBER := EXTRACT(YEAR FROM SYSDATE);
BEGIN
    payroll_pkg.calculate_salary(1, v_month, v_year);
END;
/
```

### Example 2: Generate Payslip for All Employees
```sql
DECLARE
    v_month NUMBER := EXTRACT(MONTH FROM SYSDATE);
    v_year NUMBER := EXTRACT(YEAR FROM SYSDATE);
    CURSOR c_emp IS SELECT emp_id FROM employees;
BEGIN
    FOR emp_rec IN c_emp LOOP
        payroll_pkg.generate_payslip(emp_rec.emp_id, v_month, v_year);
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END;
/
```

### Example 3: Generate Reports for All Departments
```sql
DECLARE
    v_month NUMBER := EXTRACT(MONTH FROM SYSDATE);
    v_year NUMBER := EXTRACT(YEAR FROM SYSDATE);
    CURSOR c_dept IS SELECT dept_id FROM departments;
BEGIN
    FOR dept_rec IN c_dept LOOP
        payroll_pkg.department_salary_report(dept_rec.dept_id, v_month, v_year);
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END;
/
```

## 🔍 Tax Calculation Details

The tax calculation follows a simplified version of Indian income tax slabs:
- **Annual Income ≤ ₹2,50,000**: No tax
- **Annual Income ₹2,50,001 - ₹5,00,000**: 5% tax on amount above ₹2,50,000
- **Annual Income ₹5,00,001 - ₹10,00,000**: ₹12,500 + 20% tax on amount above ₹5,00,000
- **Annual Income > ₹10,00,000**: ₹1,12,500 + 30% tax on amount above ₹10,00,000

The function converts monthly gross salary to annual, calculates annual tax, and returns monthly tax amount.

## 🎯 Key Features Summary

- ✅ Complete employee management
- ✅ Automated salary calculations (Basic + HRA + Bonus - Tax)
- ✅ Indian tax slab implementation
- ✅ Monthly payslip generation
- ✅ Department-wise reporting with cursors
- ✅ Audit trail for salary changes
- ✅ Performance optimization with indexes
- ✅ Sample data with Indian names (14+ employees)
- ✅ Comprehensive error handling
- ✅ Beginner-friendly code structure

## 📝 Notes

- The system uses simplified tax calculations for educational purposes
- HRA is calculated as 40% of basic salary (configurable in the code)
- Bonus is calculated as 10% of basic salary (configurable in the code)
- All monetary values are in Indian Rupees (₹)
- The system maintains referential integrity through foreign keys
- Indexes are created to optimize query performance

## 🤝 Contributing

This is a beginner-level project. Feel free to extend it with:
- Additional salary components (DA, PF, etc.)
- More complex tax calculations
- Employee leave management
- Salary history tracking
- Export functionality for reports

## 📄 License

This project is created for educational purposes.

---

**Created for PL/SQL Learning and Practice**

For questions or issues, please review the code comments in `Main.sql` for detailed explanations.

