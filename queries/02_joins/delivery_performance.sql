-- Author: oneaarmdeveloper
-- Goal: Orders pending longer than 7 days
-- Date: 14.04.2026
USE retail_analytics;

SELECT 
    o.order_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.city,
    o.order_date,
    o.status,
    DATEDIFF(CURRENT_DATE, o.order_date) AS days_since_order,
    COUNT(oi.order_item_id) AS item_count,
    ROUND(SUM(oi.quantity * oi.unit_price_at_time), 2) AS order_value,
    CASE 
        WHEN SUM(oi.quantity * oi.unit_price_at_time) >= 500 THEN 'High Value'
        WHEN SUM(oi.quantity * oi.unit_price_at_time) >= 200 THEN 'Medium Value'
        ELSE 'Standard'
    END AS order_tier
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status IN ('Pending', 'Processing', 'Shipped')
  AND DATEDIFF(CURRENT_DATE, o.order_date) > 7
GROUP BY 
    o.order_id,
    c.first_name,
    c.last_name,
    c.city,
    o.order_date,
    o.status
ORDER BY days_since_order DESC;  