DROP TABLE IF EXISTS zepto;

--CREATE TABLE zepto

CREATE TABLE zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discount_percentage NUMERIC (5,2),
availability_quantity INTEGER,
discounted_selling_price NUMERIC(8,2),
weight_inGms INTEGER,
out_of_stock BOOLEAN,
quantity INTEGER
);
--CHECK IF IMPORTED OR NOT 
SELECT * FROM zepto;
--CHECKING FOR NULL VALUES
SELECT * FROM zepto
WHERE category IS NULL
OR
name IS NULL
OR
mrp IS NULL
OR
discount_percentage IS NULL
OR
availability_quantity IS NULL
OR
discounted_selling_price IS NULL
OR
weight_inGms IS NULL
OR
out_of_stock IS NULL
OR 
quantity IS NULL;

--DIFFERENT PRODUCT CATEGORIES
SELECT DISTINCT category 
FROM zepto ORDER BY category;

--PRODUCTS IN STOCK OR OUT OF STOCK
 SELECT out_of_stock,COUNT(sku_id)
 FROM zepto
 GROUP BY out_of_stock;

--PRODUCT NAMES PRESENT MULTIPLE TIMES
SELECT name,COUNT(sku_id)
FROM zepto
GROUP BY name
HAVING COUNT(sku_id)>1
ORDER BY COUNT(sku_id) DESC;

--DATA CLEANING

--PRODUCTS WITH PRICE IS ZERO
SELECT * FROM zepto
WHERE mrp = 0 OR discounted_selling_price = 0;

--DELETE THIS ZERO ROW
DELETE FROM zepto 
WHERE mrp= 0;

--COVERT THE mrp FROM PAISE TO RUPEES

UPDATE zepto
SET mrp = mrp/100.00,
discounted_selling_price = discounted_selling_price/100.00; 
SELECT * FROM zepto;

--BUSINESS INSIGHTS QUESTIONS

--Q1)FIND THE TOP 10 BEST-VALUE PRODUCTS BASED ON THE DISCOUNTED PERCENTAGE?
SELECT DISTINCT name,mrp,discount_percentage
FROM zepto
ORDER BY discount_percentage DESC LIMIT 10;

--Q2)WHAT ARE THE PRODUCTS WITH HIGH MRP BUT OUT OF STOCK?
SELECT DISTINCT name ,mrp,out_of_stock FROM zepto
WHERE out_of_stock= 'TRUE'
ORDER BY mrp DESC;

--Q3)CALCULATE ESTIMATED REVENUE FOR EACH CATEGORY?
SELECT category,
SUM(discounted_selling_price*availability_quantity) AS total_revenue_by_category
FROM zepto
GROUP BY category
ORDER BY total_revenue_by_category DESC;
 
--Q4)FIND ALL PRODUCTS WHERE MRP IS GREATER THAN RS 500 AND DISCOUNT IS LESS THAN 10%?
SELECT DISTINCT name,mrp,discount_percentage
FROM zepto
WHERE mrp > 500 AND discount_percentage < 10
ORDER BY mrp DESC,discount_percentage DESC;

--Q5)IDENTIFY THE TOP 5 CATEGORIES OFERING THE HIGHEST AVERAGE DISCOUNT PERCENTAGE?
SELECT DISTINCT category,ROUND(AVG(discount_percentage),2) AS average_discount_percentage
FROM zepto
GROUP BY category
ORDER BY average_discount_percentage DESC LIMIT 5;

SELECT * FROM zepto;

--Q6)FIND THE PRICE PER GRAMM FOR PRODUCT ABOVE 100G AND SORT BY BEST VALUE?
SELECT DISTINCT name,weight_inGms,discounted_selling_price,
ROUND(discounted_selling_price/weight_inGms,2) AS price_per_gram
FROM zepto
WHERE weight_inGms>=100
ORDER BY price_per_gram;

--Q7)GROUP THE PRODUCTS INTO CATEGORIES LIKE LOW,MEDIUM,BULK?
SELECT DISTINCT name,weight_inGms,
CASE WHEN weight_inGms < 1000 THEN 'LOW'
	 WHEN weight_inGms < 5000 THEN 'MEDIUM'
	 ELSE 'BULK'
	 END AS weight_category
FROM zepto;	 

--Q8)WHAT IS THE TOTAL INVENTORY WEIGHT PER CATEGORY?
SELECT category,
SUM(weight_inGms*availability_quantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;