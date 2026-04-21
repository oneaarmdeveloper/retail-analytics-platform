-- Author: oneaarmdeveloper
-- Goals: Supplier performance scorecard
-- Date: 21.04.2026

USE retail_analytics;

WITH supplier_metrics AS (
    SELECT
        s.supplier_id,
        s.supplier_name,
        s.city AS supplier_city,
        COUNT(DISTINCT p.product_id) AS total_products,
        COUNT(DISTINCT CASE WHEN p.discontinued = FALSE THEN p.product_id END) AS active_products,
        ROUND(SUM(oi.quantity * oi.unit_price_at_time * (1 - oi.discount_percent / 100)), 2) AS total_revenue,
        SUM(oi.quantity) AS total_units_sold,
        ROUND(AVG(oi.discount_percent), 2) AS avg_discount,
        COUNT(DISTINCT CASE WHEN p.stock_quantity < p.reorder_level THEN p.product_id END) AS products_below_reorder
    FROM suppliers s
    JOIN products p ON s.supplier_id = p.supplier_id
    JOIN order_items oi ON p.product_id = oi.product_id
    JOIN orders o ON oi.order_id = o.order_id
    WHERE o.status = 'Delivered'
    GROUP BY s.supplier_id, s.supplier_name, s.city
),
supplier_scores AS (
    SELECT
        supplier_name,
        supplier_city,
        total_products,
        active_products,
        total_revenue,
        total_units_sold,
        avg_discount,
        products_below_reorder,
        -- Normalize Revenue (Max 30 points)
        ROUND((total_revenue / NULLIF(MAX(total_revenue) OVER (), 0)) * 30, 0) AS revenue_score,
        -- Normalize Catalog Activity (Max 20 points)
        ROUND((active_products / NULLIF(MAX(active_products) OVER (), 0)) * 20, 0) AS catalog_score,
        -- Reliability Score (Max 25 points): Penalize low stock items
        ROUND(25 - (products_below_reorder / GREATEST(total_products, 1)) * 25, 0) AS reliability_score,
        -- Pricing Score (Max 25 points): Penalize high discounts
        ROUND(25 - (avg_discount / 100) * 25, 0) AS pricing_score,
        -- Total Composite Score
        ROUND(
            (total_revenue / NULLIF(MAX(total_revenue) OVER (), 0)) * 30 +
            (active_products / NULLIF(MAX(active_products) OVER (), 0)) * 20 +
            (25 - (products_below_reorder / GREATEST(total_products, 1)) * 25) +
            (25 - (avg_discount / 100) * 25),
        0) AS total_score
    FROM supplier_metrics
)
SELECT
    supplier_name,
    supplier_city,
    total_products,
    active_products,
    total_revenue,
    total_units_sold,
    avg_discount,
    products_below_reorder,
    revenue_score,
    catalog_score,
    reliability_score,
    pricing_score,
    total_score,
    CASE
        WHEN total_score >= 80 THEN 'A — Strategic Partner'
        WHEN total_score >= 60 THEN 'B — Preferred Supplier'
        WHEN total_score >= 40 THEN 'C — Needs Improvement'
        ELSE 'D — Under Review'
    END AS supplier_grade
FROM supplier_scores
ORDER BY total_score DESC; 