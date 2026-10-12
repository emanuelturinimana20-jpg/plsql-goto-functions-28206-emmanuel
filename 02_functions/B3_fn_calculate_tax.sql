-- ============================================================
-- Individual Assignment III: PL/SQL GOTO Statements and Functions
-- Course: Database Development with PL/SQL (INSY 8311)
-- Instructor: Eric Maniraguha | eric.maniraguha@auca.ac.rw
-- Student Name: Emmanuel TURINIMANA
-- Student ID: 28206
-- File: 02_functions/B3_fn_calculate_tax.sql
-- Task: Part B3 - Stored Function: fn_calculate_tax
-- ============================================================

SET DEFINE OFF;
SET FEEDBACK ON;

/*
----------------------------------------------------------------------
TAX BRACKET SPECIFICATION (Rwanda PAYE Progressive Scale):
----------------------------------------------------------------------
- 0 to 60,000 RWF       : 0%  (Tax Exempt)
- 60,001 to 100,000 RWF : 10% (Taxed on slice between 60,000 and 100,000)
- Over 100,000 RWF      : 30% (Taxed on slice above 100,000 + 4,000 RWF base)
----------------------------------------------------------------------
*/

CREATE OR REPLACE FUNCTION fn_calculate_tax (
    p_salary_or_id IN NUMBER
) RETURN NUMBER
IS
    v_salary NUMBER;
    v_tax    NUMBER := 0;
BEGIN
    IF p_salary_or_id IS NULL THEN
        RETURN 0;
    END IF;

    -- If parameter matches an employee_id (e.g., 101-105), look up monthly salary
    IF p_salary_or_id <= 1000 THEN
        BEGIN
            SELECT monthly_salary
            INTO v_salary
            FROM employees
            WHERE employee_id = p_salary_or_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_salary := p_salary_or_id;
        END;
    ELSE
        v_salary := p_salary_or_id;
    END IF;

    -- Validate non-positive salary
    IF v_salary <= 0 THEN
        RETURN 0;
    END IF;

    -- Calculate progressive PAYE tax
    IF v_salary <= 60000 THEN
        v_tax := 0;
    ELSIF v_salary <= 100000 THEN
        v_tax := (v_salary - 60000) * 0.10;
    ELSE
        -- 0 on first 60k, 10% on next 40k (= 4,000), 30% on remainder above 100k
        v_tax := (40000 * 0.10) + ((v_salary - 100000) * 0.30);
    END IF;

    RETURN ROUND(v_tax, 2);

EXCEPTION
    WHEN OTHERS THEN
        RETURN 0;
END fn_calculate_tax;
/
SHOW ERRORS FUNCTION fn_calculate_tax;
