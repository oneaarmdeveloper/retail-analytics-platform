-- Author: oneaarmdeveloper
-- Goals: Customer churn prediction indicators
-- Date: 21.04.2026

USE retail_analytics;

WITH customer_behavior AS (
    SELECT
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        c.customer_tier, 
        c.city,
        DATEDIFF(CURRENT_DATE, MAX(o.order_date)) AS days_since_last_order,
        COUNT(DISTINCT o.order_id) AS total_orders,
        ROUND(SUM(oi.quantity * oi.unit_price_at_time * (1 - oi.discount_percent / 100)), 2) AS lifetime_value,
        DATEDIFF(MAX(o.order_date), MIN(o.order_date)) 
            / NULLIF(COUNT(DISTINCT o.order_id) - 1, 0) AS avg_days_between_orders
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status = 'Delivered'
    GROUP BY c.customer_id, c.first_name, c.last_name, c.customer_tier, c.city
)
SELECT
    customer_id, 
    customer_name, 
    customer_tier, 
    city,
    days_since_last_order, 
    ROUND(avg_days_between_orders, 1) AS avg_days_between_orders,
    total_orders, 
    lifetime_value,
    ROUND(days_since_last_order / NULLIF(avg_days_between_orders, 0), 1) AS missed_cycles,
    CASE
        WHEN days_since_last_order > avg_days_between_orders * 3 AND lifetime_value > 500
             THEN 'HIGH RISK — Valuable customer going silent'
        WHEN days_since_last_order > avg_days_between_orders * 2 AND total_orders >= 3
             THEN 'MEDIUM RISK — Regular buyer becoming irregular'
        WHEN days_since_last_order > 180 AND total_orders >= 2
             THEN 'LOW RISK — Watch closely'
        ELSE 'Normal'
    END AS churn_risk,
    CASE
        WHEN days_since_last_order > avg_days_between_orders * 3 AND lifetime_value > 500
             THEN 'Send WIN-BACK email with 20% discount'
        WHEN days_since_last_order > avg_days_between_orders * 2 AND total_orders >= 3
             THEN 'Send personalized reactivation offer'
        WHEN days_since_last_order > 180
             THEN 'Include in next newsletter campaign'
        ELSE 'Continue normal marketing'
    END AS recommended_action
FROM customer_behavior
WHERE days_since_last_order > 90
ORDER BY lifetime_value DESC;