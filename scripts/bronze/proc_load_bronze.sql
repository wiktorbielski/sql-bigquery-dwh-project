/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' dataset from CSV files 
    stored in Google Cloud Storage (GCS). It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses LOAD DATA to load data from CSV files in GCS to bronze tables.

Prerequisites:
    - CSV files must be uploaded to Google Cloud Storage
    - Appropriate permissions to read from GCS bucket
    
Parameters:
    None. 
    This stored procedure does not accept any parameters or return any values.

Usage Example:
    CALL `project_id.bronze.load_bronze`();
===============================================================================
*/

CREATE OR REPLACE PROCEDURE `project_id.bronze.load_bronze`()
BEGIN
  -- Configuration variables
  DECLARE project_id STRING DEFAULT 'project_id';
  DECLARE gcs_bucket STRING DEFAULT 'your-gcs-bucket-name';
  
  -- Timing variables
  DECLARE start_time TIMESTAMP;
  DECLARE end_time TIMESTAMP;
  DECLARE batch_start_time TIMESTAMP;
  DECLARE batch_end_time TIMESTAMP;
  DECLARE duration_seconds INT64;
  
  BEGIN
    SET batch_start_time = CURRENT_TIMESTAMP();
    
    -- Log start
    SELECT '================================================' AS log_message;
    SELECT 'Loading Bronze Layer' AS log_message;
    SELECT '================================================' AS log_message;

    -- ========================================
    -- Loading CRM Tables
    -- ========================================
    SELECT '------------------------------------------------' AS log_message;
    SELECT 'Loading CRM Tables' AS log_message;
    SELECT '------------------------------------------------' AS log_message;

    -- Load bronze.crm_cust_info
    SET start_time = CURRENT_TIMESTAMP();
    SELECT '>> Truncating Table: bronze.crm_cust_info' AS log_message;
    
    EXECUTE IMMEDIATE FORMAT('TRUNCATE TABLE `%s.bronze.crm_cust_info`', project_id);
    
    SELECT '>> Inserting Data Into: bronze.crm_cust_info' AS log_message;
    
    EXECUTE IMMEDIATE FORMAT('''
    LOAD DATA OVERWRITE `%s.bronze.crm_cust_info`
    FROM FILES (
      format = 'CSV',
      uris = ['gs://%s/source_crm/cust_info.csv'],
      skip_leading_rows = 1,
      field_delimiter = ','
    )''', project_id, gcs_bucket);
    
    SET end_time = CURRENT_TIMESTAMP();
    SET duration_seconds = TIMESTAMP_DIFF(end_time, start_time, SECOND);
    SELECT CONCAT('>> Load Duration: ', CAST(duration_seconds AS STRING), ' seconds') AS log_message;
    SELECT '>> -------------' AS log_message;

    -- Load bronze.crm_prd_info
    SET start_time = CURRENT_TIMESTAMP();
    SELECT '>> Truncating Table: bronze.crm_prd_info' AS log_message;
    
    EXECUTE IMMEDIATE FORMAT('TRUNCATE TABLE `%s.bronze.crm_prd_info`', project_id);
    
    SELECT '>> Inserting Data Into: bronze.crm_prd_info' AS log_message;
    
    EXECUTE IMMEDIATE FORMAT('''
    LOAD DATA OVERWRITE `%s.bronze.crm_prd_info`
    FROM FILES (
      format = 'CSV',
      uris = ['gs://%s/source_crm/prd_info.csv'],
      skip_leading_rows = 1,
      field_delimiter = ','
    )''', project_id, gcs_bucket);
    
    SET end_time = CURRENT_TIMESTAMP();
    SET duration_seconds = TIMESTAMP_DIFF(end_time, start_time, SECOND);
    SELECT CONCAT('>> Load Duration: ', CAST(duration_seconds AS STRING), ' seconds') AS log_message;
    SELECT '>> -------------' AS log_message;

    -- Load bronze.crm_sales_details
    SET start_time = CURRENT_TIMESTAMP();
    SELECT '>> Truncating Table: bronze.crm_sales_details' AS log_message;
    
    EXECUTE IMMEDIATE FORMAT('TRUNCATE TABLE `%s.bronze.crm_sales_details`', project_id);
    
    SELECT '>> Inserting Data Into: bronze.crm_sales_details' AS log_message;
    
    EXECUTE IMMEDIATE FORMAT('''
    LOAD DATA OVERWRITE `%s.bronze.crm_sales_details`
    FROM FILES (
      format = 'CSV',
      uris = ['gs://%s/source_crm/sales_details.csv'],
      skip_leading_rows = 1,
      field_delimiter = ','
    )''', project_id, gcs_bucket);
    
    SET end_time = CURRENT_TIMESTAMP();
    SET duration_seconds = TIMESTAMP_DIFF(end_time, start_time, SECOND);
    SELECT CONCAT('>> Load Duration: ', CAST(duration_seconds AS STRING), ' seconds') AS log_message;
    SELECT '>> -------------' AS log_message;

    -- ========================================
    -- Loading ERP Tables
    -- ========================================
    SELECT '------------------------------------------------' AS log_message;
    SELECT 'Loading ERP Tables' AS log_message;
    SELECT '------------------------------------------------' AS log_message;

    -- Load bronze.erp_loc_a101
    SET start_time = CURRENT_TIMESTAMP();
    SELECT '>> Truncating Table: bronze.erp_loc_a101' AS log_message;
    
    EXECUTE IMMEDIATE FORMAT('TRUNCATE TABLE `%s.bronze.erp_loc_a101`', project_id);
    
    SELECT '>> Inserting Data Into: bronze.erp_loc_a101' AS log_message;
    
    EXECUTE IMMEDIATE FORMAT('''
    LOAD DATA OVERWRITE `%s.bronze.erp_loc_a101`
    FROM FILES (
      format = 'CSV',
      uris = ['gs://%s/source_erp/loc_a101.csv'],
      skip_leading_rows = 1,
      field_delimiter = ','
    )''', project_id, gcs_bucket);
    
    SET end_time = CURRENT_TIMESTAMP();
    SET duration_seconds = TIMESTAMP_DIFF(end_time, start_time, SECOND);
    SELECT CONCAT('>> Load Duration: ', CAST(duration_seconds AS STRING), ' seconds') AS log_message;
    SELECT '>> -------------' AS log_message;

    -- Load bronze.erp_cust_az12
    SET start_time = CURRENT_TIMESTAMP();
    SELECT '>> Truncating Table: bronze.erp_cust_az12' AS log_message;
    
    EXECUTE IMMEDIATE FORMAT('TRUNCATE TABLE `%s.bronze.erp_cust_az12`', project_id);
    
    SELECT '>> Inserting Data Into: bronze.erp_cust_az12' AS log_message;
    
    EXECUTE IMMEDIATE FORMAT('''
    LOAD DATA OVERWRITE `%s.bronze.erp_cust_az12`
    FROM FILES (
      format = 'CSV',
      uris = ['gs://%s/source_erp/cust_az12.csv'],
      skip_leading_rows = 1,
      field_delimiter = ','
    )''', project_id, gcs_bucket);
    
    SET end_time = CURRENT_TIMESTAMP();
    SET duration_seconds = TIMESTAMP_DIFF(end_time, start_time, SECOND);
    SELECT CONCAT('>> Load Duration: ', CAST(duration_seconds AS STRING), ' seconds') AS log_message;
    SELECT '>> -------------' AS log_message;

    -- Load bronze.erp_px_cat_g1v2
    SET start_time = CURRENT_TIMESTAMP();
    SELECT '>> Truncating Table: bronze.erp_px_cat_g1v2' AS log_message;
    
    EXECUTE IMMEDIATE FORMAT('TRUNCATE TABLE `%s.bronze.erp_px_cat_g1v2`', project_id);
    
    SELECT '>> Inserting Data Into: bronze.erp_px_cat_g1v2' AS log_message;
    
    EXECUTE IMMEDIATE FORMAT('''
    LOAD DATA OVERWRITE `%s.bronze.erp_px_cat_g1v2`
    FROM FILES (
      format = 'CSV',
      uris = ['gs://%s/source_erp/px_cat_g1v2.csv'],
      skip_leading_rows = 1,
      field_delimiter = ','
    )''', project_id, gcs_bucket);
    
    SET end_time = CURRENT_TIMESTAMP();
    SET duration_seconds = TIMESTAMP_DIFF(end_time, start_time, SECOND);
    SELECT CONCAT('>> Load Duration: ', CAST(duration_seconds AS STRING), ' seconds') AS log_message;
    SELECT '>> -------------' AS log_message;

    -- Final summary
    SET batch_end_time = CURRENT_TIMESTAMP();
    SET duration_seconds = TIMESTAMP_DIFF(batch_end_time, batch_start_time, SECOND);
    
    SELECT '==========================================' AS log_message;
    SELECT 'Loading Bronze Layer is Completed' AS log_message;
    SELECT CONCAT('   - Total Load Duration: ', CAST(duration_seconds AS STRING), ' seconds') AS log_message;
    SELECT '==========================================' AS log_message;
    
  EXCEPTION WHEN ERROR THEN
    SELECT '==========================================' AS log_message;
    SELECT 'ERROR OCCURRED DURING LOADING BRONZE LAYER' AS log_message;
    SELECT CONCAT('Error Message: ', @@error.message) AS log_message;
    SELECT '==========================================' AS log_message;
  END;
END;
