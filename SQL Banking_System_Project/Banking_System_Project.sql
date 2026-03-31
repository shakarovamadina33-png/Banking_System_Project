create database Banking_System_Project 
go
use Banking_System_Project

--Banking System Database Schema (Creating 30 Tables)

--CUSTOMERS

CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    DOB DATE NOT NULL,
    Email NVARCHAR(150) UNIQUE NOT NULL,
    PhoneNumber NVARCHAR(20) UNIQUE NOT NULL,
    Address NVARCHAR(255) NOT NULL,
    NationalID NVARCHAR(20) UNIQUE NOT NULL,
    TaxID NVARCHAR(20) UNIQUE NOT NULL,
    EmploymentStatus NVARCHAR(30),
    AnnualIncome DECIMAL(12,2),
    CreatedAt DATETIME2 DEFAULT SYSDATETIME(),
    UpdatedAt DATETIME2 DEFAULT SYSDATETIME()
);

;WITH FirstNames AS (
    SELECT Name, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS rn
    FROM (VALUES
        ('James'),('John'),('Robert'),('Michael'),('William'),
        ('David'),('Richard'),('Joseph'),('Thomas'),('Charles'),
        ('Daniel'),('Matthew'),('Anthony'),('Mark'),('Donald'),
        ('Steven'),('Paul'),('Andrew'),('Joshua'),('Kevin'),
        ('Brian'),('George'),('Edward'),('Ronald'),('Timothy'),
        ('Jason'),('Jeffrey'),('Ryan'),('Jacob'),('Gary'),
        ('Nicholas'),('Eric'),('Stephen'),('Jonathan'),('Larry'),
        ('Justin'),('Scott'),('Brandon'),('Benjamin'),('Samuel'),
        ('Frank'),('Gregory'),('Raymond'),('Alexander'),('Patrick'),
        ('Jack'),('Dennis'),('Jerry'),('Tyler'),('Aaron'),
        ('Jose'),('Henry'),('Adam'),('Douglas'),('Nathan'),
        ('Peter'),('Zachary'),('Kyle'),('Walter'),('Harold'),
        ('Jeremy'),('Ethan'),('Carl'),('Keith'),('Roger'),
        ('Gerald'),('Christian'),('Terry'),('Sean'),('Arthur'),
        ('Austin'),('Noah'),('Jesse'),('Joe'),('Bryan'),
        ('Billy'),('Jordan'),('Albert'),('Dylan'),('Bruce'),
        ('Willie'),('Gabriel'),('Alan'),('Juan'),('Logan'),
        ('Mary'),('Patricia'),('Jennifer'),('Linda'),('Elizabeth'),
        ('Barbara'),('Susan'),('Jessica'),('Sarah'),('Karen'),
        ('Nancy'),('Lisa'),('Betty'),('Margaret'),('Sandra'),
        ('Ashley'),('Kimberly'),('Emily'),('Donna'),('Michelle')
    ) AS FN(Name)
),
LastNames AS (
    SELECT Name, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS rn
    FROM (VALUES
        ('Smith'),('Johnson'),('Williams'),('Brown'),('Jones'),
        ('Garcia'),('Miller'),('Davis'),('Rodriguez'),('Martinez'),
        ('Hernandez'),('Lopez'),('Gonzalez'),('Wilson'),('Anderson'),
        ('Thomas'),('Taylor'),('Moore'),('Jackson'),('Martin'),
        ('Lee'),('Perez'),('Thompson'),('White'),('Harris'),
        ('Sanchez'),('Clark'),('Ramirez'),('Lewis'),('Robinson'),
        ('Walker'),('Young'),('Allen'),('King'),('Wright'),
        ('Scott'),('Torres'),('Nguyen'),('Hill'),('Flores'),
        ('Green'),('Adams'),('Nelson'),('Baker'),('Hall'),
        ('Rivera'),('Campbell'),('Mitchell'),('Carter'),('Roberts'),
        ('Gomez'),('Phillips'),('Evans'),('Turner'),('Diaz'),
        ('Parker'),('Cruz'),('Edwards'),('Collins'),('Reyes'),
        ('Stewart'),('Morris'),('Morales'),('Murphy'),('Cook'),
        ('Rogers'),('Gutierrez'),('Ortiz'),('Morgan'),('Cooper'),
        ('Peterson'),('Bailey'),('Reed'),('Kelly'),('Howard'),
        ('Ramos'),('Kim'),('Cox'),('Ward'),('Richardson'),
        ('Watson'),('Brooks'),('Chavez'),('Wood'),('James'),
        ('Bennett'),('Gray'),('Jameson'),('Hughes'),('Foster'),
        ('Sanders'),('Ross'),('Patel'),('Long'),('Collier')
    ) AS LN(Name)
),
StreetNames AS (
    SELECT Name, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS rn
    FROM (VALUES
        ('Elm'),('Maple'),('Oak'),('Pine'),('Cedar'),
        ('Birch'),('Walnut'),('Main'),('Park'),('Washington'),
        ('Lake'),('Hill'),('Sunset'),('Forest'),('River'),
        ('Cherry'),('Highland'),('North'),('South'),('East')
    ) AS SN(Name)
),
Numbers AS (
    SELECT TOP (5000) ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS n
    FROM sys.objects a CROSS JOIN sys.objects b
),
Names AS (
    SELECT TOP (5000)
        n.n,
        fn.Name AS FirstName,
        ln.Name AS LastName,
        100 + ((n.n - 1) % 900) AS StreetNumber,
        sn.Name AS StreetName
    FROM Numbers n
    CROSS APPLY (SELECT Name FROM FirstNames WHERE rn = ((n.n-1) % 100) + 1) fn
    CROSS APPLY (SELECT Name FROM LastNames WHERE rn = ((n.n-1) / 100) + 1) ln
    CROSS APPLY (SELECT Name FROM StreetNames WHERE rn = ((n.n-1) % 20) + 1) sn
    ORDER BY n.n
)
INSERT INTO Customers (
    FullName, DOB, Email, PhoneNumber, Address,
    NationalID, TaxID, EmploymentStatus, AnnualIncome,
    CreatedAt, UpdatedAt
)
SELECT
    CONCAT(FirstName,' ',LastName) AS FullName,
    DATEADD(DAY, - (6570 + n % 17000), CAST(GETDATE() AS DATE)) AS DOB,
    LOWER(CONCAT(FirstName, LastName,'@gmail.com')) AS Email,
    CONCAT('+9989', RIGHT('00000000' + CAST(n * 97 % 100000000 AS VARCHAR), 8)) AS PhoneNumber,
    CONCAT(StreetNumber,' ',StreetName,' St, Tashkent') AS Address,
    CONCAT('NID', RIGHT('000000000' + CAST(n AS VARCHAR), 9)) AS NationalID,
    CONCAT('TID', RIGHT('000000000' + CAST(n * 7 AS VARCHAR), 9)) AS TaxID,
    CHOOSE(1 + n % 5,'Employed','Self-Employed','Unemployed','Student','Retired') AS EmploymentStatus,
    CAST(30000 + (n % 90000) AS DECIMAL(12,2)) AS AnnualIncome,
    DATEADD(DAY, - (n % 1000), SYSDATETIME()) AS CreatedAt,
    SYSDATETIME() AS UpdatedAt
