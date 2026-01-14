-- =====================================================
-- Online Examination Result Processing System
-- Domain: Education
-- =====================================================

-- Drop existing tables if they exist (in reverse order of dependencies)
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE results CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE marks CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE subjects CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE students CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

-- =====================================================
-- Table Creation
-- =====================================================

-- Students Table
CREATE TABLE students (
    student_id NUMBER PRIMARY KEY,
    student_name VARCHAR2(100) NOT NULL,
    email VARCHAR2(100) UNIQUE NOT NULL,
    date_of_birth DATE NOT NULL,
    phone_number VARCHAR2(15),
    address VARCHAR2(200),
    enrollment_date DATE DEFAULT SYSDATE
);

-- Subjects Table
CREATE TABLE subjects (
    subject_id NUMBER PRIMARY KEY,
    subject_name VARCHAR2(50) UNIQUE NOT NULL,
    max_marks NUMBER DEFAULT 100,
    passing_marks NUMBER DEFAULT 40
);

-- Marks Table
CREATE TABLE marks (
    mark_id NUMBER PRIMARY KEY,
    student_id NUMBER NOT NULL,
    subject_id NUMBER NOT NULL,
    marks_obtained NUMBER NOT NULL,
    exam_date DATE DEFAULT SYSDATE,
    CONSTRAINT fk_marks_student FOREIGN KEY (student_id) REFERENCES students(student_id),
    CONSTRAINT fk_marks_subject FOREIGN KEY (subject_id) REFERENCES subjects(subject_id),
    CONSTRAINT chk_marks_range CHECK (marks_obtained >= 0 AND marks_obtained <= 100)
);

-- Results Table
CREATE TABLE results (
    result_id NUMBER PRIMARY KEY,
    student_id NUMBER UNIQUE NOT NULL,
    total_marks NUMBER DEFAULT 0,
    percentage NUMBER(5,2) DEFAULT 0,
    grade VARCHAR2(2),
    rank_position NUMBER,
    status VARCHAR2(10) DEFAULT 'PENDING',
    published_date DATE,
    CONSTRAINT fk_results_student FOREIGN KEY (student_id) REFERENCES students(student_id),
    CONSTRAINT chk_status CHECK (status IN ('PASS', 'FAIL', 'PENDING'))
);

-- =====================================================
-- Sequence Creation
-- =====================================================

CREATE SEQUENCE seq_student_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_subject_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_mark_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_result_id START WITH 1 INCREMENT BY 1;

-- =====================================================
-- Insert Subjects Data
-- =====================================================

INSERT INTO subjects (subject_id, subject_name, max_marks, passing_marks) VALUES (seq_subject_id.NEXTVAL, 'Maths', 100, 40);
INSERT INTO subjects (subject_id, subject_name, max_marks, passing_marks) VALUES (seq_subject_id.NEXTVAL, 'Physics', 100, 40);
INSERT INTO subjects (subject_id, subject_name, max_marks, passing_marks) VALUES (seq_subject_id.NEXTVAL, 'Chemistry', 100, 40);
INSERT INTO subjects (subject_id, subject_name, max_marks, passing_marks) VALUES (seq_subject_id.NEXTVAL, 'English', 100, 40);
INSERT INTO subjects (subject_id, subject_name, max_marks, passing_marks) VALUES (seq_subject_id.NEXTVAL, 'Biology', 100, 40);
COMMIT;

-- =====================================================
-- Insert Students Data (Indian Names)
-- =====================================================

INSERT INTO students (student_id, student_name, email, date_of_birth, phone_number, address, enrollment_date) 
VALUES (seq_student_id.NEXTVAL, 'Arjun Sharma', 'arjun.sharma@email.com', TO_DATE('2000-05-15', 'YYYY-MM-DD'), '9876543210', 'Mumbai, Maharashtra', SYSDATE);

INSERT INTO students (student_id, student_name, email, date_of_birth, phone_number, address, enrollment_date) 
VALUES (seq_student_id.NEXTVAL, 'Priya Patel', 'priya.patel@email.com', TO_DATE('2001-08-20', 'YYYY-MM-DD'), '9876543211', 'Ahmedabad, Gujarat', SYSDATE);

