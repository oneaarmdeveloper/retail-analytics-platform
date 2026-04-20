-- Author: oneaarmdeveloper
-- Goals: Year-over-year revenue growth analysis
-- Date: 20.04.2026

USE retail_analytics;

WITH yearly_revenue AS (
    SELECT
        YEAR(o.order_date) AS sales_year,
        ROUND(SUM(oi.quantity * oi.unit_price_at_time * (1 - oi.discount_percent / 100)), 2) AS annual_revenue,
        COUNT(DISTINCT o.order_id) AS total_orders,
        COUNT(DISTINCT o.customer_id) AS unique_customers
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status IN ('Delivered', 'Shipped')
    GROUP BY YEAR(o.order_date)
)
SELECT 
    sales_year,
    annual_revenue,
    total_orders,
    unique_customers,
    LAG(annual_revenue) OVER (ORDER BY sales_year) AS prev_year_revenue,
    ROUND(annual_revenue - LAG(annual_revenue) OVER (ORDER BY sales_year), 2) AS yoy_change,
    ROUND((annual_revenue - LAG(annual_revenue) OVER (ORDER BY sales_year)) 
          / NULLIF(LAG(annual_revenue) OVER (ORDER BY sales_year), 0) * 100, 1) AS yoy_growth_pct,
    CASE 
        WHEN annual_revenue > LAG(annual_revenue) OVER (ORDER BY sales_year) THEN 'Growth'
        WHEN annual_revenue < LAG(annual_revenue) OVER (ORDER BY sales_year) THEN 'Decline'
        ELSE 'Flat'
    END AS trend
FROM yearly_revenue
ORDER BY sales_year;    