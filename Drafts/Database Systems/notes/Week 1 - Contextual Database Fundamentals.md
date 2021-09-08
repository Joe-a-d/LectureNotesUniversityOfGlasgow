# Week 1 - Contextual Database Fundamentals

<div id="content">

In the most general of senses, a database is a memory aid tool with the capability to update, delete, recall and store large amounts of data. But a DB is often characterized according to the context in which it is used, or by whom uses it.

## Data Management System

### from a SE perspective, main funnctionailty is to provide software to:

- modelling data
  - examples
- accessing data
  - query, insert, delete, update
- analyze data
- physically store data
- securing data
- maintaining data consistency
- opttimise data retrieval
  - data structures
  - algorithms

### User perspective

- data modelling
- declarative programming language (SQL) to manage and query data

REM declarative tell it what to do not how

### Systems Eng

- set of interconnected components
- course focus
  - SQL
  - connector
  - optimizer
  - processing algorithms

## Types of Data

1. structured: separated into data and meta-data (e.g. tables)
2. unstructured: lack meta-data, hard to interpretaded meaning (e.g texts)
3. semi-structured : self-descriptive; self-interpretation (e.g XML, JSON)

## Conceptual Data Modelling

Motivation: want to transform textual description of a real problem into a set of concepts conveying exactly the same information


2 approaches
**Entity-Relationship

- does not guarantee optimality of the four fundamental operations

** Relational modelling

- mathematically driven
- guarantees optimization


## Relational 

Concept data model
: mathematical model for interpreting data

Is is mathematical driven because it relies on theorems from different branches of mathematics, but it is also interpreted since the goal here is to represent some entity in the world, i.e it needs to be context-aware (entities, attributes, relationships)

Relational Conc Mod
: any entity might relate with any other entity when they both share common attributes

define relation

represent an entity as a 2D table whose table consistts of an ordered set of attributes and whose rows represent instances. 
One of the attrivutes uniqueley identifies an instance

### FORMALLY

Schema of a relation : R(A, A2,...) where R is name and As are an ordered set of attributes ; each attribute has its own domain

tuple t of R $t = (v,v2,..) vi E Di$

instance r(R) set of tuples

relational DB schema, set of relations



# Integrity

Superkey

the subset of arguments where at least one of the arguments uniquely identifies the entity

Candidate Key

superkey with minimum number of attributes

{ID,Passport} - SK
{ID} - SK & CK


NULL FK EXAMPLE

![](@attachment/Clipboard_2021-01-15-10-37-30.png)



</div>