%md
# Naming Conventions

This document outlines the naming conventions used for datasets, tables, views, columns, and other objects in the BigQuery data warehouse.

---

## Table of Contents

1. [General Principles](#general-principles)
2. [Dataset Naming](#dataset-naming)
3. [Table Naming Conventions](#table-naming-conventions)
4. [Column Naming Conventions](#column-naming-conventions)
5. [Stored Procedures](#stored-procedures)

---

## General Principles

- **Case Convention**: Use `snake_case` with lowercase letters and underscores (`_`) to separate words
- **Language**: Use English for all names
- **Avoid Reserved Words**: Do not use SQL reserved keywords as object names
- **Clarity**: Use descriptive names that clearly indicate purpose

---

## Dataset Naming

Datasets represent the three layers of the Medallion Architecture:

| Dataset Name | Purpose |
|--------------|---------|
| `bronze` | Raw data from source systems (unprocessed) |
| `silver` | Cleansed and validated data |
| `gold` | Business-ready dimensional models (star schema) |

---

## Table Naming Conventions

### Bronze Layer

**Pattern**: `<source_system>_<original_table_name>`

- Preserve original source system structure
- Maintain exact table names from source systems
- No renaming or transformations

**Examples**:
- `crm_cust_info` → Customer data from CRM
- `erp_loc_a101` → Location data from ERP
- `crm_sales_details` → Sales transactions from CRM

---

### Silver Layer

**Pattern**: `<source_system>_<original_table_name>`

- Same naming convention as Bronze layer
- Maintains traceability to source systems
- Contains cleansed versions of Bronze tables

**Examples**:
- `crm_cust_info` → Cleansed customer data
- `erp_cust_az12` → Validated customer demographics
- `crm_sales_details` → Transformed sales data

---

### Gold Layer

**Pattern**: `<category>_<business_entity>`

- Use business-friendly entity names
- Apply dimensional modeling patterns (star schema)

**Category Prefixes**:

| Prefix | Meaning | Example |
|--------|---------|---------|
| `dim_` | Dimension table | `dim_customers`, `dim_products` |
| `fact_` | Fact table | `fact_sales` |
| `agg_` | Aggregated table | `agg_sales_monthly` |

**Examples**:
- `dim_customers` → Customer dimension
- `dim_products` → Product dimension
- `fact_sales` → Sales fact table

---

## Column Naming Conventions

### Bronze and Silver Layers

**Preserve source system column names** for traceability:

**CRM Prefixes**:
- `cst_` → Customer columns (e.g., `cst_id`, `cst_firstname`)
- `prd_` → Product columns (e.g., `prd_id`, `prd_nm`)
- `sls_` → Sales columns (e.g., `sls_ord_num`, `sls_sales`)

**ERP Naming**:
- Source-specific names without standardization
- Examples: `cid`, `bdate`, `gen`, `cntry`

---

### Gold Layer

**Use business-friendly column names**:

| Source Column (Silver) | Gold Column | Description |
|------------------------|-------------|-------------|
| `cst_id` | `customer_id` | Natural key |
| `cst_key` | `customer_number` | Business key |
| `cst_firstname` | `first_name` | Customer first name |
| `prd_nm` | `product_name` | Product name |
| `sls_sales` | `sales_amount` | Sales revenue |

---

### Surrogate Keys

**Pattern**: `<entity>_key`

- Primary key for dimension tables in Gold layer
- Generated using `ROW_NUMBER()` or sequences
- Integer data type

**Examples**:
- `customer_key` → Primary key in `dim_customers`
- `product_key` → Primary key in `dim_products`

---

### Foreign Keys

**Pattern**: `<referenced_entity>_key`

- Matches the surrogate key name in the dimension table

**Examples**:
- `customer_key` in `fact_sales` → References `dim_customers.customer_key`
- `product_key` in `fact_sales` → References `dim_products.product_key`

---

### Natural Keys

**Pattern**: `<entity>_id` or `<entity>_number`

- `_id` → System-generated identifiers
- `_number` → Human-readable identifiers

**Examples**:
- `customer_id` → Original ID from source
- `order_number` → Human-readable order ID

---

### Technical Columns

**Pattern**: `dwh_<purpose>`

- System-generated metadata for ETL tracking
- Required in Silver and Gold layers

**Standard Technical Columns**:

| Column Name | Data Type | Purpose |
|-------------|-----------|---------|
| `dwh_load_date` | TIMESTAMP | Record load timestamp |
| `dwh_update_date` | TIMESTAMP | Last update timestamp |
| `dwh_source_system` | STRING | Source system (e.g., 'CRM', 'ERP') |

## Stored Procedures

**Pattern**: `load_<layer>`

- ETL procedures for populating data warehouse layers

**Examples**:
- `load_bronze` → Loads data into Bronze layer
- `load_silver` → Transforms Bronze → Silver
- `load_gold` → Creates Gold layer views

**Usage**:
```sql
CALL `project-id.silver.load_silver`();
