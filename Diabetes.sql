create database Psyliq;
USE Psyliq;
SELECT * from Diabetes
ALTER TABLE Diabetes
ADD COLUMN IF NOT EXISTS age INT;

SELECT * from Diabetes

-- Q1. Retrieve the Patient_id and ages of all patients.
UPDATE Diabetes
SET age = FLOOR(DATEDIFF(CURDATE(), STR_TO_DATE(`D.O.B`, '%d-%m-%Y')) / 365.25);
SELECT * from Diabetes

SELECT Patient_id, age
FROM Diabetes;

-- Q2. Select all female patients who are older than 30.
SELECT * from Diabetes
WHERE gender = 'Female' and age > 30

-- Q3. Calculate the average BMI of patients.
SELECT AVG(bmi) AS Avg_BMI
FROM Diabetes

-- Q4. List patients in descending order of blood glucose levels.
SELECT * 
FROM Diabetes
ORDER by blood_glucose_level DESC;

-- Q5. Find patients who have hypertension and diabetes.
SELECT *
FROM Diabetes
WHERE hypertension = 1 AND diabetes = 1

-- Q6. Determine the number of patients with heart disease.
SELECT count(Patient_id) AS Patients_with_heartdisease
FROM Diabetes
WHERE heart_disease = 1

-- Q7. Group patients by smoking history and count how many smokers and non-smokers there are.
-- i) Smoking history
SELECT Patient_id,EmployeeName,gender,age,hypertension,bmi,blood_glucose_level,HbA1c_level,diabetes,smoking_history  
FROM Diabetes
GROUP BY smoking_history,Patient_id,EmployeeName,gender,age,hypertension,bmi,blood_glucose_level,HbA1c_level,diabetes
-- ii) Count - Smokers and Non-Smokers
SELECT sum( CASE WHEN smoking_history IN ('current','not current','ever','former') then 1 else 0 end) as Smokers,
       sum( CASE WHEN smoking_history IN ('never') THEN 1 ELSE 0 END) AS NonSmokers
FROM Diabetes

-- Q8. Retrieve the Patient_id of patients who have a BMI greater than the average BMI.
SELECT Patient_id FROM Diabetes
WHERE bmi > (
SELECT AVG(bmi) AS Avg_BMI
FROM Diabetes 
)

-- Q9. Find the patient with the highest HbA1c_level and the patient with the lowest HbA1clevel.
-- i)
SELECT * 
FROM Diabetes
ORDER BY HbA1c_level DESC
LIMIT 1;

-- ii)

SELECT * 
FROM Diabetes
ORDER BY HbA1c_level ASC
LIMIT 1;

-- Q10. Calculate the age of patients in years (assuming the current date as of now)
-- Please refer answer for Q1

-- Q11. Rank patients by blood glucose level within each gender group.
SELECT Patient_id,gender,blood_glucose_level,
DENSE_RANK() OVER ( Partition by gender ORDER BY blood_glucose_level DESC) AS Ranked_Patients
FROM Diabetes

-- Q12. Update the smoking history of patients who are older than 40 to "Ex-smoker."
UPDATE Diabetes
SET smoking_history = 'Ex-smoker'
WHERE age > 40 

-- Q13. Insert a new patient into the database with sample data.
INSERT INTO Diabetes (EmployeeName,Patient_id,gender, age,hypertension, heart_disease,smoking_history,bmi,HbA1c_level,blood_glucose_level,diabetes)
 VALUES ( 'Jeniffer Miller', 'PT999', 'Female', 35, 1, 0, 'Never', 25, 5.8, 100, 1)
 
SELECT * 
FROM Diabetes 
WHERE EmployeeName = 'Jeniffer Miller';

-- Q14. Delete all patients with heart disease from the database.
SELECT * 
FROM Diabetes 
WHERE heart_disease = 1

DELETE FROM Diabetes
WHERE heart_disease = 1;

-- Q15. Find patients who have hypertension but not diabetes using the EXCEPT operator.
SELECT *
FROM Diabetes
WHERE hypertension = 1 
EXCEPT
SELECT *
FROM Diabetes
WHERE diabetes =1

-- Q16. Define a unique constraint on the "patient_id" column to ensure its values are unique.

