-- Question 2 Product Performance
-- Finding the top 10 products that generated the most revenue in 2024
-- Only considering items with valid prices to avoid incorrect revenue values
SELECT 
    p.product_name,
    p.category,
    SUM(oi.line_total) AS total_revenue,
    COUNT(DISTINCT oi.order_id) AS total_orders
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE EXTRACT(YEAR FROM o.order_date) = 2024
AND oi.line_total IS NOT NULL
GROUP BY p.product_id, p.product_name, p.category
ORDER BY total_revenue DESC
LIMIT 10;