FROM Names;
go
select * from Customers

--DEPARTMENTS
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY IDENTITY(1,1),
    DepartmentName NVARCHAR(100) NOT NULL,
    ManagerID INT NULL 
);

INSERT INTO Departments (DepartmentName, ManagerID)
VALUES 
('Retail Banking', NULL),
('Corporate Finance', NULL),
('IT & Cybersecurity', NULL),
('Human Resources', NULL),
('Risk & Compliance', NULL),
('Legal', NULL),
('Marketing', NULL),
('Investment & Treasury', NULL);
go 
SELECT * FROM Departments;

--REGULATORY REPORTS

CREATE TABLE RegulatoryReports (
    ReportID INT PRIMARY KEY IDENTITY(1,1),
    ReportType NVARCHAR(100) NOT NULL,
    SubmissionDate DATE NOT NULL
);

INSERT INTO RegulatoryReports (ReportType, SubmissionDate)
VALUES 
('Anti-Money Laundering (AML) Monthly', '2023-01-31'),
('Quarterly Financial Stability Report', '2023-03-31'),
('Annual Audit Compliance', '2023-12-31'),
('Customer Privacy Protection Report', '2023-02-15'),
('Capital Adequacy Ratio (CAR) Report', '2023-04-30'),
('Liquidity Coverage Ratio (LCR) Report', '2023-05-31'),
('Monthly Fraud Activity Summary', '2023-06-30'),
('Foreign Exchange Exposure Report', '2023-07-31'),
('Internal Risk Assessment Report', '2023-08-31'),
('Cybersecurity Compliance Audit', '2023-09-30');
go
SELECT * FROM RegulatoryReports;

--CYBER SECURITY INCIDENTS
 
 CREATE TABLE CyberSecurityIncidents (
    IncidentID INT PRIMARY KEY IDENTITY(1,1),
    AffectedSystem NVARCHAR(100) NOT NULL,
    ReportedDate DATETIME NOT NULL,
    ResolutionStatus NVARCHAR(50) NOT NULL 
);


INSERT INTO CyberSecurityIncidents (AffectedSystem, ReportedDate, ResolutionStatus)
VALUES 
('Online Banking Portal', '2024-01-05 09:15:00', 'Resolved'),
('ATM Network Central Server', '2024-01-12 22:40:00', 'Resolved'),
('SWIFT Payment Gateway', '2024-02-03 14:20:00', 'In Progress'),
('Internal HR Database', '2024-02-18 11:10:00', 'Resolved'),
('Mobile App API', '2024-03-01 03:05:00', 'Escalated'),
('Credit Card Processing Unit', '2024-03-15 16:45:00', 'Resolved'),
('Corporate Email Server', '2024-04-10 08:30:00', 'Resolved'),
('Branch WiFi Network - Downtown', '2024-04-22 10:00:00', 'In Progress'),
('Customer Data Warehouse', '2024-05-05 23:55:00', 'Escalated'),
('Loan Application Module', '2024-05-20 13:12:00', 'Resolved');
GO
SELECT * FROM CyberSecurityIncidents;

--BRANCHES

 CREATE TABLE Branches (
    BranchID INT PRIMARY KEY IDENTITY(1,1),
    BranchName NVARCHAR(100) NOT NULL,
    Address NVARCHAR(255) NOT NULL,
    City NVARCHAR(100) NOT NULL,
    State NVARCHAR(100) NOT NULL,
    Country NVARCHAR(100) NOT NULL,
    ManagerID INT NULL, 
    ContactNumber NVARCHAR(20) NOT NULL
);

 INSERT INTO Branches (BranchName, Address, City, State, Country, ManagerID, ContactNumber)
VALUES 
('Main Plaza Branch', '101 Wall St', 'New York', 'NY', 'USA', NULL, '+1-212-555-0101'),
('Sunset Blvd Branch', '500 Sunset Blvd', 'Los Angeles', 'CA', 'USA', NULL, '+1-310-555-0102'),
('Magnolia Square', '75 Peach Tree St', 'Atlanta', 'GA', 'USA', NULL, '+1-404-555-0103'),
('Lakeside Hub', '22 Michigan Ave', 'Chicago', 'IL', 'USA', NULL, '+1-312-555-0104'),
('Bay Area Center', '333 Market St', 'San Francisco', 'CA', 'USA', NULL, '+1-415-555-0105'),
('Liberty Bell Branch', '15 Chestnut St', 'Philadelphia', 'PA', 'USA', NULL, '+1-215-555-0106'),
('Lone Star Station', '800 Congress Ave', 'Austin', 'TX', 'USA', NULL, '+1-512-555-0107'),
('Evergreen Office', '1200 4th Ave', 'Seattle', 'WA', 'USA', NULL, '+1-206-555-0108'),
('Mile High Branch', '1700 Broadway', 'Denver', 'CO', 'USA', NULL, '+1-303-555-0109'),
('French Quarter Bank', '400 Royal St', 'New Orleans', 'LA', 'USA', NULL, '+1-504-555-0110'),
('Emerald City Suite', '901 Main St', 'Miami', 'FL', 'USA', NULL, '+1-305-555-0111'),
('Desert Oasis', '100 Washington St', 'Phoenix', 'AZ', 'USA', NULL, '+1-602-555-0112'),
('Faneuil Hall Branch', '10 State St', 'Boston', 'MA', 'USA', NULL, '+1-617-555-0113'),
('Gateway Arch Branch', '500 Pine St', 'St. Louis', 'MO', 'USA', NULL, '+1-314-555-0114'),
('Space Needle Branch', '400 Broad St', 'Seattle', 'WA', 'USA', NULL, '+1-206-555-0115'),
('Vegas Strip Branch', '3600 Las Vegas Blvd', 'Las Vegas', 'NV', 'USA', NULL, '+1-702-555-0116'),
('Music City Bank', '200 Rep. John Lewis Way', 'Nashville', 'TN', 'USA', NULL, '+1-615-555-0117'),
('Alamo Square Branch', '300 Alamo Plaza', 'San Antonio', 'TX', 'USA', NULL, '+1-210-555-0118'),
('Twin Cities Branch', '500 Nicollet Mall', 'Minneapolis', 'MN', 'USA', NULL, '+1-612-555-0119'),
('Rose City Branch', '700 SW 5th Ave', 'Portland', 'OR', 'USA', NULL, '+1-503-555-0120');
GO
SELECT * FROM Branches;

