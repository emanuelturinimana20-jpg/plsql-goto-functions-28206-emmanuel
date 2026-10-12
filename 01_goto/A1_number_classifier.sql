-- ============================================================
-- Individual Assignment III: PL/SQL GOTO Statements and Functions
-- Course: Database Development with PL/SQL (INSY 8311)
-- Instructor: Eric Maniraguha | eric.maniraguha@auca.ac.rw
-- Student Name: Emmanuel TURINIMANA
-- Student ID: 28206
-- File: 01_goto/A1_number_classifier.sql
-- Task: Part A1 - Number Classifier Using GOTO Statements
-- ============================================================

SET SERVEROUTPUT ON SIZE UNLIMITED;
SET LINESIZE 120;

PROMPT ============================================================
PROMPT   RUNNING PART A1: NUMBER CLASSIFIER (USING GOTO)
PROMPT ============================================================

DECLARE
    -- Collection of numbers to evaluate
    TYPE num_array IS VARRAY(8) OF NUMBER;
    v_numbers      num_array := num_array(42, -17, 0, 88, -24, 15, -9, 0);
    v_current_num  NUMBER;
    v_sign         VARCHAR2(20);
    v_parity       VARCHAR2(20);
    v_result       VARCHAR2(100);
    v_index        PLS_INTEGER := 1;
BEGIN
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE(RPAD('INPUT NUMBER', 15) || RPAD('SIGN', 15) || RPAD('PARITY', 15) || 'FINAL CLASSIFICATION');
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------------------');

    <<process_next_number>>
    IF v_index > v_numbers.COUNT THEN
        GOTO process_finished;
    END IF;

    v_current_num := v_numbers(v_index);

    -- Sign Branching using GOTO
    IF v_current_num = 0 THEN
        GOTO lbl_zero;
    ELSIF v_current_num > 0 THEN
        GOTO lbl_positive;
    ELSE
        GOTO lbl_negative;
    END IF;

    -- -------------------------------------------------------------
    -- Label: Zero
    -- -------------------------------------------------------------
    <<lbl_zero>>
    v_sign   := 'ZERO';
    v_parity := 'NEITHER';
    v_result := 'ZERO (Neutral Integer)';
    GOTO lbl_print_output;

    -- -------------------------------------------------------------
    -- Label: Positive
    -- -------------------------------------------------------------
    <<lbl_positive>>
    v_sign := 'POSITIVE';
    IF MOD(v_current_num, 2) = 0 THEN
        GOTO lbl_pos_even;
    ELSE
        GOTO lbl_pos_odd;
    END IF;

    <<lbl_pos_even>>
    v_parity := 'EVEN';
    v_result := 'POSITIVE EVEN NUMBER';
    GOTO lbl_print_output;

    <<lbl_pos_odd>>
    v_parity := 'ODD';
    v_result := 'POSITIVE ODD NUMBER';
    GOTO lbl_print_output;

    -- -------------------------------------------------------------
    -- Label: Negative
    -- -------------------------------------------------------------
    <<lbl_negative>>
    v_sign := 'NEGATIVE';
    IF MOD(ABS(v_current_num), 2) = 0 THEN
        GOTO lbl_neg_even;
    ELSE
        GOTO lbl_neg_odd;
    END IF;

    <<lbl_neg_even>>
    v_parity := 'EVEN';
    v_result := 'NEGATIVE EVEN NUMBER';
    GOTO lbl_print_output;

    <<lbl_neg_odd>>
    v_parity := 'ODD';
    v_result := 'NEGATIVE ODD NUMBER';
    GOTO lbl_print_output;

    -- -------------------------------------------------------------
    -- Output formatting label
    -- -------------------------------------------------------------
    <<lbl_print_output>>
    DBMS_OUTPUT.PUT_LINE(
        RPAD(TO_CHAR(v_current_num), 15) ||
        RPAD(v_sign, 15) ||
        RPAD(v_parity, 15) ||
        v_result
    );

    -- Advance iterator and jump to top of loop
    v_index := v_index + 1;
    GOTO process_next_number;

    -- -------------------------------------------------------------
    -- Completion label
    -- -------------------------------------------------------------
    <<process_finished>>
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Classification completed successfully using GOTO branching.');
END;
/
