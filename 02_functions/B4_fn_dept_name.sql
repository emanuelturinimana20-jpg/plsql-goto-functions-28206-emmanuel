-- ============================================================
-- Individual Assignment III: PL/SQL GOTO Statements and Functions
-- Course: Database Development with PL/SQL (INSY 8311)
-- Instructor: Eric Maniraguha | eric.maniraguha@auca.ac.rw
-- Student Name: Emmanuel TURINIMANA
-- Student ID: 28206
-- File: 02_functions/B4_fn_dept_name.sql
-- Task: Part B4 - Stored Function: fn_dept_name
-- ============================================================

SET DEFINE OFF;
SET FEEDBACK ON;

CREATE OR REPLACE FUNCTION fn_dept_name (
    p_dept_id IN NUMBER
) RETURN VARCHAR2
IS
    v_dept_name departments.department_name%TYPE;
BEGIN
    -- Handle NULL parameter
    IF p_dept_id IS NULL THEN
        RETURN 'Unknown Department';
    END IF;

    -- Look up department name by department_id
    SELECT department_name
    INTO v_dept_name
    FROM departments
    WHERE department_id = p_dept_id;

    RETURN v_dept_name;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'Unknown Department';
    WHEN OTHERS THEN
        RETURN 'Error: ' || SQLERRM;
END fn_dept_name;
/
SHOW ERRORS FUNCTION fn_dept_name;
