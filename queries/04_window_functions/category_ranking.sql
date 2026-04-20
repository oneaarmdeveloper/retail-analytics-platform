-- Author: oneaarmdeveloper
-- Goals: Product performance ranking within category
-- Date: 20.04.2026

USE retail_analytics;

WITH product_revenue AS (
    SELECT 
        p.product_id, 
        p.product_name, 
        p.category, 
        p.unit_price,  -- ✅ Added missing comma
        SUM(oi.quantity) AS total_units_sold,
        ROUND(SUM(oi.quantity * oi.unit_price_at_time * (1 - oi.discount_percent / 100)), 2) AS total_revenue
    FROM products p
    JOIN order_items oi ON p.product_id = oi.product_id 
    JOIN orders o ON oi.order_id = o.order_id 
    WHERE o.status IN ('Delivered', 'Shipped')  -- ✅ Fixed typo: satatus → status
    GROUP BY p.product_id, p.product_name, p.category, p.unit_price
)
SELECT 
    category, 
    product_name, 
    unit_price, 
    total_units_sold, 
    total_revenue,
    RANK() OVER (PARTITION BY category ORDER BY total_revenue DESC) AS rank_in_category,
    ROUND(total_revenue / SUM(total_revenue) OVER (PARTITION BY category) * 100, 1) AS pct_of_category_revenue
FROM product_revenue
ORDER BY category, rank_in_category;

