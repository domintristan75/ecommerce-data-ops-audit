# Olist E-Commerce Data Operations & Supply Chain Audit

## Executive Summary
An operational database audit conducted on 100,000+ relational e-commerce records using SQLite. The objective was to isolate catalog data defects and pinpoint specific vendor supply chain bottlenecks.

## Key Audit Diagnostics

### 1. Catalog Hygiene & Physical Attributes
* **Flagged Records:** Identified **26 order items** with `NULL` or `0g` weight values in the product catalog.
* **Operational Impact:** Missing mass metrics break automated carrier freight pricing and logistics dispatches.

### 2. Fulfillment Bottleneck Analysis
* **Delivery Scope:** Filtered customer orders where `order_delivered_customer_date` exceeded `order_estimated_delivery_date` using `JULIANDAY` date arithmetic.
* **Primary Vendor Risk:** Isolated **Seller ID `656001a63d10e512058f5c7afd21e123`** as the main fulfillment failure point.
* **Impact Metrics:** Accounted for **214 severely delayed orders**, averaging 10.5 days late past the promised delivery window.

## Repository Contents
* `01_supply_chain_audit.sql`: Pure SQL script containing catalog null checks, multi-table JOINs, date differential calculations, and seller-level aggregations.