--EMPLOYEES

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY IDENTITY(1,1),
    BranchID INT NOT NULL,
    FullName NVARCHAR(150) NOT NULL,
    Position NVARCHAR(100) NOT NULL,
    Department NVARCHAR(100) NOT NULL,
    Salary DECIMAL(18, 2) NOT NULL,
    HireDate DATE NOT NULL,
    Status NVARCHAR(50) NOT NULL, 
    CONSTRAINT FK_Employee_Branch FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
);

DECLARE @cnt INT = 1;
WHILE @cnt <= 100
BEGIN
    INSERT INTO Employees (BranchID, FullName, Position, Department, Salary, HireDate, Status)
    VALUES (
        ((@cnt - 1) % 20) + 1, 
        CASE 
            WHEN @cnt % 3 = 0 THEN 'Employee ' + CAST(@cnt AS VARCHAR) + ' Smith'
            WHEN @cnt % 3 = 1 THEN 'Employee ' + CAST(@cnt AS VARCHAR) + ' Johnson'
            ELSE 'Employee ' + CAST(@cnt AS VARCHAR) + ' Williams'
        END,
        CASE 
            WHEN @cnt % 5 = 0 THEN 'Branch Manager'
            WHEN @cnt % 5 = 1 THEN 'Senior Teller'
            WHEN @cnt % 5 = 2 THEN 'Loan Officer'
            WHEN @cnt % 5 = 3 THEN 'IT Specialist'
            ELSE 'Customer Service Rep'
        END,
        CASE 
            WHEN @cnt % 4 = 0 THEN 'Retail Banking'
            WHEN @cnt % 4 = 1 THEN 'IT & Cybersecurity'
            WHEN @cnt % 4 = 2 THEN 'Risk & Compliance'
            ELSE 'Human Resources'
        END,
        45000 + (RAND() * 50000), 
        DATEADD(DAY, - (RAND() * 3650), GETDATE()), 
        'Active'
    );
    SET @cnt = @cnt + 1;
END;

SELECT * FROM Employees

-------------------------------------------------------------------
ALTER TABLE Employees DROP COLUMN Department;

-----------------------------------------------------------------
ALTER TABLE Employees ADD DepartmentID INT;

------------------------------------------------------------------
ALTER TABLE Employees 
ADD CONSTRAINT FK_Employee_Department FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID);

-----------------------------------------------------------------
UPDATE Employees 
SET DepartmentID = (EmployeeID % 8) + 1; 

-----------------------------------------------------------------
ALTER TABLE Employees ALTER COLUMN DepartmentID INT NOT NULL;

-----------------------------------------------------------------
--BRANCHES (CONNECTING WITH A FOREIGHN KEY)
UPDATE Branches
SET ManagerID = (
    SELECT MIN(EmployeeID) 
    FROM Employees 
    WHERE Employees.BranchID = Branches.BranchID
);
-------------------------------------------------------
ALTER TABLE Branches
ADD CONSTRAINT FK_Branch_Manager 
FOREIGN KEY (ManagerID) REFERENCES Employees(EmployeeID);

---------------------------------------------------------

--KYC(Know Your Customer)


CREATE TABLE KYC (
    KYCID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT NOT NULL, 
    DocumentType NVARCHAR(50) NOT NULL, 
    DocumentNumber NVARCHAR(100) NOT NULL,
    VerifiedBy INT NOT NULL, 
    CONSTRAINT FK_KYC_Customer FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    CONSTRAINT FK_KYC_Employee FOREIGN KEY (VerifiedBy) REFERENCES Employees(EmployeeID)
);


DECLARE @k INT = 1;
WHILE @k <= 5000
BEGIN
    INSERT INTO KYC (CustomerID, DocumentType, DocumentNumber, VerifiedBy)
    VALUES (
        @k,
        CASE 
            WHEN @k % 3 = 0 THEN 'Passport'
            WHEN @k % 3 = 1 THEN 'National ID'
            ELSE 'Drivers License'
        END,
        'ID-' + CAST(100000 + @k AS VARCHAR), 
        (@k % 100) + 1 
    );
    SET @k = @k + 1;
END;

SELECT * FROM KYC;

--ACCOUNTS 

CREATE TABLE Accounts (
    AccountID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT NOT NULL,
    AccountType NVARCHAR(50) NOT NULL, 
    Balance DECIMAL(18, 2) DEFAULT 0.00,
    Currency NVARCHAR(10) DEFAULT 'USD',
    Status NVARCHAR(20) DEFAULT 'Active',
    BranchID INT NOT NULL,
    CreatedDate DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Account_Customer FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    CONSTRAINT FK_Account_Branch FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
);


DECLARE @acc INT = 1;
WHILE @acc <= 1500
BEGIN
    INSERT INTO Accounts (CustomerID, AccountType, Balance, Currency, Status, BranchID)
    VALUES (
        @acc, 
        CASE 
            WHEN @acc % 3 = 0 THEN 'Savings'
            WHEN @acc % 3 = 1 THEN 'Checking'
            ELSE 'Business'
        END,
        ROUND(RAND() * 10000, 2), 
        'USD',
        'Active',
        ((@acc - 1) % 20) + 1 
    );
    SET @acc = @acc + 1;
END;

SELECT * FROM Accounts;	

--CREDIT SCORES
    CREATE TABLE CreditScores (
        CustomerID INT NOT NULL,
        CreditScore INT NOT NULL,
        UpdatedAt DATETIME DEFAULT GETDATE(),
        CONSTRAINT FK_CreditScore_Customer FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
    );

INSERT INTO CreditScores (CustomerID, CreditScore, UpdatedAt)
SELECT TOP 100 
    CustomerID, 
    FLOOR(RAND(CHECKSUM(NEWID()))*(850-300+1)+300), 
    DATEADD(DAY, - (ABS(CHECKSUM(NEWID())) % 30), GETDATE()) 
FROM Customers
ORDER BY NEWID(); 

SELECT * FROM CreditScores;

