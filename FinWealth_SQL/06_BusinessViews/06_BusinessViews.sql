-- Project: Wealth Analytics Data Platform
-- Purpose: Business Analytical Views


-- Final NULL Validation Across Business Views

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



-- vw_ProductMixAnalysis

CREATE OR ALTER VIEW dwh.vw_ProductMixAnalysis
AS

SELECT
    ISNULL(ds.AssetClass, 'Unknown') AS AssetClass,
    ISNULL(ds.Sector, 'Unknown') AS Sector,

    ds.Currency,
    ds.Region,

    COUNT(DISTINCT ds.SecurityKey) AS TotalSecurities,

    ISNULL(SUM(fh.MarketValue), 0) AS TotalAUM,

    ISNULL(SUM(ft.TradeAmount), 0) AS TotalTradeAmount,

    ISNULL(SUM(ft.Quantity), 0) AS TotalQuantity

FROM dwh.DimSecurity ds

LEFT JOIN dwh.Fact_Holdings fh
    ON ds.SecurityKey = fh.SecurityKey

LEFT JOIN dwh.Fact_Trades ft
    ON ds.SecurityKey = ft.SecurityKey

GROUP BY
    ISNULL(ds.AssetClass, 'Unknown'),
    ISNULL(ds.Sector, 'Unknown'),
    ds.Currency,
    ds.Region;
GO


SELECT TOP 20 *
FROM dwh.vw_ProductMixAnalysis
ORDER BY TotalAUM DESC;
GO


-- vw_TradeActivity

CREATE OR ALTER VIEW dwh.vw_TradeActivity
AS

SELECT
    dc.ClientID,
    dc.ClientName,
    dc.Segment,
    dc.Country,

    ds.SecurityID,
    ds.SecurityName,
    ds.AssetClass,

    ISNULL(ds.Sector, 'Unknown') AS Sector,

    ft.TradeDate,

    ISNULL(ft.TradeType, 'Unknown') AS TradeType,

    COUNT(ft.TradeKey) AS TotalTrades,

    ISNULL(SUM(ft.Quantity), 0) AS TotalQuantity,

    ISNULL(SUM(ft.TradeAmount), 0) AS TotalTradeAmount,

    ISNULL(AVG(ft.Price), 0) AS AvgTradePrice

FROM dwh.Fact_Trades ft

LEFT JOIN dwh.DimAccount acc
    ON ft.AccountKey = acc.AccountKey

LEFT JOIN dwh.DimClient dc
    ON acc.ClientID = dc.ClientID

LEFT JOIN dwh.DimSecurity ds
    ON ft.SecurityKey = ds.SecurityKey

GROUP BY
    dc.ClientID,
    dc.ClientName,
    dc.Segment,
    dc.Country,
    ds.SecurityID,
    ds.SecurityName,
    ds.AssetClass,
    ds.Sector,
    ft.TradeDate,
    ft.TradeType;
GO


SELECT TOP 20 *
FROM dwh.vw_TradeActivity
ORDER BY TotalTradeAmount DESC;
GO


-- vw_FeeRevenueAnalysis

CREATE OR ALTER VIEW dwh.vw_FeeRevenueAnalysis
AS

SELECT
    dc.ClientID,
    dc.ClientName,

    ISNULL(dc.Segment, 'Unknown') AS Segment,
    ISNULL(dc.Country, 'Unknown') AS Country,

    adv.AdvisorID,
    adv.AdvisorName,

    ISNULL(adv.Region, 'Unknown') AS Region,

    COUNT(DISTINCT acc.AccountID) AS TotalAccounts,

    ISNULL(SUM(fee.FeeAmount), 0) AS TotalFeeRevenue,

    ISNULL(AVG(fee.FeeAmount), 0) AS AvgFeePerTransaction,

    ISNULL(MAX(fee.FeeAmount), 0) AS HighestFee,

    ISNULL(MIN(fee.FeeAmount), 0) AS LowestFee

FROM dwh.Fact_Fees fee

LEFT JOIN dwh.DimAccount acc
    ON fee.AccountKey = acc.AccountKey

LEFT JOIN dwh.DimClient dc
    ON acc.ClientID = dc.ClientID

