# Academic Reflection: PL/SQL GOTO Statements and Stored Functions

**Course:** Database Development with PL/SQL (INSY 8311)  
**Instructor:** Eric Maniraguha (`eric.maniraguha@auca.ac.rw`)  
**Student Name:** Emmanuel TURINIMANA  
**Student ID:** 28206  
**Assignment:** Individual Assignment III — PL/SQL GOTO Statements and Functions  
**Date:** October 2026  

---

## Executive Summary

This practical assignment explores two foundational paradigms of Oracle PL/SQL programming: unconditional low-level branching using the `GOTO` statement, and modular, procedural encapsulation using PL/SQL stored functions. Through implementing a real-world payroll management system featuring Rwandan PAYE progressive tax brackets, employee tenure calculations, and robust database constraints, this assignment provides practical mastery of both legacy control-flow mechanisms and modern structured software engineering principles.

---

## 1. Deep Dive: The PL/SQL GOTO Statement

### 1.1 Syntax and Operational Mechanics
In PL/SQL, the `GOTO` statement performs an unconditional jump to a named label within the same executable scope:
```sql
GOTO target_label;
...
<<target_label>>
executable_statement; -- or NULL;
```
A label in PL/SQL is enclosed in double angle brackets (`<<...>>`) and must immediately precede an executable statement or a PL/SQL block. In situations where no operation is needed after the label, a `NULL;` statement is mandatory.

### 1.2 Strict Restrictions and Scoping Rules in Oracle Database
Oracle enforces strict compile-time checks on `GOTO` statements to preserve program stack integrity and avoid undefined variable states:
1. **Branching Into Compound Statements is Prohibited:** Control cannot be transferred from an outer scope directly into the body of an `IF` statement, `CASE` statement, `LOOP` construct, or child sub-block. Attempting this triggers **`PLS-00375: illegal GOTO statement; this GOTO cannot branch to label '<LABEL>'`**.
2. **Branching Between Clauses is Prohibited:** A program cannot branch from one `IF` or `ELSIF` branch into another, nor between `WHEN` clauses within a `CASE` statement.
3. **Subprogram Boundaries:** `GOTO` cannot transfer control out of a function, procedure, or method into an enclosing block.
4. **Exception Handler Rules:** Control cannot be transferred into an exception handler from an executable block, nor can control jump from an exception handler back into the current block (though jumping out of an exception handler to an enclosing parent block is permissible).

### 1.3 Dijkstra’s Principle: Why Modern Code Avoids GOTO
In 1968, Edsger W. Dijkstra published his seminal letter *"Go To Statement Considered Harmful"*, arguing that software quality is inversely proportional to the frequency of `GOTO` statements. 

Our comparative analysis between `A2_salary_review.sql` (using `GOTO`) and `A4_rewrite_no_goto.sql` (structured rewrite) highlights these concrete differences:

| Evaluation Criterion | GOTO Branching (`A2_salary_review.sql`) | Structured Programming (`A4_rewrite_no_goto.sql`) |
| :--- | :--- | :--- |
| **Control Flow** | Non-linear, arbitrary jumps ("spaghetti code") | Top-to-bottom, predictable single-entry single-exit |
| **Readability** | Difficult to trace execution paths across labels | Clear hierarchical blocks (`CASE`, `IF-ELSIF-ELSE`) |
| **Resource Safety** | Manual cursor management (`OPEN`, `FETCH`, `CLOSE`) risks leaks on jump bypass | Structured Cursor `FOR` loops automatically manage cursor lifecycle |
| **Debugging & Testing** | High risk of jumping past variable initializations | Isolated, testable units with deterministic variable lifecycles |
| **Compiler Optimization**| Limits compiler ability to reorder and optimize byte-code | Enables PL/SQL compiler inline optimizations and pipelining |

---

## 2. Mastery of Stored Functions in PL/SQL

### 2.1 Stored Functions vs. Procedures
While stored procedures execute actions and can return zero or multiple values via `OUT` parameters, stored functions:
- **Must Return Exactly One Value:** Declared with `RETURN <datatype>` in the header and containing at least one executable `RETURN` expression.
- **SQL Integrability:** Functions that adhere to purity rules (do not execute `DML` or modify package state) can be embedded directly inside SQL `SELECT`, `WHERE`, `ORDER BY`, and `GROUP BY` clauses.

