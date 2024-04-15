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
    ROUND(AVG(creditscore), 2) AS averageCreditScore,
    (
		SELECT
			ROUND(AVG(creditscore), 2)
		FROM (
			SELECT
				@rowindex := @rowindex + 1 AS rowindex,
				churn.creditscore AS creditscore
			FROM
				churn,
				(SELECT @rowindex := -1) AS init
			ORDER BY churn.creditscore
		) AS n
		WHERE n.rowindex IN (FLOOR(@rowindex / 2), CEIL(@rowindex / 2))
    ) AS median
FROM churn;

-- Age
SELECT
	MIN(age) AS minAge,
    MAX(age) AS maxAge,
    MAX(age) - MIN(age) AS differenceAge,
    FLOOR(AVG(age)) As averageAge,
    (
		SELECT
			ROUND(AVG(age), 2)
		FROM (
			SELECT
				@rowindex := @rowindex + 1 AS rowindex,
				churn.age AS age
			FROM
				churn,
				(SELECT @rowindex := -1) AS init
		ORDER BY churn.age
		) AS n
		WHERE n.rowindex IN (FLOOR(@rowindex / 2), CEIL(@rowindex / 2))
    ) AS median
FROM churn;


-- Tenure
SELECT
	MIN(tenure) AS minTenure,
    MAX(tenure) AS maxTenure,
    MAX(tenure) - MIN(tenure) AS differenceTenure,
    FLOOR(AVG(tenure)) As averageTenure,
    (
		SELECT
			ROUND(AVG(tenure), 2)
		FROM (
			SELECT
				@rowindex := @rowindex + 1 AS rowindex,
				churn.tenure AS tenure
			FROM
				churn,
				(SELECT @rowindex := -1) AS init
		ORDER BY churn.tenure
		) AS n
		WHERE n.rowindex IN (FLOOR(@rowindex / 2), CEIL(@rowindex / 2))
    ) AS median
FROM churn;

-- Balance
SELECT
	MIN(balance) AS minBalance,
    MAX(balance) AS maxBalance,
    MAX(balance) - MIN(balance) AS differenceBalance,
    ROUND(AVG(balance), 2) As averageBalance,
    (
		SELECT
			ROUND(AVG(balance), 2)
		FROM (
			SELECT
				@rowindex := @rowindex + 1 AS rowindex,
				churn.balance AS balance
			FROM
				churn,
				(SELECT @rowindex := -1) AS init
		ORDER BY churn.balance
		) AS n
		WHERE n.rowindex IN (FLOOR(@rowindex / 2), CEIL(@rowindex / 2))
    ) AS median
FROM churn;

-- Number of products
SELECT
	MIN(numofproducts) AS minNumOfProducts,
    MAX(numofproducts) AS maxNumOfProducts,
    MAX(NumOfProducts) - MIN(NumOfProducts) AS differenceProducts,
    CEIL(AVG(numofproducts)) As averageNumberOfProducts,
    (
		SELECT
			ROUND(AVG(numofproducts), 2)
		FROM (
			SELECT
				@rowindex := @rowindex + 1 AS rowindex,
				churn.numofproducts AS numofproducts
			FROM
				churn,
				(SELECT @rowindex := -1) AS init
		ORDER BY churn.numofproducts
		) AS n
		WHERE n.rowindex IN (FLOOR(@rowindex / 2), CEIL(@rowindex / 2))
    ) AS median
FROM churn;

-- Estimated Salary per year
SELECT
	MIN(estimatedsalary) AS minEstimatedSalary,
    MAX(estimatedsalary) AS maxEstimatedSalary,
    ROUND(MAX(EstimatedSalary) - MIN(EstimatedSalary),2) AS differenceSalary,
    ROUND(AVG(estimatedsalary), 2) AS averageEstimatedSalary,
    (
		SELECT
			ROUND(AVG(estimatedsalary), 2)
		FROM (
			SELECT
				@rowindex := @rowindex + 1 AS rowindex,
				churn.estimatedsalary AS estimatedsalary
			FROM
				churn,
				(SELECT @rowindex := -1) AS init
		ORDER BY churn.estimatedsalary
		) AS n
		WHERE n.rowindex IN (FLOOR(@rowindex / 2), CEIL(@rowindex / 2))
    ) AS median
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

/*
-----||| END - Data Cleaning |||-----
*/

-- ------------------------------------------------------------------------

/*
-----||| Business Questions |||-----
*/


/*
-----| Analysis list |-----
1 - Customer Demographics
2 - Customer Behavior
3 - Financial Details
4 - Product Utilization
*/

-- | Customer Demographics | --

