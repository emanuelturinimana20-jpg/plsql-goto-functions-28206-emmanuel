-- ============================================================
-- Individual Assignment III: PL/SQL GOTO Statements and Functions
-- Course: Database Development with PL/SQL (INSY 8311)
-- Instructor: Eric Maniraguha | eric.maniraguha@auca.ac.rw
-- Student Name: Emmanuel TURINIMANA
-- Student ID: 28206
-- File: 01_goto/A3_illegal_goto.sql
-- Task: Part A3 - Illegal GOTO Demonstration and Legal Fix
-- ============================================================

SET DEFINE OFF;
SET SERVEROUTPUT ON SIZE UNLIMITED;
SET LINESIZE 120;

PROMPT ============================================================
PROMPT   PART A3: ILLEGAL GOTO DEMONSTRATION AND LEGAL FIX
PROMPT ============================================================

/*
----------------------------------------------------------------------
1. THE ILLEGAL GOTO RULE IN ORACLE PL/SQL:
----------------------------------------------------------------------
Oracle PL/SQL Language Fundamentals state:
"A GOTO statement cannot transfer control INTO an IF statement,
 CASE statement, LOOP statement, or child sub-block from the outside."

When a programmer attempts to branch from an enclosing scope directly
into the interior of an IF block, the PL/SQL compiler rejects the code
with compilation error:
    ORA-06550: PLS-00375: illegal GOTO statement;
    this GOTO cannot branch to label '<LABEL_NAME>'

The following raw block demonstrates the illegal structure:

DECLARE
    v_score NUMBER := 85;
BEGIN
    -- ILLEGAL: Attempting to jump directly into the body of an IF statement
    GOTO target_inside_if;

    IF v_score >= 50 THEN
        <<target_inside_if>>
        DBMS_OUTPUT.PUT_LINE('Candidate passed successfully.');
    END IF;
END;
/
----------------------------------------------------------------------
*/

PROMPT ============================================================
PROMPT 1. DEMONSTRATING THE COMPILER ERROR DYNAMICALLY (PLS-00375)
PROMPT ============================================================

DECLARE
    v_error_msg VARCHAR2(4000);
BEGIN
    DBMS_OUTPUT.PUT_LINE('Attempting to execute block with illegal GOTO into IF statement:');
    EXECUTE IMMEDIATE '
        DECLARE
            v_score NUMBER := 85;
        BEGIN
            GOTO target_inside_if;
            IF v_score >= 50 THEN
                <<target_inside_if>>
                DBMS_OUTPUT.PUT_LINE(''Inside IF block.'');
            END IF;
        END;
    ';
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('>>> ORACLE COMPILER DETECTED ILLEGAL GOTO:');
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
        DBMS_OUTPUT.PUT_LINE('>>> Explanation: Jumping into compound statement bodies is prohibited.');
END;
/

PROMPT ============================================================
PROMPT 2. RUNNING THE LEGAL / CORRECTED PL/SQL CODE
PROMPT ============================================================

DECLARE
    v_emp_id     NUMBER := 102;
    v_salary     NUMBER;
    v_emp_name   VARCHAR2(100);
    v_status     VARCHAR2(100);
BEGIN
    -- Fetch target employee
    SELECT employee_name, monthly_salary
    INTO v_emp_name, v_salary
    FROM employees
    WHERE employee_id = v_emp_id;

    DBMS_OUTPUT.PUT_LINE('Evaluating Employee: ' || v_emp_name || ' (Salary: ' || TO_CHAR(v_salary, '999,999.00') || ' RWF)');

    -- LEGAL GOTO: Branching to labels located at the SAME or ENCLOSING block level
    IF v_salary >= 600000 THEN
        GOTO lbl_high_earner;
    ELSE
        GOTO lbl_standard_earner;
    END IF;

    -- Targets are in legal, accessible block scope (not nested inside other IF clauses)
    <<lbl_high_earner>>
    v_status := 'High earner threshold reached. Standard tax bracket applied.';
    GOTO lbl_display_summary;

    <<lbl_standard_earner>>
    v_status := 'Standard earner threshold. Normal tax bracket applied.';
    GOTO lbl_display_summary;

    <<lbl_display_summary>>
    DBMS_OUTPUT.PUT_LINE('Outcome: ' || v_status);
    DBMS_OUTPUT.PUT_LINE('Legal GOTO executed cleanly without violating PL/SQL scoping rules.');
END;
/