### 2.2 Exception Handling Within Functions
In database-driven applications, functions must never fail silently nor crash calling queries unexpectedly. In Part B:
- `fn_annual_salary` and `fn_years_of_service` defensively intercept `NO_DATA_FOUND` to return `NULL` when an employee record is missing.
- `fn_dept_name` traps `NO_DATA_FOUND` and returns `'Unknown Department'`, preventing `ORA-01403` from breaking master SQL queries.
- `fn_calculate_tax` guards against `NULL` or negative salary values by returning `0`, guaranteeing mathematical stability.

### 2.3 Real-World Application: Progressive Rwandan PAYE Tax Calculation
In `B3_fn_calculate_tax.sql`, progressive taxation according to Rwanda tax law is modeled:
$$\text{Tax Liability} = \begin{cases} 
0 & \text{if } S \le 60,000 \\
(S - 60,000) \times 0.10 & \text{if } 60,000 < S \le 100,000 \\
4,000 + (S - 100,000) \times 0.30 & \text{if } S > 100,000 
\end{cases}$$
This ensures accurate payroll computation across all salary tiers:
- **Claudine (350,000 RWF):** $4,000 + (250,000 \times 0.30) = 79,000\text{ RWF}$
- **Alice (450,000 RWF):** $4,000 + (350,000 \times 0.30) = 109,000\text{ RWF}$
- **Eric (550,000 RWF):** $4,000 + (450,000 \times 0.30) = 139,000\text{ RWF}$
- **Brian (650,000 RWF):** $4,000 + (550,000 \times 0.30) = 169,000\text{ RWF}$
- **David (800,000 RWF):** $4,000 + (700,000 \times 0.30) = 214,000\text{ RWF}$

---

## 3. Combined Task: Payroll Validator (`C1_fn_validate_payroll`)

The payroll validator function (`fn_validate_payroll`) demonstrates enterprise-grade component orchestration. It integrates business rules into a unified verification gatekeeper:
1. **Input Validation:** Enforces non-null parameter checks.
2. **Relational Integrity:** Queries employee existence; handles `NO_DATA_FOUND` with clear feedback (`INVALID: Employee ID 999 does not exist...`).
3. **Foreign Key Integrity:** Invokes `fn_dept_name` to confirm valid department membership.
4. **Compensation Feasibility:** Computes annual income (`fn_annual_salary`), service tenure (`fn_years_of_service`), and tax deduction (`fn_calculate_tax`).
5. **Solvency Verification:** Validates that net salary ($Gross - Tax$) is strictly positive.
6. **Audit Output:** Emits a concise, human-readable validation summary.

---

## 4. Quiz Preparation: Quick Revision Guide

To prepare for next week's in-class quiz, here are the essential concepts and testable rules:

1. **GOTO Restrictions:**
   - Cannot jump **into** an `IF`, `CASE`, `LOOP`, or child block.
   - Cannot jump from one `IF` / `CASE` branch to another.
   - Cannot jump into an exception block or out of a subprogram.
   - Error code when violating compound statement boundaries: **`PLS-00375`**.
2. **Label Syntax:**
   - Format: `<<label_name>>`.
   - Must be followed by an executable statement (or `NULL;`).
3. **Function Compilation & Calling:**
   - Syntax: `CREATE OR REPLACE FUNCTION name (param IN type) RETURN return_type IS ... BEGIN ... END;`
   - Stored functions must return a value; procedures do not require a return value.
   - Functions called in SQL `SELECT` cannot modify database tables via `INSERT`, `UPDATE`, or `DELETE`.
4. **Predefined Exceptions:**
   - `NO_DATA_FOUND` (`ORA-01403`): Raised when a `SELECT INTO` query returns zero rows.
   - `TOO_MANY_ROWS` (`ORA-01422`): Raised when a `SELECT INTO` query returns multiple rows.

---

## 5. Academic Integrity & AI Disclosure

In adherence to AUCA Academic Integrity guidelines and the assignment requirements:
- **Student Responsibility:** All code, logic, documentation, and SQL executions in this repository were created, reviewed, tested, and verified by Emmanuel TURINIMANA (Student ID: 28206).
- **AI Tool Usage:** Generative AI was utilized as an assistive pair-programming companion for:
  1. Validating Oracle 23ai PL/SQL compiler error messages (`PLS-00375`).
  2. Formatting test case matrices for edge-case validation.
  3. Generating clean, consistent terminal output screenshots.
  4. Structuring and proofreading documentation.
- The student understands and is prepared to explain every aspect of this repository during the upcoming in-class quiz and practical evaluations.
