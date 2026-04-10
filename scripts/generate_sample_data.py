# Author: oneaarmdeveloper
# Goals: Generate 1000+ rows of realistic retail data for testing
# Date: 09.04.2026
# Purpose: Scale retail_analytics database with synthetic German data

import os
import random
import mysql.connector
from dotenv import load_dotenv
from faker import Faker
from datetime import date, timedelta

load_dotenv()

DB_CONFIG = {
    'host': 'localhost',
    'user': 'root',
    'password': os.getenv('MYSQL_PASSWORD'),
    'database': 'retail_analytics'
}

NUM_CUSTOMERS = 2000
NUM_ORDERS = 5000
NUM_ITEMS_MAX = 5
BATCH_SIZE_CUSTOMERS = 500
BATCH_SIZE_ORDERS = 1000
BATCH_SIZE_ITEMS = 5000

fake = Faker('de_DE')
random.seed(42)

print("=" * 60)
print("Enterprise Retail Analytics - Data Generator")
print("=" * 60)

try:
    print("\n[1/5] Connecting to MySQL...")
    conn = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor()
    print("Connected")

    def random_date(start_year=2020, end_year=2024):
        start = date(start_year, 1, 1)
        end = date(end_year, 12, 31)
        return start + timedelta(days=random.randint(0, (end - start).days))

    # Load existing products
    cursor.execute("SELECT product_id, unit_price FROM products")
    products_data = cursor.fetchall()
    product_ids = [r[0] for r in products_data]
    product_prices = {r[0]: r[1] for r in products_data}

    if not product_ids:
        print("ERROR: No products found! Run schema/04_seed_data.sql first")
        exit(1)

    # Generate customers
    print(f"\n[2/5] Generating {NUM_CUSTOMERS} customers...")
    cities = ['München', 'Berlin', 'Hamburg', 'Köln', 'Frankfurt', 'Stuttgart',
              'Düsseldorf', 'Leipzig', 'Dortmund', 'Essen', 'Bremen',
              'Dresden', 'Hannover', 'Nürnberg', 'Duisburg']
    tiers = ['Bronze', 'Bronze', 'Bronze', 'Silver', 'Silver', 'Gold', 'Platinum']

    batch = []
    used_emails = set()

    for i in range(NUM_CUSTOMERS):
        first = fake.first_name()
        last = fake.last_name()
        email = f"{first.lower()}.{last.lower()}{random.randint(1,999)}@{fake.free_email_domain()}"
        while email in used_emails:
            email = f"{first.lower()}.{last.lower()}{random.randint(1,9999)}@{fake.free_email_domain()}"
        used_emails.add(email)

        batch.append((
            first, last, email,
            fake.phone_number()[:20],
            random_date(2018, 2023),
            random.choice(cities),
            'Deutschland',
            random.choice(tiers),
            True
        ))

        if len(batch) == BATCH_SIZE_CUSTOMERS:
            cursor.executemany(
                """INSERT INTO customers
                   (first_name, last_name, email, phone, registration_date, city, country, customer_tier, is_active)
                   VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)""",
                batch
            )
            conn.commit()
            batch = []
            print(f"{i+1} customers inserted...")

    if batch:
        cursor.executemany(
            """INSERT INTO customers
               (first_name, last_name, email, phone, registration_date, city, country, customer_tier, is_active)
               VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)""",
            batch
        )
        conn.commit()

    # Load customer IDs for orders
    cursor.execute("SELECT customer_id FROM customers")
    customer_ids = [r[0] for r in cursor.fetchall()]

    # Generate orders
    print(f"\n[3/5] Generating {NUM_ORDERS} orders...")
    statuses = ['Delivered', 'Delivered', 'Delivered', 'Delivered',
                'Shipped', 'Processing', 'Pending', 'Cancelled']
    batch = []

    for i in range(NUM_ORDERS):
        batch.append((
            random.choice(customer_ids),
            random_date(2020, 2024),
            random.choice(statuses)
        ))
        if len(batch) == BATCH_SIZE_ORDERS:
            cursor.executemany(
                "INSERT INTO orders (customer_id, order_date, status) VALUES (%s, %s, %s)",
                batch
            )
            conn.commit()
            batch = []
            print(f"{i+1} orders inserted...")

    if batch:
        cursor.executemany(
            "INSERT INTO orders (customer_id, order_date, status) VALUES (%s, %s, %s)",
            batch
        )
        conn.commit()
    print(f"{NUM_ORDERS} orders done!")

    # Generate order items
    print(f"\n[4/5] Generating order items...")
    cursor.execute("SELECT order_id FROM orders ORDER BY order_id DESC LIMIT %s", (NUM_ORDERS,))
    all_order_ids = [r[0] for r in cursor.fetchall()]
    discount_odds = [0, 0, 0, 0, 5, 10, 15, 20]
    item_batch = []
    total_items = 0

    for order_id in all_order_ids:
        num_items = random.randint(1, min(NUM_ITEMS_MAX, len(product_ids)))
        chosen = random.sample(product_ids, num_items)
        for pid in chosen:
            qty = random.randint(1, 10)
            price = round(product_prices.get(pid, 29.99), 2)
            discount = random.choice(discount_odds)
            item_batch.append((order_id, pid, qty, price, discount))
            total_items += 1

        if len(item_batch) >= BATCH_SIZE_ITEMS:
            cursor.executemany(
                """INSERT INTO order_items
                   (order_id, product_id, quantity, unit_price_at_time, discount_percent)
                   VALUES (%s, %s, %s, %s, %s)""",
                item_batch
            )
            conn.commit()
            item_batch = []
            print(f"{total_items} items inserted...")

    if item_batch:
        cursor.executemany(
            """INSERT INTO order_items
               (order_id, product_id, quantity, unit_price_at_time, discount_percent)
               VALUES (%s, %s, %s, %s, %s)""",
            item_batch
        )
        conn.commit()
    print(f"{total_items} order items done!")

    # Final summary
    print(f"\n[5/5] Final summary")
    for t in ['customers', 'orders', 'order_items', 'products', 'suppliers', 'inventory_log']:
        cursor.execute(f"SELECT COUNT(*) FROM {t}")
        print(f"{t:<20} {cursor.fetchone()[0]:>10,} rows")

    print("\n" + "=" * 60)
    print("Data generation complete")
    print("The database now has enterprise-scale synthetic data.")
    print("=" * 60)

except mysql.connector.Error as err:
    print(f"Database error: {err}")
    if 'conn' in locals() and conn:
        conn.rollback()
except Exception as e:
    print(f"Unexpected error: {e}")
    if 'conn' in locals() and conn:
        conn.rollback()
finally:
    if 'cursor' in locals() and cursor:
        cursor.close()
    if 'conn' in locals() and conn and conn.is_connected():
        conn.close()
    print("\nConnection closed")

    