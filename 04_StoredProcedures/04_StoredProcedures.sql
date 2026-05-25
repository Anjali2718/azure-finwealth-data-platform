-- Project: Wealth Analytics Data Platform
-- Purpose: Load Dimension & Fact Tables


-- usp_Load_DimClient

CREATE OR ALTER PROCEDURE dwh.usp_Load_DimClient
AS
BEGIN

    TRUNCATE TABLE dwh.DimClient;

    INSERT INTO dwh.DimClient
    (
        ClientID,
        ClientName,
        Segment,
        Country,
        RiskProfile,
        PrimaryAdvisorID
    )
    SELECT
        ClientID,
        ClientName,
        Segment,
        Country,
        RiskProfile,
        PrimaryAdvisorID
    FROM stg.STG_Clients;

END;
GO


-- usp_Load_DimAdvisor

CREATE OR ALTER PROCEDURE dwh.usp_Load_DimAdvisor
AS
BEGIN

    TRUNCATE TABLE dwh.DimAdvisor;

    INSERT INTO dwh.DimAdvisor
    (
        AdvisorID,
        AdvisorName,
        Region,
        ExperienceYears
    )
    SELECT
        AdvisorID,
        AdvisorName,
        Region,
        ExperienceYears
    FROM stg.STG_Advisors;

END;
GO


-- usp_Load_DimAccount

CREATE OR ALTER PROCEDURE dwh.usp_Load_DimAccount
AS
BEGIN

    TRUNCATE TABLE dwh.DimAccount;

    INSERT INTO dwh.DimAccount
    (
        AccountID,
        ClientID,
        AccountType,
        InvestmentObjective,
        RiskTolerance,
        OpeningDate,
        AccountStatus
    )
    SELECT
        AccountID,
        ClientID,
        AccountType,
        InvestmentObjective,
        RiskTolerance,
        OpeningDate,
        AccountStatus
    FROM stg.STG_Accounts;

END;
GO


-- usp_Load_DimSecurity

CREATE OR ALTER PROCEDURE dwh.usp_Load_DimSecurity
AS
BEGIN

    TRUNCATE TABLE dwh.DimSecurity;

    INSERT INTO dwh.DimSecurity
    (
        SecurityID,
        SecurityName,
        AssetClass,
        Sector,
        Currency,
        BenchmarkID
    )
    SELECT
        SecurityID,
        SecurityName,
        AssetClass,
        Sector,
        Currency,
        BenchmarkID
    FROM stg.STG_Securities;

END;
GO


-- usp_Load_FactHoldings

CREATE OR ALTER PROCEDURE dwh.usp_Load_FactHoldings
AS
BEGIN

    TRUNCATE TABLE dwh.Fact_Holdings;

    INSERT INTO dwh.Fact_Holdings
    (
        AccountKey,
        SecurityKey,
        HoldingDate,
        Quantity,
        MarketValue
    )
    SELECT
        da.AccountKey,
        ds.SecurityKey,
        h.HoldingDate,
        h.Quantity,
        h.MarketValue
    FROM stg.STG_Holdings h

    LEFT JOIN dwh.DimAccount da
        ON h.AccountID = da.AccountID

    LEFT JOIN dwh.DimSecurity ds
        ON h.SecurityID = ds.SecurityID;

END;
GO


-- usp_Load_FactTrades

CREATE OR ALTER PROCEDURE dwh.usp_Load_FactTrades
AS
BEGIN

    TRUNCATE TABLE dwh.Fact_Trades;

    INSERT INTO dwh.Fact_Trades
    (
        AccountKey,
        SecurityKey,
        TradeDate,
        TradeType,
        Quantity,
        TradeAmount
    )
    SELECT
        da.AccountKey,
        ds.SecurityKey,
        t.TradeDate,
        t.TradeType,
        t.Quantity,
        t.TradeAmount
    FROM stg.STG_Trades t

    LEFT JOIN dwh.DimAccount da
        ON t.AccountID = da.AccountID

    LEFT JOIN dwh.DimSecurity ds
        ON t.SecurityID = ds.SecurityID;

END;
GO


-- usp_Load_FactFees

CREATE OR ALTER PROCEDURE dwh.usp_Load_FactFees
AS
BEGIN

    TRUNCATE TABLE dwh.Fact_Fees;

    INSERT INTO dwh.Fact_Fees
    (
        AccountKey,
        FeeDate,
        FeeType,
        FeeAmount
    )
    SELECT
        da.AccountKey,
        f.FeeDate,
        f.FeeType,
        f.FeeAmount
    FROM stg.STG_Fees f

    LEFT JOIN dwh.DimAccount da
        ON f.AccountID = da.AccountID;

END;
GO


-- usp_Load_FactPerformance

CREATE OR ALTER PROCEDURE dwh.usp_Load_FactPerformance
AS
BEGIN

    TRUNCATE TABLE dwh.Fact_Performance;

    INSERT INTO dwh.Fact_Performance
    (
        AccountKey,
        PerformanceDate,
        ReturnPct
    )
    SELECT
        da.AccountKey,
        p.PerformanceDate,
        p.ReturnPct
    FROM stg.STG_Performance p

    LEFT JOIN dwh.DimAccount da
        ON p.AccountID = da.AccountID;

END;
GO


-- usp_Load_FactCashflows

CREATE OR ALTER PROCEDURE dwh.usp_Load_FactCashflows
AS
BEGIN

    TRUNCATE TABLE dwh.Fact_Cashflows;

    INSERT INTO dwh.Fact_Cashflows
    (
        AccountKey,
        CashflowDate,
        CashflowType,
        CashflowAmount
    )
    SELECT
        da.AccountKey,
        c.CashflowDate,
        c.CashflowType,
        c.CashflowAmount
    FROM stg.STG_Cashflows c

    LEFT JOIN dwh.DimAccount da
        ON c.AccountID = da.AccountID;

END;
GO