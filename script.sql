CREATE DATABASE IF NOT EXISTS churn_analysis;
USE churn_analysis;

SELECT * FROM churn;

/*
-----||| Understanding the Dataset |||-----
*/
-- Some info about the dataset
DESCRIBE churn;

-- Number of columns
SELECT
	COUNT(column_name) AS numberOfColumns
FROM information_schema.columns
WHERE
	table_schema = 'churn_analysis'
    AND
    table_name = 'churn';

-- Number of rows
SELECT
	COUNT(*) AS numberOfRows
FROM churn;

-- Column name and description
SELECT
	column_name AS columnName,
	CASE 
		WHEN column_name = 'customerid' THEN 'Unique identifier of each customer'
		WHEN column_name = 'creditscore' THEN 'A customer ability to pay their debts and meet their financial obligations'
		WHEN column_name = 'geography' THEN 'Country the customer is in'
		WHEN column_name = 'gender' THEN 'Customer gender (Male/Female)'
		WHEN column_name = 'age' THEN 'Describe the age of the customers'
		WHEN column_name = 'tenure' THEN 'Period of time (years) that a customer maintains an active relationship with a bank or financial institution'
		WHEN column_name = 'balance' THEN 'Amount of money that is available or that remains in a bank account after all transactions have been considered'
		WHEN column_name = 'numofproducts' THEN 'Number of products/services that a customer has or had'
		WHEN column_name = 'hascrcard' THEN '1 if has credit card and 0 if not'
        WHEN column_name = 'isactivemember' THEN '1 if is active member and 0 if not'
        WHEN column_name = 'estimatedsalary' THEN 'Estimated salary in dollar per month'
        WHEN column_name = 'exited' THEN '1 if exited and 0 if not'
	END as description
FROM information_schema.columns
WHERE 
	table_schema = 'churn_analysis'
    AND
    table_name = 'churn';

-- Checking missing values
SELECT
	COUNT(*) AS missingValues
FROM churn
WHERE NULL IN (customerid, creditscore, geography, gender, age, tenure, balance, numofproducts, hascrcard, isactivemember, estimatedsalary, exited);


/*--| Show categorical values |--*/

-- Credit score
SELECT
	creditScore,
    COUNT(customerid) AS quantityOfCustomers
FROM churn
GROUP BY creditscore;

-- Geography
SELECT
	geography,
    COUNT(customerId) AS quantityOfCustomers
FROM churn
GROUP BY geography;

-- Gender
SELECT
	gender,
    COUNT(customerId) AS quantityOfCustomers
FROM churn
GROUP BY gender;

-- Age
SELECT
	age,
    COUNT(customerId) AS quantityOfCustomers
FROM churn
GROUP BY age;

-- Tenure
SELECT
	tenure,
    COUNT(customerId) AS quantityOfCustomers
FROM churn
GROUP BY tenure;

-- Number of products
SELECT
	numofproducts,
    COUNT(customerId) AS quantityOfCustomers
FROM churn
GROUP BY numofproducts;

-- Has credit card
SELECT 
    IF(hascrcard = 1, 'Yes', 'No') AS hascrCard,
    COUNT(customerId) AS quantityOfCustomers
FROM churn
GROUP BY hascrCard;

-- Is active member
SELECT 
    IF(isactivemember = 1, 'Yes', 'No') AS isactivemember,
    COUNT(customerId) AS quantityOfCustomers
FROM churn
GROUP BY isactivemember;

-- Exited
SELECT 
    IF(exited = 1, 'Yes', 'No') AS exited,
    COUNT(customerId) AS quantityOfCustomers
FROM churn
GROUP BY exited;


/*
--| Data distribution |--*/	

/*-- Data range --*/
-- Credit score
SELECT
	MIN(creditscore) AS minCreditScore,
    MAX(creditscore) AS maxCreditScore,
    MAX(creditscore) - MIN(creditscore) AS differenceCreditscore,
    ROUND(AVG(creditscore), 2) AS averageCreditScore
FROM churn;

-- Age
SELECT
	MIN(age) AS minAge,
    MAX(age) AS maxAge,
    MAX(age) - MIN(age) AS differenceAge,
    FLOOR(AVG(age)) As averageAge
FROM churn;

-- Tenure
SELECT
	MIN(tenure) AS minTenure,
    MAX(tenure) AS maxTenure,
    MAX(tenure) - MIN(tenure) AS differenceTenure,
    FLOOR(AVG(tenure)) As averageTenure
FROM churn;

-- Balance
SELECT
	MIN(balance) AS minBalance,
    MAX(balance) AS maxBalance,
    MAX(balance) - MIN(balance) AS differenceBalance,
    ROUND(AVG(balance), 2) As averageBalance
FROM churn;

-- Number of products
SELECT
	MIN(numofproducts) AS minNumOfProducts,
    MAX(numofproducts) AS maxNumOfProducts,
    MAX(NumOfProducts) - MIN(NumOfProducts) AS differenceProducts,
    CEIL(AVG(numofproducts)) As averageNumberOfProducts
