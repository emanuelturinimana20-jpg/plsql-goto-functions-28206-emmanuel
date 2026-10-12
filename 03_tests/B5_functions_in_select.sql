-- ============================================================
-- Individual Assignment III: PL/SQL GOTO Statements and Functions
-- Course: Database Development with PL/SQL (INSY 8311)
-- Instructor: Eric Maniraguha | eric.maniraguha@auca.ac.rw
-- Student Name: Emmanuel TURINIMANA
-- Student ID: 28206
-- File: 03_tests/B5_functions_in_select.sql
-- Task: Part B5 - Using Stored Functions in SQL SELECT Queries
-- ============================================================

SET DEFINE OFF;
SET ECHO OFF;
SET FEEDBACK ON;
SET LINESIZE 150;
SET PAGESIZE 50;

PROMPT =========================================================================================================
PROMPT   PART B5: COMPREHENSIVE PAYROLL REPORT USING STORED FUNCTIONS IN SQL SELECT
PROMPT =========================================================================================================

COLUMN emp_id        FORMAT 9999    HEADING "Emp ID"
COLUMN emp_name      FORMAT A12     HEADING "Employee"
COLUMN dept_name     FORMAT A22     HEADING "Department Name"
COLUMN monthly_sal   FORMAT 999,999 HEADING "Monthly Sal"
COLUMN annual_sal    FORMAT 9,999,999 HEADING "Annual Sal"
COLUMN service_years FORMAT 99.9    HEADING "Tenure (Yrs)"
COLUMN tax_amt       FORMAT 999,999 HEADING "Tax (PAYE)"
COLUMN net_sal       FORMAT 999,999 HEADING "Net Monthly"

SELECT 
    e.employee_id                                               AS emp_id,
    e.employee_name                                             AS emp_name,
    fn_dept_name(e.department_id)                               AS dept_name,
    e.monthly_salary                                            AS monthly_sal,
    fn_annual_salary(e.employee_id)                             AS annual_sal,
    fn_years_of_service(e.employee_id)                          AS service_years,
    fn_calculate_tax(e.monthly_salary)                          AS tax_amt,
    (e.monthly_salary - fn_calculate_tax(e.monthly_salary))     AS net_sal
FROM employees e
ORDER BY e.employee_id;

PROMPT =========================================================================================================
PROMPT   QUERY 2: FILTERING WITH FUNCTIONS IN WHERE CLAUSE (TENURE >= 5 YEARS)
PROMPT =========================================================================================================

SELECT 
    e.employee_id                                   AS emp_id,
    e.employee_name                                 AS emp_name,
    fn_dept_name(e.department_id)                   AS dept_name,
    fn_years_of_service(e.employee_id)              AS service_years,
    fn_annual_salary(e.employee_id)                 AS annual_sal
FROM employees e
WHERE fn_years_of_service(e.employee_id) >= 5.0
ORDER BY fn_years_of_service(e.employee_id) DESC;

PROMPT =========================================================================================================
PROMPT   QUERY 3: AGGREGATE SUMMARY BY DEPARTMENT USING STORED FUNCTIONS
PROMPT =========================================================================================================

COLUMN total_dept_tax FORMAT 999,999,999 HEADING "Total Tax Withheld"
COLUMN avg_tenure     FORMAT 99.9        HEADING "Avg Tenure (Yrs)"
COLUMN emp_count      FORMAT 9999        HEADING "Total Staff"

SELECT 
    fn_dept_name(e.department_id)                               AS dept_name,
    COUNT(*)                                                    AS emp_count,
    ROUND(AVG(fn_years_of_service(e.employee_id)), 1)           AS avg_tenure,
    SUM(fn_calculate_tax(e.monthly_salary))                     AS total_dept_tax
FROM employees e
GROUP BY fn_dept_name(e.department_id)
ORDER BY total_dept_tax DESC;
