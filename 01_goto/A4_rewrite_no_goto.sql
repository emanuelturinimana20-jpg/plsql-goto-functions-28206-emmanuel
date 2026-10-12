-- ============================================================
-- Individual Assignment III: PL/SQL GOTO Statements and Functions
-- Course: Database Development with PL/SQL (INSY 8311)
-- Instructor: Eric Maniraguha | eric.maniraguha@auca.ac.rw
-- Student Name: Emmanuel TURINIMANA
-- Student ID: 28206
-- File: 01_goto/A4_rewrite_no_goto.sql
-- Task: Part A4 - Rewrite Salary Review Without GOTO Statements
-- ============================================================

SET DEFINE OFF;
SET SERVEROUTPUT ON SIZE UNLIMITED;
SET LINESIZE 130;

PROMPT ============================================================
PROMPT   RUNNING PART A4: SALARY REVIEW REWRITE (STRUCTURED - NO GOTO)
PROMPT ============================================================

/*
----------------------------------------------------------------------
STRUCTURED PROGRAMMING VS. GOTO ANALYSIS:
----------------------------------------------------------------------
1. Readability:
   - GOTO produces arbitrary jumps across blocks ("spaghetti code").
   - Structured loops (FOR-IN-LOOP) and CASE/IF statements provide a
     predictable, top-to-bottom, single-entry single-exit execution flow.

2. Maintainability & Debugging:
   - Eliminating labels prevents unhandled skip bugs where intermediate
     variable initializations are bypassed.
   - Code logic is modular, self-contained, and easy to unit test.

3. Resource Management:
   - Cursor FOR loops automatically handle OPEN, FETCH, and CLOSE,
     preventing cursor leaks if an exception occurs.
----------------------------------------------------------------------
*/

DECLARE
    CURSOR c_employees IS
        SELECT employee_id, employee_name, department_id, monthly_salary
        FROM employees
        ORDER BY employee_id;

    v_tier_label     VARCHAR2(30);
    v_recommendation VARCHAR2(60);
BEGIN
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE(
        RPAD('EMP ID', 8) ||
        RPAD('NAME', 12) ||
        RPAD('DEPT', 8) ||
        RPAD('SALARY (RWF)', 16) ||
        RPAD('TIER', 18) ||
        'REVIEW ACTION / RECOMMENDATION'
    );
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------------------------------------------------');

    -- Structured iteration using Cursor FOR Loop (eliminates OPEN, FETCH, CLOSE, and GOTO)
    FOR emp_rec IN c_employees LOOP
        -- Structured evaluation using CASE statement (eliminates branching labels)
        CASE
            WHEN emp_rec.monthly_salary < 400000 THEN
                v_tier_label     := 'Tier 1 (Junior)';
                v_recommendation := 'Eligible for 15% Annual Cost-of-Living Raise';

            WHEN emp_rec.monthly_salary BETWEEN 400000 AND 600000 THEN
                v_tier_label     := 'Tier 2 (Standard)';
                v_recommendation := 'Standard Range; Discretionary 8% Merit Bonus';

            ELSE
                v_tier_label     := 'Tier 3 (Senior)';
                v_recommendation := 'Leadership Bracket; Retention and Stock Options';
        END CASE;

        -- Formatted display for each record
        DBMS_OUTPUT.PUT_LINE(
            RPAD(TO_CHAR(emp_rec.employee_id), 8) ||
            RPAD(emp_rec.employee_name, 12) ||
            RPAD(TO_CHAR(emp_rec.department_id), 8) ||
            RPAD(TO_CHAR(emp_rec.monthly_salary, '999,999.00'), 16) ||
            RPAD(v_tier_label, 18) ||
            v_recommendation
        );
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Structured salary review completed cleanly without any GOTO statements.');
END;
/