--ONLINE BANKING USERS 
    CREATE TABLE OnlineBankingUsers (
        UserID INT PRIMARY KEY IDENTITY(1,1),
        CustomerID INT NOT NULL,
        Username NVARCHAR(50) NOT NULL UNIQUE,
        PasswordHash NVARCHAR(255) NOT NULL,
        LastLogin DATETIME NULL,
        CONSTRAINT FK_OnlineUser_Customer FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
    );

INSERT INTO OnlineBankingUsers (CustomerID, Username, PasswordHash, LastLogin)
SELECT TOP 400 
    CustomerID, 
    LOWER(REPLACE(FullName, ' ', '_')) + CAST(CustomerID AS NVARCHAR),
    'HASH' + CAST(ABS(CHECKSUM(NEWID())) AS NVARCHAR), 
    DATEADD(MINUTE, - (ABS(CHECKSUM(NEWID())) % 50000), GETDATE()) 
FROM Customers
ORDER BY NEWID();

SELECT * FROM OnlineBankingUsers;

--BILL PAYMENTS
    CREATE TABLE BillPayments (
        PaymentID INT PRIMARY KEY IDENTITY(1,1),
        CustomerID INT NOT NULL,
        BillerName NVARCHAR(100) NOT NULL, 
        Amount DECIMAL(10, 2) NOT NULL,
        PaymentDate DATETIME DEFAULT GETDATE(),
        Status NVARCHAR(20) NOT NULL, 
        CONSTRAINT FK_BillPayment_Customer FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
    );

INSERT INTO BillPayments (CustomerID, BillerName, Amount, PaymentDate, Status)
SELECT TOP 100 
    CustomerID, 
    CASE (ABS(CHECKSUM(NEWID())) % 5)
        WHEN 0 THEN 'National Grid (Electricity)'
        WHEN 1 THEN 'City Water Services'
        WHEN 2 THEN 'SkyNet Internet'
        WHEN 3 THEN 'Mobile Telecom Plus'
        ELSE 'Municipal Gas'
    END AS BillerName,
    ROUND((RAND(CHECKSUM(NEWID())) * 450) + 20, 2) AS Amount,
    DATEADD(DAY, - (ABS(CHECKSUM(NEWID())) % 60), GETDATE()) AS PaymentDate,
    CASE (ABS(CHECKSUM(NEWID())) % 10)
        WHEN 0 THEN 'Failed'
        WHEN 1 THEN 'Pending'
        ELSE 'Completed'
    END AS Status
FROM Customers
ORDER BY NEWID(); 

SELECT * FROM BillPayments;

--MOBILE BANKING TRANSACTIONS

    CREATE TABLE MobileBankingTransactions (
        TransactionID INT PRIMARY KEY IDENTITY(1,1),
        CustomerID INT NOT NULL,
        DeviceID NVARCHAR(100) NOT NULL, 
        AppVersion NVARCHAR(20) NOT NULL, 
        TransactionType NVARCHAR(50) NOT NULL, 
        Amount DECIMAL(15, 2) NOT NULL,
        TransactionDate DATETIME DEFAULT GETDATE(),
        CONSTRAINT FK_MobileTrans_Customer FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
    );

INSERT INTO MobileBankingTransactions (CustomerID, DeviceID, AppVersion, TransactionType, Amount, TransactionDate)
SELECT TOP 150 
    CustomerID, 
    'DEV-' + CAST(ABS(CHECKSUM(NEWID())) % 999999 AS NVARCHAR) + '-IOS',
    'v' + CAST((ABS(CHECKSUM(NEWID())) % 3) + 2 AS NVARCHAR) + '.1.' + CAST(ABS(CHECKSUM(NEWID())) % 9 AS NVARCHAR), 
    CASE (ABS(CHECKSUM(NEWID())) % 4)
        WHEN 0 THEN 'P2P Transfer'
        WHEN 1 THEN 'Mobile Top-up'
        WHEN 2 THEN 'QR Payment'
        ELSE 'Utility Payment'
    END AS TransactionType,
    ROUND((RAND(CHECKSUM(NEWID())) * 1000) + 5, 2) AS Amount, 
    DATEADD(MINUTE, - (ABS(CHECKSUM(NEWID())) % 10000), GETDATE()) 
FROM Customers
ORDER BY NEWID();

SELECT * FROM MobileBankingTransactions;

--LOANS

    CREATE TABLE Loans (
        LoanID INT PRIMARY KEY IDENTITY(1,1),
        CustomerID INT NOT NULL,
        LoanType NVARCHAR(50) NOT NULL, 
        Amount DECIMAL(18, 2) NOT NULL,
        InterestRate DECIMAL(5, 2) NOT NULL,
        StartDate DATE NOT NULL,
        EndDate DATE NOT NULL,
        Status NVARCHAR(20) NOT NULL, 
        CONSTRAINT FK_Loan_Customer FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
    );

INSERT INTO Loans (CustomerID, LoanType, Amount, InterestRate, StartDate, EndDate, Status)
SELECT TOP 100 
    CustomerID, 
    L.LType,
    CASE L.LType 
        WHEN 'Mortgage' THEN ROUND((RAND(CHECKSUM(NEWID())) * 300000) + 50000, 2)
        WHEN 'Business' THEN ROUND((RAND(CHECKSUM(NEWID())) * 100000) + 10000, 2)
        WHEN 'Auto' THEN ROUND((RAND(CHECKSUM(NEWID())) * 40000) + 5000, 2)
        ELSE ROUND((RAND(CHECKSUM(NEWID())) * 15000) + 1000, 2)
    END AS Amount,
    CASE L.LType 
        WHEN 'Mortgage' THEN 3.5 + (RAND(CHECKSUM(NEWID())) * 2)
        WHEN 'Business' THEN 7.0 + (RAND(CHECKSUM(NEWID())) * 5)
        WHEN 'Auto' THEN 4.5 + (RAND(CHECKSUM(NEWID())) * 3)
        ELSE 10.0 + (RAND(CHECKSUM(NEWID())) * 8)
    END AS InterestRate,
    DATEADD(MONTH, - (ABS(CHECKSUM(NEWID())) % 24), GETDATE()) AS StartDate, 
    DATEADD(MONTH, (ABS(CHECKSUM(NEWID())) % 60) + 12, GETDATE()) AS EndDate, 
    CASE (ABS(CHECKSUM(NEWID())) % 10)
        WHEN 0 THEN 'Defaulted'
        WHEN 1 THEN 'Closed'
        ELSE 'Active'
    END AS Status
