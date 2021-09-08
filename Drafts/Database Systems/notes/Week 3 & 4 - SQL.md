# Week 3 & 4 - SQL

<div id="content>


> REM syntax excluded, refer to slides or official docs

## Join & Select

```SQL
SELECT <ATTRIBUTES>
FROM <TABLES>
WHERE <ATTRIBUTE = VALUE> AND <PK = FK>
```

## Table as Var

```SQL
<TABLE> AS <VAR_NAME>
```

> REM particularly useful when a relation plays different roles within a query (e.g. recursive R)

## Multi-Sets

```SQL
UNION , EXCEPT, INTERSECT, DISTINCT
```
Operators which allow manipulation of multi-sets. Often used to get a final query which is composed from interim sub-queries

```SQL
-- Q1 SET : Employees with surname = Smith
( SELECT DISTINCT Pnumber
FROM PROJECT, DEPARTMENT, EMPLOYEE
WHERE Dnum = Dnumber AND Mgr_ssn = Ssn
AND Lname = ‘Smith’ )

UNION -- Q3 : UNION Q1, Q2

-- Q2 SET : Employe with surname = Smith and is manager 
( SELECT DISTINCT Pnumber
FROM PROJECT, WORKS_ON, EMPLOYEE
WHERE Pnumber = Pno AND Essn = Ssn
AND Lname = ‘Smith’ );
```

> REM the `ALL` keyword performs multiset operations

## Booleans : 3-Valued Logic

```SQL
TRUE (1), FALSE (0), UNKOWN (0.5)
```

Any value compared with `NULL` evaluates to `UNKNOWN`, hence to verify if `NULL` user `IS` and `IS NOT` operators.

In order to build the truth tables for `AND, OR, NOT` using `UNK` you can think as applying a *min, max, 1-x* operations respectively. For example , `min(T,UNK) == UNK` hence `T AND UNK == UNK`

## Nested/Inner Queries

`SELECT FROM WHERE` block within another outer `WHERE` clause.

There are two categories of nested queries:
1. *Uncorrelated* : Execute inner `Q1` followed by outer `Q2`
2. *Correlated* : For each tuple in `Q2` execute `Q1`

### Uncorrelated - IN

checks whether a value belongs to the inners' output 

```SQL
WHERE X IN (1,2,3)
```

### Uncorrelated - ALL

compares a value with all the values from the inners' output

```SQL
WHERE X > ALL (Q1)
```
### Correlated - IN

```SQL
SELECT E.Fname, E.Lname
FROM EMPLOYEE AS E
WHERE E.Ssn IN ( SELECT D.Essn
                 FROM DEPENDENT AS D
                 WHERE E.Fname = D.Dependent_name
                       AND E.Sex = D.Sex );
```

In general, a query written with nested select-from-where blocks and using the `=` or
`IN` comparison operators can always be expressed as a single block query

```SQL
SELECT E.Fname, E.Lname
FROM EMPLOYEE AS E, DEPENDENT AS D
WHERE E.Ssn = D.Essn AND E.Sex = D.Sex
      AND E.Fname = D.Dependent_name;
```

### Correlated - EXISTS

checks if the inner's output is an empty set, returns false if empty


## Join

### INNER

matches tuples using FK and PK

- EQUI-JOIN : if operator is `=`
- THETA-JOIN : any operator

```SQL
SELECT
FROM R1 JOIN R2 ON PK=FK
WHERE
```

> REM recall from above that we can also JOIN and SELECT by including both conditions in the WHERE clause

### OUTER

allows FK to be null

#### LEFT OUTER

- every tuple in the LR *must* appear in the result
- if no matching tuple exists add `NULL` to RR

```SQL
SELECT E.Lname AS Employee_name,
S.Lname AS Supervisor_name
FROM (EMPLOYEE AS E LEFT OUTER JOIN EMPLOYEE AS S
ON E.Super_ssn = S.Ssn);
```

#### RIGHT OUTER

- every tuple in the RR *must* appear in the result
- if no matching tuple exists add `NULL` to LR

## Analytics


## Modification

</div>