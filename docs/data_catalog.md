# Data Catalog for Gold Layer

## Overview
The Gold Layer is the business-level data representation, structured to support analytical and reporting use cases. It consists of **dimension views** and **fact views** following a star schema for analytical queries in BigQuery.

---

## Dimension Tables

### 1. **gold.dim_customers**
- **Type:** View
- **Purpose:** Stores customer details enriched with demographic and geographic data from CRM and ERP sources.
- **Source Tables:** `silver.crm_cust_info`, `silver.erp_cust_az12`, `silver.erp_loc_a101`
- **Grain:** One row per unique customer

**Columns:**

| Column Name      | Data Type  | Description                                                                                   | Source Column |
|------------------|------------|-----------------------------------------------------------------------------------------------|---------------|
| customer_key     | INT64      | Surrogate key uniquely identifying each customer record (generated via ROW_NUMBER).           | Generated     |
| customer_id      | INT64      | Unique numerical identifier assigned to each customer from source system.                     | cst_id        |
| customer_number  | STRING     | Alphanumeric identifier representing the customer, used for tracking and referencing.         | cst_key       |
| first_name       | STRING     | The customer's first name, as recorded in the system.                                         | cst_firstname |
| last_name        | STRING     | The customer's last name or family name.                                                      | cst_lastname  |
| country          | STRING     | The country of residence for the customer (e.g., 'Germany', 'United States').                | cntry         |
| marital_status   | STRING     | The marital status of the customer (e.g., 'Married', 'Single', 'n/a').                       | cst_marital_status |
| gender           | STRING     | The gender of the customer (e.g., 'Male', 'Female', 'n/a'). Uses CRM data with ERP fallback. | cst_gndr / gen |
| birthdate        | DATE       | The date of birth of the customer, formatted as YYYY-MM-DD (e.g., 1971-10-06).               | bdate         |
| create_date      | TIMESTAMP  | The timestamp when the customer record was created in the source system.                      | cst_create_date |

**Sample Query:**
```sql
SELECT 
    customer_key,
    customer_number,
    first_name,
    last_name,
    country,
    gender
FROM `project-id.gold.dim_customers`
WHERE country = 'United States'
LIMIT 10;
```

---

### 2. **gold.dim_products**
- **Type:** View
- **Purpose:** Provides information about current products and their attributes with category hierarchy.
- **Source Tables:** `silver.crm_prd_info`, `silver.erp_px_cat_g1v2`
- **Grain:** One row per active product (WHERE prd_end_dt IS NULL)
- **Filter:** Only includes currently active products

**Columns:**

| Column Name      | Data Type  | Description                                                                                   | Source Column |
|------------------|------------|-----------------------------------------------------------------------------------------------|---------------|
| product_key      | INT64      | Surrogate key uniquely identifying each product record (generated via ROW_NUMBER).            | Generated     |
| product_id       | INT64      | A unique identifier assigned to the product for internal tracking and referencing.            | prd_id        |
| product_number   | STRING     | A structured alphanumeric code representing the product.                                      | prd_key       |
| product_name     | STRING     | Descriptive name of the product, including key details such as type, color, and size.         | prd_nm        |
| category_id      | STRING     | A unique identifier for the product's category, extracted from product key.                   | cat_id        |
| category         | STRING     | The broader classification of the product (e.g., Bikes, Components).                          | cat           |
| subcategory      | STRING     | A more detailed classification of the product within the category.                            | subcat        |
| maintenance      | STRING     | Indicates whether the product requires maintenance (e.g., 'Yes', 'No').                       | maintenance   |
| cost             | INT64      | The cost or base price of the product, measured in monetary units.                            | prd_cost      |
| product_line     | STRING     | The specific product line to which the product belongs (e.g., 'Road', 'Mountain', 'Touring'). | prd_line      |
| start_date       | DATE       | The date when the product became available for sale, formatted as YYYY-MM-DD.                 | prd_start_dt  |

**Sample Query:**
```sql
SELECT 
    product_key,
    product_name,
    category,
    subcategory,
    product_line,
    cost
FROM `project-id.gold.dim_products`
WHERE product_line = 'Mountain'
ORDER BY cost DESC
LIMIT 10;
```