FROM Customers
CROSS APPLY (SELECT CASE (ABS(CHECKSUM(NEWID())) % 4)
    WHEN 0 THEN 'Mortgage'
    WHEN 1 THEN 'Personal'
    WHEN 2 THEN 'Auto'
    ELSE 'Business'
END AS LType) AS L
ORDER BY NEWID();

SELECT * FROM Loans;

--DEBTCOLLECTION
    CREATE TABLE DebtCollection (
        DebtID INT PRIMARY KEY IDENTITY(1,1),
        CustomerID INT NOT NULL,
        AmountDue DECIMAL(18, 2) NOT NULL,
        DueDate DATE NOT NULL,
        CollectorAssigned INT NOT NULL, 
        CONSTRAINT FK_Debt_Customer FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
        CONSTRAINT FK_Debt_Employee FOREIGN KEY (CollectorAssigned) REFERENCES Employees(EmployeeID)
    );

INSERT INTO DebtCollection (CustomerID, AmountDue, DueDate, CollectorAssigned)
SELECT TOP 30 
    CustomerID, 
    ROUND((RAND(CHECKSUM(NEWID())) * 15000) + 500, 2) AS AmountDue, 
    DATEADD(DAY, - (ABS(CHECKSUM(NEWID())) % 90), GETDATE()) AS DueDate, 
    (ABS(CHECKSUM(NEWID())) % 100) + 1 
FROM Customers
ORDER BY NEWID();

SELECT * FROM DebtCollection
--CHECK 
SELECT 
    d.DebtID, 
    c.FullName AS DebtorName, 
    d.AmountDue, 
    d.DueDate, 
    e.FullName AS CollectorName
FROM DebtCollection d
JOIN Customers c ON d.CustomerID = c.CustomerID
JOIN Employees e ON d.CollectorAssigned = e.EmployeeID;

--AMLCASES
    CREATE TABLE AMLCases (
        CaseID INT PRIMARY KEY IDENTITY(1,1),
        CustomerID INT NOT NULL, 
        CaseType NVARCHAR(100) NOT NULL, 
        Status NVARCHAR(50) NOT NULL, 
        InvestigatorID INT NOT NULL, 
        CONSTRAINT FK_AML_Customer FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
        CONSTRAINT FK_AML_Employee FOREIGN KEY (InvestigatorID) REFERENCES Employees(EmployeeID)
    );

INSERT INTO AMLCases (CustomerID, CaseType, Status, InvestigatorID)
SELECT TOP 20 
    CustomerID, 
    CASE (ABS(CHECKSUM(NEWID())) % 4)
        WHEN 0 THEN 'Structuring (Smurfing)'
        WHEN 1 THEN 'Unusual Transaction Velocity'
        WHEN 2 THEN 'High-Risk Jurisdiction Transfer'
        ELSE 'Identity Theft Suspicion'
    END AS CaseType,
    CASE (ABS(CHECKSUM(NEWID())) % 4)
        WHEN 0 THEN 'Open'
        WHEN 1 THEN 'Under Investigation'
        WHEN 2 THEN 'Closed - Cleared'
        ELSE 'Reported to Regulator'
    END AS Status,
    (ABS(CHECKSUM(NEWID())) % 100) + 1 
FROM Customers
ORDER BY NEWID();

SELECT * FROM AMLCases

--INVESTMENTS

CREATE TABLE Investments (
        InvestmentID INT PRIMARY KEY IDENTITY(1,1),
        CustomerID INT NOT NULL,
        InvestmentType NVARCHAR(50) NOT NULL, 
        Amount DECIMAL(18, 2) NOT NULL,
        ROI DECIMAL(5, 2) NOT NULL, 
        MaturityDate DATE NOT NULL,
        CONSTRAINT FK_Investment_Customer FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
    );


INSERT INTO Investments (CustomerID, InvestmentType, Amount, ROI, MaturityDate)
SELECT TOP 60 
    CustomerID, 
    I.IType,
    CASE I.IType 
        WHEN 'Fixed Deposit' THEN ROUND((RAND(CHECKSUM(NEWID())) * 50000) + 1000, 2)
        WHEN 'Gold' THEN ROUND((RAND(CHECKSUM(NEWID())) * 20000) + 5000, 2)
        WHEN 'Bonds' THEN ROUND((RAND(CHECKSUM(NEWID())) * 100000) + 10000, 2)
        ELSE ROUND((RAND(CHECKSUM(NEWID())) * 30000) + 2000, 2)
    END AS Amount,
    CASE I.IType 
        WHEN 'Fixed Deposit' THEN 4.5 + (RAND(CHECKSUM(NEWID())) * 2) 
        WHEN 'Bonds' THEN 3.0 + (RAND(CHECKSUM(NEWID())) * 3)
        ELSE 8.0 + (RAND(CHECKSUM(NEWID())) * 12) 
    END AS ROI,
    DATEADD(YEAR, (ABS(CHECKSUM(NEWID())) % 5) + 1, GETDATE()) AS MaturityDate
FROM Customers
CROSS APPLY (SELECT CASE (ABS(CHECKSUM(NEWID())) % 4)
    WHEN 0 THEN 'Fixed Deposit'
    WHEN 1 THEN 'Mutual Funds'
    WHEN 2 THEN 'Gold'
    ELSE 'Bonds'
END AS IType) AS I
ORDER BY NEWID();

SELECT * FROM Investments;

--STOCK TRADING ACOOUNTS

    CREATE TABLE StockTradingAccounts (
        AccountID INT PRIMARY KEY IDENTITY(1,1),
        CustomerID INT NOT NULL,
        BrokerageFirm NVARCHAR(100) NOT NULL, 
        TotalInvested DECIMAL(18, 2) NOT NULL, 
        CurrentValue DECIMAL(18, 2) NOT NULL, 
        CONSTRAINT FK_StockAccount_Customer FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
    );



INSERT INTO StockTradingAccounts (CustomerID, BrokerageFirm, TotalInvested, CurrentValue)
SELECT TOP 40 
    CustomerID, 
    CASE (ABS(CHECKSUM(NEWID())) % 5)
        WHEN 0 THEN 'Interactive Brokers'
        WHEN 1 THEN 'Charles Schwab'
        WHEN 2 THEN 'E*TRADE'
        WHEN 3 THEN 'Fidelity Investments'
        ELSE 'Robinhood Financial'
    END AS BrokerageFirm,
    ROUND((RAND(CHECKSUM(NEWID())) * 50000) + 500, 2) AS Invested,
    0 AS CurrentValue 
FROM Customers
ORDER BY NEWID();

