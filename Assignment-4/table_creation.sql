/* CONTEXT */
USE ROLE COLLEGE_ADMIN;
USE DATABASE COLLEGE_DB;
USE SCHEMA ACADEMICS;
USE WAREHOUSE COMPUTE_WH;


/* CREATE TABLE */
CREATE OR REPLACE TABLE STUDENT_DETAILS (
    ENROLLMENT_NO     VARCHAR(20)    NOT NULL,
    STUDENT_NAME      VARCHAR(50)    NOT NULL,
    BRANCH_NAME       VARCHAR(30)    NOT NULL,
    YEAR_OF_STUDY     NUMBER(1)      NOT NULL,
    SEMESTER          NUMBER(1)      NOT NULL,
    DATE_OF_BIRTH     DATE,
    EMAIL_ID          VARCHAR(100),
    PHONE_NO          VARCHAR(15),
    ADMISSION_DATE    DATE           DEFAULT CURRENT_DATE,
    STATUS            VARCHAR(10)    DEFAULT 'ACTIVE',
    
    CONSTRAINT PK_STUDENT_DETAILS PRIMARY KEY (ENROLLMENT_NO)
);


/* INSERT SAMPLE DATA */
INSERT INTO STUDENT_DETAILS
(ENROLLMENT_NO, STUDENT_NAME, BRANCH_NAME, YEAR_OF_STUDY, SEMESTER, DATE_OF_BIRTH, EMAIL_ID, PHONE_NO)
VALUES
('0111CS221101', 'Aarav Sharma',   'Computer Science', 3, 5, '2002-05-12', 'aarav.sharma@college.edu', '9876543210'),
('0111AL221102', 'Priya Verma',    'AIML',      2, 3, '2003-09-21', 'priya.verma@college.edu', '9876501234'),
('0111AS221103', 'Rohit Mehta',    'AIDS',       4, 7, '2001-12-10', 'rohit.mehta@college.edu', '9898989898'),
('0111CS221104', 'Neha Singh',     'Computer Science',            1, 1, '2004-03-18', 'neha.singh@college.edu', '9123456780'),
('0111AL221105', 'Karan Patel',    'AIML', 4, 8, '2001-07-25', 'karan.patel@college.edu', '9000011111'),
('0111CS221106', 'Ananya Gupta',   'Computer Science', 2, 4, '2003-01-15', 'ananya.gupta@college.edu', '9812345678'),
('0111AS221107', 'Siddharth Jain', 'AIDS',             3, 6, '2002-08-09', 'siddharth.jain@college.edu', '9823456789'),
('0111AL221108', 'Pooja Nair',     'AIML',             1, 2, '2004-11-23', 'pooja.nair@college.edu', '9834567890'),
('0111CS221109', 'Rahul Khanna',   'Computer Science', 4, 7, '2001-04-05', 'rahul.khanna@college.edu', '9845678901'),
('0111AS221110', 'Meera Iyer',     'AIDS',             2, 3, '2003-06-17', 'meera.iyer@college.edu', '9856789012'),
('0111AL221111', 'Vikram Singh',   'AIML',             3, 5, '2002-02-28', 'vikram.singh@college.edu', '9867890123'),
('0111CS221112', 'Ritika Malhotra','Computer Science', 1, 1, '2004-09-30', 'ritika.malhotra@college.edu', '9878901234'),
('0111AS221113', 'Arjun Rao',      'AIDS',             4, 8, '2001-11-11', 'arjun.rao@college.edu', '9889012345'),
('0111AL221114', 'Sneha Kulkarni', 'AIML',             2, 4, '2003-03-07', 'sneha.kulkarni@college.edu', '9890123456'),
('0111CS221115', 'Mohit Bansal',   'Computer Science', 3, 6, '2002-07-19', 'mohit.bansal@college.edu', '9901234567'),
('0111AS221116', 'Nikhil Verma',     'AIDS', 1, 1, '2004-02-14', 'nikhil.verma@college.edu', '9912345670'),
('0111AS221117', 'Kavya Sharma',     'AIDS', 1, 2, '2004-06-09', 'kavya.sharma@college.edu', '9923456781'),
('0111AS221118', 'Aditya Kulkarni', 'AIDS', 2, 3, '2003-10-21', 'aditya.kulkarni@college.edu', '9934567892'),
('0111AS221119', 'Riya Choudhary',   'AIDS', 2, 4, '2003-01-30', 'riya.choudhary@college.edu', '9945678903'),
('0111AS221120', 'Manish Yadav',     'AIDS', 3, 5, '2002-08-18', 'manish.yadav@college.edu', '9956789014'),
('0111AS221121', 'Ishita Banerjee',  'AIDS', 3, 6, '2002-03-12', 'ishita.banerjee@college.edu', '9967890125'),
('0111AS221122', 'Saurabh Mishra',   'AIDS', 4, 7, '2001-09-05', 'saurabh.mishra@college.edu', '9978901236'),
('0111AS221123', 'Tanvi Deshpande',  'AIDS', 4, 8, '2001-12-27', 'tanvi.deshpande@college.edu', '9989012347');





/* VERIFY DATA */
SELECT * FROM STUDENT_DETAILS;