-- 1 - What is the age distribution among the customers who exited the bank?
SELECT -- First we will identify the minimum age, the maximum age and quantity of the customers who churned
	MIN(age) AS minAge,
    MAX(age) AS maxAge,
    COUNT(*) AS quantityOfCustomers
FROM churn
WHERE exited = 1;

-- Answer to the question
WITH number_cte AS (
    SELECT
        MIN(age) AS minAge,
        MAX(age) AS maxAge,
        CEIL((MAX(age) - MIN(age)) / 4) AS number
    FROM churn
    WHERE exited = 1
)
SELECT
    SUM(CASE WHEN c.age BETWEEN minAge AND minAge + number THEN 1 ELSE 0 END) AS `18to32`,
    SUM(CASE WHEN c.age BETWEEN minAge + number + 1 AND minAge + number * 2 + 1 THEN 1 ELSE 0 END) AS `33to47`,
    SUM(CASE WHEN c.age BETWEEN minAge + number * 2 + 2 AND minAge + number * 3 + 2 THEN 1 ELSE 0 END) AS `48to62`,
    SUM(CASE WHEN c.age BETWEEN minAge + number * 3 + 3 AND maxAge THEN 1 ELSE 0 END) AS `63to74`
FROM
	churn c,
	number_cte n
WHERE exited = 1;


-- 2 - How does the gender factor affect the churn rate? This won´t be answered with SQL, but it will give some resources to think
-- Quantity and rate of churn by gender
SELECT
	gender,
    COUNT(gender) AS frequency,
    ROUND(COUNT(gender) / (SELECT COUNT(gender) FROM churn WHERE exited = 1) * 100) AS rateInPercentage
FROM churn
WHERE exited = 1
GROUP BY gender;

-- Quantity and rate of churn by gender per country
SELECT
	Geography,
    gender,
    COUNT(gender) AS frequency,
    ROUND(COUNT(gender) / (SELECT COUNT(gender) FROM churn WHERE exited = 1) * 100) AS rateInPercentage
FROM churn
WHERE exited = 1
GROUP BY Geography, gender
ORDER BY Geography;

-- Quantity and rate of a specified country
SELECT
	geography,
    gender,
    COUNT(gender) AS frequency,
    ROUND(COUNT(gender) / (SELECT COUNT(gender) FROM churn WHERE exited = 1 AND geography = 'Germany') * 100) AS rateInPercentage -- (Same as  in WHERE)
FROM churn c
WHERE exited = 1 AND Geography = 'Germany' -- Just change this if you want different country, there are (France, Germany and Spain)
GROUP BY gender;


-- 3 - What geographical location has the highest churn rate?
SELECT
	geography,
    COUNT(*) AS frequency,
    ROUND(COUNT(customerId) / (SELECT COUNT(customerId) FROM churn WHERE exited = 1) * 100, 2) AS rateInPercentageFromTotalOfChurn
FROM churn
WHERE exited = 1
GROUP BY geography
ORDER BY frequency DESC;



-- | Customer Behavior | --

-- 4 - Who are more likely to churn - customers with a credit card or without?
-- For those who churned
SELECT
	IF(hascrcard = 1, 'With Credit Card', 'Without Credit Card') AS creditCard,
    COUNT(customerId) AS frequency,
    ROUND(COUNT(customerId) / (SELECT COUNT(customerId) FROM churn WHERE exited = 1) * 100, 2) AS churnRate
FROM churn
WHERE exited = 1
GROUP BY hascrcard;

-- General
SELECT
	IF(hascrcard = 1, 'With Credit Card', 'Without Credit Card') AS creditCard,
    COUNT(customerId) AS totalCustomers,
    SUM(exited) AS churnedCustomers,
    ROUND(SUM(exited) / COUNT(customerId) * 100, 2) AS churnRate
FROM churn
GROUP BY creditCard;


-- 5 - Does the customer's activity level (IsActiveMember) correlate with the churn rate?
-- For those who churned
SELECT
	IF(isActiveMember = 1, 'Active Member', 'No Active Member') AS isActiveMember,
    COUNT(customerId) AS churnedCustomers,
    ROUND(COUNT(customerId) / (SELECT COUNT(customerId) FROM churn WHERE exited = 1) * 100, 2) AS churnRate
FROM churn
WHERE exited = 1
GROUP BY IsActiveMember;

-- General
SELECT
    IF(isActiveMember = 1, 'Active Member', 'No Active Member') AS isActiveMember,
    COUNT(customerId) AS totalCustomers,
    SUM(exited) AS churnedCustomers,
    ROUND(SUM(exited) / COUNT(customerId) * 100,2) AS churnRate
FROM churn
GROUP BY IsActiveMember;


