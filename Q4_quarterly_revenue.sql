-- Question 4: Quarterly Revenue Trends
-- Comparing revenue performance across quarters for 2023 and 2024

SELECT 
    EXTRACT(YEAR FROM o.order_date) AS year,
    EXTRACT(QUARTER FROM o.order_date) AS quarter,
    
    COUNT(DISTINCT o.order_id) AS total_orders,
    
    SUM(oi.quantity * oi.unit_price) AS total_revenue,
    
    SUM(oi.quantity * oi.unit_price) / COUNT(DISTINCT o.order_id) AS avg_order_value

FROM orders o
JOIN order_items oi 
    ON o.order_id = oi.order_id

WHERE o.order_date BETWEEN '2023-01-01' AND '2024-12-31'
    AND oi.unit_price IS NOT NULL

GROUP BY 
    EXTRACT(YEAR FROM o.order_date),
    EXTRACT(QUARTER FROM o.order_date)

ORDER BY year, quarter;