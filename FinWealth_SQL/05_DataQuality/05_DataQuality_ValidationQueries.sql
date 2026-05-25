-- Project: Wealth Analytics Data Platform
-- Purpose: Data Quality Checks & Warehouse Validation


-- Row Count Validation

SELECT COUNT(*) AS DimClient_Count
FROM dwh.DimClient;
GO

SELECT COUNT(*) AS DimAdvisor_Count
FROM dwh.DimAdvisor;
GO

SELECT COUNT(*) AS DimAccount_Count
FROM dwh.DimAccount;
GO

SELECT COUNT(*) AS DimSecurity_Count
FROM dwh.DimSecurity;
GO

SELECT COUNT(*) AS FactHoldings_Count
FROM dwh.Fact_Holdings;
GO

SELECT COUNT(*) AS FactTrades_Count
FROM dwh.Fact_Trades;
GO

SELECT COUNT(*) AS FactFees_Count
FROM dwh.Fact_Fees;
GO

SELECT COUNT(*) AS FactPerformance_Count
FROM dwh.Fact_Performance;
GO

SELECT COUNT(*) AS FactCashflows_Count
FROM dwh.Fact_Cashflows;
GO


-- NULL Checks

SELECT *
FROM dwh.DimClient
WHERE ClientID IS NULL;
GO

SELECT *
FROM dwh.DimAdvisor
WHERE AdvisorID IS NULL;
GO

SELECT *
FROM dwh.DimAccount
WHERE AccountID IS NULL;
GO

SELECT *
FROM dwh.DimSecurity
WHERE SecurityID IS NULL;
GO

SELECT *
FROM dwh.Fact_Holdings
WHERE AccountKey IS NULL
   OR SecurityKey IS NULL;
GO

SELECT *
FROM dwh.Fact_Trades
WHERE AccountKey IS NULL
   OR SecurityKey IS NULL;
GO

SELECT *
FROM dwh.Fact_Fees
WHERE AccountKey IS NULL;
GO

SELECT *
FROM dwh.Fact_Performance
WHERE AccountKey IS NULL;
GO

SELECT *
FROM dwh.Fact_Cashflows
WHERE AccountKey IS NULL;
GO


-- Duplicate Checks

SELECT
    ClientID,
    COUNT(*) AS DuplicateCount
FROM dwh.DimClient
GROUP BY ClientID
HAVING COUNT(*) > 1;
GO

SELECT
    AdvisorID,
    COUNT(*) AS DuplicateCount
FROM dwh.DimAdvisor
GROUP BY AdvisorID
HAVING COUNT(*) > 1;
GO

SELECT
    AccountID,
    COUNT(*) AS DuplicateCount
FROM dwh.DimAccount
GROUP BY AccountID
HAVING COUNT(*) > 1;
GO

SELECT
    SecurityID,
    COUNT(*) AS DuplicateCount
FROM dwh.DimSecurity
GROUP BY SecurityID
HAVING COUNT(*) > 1;
GO


-- Referential Integrity Checks

SELECT *
FROM dwh.Fact_Holdings
WHERE AccountKey NOT IN
(
    SELECT AccountKey
    FROM dwh.DimAccount
);
GO

SELECT *
FROM dwh.Fact_Trades
WHERE SecurityKey NOT IN
(
    SELECT SecurityKey
    FROM dwh.DimSecurity
);
GO

SELECT *
FROM dwh.Fact_Fees
WHERE AccountKey NOT IN
(
    SELECT AccountKey
    FROM dwh.DimAccount
);
GO


-- Business Rule Checks

SELECT *
FROM dwh.Fact_Holdings
WHERE MarketValue < 0;
GO

SELECT *
FROM dwh.Fact_Trades
WHERE TradeAmount < 0;
GO

SELECT *
FROM dwh.Fact_Fees
WHERE FeeAmount < 0;
GO

SELECT *
FROM dwh.Fact_Cashflows
WHERE CashflowAmount < 0;
GO


-- Final Warehouse Validation

SELECT TOP 10 *
FROM dwh.DimClient;
GO

SELECT TOP 10 *
FROM dwh.DimAdvisor;
GO

SELECT TOP 10 *
FROM dwh.DimAccount;
GO

SELECT TOP 10 *
FROM dwh.DimSecurity;
GO

SELECT TOP 10 *
FROM dwh.Fact_Holdings;
GO

SELECT TOP 10 *
FROM dwh.Fact_Trades;
GO

SELECT TOP 10 *
FROM dwh.Fact_Fees;
GO

SELECT TOP 10 *
FROM dwh.Fact_Performance;
GO

SELECT TOP 10 *
FROM dwh.Fact_Cashflows;
GO
