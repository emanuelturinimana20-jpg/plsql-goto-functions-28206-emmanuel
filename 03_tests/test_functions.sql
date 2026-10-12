-- ============================================================
-- Individual Assignment III: PL/SQL GOTO Statements and Functions
-- Course: Database Development with PL/SQL (INSY 8311)
-- Instructor: Eric Maniraguha | eric.maniraguha@auca.ac.rw
-- Student Name: Emmanuel TURINIMANA
-- Student ID: 28206
-- File: 03_tests/test_functions.sql
-- Task: Comprehensive Unit Test Suite for Stored Functions (B1 - B4)
-- ============================================================

SET DEFINE OFF;
SET SERVEROUTPUT ON SIZE UNLIMITED;
SET LINESIZE 120;

PROMPT ============================================================
PROMPT   RUNNING UNIT TESTS FOR STORED FUNCTIONS (B1 - B4)
PROMPT ============================================================

DECLARE
    v_passed PLS_INTEGER := 0;
    v_failed PLS_INTEGER := 0;

    PROCEDURE assert_test(
        p_test_name IN VARCHAR2,
        p_condition IN BOOLEAN,
        p_actual    IN VARCHAR2,
        p_expected  IN VARCHAR2
    ) IS
    BEGIN
        IF p_condition THEN
            DBMS_OUTPUT.PUT_LINE('[PASS] ' || RPAD(p_test_name, 45) || ' Actual: ' || p_actual);
            v_passed := v_passed + 1;
        ELSE
            DBMS_OUTPUT.PUT_LINE('[FAIL] ' || RPAD(p_test_name, 45) || ' Expected: ' || p_expected || ' | Got: ' || p_actual);
            v_failed := v_failed + 1;
        END IF;
    END;
BEGIN
    -- -------------------------------------------------------------
    -- 1. TESTS FOR B1: fn_annual_salary
    -- -------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('--- Testing B1: fn_annual_salary ---');
    assert_test(
        'Annual salary for Emp 101 (450k/mo)',
        fn_annual_salary(101) = 5400000,
        TO_CHAR(fn_annual_salary(101)),
        '5400000'
    );
    assert_test(
        'Annual salary for direct value 500k',
        fn_annual_salary(500000) = 6000000,
        TO_CHAR(fn_annual_salary(500000)),
        '6000000'
    );
    assert_test(
        'Annual salary for invalid ID 999 (NULL)',
        fn_annual_salary(999) IS NULL,
        NVL(TO_CHAR(fn_annual_salary(999)), 'NULL'),
        'NULL'
    );
    assert_test(
        'Annual salary for NULL parameter (NULL)',
        fn_annual_salary(NULL) IS NULL,
        NVL(TO_CHAR(fn_annual_salary(NULL)), 'NULL'),
        'NULL'
    );

    -- -------------------------------------------------------------
    -- 2. TESTS FOR B2: fn_years_of_service
    -- -------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('--- Testing B2: fn_years_of_service ---');
    assert_test(
        'Tenure for Emp 101 (hired 2021)',
        fn_years_of_service(101) > 4.5,
        TO_CHAR(fn_years_of_service(101)) || ' yrs',
        '> 4.5 yrs'
    );
    assert_test(
        'Tenure for Emp 104 (hired 2018)',
        fn_years_of_service(104) > 7.5,
        TO_CHAR(fn_years_of_service(104)) || ' yrs',
        '> 7.5 yrs'
    );
    assert_test(
        'Tenure for invalid ID 999 (NULL)',
        fn_years_of_service(999) IS NULL,
        NVL(TO_CHAR(fn_years_of_service(999)), 'NULL'),
        'NULL'
    );
    assert_test(
        'Tenure for NULL input (NULL)',
        fn_years_of_service(NULL) IS NULL,
        NVL(TO_CHAR(fn_years_of_service(NULL)), 'NULL'),
        'NULL'
    );

    -- -------------------------------------------------------------
    -- 3. TESTS FOR B3: fn_calculate_tax
    -- -------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('--- Testing B3: fn_calculate_tax ---');
    assert_test(
        'Tax for 50k (exempt <= 60k)',
        fn_calculate_tax(50000) = 0,
        TO_CHAR(fn_calculate_tax(50000)),
        '0'
    );
    assert_test(
        'Tax for 80k (10% on 20k excess)',
        fn_calculate_tax(80000) = 2000,
        TO_CHAR(fn_calculate_tax(80000)),
        '2000'
    );
    assert_test(
        'Tax for 450k (Emp 101)',
        fn_calculate_tax(450000) = 109000,
        TO_CHAR(fn_calculate_tax(450000)),
        '109000'
    );
    assert_test(
        'Tax for 0 / negative input',
        fn_calculate_tax(-1000) = 0,
        TO_CHAR(fn_calculate_tax(-1000)),
        '0'
    );

    -- -------------------------------------------------------------
    -- 4. TESTS FOR B4: fn_dept_name
    -- -------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('--- Testing B4: fn_dept_name ---');
    assert_test(
        'Dept 10 name',
        fn_dept_name(10) = 'Information Technology',
        fn_dept_name(10),
        'Information Technology'
    );
    assert_test(
        'Dept 20 name',
        fn_dept_name(20) = 'Finance',
        fn_dept_name(20),
        'Finance'
    );
    assert_test(
        'Dept 99 (non-existent)',
        fn_dept_name(99) = 'Unknown Department',
        fn_dept_name(99),
        'Unknown Department'
    );
    assert_test(
        'Dept NULL input',
        fn_dept_name(NULL) = 'Unknown Department',
        fn_dept_name(NULL),
        'Unknown Department'
    );

    -- -------------------------------------------------------------
    -- SUMMARY
    -- -------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('TEST SUITE COMPLETE: ' || v_passed || ' PASSED, ' || v_failed || ' FAILED.');
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------------------');
END;
/
