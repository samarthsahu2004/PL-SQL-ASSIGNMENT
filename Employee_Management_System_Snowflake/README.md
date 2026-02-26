# Employee Management System (Snowflake)

This project implements an **Employee Management System** in **Snowflake**, including:

- Tables with constraints
- Sequences
- Views
- User-defined functions (UDFs)
- Stored procedures (JavaScript) including cursor/resultset-style processing
- Audit trail for salary changes using **STREAM + TASK**
- Seed data (~50 employees with Indian names) + test script

## How to run (recommended order)

Run these scripts in order (Snowflake Worksheets or SnowSQL):

1. `00_setup.sql`
2. `01_tables.sql`
3. `02_sequences.sql`
4. `03_views.sql`
5. `04_udfs.sql`
6. `05_procedures.sql`
7. `06_streams_tasks.sql`
8. `08_seed_data.sql`
9. `09_tests.sql`

## Notes on Oracle → Snowflake differences

- **Packages / PL/SQL**: Snowflake doesn't support Oracle PL/SQL packages. Here we model the “package” as a schema + a set of stored procedures and UDFs with consistent naming (`EMP_MANAGEMENT__*`).
- **Triggers**: Snowflake doesn’t have row-level triggers. For audit, we use **STREAM + TASK** (captures salary updates even if someone runs ad-hoc `UPDATE`).
- **Indexes**: Snowflake doesn’t use B-tree indexes. For performance we use **clustering keys** (and optionally Search Optimization if needed).

