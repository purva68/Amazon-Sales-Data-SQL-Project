-- Create Schema
Create Database amazon_sales_data; 

Use amazon_sales_data;

-- Create Table
CREATE TABLE amazon (
     invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
     branch VARCHAR(5) NOT NULL, 
     city VARCHAR(30) NOT NULL,
     customer_type VARCHAR(30) NOT NULL,
     gender VARCHAR(10) NOT NULL,
     product_line VARCHAR(100) NOT NULL, 
     unit_price DECIMAL(10, 2) NOT NULL,
     quantity INT NOT NULL, 
     vat FLOAT(6, 4) NOT NULL,
     total DECIMAL(10, 2) NOT NULL,
     date date NOT NULL, 
     time time NOT NULL, 
     payment_method VARCHAR(15) NOT NULL, 
     cogs DECIMAL(10, 2) NOT NULL, 
     gross_margin_percentage FLOAT NOT NULL, 
     gross_income DECIMAL(10, 2) NOT NULL, 
     rating float
);
SELECT * FROM amazon;

-- Feature Enginnering

-- Add time of day column into data

ALTER TABLE amazon
ADD timeofday VARCHAR(15);

SET SQL_SAFE_UPDATES = 0;
UPDATE amazon
SET timeofday = CASE
                  WHEN TIME(time) BETWEEN '00:00:00' AND '11:59:59' THEN 'Morning'
                  WHEN TIME(time) BETWEEN '12:00:00' AND '17:59:59' THEN 'Afternoon'
                  ELSE 'Evening'
				END;
                
-- Add day name column
ALTER TABLE amazon
ADD dayname VARCHAR(10);

UPDATE amazon
SET dayname = DAYNAME(date);

-- Add month name column
ALTER TABLE amazon
ADD monthname VARCHAR(10);

UPDATE amazon
SET monthname = MONTHNAME(date);


/* Bussiness Questions to answer */


-- 1.What is the count of distinct cities in the dataset? (Sales Analysis)
SELECT COUNT(DISTINCT city) AS distinct_city
FROM amazon;


-- 2.For each branch, what is the corresponding city? (Sales Analysis)
SELECT 
	branch,
	city
FROM amazon
GROUP BY branch, city
ORDER BY branch;


-- 3.What is the count of distinct product lines in the dataset? (Product Analysis)
SELECT COUNT(DISTINCT product_line) as distinct_product_line
FROM amazon;


-- 4.Which payment method occurs most frequently? (Customer Analysis)
SELECT 
	payment_method,
	COUNT(*) AS frequent_pay_method
FROM amazon
GROUP BY payment_method
ORDER BY frequent_pay_method DESC;


-- 5.Which product line has the highest sales? (Product Analysis)
SELECT 
	product_line,
	SUM(total) AS total_sales
FROM amazon
GROUP BY product_line
ORDER BY total_sales DESC;


-- 6.How much revenue is generated each month? (Sales Analysis)
SELECT 
	monthname,
	SUM(total) AS total_revenue
FROM amazon
GROUP BY monthname
ORDER BY total_revenue DESC;


-- 7.In which month did the cost of goods sold reach its peak? (Sales Analysis)
SELECT 
	monthname,
	SUM(cogs) AS total_cogs
FROM amazon
GROUP BY monthname
ORDER BY total_cogs DESC;


-- 8.Which product line generated the highest revenue? (Product Analysis)
SELECT 
	product_line,
    SUM(total) AS high_revenue
FROM amazon
GROUP BY product_line
ORDER BY high_revenue DESC;


-- 9.In which city was the highest revenue recorded? (Sales Analysis)
SELECT
	city,
	SUM(total) as high_revenue
FROM amazon
GROUP BY city
ORDER BY high_revenue DESC;


-- 10.Which product line incurred the highest Value Added Tax? (Product Analysis)
SELECT 
	product_line,
	SUM(vat) AS high_VAT
FROM amazon
GROUP BY product_line
ORDER BY high_VAT DESC;


-- 11.For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad." (Product Analysis)
SELECT *,
CASE WHEN total > avg_sales THEN "Good"
ELSE "bad"
END AS sales_performnace
FROM(
      SELECT 
         product_line,
         total,
         (SELECT ROUND(AVG(total), 2)  FROM amazon) AS avg_sales
	  FROM amazon
) AS avg_table;


