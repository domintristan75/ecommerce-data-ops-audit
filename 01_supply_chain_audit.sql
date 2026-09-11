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

-- =========================================================
-- AUDIT TASK 2: Fulfillment Delay & Bottleneck Analysis
-- =========================================================

-- Query 1: Isolate Severe Delivery Delays
-- Objective: Calculate exact days delayed past estimated delivery date for late shipments.
-- Finding: Identified thousands of delayed shipments spanning from several days to months past estimate.

SELECT 
    i.order_id,
    i.seller_id,
    o.order_estimated_delivery_date,
    o.order_delivered_customer_date,
    ROUND(JULIANDAY(o.order_delivered_customer_date) - JULIANDAY(o.order_estimated_delivery_date), 1) AS days_delayed
FROM order_items i
JOIN orders o 
    ON i.order_id = o.order_id
WHERE o.order_delivered_customer_date > o.order_estimated_delivery_date
ORDER BY days_delayed DESC;


-- Query 2: Aggregate Delays by Seller (Root Cause Analysis)
-- Objective: Group late orders by seller to flag repeat offenders responsible for fulfillment bottlenecks.
-- Filtering Condition: Only include sellers with 5 or more total late shipments.

SELECT 
    i.seller_id,
    COUNT(i.order_id) AS total_delayed_orders,
    ROUND(AVG(JULIANDAY(o.order_delivered_customer_date) - JULIANDAY(o.order_estimated_delivery_date)), 1) AS avg_days_late
FROM order_items i
JOIN orders o 
    ON i.order_id = o.order_id
WHERE o.order_delivered_customer_date > o.order_estimated_delivery_date
GROUP BY i.seller_id
HAVING total_delayed_orders >= 5
ORDER BY total_delayed_orders DESC;
