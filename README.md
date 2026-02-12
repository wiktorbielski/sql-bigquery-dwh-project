## 📖 Project Overview

This project involves:
1. **Data Architecture**: Designing a modern data warehouse using Medallion Architecture (Bronze, Silver, and Gold layers)
2. **ETL Pipelines**: Extracting, transforming, and loading data from source systems into the warehouse
3. **Data Modeling**: Developing fact and dimension tables optimized for analytical queries using star schema
4. **Analytics & Reporting**: Creating SQL-based reports and dashboards for actionable insights

## 🛠️ Technology Stack

* **BigQuery**: Data warehouse and SQL processing engine
* **Google Cloud Storage**: Cloud storage for raw data files and staging
* **SQL**: Primary language for data transformation and analytics
* **Stored Procedures**: Automated ETL orchestration

## 🏗️ Data Architecture

The data architecture follows the **Medallion Architecture** pattern with three distinct layers:

1. **Bronze Layer**: Stores raw data as-is from source systems. Data is ingested from CSV files in Google Cloud Storage into BigQuery tables with minimal transformation.

2. **Silver Layer**: Contains cleansed, validated, and standardized data. Business rules and data quality checks are applied through stored procedures to prepare data for consumption.

3. **Gold Layer**: Houses business-ready data modeled as a star schema (dimension and fact tables) optimized for reporting and analytics.

### Architecture Diagram
```
Source Systems (CRM, ERP)
         ↓
    [CSV Files in GCS]
         ↓
   📊 Bronze Layer (Raw Data)
         ↓
   🔄 Silver Layer (Cleaned & Validated)
         ↓
   ⭐ Gold Layer (Star Schema)
         ↓
    Analytics & Reports
```

## 📊 Data Layer Details

### Bronze Layer Tables
Raw data ingested from source systems without transformations:

| Table Name | Source | Main Purpose | Key Columns |
|------------|--------|--------------|-------------|
| `bronze.crm_cust_info` | CRM | Customer master data | cst_id, cst_key, cst_firstname, cst_lastname, cst_marital_status, cst_gndr, cst_create_date |
| `bronze.crm_prd_info` | CRM | Product master data | prd_id, prd_key (format: CATID-PRDKEY), prd_nm, prd_cost, prd_line, prd_start_dt, prd_end_dt |
| `bronze.crm_sales_details` | CRM | Sales transactions | sls_ord_num, sls_prd_key, sls_cust_id, sls_order_dt, sls_ship_dt, sls_due_dt, sls_sales, sls_quantity, sls_price |
| `bronze.erp_loc_a101` | ERP | Customer location mapping | cid (customer ID), cntry (country code) |
| `bronze.erp_cust_az12` | ERP | Customer demographics | cid (may have "NAS" prefix), bdate (birthdate), gen (gender) |
| `bronze.erp_px_cat_g1v2` | ERP | Product category hierarchy | id (category ID), cat (category), subcat (subcategory), maintenance |

---

### Silver Layer Tables
Cleaned and validated data with business rules applied:

| Table Name | Source | Key Transformations | Data Quality Rules |
|------------|--------|---------------------|-------------------|
| `silver.crm_cust_info` | Bronze CRM | Deduplicated by cst_id (most recent record), trimmed text fields, normalized values | Marital status: S→Single, M→Married<br>Gender: F→Female, M→Male |
| `silver.crm_prd_info` | Bronze CRM | Extracted cat_id (first 5 chars of prd_key), normalized product lines, calculated prd_end_dt using LEAD() | Product line: M→Mountain, R→Road, T→Touring, S→Other Sales<br>Cost: NULL→0 |
| `silver.crm_sales_details` | Bronze CRM | Parsed integer dates to DATE format (YYYYMMDD), validated and recalculated sales amounts | Sales = quantity × price<br>Derived price when missing: sales ÷ quantity |
| `silver.erp_cust_az12` | Bronze ERP | Removed "NAS" prefix from cid, validated birthdates, normalized gender values | Future birthdates→NULL<br>Gender: F/Female→Female, M/Male→Male |
| `silver.erp_loc_a101` | Bronze ERP | Removed dashes from cid, standardized country codes to full names | DE→Germany, US/USA→United States<br>Blank/NULL→n/a |
| `silver.erp_px_cat_g1v2` | Bronze ERP | Pass-through table (no transformations applied) | None |

---

### Gold Layer Views (Star Schema)
Analytics-ready dimensional model optimized for reporting:

| View Name | Type | Grain | Key Features | Source Tables |
|-----------|------|-------|--------------|---------------|
| `gold.dim_customers` | Dimension | One row per customer | **Surrogate key:** customer_key (ROW_NUMBER)<br>**Data enrichment:** Merges CRM + ERP sources<br>**Fallback logic:** Gender from CRM (primary), ERP (secondary)<br>**Attributes:** Demographics, location, create date | `silver.crm_cust_info`<br>`silver.erp_cust_az12`<br>`silver.erp_loc_a101` |
| `gold.dim_products` | Dimension | One row per active product | **Surrogate key:** product_key (ROW_NUMBER)<br>**Filter:** Active products only (prd_end_dt IS NULL)<br>**Hierarchy:** Category → Subcategory<br>**Attributes:** Product details, cost, line, maintenance flag | `silver.crm_prd_info`<br>`silver.erp_px_cat_g1v2` |
| `gold.fact_sales` | Fact | One row per order line item | **Foreign keys:** customer_key, product_key<br>**Measures:** sales_amount, quantity, price<br>**Dates:** order_date, shipping_date, due_date<br>**Business key:** order_number | `silver.crm_sales_details`<br>`gold.dim_customers`<br>`gold.dim_products` |

**Star Schema Relationships:**
- `fact_sales.customer_key` → `dim_customers.customer_key` (Many-to-One)
- `fact_sales.product_key` → `dim_products.product_key` (Many-to-One)

## 🔄 ETL Pipeline

The ETL process is automated using BigQuery stored procedures:

1. **Bronze Layer**: Raw data loaded from GCS CSV files into BigQuery tables
2. **Silver Layer**: `load_silver` stored procedure performs transformations and data quality checks
3. **Gold Layer**: Views created on top of Silver layer tables to form the star schema

### Running the ETL Pipeline
```sql
-- Load Silver layer from Bronze
CALL `project-id.silver.load_silver`();

-- Gold layer views are automatically available once Silver layer is populated
SELECT * FROM `project-id.gold.dim_customers`;
SELECT * FROM `project-id.gold.dim_products`;
SELECT * FROM `project-id.gold.fact_sales`;
```

## 📈 Key Features

- **Medallion Architecture**: Structured three-layer approach for data quality and governance
- **Data Quality**: Comprehensive validation, deduplication, and normalization rules
- **Star Schema**: Optimized dimensional model for analytical queries
- **Automated ETL**: Stored procedures for repeatable and maintainable data pipelines
- **Surrogate Keys**: Dimension tables use surrogate keys for better performance and flexibility
- **Data Lineage**: Clear transformation logic from Bronze → Silver → Gold
`
