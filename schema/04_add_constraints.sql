-- Author: oneaarmdeveloper
-- Goals: creating 6 tables with constraints and relationships
-- Date: 09.04.2026

USE retail_analytics;

CREATE INDEX idx_customers_email
     ON customers(email);

CREATE INDEX idx_customers_tier
     ON customers(customer_tier);

CREATE INDEX idx_customers_city
     ON customers(city);

CREATE INDEX idx_orders_date
     ON orders(order_date);

CREATE INDEX idx_orders_status
     ON orders(status);

CREATE INDEX idx_orders_cust_date_status
     ON orders(customer_id,order_date, status);

CREATE INDEX idx_items_product
     ON order_items(product_id);

-- Confirm indices were created

SELECT
    table_name,
    index_name,
    column_name
FROM information_schema.statistics
WHERE table_schema = 'retail_analytics'
ORDER BY table_name, index_name; 


