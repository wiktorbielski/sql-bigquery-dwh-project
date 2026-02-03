/*
=============================================================
Create Datasets for Data Warehouse
=============================================================
Script Purpose:
    This script creates three datasets in BigQuery: 'bronze', 'silver', and 'gold'
    for organizing data warehouse layers. If datasets already exist, they are dropped 
    and recreated.
	
WARNING:
    Running this script will drop the datasets if they exist. 
    All tables and data in these datasets will be permanently deleted. 
    Proceed with caution and ensure you have proper backups before running this script.

INSTRUCTIONS:
    Replace 'your-project-id' with your actual GCP project ID before running.
*/

-- Set your project ID
DECLARE project_id STRING DEFAULT 'your-project-id';

-- Drop and recreate 'bronze' dataset
BEGIN
  EXECUTE IMMEDIATE FORMAT('DROP SCHEMA IF EXISTS `%s.bronze` CASCADE', project_id);
  EXECUTE IMMEDIATE FORMAT('CREATE SCHEMA `%s.bronze`', project_id);
EXCEPTION WHEN ERROR THEN
  -- If dataset doesn't exist, just create it
  EXECUTE IMMEDIATE FORMAT('CREATE SCHEMA IF NOT EXISTS `%s.bronze`', project_id);
END;

-- Drop and recreate 'silver' dataset
BEGIN
  EXECUTE IMMEDIATE FORMAT('DROP SCHEMA IF EXISTS `%s.silver` CASCADE', project_id);
  EXECUTE IMMEDIATE FORMAT('CREATE SCHEMA `%s.silver`', project_id);
EXCEPTION WHEN ERROR THEN
  EXECUTE IMMEDIATE FORMAT('CREATE SCHEMA IF NOT EXISTS `%s.silver`', project_id);
END;

-- Drop and recreate 'gold' dataset
BEGIN
  EXECUTE IMMEDIATE FORMAT('DROP SCHEMA IF EXISTS `%s.gold` CASCADE', project_id);
  EXECUTE IMMEDIATE FORMAT('CREATE SCHEMA `%s.gold`', project_id);
EXCEPTION WHEN ERROR THEN
  EXECUTE IMMEDIATE FORMAT('CREATE SCHEMA IF NOT EXISTS `%s.gold`', project_id);

END;
