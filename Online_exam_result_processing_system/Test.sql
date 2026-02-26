-- =====================================================
-- Test Script for Online Examination Result Processing System
-- =====================================================

SET SERVEROUTPUT ON;

-- Enable DBMS_OUTPUT
BEGIN
    DBMS_OUTPUT.ENABLE(1000000);
END;
/

-- =====================================================
-- Test 1: Display All Students
-- =====================================================

PROMPT ========================================
PROMPT Test 1: Display All Students
PROMPT ========================================

SELECT student_id, student_name, email, TO_CHAR(date_of_birth, 'DD-MON-YYYY') AS dob, enrollment_date
FROM students
ORDER BY student_id;

-- =====================================================
-- Test 2: Display All Subjects
-- =====================================================

PROMPT 
PROMPT ========================================
PROMPT Test 2: Display All Subjects
PROMPT ========================================

SELECT subject_id, subject_name, max_marks, passing_marks
FROM subjects
ORDER BY subject_id;

-- =====================================================
-- Test 3: Display Marks for All Students
-- ========================================

PROMPT 
PROMPT ========================================
PROMPT Test 3: Display Marks for All Students
PROMPT ========================================

SELECT s.student_id, s.student_name, sub.subject_name, m.marks_obtained, sub.passing_marks,
       CASE WHEN m.marks_obtained >= sub.passing_marks THEN 'PASS' ELSE 'FAIL' END AS subject_status
FROM students s
JOIN marks m ON s.student_id = m.student_id
JOIN subjects sub ON m.subject_id = sub.subject_id
ORDER BY s.student_id, sub.subject_id;

-- =====================================================
-- Test 4: Test Grade Calculation Function
-- =====================================================

PROMPT 
PROMPT ========================================
PROMPT Test 4: Test Grade Calculation Function
PROMPT ========================================

DECLARE
    v_grade VARCHAR2(2);
BEGIN
    DBMS_OUTPUT.PUT_LINE('Testing Grade Calculation Function:');
    DBMS_OUTPUT.PUT_LINE('-----------------------------------');
    
    -- Test various percentages
    v_grade := calculate_grade(95);
    DBMS_OUTPUT.PUT_LINE('95% -> Grade: ' || v_grade);
    
    v_grade := calculate_grade(85);
    DBMS_OUTPUT.PUT_LINE('85% -> Grade: ' || v_grade);
    
    v_grade := calculate_grade(75);
    DBMS_OUTPUT.PUT_LINE('75% -> Grade: ' || v_grade);
    
    v_grade := calculate_grade(65);
    DBMS_OUTPUT.PUT_LINE('65% -> Grade: ' || v_grade);
    
    v_grade := calculate_grade(55);
    DBMS_OUTPUT.PUT_LINE('55% -> Grade: ' || v_grade);
    
    v_grade := calculate_grade(45);
    DBMS_OUTPUT.PUT_LINE('45% -> Grade: ' || v_grade);
    
    v_grade := calculate_grade(35);
    DBMS_OUTPUT.PUT_LINE('35% -> Grade: ' || v_grade);
    
    DBMS_OUTPUT.PUT_LINE('');
END;
/

-- =====================================================
-- Test 5: Display Results (Before Processing)
-- =====================================================

PROMPT 
PROMPT ========================================
PROMPT Test 5: Display Current Results
PROMPT ========================================

SELECT r.student_id, s.student_name, r.total_marks, r.percentage, r.grade, 
       r.rank_position, r.status, TO_CHAR(r.published_date, 'DD-MON-YYYY HH24:MI:SS') AS published
FROM results r
JOIN students s ON r.student_id = s.student_id
ORDER BY r.rank_position NULLS LAST, r.percentage DESC;

-- =====================================================
-- Test 6: Test Result Processing Procedure
-- =====================================================

PROMPT 
PROMPT ========================================
PROMPT Test 6: Re-process Results
PROMPT ========================================

BEGIN
    process_results;
    DBMS_OUTPUT.PUT_LINE('Results processed successfully');
END;
/

-- =====================================================
-- Test 7: Test Rank Generation
-- =====================================================

PROMPT 
PROMPT ========================================
PROMPT Test 7: Generate Ranks
PROMPT ========================================

