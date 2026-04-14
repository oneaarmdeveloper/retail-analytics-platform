-- Author: oneaarmdeveloper
-- Goal: Products with low stock and their supplier info
-- Date: 13.04.2026

USE retail_analytics;

SELECT 
    p.product_id,
    p.product_name,
    p.category,
    p.stock_quantity,
    p.reorder_level,
    (p.reorder_level - p.stock_quantity) AS stock_deficit,
    CASE
        WHEN p.stock_quantity = 0 THEN 'OUT OF STOCK'
        WHEN p.stock_quantity < p.reorder_level THEN 'LOW STOCK'
        ELSE 'OK'
    END AS stock_status,
    s.supplier_name,
    s.contact_name,
    s.phone AS supplier_phone,
    s.email AS supplier_email,
    ROUND(p.unit_price * (p.reorder_level * 3), 2) AS estimated_reorder_cost
FROM products p
LEFT JOIN suppliers s ON p.supplier_id = s.supplier_id
WHERE p.discontinued = FALSE 
  AND p.stock_quantity <= p.reorder_level
ORDER BY p.stock_quantity ASC, stock_deficit DESC; 