---

## Fact Tables

### 3. **gold.fact_sales**
- **Type:** View
- **Purpose:** Stores transactional sales data for analytical purposes with links to dimension tables.
- **Source Tables:** `silver.crm_sales_details`, `gold.dim_products`, `gold.dim_customers`
- **Grain:** One row per order line item (order_number + product combination)

**Columns:**

| Column Name     | Data Type  | Description                                                                                   | Source Column |
|-----------------|------------|-----------------------------------------------------------------------------------------------|---------------|
| order_number    | STRING     | A unique alphanumeric identifier for each sales order (e.g., 'SO54496').                     | sls_ord_num   |
| product_key     | INT64      | Surrogate key linking the order to the product dimension table.                               | Generated FK  |
| customer_key    | INT64      | Surrogate key linking the order to the customer dimension table.                              | Generated FK  |
| order_date      | DATE       | The date when the order was placed, formatted as YYYY-MM-DD.                                  | sls_order_dt  |
| shipping_date   | DATE       | The date when the order was shipped to the customer.                                          | sls_ship_dt   |
| due_date        | DATE       | The date when the order payment was due.                                                      | sls_due_dt    |
| sales_amount    | INT64      | The total monetary value of the sale for the line item (calculated as quantity × price).      | sls_sales     |
| quantity        | INT64      | The number of units of the product ordered for the line item.                                 | sls_quantity  |
| price           | INT64      | The price per unit of the product for the line item, in whole currency units.                 | sls_price     |

**Sample Query:**
```sql
SELECT 
    f.order_number,
    c.first_name,
    c.last_name,
    p.product_name,
    f.order_date,
    f.quantity,
    f.sales_amount
FROM `project-id.gold.fact_sales` f
JOIN `project-id.gold.dim_customers` c ON f.customer_key = c.customer_key
JOIN `project-id.gold.dim_products` p ON f.product_key = p.product_key
WHERE f.order_date >= '2023-01-01'
ORDER BY f.sales_amount DESC
LIMIT 10;
```

---

## Star Schema Relationships
```
        dim_customers                    dim_products
              |                                |
    customer_key (PK)                 product_key (PK)
              |                                |
              └────────────┬──────────────────┘
                           │
                      fact_sales
                  ┌──────────────────┐
                  │ customer_key (FK)│
                  │ product_key (FK) │
                  │ order_number     │
                  │ sales_amount     │
                  │ quantity         │
                  │ price            │
                  └──────────────────┘
```

**Relationships:**
- `fact_sales.customer_key` → `dim_customers.customer_key` (Many-to-One)
- `fact_sales.product_key` → `dim_products.product_key` (Many-to-One)

---

## Common Analytical Queries

### Sales by Customer
```sql
SELECT 
    c.customer_number,
    c.first_name || ' ' || c.last_name AS customer_name,
    c.country,
    COUNT(DISTINCT f.order_number) AS total_orders,
    SUM(f.quantity) AS total_items,
    SUM(f.sales_amount) AS total_sales
FROM `project-id.gold.fact_sales` f
JOIN `project-id.gold.dim_customers` c ON f.customer_key = c.customer_key
GROUP BY c.customer_number, customer_name, c.country
ORDER BY total_sales DESC
LIMIT 20;
```

### Sales by Product Category
```sql
SELECT 
    p.category,
    p.subcategory,
    COUNT(DISTINCT f.order_number) AS total_orders,
    SUM(f.quantity) AS units_sold,
    SUM(f.sales_amount) AS total_revenue,
    AVG(f.price) AS avg_price
FROM `project-id.gold.fact_sales` f
JOIN `project-id.gold.dim_products` p ON f.product_key = p.product_key
GROUP BY p.category, p.subcategory
ORDER BY total_revenue DESC;
```

### Monthly Sales Trend
```sql
SELECT 
    DATE_TRUNC(f.order_date, MONTH) AS month,
    COUNT(DISTINCT f.order_number) AS orders,
    SUM(f.quantity) AS items_sold,
    SUM(f.sales_amount) AS revenue
FROM `project-id.gold.fact_sales` f
WHERE f.order_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 12 MONTH)
GROUP BY month
ORDER BY month;
```