UPDATE StockTradingAccounts
SET CurrentValue = TotalInvested * (0.85 + (RAND(CHECKSUM(CAST(AccountID AS VARCHAR))) * 0.35));

SELECT * FROM StockTradingAccounts
-- CHECK
SELECT 
    AccountID, 
    CustomerID, 
    BrokerageFirm, 
    TotalInvested, 
    CurrentValue,
    (CurrentValue - TotalInvested) AS ProfitLoss
FROM StockTradingAccounts;

--FOREIGN EXCHANGE

    CREATE TABLE ForeignExchange (
        FXID INT PRIMARY KEY IDENTITY(1,1),
        CustomerID INT NOT NULL,
        CurrencyPair NVARCHAR(10) NOT NULL, 
        ExchangeRate DECIMAL(10, 4) NOT NULL,
        AmountExchanged DECIMAL(18, 2) NOT NULL, 
        TransactionDate DATETIME DEFAULT GETDATE(),
        CONSTRAINT FK_FX_Customer FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
    );

INSERT INTO ForeignExchange (CustomerID, CurrencyPair, ExchangeRate, AmountExchanged)
SELECT TOP 50 
    CustomerID, 
    FX.CPair,
    CASE FX.CPair 
        WHEN 'EUR/USD' THEN 1.08 + (RAND(CHECKSUM(NEWID())) * 0.05)
        WHEN 'GBP/USD' THEN 1.25 + (RAND(CHECKSUM(NEWID())) * 0.05)
        WHEN 'USD/JPY' THEN 145.0 + (RAND(CHECKSUM(NEWID())) * 10.0)
        WHEN 'USD/UZS' THEN 12600.0 + (RAND(CHECKSUM(NEWID())) * 200.0)
        ELSE 0.90 + (RAND(CHECKSUM(NEWID())) * 0.1)
    END AS ExchangeRate,
    ROUND((RAND(CHECKSUM(NEWID())) * 10000) + 100, 2) AS AmountExchanged
FROM Customers
CROSS APPLY (SELECT CASE (ABS(CHECKSUM(NEWID())) % 5)
    WHEN 0 THEN 'EUR/USD'
    WHEN 1 THEN 'GBP/USD'
    WHEN 2 THEN 'USD/JPY'
    WHEN 3 THEN 'USD/UZS'
    ELSE 'USD/CHF'
END AS CPair) AS FX
ORDER BY NEWID();

SELECT * FROM ForeignExchange;

--INSURANCE PLOCIES

    CREATE TABLE InsurancePolicies (
        PolicyID INT PRIMARY KEY IDENTITY(1,1),
        CustomerID INT NOT NULL,
        InsuranceType NVARCHAR(50) NOT NULL, 
        PremiumAmount DECIMAL(18, 2) NOT NULL, 
        CoverageAmount DECIMAL(18, 2) NOT NULL, 
        StartDate DATE DEFAULT GETDATE(),
        CONSTRAINT FK_Insurance_Customer FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
    );


INSERT INTO InsurancePolicies (CustomerID, InsuranceType, PremiumAmount, CoverageAmount)
SELECT TOP 60 
    CustomerID, 
    I.IType,
    CASE I.IType 
        WHEN 'Life' THEN ROUND((RAND(CHECKSUM(NEWID())) * 200) + 50, 2)
        WHEN 'Health' THEN ROUND((RAND(CHECKSUM(NEWID())) * 150) + 30, 2)
        WHEN 'Auto' THEN ROUND((RAND(CHECKSUM(NEWID())) * 100) + 20, 2)
        ELSE ROUND((RAND(CHECKSUM(NEWID())) * 300) + 100, 2) -- Home
    END AS PremiumAmount,
    CASE I.IType 
        WHEN 'Life' THEN 500000.00
        WHEN 'Health' THEN 50000.00
        WHEN 'Auto' THEN 25000.00
        ELSE 150000.00 -- Home
    END AS CoverageAmount
FROM Customers
CROSS APPLY (SELECT CASE (ABS(CHECKSUM(NEWID())) % 4)
    WHEN 0 THEN 'Life'
    WHEN 1 THEN 'Health'
    WHEN 2 THEN 'Auto'
    ELSE 'Home'
END AS IType) AS I
ORDER BY NEWID();

SELECT * FROM InsurancePolicies;

--MERCHANTS

    CREATE TABLE Merchants (
        MerchantID INT PRIMARY KEY IDENTITY(1,1),
        MerchantName NVARCHAR(150) NOT NULL,
        Industry NVARCHAR(100) NOT NULL, 
        Location NVARCHAR(255) NOT NULL,
        CustomerID INT NOT NULL, 
        CONSTRAINT FK_Merchant_Customer FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
    );
INSERT INTO Merchants (MerchantName, Industry, Location, CustomerID)
SELECT TOP 30 
    CASE (ABS(CHECKSUM(NEWID())) % 6)
        WHEN 0 THEN 'Global Mart'
        WHEN 1 THEN 'Tech Solutions LLC'
        WHEN 2 THEN 'Green Valley Organics'
        WHEN 3 THEN 'Skyline Hotels'
        WHEN 4 THEN 'Urban Fashion'
        ELSE 'Quick Stop Auto'
    END + ' ' + CAST(CustomerID AS NVARCHAR) AS MerchantName,
    CASE (ABS(CHECKSUM(NEWID())) % 5)
        WHEN 0 THEN 'Retail'
        WHEN 1 THEN 'Technology'
        WHEN 2 THEN 'Hospitality'
        WHEN 3 THEN 'Agriculture'
        ELSE 'Automotive'
    END AS Industry,
    CASE (ABS(CHECKSUM(NEWID())) % 4)
        WHEN 0 THEN 'Downtown Center'
        WHEN 1 THEN 'North Industrial Zone'
        WHEN 2 THEN 'Airport Business Park'
        ELSE 'Westside Mall'
    END AS Location,
    CustomerID
FROM Customers
ORDER BY NEWID();

SELECT * FROM Merchants;

--CREDIT CARDS 

