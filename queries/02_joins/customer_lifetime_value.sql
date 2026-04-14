-- Author: oneaarmdeveloper
-- Goal: Customer lifetime value with full profile
-- Date: 13.04.2026

USE retail_analytics;

SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.customer_tier,
    c.city,
    c.registration_date,
    DATEDIFF(CURRENT_DATE, c.registration_date) AS days_as_customer,
    COUNT(DISTINCT o.order_id) AS total_orders,
    MIN(o.order_date) AS first_order_date,
    MAX(o.order_date) AS last_order_date,
    ROUND(
        SUM(oi.quantity * oi.unit_price_at_time * (1 - oi.discount_percent / 100)) 
        / GREATEST(DATEDIFF(CURRENT_DATE, c.registration_date) / 365.0, 1), 
        2
    ) AS annualized_lifetime_value,
    CASE 
        WHEN DATEDIFF(CURRENT_DATE, MAX(o.order_date)) <= 90 THEN 'Active'
        WHEN DATEDIFF(CURRENT_DATE, MAX(o.order_date)) <= 180 THEN 'At Risk'
        WHEN DATEDIFF(CURRENT_DATE, MAX(o.order_date)) <= 365 THEN 'Dormant'
        ELSE 'Churned'
    END AS customer_status
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status IN ('Delivered', 'Shipped', 'Processing')
GROUP BY 
    c.customer_id, 
    c.first_name, 
    c.last_name, 
    c.customer_tier, 
    c.registration_date,
    c.city
ORDER BY annualized_lifetime_value DESC
LIMIT 100; 
