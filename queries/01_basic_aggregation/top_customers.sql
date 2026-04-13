-- Author: oneaarmdeveloper
-- Goals: Top 10 customers by total lifetime spending
-- Date: 13.04.2026

USE retail_analytics;

SELECT 
     c.customer_id,
     CONCAT(c.first_name, ' ', c.last_name) AS full_name,
     c.email,
     c.customer_tier,
     COUNT(DISTINCT o.order_id) AS total_orders,
     ROUND(SUM(oi.quantity * oi.unit_price_at_time * (1 - oi.discount_percent / 100)), 2) AS lifetime_value,
     ROUND(SUM(oi.quantity * oi.unit_price_at_time) / COUNT(DISTINCT o.order_id), 2) AS avg_order_value,
     MIN(o.order_date) AS first_order_date,
     MAX(o.order_date) AS last_order_date,
     DATEDIFF(CURRENT_DATE, MAX(o.order_date)) AS days_since_last_order
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status IN ('Delivered', 'Shipped')
GROUP BY 
     c.customer_id, 
     c.first_name, 
     c.last_name, 
     c.email, 
     c.customer_tier
ORDER BY lifetime_value DESC
LIMIT 10;