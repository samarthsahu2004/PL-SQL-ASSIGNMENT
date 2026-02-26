# Online Examination Result Processing System

A comprehensive PL/SQL-based system for managing and processing online examination results in an educational institution. This system automates the entire result processing workflow including mark storage, grade calculation, pass/fail determination, rank generation, and result publishing.

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Database Schema](#database-schema)
- [PL/SQL Components](#plsql-components)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [Testing](#testing)
- [Database Tables](#database-tables)
- [Sample Data](#sample-data)
- [File Structure](#file-structure)

## 🎯 Overview

This system is designed to handle the complete lifecycle of examination result processing:

- **Student Management**: Store and manage student information
- **Mark Entry**: Record marks for multiple subjects
- **Result Calculation**: Automatically calculate grades, percentages, and pass/fail status
- **Ranking System**: Generate ranks for students based on performance
- **Result Publishing**: Publish results with timestamps
- **Automated Updates**: Trigger-based automatic result updates when marks change

**Domain**: Education  
**Database**: Oracle PL/SQL

## ✨ Features

### Core Features
- ✅ Store student marks for multiple subjects
- ✅ Automatic grade calculation (A+, A, B+, B, C+, C, F)
- ✅ Pass/fail logic with subject-wise validation
- ✅ Rank generation with tie-handling
- ✅ Result publishing with timestamps
- ✅ Real-time result updates via triggers

### PL/SQL Concepts Implemented
- **Functions**: Grade calculation based on percentage
- **Procedures**: Result processing, rank generation, result publishing
- **Cursors**: Iterative rank assignment logic
- **Triggers**: Auto-update result status on mark changes
- **Exception Handling**: Comprehensive error handling throughout

## 🗄️ Database Schema

### Tables

#### 1. `students`
Stores student personal information.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| student_id | NUMBER | PRIMARY KEY | Unique student identifier |
| student_name | VARCHAR2(100) | NOT NULL | Student's full name |
| email | VARCHAR2(100) | UNIQUE, NOT NULL | Student email address |
| date_of_birth | DATE | NOT NULL | Date of birth |
| phone_number | VARCHAR2(15) | | Contact number |
| address | VARCHAR2(200) | | Residential address |
| enrollment_date | DATE | DEFAULT SYSDATE | Enrollment timestamp |

#### 2. `subjects`
Contains subject information.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| subject_id | NUMBER | PRIMARY KEY | Unique subject identifier |
| subject_name | VARCHAR2(50) | UNIQUE, NOT NULL | Subject name |
| max_marks | NUMBER | DEFAULT 100 | Maximum marks for the subject |
| passing_marks | NUMBER | DEFAULT 40 | Minimum marks to pass |

**Subjects**: Maths, Physics, Chemistry, English, Biology

#### 3. `marks`
Stores individual subject marks for each student.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| mark_id | NUMBER | PRIMARY KEY | Unique mark identifier |
| student_id | NUMBER | FOREIGN KEY → students | Reference to student |
| subject_id | NUMBER | FOREIGN KEY → subjects | Reference to subject |
| marks_obtained | NUMBER | NOT NULL, CHECK (0-100) | Marks scored |
| exam_date | DATE | DEFAULT SYSDATE | Examination date |

#### 4. `results`
Stores calculated results for each student.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| result_id | NUMBER | PRIMARY KEY | Unique result identifier |
| student_id | NUMBER | FOREIGN KEY → students, UNIQUE | Reference to student |
| total_marks | NUMBER | DEFAULT 0 | Sum of all subject marks |
| percentage | NUMBER(5,2) | DEFAULT 0 | Overall percentage |
| grade | VARCHAR2(2) | | Calculated grade (A+, A, B+, B, C+, C, F) |
| rank_position | NUMBER | | Rank among passed students |
| status | VARCHAR2(10) | CHECK (PASS/FAIL/PENDING) | Pass or fail status |
| published_date | DATE | | Result publication timestamp |

### Sequences

- `seq_student_id`: Auto-increment for student IDs
- `seq_subject_id`: Auto-increment for subject IDs
- `seq_mark_id`: Auto-increment for mark IDs
- `seq_result_id`: Auto-increment for result IDs

## 🔧 PL/SQL Components

### 1. Function: `calculate_grade(p_percentage NUMBER)`

Calculates the grade based on percentage.

**Grade Scale:**
- A+ : ≥ 90%
- A  : ≥ 80%
- B+ : ≥ 70%
- B  : ≥ 60%
- C+ : ≥ 50%
- C  : ≥ 40%
- F  : < 40%

**Returns:** VARCHAR2(2) - Grade letter

**Exception Handling:** Returns 'N/A' on error

### 2. Procedure: `process_results`

Processes results for all students:
- Calculates total marks across all subjects
- Computes percentage
- Determines grade using `calculate_grade()` function
- Checks pass/fail status (fails if any subject marks < passing marks or overall < 40%)
- Inserts/updates results table

**Exception Handling:** Rolls back on error and displays error message

### 3. Procedure: `generate_ranks`

Generates ranks for passed students:
- Uses cursor to iterate through students ordered by percentage
- Handles ties (same percentage gets same rank)
- Updates rank_position in results table

**Exception Handling:** Rolls back on error

### 4. Procedure: `publish_results`

Publishes results by setting the published_date:
- Updates published_date to SYSDATE for all unpublished results

**Exception Handling:** Rolls back on error

### 5. Trigger: `trg_auto_update_result`

Automatically updates results when marks are inserted or updated:
- Fires AFTER INSERT OR UPDATE on `marks` table
- Recalculates total marks, percentage, grade, and status
- Updates existing result or inserts new one if not exists

**Exception Handling:** Logs errors without failing the transaction

## 📦 Prerequisites

- Oracle Database 11g or higher
- SQL*Plus or SQL Developer
- Database user with CREATE TABLE, CREATE SEQUENCE, CREATE PROCEDURE, CREATE FUNCTION, CREATE TRIGGER privileges

## 🚀 Installation

1. **Connect to Oracle Database**
   ```sql
   sqlplus username/password@database
   ```

2. **Run the main script**
   ```sql
   @Main.sql
   ```
   Or in SQL Developer, open and execute `Main.sql`

3. **Verify Installation**
   ```sql
   SELECT COUNT(*) FROM students;  -- Should return 12
   SELECT COUNT(*) FROM subjects;  -- Should return 5
   SELECT COUNT(*) FROM marks;     -- Should return 60 (12 students × 5 subjects)
   SELECT COUNT(*) FROM results;   -- Should return 12
   ```

## 💻 Usage

### Manual Result Processing

```sql
-- Process all results
EXEC process_results;

-- Generate ranks
EXEC generate_ranks;

-- Publish results
EXEC publish_results;
```

### View Results

```sql
-- View all results with student names
SELECT r.student_id, s.student_name, r.total_marks, r.percentage, 
       r.grade, r.rank_position, r.status
FROM results r
JOIN students s ON r.student_id = s.student_id
ORDER BY r.rank_position NULLS LAST, r.percentage DESC;
```

### Add New Marks

```sql
-- Insert new marks (trigger will auto-update results)
INSERT INTO marks (mark_id, student_id, subject_id, marks_obtained)
VALUES (seq_mark_id.NEXTVAL, 1, 1, 85);

COMMIT;
```

### Update Marks

```sql
-- Update existing marks (trigger will auto-update results)
UPDATE marks 
SET marks_obtained = 92
WHERE student_id = 1 AND subject_id = 1;

COMMIT;
```

### Get Student Result Card

```sql
-- Detailed result card for a student
SELECT 
    s.student_name,
    sub.subject_name,
    m.marks_obtained,
    sub.max_marks,
    CASE WHEN m.marks_obtained >= sub.passing_marks THEN 'PASS' ELSE 'FAIL' END AS status
FROM students s
JOIN marks m ON s.student_id = m.student_id
JOIN subjects sub ON m.subject_id = sub.subject_id
WHERE s.student_id = 1
ORDER BY sub.subject_id;
```

## 🧪 Testing

Run the comprehensive test suite:

```sql
@Test.sql
```

The test file includes 18 test cases covering:

1. Display all students
2. Display all subjects
3. Display marks for all students
4. Test grade calculation function
5. Display current results
6. Test result processing procedure
7. Test rank generation
8. Display results after processing
9. Test trigger functionality
10. Student-wise mark summary
11. Subject-wise statistics
12. Overall pass/fail statistics
13. Top 5 students
14. Failed students list
15. Grade distribution
16. Exception handling tests
17. Detailed result card
18. Result publishing test

## 📊 Sample Data

The system comes pre-populated with:

- **12 Students** with Indian names:
  - Arjun Sharma, Priya Patel, Rahul Kumar, Kavya Reddy, Vikram Singh
  - Ananya Desai, Aditya Nair, Meera Iyer, Rohan Gupta, Sneha Joshi
  - Karan Malhotra, Divya Menon

- **5 Subjects**:
  - Maths, Physics, Chemistry, English, Biology

- **60 Mark Entries** (12 students × 5 subjects)

- **12 Results** (automatically calculated)

## 📁 File Structure

```
PL.SQL/
├── Main.sql          # Main system file (creates schema, procedures, functions, triggers)
├── Test.sql          # Comprehensive test suite
└── README.md         # This file
```

## 🔍 Key Features Explained

### Grade Calculation Logic

Grades are assigned based on overall percentage:
- All subjects must have marks ≥ passing marks (40) to pass a subject
- Overall percentage must be ≥ 40% to pass
- Grade is based on percentage ranges (see Function section above)

### Ranking Logic

- Only passed students receive ranks
- Students with same percentage get the same rank
- Next rank skips the number of students with the same rank
- Example: If two students tie at rank 1, next student gets rank 3

### Pass/Fail Criteria

A student passes if:
1. All individual subject marks ≥ subject passing marks (40)
2. Overall percentage ≥ 40%

A student fails if:
1. Any subject marks < passing marks, OR
2. Overall percentage < 40%

## 🛠️ Maintenance

### Adding New Students

```sql
INSERT INTO students (student_id, student_name, email, date_of_birth, phone_number, address)
VALUES (seq_student_id.NEXTVAL, 'New Student', 'new@email.com', TO_DATE('2000-01-01', 'YYYY-MM-DD'), 
        '9999999999', 'City, State');
COMMIT;
```

### Adding New Subjects

```sql
INSERT INTO subjects (subject_id, subject_name, max_marks, passing_marks)
VALUES (seq_subject_id.NEXTVAL, 'Computer Science', 100, 40);
COMMIT;
```

### Recalculating Results

Simply run:
```sql
EXEC process_results;
EXEC generate_ranks;
EXEC publish_results;
```

Or update any mark - the trigger will automatically recalculate results.

## ⚠️ Important Notes

1. **Marks Constraint**: Marks must be between 0 and 100 (enforced by CHECK constraint)
2. **Foreign Keys**: Cannot delete students/subjects that have associated marks/results
3. **Trigger Behavior**: The trigger automatically updates results when marks change
4. **Rank Regeneration**: Ranks should be regenerated after any mark changes for accuracy

## 📝 License

This project is created for educational purposes.

## 👨‍💻 Author

PL/SQL Online Examination Result Processing System

---

**Happy Coding! 🎓**

