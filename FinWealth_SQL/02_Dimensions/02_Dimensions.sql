-- Project: Wealth Analytics Data Platform
-- Purpose: Create Dimension Tables

-- DimClient

CREATE TABLE dwh.DimClient
(
    ClientKey INT IDENTITY(1,1) PRIMARY KEY,

    ClientID VARCHAR(50),
    ClientName VARCHAR(255),
    Segment VARCHAR(100),
    Country VARCHAR(100),
    RiskProfile VARCHAR(100),

    PrimaryAdvisorID VARCHAR(50)
);
GO


-- DimAdvisor

CREATE TABLE dwh.DimAdvisor
(
    AdvisorKey INT IDENTITY(1,1) PRIMARY KEY,

    AdvisorID VARCHAR(50),
    AdvisorName VARCHAR(255),
    Region VARCHAR(100),
    ExperienceYears INT
);
GO


-- DimAccount

CREATE TABLE dwh.DimAccount
(
    AccountKey INT IDENTITY(1,1) PRIMARY KEY,

    AccountID VARCHAR(50),
    ClientID VARCHAR(50),

    AccountType VARCHAR(100),
    InvestmentObjective VARCHAR(255),
    RiskTolerance VARCHAR(100),

    OpeningDate DATE,
    AccountStatus VARCHAR(100)
);
GO


-- DimSecurity

CREATE TABLE dwh.DimSecurity
(
    SecurityKey INT IDENTITY(1,1) PRIMARY KEY,

    SecurityID VARCHAR(50),
    SecurityName VARCHAR(255),

    AssetClass VARCHAR(100),
    Sector VARCHAR(100),
    Currency VARCHAR(50),

    BenchmarkID VARCHAR(50)
);
GO