-- Author: oneaarmdeveloper
-- Goals: Monthly Sales Report with running Total
-- Date: 13.04.2026

USE retail_analytics;

WITH monthly_metrics AS (
    SELECT 
        DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
        COUNT(DISTINCT o.order_id) AS total_orders,
        COUNT(DISTINCT o.customer_id) AS unique_customers,
        ROUND(SUM(oi.quantity * oi.unit_price_at_time), 2) AS gross_revenue,
        ROUND(SUM(oi.quantity * oi.unit_price_at_time * (1 - oi.discount_percent / 100)), 2) AS net_revenue,
        ROUND(SUM(oi.quantity * oi.unit_price_at_time) / COUNT(DISTINCT o.order_id), 2) AS avg_order_value
    FROM orders AS o
    JOIN order_items AS oi ON o.order_id = oi.order_id
    WHERE o.status IN ('Delivered', 'Shipped')
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
)
SELECT 
    sales_month,
    total_orders,
    unique_customers,
    gross_revenue,
    net_revenue,
    avg_order_value,
    SUM(net_revenue) OVER (ORDER BY sales_month) AS running_net_revenue
FROM monthly_metrics
ORDER BY sales_month DESC
LIMIT 24;   


