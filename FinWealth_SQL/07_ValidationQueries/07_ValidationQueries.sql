-- Project: Wealth Analytics Data Platform
-- Purpose: Final Post-Load Validation Queries

-- 1. Staging Row Count Validation
-- Purpose: Verify that CSV data was loaded successfully into staging tables

SELECT 'stg.Clients' AS TableName, COUNT(*) AS RowCount
FROM stg.Clients

UNION ALL

SELECT 'stg.Advisors', COUNT(*)
FROM stg.Advisors

UNION ALL

SELECT 'stg.Accounts', COUNT(*)
FROM stg.Accounts

UNION ALL

SELECT 'stg.Securities', COUNT(*)
FROM stg.Securities

UNION ALL

SELECT 'stg.Benchmarks', COUNT(*)
FROM stg.Benchmarks

UNION ALL

SELECT 'stg.Holdings', COUNT(*)
FROM stg.Holdings

UNION ALL

SELECT 'stg.Trades', COUNT(*)
FROM stg.Trades

UNION ALL

SELECT 'stg.Prices', COUNT(*)
FROM stg.Prices

UNION ALL

SELECT 'stg.Cashflows', COUNT(*)
FROM stg.Cashflows

UNION ALL

SELECT 'stg.Fees', COUNT(*)
FROM stg.Fees

UNION ALL

SELECT 'stg.Performance', COUNT(*)
FROM stg.Performance;
GO


-- 2. Dimension Row Count Validation
-- Purpose: Verify dimension tables after stored procedure execution

SELECT 'dwh.DimClient' AS TableName, COUNT(*) AS RowCount
FROM dwh.DimClient

UNION ALL

SELECT 'dwh.DimAdvisor', COUNT(*)
FROM dwh.DimAdvisor

UNION ALL

SELECT 'dwh.DimAccount', COUNT(*)
FROM dwh.DimAccount

UNION ALL

SELECT 'dwh.DimSecurity', COUNT(*)
FROM dwh.DimSecurity;
GO

-- 3. Fact Row Count Validation
-- Purpose: Verify fact tables after warehouse loading

SELECT 'dwh.Fact_Trades' AS TableName, COUNT(*) AS RowCount
FROM dwh.Fact_Trades

UNION ALL

SELECT 'dwh.Fact_Holdings', COUNT(*)
FROM dwh.Fact_Holdings

UNION ALL

SELECT 'dwh.Fact_Fees', COUNT(*)
FROM dwh.Fact_Fees

UNION ALL

SELECT 'dwh.Fact_Cashflows', COUNT(*)
FROM dwh.Fact_Cashflows

UNION ALL

SELECT 'dwh.Fact_Performance', COUNT(*)
FROM dwh.Fact_Performance;
GO


-- 4. Business View NULL Validation
-- Purpose: Confirm final analytical views are reporting-ready
-- Expected Result: All NullRows should be 0

SELECT 'vw_ClientPortfolioSummary' AS ViewName,
       COUNT(*) AS NullRows
FROM dwh.vw_ClientPortfolioSummary
WHERE ClientID IS NULL
   OR ClientName IS NULL
   OR Segment IS NULL
   OR Country IS NULL
   OR TotalAUM IS NULL

UNION ALL

SELECT 'vw_AdvisorPerformance',
       COUNT(*)
FROM dwh.vw_AdvisorPerformance
WHERE AdvisorID IS NULL
   OR AdvisorName IS NULL
   OR Region IS NULL
   OR TotalAUM IS NULL

UNION ALL

SELECT 'vw_AUM_By_Region',
       COUNT(*)
FROM dwh.vw_AUM_By_Region
WHERE Region IS NULL
   OR TotalAUM IS NULL

UNION ALL

SELECT 'vw_FeeRevenueAnalysis',
       COUNT(*)
FROM dwh.vw_FeeRevenueAnalysis
WHERE ClientID IS NULL
   OR AdvisorID IS NULL
   OR Region IS NULL
   OR TotalFeeRevenue IS NULL

UNION ALL

SELECT 'vw_TradeActivity',
       COUNT(*)
FROM dwh.vw_TradeActivity
WHERE ClientID IS NULL
   OR SecurityID IS NULL
   OR AssetClass IS NULL
   OR Sector IS NULL
   OR TradeType IS NULL

