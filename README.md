# Data Warehouse and Analytics Project

Welcome to the Data Warehouse and Analytics Project repository! 🚀 This project demonstrates a comprehensive data warehousing and analytics solution, from building a data warehouse to generating actionable insights. Designed as a portfolio project, it highlights industry best practices in data engineering and analytics.

## 🏗️ Data Architecture

The data architecture for this project follows **Medallion Architecture** with Bronze, Silver, and Gold layers, implemented in **BigQuery** as the data warehouse solution with **Google Cloud Storage** for cloud storage:

1. **Bronze Layer**: Stores raw data as-is from the source systems. Data is ingested from CSV files stored in Google Cloud Storage into BigQuery tables.
2. **Silver Layer**: This layer includes data cleansing, standardization, and normalization processes to prepare data for analysis.
3. **Gold Layer**: Houses business-ready data modeled into a star schema required for reporting and analytics.

## 📖 Project Overview

This project involves:

1. **Data Architecture**: Designing a Modern Data Warehouse Using Medallion Architecture Bronze, Silver, and Gold layers.
2. **ETL Pipelines**: Extracting, transforming, and loading data from source systems into the warehouse.
3. **Data Modeling**: Developing fact and dimension tables optimized for analytical queries.
4. **Analytics & Reporting**: Creating SQL-based reports and dashboards for actionable insights.

## 🛠️ Technology Stack

* **BigQuery**: Data warehouse and SQL provider
* **Google Cloud Storage**: Cloud storage for raw data files and staging
* **SQL**: Primary language for data transformation and analytics

## 🚀 Project Requirements

### Building the Data Warehouse (Data Engineering)

**Objective**

Develop a modern data warehouse using BigQuery to consolidate sales data, enabling analytical reporting and informed decision-making.

**Specifications**

* **Data Sources**: Import data from two source systems (ERP and CRM) provided as CSV files stored in Google Cloud Storage.
* **Data Quality**: Cleanse and resolve data quality issues prior to analysis.
* **Integration**: Combine both sources into a single, user-friendly data model designed for analytical queries.
* **Scope**: Focus on the latest dataset only; historization of data is not required.
* **Documentation**: Provide clear documentation of the data model to support both business stakeholders and analytics teams.