-- 6 - What is the tenure distribution among customers who churned?
SELECT
    FLOOR(tenure / 2) * 2 AS tenureRange,
    COUNT(customerId) AS totalCustomers,
    SUM(exited) AS churnedCustomers,
    ROUND(SUM(exited) / COUNT(customerId) * 100,2) AS churnRate
FROM
    churn
GROUP BY tenureRange
ORDER BY churnedCustomers DESC;


-- 7 - How does having multiple products/services associate with the churn rate?
SELECT
	numofproducts,
    COUNT(customerId) AS totalCustomers,
    SUM(exited) AS churnedCustomers,
    ROUND(SUM(exited) / COUNT(customerId) * 100,2) AS churnRate
FROM churn
GROUP BY numofproducts
ORDER BY churnedCustomers DESC;


-- | Financial Details | --

-- 8 - Is there any relationship between the balance in the bank account and the churn rate?
SELECT
    FLOOR(balance / 30000) * 30000 AS balanceRange,
    COUNT(*) AS totalCustomers,
    SUM(exited) AS churnedCustomers,
    ROUND(SUM(exited) / COUNT(*) * 100, 2) AS churnRate
FROM churn
GROUP BY balanceRange
ORDER BY balanceRange;


-- 9 - Does a customer’s Credit Score affect their likelihood to churn?
SELECT
    FLOOR(creditScore / 50) * 50 AS creditScoreRange,
    COUNT(*) AS totalCustomers,
    SUM(exited) AS churnedCustomers,
    ROUND(SUM(exited) / COUNT(*) * 100, 2) AS churnRate
FROM churn
GROUP BY creditScoreRange
ORDER BY creditScoreRange;


-- 10 - Does estimated salary have any impact on the churn rate?

-- Those who churned
SELECT
    CASE
        WHEN estimatedSalary < 50000 THEN 'Low Salary'
        WHEN estimatedSalary >= 50000 AND estimatedSalary < 100000 THEN 'Medium Salary'
        ELSE 'High Salary'
    END AS salaryRange,
    COUNT(*) AS churnedCustomers,
    ROUND(COUNT(customerId) / (SELECT COUNT(customerId) FROM churn WHERE exited = 1) * 100, 2) AS churnRate
FROM churn
WHERE exited = 1
GROUP BY salaryRange
ORDER BY salaryRange;

-- General
SELECT
    CASE
        WHEN estimatedSalary < 50000 THEN 'Low Salary'
        WHEN estimatedSalary >= 50000 AND estimatedSalary < 100000 THEN 'Medium Salary'
        ELSE 'High Salary'
    END AS salaryRange,
    SUM(exited) AS churnedCustomers,
    COUNT(*) AS totalCustomers,
    ROUND(SUM(exited) / COUNT(*) * 100, 2) AS churnRate
FROM churn
GROUP BY salaryRange
ORDER BY salaryRange;


-- | Product Utilization | --

-- 11 - Are customers using multiple bank's products/services more likely to stay with the bank?
SELECT
    SUM(IF(numofproducts <= 1, 1, 0)) AS lessOrEqual1,
    SUM(IF(numofproducts > 1, 1, 0)) AS greaterThan1,
    ROUND((SUM(IF(numofproducts <= 1, 1, 0)) / (SELECT COUNT(*) FROM churn WHERE exited = 1)) * 100, 2) AS churnRateLessOrEqual1,
    ROUND((SUM(IF(numofproducts > 1, 1, 0)) / (SELECT COUNT(*) FROM churn WHERE exited = 1)) * 100, 2) AS churnRateGreaterThan1
FROM
    churn
WHERE exited = 1;


-- 12 - How does customers' engagement with different bank’s products/services change over their tenure?
-- For those who churned
SELECT
	tenure,
    SUM(numofproducts) AS numberOfProductsTernure,
    CEIL(AVG(NumOfProducts)) AS avgNumberOfProductsPerCustomer
FROM churn
WHERE exited = 1
GROUP BY tenure
ORDER BY tenure;

-- Didn't churn
SELECT
	tenure,
    SUM(numofproducts) AS numberOfProductsTernure,
    CEIL(AVG(NumOfProducts)) AS avgNumberOfProductsPerCustomer
FROM churn
WHERE exited = 0
GROUP BY tenure
ORDER BY tenure;

-- 13 - What is the cost impact of churn?
-- Loss at the moment of the churn
SELECT
	CEIL(SUM(balance)) AS loss
FROM churn
WHERE exited = 1;

-- Loss within 12 months
SELECT
	CEIL(SUM(balance)) + CEIL(SUM(estimatedSalary) * 12) AS lossWithin12months
FROM churn
WHERE exited = 1;



























 