UNION ALL

SELECT 'vw_ProductMixAnalysis',
       COUNT(*)
FROM dwh.vw_ProductMixAnalysis
WHERE AssetClass IS NULL
   OR Sector IS NULL
   OR TotalAUM IS NULL;
GO

-- 5. Duplicate Business Key Validation
-- Purpose: Ensure dimension business keys are unique
-- Expected Result: No rows should return

SELECT ClientID, COUNT(*) AS DuplicateCount
FROM dwh.DimClient
GROUP BY ClientID
HAVING COUNT(*) > 1;
GO

SELECT AdvisorID, COUNT(*) AS DuplicateCount
FROM dwh.DimAdvisor
GROUP BY AdvisorID
HAVING COUNT(*) > 1;
GO

SELECT AccountID, COUNT(*) AS DuplicateCount
FROM dwh.DimAccount
GROUP BY AccountID
HAVING COUNT(*) > 1;
GO

SELECT SecurityID, COUNT(*) AS DuplicateCount
FROM dwh.DimSecurity
GROUP BY SecurityID
HAVING COUNT(*) > 1;
GO


-- 6. Fact Foreign Key NULL Validation
-- Purpose: Check whether fact records failed to map with dimensions
-- Expected Result: 0 rows ideally

SELECT *
FROM dwh.Fact_Trades
WHERE AccountKey IS NULL
   OR SecurityKey IS NULL;
GO

SELECT *
FROM dwh.Fact_Holdings
WHERE AccountKey IS NULL
   OR SecurityKey IS NULL;
GO

SELECT *
FROM dwh.Fact_Fees
WHERE AccountKey IS NULL;
GO

SELECT *
FROM dwh.Fact_Cashflows
WHERE AccountKey IS NULL;
GO

SELECT *
FROM dwh.Fact_Performance
WHERE AccountKey IS NULL;
GO


-- 7. Business Rule Validation
-- Purpose: Detect invalid financial values

SELECT *
FROM dwh.Fact_Holdings
WHERE MarketValue < 0;
GO

SELECT *
FROM dwh.Fact_Trades
WHERE TradeAmount IS NULL;
GO

SELECT *
FROM dwh.Fact_Fees
WHERE FeeAmount < 0;
GO

SELECT *
FROM dwh.Fact_Cashflows
WHERE Amount IS NULL;
GO

SELECT *
FROM dwh.Fact_Performance
WHERE ReturnPct IS NULL;
GO


-- 8. Analytical KPI Validation
-- Purpose: Verify final business metrics

SELECT 
    SUM(MarketValue) AS TotalAUM
FROM dwh.Fact_Holdings;
GO

SELECT 
    SUM(FeeAmount) AS TotalFees
FROM dwh.Fact_Fees;
GO

SELECT 
    SUM(TradeAmount) AS TotalTradeAmount
FROM dwh.Fact_Trades;
GO

SELECT 
    SUM(Amount) AS TotalCashflowAmount
FROM dwh.Fact_Cashflows;
GO

SELECT 
    AVG(ReturnPct) AS AvgPortfolioReturn
FROM dwh.Fact_Performance;
GO


-- 9. Business View Sample Output Checks
-- Purpose: Quickly inspect final reporting views

SELECT TOP 20 *
FROM dwh.vw_ClientPortfolioSummary
ORDER BY TotalAUM DESC;
GO

SELECT TOP 20 *
FROM dwh.vw_AdvisorPerformance
ORDER BY TotalAUM DESC;
GO

SELECT *
FROM dwh.vw_AUM_By_Region
ORDER BY TotalAUM DESC;
GO

SELECT TOP 20 *
FROM dwh.vw_FeeRevenueAnalysis
ORDER BY TotalFeeRevenue DESC;
GO

SELECT TOP 20 *
FROM dwh.vw_TradeActivity
ORDER BY TotalTradeAmount DESC;
GO

SELECT TOP 20 *
FROM dwh.vw_ProductMixAnalysis
ORDER BY TotalAUM DESC;
GO


-- 10. Audit Result Check
-- Purpose: View stored data quality procedure output

EXEC audit.usp_Run_DataQualityChecks;
GO

SELECT *
FROM audit.DataQualityResults
ORDER BY CheckDate DESC;
GO