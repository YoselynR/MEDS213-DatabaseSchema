-- Industrial Energy Efficiency Data Tables

-- Drop tables if necessary (only after creating it wrong)

DROP TABLE IF EXISTS industrialenergy.emissions;
DROP TABLE IF EXISTS industrialenergy.recc;
DROP TABLE IF EXISTS industrialenergy.assess;
DROP TABLE IF EXISTS industrialenergy.arc;
DROP TABLE IF EXISTS clean_raw_data;


-- Load in data and look at info

CREATE TABLE raw_data AS 
SELECT * FROM read_csv_auto('data/iac_integrated_data.csv', HEADER=TRUE);

PRAGMA table_info('raw_data');


-- Create schema

CREATE SCHEMA IF NOT EXISTS industrialenergy;


-- Create tables

-- Create arc table

CREATE TABLE industrialenergy.arc (
  arc2 TEXT PRIMARY KEY,             
  arc_description TEXT              
);

-- Create emissions table

CREATE TABLE industrialenergy.emissions (
  superid TEXT PRIMARY KEY,       
  emission_factor_units TEXT,       
  emission_type TEXT,               
  emission_factor DOUBLE,
  emissions_avoided DOUBLE,           
  sector TEXT                       
);

-- Create assess table

CREATE TABLE industrialenergy.assess (
  id TEXT PRIMARY KEY,    
  superid TEXT,                                     
  impcost DOUBLE,                   
  impcost_adj DOUBLE,               
  payback DOUBLE,                   
  reference_year INTEGER,           
  reference_ppi DOUBLE,            
  fy INTEGER,                       
  arc2 TEXT,                                           
  conserved DOUBLE,                 
  saved DOUBLE                                                                                    
);

-- Create clean raw data

CREATE TABLE clean_raw_data AS
SELECT 
  superid,
  id,
  arc2,
  impcost,
  impcost_adj,
  payback,
  reference_year,
  reference_ppi,
  fy,
  conserved,
  saved,
  emission_type,
  emission_factor_units,
  emission_factor,
  emissions_avoided,
  sector,
  arc_description
FROM raw_data
WHERE emission_type = 'CO2'  
  AND arc2 IS NOT NULL
  AND superid IS NOT NULL
  AND id IS NOT NULL
  AND impcost IS NOT NULL
  AND impcost_adj IS NOT NULL
  AND payback IS NOT NULL
  AND reference_year IS NOT NULL
  AND reference_ppi IS NOT NULL;


-- Insert data into tables

-- Insert into arc table

INSERT INTO industrialenergy.arc (arc2, arc_description)
SELECT DISTINCT arc2, arc_description
FROM clean_raw_data
WHERE arc2 IS NOT NULL
ON CONFLICT (arc2) DO NOTHING;

-- Insert into emissions table

WITH EmissionData AS (
  SELECT
    superid, emission_factor_units, emission_type, emission_factor, emissions_avoided, sector,
    ROW_NUMBER() OVER (PARTITION BY superid ORDER BY emission_factor DESC) AS row_num
  FROM clean_raw_data
  WHERE superid IS NOT NULL AND emission_type = 'CO2'
)
INSERT INTO industrialenergy.emissions (
  superid, emission_factor_units, emission_type, emission_factor, emissions_avoided, sector
)
SELECT superid, emission_factor_units, emission_type, emission_factor, emissions_avoided, sector
FROM EmissionData
WHERE row_num = 1
ON CONFLICT (superid) DO NOTHING;

-- Insert into assess table

WITH AssessData AS (
  SELECT
    id, superid, impcost, impcost_adj, payback, reference_year, reference_ppi, fy,
    arc2, conserved, saved,
    ROW_NUMBER() OVER (PARTITION BY id ORDER BY superid DESC) AS row_num
  FROM clean_raw_data
  WHERE id IS NOT NULL
)
INSERT INTO industrialenergy.assess (
  id, superid, impcost, impcost_adj, payback, reference_year, reference_ppi, fy,
    arc2, conserved, saved
)
SELECT id, superid, impcost, impcost_adj, payback, reference_year, reference_ppi, fy,
    arc2, conserved, saved
FROM AssessData
WHERE row_num = 1
ON CONFLICT (id) DO NOTHING;


-- View tables to verify data and save
-- View assess
SELECT * FROM industrialenergy.assess
LIMIT 10;
-- View arc
SELECT * FROM industrialenergy.arc
LIMIT 10;
-- View emissions
SELECT * FROM industrialenergy.emissions
LIMIT 10;
-- View clean raw data
SELECT * FROM clean_raw_data
LIMIT 10;

-- Save tables

COPY industrialenergy.assess TO 'exports/assess.csv' (HEADER, DELIMITER ',');
COPY industrialenergy.arc TO 'exports/arc.csv' (HEADER, DELIMITER ',');
COPY industrialenergy.emissions TO 'exports/emissions.csv' (HEADER, DELIMITER ',');

