-- ============================================================
-- Individual Assignment III: PL/SQL GOTO Statements and Functions
-- Course: Database Development with PL/SQL (INSY 8311)
-- Instructor: Eric Maniraguha | eric.maniraguha@auca.ac.rw
-- Student Name: Emmanuel TURINIMANA
-- Student ID: 28206
-- File: 02_functions/B2_fn_years_of_service.sql
-- Task: Part B2 - Stored Function: fn_years_of_service
-- ============================================================

SET DEFINE OFF;
SET FEEDBACK ON;

CREATE OR REPLACE FUNCTION fn_years_of_service (
    p_emp_id IN NUMBER
) RETURN NUMBER
IS
    v_hire_date DATE;
    v_years     NUMBER;
BEGIN
    -- Handle NULL parameter
    IF p_emp_id IS NULL THEN
        RETURN NULL;
    END IF;

    -- Query hire date for the given employee
    SELECT hire_date
    INTO v_hire_date
    FROM employees
    WHERE employee_id = p_emp_id;

    -- Calculate years of service to 1 decimal place using MONTHS_BETWEEN
    v_years := ROUND(MONTHS_BETWEEN(SYSDATE, v_hire_date) / 12, 1);
    RETURN v_years;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    WHEN OTHERS THEN
        RETURN NULL;
END fn_years_of_service;
/
SHOW ERRORS FUNCTION fn_years_of_service;
