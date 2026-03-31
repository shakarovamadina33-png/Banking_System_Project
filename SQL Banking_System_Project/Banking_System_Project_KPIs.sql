use Banking_System_Project

--==================================================
-- KPIs
--==================================================

--1. Top 3 Customers with the Highest Total Balance Across All Accounts 

;with cte as 
(
	select top 3 a.CustomerID, b.FullName,
	sum(Balance) as sum_,
	max(Balance) as max_
	from Accounts a 
	join Customers b on a.CustomerID = b.CustomerID
	group by a.CustomerID, b.FullName
	order by sum_ desc 
) select * from cte

-- 2.Customers Who Have More Than One Active Loan

select  b.FullName, count(a.LoanID) AS ActiveLoanCount, sum(a.Amount) AS TotalDebt
from Loans a
join Customers b on a.CustomerID = b.CustomerID
where a.Status = 'Active'
group by b.FullName, a.CustomerID
having count(a.LoanID) > 1


--3.Transactions That Were Flagged as Fraudulent 

select a.*, b.AccountID, b.TransactionType, b.Amount, b.Currency, b.TransactionDate, b.Status, b.ReferenceNo from FraudDetection a 
join Transactions b on a.TransactionID = b.TransactionID
where RiskLevel in('high', 'medium')

--4. Total Loan Amount Issued Per Branch

select b.BranchName,  sum(l.Amount) over(partition by b.city order by l.amount desc)
from Branches as b
join  Accounts as a on b.BranchID = a.BranchID
join Loans as l on a.CustomerID = l.CustomerID

-- 5. Customers who made multiple large transactions (above $10,000) within a short time frame (less than 1 hour apart)

select  distinct 
    c.FullName,
    t1.Amount,
    t2.Amount,
    t1.TransactionDate,
    t2.TransactionDate,
    DATEDIFF(minute, t1.TransactionDate, t2.TransactionDate) as minut
from Transactions t1
join Transactions t2 on t1.AccountID = t2.AccountID 
    and t1.TransactionID <> t2.TransactionID
join Accounts a on t1.AccountID = a.AccountID
join Customers c on a.CustomerID = c.CustomerID
where 
    t1.Amount > 10000 and t2.Amount > 10000 
    and ABS(DATEDIFF(minute, t1.TransactionDate, t2.TransactionDate)) <= 60 
    and t1.TransactionDate < t2.TransactionDate 
order by minut

--6. Customers who have made transactions from different countries within 10 minutes, a common red flag for fraud.

select  
c.FullName,
t1.TransactionDate,
t1.Currency,
t2.TransactionDate,
t2.Currency,
DATEDIFF(minute, t1.TransactionDate, t2.TransactionDate) as diff_
from Transactions t1
join Transactions t2 on t1.AccountID = t2.AccountID
join Accounts a on t1.AccountID = a.AccountID
join Customers c on a.CustomerID = c.CustomerID
where t1.TransactionID <> t2.TransactionID 
and t1.Currency <> t2.Currency 
and ABS(DATEDIFF(minute, t1.TransactionDate, t2.TransactionDate)) <= 10 
and t1.TransactionDate < t2.TransactionDate 
order by diff_;