CREATE TABLE CreditCards (
    CardID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT NOT NULL,
    CardNumber NVARCHAR(16) NOT NULL UNIQUE,
    CardType NVARCHAR(20) NOT NULL, 
    CVV NVARCHAR(3) NOT NULL,
    ExpiryDate DATE NOT NULL,
    CreditLimit DECIMAL(18, 2) NOT NULL,
    Status NVARCHAR(20) NOT NULL,
    CONSTRAINT FK_Card_Customer FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

INSERT INTO CreditCards (CustomerID, CardNumber, CardType, CVV, ExpiryDate, CreditLimit, Status)
SELECT TOP 100 
    CustomerID, 
    LEFT(CAST(ABS(CHECKSUM(NEWID())) AS VARCHAR) + CAST(ABS(CHECKSUM(NEWID())) AS VARCHAR) + '4444', 16) AS CardNumber, 
    
    CASE (ABS(CHECKSUM(NEWID())) % 3)
        WHEN 0 THEN 'Silver'
        WHEN 1 THEN 'Gold'
        ELSE 'Platinum'
    END AS CardType,
    
    LEFT(CAST(ABS(CHECKSUM(NEWID())) % 900 + 100 AS VARCHAR), 3) AS CVV, 
    
    DATEADD(YEAR, 4, GETDATE()) AS ExpiryDate,
    
    CASE (ABS(CHECKSUM(NEWID())) % 3)
        WHEN 0 THEN 5000.00  
        WHEN 1 THEN 20000.00  
        ELSE 50000.00         
    END AS CreditLimit,
    
    'Active' AS Status
FROM Customers
ORDER BY NEWID();

SELECT * FROM CreditCards;

--CLAIMS

CREATE TABLE Claims (
    ClaimID INT PRIMARY KEY IDENTITY(1,1),
    PolicyID INT NOT NULL, 
    ClaimAmount DECIMAL(18, 2) NOT NULL,
    Status NVARCHAR(20) NOT NULL, 
    FiledDate DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Claim_Policy FOREIGN KEY (PolicyID) REFERENCES InsurancePolicies(PolicyID)
);


INSERT INTO Claims (PolicyID, ClaimAmount, Status, FiledDate)
SELECT TOP 20 
    PolicyID, 
    ROUND((RAND(CHECKSUM(NEWID())) * (CoverageAmount * 0.5)) + 500, 2) AS ClaimAmount,
    CASE (ABS(CHECKSUM(NEWID())) % 3)
        WHEN 0 THEN 'Pending'
        WHEN 1 THEN 'Approved'
        ELSE 'Rejected'
    END AS Status,
    DATEADD(DAY, - (ABS(CHECKSUM(NEWID())) % 60), GETDATE()) AS FiledDate
FROM InsurancePolicies
ORDER BY NEWID();

SELECT * FROM Claims

--LOAN PAYMENTS

CREATE TABLE LoanPayments (
    PaymentID INT PRIMARY KEY IDENTITY(1,1),
    LoanID INT NOT NULL, 
    AmountPaid DECIMAL(18, 2) NOT NULL,
    PaymentDate DATETIME DEFAULT GETDATE(),
    RemainingBalance DECIMAL(18, 2) NOT NULL,
    CONSTRAINT FK_Payment_Loan FOREIGN KEY (LoanID) REFERENCES Loans(LoanID)
);

DECLARE @counter INT = 1;
WHILE @counter <= 200
BEGIN
    INSERT INTO LoanPayments (LoanID, AmountPaid, PaymentDate, RemainingBalance)
    SELECT TOP 1 
        LoanID, 
        ROUND((Amount * 0.05), 2) AS AmountPaid,
        DATEADD(DAY, - (ABS(CHECKSUM(NEWID())) % 180), GETDATE()) AS PaymentDate,
        ROUND((Amount - (Amount * 0.05 * (ABS(CHECKSUM(NEWID())) % 5 + 1))), 2) AS RemainingBalance
    FROM Loans
    ORDER BY NEWID(); 
    
    SET @counter = @counter + 1;
END;

SELECT * FROM LoanPayments

--TRANSACTIONS

CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY IDENTITY(1,1),
    AccountID INT NOT NULL, 
    TransactionType NVARCHAR(50) NOT NULL, 
    Amount DECIMAL(18, 2) NOT NULL,
    Currency NVARCHAR(10) DEFAULT 'USD',
    TransactionDate DATETIME DEFAULT GETDATE(),
    Status NVARCHAR(20) NOT NULL, 
    ReferenceNo NVARCHAR(100) UNIQUE NOT NULL, 
    CONSTRAINT FK_Transaction_Account FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);

DECLARE @t INT = 1;
WHILE @t <= 1500
BEGIN
    INSERT INTO Transactions (AccountID, TransactionType, Amount, Currency, TransactionDate, Status, ReferenceNo)
    SELECT TOP 1 
        AccountID, 
        CASE (ABS(CHECKSUM(NEWID())) % 4)
            WHEN 0 THEN 'Deposit'
            WHEN 1 THEN 'Withdrawal'
            WHEN 2 THEN 'Transfer'
            ELSE 'Payment'
        END,
        ROUND((RAND(CHECKSUM(NEWID())) * 2000) + 10, 2),
        'USD',
        DATEADD(SECOND, - (ABS(CHECKSUM(NEWID())) % 7776000), GETDATE()),
        CASE (ABS(CHECKSUM(NEWID())) % 10)
            WHEN 0 THEN 'Failed'
            WHEN 1 THEN 'Pending'
            ELSE 'Completed'
        END,
        'REF-' + CAST(@t AS VARCHAR) + '-' + LEFT(CAST(ABS(CHECKSUM(NEWID())) AS VARCHAR), 5)
    FROM Accounts
    ORDER BY NEWID();
    
    SET @t = @t + 1;
END;

SELECT * FROM Transactions

-- CREDIT CARD TRANSACTIONS 

CREATE TABLE CreditCardTransactions (
    TransactionID INT PRIMARY KEY IDENTITY(1,1),
    CardID INT NOT NULL,
    Merchant NVARCHAR(150) NOT NULL, 
    Amount DECIMAL(18, 2) NOT NULL,
    Currency NVARCHAR(10) DEFAULT 'USD',
    TransactionDate DATETIME DEFAULT GETDATE(),
    Status NVARCHAR(20) NOT NULL, 
    CONSTRAINT FK_CCTrans_Card FOREIGN KEY (CardID) REFERENCES CreditCards(CardID)
);

DECLARE @cc INT = 1;
WHILE @cc <= 300
BEGIN
    INSERT INTO CreditCardTransactions (CardID, Merchant, Amount, Currency, TransactionDate, Status)
    SELECT TOP 1 
        CardID, 
        CASE (ABS(CHECKSUM(NEWID())) % 6)
            WHEN 0 THEN 'Amazon Online'
            WHEN 1 THEN 'Netflix Subscription'
            WHEN 2 THEN 'Local Supermarket'
            WHEN 3 THEN 'Gas Station'
            WHEN 4 THEN 'Apple Store'
            ELSE 'Starbucks Coffee'
        END,
        ROUND((RAND(CHECKSUM(NEWID())) * 495) + 5, 2),
        'USD',
        DATEADD(MINUTE, - (ABS(CHECKSUM(NEWID())) % 43200), GETDATE()),
        CASE (ABS(CHECKSUM(NEWID())) % 12)
            WHEN 0 THEN 'Declined'
            WHEN 1 THEN 'Reversed'
            ELSE 'Approved'
        END
    FROM CreditCards
    ORDER BY NEWID();
    
    SET @cc = @cc + 1;