-- 12.Identify the branch that exceeded the average number of products sold. (Sales Analysis)
SELECT
	branch,
	SUM(quantity) AS total_quantity
FROM amazon
GROUP BY branch
HAVING total_quantity > (SELECT AVG(quantity) FROM amazon);


-- 13.Which product line is most frequently associated with each gender? (Product Analysis)
SELECT 
	gender,
    product_line,
    COUNT(*) AS frequency
FROM amazon
GROUP BY gender, product_line
ORDER BY frequency DESC;

-- 14.Calculate the average rating for each product line. (Product Analysis)
SELECT
    product_line,
    round(AVG(rating),2) AS avg_rating
FROM amazon
GROUP BY product_line
ORDER BY avg_rating DESC;


-- 15.Count the sales occurrences for each time of day on every weekday. (Sales Analysis)
SELECT
	dayname,
    timeofday,
    COUNT(*) AS sales_occurences
FROM amazon
WHERE dayname NOT IN  ("Saturday", "Sunday")
GROUP BY timeofday, dayname
ORDER BY sales_occurences DESC;


-- 16.Identify the customer type contributing the highest revenue. (Customer Analysis)
SELECT
	customer_type,
	SUM(total) AS high_revenue
FROM amazon
GROUP BY customer_type
ORDER BY high_revenue DESC;


-- 17.Determine the city with the highest VAT percentage. (Sales Analysis)
SELECT
	city,
    ROUND(SUM(vat),2) AS high_VAT
FROM amazon
GROUP BY city
ORDER BY high_VAT DESC;


-- 18.Identify the customer type with the highest VAT payments. (Customer Analysis)
SELECT
	customer_type,
    ROUND(SUM(vat),2) AS high_vat_payments
FROM amazon
GROUP BY customer_type
ORDER BY high_vat_payments DESC;


-- 19.What is the count of distinct customer types in the dataset? (Customer Analysis)
SELECT
	COUNT(DISTINCT customer_type) AS distinct_customer_type
FROM amazon;


-- 20.What is the count of distinct payment methods in the dataset? (Customer Analysis)
SELECT
	COUNT(DISTINCT payment_method) AS distinct_payment_methods
FROM amazon;


-- 21.Which customer type occurs most frequently? (Customer Analysis)
SELECT
	customer_type,
	COUNT(*) AS frequent_customer_type
FROM amazon
GROUP BY customer_type
ORDER BY frequent_customer_type DESC;


-- 22.Identify the customer type with the highest purchase frequency. (Customer Analysis)
SELECT
	customer_type,
	COUNT(*) AS high_purchase_frequency
FROM amazon
GROUP BY customer_type
ORDER BY high_purchase_frequency DESC;


-- 23.Determine the predominant gender among customers. (Customer Analysis)
SELECT
	gender,
	COUNT(*) AS predominant_gender
FROM amazon
GROUP BY gender
ORDER BY predominant_gender DESC;


-- 24.Examine the distribution of genders within each branch. (Customer Analysis)
SELECT
	branch,
	gender,
	count(gender) AS dist_gender
FROM amazon
GROUP BY branch, gender
ORDER BY  branch, dist_gender DESC;


-- 25.Identify the time of day when customers provide the most ratings. (Sales Analysis)
SELECT
	timeofday,
    COUNT(rating) AS rating_count
FROM amazon
GROUP BY timeofday
ORDER BY rating_count DESC;

-- 26.Determine the time of day with the highest customer ratings for each branch. (Sales Analysis)
SELECT
    branch,
	timeofday,
    MAX(rating) AS high_rating
FROM amazon
GROUP BY branch, timeofday
ORDER BY branch,high_rating DESC;


-- 27.Identify the day of the week with the highest average ratings. (Sales Analysis)
SELECT 
	dayname,
    ROUND(AVG(rating),2) AS avg_rating
FROM amazon
GROUP BY dayname
ORDER BY avg_rating DESC;


-- 28.Determine the day of the week with the highest average ratings for each branch. (Sales Analysis)
SELECT 
    branch,
	dayname,
    ROUND(AVG(rating),2) AS avg_rating
FROM amazon
GROUP BY branch, dayname
ORDER BY branch, avg_rating DESC;






