INSERT INTO students (student_id, student_name, email, date_of_birth, phone_number, address, enrollment_date) 
VALUES (seq_student_id.NEXTVAL, 'Rahul Kumar', 'rahul.kumar@email.com', TO_DATE('2000-03-10', 'YYYY-MM-DD'), '9876543212', 'Delhi, NCR', SYSDATE);

INSERT INTO students (student_id, student_name, email, date_of_birth, phone_number, address, enrollment_date) 
VALUES (seq_student_id.NEXTVAL, 'Kavya Reddy', 'kavya.reddy@email.com', TO_DATE('2001-11-25', 'YYYY-MM-DD'), '9876543213', 'Hyderabad, Telangana', SYSDATE);

INSERT INTO students (student_id, student_name, email, date_of_birth, phone_number, address, enrollment_date) 
VALUES (seq_student_id.NEXTVAL, 'Vikram Singh', 'vikram.singh@email.com', TO_DATE('2000-07-18', 'YYYY-MM-DD'), '9876543214', 'Pune, Maharashtra', SYSDATE);

INSERT INTO students (student_id, student_name, email, date_of_birth, phone_number, address, enrollment_date) 
VALUES (seq_student_id.NEXTVAL, 'Ananya Desai', 'ananya.desai@email.com', TO_DATE('2001-09-12', 'YYYY-MM-DD'), '9876543215', 'Bangalore, Karnataka', SYSDATE);

INSERT INTO students (student_id, student_name, email, date_of_birth, phone_number, address, enrollment_date) 
VALUES (seq_student_id.NEXTVAL, 'Aditya Nair', 'aditya.nair@email.com', TO_DATE('2000-04-30', 'YYYY-MM-DD'), '9876543216', 'Chennai, Tamil Nadu', SYSDATE);

INSERT INTO students (student_id, student_name, email, date_of_birth, phone_number, address, enrollment_date) 
VALUES (seq_student_id.NEXTVAL, 'Meera Iyer', 'meera.iyer@email.com', TO_DATE('2001-06-22', 'YYYY-MM-DD'), '9876543217', 'Kochi, Kerala', SYSDATE);

INSERT INTO students (student_id, student_name, email, date_of_birth, phone_number, address, enrollment_date) 
VALUES (seq_student_id.NEXTVAL, 'Rohan Gupta', 'rohan.gupta@email.com', TO_DATE('2000-12-05', 'YYYY-MM-DD'), '9876543218', 'Kolkata, West Bengal', SYSDATE);

INSERT INTO students (student_id, student_name, email, date_of_birth, phone_number, address, enrollment_date) 
VALUES (seq_student_id.NEXTVAL, 'Sneha Joshi', 'sneha.joshi@email.com', TO_DATE('2001-02-14', 'YYYY-MM-DD'), '9876543219', 'Jaipur, Rajasthan', SYSDATE);

INSERT INTO students (student_id, student_name, email, date_of_birth, phone_number, address, enrollment_date) 
VALUES (seq_student_id.NEXTVAL, 'Karan Malhotra', 'karan.malhotra@email.com', TO_DATE('2000-10-08', 'YYYY-MM-DD'), '9876543220', 'Chandigarh, Punjab', SYSDATE);

INSERT INTO students (student_id, student_name, email, date_of_birth, phone_number, address, enrollment_date) 
VALUES (seq_student_id.NEXTVAL, 'Divya Menon', 'divya.menon@email.com', TO_DATE('2001-01-19', 'YYYY-MM-DD'), '9876543221', 'Trivandrum, Kerala', SYSDATE);
COMMIT;

-- =====================================================
-- Insert Marks Data (for all students in all subjects)
-- =====================================================

DECLARE
    v_student_id NUMBER;
    v_subject_id NUMBER;
    v_marks NUMBER;
    CURSOR c_students IS SELECT student_id FROM students;
    CURSOR c_subjects IS SELECT subject_id FROM subjects ORDER BY subject_id;
