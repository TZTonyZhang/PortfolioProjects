USE portfolio_project_customer_sales;
-- Data Cleaning and Transform in SQL
-- Create DIM customers table
CREATE TABLE customers AS 
SELECT 
  ad.Customer_ID, 
  ad.Age, 
  CASE -- Create custom groups for all ages
  WHEN ad.Age < 20 THEN 'Under 20' WHEN ad.Age BETWEEN 20 
  AND 30 THEN '20-30' WHEN ad.Age BETWEEN 31 
  AND 40 THEN '31-40' WHEN ad.Age BETWEEN 41 
  AND 55 THEN '41-55' WHEN ad.Age BETWEEN 56 
  AND 65 THEN '56-65' ELSE 'Over 65' END AS Age_Groups, 
  ad.Gender, 
  ad.Location AS City, 
  ad.Subscription_Status, 
  ad.Previous_Purchases, 
  ad.Frequency_of_Purchases, 
  CASE -- Create customer types
  WHEN ad.Previous_Purchases < 5 THEN 'New Customer' WHEN ad.Previous_Purchases BETWEEN 5 
  AND 20 THEN 'Bronze Customer' WHEN ad.Previous_Purchases BETWEEN 21 
  AND 40 THEN 'Silver Customer' ELSE 'Gold Customer' END AS Customer_Type 
FROM 
  all_data AS ad;
-- Define constraints and primary key for DIM customer table
ALTER TABLE 
  customers MODIFY Customer_ID INT NOT NULL AUTO_INCREMENT, 
ADD 
  PRIMARY KEY(Customer_ID);
-- Create DIM products table
CREATE TABLE products (
  Product_ID INT NOT NULL AUTO_INCREMENT, 
  -- Define constraints and primary key
  PRIMARY KEY (Product_ID)
) 
SELECT 
  ad.Item_Purchased, 
  ad.Category, 
  ad.Size, 
  ad.Color 
FROM 
  all_data AS ad 
GROUP BY 
  1, 
  2, 
  3, 
  4 
ORDER BY 
  ad.Category;
-- Create DIM seasons table
CREATE TABLE seasons (
  Season_ID INT NOT NULL AUTO_INCREMENT, 
  -- Define constraints and primary key
  Season varchar(15) NOT NULL, 
  PRIMARY KEY (Season_ID)
);
INSERT INTO seasons (Season) 
VALUES 
  ('Spring'), 
  ('Summer'), 
  ('Fall'), 
  ('Winter');
-- Create DIM shipping table
CREATE TABLE shipping (
  Shipping_ID INT NOT NULL AUTO_INCREMENT, 
  -- Define constraints and primary key
  PRIMARY KEY (Shipping_ID)
) 
SELECT 
  ad.Shipping_Type 
FROM 
  all_data AS ad 
GROUP BY 
  1;
-- Create DIM payment table
CREATE TABLE payments (
  Payment_ID INT NOT NULL AUTO_INCREMENT, 
  -- Define constraints and primary key
  PRIMARY KEY (Payment_ID)
) 
SELECT 
  ad.Payment_Method 
FROM 
  all_data AS ad 
GROUP BY 
  1;
-- Create DIM markdown table
CREATE TABLE markdowns (
  Markdown_ID INT NOT NULL AUTO_INCREMENT, 
  -- Define constraints and primary key
  PRIMARY KEY (Markdown_ID)
) 
SELECT 
  ad.Discount_Applied, 
  ad.Promo_Code_Used 
FROM 
  all_data AS ad 
GROUP BY 
  1, 
  2;
-- Create FACTS Sales table
CREATE TABLE sales AS 
SELECT 
  ad.Customer_ID, 
  p.Product_ID, 
  s.Season_ID, 
  sh.Shipping_ID, 
  pm.Payment_ID, 
  m.Markdown_ID, 
  ad.Purchase_Amount_USD 
FROM 
  all_data as ad 
  JOIN products as p USING(
    Item_Purchased, Category, Size, Color
  ) 
  JOIN seasons as s USING (Season) 
  JOIN shipping as sh USING (Shipping_Type) 
  JOIN payments as pm USING (Payment_Method) 
  JOIN markdowns as m USING (
    Discount_Applied, Promo_Code_Used
  ) 
ORDER BY 
  1;
