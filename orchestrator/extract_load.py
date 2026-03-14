"""
Extract data from the source database and load it into the warehouse raw schema.
"""

import psycopg2
import os
import sys
import time

SOURCE_DB = {
    "host": "primary_system",
    "port": 5432,
    "dbname": "primary_system",
    "user": "primary_user",
    "password": "primary_pass",
}

WAREHOUSE_DB = {
    "host": "warehouse_db",
    "port": 5432,
    "dbname": "warehouse_db",
    "user": "warehouse_user",
    "password": "warehouse_pass",
}

TABLES = [
    "brands",
    "categories",
    "stores",
    "staffs",
    "customers",
    "products",
    "orders",
    "order_items",
    "stocks",
]


def get_columns(cursor, table):
    """Get column names for a table."""
    cursor.execute(
        """
        SELECT column_name
        FROM information_schema.columns
        WHERE table_schema = 'public' AND table_name = %s
        ORDER BY ordinal_position
        """,
        (table,),
    )
    return [row[0] for row in cursor.fetchall()]


def extract_load(table, source_conn, warehouse_conn):
    """Extract a table from source and load into warehouse raw schema."""
    src_cur = source_conn.cursor()
    wh_cur = warehouse_conn.cursor()

    # Get column definitions from source
    columns = get_columns(src_cur, table)
    col_list = ", ".join(columns)

    # Read all rows from source
    src_cur.execute(f"SELECT {col_list} FROM public.{table}")
    rows = src_cur.fetchall()

    # Truncate and reload in warehouse
    wh_cur.execute(f"TRUNCATE TABLE raw.{table} CASCADE")
    if rows:
        placeholders = ", ".join(["%s"] * len(columns))
        insert_sql = f"INSERT INTO raw.{table} ({col_list}) VALUES ({placeholders})"
        wh_cur.executemany(insert_sql, rows)

    warehouse_conn.commit()
    print(f"  {table}: {len(rows)} rows loaded")


def main():
    print("=" * 50)
    print("Pipeline: Extract from Source → Load to Warehouse")
    print("=" * 50)

    source_conn = psycopg2.connect(**SOURCE_DB)
    warehouse_conn = psycopg2.connect(**WAREHOUSE_DB)

    # Create raw schema and tables in warehouse
    print("\nCreating raw schema in warehouse...")
    with open("/orchestrator/raw_schema.sql", "r") as f:
        warehouse_conn.cursor().execute(f.read())
    warehouse_conn.commit()
    print("[OK] Raw schema ready.")

    # Extract and load each table
    print("\nLoading tables...")
    for table in TABLES:
        extract_load(table, source_conn, warehouse_conn)

    source_conn.close()
    warehouse_conn.close()
    print("\n[DONE] Pipeline completed successfully.")


if __name__ == "__main__":
    main()
