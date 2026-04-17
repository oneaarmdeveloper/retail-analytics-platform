-- Author: oneaarmdeveloper
-- Goals: Suppliers whose Products perform above average
-- Date: 17.04.2026

USE retail_analytics;

WITH supplier_metrics AS (
    SELECT 
        s.supplier_id,
        s.supplier_name,
        s.city AS supplier_city,
        COUNT(DISTINCT p.product_id) AS distinct_products,
        SUM(oi.quantity) AS total_units_sold,
        ROUND(SUM(oi.quantity * oi.unit_price_at_time * (1 - oi.discount_percent / 100)), 2) AS total_net_revenue
    FROM suppliers s
    JOIN products p ON s.supplier_id = p.supplier_id
    JOIN order_items oi ON p.product_id = oi.product_id
    JOIN orders o ON oi.order_id = o.order_id
    WHERE o.status = 'Delivered'
    GROUP BY 
        s.supplier_id, 
        s.supplier_name, 
        s.city
),
supplier_with_avg AS (
    SELECT 
        *,
        ROUND(AVG(total_net_revenue) OVER (), 2) AS avg_supplier_revenue,
        ROUND(total_net_revenue / NULLIF(distinct_products, 0), 2) AS avg_revenue_per_product
    FROM supplier_metrics
)
SELECT 
    supplier_name,
    supplier_city,
    distinct_products,
    total_units_sold,
    total_net_revenue,
    avg_revenue_per_product,
    avg_supplier_revenue,
    CASE 
        WHEN total_net_revenue > avg_supplier_revenue THEN 'Above Average'
        ELSE 'Below Average'
    END AS performance_rating
FROM supplier_with_avg
WHERE total_net_revenue > avg_supplier_revenue
ORDER BY total_net_revenue DESC;

