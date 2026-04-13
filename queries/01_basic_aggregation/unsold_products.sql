-- Author: oneaarmdeveloper
-- Goal: Product that has never been sold
-- Date: 13.04.2026


USE retail_analytics;

SELECT 
    p.product_id,
    p.product_name,
    p.category,
    s.supplier_name,
    p.unit_price,
    p.stock_quantity,
    ROUND(p.unit_price * p.stock_quantity, 2) AS total_inventory_value,
    p.discontinued,
    p.created_at
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
LEFT JOIN suppliers s ON p.supplier_id = s.supplier_id
WHERE oi.order_item_id IS NULL
ORDER BY p.category, p.unit_price DESC;   