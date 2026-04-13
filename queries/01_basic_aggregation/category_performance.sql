
-- Author: oneaarmdeveloper
-- Goals: Category Performance Report
-- Date: 13.04.2026

USE retail_analytics;

SELECT 
    p.category,
    COUNT(DISTINCT p.product_id) AS unique_products_sold,
    SUM(oi.quantity) AS total_units_sold,
    ROUND(SUM(oi.quantity * oi.unit_price_at_time), 2) AS gross_revenue,
    ROUND(SUM(oi.quantity * oi.unit_price_at_time * (1 - oi.discount_percent / 100)), 2) AS net_revenue,
    ROUND(SUM(oi.quantity * oi.unit_price_at_time) / SUM(oi.quantity), 2) AS avg_selling_price,
    ROUND(AVG(oi.discount_percent), 2) AS avg_discount_percent,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM products AS p
JOIN order_items AS oi ON p.product_id = oi.product_id
JOIN orders AS o ON oi.order_id = o.order_id
WHERE o.status IN ('Delivered', 'Shipped')
GROUP BY p.category
ORDER BY net_revenue DESC;  