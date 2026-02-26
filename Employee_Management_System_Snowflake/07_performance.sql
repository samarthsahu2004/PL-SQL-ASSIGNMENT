-- 07_performance.sql
-- Snowflake performance options (no traditional indexes).

USE DATABASE EMP_MGMT_DB;
USE SCHEMA EMP_MGMT;

-- Clustering can help when tables grow large and queries frequently filter by these columns.
-- (Optional: monitor before/after; clustering has compute cost.)
ALTER TABLE EMPLOYEES CLUSTER BY (DEPARTMENT_ID, SALARY);

-- If you frequently search by LAST_NAME case-insensitively:
-- Consider Search Optimization Service (account/edition dependent) instead of a function-based index.
-- ALTER TABLE EMPLOYEES ADD SEARCH OPTIMIZATION;

