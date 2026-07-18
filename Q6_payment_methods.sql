-- Question 6: Payment Method Preferences by State
-- Show transaction count and total amount per payment method per state
-- Identify the most popular payment method per state
SELECT 
    c.state,
    p.payment_method,
    COUNT(p.payment_id) AS transaction_count,
    SUM(p.amount) AS total_amount,
    RANK() OVER (
        PARTITION BY c.state 
        ORDER BY COUNT(p.payment_id) DESC
    ) AS popularity_rank
FROM payments p
JOIN orders o ON p.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.state, p.payment_method
ORDER BY c.state, transaction_count DESC;