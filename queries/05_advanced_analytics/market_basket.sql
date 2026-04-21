-- Author: oneaarmdeveloper
-- Goals: Market Basket Analysis - Products bought together
-- Date: 21.04.2026

USE retail_analytics;

SELECT
    p1.product_name AS product_a,
    p2.product_name AS product_b,
    p1.category AS category_a,
    p2.category AS category_b,
    COUNT(DISTINCT oi1.order_id) AS times_bought_together,
    ROUND(
        COUNT(DISTINCT oi1.order_id) / 
        (SELECT COUNT(DISTINCT order_id) FROM orders WHERE status = 'Delivered') * 100, 
    2) AS support_pct
FROM order_items oi1
JOIN order_items oi2 
    ON oi1.order_id = oi2.order_id 
    AND oi1.product_id < oi2.product_id  -- ✅ Ensures unique pairs, avoids self-joins & duplicates
JOIN products p1 ON oi1.product_id = p1.product_id
JOIN products p2 ON oi2.product_id = p2.product_id  -- ✅ Added missing join
JOIN orders o ON oi1.order_id = o.order_id
WHERE o.status = 'Delivered'
GROUP BY 
    p1.product_id, p1.product_name, p1.category,
    p2.product_id, p2.product_name, p2.category
ORDER BY times_bought_together DESC  -- ✅ Correct sorting syntax
LIMIT 20;
