-- Author: oneaarmdeveloper
-- Goals: creating 6 tables with constraints and relationships
-- Date: 09.04.2026

USE retail_analytics;

-- SUPPLIERS (10 rows)

INSERT INTO suppliers (supplier_name, contact_name, phone, email, city, country) VALUES
('TechWorld GmbH',    'Franz Müller',   '+49 89 12345',  'franz@techworld.de',    'München',    'Deutschland'),
('ElectroPro AG',     'Heike Schmidt',  '+49 30 98765',  'heike@electropro.de',   'Berlin',     'Deutschland'),
('FashionHub KG',     'Laura Becker',   '+49 40 55555',  'laura@fashionhub.de',   'Hamburg',    'Deutschland'),
('SportMax GmbH',     'Tobias Wolf',    '+49 221 33333', 'tobias@sportmax.de',    'Köln',       'Deutschland'),
('HomeStyle AG',      'Sabine Koch',    '+49 711 44444', 'sabine@homestyle.de',   'Stuttgart',  'Deutschland'),
('BookWorld Verlag',  'Peter Braun',    '+49 69 22222',  'peter@bookworld.de',    'Frankfurt',  'Deutschland'),
('FoodFirst GmbH',    'Monika Schäfer', '+49 911 66666', 'monika@foodfirst.de',   'Nürnberg',   'Deutschland'),
('GardenPlus KG',     'Hans Weber',     '+49 351 77777', 'hans@gardenplus.de',    'Dresden',    'Deutschland'),
('AutoParts AG',      'Renate Fischer', '+49 211 88888', 'renate@autoparts.de',   'Düsseldorf', 'Deutschland'),
('GlobalImport GmbH', 'Klaus Richter',  '+49 431 99999', 'klaus@globalimport.de', 'Kiel',       'Deutschland');


-- PRODUCTS (20 rows across 4 categories)

INSERT INTO products (product_name, category, supplier_id, unit_price, stock_quantity, reorder_level) VALUES
-- Electronics
('Laptop Pro 15"',         'Electronics', 1, 1299.99,  45,  5),
('Wireless Mouse X200',    'Electronics', 1,   29.99, 200, 20),
('USB-C Hub 7-Port',       'Electronics', 2,   49.99, 150, 15),
('Mechanical Keyboard',    'Electronics', 2,   89.99,  80, 10),
('4K Monitor 27"',         'Electronics', 1,  449.99,  30,  5),
-- Fashion
('Running Shoes Pro',      'Fashion',     3,  119.99,  90, 20),
('Winter Jacket XL',       'Fashion',     3,  199.99,  60, 10),
('Casual T-Shirt Pack x3', 'Fashion',     3,   34.99, 300, 50),
('Denim Jeans Slim Fit',   'Fashion',     3,   79.99, 120, 25),
('Sports Cap',             'Fashion',     3,   24.99, 200, 30),
-- Sports
('Yoga Mat Premium',       'Sports',      4,   49.99, 100, 15),
('Dumbbell Set 20kg',      'Sports',      4,  129.99,  40, 10),
('Protein Powder 2kg',     'Sports',      4,   59.99,  75, 20),
('Resistance Bands Kit',   'Sports',      4,   24.99, 180, 30),
('Water Bottle 1L',        'Sports',      4,   19.99, 250, 40),
-- Home
('Coffee Maker Deluxe',    'Home',        5,  149.99,  55, 10),
('Air Purifier HEPA',      'Home',        5,  299.99,  25,  5),
('Smart LED Bulb Pack x4', 'Home',        5,   29.99, 400, 50),
('Bamboo Cutting Board',   'Home',        5,   34.99, 150, 20),
('Electric Kettle 1.7L',   'Home',        5,   49.99,  90, 15);


-- CUSTOMERS (15 rows)

INSERT INTO customers (first_name, last_name, email, phone, registration_date, city, country, customer_tier) VALUES
('Anna',      'Müller',     'anna.mueller@email.de',   '+49 171 111111', '2022-01-15', 'München',    'Deutschland', 'Platinum'),
('Klaus',     'Schmidt',    'k.schmidt@web.de',        '+49 172 222222', '2022-03-20', 'Berlin',     'Deutschland', 'Gold'),
('Sophie',    'Wagner',     'sophie.w@gmail.com',      '+49 173 333333', '2022-05-10', 'Hamburg',    'Deutschland', 'Gold'),
('Thomas',    'Fischer',    'thomas.f@outlook.de',     '+49 174 444444', '2022-07-01', 'Köln',       'Deutschland', 'Silver'),
('Maria',     'Weber',      'maria.weber@email.de',    '+49 175 555555', '2022-08-14', 'Frankfurt',  'Deutschland', 'Silver'),
('Felix',     'Becker',     'felix.b@web.de',          '+49 176 666666', '2022-09-30', 'Stuttgart',  'Deutschland', 'Bronze'),
('Laura',     'Hoffmann',   'laura.h@gmail.com',       '+49 177 777777', '2022-11-05', 'Düsseldorf', 'Deutschland', 'Gold'),
('Michael',   'Schulz',     'michael.s@freenet.de',    '+49 178 888888', '2023-01-20', 'München',    'Deutschland', 'Platinum'),
('Julia',     'Koch',       'julia.k@email.de',        '+49 179 999999', '2023-02-28', 'Hamburg',    'Deutschland', 'Silver'),
('Daniel',    'Bauer',      'd.bauer@web.de',          '+49 170 101010', '2023-04-15', 'Berlin',     'Deutschland', 'Bronze'),
('Sabine',    'Richter',    'sabine.r@gmail.com',      '+49 151 202020', '2023-06-01', 'Köln',       'Deutschland', 'Gold'),
('Andreas',   'Wolf',       'a.wolf@outlook.de',       '+49 152 303030', '2023-07-22', 'Frankfurt',  'Deutschland', 'Bronze'),
('Christine', 'Braun',      'c.braun@email.de',        '+49 153 404040', '2023-09-10', 'Stuttgart',  'Deutschland', 'Silver'),
('Stefan',    'Zimmermann', 's.zimm@web.de',           '+49 154 505050', '2023-10-30', 'München',    'Deutschland', 'Gold'),
('Petra',     'Neumann',    'petra.n@freenet.de',      '+49 155 606060', '2024-01-05', 'Berlin',     'Deutschland', 'Bronze');