END;

SELECT * FROM CreditCardTransactions

--MERCHANTS TRANSACTIONS 

CREATE TABLE MerchantTransactions (
    TransactionID INT PRIMARY KEY IDENTITY(1,1),
    MerchantID INT NOT NULL, 
    Amount DECIMAL(18, 2) NOT NULL,
    PaymentMethod NVARCHAR(50) NOT NULL, 
    TransactionDate DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_MerchTrans_Merchant FOREIGN KEY (MerchantID) REFERENCES Merchants(MerchantID)
);

DECLARE @mt INT = 1;
WHILE @mt <= 100
BEGIN
    INSERT INTO MerchantTransactions (MerchantID, Amount, PaymentMethod, TransactionDate)
    SELECT TOP 1 
        MerchantID, 
        ROUND((RAND(CHECKSUM(NEWID())) * 4950) + 50, 2),
        CASE (ABS(CHECKSUM(NEWID())) % 4)
            WHEN 0 THEN 'Credit Card'
            WHEN 1 THEN 'Cash'
            WHEN 2 THEN 'QR Code'
            ELSE 'Online Banking'
        END,
        DATEADD(MINUTE, - (ABS(CHECKSUM(NEWID())) % 64800), GETDATE())
    FROM Merchants
    ORDER BY NEWID();
    
    SET @mt = @mt + 1;
END;

SELECT * FROM MerchantTransactions


--USER ACCESS LOGS

CREATE TABLE UserAccessLogs (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT NOT NULL, 
    ActionType NVARCHAR(50) NOT NULL, 
    Timestamp DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Log_User FOREIGN KEY (UserID) REFERENCES OnlineBankingUsers(UserID)
);

DECLARE @log_count INT = 1;
WHILE @log_count <= 200
BEGIN
    INSERT INTO UserAccessLogs (UserID, ActionType, Timestamp)
    SELECT TOP 1 
        UserID, 
        CASE (ABS(CHECKSUM(NEWID())) % 5)
            WHEN 0 THEN 'Login Success'
            WHEN 1 THEN 'Logout'
            WHEN 2 THEN 'Failed Login Attempt'
            WHEN 3 THEN 'Password Change'
            ELSE 'Profile Update'
        END,
        DATEADD(SECOND, - (ABS(CHECKSUM(NEWID())) % 2592000), GETDATE())
    FROM OnlineBankingUsers
    ORDER BY NEWID();
    
    SET @log_count = @log_count + 1;
END;

SELECT * FROM UserAccessLogs

--SALARY 

CREATE TABLE Salaries (
    SalaryID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeID INT NOT NULL, 
    BaseSalary DECIMAL(18, 2) NOT NULL,
    Bonus DECIMAL(18, 2) DEFAULT 0,
    Deductions DECIMAL(18, 2) DEFAULT 0,
    PaymentDate DATE NOT NULL,
    CONSTRAINT FK_Salary_Employee FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

INSERT INTO Salaries (EmployeeID, BaseSalary, Bonus, Deductions, PaymentDate)
SELECT 
    EmployeeID, 
    
    ROUND((RAND(CHECKSUM(NEWID())) * 6000) + 2500, 2) AS BaseSalary,
    ROUND((RAND(CHECKSUM(NEWID())) * 500), 2) AS Bonus,
    ROUND((RAND(CHECKSUM(NEWID())) * 300), 2) AS Deductions,
    
    CAST('2025-11-30' AS DATE) AS PaymentDate
FROM Employees;

SELECT * FROM Salaries

--EMPLOYEE ATTENDACE

CREATE TABLE EmployeeAttendance (
    AttendanceID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeID INT NOT NULL,
    CheckInTime DATETIME NOT NULL,
    CheckOutTime DATETIME NOT NULL,
    TotalHours DECIMAL(5, 2), 
    CONSTRAINT FK_Attendance_Employee FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

DECLARE @a INT = 1;
WHILE @a <= 150
BEGIN
    INSERT INTO EmployeeAttendance (EmployeeID, CheckInTime, CheckOutTime, TotalHours)
    SELECT TOP 1 
        EmployeeID, 
        DATEADD(MINUTE, (ABS(CHECKSUM(NEWID())) % 90), DATEADD(HOUR, 8, CAST(CAST(GETDATE() - (ABS(CHECKSUM(NEWID())) % 30) AS DATE) AS DATETIME))) AS CheckIn,
        DATEADD(MINUTE, (ABS(CHECKSUM(NEWID())) % 120), DATEADD(HOUR, 17, CAST(CAST(GETDATE() - (ABS(CHECKSUM(NEWID())) % 30) AS DATE) AS DATETIME))) AS CheckOut,
        0
    FROM Employees
    ORDER BY NEWID();
    
    SET @a = @a + 1;
END;

UPDATE EmployeeAttendance
SET TotalHours = ROUND(CAST(DATEDIFF(MINUTE, CheckInTime, CheckOutTime) AS DECIMAL) / 60, 2);

SELECT * FROM EmployeeAttendance

--FRAUD DETECTION 

CREATE TABLE FraudDetection (
    FraudID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT NOT NULL,
    TransactionID INT NOT NULL, 
    RiskLevel NVARCHAR(20) NOT NULL,
    ReportedDate DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Fraud_Customer FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    CONSTRAINT FK_Fraud_Transaction FOREIGN KEY (TransactionID) REFERENCES Transactions(TransactionID)
);

INSERT INTO FraudDetection (CustomerID, TransactionID, RiskLevel, ReportedDate)
SELECT TOP 40 
    t.AccountID, 
    t.TransactionID,
    CASE (ABS(CHECKSUM(NEWID())) % 3)
        WHEN 0 THEN 'Low'
        WHEN 1 THEN 'Medium'
        ELSE 'High'
    END AS RiskLevel,
    DATEADD(HOUR, (ABS(CHECKSUM(NEWID())) % 24), t.TransactionDate) AS ReportedDate
FROM Transactions t
ORDER BY NEWID();

SELECT * FROM FraudDetection