FROM churn;

-- Estimated Salary per year
SELECT
	MIN(estimatedsalary) AS minEstimatedSalary,
    MAX(estimatedsalary) AS maxEstimatedSalary,
    ROUND(MAX(EstimatedSalary) - MIN(EstimatedSalary),2) AS differenceSalary,
    ROUND(AVG(estimatedsalary), 2) AS averageEstimatedSalary
FROM churn;


/*-- Histograms and Frequency Distributions --*/

-- Credit score
SELECT
    FLOOR(creditScore / 10) * 10 AS creditScoreRange,
    COUNT(*) AS frequency
FROM
    churn
GROUP BY creditScoreRange
ORDER BY creditScoreRange;

-- Age
SELECT
    FLOOR(age / 10) * 10 AS ageRange,
    COUNT(*) AS frequency
FROM
    churn
GROUP BY ageRange
ORDER BY ageRange;

-- Tenure
SELECT
    FLOOR(tenure / 2) * 2 AS tenureRange,
    COUNT(*) AS frequency
FROM
    churn
GROUP BY tenureRange;

-- Balance
SELECT
    FLOOR(balance / 2500) * 2500 AS balanceRange,
    COUNT(*) AS frequency
FROM
    churn
GROUP BY balanceRange
ORDER BY balancerange;

-- Number of products
SELECT
    FLOOR(numOfProducts / 2) * 2 AS numberOfProductsRange,
    COUNT(*) AS frequency
FROM
    churn
GROUP BY numberOfProductsRange;

-- Estimated salary
SELECT
    FLOOR(estimatedSalary / 20000) * 20000 AS estimatedSalaryRange,
    COUNT(*) AS frequency
FROM
    churn
GROUP BY estimatedSalaryRange
ORDER by estimatedSalaryRange;

/*
-----||| END - Understanding the Dataset |||-----
*/

-- ------------------------------------------------------------------------

/*
-----||| Data Cleaning |||-----
*/

/*--| Handling missing values |--*/
SELECT
	COUNT(*) AS missingValues
FROM churn
WHERE NULL IN (customerid, creditscore, geography, gender, age, tenure, balance, numofproducts, hascrcard, isactivemember, estimatedsalary, exited);

/*--| Removing duplicates |--*/
SELECT
	customerId
FROM churn
GROUP BY customerId
HAVING COUNT(*) > 1; -- We don't have duplicate customer

/*--| Checking for possible outliers or unrealistic values in numerical variables |--*/
-- Age
WITH age_cte AS (
	SELECT
		DISTINCT age
	FROM churn
	WHERE
		ABS(age - (SELECT AVG(age) FROM churn)) > (SELECT 2 * STDDEV(age) FROM churn)
)
SELECT
	DISTINCT age
FROM age_cte
ORDER BY age; -- Based on this and the age frequency in line 180, 90s and 80 years is a good outlier to remove

DELETE FROM churn
WHERE age BETWEEN 80 AND 99;


-- Balance
SELECT -- To identify which is outlier
	DISTINCT balance
FROM churn
WHERE ABS(balance - (SELECT AVG(balance) FROM churn)) > (SELECT 2 * STDDEV(balance) FROM churn)
ORDER BY balance; 
    
WITH balance_cte AS (
	SELECT
		DISTINCT balance
	FROM churn
	WHERE ABS(balance - (SELECT AVG(balance) FROM churn)) > (SELECT 2 * STDDEV(balance) FROM churn)
	ORDER BY balance
)
DELETE FROM churn
WHERE balance IN (SELECT balance FROM balance_cte);

-- Credit score
SELECT -- To identify which is outlier
	DISTINCT creditScore
FROM churn
WHERE ABS(creditScore - (SELECT AVG(creditScore) FROM churn)) > (SELECT 2 * STDDEV(creditScore) FROM churn)
ORDER BY creditScore; -- Important number of data to analyze, so we will not remove

-- Estimated salary
SELECT 
	estimatedSalary
FROM churn
WHERE
	ABS(estimatedSalary - (SELECT AVG(estimatedSalary) FROM churn)) > (SELECT 2 * STDDEV(estimatedSalary) FROM churn); -- Important number of data to analyze, so we will not remove

-- Number of products
SELECT -- To identify which is outlier
	DISTINCT NumOfProducts
FROM churn
WHERE ABS(NumOfProducts - (SELECT AVG(NumOfProducts) FROM churn)) > (SELECT 2 * STDDEV(NumOfProducts) FROM churn)
ORDER BY NumOfProducts; -- Important number of data to analyze, so we will not remove

-- Tenure
SELECT -- To identify which is outlier
	DISTINCT Tenure
FROM churn
WHERE ABS(Tenure - (SELECT AVG(Tenure) FROM churn)) > (SELECT 2 * STDDEV(Tenure) FROM churn)
ORDER BY Tenure; -- Important number of data to analyze, so we will not remove
















 