LEFT JOIN dwh.DimAdvisor adv
    ON dc.PrimaryAdvisorID = adv.AdvisorID

GROUP BY
    dc.ClientID,
    dc.ClientName,
    ISNULL(dc.Segment, 'Unknown'),
    ISNULL(dc.Country, 'Unknown'),
    adv.AdvisorID,
    adv.AdvisorName,
    ISNULL(adv.Region, 'Unknown');
GO


SELECT TOP 20 *
FROM dwh.vw_FeeRevenueAnalysis
ORDER BY TotalFeeRevenue DESC;
GO


-- vw_AUM_By_Region

CREATE OR ALTER VIEW dwh.vw_AUM_By_Region
AS

SELECT
    ISNULL(adv.Region, 'Unknown') AS Region,

    COUNT(DISTINCT adv.AdvisorID) AS TotalAdvisors,

    COUNT(DISTINCT dc.ClientID) AS TotalClients,

    COUNT(DISTINCT acc.AccountKey) AS TotalAccounts,

    ISNULL(SUM(hold.MarketValue), 0) AS TotalAUM,

    ISNULL(AVG(perf.ReturnPct), 0) AS AvgPortfolioReturn

FROM dwh.DimAdvisor adv

LEFT JOIN dwh.DimClient dc
    ON adv.AdvisorID = dc.PrimaryAdvisorID

LEFT JOIN dwh.DimAccount acc
    ON dc.ClientID = acc.ClientID

LEFT JOIN dwh.Fact_Holdings hold
    ON acc.AccountKey = hold.AccountKey

LEFT JOIN dwh.Fact_Performance perf
    ON acc.AccountKey = perf.AccountKey

GROUP BY
    ISNULL(adv.Region, 'Unknown');
GO


SELECT *
FROM dwh.vw_AUM_By_Region
ORDER BY TotalAUM DESC;
GO


-- vw_AdvisorPerformance

CREATE OR ALTER VIEW dwh.vw_AdvisorPerformance
AS

SELECT
    adv.AdvisorID,
    adv.AdvisorName,

    ISNULL(adv.Region, 'Unknown') AS Region,

    adv.ExperienceYears,

    COUNT(DISTINCT dc.ClientID) AS TotalClients,

    COUNT(DISTINCT acc.AccountKey) AS TotalAccounts,

    ISNULL(SUM(hold.MarketValue), 0) AS TotalAUM,

    ISNULL(SUM(fee.FeeAmount), 0) AS TotalFeesGenerated,

    ISNULL(AVG(perf.ReturnPct), 0) AS AvgPortfolioReturn

FROM dwh.DimAdvisor adv

LEFT JOIN dwh.DimClient dc
    ON adv.AdvisorID = dc.PrimaryAdvisorID

LEFT JOIN dwh.DimAccount acc
    ON dc.ClientID = acc.ClientID

LEFT JOIN dwh.Fact_Holdings hold
    ON acc.AccountKey = hold.AccountKey

LEFT JOIN dwh.Fact_Fees fee
    ON acc.AccountKey = fee.AccountKey

LEFT JOIN dwh.Fact_Performance perf
    ON acc.AccountKey = perf.AccountKey

GROUP BY
    adv.AdvisorID,
    adv.AdvisorName,
    ISNULL(adv.Region, 'Unknown'),
    adv.ExperienceYears;
GO


SELECT TOP 20 *
FROM dwh.vw_AdvisorPerformance
ORDER BY TotalAUM DESC;
GO


-- vw_ClientPortfolioSummary

CREATE OR ALTER VIEW dwh.vw_ClientPortfolioSummary
AS

SELECT
    dc.ClientID,
    dc.ClientName,
    dc.Segment,
    dc.RiskProfile,

    ISNULL(dc.Country, 'Unknown') AS Country,

    COUNT(DISTINCT da.AccountKey) AS TotalAccounts,

    COUNT(DISTINCT fh.SecurityKey) AS TotalSecurities,

    ISNULL(SUM(fh.MarketValue), 0) AS TotalAUM,

    ISNULL(SUM(ff.FeeAmount), 0) AS TotalFees

FROM dwh.DimClient dc

LEFT JOIN dwh.DimAccount da
    ON dc.ClientID = da.ClientID

