CREATE SCHEMA stg;
GO

CREATE SCHEMA dwh;
GO

CREATE SCHEMA audit;
GO

CREATE SCHEMA ref;
GO

CREATE TABLE stg.Clients
(
    ClientID           VARCHAR(50),
    ClientName         NVARCHAR(200),
    Segment            VARCHAR(100),
    RiskProfile        VARCHAR(100),
    PrimaryAdvisorID   VARCHAR(50),
    ClientSince        DATE,
    Country            VARCHAR(100),
    LoadDate           DATETIME2 DEFAULT SYSDATETIME()
);
GO

CREATE TABLE stg.Advisors
(
    AdvisorID        VARCHAR(50),
    AdvisorName      NVARCHAR(200),
    Region           VARCHAR(100),
    JoinDate         DATE,
    ExperienceYears  INT,
    LoadDate         DATETIME2 DEFAULT SYSDATETIME()
);
GO

CREATE TABLE stg.Accounts
(
    AccountID      VARCHAR(50),
    ClientID       VARCHAR(50),
    AccountType    VARCHAR(100),
    OpenDate       DATE,
    BaseCurrency   VARCHAR(10),
    Status         VARCHAR(50),
    LoadDate       DATETIME2 DEFAULT SYSDATETIME()
);
GO

CREATE TABLE stg.Securities
(
    SecurityID     VARCHAR(50),
    Ticker         VARCHAR(50),
    SecurityName   NVARCHAR(200),
    AssetClass     VARCHAR(100),
    Sector         VARCHAR(100),
    Currency       VARCHAR(10),
    Region         VARCHAR(100),
    LoadDate       DATETIME2 DEFAULT SYSDATETIME()
);
GO

CREATE TABLE stg.Benchmarks
(
    BenchmarkCode   VARCHAR(50),
    Description     NVARCHAR(200),
    Currency        VARCHAR(10),
    IndexValueDate  DATE,
    IndexValue      DECIMAL(18,4),
    LoadDate        DATETIME2 DEFAULT SYSDATETIME()
);
GO

CREATE TABLE stg.Trades
(
    TradeID         VARCHAR(50),
    AccountID       VARCHAR(50),
    SecurityID      VARCHAR(50),
    TradeDate       DATE,
    TradeType       VARCHAR(20),
    Quantity        DECIMAL(18,4),
    Price           DECIMAL(18,4),
    TradeAmount     DECIMAL(18,4),
    Broker          VARCHAR(100),
    LoadDate        DATETIME2 DEFAULT SYSDATETIME()
);
GO

CREATE TABLE stg.Holdings
(
    HoldingID       VARCHAR(50),
    AccountID       VARCHAR(50),
    SecurityID      VARCHAR(50),
    HoldingDate     DATE,
    Quantity        DECIMAL(18,4),
    MarketValue     DECIMAL(18,4),
    LoadDate        DATETIME2 DEFAULT SYSDATETIME()
);
GO

CREATE TABLE stg.Performance
(
    PerformanceID     VARCHAR(50),
    AccountID         VARCHAR(50),
    BenchmarkCode     VARCHAR(50),
    PerformanceDate   DATE,
    ReturnPct         DECIMAL(18,4),
    BenchmarkReturn   DECIMAL(18,4),
    LoadDate          DATETIME2 DEFAULT SYSDATETIME()
);
GO

CREATE TABLE stg.Cashflows
(
    CashflowID       VARCHAR(50),
    AccountID        VARCHAR(50),
    FlowDate         DATE,
    FlowType         VARCHAR(50),
    Amount           DECIMAL(18,4),
    Currency         VARCHAR(10),
    LoadDate         DATETIME2 DEFAULT SYSDATETIME()
);
GO

CREATE TABLE stg.Fees
(
    FeeID            VARCHAR(50),
    AccountID        VARCHAR(50),
    FeeDate          DATE,
    FeeType          VARCHAR(50),
    FeeAmount        DECIMAL(18,4),
    Currency         VARCHAR(10),
    LoadDate         DATETIME2 DEFAULT SYSDATETIME()
);
GO

CREATE TABLE stg.Prices
(
    PriceID          VARCHAR(50),
    SecurityID       VARCHAR(50),
    PriceDate        DATE,
    ClosePrice       DECIMAL(18,4),
    Currency         VARCHAR(10),
    LoadDate         DATETIME2 DEFAULT SYSDATETIME()
);
GO