BEGIN
    FOR stud_rec IN c_students LOOP
        v_student_id := stud_rec.student_id;
        
        -- Generate different marks for each student
        FOR subj_rec IN c_subjects LOOP
            v_subject_id := subj_rec.subject_id;
            
            -- Generate marks between 30-95 based on student_id for variety
            v_marks := 30 + MOD(v_student_id * 7 + v_subject_id * 3, 66);
            
            INSERT INTO marks (mark_id, student_id, subject_id, marks_obtained, exam_date)
            VALUES (seq_mark_id.NEXTVAL, v_student_id, v_subject_id, v_marks, SYSDATE);
        END LOOP;
    END LOOP;
    COMMIT;
END;
/

-- =====================================================
-- Function: Calculate Grade
-- =====================================================

CREATE OR REPLACE FUNCTION calculate_grade(p_percentage NUMBER) 
RETURN VARCHAR2
IS
    v_grade VARCHAR2(2);
BEGIN
    IF p_percentage >= 90 THEN
        v_grade := 'A+';
    ELSIF p_percentage >= 80 THEN
        v_grade := 'A';
    ELSIF p_percentage >= 70 THEN
        v_grade := 'B+';
    ELSIF p_percentage >= 60 THEN
        v_grade := 'B';
    ELSIF p_percentage >= 50 THEN
        v_grade := 'C+';
    ELSIF p_percentage >= 40 THEN
        v_grade := 'C';
    ELSE
        v_grade := 'F';
    END IF;
    
    RETURN v_grade;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'N/A';
END;
/

-- =====================================================
-- Procedure: Process Results
-- =====================================================

CREATE OR REPLACE PROCEDURE process_results
IS
    v_student_id NUMBER;
    v_total_marks NUMBER;
    v_percentage NUMBER;
    v_grade VARCHAR2(2);
    v_status VARCHAR2(10);
    v_subject_count NUMBER;
    v_failed_subjects NUMBER := 0;
    
    CURSOR c_students IS 
        SELECT DISTINCT student_id 
        FROM marks 
        ORDER BY student_id;
        
    CURSOR c_marks(p_stud_id NUMBER) IS
        SELECT marks_obtained, s.passing_marks
        FROM marks m
        JOIN subjects s ON m.subject_id = s.subject_id
        WHERE m.student_id = p_stud_id;
BEGIN
    -- Clear existing results
    DELETE FROM results;
    COMMIT;
    
    -- Process each student
    FOR stud_rec IN c_students LOOP
        v_student_id := stud_rec.student_id;
        v_total_marks := 0;
        v_subject_count := 0;
        v_failed_subjects := 0;
        
        -- Calculate total marks and check for failed subjects
        FOR mark_rec IN c_marks(v_student_id) LOOP
            v_total_marks := v_total_marks + mark_rec.marks_obtained;
            v_subject_count := v_subject_count + 1;
            
            IF mark_rec.marks_obtained < mark_rec.passing_marks THEN
                v_failed_subjects := v_failed_subjects + 1;
            END IF;
        END LOOP;
        
        -- Calculate percentage (assuming 5 subjects * 100 = 500 total)
        v_percentage := (v_total_marks / (v_subject_count * 100)) * 100;
        
        -- Get grade
        v_grade := calculate_grade(v_percentage);
        
        -- Determine pass/fail status
        IF v_failed_subjects = 0 AND v_percentage >= 40 THEN
            v_status := 'PASS';
        ELSE
            v_status := 'FAIL';
        END IF;
        
        -- Insert or update result
        INSERT INTO results (result_id, student_id, total_marks, percentage, grade, status)
        VALUES (seq_result_id.NEXTVAL, v_student_id, v_total_marks, v_percentage, v_grade, v_status);
        
    END LOOP;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Results processed successfully for all students');
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in process_results: ' || SQLERRM);
        ROLLBACK;
        RAISE;
END;
/

-- =====================================================
-- Procedure: Generate Ranks
-- =====================================================

