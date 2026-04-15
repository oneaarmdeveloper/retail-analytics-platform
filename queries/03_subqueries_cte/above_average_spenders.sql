-- Author: oneaarmdeveloper
-- Goals: customers who spent more than 2x the average
-- Date: 15.04.2026

USE retail_analytics;

WITH customer_totals AS (
    SELECT 
        c.customer_id,
        c.first_name,
        c.last_name,
        c.customer_tier,
        c.city,
        ROUND(SUM(oi.quantity * oi.unit_price_at_time * (1 - oi.discount_percent / 100)), 2) AS total_spent
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status = 'Delivered'
    GROUP BY 
        c.customer_id, 
        c.first_name, 
        c.last_name, 
        c.customer_tier, 
        c.city
),
global_avg AS (
    SELECT AVG(total_spent) AS avg_customer_spend
    FROM customer_totals
)
SELECT 
    ct.customer_id,
    CONCAT(ct.first_name, ' ', ct.last_name) AS customer_name,
    ct.customer_tier,
    ct.city,
    ct.total_spent,
    ROUND(ct.total_spent / ga.avg_customer_spend, 2) AS times_above_average
FROM customer_totals ct
CROSS JOIN global_avg ga
WHERE ct.total_spent > 2 * ga.avg_customer_spend
ORDER BY ct.total_spent DESC;  