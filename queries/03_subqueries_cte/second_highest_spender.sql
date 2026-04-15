-- Author: oneaarmdeveloper
-- Goals: Find the 2nd highest-spending customer per city
-- Date: 15.04.2026

USE retail_analytics;

WITH customer_spend AS (
    SELECT 
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        c.city,
        c.customer_tier,
        ROUND(SUM(oi.quantity * oi.unit_price_at_time * (1 - oi.discount_percent / 100)), 2) AS total_spent
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status = 'Delivered'
    GROUP BY 
        c.customer_id,
        c.first_name,
        c.last_name,
        c.city,
        c.customer_tier
),
ranked_customers AS (
    SELECT 
        customer_id,
        customer_name,
        city,
        customer_tier,
        total_spent,
        DENSE_RANK() OVER (PARTITION BY city ORDER BY total_spent DESC) AS city_rank
    FROM customer_spend
)
SELECT 
    city,
    customer_name,
    customer_tier,
    total_spent,
    city_rank
FROM ranked_customers
WHERE city_rank = 2
ORDER BY city DESC;