-- Project: Wealth Analytics Data Platform
-- Purpose: Create Fact Tables

-- Fact_Holdings

CREATE TABLE dwh.Fact_Holdings
(
    HoldingKey INT IDENTITY(1,1) PRIMARY KEY,

    AccountKey INT,
    SecurityKey INT,

    HoldingDate DATE,

    Quantity DECIMAL(18,2),
    MarketValue DECIMAL(18,2),

    FOREIGN KEY (AccountKey) REFERENCES dwh.DimAccount(AccountKey),
    FOREIGN KEY (SecurityKey) REFERENCES dwh.DimSecurity(SecurityKey)
);
GO


-- Fact_Trades

CREATE TABLE dwh.Fact_Trades
(
    TradeKey INT IDENTITY(1,1) PRIMARY KEY,

    AccountKey INT,
    SecurityKey INT,

    TradeDate DATE,

    TradeType VARCHAR(50),
    Quantity DECIMAL(18,2),
    TradeAmount DECIMAL(18,2),

    FOREIGN KEY (AccountKey) REFERENCES dwh.DimAccount(AccountKey),
    FOREIGN KEY (SecurityKey) REFERENCES dwh.DimSecurity(SecurityKey)
);
GO


-- Fact_Fees

CREATE TABLE dwh.Fact_Fees
(
    FeeKey INT IDENTITY(1,1) PRIMARY KEY,

    AccountKey INT,

    FeeDate DATE,
    FeeType VARCHAR(100),

    FeeAmount DECIMAL(18,2),

    FOREIGN KEY (AccountKey) REFERENCES dwh.DimAccount(AccountKey)
);
GO


-- Fact_Performance

CREATE TABLE dwh.Fact_Performance
(
    PerformanceKey INT IDENTITY(1,1) PRIMARY KEY,

    AccountKey INT,

    PerformanceDate DATE,

    ReturnPct DECIMAL(18,6),

    FOREIGN KEY (AccountKey) REFERENCES dwh.DimAccount(AccountKey)
);
GO


-- Fact_Cashflows

CREATE TABLE dwh.Fact_Cashflows
(
    CashflowKey INT IDENTITY(1,1) PRIMARY KEY,

    AccountKey INT,

    CashflowDate DATE,

    CashflowType VARCHAR(100),
    CashflowAmount DECIMAL(18,2),

    FOREIGN KEY (AccountKey) REFERENCES dwh.DimAccount(AccountKey)
);
GO