BEGIN
    generate_ranks;
    DBMS_OUTPUT.PUT_LINE('Ranks generated successfully');
END;
/

-- =====================================================
-- Test 8: Display Results After Processing
-- =====================================================

PROMPT 
PROMPT ========================================
PROMPT Test 8: Display Results After Processing
PROMPT ========================================

SELECT r.student_id, s.student_name, r.total_marks, r.percentage, r.grade, 
       r.rank_position, r.status, TO_CHAR(r.published_date, 'DD-MON-YYYY HH24:MI:SS') AS published
FROM results r
JOIN students s ON r.student_id = s.student_id
ORDER BY r.rank_position NULLS LAST, r.percentage DESC;

-- =====================================================
-- Test 9: Test Trigger - Insert New Marks
-- =====================================================

PROMPT 
PROMPT ========================================
PROMPT Test 9: Test Trigger - Update Marks for Student ID 1
PROMPT ========================================

DECLARE
    v_student_id NUMBER := 1;
    v_subject_id NUMBER;
BEGIN
    -- Get first subject ID
    SELECT subject_id INTO v_subject_id FROM subjects WHERE subject_name = 'Maths';
    
    -- Update marks to test trigger
    UPDATE marks 
    SET marks_obtained = 95
    WHERE student_id = v_student_id AND subject_id = v_subject_id;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Marks updated for Student ID ' || v_student_id || ' in Maths');
    DBMS_OUTPUT.PUT_LINE('Trigger should have automatically updated the result');
END;
/

-- Check result after trigger execution
SELECT r.student_id, s.student_name, r.total_marks, r.percentage, r.grade, r.status
FROM results r
JOIN students s ON r.student_id = s.student_id
WHERE r.student_id = 1;

-- =====================================================
-- Test 10: Student-wise Mark Summary
-- =====================================================

PROMPT 
PROMPT ========================================
PROMPT Test 10: Student-wise Mark Summary
PROMPT ========================================

SELECT 
    s.student_id,
    s.student_name,
    SUM(m.marks_obtained) AS total_marks,
    ROUND(AVG(m.marks_obtained), 2) AS average_marks,
    MIN(m.marks_obtained) AS lowest_marks,
    MAX(m.marks_obtained) AS highest_marks,
    COUNT(*) AS subjects_count
FROM students s
JOIN marks m ON s.student_id = m.student_id
GROUP BY s.student_id, s.student_name
ORDER BY total_marks DESC;

-- =====================================================
-- Test 11: Subject-wise Statistics
-- =====================================================

PROMPT 
PROMPT ========================================
PROMPT Test 11: Subject-wise Statistics
PROMPT ========================================

SELECT 
    sub.subject_name,
    COUNT(*) AS total_students,
    ROUND(AVG(m.marks_obtained), 2) AS average_marks,
    MIN(m.marks_obtained) AS lowest_marks,
    MAX(m.marks_obtained) AS highest_marks,
    COUNT(CASE WHEN m.marks_obtained >= sub.passing_marks THEN 1 END) AS pass_count,
    COUNT(CASE WHEN m.marks_obtained < sub.passing_marks THEN 1 END) AS fail_count
FROM subjects sub
JOIN marks m ON sub.subject_id = m.subject_id
GROUP BY sub.subject_name, sub.passing_marks
ORDER BY sub.subject_name;

-- =====================================================
-- Test 12: Pass/Fail Statistics
-- =====================================================

PROMPT 
PROMPT ========================================
PROMPT Test 12: Overall Pass/Fail Statistics
PROMPT ========================================

SELECT 
    status,
    COUNT(*) AS student_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM results), 2) AS percentage
FROM results
GROUP BY status
ORDER BY status;

-- =====================================================
-- Test 13: Top 5 Students
-- =====================================================

PROMPT 
PROMPT ========================================
PROMPT Test 13: Top 5 Students
PROMPT ========================================

SELECT 
    r.rank_position,
    s.student_name,
    r.total_marks,
    r.percentage,
    r.grade,
    r.status
FROM results r
JOIN students s ON r.student_id = s.student_id
WHERE r.status = 'PASS' AND r.rank_position IS NOT NULL
ORDER BY r.rank_position
FETCH FIRST 5 ROWS ONLY;