LEFT JOIN dwh.Fact_Holdings fh
    ON da.AccountKey = fh.AccountKey

LEFT JOIN dwh.Fact_Fees ff
    ON da.AccountKey = ff.AccountKey

GROUP BY
    dc.ClientID,
    dc.ClientName,
    dc.Segment,
    dc.RiskProfile,
    ISNULL(dc.Country, 'Unknown');
GO


SELECT TOP 20 *
FROM dwh.vw_ClientPortfolioSummary
ORDER BY TotalAUM DESC;
GO


-- Data Quality Audit Table

CREATE TABLE audit.DataQualityResults
(
    CheckID        INT IDENTITY(1,1) PRIMARY KEY,
    CheckName      VARCHAR(200),
    TableName      VARCHAR(100),
    CheckType      VARCHAR(100),
    IssueCount     INT,
    Status         VARCHAR(20),
    CheckDate      DATETIME2 DEFAULT SYSDATETIME()
);
GO


-- audit.usp_Run_DataQualityChecks

CREATE OR ALTER PROCEDURE audit.usp_Run_DataQualityChecks
AS
BEGIN

    SET NOCOUNT ON;

    TRUNCATE TABLE audit.DataQualityResults;

    ---------------------------------------------------
    -- NULL CHECK : DimClient
    ---------------------------------------------------

    INSERT INTO audit.DataQualityResults
    (
        CheckName,
        TableName,
        CheckType,
        IssueCount,
        Status
    )

    SELECT
        'Null ClientID Check',
        'dwh.DimClient',
        'NULL CHECK',
        COUNT(*),

        CASE
            WHEN COUNT(*) = 0 THEN 'PASSED'
            ELSE 'FAILED'
        END

    FROM dwh.DimClient
    WHERE ClientID IS NULL;

    -- NULL CHECK : DimAdvisor

    INSERT INTO audit.DataQualityResults
    (
        CheckName,
        TableName,
        CheckType,
        IssueCount,
        Status
    )

    SELECT
        'Null AdvisorID Check',
        'dwh.DimAdvisor',
        'NULL CHECK',
        COUNT(*),

        CASE
            WHEN COUNT(*) = 0 THEN 'PASSED'
            ELSE 'FAILED'
        END

    FROM dwh.DimAdvisor
    WHERE AdvisorID IS NULL;

    -- DUPLICATE CHECK : DimAccount

    INSERT INTO audit.DataQualityResults
    (
        CheckName,
        TableName,
        CheckType,
        IssueCount,
        Status
    )

    SELECT
        'Duplicate AccountID Check',
        'dwh.DimAccount',
        'DUPLICATE CHECK',
        COUNT(*),

        CASE
            WHEN COUNT(*) = 0 THEN 'PASSED'
            ELSE 'FAILED'
        END

    FROM
    (
        SELECT AccountID
        FROM dwh.DimAccount
        GROUP BY AccountID
        HAVING COUNT(*) > 1
    ) A;

    -- FACT VALIDATION : Fact_Trades

    INSERT INTO audit.DataQualityResults
    (
        CheckName,
        TableName,
        CheckType,
        IssueCount,
        Status
    )

    SELECT
        'Null Trade Amount Check',
        'dwh.Fact_Trades',
        'NULL CHECK',
        COUNT(*),

        CASE
            WHEN COUNT(*) = 0 THEN 'PASSED'
            ELSE 'FAILED'
        END

    FROM dwh.Fact_Trades
    WHERE TradeAmount IS NULL;

    -- FACT VALIDATION : Fact_Holdings

    INSERT INTO audit.DataQualityResults
    (
        CheckName,
        TableName,
        CheckType,
        IssueCount,
        Status
    )

    SELECT
        'Negative Market Value Check',
        'dwh.Fact_Holdings',
        'BUSINESS RULE CHECK',
        COUNT(*),

        CASE
            WHEN COUNT(*) = 0 THEN 'PASSED'
            ELSE 'FAILED'
        END

    FROM dwh.Fact_Holdings
    WHERE MarketValue < 0;

END;
GO


EXEC audit.usp_Run_DataQualityChecks;
GO


SELECT *
FROM audit.DataQualityResults;
GO