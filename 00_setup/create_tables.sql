-- ============================================================
-- Individual Assignment III: PL/SQL GOTO Statements and Functions
-- Course: Database Development with PL/SQL (INSY 8311)
-- Instructor: Eric Maniraguha | eric.maniraguha@auca.ac.rw
-- Student: Emmanuel TURINIMANA (ID: 28206)
-- Script: 00_setup/create_tables.sql
-- ============================================================

SET ECHO OFF;
SET FEEDBACK ON;
SET SQLBLANKLINES ON;
SET SERVEROUTPUT ON;
SET LINESIZE 120;
SET PAGESIZE 50;

PROMPT ============================================================
PROMPT   DROPPING EXISTING TABLES (IF ANY)
PROMPT ============================================================

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE employees CASCADE CONSTRAINTS';
    DBMS_OUTPUT.PUT_LINE('Table EMPLOYEES dropped.');
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
        DBMS_OUTPUT.PUT_LINE('Table EMPLOYEES did not exist.');
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE departments CASCADE CONSTRAINTS';
    DBMS_OUTPUT.PUT_LINE('Table DEPARTMENTS dropped.');
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
        DBMS_OUTPUT.PUT_LINE('Table DEPARTMENTS did not exist.');
END;
/

PROMPT ============================================================
PROMPT   CREATING DEPARTMENTS TABLE
PROMPT ============================================================

CREATE TABLE departments (
    department_id   NUMBER PRIMARY KEY,
    department_name VARCHAR2(100) NOT NULL
);

PROMPT ============================================================
PROMPT   CREATING EMPLOYEES TABLE
PROMPT ============================================================

CREATE TABLE employees (
    employee_id    NUMBER PRIMARY KEY,
    employee_name  VARCHAR2(100) NOT NULL,
    department_id  NUMBER NOT NULL,
    monthly_salary NUMBER(10,2) NOT NULL,
    hire_date      DATE NOT NULL,
    CONSTRAINT fk_employee_department
        FOREIGN KEY (department_id)
        REFERENCES departments(department_id),
    CONSTRAINT chk_employee_salary
        CHECK (monthly_salary > 0)
);

PROMPT ============================================================
PROMPT   INSERTING SEED DATA: DEPARTMENTS
PROMPT ============================================================

INSERT INTO departments (department_id, department_name)
VALUES (10, 'Information Technology');

INSERT INTO departments (department_id, department_name)
VALUES (20, 'Finance');

INSERT INTO departments (department_id, department_name)
VALUES (30, 'Human Resources');

INSERT INTO departments (department_id, department_name)
VALUES (40, 'Marketing');

PROMPT ============================================================
PROMPT   INSERTING SEED DATA: EMPLOYEES
PROMPT ============================================================

INSERT INTO employees (employee_id, employee_name, department_id, monthly_salary, hire_date)
VALUES (101, 'Alice', 10, 450000, DATE '2021-03-15');

INSERT INTO employees (employee_id, employee_name, department_id, monthly_salary, hire_date)
VALUES (102, 'Brian', 20, 650000, DATE '2019-07-10');

INSERT INTO employees (employee_id, employee_name, department_id, monthly_salary, hire_date)
VALUES (103, 'Claudine', 30, 350000, DATE '2023-01-20');

INSERT INTO employees (employee_id, employee_name, department_id, monthly_salary, hire_date)
VALUES (104, 'David', 40, 800000, DATE '2018-05-05');

INSERT INTO employees (employee_id, employee_name, department_id, monthly_salary, hire_date)
VALUES (105, 'Eric', 10, 550000, DATE '2022-09-12');

COMMIT;

PROMPT ============================================================
PROMPT   VERIFYING DEPARTMENTS TABLE
PROMPT ============================================================

COLUMN department_id FORMAT 9999 HEADING "Dept ID"
COLUMN department_name FORMAT A25 HEADING "Department Name"

SELECT department_id, department_name
FROM departments
ORDER BY department_id;

PROMPT ============================================================
PROMPT   VERIFYING EMPLOYEES TABLE
PROMPT ============================================================

COLUMN employee_id FORMAT 9999 HEADING "Emp ID"
COLUMN employee_name FORMAT A15 HEADING "Employee Name"
COLUMN monthly_salary FORMAT 999,999,999.00 HEADING "Monthly Salary (RWF)"
COLUMN hire_date HEADING "Hire Date"

SELECT employee_id, employee_name, department_id, monthly_salary, hire_date
FROM employees
ORDER BY employee_id;