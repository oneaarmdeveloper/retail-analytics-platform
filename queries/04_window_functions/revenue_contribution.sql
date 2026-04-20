-- Author: oneaarmdeveloper
-- Goals: Customer percentage contribution to total revenue
-- Date: 20.04.2026

USE retail_analytics;

WITH customer_revenue AS (
    SELECT 
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        c.customer_tier,
        ROUND(SUM(oi.quantity * oi.unit_price_at_time * (1 - oi.discount_percent / 100)), 2) AS revenue
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status = 'Delivered'
    GROUP BY 
        c.customer_id,
        c.first_name,
        c.last_name,
        c.customer_tier
)
SELECT 
    customer_name,
    customer_tier,
    revenue,
    ROUND(revenue / SUM(revenue) OVER () * 100, 2) AS pct_of_total,
    ROUND(SUM(revenue) OVER (ORDER BY revenue DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) 
          / SUM(revenue) OVER () * 100, 2) AS cumulative_pct,
    RANK() OVER (ORDER BY revenue DESC) AS customer_rank
FROM customer_revenue 
ORDER BY revenue DESC
LIMIT 50;