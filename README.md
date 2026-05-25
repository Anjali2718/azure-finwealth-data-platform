# 💰 Wealth Analytics Data Platform

Enterprise Azure Data Engineering Project for Financial Analytics & Wealth Management

---

## 📌 Project Overview

The **Wealth Analytics Data Platform** is an end-to-end Azure Data Engineering solution designed for centralized financial analytics and reporting.
The project simulates a real-world enterprise wealth management system where data from multiple financial datasets is ingested, transformed, stored, and prepared for analytical consumption.

The platform was built using:

* Azure Data Factory (ADF)
* Azure SQL Database
* Azure Data Lake Storage Gen2
* SQL
* GitHub Integration
* ETL & Data Warehousing Concepts

---

# 🚀 Business Problem

Financial organizations often store data across multiple operational systems such as:

* Client Management Systems
* Advisor Systems
* Transaction Systems
* Holdings & Portfolio Systems
* Fee & Revenue Systems
* Market Benchmark Data

This project centralizes all these datasets into a scalable Azure-based analytical platform to support:

* Assets Under Management (AUM) Analytics
* Advisor Performance Analysis
* Portfolio Performance Tracking
* Fee Revenue Analysis
* Product Mix Insights
* Trade Activity Monitoring

---

# 🏗️ Solution Architecture

## 🔹 Medallion Architecture

The project follows the **Bronze → Silver → Gold** Medallion Architecture pattern.

### Bronze Layer

Raw CSV files stored in Azure Data Lake Storage Gen2.

### Silver Layer

Cleaned and transformed datasets prepared for business processing.

### Gold Layer

Business-ready analytical data stored in Azure SQL Data Warehouse.

### Logs Layer

Pipeline execution logs and monitoring storage.

---

# ☁️ Azure Services Used

| Service                      | Purpose                            |
| ---------------------------- | ---------------------------------- |
| Azure Data Factory           | ETL Pipeline Orchestration         |
| Azure SQL Database           | Data Warehouse Storage             |
| Azure Data Lake Storage Gen2 | Data Lake Storage                  |
| GitHub                       | Version Control & CI/CD            |
| Power BI                     | Future Reporting & Analytics Layer |

---

# 📂 Datasets Used

The platform processes multiple financial datasets:

* Clients
* Advisors
* Accounts
* Holdings
* Trades
* Fees
* Performance
* Prices
* Benchmarks
* Securities
* Cashflows
* Data Dictionary

---

# 🔄 ETL Pipeline Flow

## Phase 1 — Data Ingestion

CSV files uploaded into the **Bronze container** in ADLS Gen2.

## Phase 2 — ADF Pipelines

ADF pipelines copy data from:
Bronze Layer → Staging Tables

## Phase 3 — SQL Data Warehouse

Data transformed into:

* Dimension Tables
* Fact Tables
* Analytical Business Views

---

# 🧱 Data Warehouse Design

## Dimension Tables

* DimClient
* DimAdvisor
* DimAccount
* DimSecurity

## Fact Tables

* Fact_Holdings
* Fact_Trades
* Fact_Fees
* Fact_Performance

---

# 📊 Business Views Created

* vw_ClientPortfolioSummary
* vw_AdvisorPerformance
* vw_AUM_By_Region
* vw_FeeRevenueAnalysis
* vw_TradeActivity
* vw_ProductMixAnalysis

---

# ✅ Data Validation & Quality Checks

Implemented:

* NULL validation checks
* Data type standardization
* Duplicate validation
* Referential integrity checks
* Aggregation validation
* Business rule validations

---

# 🔧 Key Features

✔ End-to-End Azure Data Engineering Workflow
✔ ETL Pipeline Development using ADF
✔ Star Schema Data Warehouse Design
✔ SQL-Based Analytical Views
✔ GitHub Integration with ADF
✔ Medallion Architecture Implementation
✔ Enterprise-Style Project Documentation

---

# 📁 Repository Structure

```bash
azure-wealth-analytics-platform/
│
├── dataset/
├── pipeline/
├── linkedService/
├── factory/
├── sql/
├── documentation/
└── README.md
```

---

# 🖥️ Sample Architecture Flow

```text
CSV Files
   ↓
Azure Data Lake (Bronze)
   ↓
Azure Data Factory Pipelines
   ↓
Azure SQL Staging Tables
   ↓
Data Warehouse (Star Schema)
   ↓
Business Views & Analytics
```

---

# 📌 Project Highlights

* Built using real enterprise-style Azure architecture
* Followed modern Data Engineering best practices
* Implemented scalable ETL workflows
* Integrated GitHub version control with ADF
* Designed for analytical reporting & business intelligence

---

# 👩‍💻 Author

### Anjali Kolambkar

B.Tech — Artificial Intelligence & Data Science
Azure Data Engineering Enthusiast

GitHub: [https://github.com/Anjali2718](https://github.com/Anjali2718)

---

# ⭐ Future Enhancements

* Power BI Dashboard Layer
* Incremental Loading Pipelines
* Parameterized Pipelines
* CI/CD Deployment
* Data Monitoring & Alerting
* Databricks Integration

---

# 📜 License

This project is for educational and portfolio purposes.
