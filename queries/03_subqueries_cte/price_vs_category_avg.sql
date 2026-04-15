-- Author: oneaarmdeveloper
-- Goals: products priced above their Category Average
-- Date: 15.04.2026

USE retail_analytics;

SELECT
    p.product_id,
    p.product_name,
    p.category,
    p.unit_price,
    ROUND((SELECT AVG(p2.unit_price) 
           FROM products p2 
           WHERE p2.category = p.category AND p2.discontinued = FALSE), 2) AS category_avg_price,
    ROUND(p.unit_price - (SELECT AVG(p2.unit_price) 
                          FROM products p2 
                          WHERE p2.category = p.category AND p2.discontinued = FALSE), 2) AS price_premium,
    ROUND((p.unit_price / (SELECT AVG(p2.unit_price) 
                           FROM products p2 
                           WHERE p2.category = p.category AND p2.discontinued = FALSE) - 1) * 100, 1) AS pct_above_avg
FROM products p
WHERE p.discontinued = FALSE
  AND p.unit_price > (SELECT AVG(p3.unit_price) 
                      FROM products p3 
                      WHERE p3.category = p.category AND p3.discontinued = FALSE)
ORDER BY p.category, price_premium DESC; 