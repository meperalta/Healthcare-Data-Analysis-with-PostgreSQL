/* Healthcare Data Analysis with PostgreSQL

   Project Steps: 
   Import Dataset 'COPY csv file into PostgreSQL'
   Create Table 'CREATE TABLE'
   Data Exploration Queries 'SELECT'
   Statistical Analysis Queries 'AVG, COUNT'
   Insurance Provider Analysis 'COUNT, AVG'
   Patient Outcome Analysis Queries 
   Room Utilization Analysis Queries
   Doctor Performance Queries

Other Skills used: Aggregation, Filtering and Sorting, Joins, Group by, Order by
			 Windows Functions, CTEs (Common Table Expressions, Creating Views           
*/

/* Creating a table to define a table to store the healthcare dataset */

CREATE TABLE healthcare_dataset (
    Name VARCHAR(255),
    Age INTEGER,
    Gender VARCHAR(10),
    Blood_Type VARCHAR(5),
    Medical_Condition VARCHAR(100),
    Date_of_Admission DATE,
    Doctor VARCHAR(255),
    Hospital VARCHAR(255),
    Insurance_provider VARCHAR(100),
    Billing_Amount NUMERIC(18, 2),
    Room_Number INTEGER,
    Admission_Type VARCHAR(50),
    Discharge_Date DATE,
    Medication VARCHAR(100),
    Test_Results VARCHAR(100)
);

/* DATA EXPLORATION 
Basic SELECT Queries
Retrieve data from table 
*/
SELECT * FROM healthcare_dataset;

-- Retrieve the first 10 rows of the dataset
SELECT * FROM healthcare_dataset LIMIT 10;

-- Count total number of records in the dataset
SELECT COUNT(*) AS total_records
FROM healthcare_dataset;

-- Identify unique medical conditions present in the dataset
SELECT DISTINCT "medical_condition"
FROM healthcare_dataset;


/* STATISTICAL ANALYSIS QUERIES */
-- statistical analysis on the billing amounts:
-- Calculate the average billing amount.
SELECT AVG("billing_amount") AS average_billing_amount
FROM healthcare_dataset;

-- Highest and lowest billing amounts
SELECT
    MAX("billing_amount") AS highest_billing_amount,
    MIN("billing_amount") AS lowest_billing_amount
FROM healthcare_dataset;

--Aggregation to summarize data: 
   Count total admission and Calculate the average billing amount for each medical condition */
SELECT COUNT(*) AS total_admissions 
FROM healthcare_dataset;

-- Calculate the total billing amount for each medical condition
SELECT medical_condition, AVG(billing_amount) AS avg_billing_amount 
FROM healthcare_dataset 
GROUP BY medical_condition;

/* Aggregation and Grouping: Calculating average billing amount by insurance provider */
SELECT insurance_provider, AVG(billing_amount) AS average_billing_amount
FROM healthcare_dataset
GROUP BY insurance_provider
ORDER BY average_billing_amount DESC;

/* Analyzing Insurance Provider
   Count the number of admissions for each insurance provider */
SELECT
    "insurance_provider",
    COUNT(*) AS admissions_count
FROM healthcare_dataset
GROUP BY "insurance_provider"
ORDER BY admissions_count DESC;

-- Calculate the average billing amount for each insurance provider
SELECT
    "insurance_provider",
    AVG("billing_amount") AS avg_billing_amount
FROM healthcare_dataset
GROUP BY "insurance_provider"
ORDER BY avg_billing_amount DESC;

/* Patient Outcome Analysis
   Count the number of patients with abnormal test results */
   
SELECT
    COUNT(*) AS abnormal_results_count
FROM healthcare_dataset
WHERE "test_results" = 'Abnormal';

--Calculate the percentage of patients with abnormal outcomes for each medical condition
SELECT
    "medical_condition",
    COUNT(*) AS total_patients,
    COUNT(*) FILTER (WHERE "test_results" = 'Abnormal') AS abnormal_patients,
    (COUNT(*) FILTER (WHERE "test_results" = 'Abnormal') * 100.0) / COUNT(*) AS percentage_abnormal
FROM healthcare_dataset
GROUP BY "medical_condition";

-- Analyze the room utilization
SELECT
    "room_number",
    COUNT(*) AS admissions_count
FROM healthcare_dataset
GROUP BY "room_number"
ORDER BY "room_number";

-- Doctors number of patients treated
SELECT
    "doctor",
    COUNT(*) AS patients_treated
FROM healthcare_dataset
GROUP BY "doctor"
ORDER BY patients_treated DESC;

-- Calculate the average billing amount for each doctor
SELECT
    "doctor",
    AVG("billing_amount") AS avg_billing_amount
FROM healthcare_dataset
GROUP BY "doctor"
ORDER BY avg_billing_amount DESC;


/* Filtering and Sorting based on Medicare 
   analyzing medicare-covered cases */
SELECT * FROM healthcare_dataset 
WHERE insurance_provider = 'Medicare' 
ORDER BY date_of_admission;

/* Joins: Combine Data from Multiple Tables */
-- Performing a simple JOIN between "healthcare_dataset" and "doctors"
SELECT
    hd.doctor,
    hd.medical_condition,
    hd.hospital,
    d.doctor_name
FROM
    healthcare_dataset hd
JOIN
    doctors d ON hd.doctor = d.doctor_name;

/* Window Functions for calculations over average billing amount accorss all patients in the dataset */
SELECT patient_name, billing_amount, AVG(billing_amount) OVER () AS avg_billing_amount
FROM healthcare_dataset;

/* CTEs (Common table Expressions) to create temporary results sets for complex queries */
WITH high_billing AS (
    SELECT * FROM healthcare_dataset WHERE billing_amount > 50000
)
SELECT * FROM high_billing;

/* Creating Views for commonly used queries */
CREATE VIEW high_billing_view AS
SELECT * FROM healthcare_dataset 
WHERE billing_amount > 50000;