-- =====================================================
-- Test 14: Failed Students
-- =====================================================

PROMPT 
PROMPT ========================================
PROMPT Test 14: Failed Students
PROMPT ========================================

SELECT 
    s.student_id,
    s.student_name,
    r.total_marks,
    r.percentage,
    r.grade,
    r.status
FROM results r
JOIN students s ON r.student_id = s.student_id
WHERE r.status = 'FAIL'
ORDER BY r.percentage DESC;

-- =====================================================
-- Test 15: Grade Distribution
-- =====================================================

PROMPT 
PROMPT ========================================
PROMPT Test 15: Grade Distribution
PROMPT ========================================

SELECT 
    grade,
    COUNT(*) AS student_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM results WHERE status = 'PASS'), 2) AS percentage
FROM results
WHERE status = 'PASS'
GROUP BY grade
ORDER BY 
    CASE grade
        WHEN 'A+' THEN 1
        WHEN 'A' THEN 2
        WHEN 'B+' THEN 3
        WHEN 'B' THEN 4
        WHEN 'C+' THEN 5
        WHEN 'C' THEN 6
        ELSE 7
    END;

-- =====================================================
-- Test 16: Exception Handling Test - Invalid Marks
-- =====================================================

PROMPT 
PROMPT ========================================
PROMPT Test 16: Exception Handling Test - Invalid Marks (Should Fail)
PROMPT ========================================

BEGIN
    -- Try to insert invalid marks (should fail due to CHECK constraint)
    BEGIN
        INSERT INTO marks (mark_id, student_id, subject_id, marks_obtained)
        VALUES (seq_mark_id.NEXTVAL, 1, 1, 150);
        
        DBMS_OUTPUT.PUT_LINE('ERROR: Invalid marks were inserted (should not happen)');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Exception caught (Expected): ' || SQLERRM);
    END;
    
    -- Try to insert negative marks (should fail)
    BEGIN
        INSERT INTO marks (mark_id, student_id, subject_id, marks_obtained)
        VALUES (seq_mark_id.NEXTVAL, 1, 1, -10);
        
        DBMS_OUTPUT.PUT_LINE('ERROR: Negative marks were inserted (should not happen)');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Exception caught (Expected): ' || SQLERRM);
    END;
END;
/

-- =====================================================
-- Test 17: Detailed Result Card for a Specific Student
-- =====================================================

PROMPT 
PROMPT ========================================
PROMPT Test 17: Detailed Result Card for Student ID 1
PROMPT ========================================

SELECT 
    s.student_name,
    sub.subject_name,
    m.marks_obtained,
    sub.max_marks,
    sub.passing_marks,
    CASE WHEN m.marks_obtained >= sub.passing_marks THEN 'PASS' ELSE 'FAIL' END AS subject_status
FROM students s
JOIN marks m ON s.student_id = m.student_id
JOIN subjects sub ON m.subject_id = sub.subject_id
WHERE s.student_id = 1
ORDER BY sub.subject_id;

-- Display overall result
SELECT 
    s.student_name,
    r.total_marks,
    r.percentage,
    r.grade,
    r.rank_position,
    r.status,
    TO_CHAR(r.published_date, 'DD-MON-YYYY HH24:MI:SS') AS published_date
FROM results r
JOIN students s ON r.student_id = s.student_id
WHERE r.student_id = 1;

-- =====================================================
-- Test 18: Test Publish Results Procedure
-- =====================================================

PROMPT 
PROMPT ========================================
PROMPT Test 18: Publish Results
PROMPT ========================================

BEGIN
    -- Clear published dates first
    UPDATE results SET published_date = NULL;
    COMMIT;
    
    publish_results;
    DBMS_OUTPUT.PUT_LINE('Results published successfully');
END;
/

-- Verify published results
SELECT 
    s.student_name,
    r.percentage,
    r.grade,
    r.rank_position,
    r.status,
    TO_CHAR(r.published_date, 'DD-MON-YYYY HH24:MI:SS') AS published_date
FROM results r
JOIN students s ON r.student_id = s.student_id
WHERE r.published_date IS NOT NULL
ORDER BY r.rank_position NULLS LAST;

PROMPT 
PROMPT ========================================
PROMPT All Tests Completed!
PROMPT ========================================

