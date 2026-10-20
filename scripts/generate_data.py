"""Generate synthetic e-commerce data: customers, products, orders."""
import csv, random
from datetime import date, timedelta

random.seed(42)

OUT = "/home/hatch/workspace/goals/become-a-true-analytics-engineer/dbt-ecommerce/seeds"

FIRST = ["James","Mary","Robert","Patricia","John","Jennifer","Michael","Linda","David","Elizabeth",
         "William","Barbara","Richard","Susan","Joseph","Jessica","Thomas","Sarah","Charles","Karen",
         "Daniel","Nancy","Matthew","Lisa","Anthony","Betty","Mark","Margaret","Donald","Sandra"]
LAST = ["Smith","Johnson","Williams","Brown","Jones","Garcia","Miller","Davis","Rodriguez","Martinez",
        "Hernandez","Lopez","Gonzalez","Wilson","Anderson","Thomas","Taylor","Moore","Jackson","Martin"]
REGIONS = ["Midwest","Northeast","South","West"]
SEGMENTS = ["new","returning","vip","lapsed"]
CATEGORIES = {
    "Electronics": ["Wireless Headphones","Smart Speaker","USB-C Hub","Mechanical Keyboard","4K Monitor",
                    "Bluetooth Tracker","Portable Charger","Noise-Cancelling Earbuds","Smart Watch","Tablet Stand"],
    "Apparel": ["Graphic Tee","Denim Jacket","Running Shoes","Wool Socks 3-Pack","Hoodie",
                "Chino Pants","Baseball Cap","Rain Jacket","Yoga Leggings","Flannel Shirt"],
    "Home & Kitchen": ["Cast Iron Skillet","Pour-Over Coffee Set","Robot Vacuum","Air Fryer","Duvet Cover Set",
                       "Chef's Knife","Stand Mixer","LED Desk Lamp","Storage Ottoman","Bamboo Cutting Board"],
    "Sports": ["Yoga Mat","Dumbbell Set","Insulated Water Bottle","Resistance Bands","Camping Tent",
               "Pickleball Paddles","Foam Roller","Hiking Backpack","Jump Rope","Cooler 45qt"],
    "Beauty": ["Vitamin C Serum","Moisturizer SPF 30","Clay Mask","Hair Dryer","Lip Tint Set",
               "Body Lotion","Face Roller","Dry Shampoo","Eyelash Curler","Hand Cream Trio"],
    "Books": ["Mystery Novel","Cookbook","Sci-Fi Paperback","Business Bestseller","Children's Picture Book",
              "History Hardcover","Poetry Collection","Travel Guide","Graphic Novel","Memoir"],
}

def rand_date(start, end):
    return start + timedelta(days=random.randint(0, (end - start).days))

# ---- customers ----
customers = []
for i in range(1, 1001):
    fn, ln = random.choice(FIRST), random.choice(LAST)
    email = f"{fn.lower()}.{ln.lower()}{random.randint(1,99)}@example.com"
    if random.random() < 0.02:  # a little mess for staging to clean
        email = None
    customers.append({
        "customer_id": i,
        "first_name": fn, "last_name": ln, "email": email,
        "signup_date": rand_date(date(2022,1,1), date(2025,6,30)).isoformat(),
        "region": random.choice(REGIONS),
        "customer_segment": random.choice(SEGMENTS),
    })

# ---- products ----
products, pid = [], 1
for cat, names in CATEGORIES.items():
    for name in names:
        base = round(random.uniform(9.99, 399.99), 2)
        products.append({
            "product_id": pid, "product_name": name, "category": cat,
            "unit_price": base,
            "created_date": rand_date(date(2021,1,1), date(2024,12,31)).isoformat(),
        })
        pid += 1

# ---- orders ----
statuses = ["delivered"]*70 + ["shipped"]*12 + ["pending"]*8 + ["cancelled"]*6 + ["returned"]*4
orders = []
for oid in range(1, 8001):
    c = random.choice(customers); p = random.choice(products)
    qty = random.randint(1, 4)
    status = random.choice(statuses)
    if random.random() < 0.03:  # messy casing for staging to normalize
        status = status.upper()
    orders.append({
        "order_id": oid,
        "customer_id": c["customer_id"],
        "product_id": p["product_id"],
        "order_date": rand_date(date(2024,1,1), date(2026,9,30)).isoformat(),
        "quantity": qty,
        "unit_price": p["unit_price"],
        "discount_pct": random.choice([0,0,0,0,0.05,0.10,0.15,0.20]),
        "status": status,
    })

import os
os.makedirs(OUT, exist_ok=True)
for name, rows in [("raw_customers", customers), ("raw_products", products), ("raw_orders", orders)]:
    with open(f"{OUT}/{name}.csv","w",newline="") as f:
        w = csv.DictWriter(f, fieldnames=list(rows[0].keys()))
        w.writeheader(); w.writerows(rows)
    print(name, len(rows), "rows")