ALTER TABLE Diabetes
MODIFY COLUMN Patient_id VARCHAR(255) NOT NULL;


ALTER TABLE Diabetes
ADD CONSTRAINT Patient_id UNIQUE(Patient_id);

-- 17. Create a view that displays the Patient_ids, ages, and BMI of patients.
CREATE VIEW  Patient_info AS
SELECT Patient_id, Age, BMI FROM Diabetes;

SELECT Patient_id, Age, BMI
FROM Patient_info


-- Q18. Suggest improvements in the database schema to reduce data redundancy and 	improve data integrity.
/*When it comes to improving a database schema, there are several best practices you can follow to reduce data redundancy and enhance data integrity. Here are some suggestions:

    1. Normalize the Database
    Normalization helps organize your data to minimize redundancy. You can think of it in terms of three main levels:
        First Normal Form (1NF): Make sure each table has a primary key and that all entries in a column are of the same data type.
        Second Normal Form (2NF): Eliminate partial dependencies. Every non-key attribute should rely on the entire primary key.
        Third Normal Form (3NF): Get rid of transitive dependencies, meaning non-key attributes shouldn't depend on other non-key attributes.

    2. Use Foreign Keys
    Establish relationships between tables using foreign keys. This maintains referential integrity, ensuring that the relationships between tables stay consistent. For instance, if you have a Patients table and a Diabetes table, you’d use patient_id as a foreign key in the Diabetes table.

    3. Separate Related Entities
    If your database includes multiple related entities—like Patients, Doctors, and Medications—consider creating separate tables for each one. This approach helps reduce redundancy. For example:
        Patients: Basic patient info.
        Doctors: Details about doctors.
        Medications: Information on medications.
        Visits: Records linking patients and doctors.

    4. Use Appropriate Data Types
    Make sure to choose data types that fit the nature of the data. For example, use INT for IDs, DATE for dates, and VARCHAR for variable-length strings. This can help maintain data integrity and optimize storage.

    5. Implement Constraints
    Set up constraints like UNIQUE, NOT NULL, and CHECK to enforce rules on the data and ensure its validity. For instance, ensuring that patient_id is unique can prevent duplicate entries.

    6. Use Default Values
    It’s a good idea to set default values for columns where applicable. This can help reduce the chance of NULL entries, which might lead to data integrity issues.

    7. Archive Old Data
    Consider moving historical or less frequently accessed data to an archive table. This keeps your main tables lean and can improve performance.

    8. Document Relationships and Rules
    Keep clear documentation of the relationships between tables and any business rules. This not only helps in understanding the schema but also ensures that future changes follow established guidelines. */
    
    -- Q19. Explain how you can optimize the performance of SQL queries on this dataset.
    /*To optimize the performance of SQL queries on a dataset, here are several strategies you should consider:

    1. Indexing:
        - Create indexes on frequently queried columns to speed up data retrieval.
        - Focus on primary keys, foreign keys, and columns used in WHERE clauses.

    2. Use Appropriate Data Types:
        - Choose the right data types for your columns to minimize storage space and improve query performance.
        - Use types like INT for IDs and VARCHAR for known-length strings.

    3. Optimize Queries:
        - Select only the necessary columns instead of using SELECT *.
        - Use WHERE clauses effectively to filter results as much as possible.

    4. Limit Result Sets:
        - When you only need a subset of data, use LIMIT to restrict the number of rows returned.

    5. Avoid Using Functions in WHERE Clauses:
        - Using functions on indexed columns can prevent the use of indexes.
        - Instead, use direct comparisons.

    6. Batch Inserts and Updates:
        - When inserting or updating a large number of records, do it in batches to reduce overhead.

    7. Analyze and Optimize Query Execution Plans:
        - Use the EXPLAIN statement to understand how MySQL executes your queries.
        - Identify any bottlenecks in the process.

    8. Regular Maintenance:
        - Perform regular maintenance tasks, such as analyzing and optimizing tables.
        - This helps update index statistics and reclaim space.

    9. Caching:
        - Implement caching mechanisms for frequently accessed data to reduce the number of database hits.

    10. Use Connection Pooling:
        - For high volumes of database connections, use connection pooling to manage connections more efficiently.*/
