# Banking System: BI-Driven Operational Analysis

## Project Overview
This project implements a comprehensive relational database for a modern banking system using SQL Server. The primary goal is to simulate a real-world banking environment, starting from schema design and "fake" data generation to calculating key business intelligence (BI) metrics.

The project addresses critical banking challenges—such as cybersecurity vulnerabilities, outdated technology, and regulatory compliance—by leveraging data analytics and visualization.

## Database Schema & ER Diagram
![Banking System ER Diagram](https://raw.githubusercontent.com/shakarovamadina33-png/Banking_System_Project/main/Diagram%20Banking%20System/photo_2026-03-31_21-50-35.jpg)

**Description:**
This database diagram represents a normalized relational schema with **30 tables**. It covers all core banking operational areas:
* **Customer 360:** Customers, Accounts, KYC, Credit Scores.
* **Operations:** Employees, Branches, Departments, Salaries, Attendance.
* **Transactions:** Payments, Mobile Transactions, Foreign Exchange, Merchant Activities.
* **Credit & Risk:** Loans, Loan Payments, Credit Cards, Debt Collection.
* **Digital & Security:** Online Banking Users, Cyber Security Incidents, Fraud Detection, AML Cases.

## Project Objectives
* **Database Development:** Design and build a complex, normalized SQL Server database for the banking sector.
* **Data Simulation:** Create "fake" transactional data and populate all 30 tables to support analytics.
* **Fraud Detection Analysis:** Identify flagged transactions based on risk levels (High, Medium).
* **Operational BI:** Monitor system performance, resource utilization, and compliance workflows.

## Key Performance Indicators (KPIs)
The system calculates essential metrics derived from operational data:
* **Top Depositors:** Identification of customers with the highest total balance across all accounts.
* **Debt Risk Analysis:** Detection of customers holding multiple active loans.
* **Fraud Monitoring:** Analysis of transactions flagged for fraud based on risk level.
* **Branch Performance:** Calculation of the total loan amount issued per branch.
* **Velocity Checks (Fraud Prevention):** Detection of customers making large transactions within a short time frame (less than 1 hour apart).
* **Geo-fencing (Fraud Prevention):** Identification of simultaneous transactions from different countries within 10 minutes.

## Technical Highlights
* **SQL Server Implementation:** All database operations are performed using T-SQL.
* **Complex Data Modeling:** Normalized relational schema (ER Modeling).
* **Fake Data Generation:** Data populated using WHILE loops, CTEs, Window Functions, and standard T-SQL functions.
* **Advanced Analytics:** extensive use of Window Functions (`PARTITION BY`), CTEs, Aggregations, and Date Functions.

## Tools & Technologies
* **Database:** SQL Server
* **Language:** T-SQL
* **Modeling:** Normalized Relational Schema
* **Concepts:** Cybersecurity monitoring, Fraud detection, AML compliance.
