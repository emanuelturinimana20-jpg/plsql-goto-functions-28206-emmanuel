-- ============================================================
-- Individual Assignment III: PL/SQL GOTO Statements and Functions
-- Course: Database Development with PL/SQL (INSY 8311)
-- Instructor: Eric Maniraguha | eric.maniraguha@auca.ac.rw
-- Student Name: Emmanuel TURINIMANA
-- Student ID: 28206
-- File: 03_tests/test_validate_payroll.sql
-- Task: Comprehensive Test Suite for Payroll Validator (Part C1)
-- ============================================================

SET DEFINE OFF;
SET SERVEROUTPUT ON SIZE UNLIMITED;
SET LINESIZE 140;

PROMPT =========================================================================================================
PROMPT   RUNNING UNIT AND INTEGRATION TESTS FOR PAYROLL VALIDATOR (C1: fn_validate_payroll)
PROMPT =========================================================================================================

DECLARE
    TYPE id_table IS TABLE OF NUMBER;
    v_test_ids id_table := id_table(101, 102, 103, 104, 105, 999, NULL);
    v_result   VARCHAR2(400);
BEGIN
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------------------------------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE(RPAD('INPUT ID', 12) || RPAD('STATUS', 10) || 'VALIDATOR AUDIT MESSAGE');
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------------------------------------------------------------------------');

    FOR i IN 1..v_test_ids.COUNT LOOP
        v_result := fn_validate_payroll(v_test_ids(i));

        DBMS_OUTPUT.PUT_LINE(
            RPAD(NVL(TO_CHAR(v_test_ids(i)), 'NULL'), 12) ||
            RPAD(SUBSTR(v_result, 1, INSTR(v_result, ':') - 1), 10) ||
            v_result
        );
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------------------------------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Payroll validation test suite executed successfully across all valid and invalid cases.');
END;
/
