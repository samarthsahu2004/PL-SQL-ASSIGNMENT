-- 08_seed_data.sql
-- Seed departments and ~50 employees with Indian names / realistic sample data.

USE DATABASE EMP_MGMT_DB;
USE SCHEMA EMP_MGMT;

-- Seed departments
INSERT INTO DEPARTMENTS (DEPARTMENT_ID, DEPARTMENT_NAME, LOCATION) VALUES
  (10, 'Human Resources', 'Bengaluru'),
  (20, 'Finance', 'Mumbai'),
  (30, 'Information Technology', 'Hyderabad'),
  (40, 'Sales', 'Delhi'),
  (50, 'Marketing', 'Bengaluru'),
  (60, 'Operations', 'Pune'),
  (70, 'Research & Development', 'Chennai'),
  (80, 'Customer Support', 'Noida'),
  (90, 'Administration', 'Kolkata'),
  (100, 'Training', 'Gurugram');

-- Seed employees (explicit IDs for clarity; align with SEQ_EMPLOYEE_ID start if needed)
INSERT INTO EMPLOYEES (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, SALARY, DEPARTMENT_ID, HIRE_DATE) VALUES
  (1001, 'Amit', 'Sharma', 'amit.sharma@example.com', 65000, 30, '2019-04-15'),
  (1002, 'Priya', 'Verma', 'priya.verma@example.com', 72000, 20, '2018-07-10'),
  (1003, 'Rahul', 'Gupta', 'rahul.gupta@example.com', 55000, 40, '2020-01-20'),
  (1004, 'Neha', 'Reddy', 'neha.reddy@example.com', 60000, 30, '2021-03-05'),
  (1005, 'Sanjay', 'Iyer', 'sanjay.iyer@example.com', 48000, 10, '2017-11-01'),
  (1006, 'Kiran', 'Patel', 'kiran.patel@example.com', 53000, 60, '2019-09-18'),
  (1007, 'Deepa', 'Menon', 'deepa.menon@example.com', 58000, 50, '2020-06-22'),
  (1008, 'Vikram', 'Singh', 'vikram.singh@example.com', 90000, 30, '2016-02-12'),
  (1009, 'Anjali', 'Jain', 'anjali.jain@example.com', 47000, 80, '2021-08-30'),
  (1010, 'Rohit', 'Kumar', 'rohit.kumar@example.com', 52000, 40, '2019-12-01'),
  (1011, 'Sneha', 'Bhatt', 'sneha.bhatt@example.com', 61000, 50, '2018-05-19'),
  (1012, 'Manish', 'Naidu', 'manish.naidu@example.com', 75000, 70, '2017-09-25'),
  (1013, 'Pooja', 'Desai', 'pooja.desai@example.com', 54000, 10, '2020-10-10'),
  (1014, 'Arjun', 'Chopra', 'arjun.chopra@example.com', 83000, 30, '2015-12-05'),
  (1015, 'Lakshmi', 'Nair', 'lakshmi.nair@example.com', 49500, 80, '2022-01-15'),
  (1016, 'Gaurav', 'Saxena', 'gaurav.saxena@example.com', 68000, 60, '2018-03-08'),
  (1017, 'Divya', 'Kulkarni', 'divya.kulkarni@example.com', 72500, 20, '2019-07-27'),
  (1018, 'Harsh', 'Srivastava', 'harsh.srivastava@example.com', 51000, 40, '2021-09-03'),
  (1019, 'Meera', 'Rao', 'meera.rao@example.com', 63000, 50, '2018-11-11'),
  (1020, 'Nitin', 'Mishra', 'nitin.mishra@example.com', 58500, 10, '2020-02-29'),
  (1021, 'Shreya', 'Bansal', 'shreya.bansal@example.com', 70500, 70, '2016-06-17'),
  (1022, 'Aditya', 'Joshi', 'aditya.joshi@example.com', 66000, 30, '2019-01-09'),
  (1023, 'Ritika', 'Soni', 'ritika.soni@example.com', 49000, 80, '2020-04-21'),
  (1024, 'Varun', 'Rastogi', 'varun.rastogi@example.com', 56000, 60, '2018-08-14'),
  (1025, 'Ananya', 'Mukherjee', 'ananya.mukherjee@example.com', 62000, 50, '2017-10-02'),
  (1026, 'Suresh', 'Pillai', 'suresh.pillai@example.com', 78000, 20, '2015-03-19'),
  (1027, 'Rohini', 'Khatri', 'rohini.khatri@example.com', 53000, 40, '2021-01-07'),
  (1028, 'Tarun', 'Bose', 'tarun.bose@example.com', 60000, 60, '2019-05-30'),
  (1029, 'Kavita', 'Shukla', 'kavita.shukla@example.com', 51500, 10, '2020-09-19'),
  (1030, 'Yogesh', 'Aggarwal', 'yogesh.aggarwal@example.com', 84500, 30, '2016-11-23'),
  (1031, 'Isha', 'Malhotra', 'isha.malhotra@example.com', 57500, 50, '2018-12-29'),
  (1032, 'Sachin', 'Banerjee', 'sachin.banerjee@example.com', 69000, 70, '2017-07-06'),
  (1033, 'Nandini', 'Ghosh', 'nandini.ghosh@example.com', 50500, 80, '2021-06-01'),
  (1034, 'Vivek', 'Chandra', 'vivek.chandra@example.com', 72000, 20, '2019-03-25'),
  (1035, 'Pallavi', 'Dhar', 'pallavi.dhar@example.com', 54000, 40, '2020-01-31'),
  (1036, 'Ashish', 'Rana', 'ashish.rana@example.com', 59500, 60, '2018-04-04'),
  (1037, 'Monika', 'Kaur', 'monika.kaur@example.com', 61000, 50, '2017-02-18'),
  (1038, 'Raghav', 'Kaushik', 'raghav.kaushik@example.com', 88000, 30, '2015-09-09'),
  (1039, 'Smita', 'Yadav', 'smita.yadav@example.com', 52500, 80, '2022-02-02'),
  (1040, 'Abhishek', 'Chauhan', 'abhishek.chauhan@example.com', 64000, 10, '2019-10-15'),
  (1041, 'Kriti', 'Lal', 'kriti.lal@example.com', 73500, 70, '2016-01-28'),
  (1042, 'Dev', 'Thakur', 'dev.thakur@example.com', 56500, 40, '2020-05-13'),
  (1043, 'Renu', 'Sethi', 'renu.sethi@example.com', 60500, 60, '2018-09-07'),
  (1044, 'Mohan', 'Sridhar', 'mohan.sridhar@example.com', 69500, 20, '2017-06-20'),
  (1045, 'Sarika', 'Rawat', 'sarika.rawat@example.com', 51500, 50, '2021-03-16'),
  (1046, 'Parag', 'Kapoor', 'parag.kapoor@example.com', 73500, 30, '2016-08-08'),
  (1047, 'Jaya', 'Krishnan', 'jaya.krishnan@example.com', 55500, 80, '2020-11-24'),
  (1048, 'Imran', 'Ansari', 'imran.ansari@example.com', 58500, 60, '2019-02-05'),
  (1049, 'Bhavna', 'Tripathi', 'bhavna.tripathi@example.com', 62500, 10, '2018-01-12'),
  (1050, 'Rakesh', 'Dubey', 'rakesh.dubey@example.com', 77000, 20, '2015-04-28');

