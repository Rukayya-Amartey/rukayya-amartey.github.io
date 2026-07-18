-- Question 5: Customer Spend Segmentation
-- Grouping customers based on how much they spent in 2024

WITH customer_spend AS (
    SELECT 
        o.customer_id,
        SUM(oi.quantity * oi.unit_price) AS total_spend
    FROM orders o
    JOIN order_items oi 
        ON o.order_id = oi.order_id
    WHERE o.order_date BETWEEN '2024-01-01' AND '2024-12-31'
        AND oi.unit_price IS NOT NULL
    GROUP BY o.customer_id
)

SELECT 
    CASE 
        WHEN total_spend >= 100000 THEN 'High Spenders'
        WHEN total_spend BETWEEN 50000 AND 99999 THEN 'Medium Spenders'
        ELSE 'Low Spenders'
    END AS spend_category,

    COUNT(customer_id) AS customer_count,
    AVG(total_spend) AS avg_spend,
    SUM(total_spend) AS total_revenue

FROM customer_spend
GROUP BY spend_category
ORDER BY total_revenue DESC;
