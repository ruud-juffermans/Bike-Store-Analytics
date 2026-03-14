-- Raw schema in warehouse: mirrors source tables structure
CREATE SCHEMA IF NOT EXISTS raw;

CREATE TABLE IF NOT EXISTS raw.brands (
    brand_id   INTEGER PRIMARY KEY,
    brand_name VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS raw.categories (
    category_id   INTEGER PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS raw.stores (
    store_id   INTEGER PRIMARY KEY,
    store_name VARCHAR(100) NOT NULL,
    phone      VARCHAR(25),
    email      VARCHAR(100),
    street     VARCHAR(200),
    city       VARCHAR(100),
    state      VARCHAR(10),
    zip_code   VARCHAR(10)
);

CREATE TABLE IF NOT EXISTS raw.staffs (
    staff_id   INTEGER PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name  VARCHAR(50) NOT NULL,
    email      VARCHAR(100) NOT NULL,
    phone      VARCHAR(25),
    active     INTEGER NOT NULL,
    store_id   INTEGER NOT NULL,
    manager_id INTEGER
);

CREATE TABLE IF NOT EXISTS raw.customers (
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

CREATE TABLE IF NOT EXISTS raw.products (
    product_id   INTEGER PRIMARY KEY,
    product_name VARCHAR(200) NOT NULL,
    brand_id     INTEGER NOT NULL,
    category_id  INTEGER NOT NULL,
    model_year   INTEGER NOT NULL,
    list_price   NUMERIC(10,2) NOT NULL
);

CREATE TABLE IF NOT EXISTS raw.orders (
    order_id      INTEGER PRIMARY KEY,
    customer_id   INTEGER NOT NULL,
    order_status  INTEGER NOT NULL,
    order_date    DATE NOT NULL,
    required_date DATE NOT NULL,
    shipped_date  DATE,
    store_id      INTEGER NOT NULL,
    staff_id      INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS raw.order_items (
    order_id   INTEGER NOT NULL,
    item_id    INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity   INTEGER NOT NULL,
    list_price NUMERIC(10,2) NOT NULL,
    discount   NUMERIC(4,2) NOT NULL DEFAULT 0,
    PRIMARY KEY (order_id, item_id)
);

CREATE TABLE IF NOT EXISTS raw.stocks (
    store_id   INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity   INTEGER NOT NULL,
    PRIMARY KEY (store_id, product_id)
);
