-- Author: oneaarmdeveloper
-- Goals: Running total of sales per month
-- Date: 20.04.2026

USE retail_analytics;

WITH monthly_revenue AS (
    SELECT 
        DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
        ROUND(SUM(oi.quantity * oi.unit_price_at_time * (1 - oi.discount_percent / 100)), 2) AS monthly_revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id 
    WHERE o.status IN ('Delivered', 'Shipped')
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
)
SELECT 
    sales_month,
    monthly_revenue,
    SUM(monthly_revenue) OVER (ORDER BY sales_month) AS running_total,
    ROUND(monthly_revenue - LAG(monthly_revenue) OVER (ORDER BY sales_month), 2) AS mom_change,
    ROUND(
        (monthly_revenue - LAG(monthly_revenue) OVER (ORDER BY sales_month)) 
        / NULLIF(LAG(monthly_revenue) OVER (ORDER BY sales_month), 0) * 100, 
    1) AS mom_pct_change
FROM monthly_revenue
ORDER BY sales_month; 

