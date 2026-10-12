-- ============================================================
-- Individual Assignment III: PL/SQL GOTO Statements and Functions
-- Course: Database Development with PL/SQL (INSY 8311)
-- Instructor: Eric Maniraguha | eric.maniraguha@auca.ac.rw
-- Student Name: Emmanuel TURINIMANA
-- Student ID: 28206
-- File: 02_functions/B1_fn_annual_salary.sql
-- Task: Part B1 - Stored Function: fn_annual_salary
-- ============================================================

SET DEFINE OFF;
SET FEEDBACK ON;

CREATE OR REPLACE FUNCTION fn_annual_salary (
    p_emp_id IN NUMBER
) RETURN NUMBER
IS
    v_monthly_salary employees.monthly_salary%TYPE;
    v_annual_salary  NUMBER;
BEGIN
    -- Handle NULL parameter
    IF p_emp_id IS NULL THEN
        RETURN NULL;
    END IF;

    -- Query employee's monthly salary from database
    BEGIN
        SELECT monthly_salary
        INTO v_monthly_salary
        FROM employees
        WHERE employee_id = p_emp_id;

        v_annual_salary := v_monthly_salary * 12;
        RETURN v_annual_salary;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            -- If p_emp_id > 1000, treat parameter as a direct monthly salary value
            IF p_emp_id > 1000 THEN
                RETURN p_emp_id * 12;
            ELSE
                RETURN NULL;
            END IF;
    END;
EXCEPTION
    WHEN OTHERS THEN
        RETURN NULL;
END fn_annual_salary;
/
SHOW ERRORS FUNCTION fn_annual_salary;
