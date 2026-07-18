-- Question 8: Top Seller Bonus Qualification
-- Identifying top performing sellers based on revenue, order volume and ratings

WITH seller_stats AS (
    SELECT 
        o.seller_id,
        COUNT(o.order_id) AS total_orders,
        SUM(oi.quantity * oi.unit_price) AS total_revenue,
        AVG(r.rating) AS avg_rating
    FROM orders o
    JOIN order_items oi 
        ON o.order_id = oi.order_id
    LEFT JOIN reviews r 
        ON o.order_id = r.order_id
    WHERE o.order_date BETWEEN '2024-01-01' AND '2024-12-31'
        AND oi.unit_price IS NOT NULL
    GROUP BY o.seller_id
)

SELECT 
    seller_id,
    total_orders,
    avg_rating,
    total_revenue
FROM seller_stats
WHERE total_orders >= 10
    AND avg_rating >= 4.0
ORDER BY total_revenue DESC
LIMIT 10;