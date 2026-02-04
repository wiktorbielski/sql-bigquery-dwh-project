/*
===============================================================================
DDL Script: Create Silver Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'silver' dataset, dropping existing tables 
    if they already exist.
    Run this script to re-define the DDL structure of 'silver' Tables

INSTRUCTIONS:
    Replace 'your-project-id' with your actual GCP project ID before running.
===============================================================================
*/

-- Set your project ID
DECLARE project_id STRING DEFAULT 'your-project-id';

-- Drop and create silver.crm_cust_info
BEGIN
  EXECUTE IMMEDIATE FORMAT('DROP TABLE IF EXISTS `%s.silver.crm_cust_info`', project_id);
END;

EXECUTE IMMEDIATE FORMAT('''
CREATE TABLE `%s.silver.crm_cust_info` (
    cst_id             INT64,
    cst_key            STRING,
    cst_firstname      STRING,
    cst_lastname       STRING,
    cst_marital_status STRING,
    cst_gndr           STRING,
    cst_create_date    DATE,
    dwh_create_date    TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
)''', project_id);

-- Drop and create silver.crm_prd_info
BEGIN
  EXECUTE IMMEDIATE FORMAT('DROP TABLE IF EXISTS `%s.silver.crm_prd_info`', project_id);
END;

EXECUTE IMMEDIATE FORMAT('''
CREATE TABLE `%s.silver.crm_prd_info` (
    prd_id          INT64,
    cat_id          STRING,
    prd_key         STRING,
    prd_nm          STRING,
    prd_cost        INT64,
    prd_line        STRING,
    prd_start_dt    DATE,
    prd_end_dt      DATE,
    dwh_create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
)''', project_id);

-- Drop and create silver.crm_sales_details
BEGIN
  EXECUTE IMMEDIATE FORMAT('DROP TABLE IF EXISTS `%s.silver.crm_sales_details`', project_id);
END;

EXECUTE IMMEDIATE FORMAT('''
CREATE TABLE `%s.silver.crm_sales_details` (
    sls_ord_num     STRING,
    sls_prd_key     STRING,
    sls_cust_id     INT64,
    sls_order_dt    DATE,
    sls_ship_dt     DATE,
    sls_due_dt      DATE,
    sls_sales       INT64,
    sls_quantity    INT64,
    sls_price       INT64,
    dwh_create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
)''', project_id);

-- Drop and create silver.erp_loc_a101
BEGIN
  EXECUTE IMMEDIATE FORMAT('DROP TABLE IF EXISTS `%s.silver.erp_loc_a101`', project_id);
END;

EXECUTE IMMEDIATE FORMAT('''
CREATE TABLE `%s.silver.erp_loc_a101` (
    cid             STRING,
    cntry           STRING,
    dwh_create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
)''', project_id);

-- Drop and create silver.erp_cust_az12
BEGIN
  EXECUTE IMMEDIATE FORMAT('DROP TABLE IF EXISTS `%s.silver.erp_cust_az12`', project_id);
END;

EXECUTE IMMEDIATE FORMAT('''
CREATE TABLE `%s.silver.erp_cust_az12` (
    cid             STRING,
    bdate           DATE,
    gen             STRING,
    dwh_create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
)''', project_id);

-- Drop and create silver.erp_px_cat_g1v2
BEGIN
  EXECUTE IMMEDIATE FORMAT('DROP TABLE IF EXISTS `%s.silver.erp_px_cat_g1v2`', project_id);
END;

EXECUTE IMMEDIATE FORMAT('''
CREATE TABLE `%s.silver.erp_px_cat_g1v2` (
    id              STRING,
    cat             STRING,
    subcat          STRING,
    maintenance     STRING,
    dwh_create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
)''', project_id);
