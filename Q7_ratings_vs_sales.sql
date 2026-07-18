-- Question 7: Review Ratings and Sales Performance
-- Grouping products based on their average ratings and comparing revenue performance

WITH product_stats AS (
    SELECT 
        p.product_id,
        p.product_name,
        AVG(r.rating) AS avg_rating,
        SUM(oi.quantity * oi.unit_price) AS total_revenue,
        AVG(oi.unit_price) AS avg_unit_price
    FROM products p
    LEFT JOIN order_items oi 
        ON p.product_id = oi.product_id
    LEFT JOIN reviews r 
        ON p.product_id = r.product_id
    WHERE oi.unit_price IS NOT NULL
    GROUP BY p.product_id, p.product_name
)

SELECT 
    CASE 
        WHEN avg_rating >= 4 THEN 'High Rated'
        WHEN avg_rating BETWEEN 3 AND 3.99 THEN 'Mid Rated'
        ELSE 'Low Rated'
    END AS rating_category,

    COUNT(product_id) AS product_count,
    SUM(total_revenue) AS total_revenue,
    AVG(avg_unit_price) AS avg_unit_price

FROM product_stats
GROUP BY rating_category
ORDER BY total_revenue DESC;