-- ORDERS (30 rows)

INSERT INTO orders (customer_id, order_date, status) VALUES
(1,'2022-02-10','Delivered'),(1,'2022-06-15','Delivered'),(1,'2022-11-20','Delivered'),
(2,'2022-04-05','Delivered'),(2,'2023-01-10','Delivered'),
(3,'2022-06-20','Delivered'),(3,'2023-03-15','Delivered'),
(4,'2022-08-01','Delivered'),
(5,'2022-09-20','Delivered'),(5,'2023-05-10','Delivered'),
(6,'2022-12-01','Delivered'),
(7,'2023-01-05','Delivered'),(7,'2023-08-20','Delivered'),
(8,'2023-02-14','Delivered'),(8,'2023-07-01','Delivered'),(8,'2024-01-10','Delivered'),
(9,'2023-03-20','Delivered'),
(10,'2023-04-01','Shipped'),
(11,'2023-06-15','Delivered'),(11,'2023-12-20','Delivered'),
(12,'2023-07-30','Cancelled'),
(13,'2023-09-14','Delivered'),
(14,'2023-10-01','Delivered'),(14,'2024-02-14','Processing'),
(15,'2024-01-20','Pending'),
(1,'2024-03-01','Delivered'),
(2,'2024-03-15','Shipped'),
(8,'2024-04-01','Processing'),
(3,'2024-04-10','Pending'),
(7,'2024-04-15','Pending');


-- ORDER ITEMS

INSERT INTO order_items (order_id, product_id, quantity, unit_price_at_time, discount_percent) VALUES
(1,1,1,1299.99,0.00),(1,2,2,29.99,5.00),
(2,5,1,449.99,10.00),(2,18,4,29.99,0.00),
(3,3,1,49.99,0.00),(3,16,1,149.99,5.00),
(4,4,1,89.99,0.00),(4,11,1,49.99,0.00),
(5,1,1,1299.99,15.00),
(6,8,3,34.99,0.00),(6,9,2,79.99,5.00),
(7,6,1,119.99,0.00),(7,15,2,19.99,0.00),
(8,12,1,129.99,0.00),(8,13,2,59.99,10.00),
(9,17,1,299.99,0.00),(9,19,1,34.99,0.00),
(10,16,1,149.99,5.00),(10,20,1,49.99,0.00),
(11,10,1,24.99,0.00),(11,14,2,24.99,0.00),
(12,1,1,1299.99,20.00),
(13,3,2,49.99,0.00),(13,4,1,89.99,5.00),
(14,5,2,449.99,10.00),
(15,1,1,1299.99,0.00),(15,17,1,299.99,0.00),
(16,2,5,29.99,5.00),(16,18,10,29.99,10.00),
(17,7,1,199.99,0.00),(17,6,1,119.99,5.00),
(18,11,1,49.99,0.00),
(19,8,5,34.99,0.00),(19,9,3,79.99,5.00),
(20,6,2,119.99,10.00),
(21,12,1,129.99,0.00),
(22,16,1,149.99,0.00),(22,17,1,299.99,5.00),
(23,1,1,1299.99,0.00),(23,3,2,49.99,0.00),
(24,5,1,449.99,0.00),
(25,10,2,24.99,0.00),(25,15,3,19.99,0.00),
(26,2,3,29.99,0.00),(26,18,6,29.99,5.00),
(27,4,1,89.99,0.00),
(28,1,1,1299.99,0.00),
(29,7,1,199.99,0.00),
(30,11,1,49.99,0.00);


-- INVENTORY LOG

INSERT INTO inventory_log (product_id, change_date, previous_stock, new_stock, change_reason, changed_by) VALUES
(1,'2022-01-01',0,50,'Initial stock','System'),
(1,'2022-02-11',50,49,'Order #1 fulfilled','Warehouse'),
(2,'2022-01-01',0,200,'Initial stock','System'),
(5,'2022-01-01',0,30,'Initial stock','System'),
(5,'2022-06-16',30,29,'Order #2 fulfilled','Warehouse'),
(17,'2023-01-01',0,30,'Initial stock','System'),
(17,'2023-03-21',30,29,'Order #9 fulfilled','Warehouse');

-- Verify row counts
SELECT 'suppliers'      AS tbl, COUNT(*) AS rows FROM suppliers   UNION ALL
SELECT 'customers',            COUNT(*)           FROM customers   UNION ALL
SELECT 'products',             COUNT(*)           FROM products    UNION ALL
SELECT 'orders',               COUNT(*)           FROM orders      UNION ALL
SELECT 'order_items',          COUNT(*)           FROM order_items UNION ALL
SELECT 'inventory_log',        COUNT(*)           FROM inventory_log;    