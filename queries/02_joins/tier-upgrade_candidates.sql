-- Author: oneaarmdeveloper
-- Goal: Customers who should be upgraded to next Tier
-- Date: 14.04.2026

USE retail_analytics;

SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.customer_tier AS current_tier,
    CASE
        WHEN SUM(oi.quantity * oi.unit_price_at_time * (1 - oi.discount_percent / 100)) >= 10000 THEN 'Platinum'
        WHEN SUM(oi.quantity * oi.unit_price_at_time * (1 - oi.discount_percent / 100)) >= 5000 THEN 'Gold'
        WHEN SUM(oi.quantity * oi.unit_price_at_time * (1 - oi.discount_percent / 100)) >= 1000 THEN 'Silver'
        ELSE 'Bronze'
    END AS earned_tier,
    ROUND(SUM(oi.quantity * oi.unit_price_at_time * (1 - oi.discount_percent / 100)), 2) AS total_spent,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Delivered'
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name,
    c.customer_tier
HAVING earned_tier != c.customer_tier
ORDER BY total_spent DESC;