CREATE OR REPLACE PROCEDURE generate_ranks
IS
    v_rank NUMBER := 1;
    v_prev_percentage NUMBER := -1;
    v_prev_rank NUMBER := 0;
    
    CURSOR c_results IS
        SELECT student_id, percentage
        FROM results
        WHERE status = 'PASS'
        ORDER BY percentage DESC, student_id ASC;
        
BEGIN
    FOR result_rec IN c_results LOOP
        -- Handle ties (same percentage gets same rank)
        IF result_rec.percentage = v_prev_percentage THEN
            v_rank := v_prev_rank;
        ELSE
            v_prev_rank := v_rank;
        END IF;
        
        UPDATE results
        SET rank_position = v_rank
        WHERE student_id = result_rec.student_id;
        
        v_prev_percentage := result_rec.percentage;
        v_rank := v_rank + 1;
    END LOOP;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Ranks generated successfully');
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in generate_ranks: ' || SQLERRM);
        ROLLBACK;
        RAISE;
END;
/

-- =====================================================
-- Procedure: Publish Results
-- =====================================================

CREATE OR REPLACE PROCEDURE publish_results
IS
BEGIN
    UPDATE results
    SET published_date = SYSDATE
    WHERE published_date IS NULL;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Results published successfully');
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in publish_results: ' || SQLERRM);
        ROLLBACK;
        RAISE;
END;
/

-- =====================================================
-- Trigger: Auto Update Result Status on Marks Insert/Update
-- =====================================================

CREATE OR REPLACE TRIGGER trg_auto_update_result
AFTER INSERT OR UPDATE ON marks
FOR EACH ROW
DECLARE
    v_student_id NUMBER;
    v_total_marks NUMBER;
    v_percentage NUMBER;
    v_grade VARCHAR2(2);
    v_status VARCHAR2(10);
    v_subject_count NUMBER;
    v_failed_subjects NUMBER := 0;
    v_passing_marks NUMBER;
    
    CURSOR c_marks(p_stud_id NUMBER) IS
        SELECT marks_obtained, s.passing_marks
        FROM marks m
        JOIN subjects s ON m.subject_id = s.subject_id
        WHERE m.student_id = p_stud_id;
BEGIN
    v_student_id := :NEW.student_id;
    v_total_marks := 0;
    v_subject_count := 0;
    v_failed_subjects := 0;
    
    -- Calculate total marks and check for failed subjects
    FOR mark_rec IN c_marks(v_student_id) LOOP
        v_total_marks := v_total_marks + mark_rec.marks_obtained;
        v_subject_count := v_subject_count + 1;
        
        IF mark_rec.marks_obtained < mark_rec.passing_marks THEN
            v_failed_subjects := v_failed_subjects + 1;
        END IF;
    END LOOP;
    
    -- Calculate percentage
    IF v_subject_count > 0 THEN
        v_percentage := (v_total_marks / (v_subject_count * 100)) * 100;
    ELSE
        v_percentage := 0;
    END IF;
    
    -- Get grade
    v_grade := calculate_grade(v_percentage);
    
    -- Determine pass/fail status
    IF v_failed_subjects = 0 AND v_percentage >= 40 THEN
        v_status := 'PASS';
    ELSE
        v_status := 'FAIL';
    END IF;
    
    -- Update or insert result
    UPDATE results
    SET total_marks = v_total_marks,
        percentage = v_percentage,
        grade = v_grade,
        status = v_status
    WHERE student_id = v_student_id;
    
    IF SQL%ROWCOUNT = 0 THEN
        INSERT INTO results (result_id, student_id, total_marks, percentage, grade, status)
        VALUES (seq_result_id.NEXTVAL, v_student_id, v_total_marks, v_percentage, v_grade, v_status);
    END IF;
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in trigger: ' || SQLERRM);
END;
/

-- =====================================================
-- Initial Data Processing
-- =====================================================

BEGIN
    process_results;
    generate_ranks;
    publish_results;
    DBMS_OUTPUT.PUT_LINE('All initial processing completed successfully');
END;
/

-- =====================================================
-- End of Main.sql
-- =====================================================

