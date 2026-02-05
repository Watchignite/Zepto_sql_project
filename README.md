# 🛒 Zepto Product Data Analysis using SQL
![image](https://github.com/Watchignite/Zepto_sql_project/blob/main/Zepto_logo.jpg)

This is a complete, real-world data analyst portfolio project based on an e-commerce inventory dataset scraped from [@Zepto](https://www.zepto.com/?srsltid=AfmBOoqtqUJPtLGpA8kd0s-6IVJB_Kh3MEyVsxf_J3D3W8HD-9WBEOiA)
 — one of India’s fastest-growing quick-commerce startups. This project simulates real analyst workflows, from raw data exploration to business-focused data analysis.

This project is perfect for:

✔️📊 Data Analyst aspirants who want to build a strong Portfolio Project for interviews and LinkedIn <br>
✔️📚 Anyone learning SQL hands-on <br>
✔️💼 Preparing for interviews in retail, e-commerce, or product analytics
## 📌 Project Overview
The goal is to simulate how actual data analysts in the e-commerce or retail industries work behind the scenes to use SQL to:

✅ Set up a messy, real-world e-commerce inventory database

✅ Perform Exploratory Data Analysis (EDA) to explore product categories, availability, and pricing inconsistencies

✅ Implement Data Cleaning to handle null values, remove invalid entries, and convert pricing from paise to rupees

✅ Write business-driven SQL queries to derive insights around pricing, inventory, stock availability, revenue and more
## 📁 Dataset Overview
The dataset was sourced from[@Kaggle](https://www.kaggle.com/) and was originally scraped from Zepto’s official product listings. It mimics what you’d typically encounter in a real-world e-commerce inventory system.

Each row represents a unique SKU (Stock Keeping Unit) for a product. Duplicate product names exist because the same product may appear multiple times in different package sizes, weights, discounts, or categories to improve visibility – exactly how real catalog data looks.

🧾 Columns:

● sku_id: Unique identifier for each product entry (Synthetic Primary Key)

● name: Product name as it appears on the app

● category: Product category like Fruits, Snacks, Beverages, etc.

● mrp: Maximum Retail Price (originally in paise, converted to ₹)

● discountPercent: Discount applied on MRP

● discountedSellingPrice: Final price after discount (also converted to ₹)

● availableQuantity: Units available in inventory

● weightInGms: Product weight in grams

● outOfStock: Boolean flag indicating stock availability

quantity: Number of units per package (mixed with grams for loose produce)
## 🔧 Project Workflow
Here’s a step-by-step breakdown of what we do in this project:
### Database & Table Creation
We start by creating a SQL table with appropriate data types:
```sql
CREATE TABLE zepto (
  sku_id SERIAL PRIMARY KEY,
  category VARCHAR(120),
  name VARCHAR(150) NOT NULL,
  mrp NUMERIC(8,2),
  discountPercent NUMERIC(5,2),
  availableQuantity INTEGER,
  discountedSellingPrice NUMERIC(8,2),
  weightInGms INTEGER,
  outOfStock BOOLEAN,
  quantity INTEGER
);
```
### Data Import
● Loaded CSV using pgAdmin's import feature.
● If you're not able to use the import feature, write this code instead:
```sql
   \copy zepto(category,name,mrp,discountPercent,availableQuantity,
            discountedSellingPrice,weightInGms,outOfStock,quantity)
  FROM 'data/zepto_v2.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', QUOTE '"', ENCODING 'UTF8');
```
● Faced encoding issues (UTF-8 error), which were fixed by saving the CSV file using CSV UTF-8 format.

## 🔍 Data Cleaning Steps
### ✔️ Check for NULL values
```sql
SELECT * FROM zepto
WHERE category IS NULL
OR name IS NULL
OR mrp IS NULL
OR discount_percentage IS NULL
OR availability_quantity IS NULL
OR discounted_selling_price IS NULL
OR weight_inGms IS NULL
OR out_of_stock IS NULL
OR quantity IS NULL;
```
### ✔️ Identify products with zero prices
```sql
SELECT * FROM zepto
WHERE mrp = 0 OR discounted_selling_price = 0;
```
### ✔️ Remove invalid zero-price rows
```sql
DELETE FROM zepto WHERE mrp = 0;
```
### ✔️ Convert MRP & Selling Price from Paise → Rupees
```sql
UPDATE zepto
SET mrp = mrp / 100.00,
    discounted_selling_price = discounted_selling_price / 100.00;
```
## 📊 Exploratory Data Analysis (EDA)
### 🔹 Distinct categories
```sql
SELECT DISTINCT category FROM zepto ORDER BY category;
```
### 🔹 Stock status Summary
```sql
SELECT out_of_stock, COUNT(sku_id)
FROM zepto
GROUP BY out_of_stock;
```
### 🔹 Duplicate product names
```sql
SELECT name, COUNT(sku_id)
FROM zepto
GROUP BY name
HAVING COUNT(sku_id) > 1
ORDER BY COUNT(sku_id) DESC;
```
## 📈 Business Insights & Analysis
Below are the major business questions and SQL queries used for insights:
### Q1) Top 10 Best-Value Products (Highest Discount Percentage
```sql
SELECT DISTINCT name, mrp, discount_percentage
FROM zepto
ORDER BY discount_percentage DESC
LIMIT 10;
```
#### Objective:
To identify the products offering the highest discount, helping understand which items provide maximum value to customers and are likely driving higher conversions.
### Q2) High-MRP Products That Are Out of Stock
```sql
SELECT DISTINCT name, mrp, out_of_stock 
FROM zepto
WHERE out_of_stock = 'TRUE'
ORDER BY mrp DESC;
```
### Q3) Estimated Revenue for Each Category
```sql
SELECT category,
SUM(discounted_selling_price * availability_quantity) AS total_revenue_by_category
FROM zepto
GROUP BY category
ORDER BY total_revenue_by_category DESC;
```
### Q4) Products with MRP > ₹500 and Discount < 10%
```sql
SELECT DISTINCT name, mrp, discount_percentage
FROM zepto
WHERE mrp > 500 AND discount_percentage < 10
ORDER BY mrp DESC, discount_percentage DESC;
```
### Q5) Top 5 Categories with Highest Average Discount %
```sql
SELECT DISTINCT category,
ROUND(AVG(discount_percentage), 2) AS average_discount_percentage
FROM zepto
GROUP BY category
ORDER BY average_discount_percentage DESC
LIMIT 5;
```
### Q6) Price per Gram Calculation (for items above 100g)
```sql
SELECT DISTINCT name, weight_inGms, discounted_selling_price,
ROUND(discounted_selling_price / weight_inGms, 2) AS price_per_gram
FROM zepto
WHERE weight_inGms >= 100
ORDER BY price_per_gram;
```
### Q7) Categorize Weight into LOW / MEDIUM / BULK
```sql
SELECT DISTINCT name, weight_inGms,
CASE 
    WHEN weight_inGms < 1000 THEN 'LOW'
    WHEN weight_inGms < 5000 THEN 'MEDIUM'
    ELSE 'BULK'
END AS weight_category
FROM zepto;
```
### Q8) Total Inventory Weight per Category
```sql
SELECT category,
SUM(weight_inGms * availability_quantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;
```
## 🧠 Key Insights

● Many products have duplicate names, indicating variations or multiple SKUs.

● Some high-MRP products are out of stock, showing potential supply & demand gaps.

● Certain categories generate significantly higher revenue, guiding stock placement.

● Price-per-gram analysis helps identify the best-value products for customers.

● Weight classification helps in logistics, packaging, and delivery planning.

## 🚀 How to Run the Project

● Install PostgreSQL / MySQL / SQL tool of your choice

● Import the dataset into the table

● Run the SQL queries in sequence

● View insights and export results

## 📝 Conclusion

This SQL project helps understand product distribution, pricing insights, discount behavior, stock trends, and category-level performance within Zepto’s catalog.
It demonstrates strong skills in SQL, data cleaning, analysis, and real-world business insights.







