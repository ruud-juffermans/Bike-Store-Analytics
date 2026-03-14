-- =============================================
-- bike_store_source: relational source data
-- =============================================

-- Brands
CREATE TABLE brands (
    brand_id   INTEGER PRIMARY KEY,
    brand_name VARCHAR(100) NOT NULL
);

-- Categories
CREATE TABLE categories (
    category_id   INTEGER PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);

-- Stores
CREATE TABLE stores (
    store_id   INTEGER PRIMARY KEY,
    store_name VARCHAR(100) NOT NULL,
    phone      VARCHAR(25),
    email      VARCHAR(100),
    street     VARCHAR(200),
    city       VARCHAR(100),
    state      VARCHAR(10),
    zip_code   VARCHAR(10)
);

-- Staffs
CREATE TABLE staffs (
    staff_id   INTEGER PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name  VARCHAR(50) NOT NULL,
    email      VARCHAR(100) NOT NULL,
    phone      VARCHAR(25),
    active     INTEGER NOT NULL,
    store_id   INTEGER NOT NULL REFERENCES stores(store_id),
    manager_id INTEGER REFERENCES staffs(staff_id)
);

-- Customers
CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    first_name  VARCHAR(50) NOT NULL,
    last_name   VARCHAR(50) NOT NULL,
    phone       VARCHAR(25),
    email       VARCHAR(100) NOT NULL,
    street      VARCHAR(200),
    city        VARCHAR(100),
    state       VARCHAR(10),
    zip_code    VARCHAR(10)
);

-- Products
CREATE TABLE products (
    product_id   INTEGER PRIMARY KEY,
    product_name VARCHAR(200) NOT NULL,
    brand_id     INTEGER NOT NULL REFERENCES brands(brand_id),
    category_id  INTEGER NOT NULL REFERENCES categories(category_id),
    model_year   INTEGER NOT NULL,
    list_price   NUMERIC(10,2) NOT NULL
);

-- Orders
CREATE TABLE orders (
    order_id      INTEGER PRIMARY KEY,
    customer_id   INTEGER NOT NULL REFERENCES customers(customer_id),
    order_status  INTEGER NOT NULL,
    order_date    DATE NOT NULL,
    required_date DATE NOT NULL,
    shipped_date  DATE,
    store_id      INTEGER NOT NULL REFERENCES stores(store_id),
    staff_id      INTEGER NOT NULL REFERENCES staffs(staff_id)
);

-- Order Items
CREATE TABLE order_items (
    order_id   INTEGER NOT NULL REFERENCES orders(order_id),
    item_id    INTEGER NOT NULL,
    product_id INTEGER NOT NULL REFERENCES products(product_id),
    quantity   INTEGER NOT NULL,
    list_price NUMERIC(10,2) NOT NULL,
    discount   NUMERIC(4,2) NOT NULL DEFAULT 0,
    PRIMARY KEY (order_id, item_id)
);

-- Stocks
CREATE TABLE stocks (
    store_id   INTEGER NOT NULL REFERENCES stores(store_id),
    product_id INTEGER NOT NULL REFERENCES products(product_id),
    quantity   INTEGER NOT NULL,
    PRIMARY KEY (store_id, product_id)
);

-- Load CSV data (order matters for foreign key constraints)
\copy brands      FROM '/data/brands.csv'      WITH CSV HEADER;
\copy categories  FROM '/data/categories.csv'   WITH CSV HEADER;
\copy stores      FROM '/data/stores.csv'       WITH CSV HEADER;
\copy staffs      FROM '/data/staffs.csv'       WITH CSV HEADER NULL 'NULL';
\copy customers   FROM '/data/customers.csv'    WITH CSV HEADER NULL 'NULL';
\copy products    FROM '/data/products.csv'     WITH CSV HEADER;
\copy orders      FROM '/data/orders.csv'       WITH CSV HEADER NULL 'NULL';
\copy order_items FROM '/data/order_items.csv'  WITH CSV HEADER;
\copy stocks      FROM '/data/stocks.csv'       WITH CSV HEADER;
