Create DATABASE WalmartSalesData;
USE WalmartSalesData;
CREATE TABLE sales(
invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
branch VARCHAR(5) NOT NULL,
city VARCHAR(30) NOT NULL,
custm_type VARCHAR(30) NOT NULL,
gender VARCHAR(10) NOT NULL,
prod_line VARCHAR(100) NOT NULL,
unit_price DECIMAL(10,2) NOT NULL,
quantity INT NOT NULL,
tax DECIMAL(8, 4) NOT NULL,
total DECIMAL(10,4) NOT NULL, 
tran_date DATETIME NOT NULL,
tran_time TIME NOT NULL,
pay_method VARCHAR(20) NOT NULL,
cogs DECIMAL(10,2) NOT NULL,
margin_pc DECIMAL (11,9) NOT NULL,
gross_inc DECIMAL(12,4),
rating FLOAT(2,1)
);

-- ---------------------------------------------------------------------Feature Engineering-----------------------------------------------------------------------------------
-- Time of the day
SELECT tran_time,
(CASE
	WHEN tran_time BETWEEN '00:00:00' AND '11:59:59' THEN 'Morning'
	WHEN tran_time BETWEEN '12:00:00' AND '15:59:59' THEN 'Afternoon'
	ELSE 'Evening'
END)
AS time_of_day
FROM sales;
ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);
UPDATE sales SET time_of_day=(CASE
	WHEN tran_time BETWEEN '00:00:00' AND '11:59:59' THEN 'Morning'
	WHEN tran_time BETWEEN '12:00:00' AND '15:59:59' THEN 'Afternoon'
	ELSE 'Evening'
END);

-- Name of the day
SELECT tran_date,
DAYNAME(tran_date)
FROM sales;
ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);
UPDATE sales SET day_name=(DAYNAME(tran_date));

-- Name of the month

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);
UPDATE sales SET month_name=MONTHNAME(tran_date);

-- -----------------------------------------------------------------------Answering Business Questions--------------------------------------------------------------------------
-- How many distinct cities?
SELECT DISTINCT city FROM sales;

-- In which city is each branch located?
SELECT branch, city FROM sales;

-- How many unique product lines of the company?
SELECT COUNT(DISTINCT prod_line) FROM sales;

-- Which is the most common payment method?
SELECT pay_method, COUNT(pay_method ) AS cnt 
FROM sales
GROUP BY pay_method
ORDER BY cnt DESC
LIMIT 1;

-- Which is the most selling product line?
SELECT prod_line, COUNT(quantity) AS total_sales
FROM sales
GROUP BY prod_line 
ORDER BY total_sales DESC
LIMIT 1;

-- What is the total revenue by month?
SELECT month_name, SUM(total) AS total_revenue
FROM SALES
GROUP BY month_name
ORDER BY total_revenue DESC;

-- Which month had the largest COGS?
SELECT month_name, SUM(cogs) AS total_cogs
FROM SALES
GROUP BY month_name
ORDER BY total_cogs DESC
LIMIT 1;

-- Which product line had the largest revenue?
SELECT prod_line, SUM(total) AS total_revenue
FROM SALES
GROUP BY prod_line
ORDER BY total_revenue DESC
LIMIT 1;
-- Alternate Way
SELECT prod_line, cwr
FROM (
	SELECT prod_line, SUM(total) AS cwr
    FROM sales
    GROUP BY prod_line
    ) AS city_totals
WHERE cwr=(
		SELECT MAX(cwr)
        FROM(
			SELECT SUM(total) AS cwr
            FROM sales
            GROUP BY prod_line) AS max_cwr
		);
-- Which is the one city with the largest revenue?
SELECT city, SUM(total) AS cwr
FROM sales
GROUP BY city
ORDER BY cwr DESC
LIMIT 1;

-- Which product line had the largest VAT?
SELECT prod_line, SUM(tax) total_vat
FROM sales 
GROUP BY prod_line 
ORDER BY total_vat DESC
LIMIT 1;

-- Fetch each product line and add a column to all the product lines, showing "Good", "Bad" (Good if its greater than average sales).

WITH overall_avg AS(
SELECT AVG(quantity) AS avg_quantity
FROM sales)
SELECT prod_line,
	CASE
		WHEN AVG(quantity)>(SELECT avg_quantity FROM overall_avg) THEN 'Good'
		ELSE 'Bad'
	END AS Remark
FROM sales
GROUP BY prod_line;

-- Which branch sold more products than average product sold?
SELECT branch, SUM(quantity) AS qty
FROM sales
GROUP BY branch
HAVING qty> (SELECT AVG(quantity) FROM SALES);

-- Which is the most common product line by gender?
SELECT gender, prod_line, COUNT(gender) as cnt
FROM sales
GROUP BY gender, prod_line
ORDER BY cnt DESC;

-- What is the average rating of each product line?
SELECT prod_line, ROUND(AVG(rating), 2) 
FROM sales
GROUP BY prod_line
ORDER BY AVG(rating) DESC;

-- Number of sales made in each time of the day per weekday
SELECT day_name, time_of_day, COUNT(quantity) AS qty
FROM sales
GROUP BY day_name, time_of_day
ORDER BY qty DESC;

-- Which of the customer types brings the most revenue?
SELECT custm_type, SUM(total) as tot
FROM sales
GROUP BY custm_type
ORDER BY tot DESC
LIMIT 1;

-- Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT city, AVG(tax) AS avg_vat
FROM sales
GROUP BY city
ORDER BY avg_vat DESC
LIMIT 1;

-- Which customer type pays the most in VAT?
SELECT custm_type, SUM(tax) as total_vat
FROM sales
GROUP BY custm_type
ORDER BY total_vat DESC
LIMIT 1;

-- How many unique customer types does the data have?
SELECT COUNT(DISTINCT custm_type) AS number_of_unique_customer_types FROM sales;

-- How many unique payment methods does the data have?
SELECT COUNT(DISTINCT pay_method) FROM sales;

-- Which is the most common customer type? OR Which customer type buys the most?
SELECT custm_type, COUNT(custm_type) num
FROM sales
GROUP BY custm_type
ORDER BY num DESC
LIMIT 1;

-- What is the gender of most of the customers?
SELECT gender, COUNT(gender) AS gender_count
FROM sales
GROUP BY gender
ORDER BY gender_count DESC
LIMIT 1;

-- What is the gender distribution per branch?
SELECT branch, gender, COUNT(gender) AS gender_count
FROM sales
GROUP BY branch, gender
ORDER BY branch ;

-- During which time of the day do customers give best ratings?
SELECT time_of_day, AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC
LIMIT 1;

-- Which time of the day do customers give best ratings per branch?
SELECT branch, time_of_day, AVG(rating) AS avg_rating
FROM sales
GROUP BY branch, time_of_day
ORDER BY avg_rating DESC
;

-- Which day oF the week has best avg rating?
SELECT day_name, AVG(rating) avg_rating
FROM sales
GROUP BY day_name
ORDER BY avg_rating DESC
LIMIT 1;

-- Which day of the week has the best average rating per branch?
SELECT branch, day_name, AVG(rating) avg_rating
FROM sales
GROUP BY branch, day_name
ORDER BY avg_rating DESC
;