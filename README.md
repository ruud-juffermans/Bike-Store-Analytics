# Bike Store Analytics — End-to-End Data Warehouse

An end-to-end analytics engineering project that transforms raw bike store transactional data into a **star schema data warehouse** using Docker, PostgreSQL, Python, dbt, and Apache Superset.
The project demonstrates a complete modern data stack: containerized infrastructure, EL pipelines, dimensional modeling, automated testing, and self-service BI dashboards.

## Architecture

```
┌──────────────────┐     ┌──────────────────┐     ┌──────────────────┐     ┌──────────────────┐
│  primary-system  │     │   orchestrator   │     │   datawarehouse  │     │     superset      │
│                  │     │                  │     │                  │     │                   │
│  Source DB       │────▶│  Python EL       │────▶│  raw (tables)    │     │  Dashboards       │
│  (PostgreSQL)    │     │  pipeline        │     │  staging (views) │────▶│  (Apache Superset) │
│                  │     │                  │     │  marts (tables)  │     │                   │
│  9 CSV tables    │     │  dbt-core        │     │                  │     │  http://localhost  │
│  with FKs        │     │  inspect scripts │     │  Star schema     │     │  :8088             │
└──────────────────┘     └──────────────────┘     └──────────────────┘     └──────────────────┘
     Port 5433                                         Port 5434               Port 8088
```

### Data Flow

```
CSV Files → Source DB → [EL Pipeline] → Warehouse raw schema
                                              ↓
                                        dbt staging (clean, cast, rename)
                                              ↓
                                        dbt marts (star schema)
                                              ↓
                                        mart_sales_overview (wide table)
                                              ↓
                                        Superset dashboards
```

## Tech Stack

| Layer | Tool | Purpose |
|-------|------|---------|
| Containerization | Docker + Docker Compose | All services containerized |
| Source Database | PostgreSQL 16 | OLTP transactional data |
| Warehouse Database | PostgreSQL 16 | Analytical data warehouse |
| EL Pipeline | Python + psycopg2 | Extract from source, load to warehouse |
| Transformation | dbt-core + dbt-postgres | Staging views, dimensional models, tests |
| BI / Visualization | Apache Superset | Interactive dashboards |