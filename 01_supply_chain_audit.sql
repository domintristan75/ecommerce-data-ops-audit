-- =========================================================
-- PROJECT: Olist Supply Chain & Data Hygiene Audit
-- SCRIPT: 01_supply_chain_audit.sql
-- =========================================================

-- Query 1: Basic Table Validation
-- SELECT order_id, product_id, seller_id FROM order_items LIMIT 10;


-- Query 2: Product Weight Cross-Reference (JOIN)
SELECT 
    i.order_id,
    i.product_id,
    i.seller_id,
    p.product_weight_g
FROM order_items i
LEFT JOIN products p 
    ON i.product_id = p.product_id
LIMIT 10;

-- Query 3: Filter for Null and 0 values
SELECT 
    i.order_id,
    i.product_id,
    i.seller_id,
    p.product_weight_g
FROM order_items i
LEFT JOIN products p
    ON i.product_id = p.product_id
WHERE p.product_weight_g IS NULL 
    OR p.product_weight_g = 0

26 missing and null values found