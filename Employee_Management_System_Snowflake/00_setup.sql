-- 00_setup.sql
-- Environment bootstrap (edit names as needed).

-- Optional: choose role/warehouse (comment out if your environment manages this externally)
-- USE ROLE SYSADMIN;
-- CREATE WAREHOUSE IF NOT EXISTS WH_EMP_MGMT
--   WAREHOUSE_SIZE = 'XSMALL'
--   AUTO_SUSPEND = 60
--   AUTO_RESUME = TRUE;
-- USE WAREHOUSE WH_EMP_MGMT;

CREATE DATABASE IF NOT EXISTS EMP_MGMT_DB;
CREATE SCHEMA IF NOT EXISTS EMP_MGMT_DB.EMP_MGMT;

USE DATABASE EMP_MGMT_DB;
USE SCHEMA EMP_MGMT;

