-- ============================================================
-- Individual Assignment III: PL/SQL GOTO Statements and Functions
-- Course: Database Development with PL/SQL (INSY 8311)
-- Instructor: Eric Maniraguha | eric.maniraguha@auca.ac.rw
-- Student Name: Emmanuel TURINIMANA
-- Student ID: 28206
-- File: 01_goto/A2_salary_review.sql
-- Task: Part A2 - Salary Review Using GOTO Statements
-- ============================================================

SET DEFINE OFF;
SET SERVEROUTPUT ON SIZE UNLIMITED;
SET LINESIZE 130;

PROMPT ============================================================
PROMPT   RUNNING PART A2: EMPLOYEE SALARY REVIEW (USING GOTO)
PROMPT ============================================================

DECLARE
    CURSOR c_employees IS
        SELECT employee_id, employee_name, department_id, monthly_salary
        FROM employees
        ORDER BY employee_id;

    v_rec            c_employees%ROWTYPE;
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

    OPEN c_employees;

    <<fetch_employee_loop>>
    FETCH c_employees INTO v_rec;
    IF c_employees%NOTFOUND THEN
        GOTO review_complete;
    END IF;

    -- Evaluate salary brackets using GOTO branching
    IF v_rec.monthly_salary < 400000 THEN
        GOTO salary_tier_low;
    ELSIF v_rec.monthly_salary BETWEEN 400000 AND 600000 THEN
        GOTO salary_tier_mid;
    ELSE
        GOTO salary_tier_high;
    END IF;

    -- -------------------------------------------------------------
    -- Label: Low Salary Bracket (< 400,000 RWF)
    -- -------------------------------------------------------------
    <<salary_tier_low>>
    v_tier_label     := 'Tier 1 (Junior)';
    v_recommendation := 'Eligible for 15% Annual Cost-of-Living Raise';
    GOTO print_employee_review;

    -- -------------------------------------------------------------
    -- Label: Mid Salary Bracket (400,000 to 600,000 RWF)
    -- -------------------------------------------------------------
    <<salary_tier_mid>>
    v_tier_label     := 'Tier 2 (Standard)';
    v_recommendation := 'Standard Range; Discretionary 8% Merit Bonus';
    GOTO print_employee_review;

    -- -------------------------------------------------------------
    -- Label: High Salary Bracket (> 600,000 RWF)
    -- -------------------------------------------------------------
    <<salary_tier_high>>
    v_tier_label     := 'Tier 3 (Senior)';
    v_recommendation := 'Leadership Bracket; Retention and Stock Options';
    GOTO print_employee_review;

    -- -------------------------------------------------------------
    -- Output Formatting Label
    -- -------------------------------------------------------------
    <<print_employee_review>>
    DBMS_OUTPUT.PUT_LINE(
        RPAD(TO_CHAR(v_rec.employee_id), 8) ||
        RPAD(v_rec.employee_name, 12) ||
        RPAD(TO_CHAR(v_rec.department_id), 8) ||
        RPAD(TO_CHAR(v_rec.monthly_salary, '999,999.00'), 16) ||
        RPAD(v_tier_label, 18) ||
        v_recommendation
    );

    -- Loop jump to fetch next record
    GOTO fetch_employee_loop;

    -- -------------------------------------------------------------
    -- Termination Label
    -- -------------------------------------------------------------
    <<review_complete>>
    CLOSE c_employees;
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Salary review finished successfully across all employee records.');
END;
/
