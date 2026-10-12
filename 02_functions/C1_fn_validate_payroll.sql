-- ============================================================
-- Individual Assignment III: PL/SQL GOTO Statements and Functions
-- Course: Database Development with PL/SQL (INSY 8311)
-- Instructor: Eric Maniraguha | eric.maniraguha@auca.ac.rw
-- Student Name: Emmanuel TURINIMANA
-- Student ID: 28206
-- File: 02_functions/C1_fn_validate_payroll.sql
-- Task: Part C1 - Stored Function: fn_validate_payroll
-- ============================================================

SET DEFINE OFF;
SET FEEDBACK ON;

CREATE OR REPLACE FUNCTION fn_validate_payroll (
    p_emp_id IN NUMBER
) RETURN VARCHAR2
IS
    v_emp_name   employees.employee_name%TYPE;
    v_dept_id    employees.department_id%TYPE;
    v_salary     employees.monthly_salary%TYPE;
    v_hire_date  employees.hire_date%TYPE;
    v_dept_name  VARCHAR2(100);
    v_annual_sal NUMBER;
    v_years      NUMBER;
    v_tax        NUMBER;
    v_net_salary NUMBER;
BEGIN
    -- 1. Validate NULL input
    IF p_emp_id IS NULL THEN
        RETURN 'INVALID: Employee ID parameter cannot be NULL';
    END IF;

    -- 2. Validate Employee Existence
    BEGIN
        SELECT employee_name, department_id, monthly_salary, hire_date
        INTO v_emp_name, v_dept_id, v_salary, v_hire_date
        FROM employees
        WHERE employee_id = p_emp_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 'INVALID: Employee ID ' || p_emp_id || ' does not exist in payroll system';
    END;

    -- 3. Validate Department via fn_dept_name
    v_dept_name := fn_dept_name(v_dept_id);
    IF v_dept_name = 'Unknown Department' OR v_dept_name LIKE 'Error%' THEN
        RETURN 'INVALID: Employee ' || v_emp_name || ' assigned to unrecognized department ID ' || v_dept_id;
    END IF;

    -- 4. Validate Salary Range
    IF v_salary IS NULL OR v_salary <= 0 THEN
        RETURN 'INVALID: Non-positive monthly salary detected (' || NVL(TO_CHAR(v_salary), 'NULL') || ')';
    END IF;

    -- 5. Calculate Payroll Components via Helper Stored Functions
    v_annual_sal := fn_annual_salary(p_emp_id);
    v_years      := fn_years_of_service(p_emp_id);
    v_tax        := fn_calculate_tax(v_salary);
    v_net_salary := v_salary - v_tax;

    -- 6. Validate Net Salary
    IF v_net_salary <= 0 THEN
        RETURN 'INVALID: Net salary must be positive after tax withholding';
    END IF;

    -- 7. Return Formatted Approval Confirmation
    RETURN 'VALID: Approved | Gross: ' || TRIM(TO_CHAR(v_salary, '999,999.00')) ||
           ' RWF | Tax: ' || TRIM(TO_CHAR(v_tax, '999,999.00')) ||
           ' RWF | Net: ' || TRIM(TO_CHAR(v_net_salary, '999,999.00')) ||
           ' RWF | Service: ' || v_years || ' yrs';

EXCEPTION
    WHEN OTHERS THEN
        RETURN 'ERROR: Payroll validation failed - ' || SQLERRM;
END fn_validate_payroll;
/
SHOW ERRORS FUNCTION fn_validate_payroll;
