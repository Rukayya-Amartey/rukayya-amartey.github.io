-- fixing city names in the customer table
UPDATE customers
SET city = CASE
    WHEN TRIM(LOWER(REPLACE(city, ' ', ''))) = 'lagos' 
        THEN 'Lagos'
    WHEN TRIM(LOWER(REPLACE(city, ' ', ''))) = 'abuja' 
        THEN 'Abuja'
    WHEN TRIM(LOWER(REPLACE(city, ' ', ''))) = 'kano' 
        THEN 'Kano'
    WHEN TRIM(LOWER(REPLACE(city, ' ', ''))) = 'ibadan' 
        THEN 'Ibadan'
    WHEN TRIM(LOWER(REPLACE(city, ' ', ''))) IN 
        ('portharcourt','port-harcourt','portharcourt') 
        THEN 'Port Harcourt'
    ELSE INITCAP(TRIM(city))
END;

-- fixing city names in seller table
UPDATE sellers
SET city = CASE
    WHEN TRIM(LOWER(REPLACE(city, ' ', ''))) = 'lagos' 
        THEN 'Lagos'
    WHEN TRIM(LOWER(REPLACE(city, ' ', ''))) = 'abuja' 
        THEN 'Abuja'
    WHEN TRIM(LOWER(REPLACE(city, ' ', ''))) = 'kano' 
        THEN 'Kano'
    WHEN TRIM(LOWER(REPLACE(city, ' ', ''))) = 'ibadan' 
        THEN 'Ibadan'
    WHEN TRIM(LOWER(REPLACE(city, ' ', ''))) IN 
        ('portharcourt','port-harcourt','portharcourt') 
        THEN 'Port Harcourt'
    ELSE INITCAP(TRIM(city))
END;

-- fixing category names in customer table to title names
UPDATE products
SET category = INITCAP(LOWER(TRIM(category)))
WHERE category IS NOT NULL;

-- fixing category names in sellers table to title names
UPDATE sellers
SET product_category = INITCAP(LOWER(TRIM(product_category)))
WHERE product_category IS NOT NULL;

-- Check for duplicate customers by email
SELECT email, COUNT(*) as duplicate_count
FROM customers
WHERE email IS NOT NULL
GROUP BY email
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

-- flagging duplicates 
-- deleting duplicate emails is not possible as they have orders attached to them
SELECT customer_id, first_name, last_name, email,
       'Duplicate Email' AS flag
FROM customers
WHERE email IN (
    SELECT email
    FROM customers
    WHERE email IS NOT NULL
    GROUP BY email
    HAVING COUNT(*) > 1
);

-- check for duplicate sellers by name, city and date joined
SELECT seller_name, city, onboarding_date, COUNT(*)
FROM sellers
GROUP BY seller_name, city, onboarding_date
HAVING COUNT(*) > 1;

-- Check for duplicate orders
SELECT customer_id, seller_id, order_date, total_amount, COUNT(*)
FROM orders
GROUP BY customer_id, seller_id, order_date, total_amount
HAVING COUNT(*) > 1;

-- check for missing emails and flagging them
SELECT customer_id, first_name, last_name, email,
       'Missing Email' AS flag
FROM customers
WHERE email IS NULL;

-- Check for zero or null unit price for products and flagging them
SELECT product_id, product_name, unit_price,
       'Invalid Price' AS flag
FROM products
WHERE unit_price IS NULL OR unit_price <= 0;

-- Check for negative product prices
SELECT product_id, product_name, unit_price,
       'Negative Price' AS flag
FROM products
WHERE unit_price < 0;

-- Check for review ratings outside 1 to 5
SELECT review_id, rating,
       'Invalid Rating' AS flag
FROM reviews
WHERE rating < 1 OR rating > 5;

-- Delete invalid review ratings
-- Decision: Ratings outside 1-5 are bad data and would skew
-- average rating calculations in the analysis
DELETE FROM reviews
WHERE rating < 1 OR rating > 5;

-- Check for orders where total amount does not match sum of the line items
-- did nOT delete these orders as they are still valid transactions
-- i will use order_items line totals for revenue calculations in the analysis
-- as they are more reliable than the orders.total_amount column
-- the mismatch has been flagged
SELECT o.order_id,
       o.total_amount AS recorded_total,
       SUM(oi.line_total) AS calculated_total,
       ABS(o.total_amount - SUM(oi.line_total)) AS difference,
       'Amount Mismatch' AS flag
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id, o.total_amount
HAVING ABS(o.total_amount - SUM(oi.line_total)) > 10
ORDER BY difference DESC;
