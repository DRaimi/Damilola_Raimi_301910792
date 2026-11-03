-- Run this setup once. The original e-commerce tables remain unchanged. 
-- The benchmark table is stored separately in `p2_benchmark`.

CREATE SCHEMA p2_benchmark;
-- Create 100,000 synthetic e-commerce order-history records.
-- Existing customer and product IDs are reused.
-- Timestamps are one hour apart.
-- These records are for benchmarking only, not real orders.

CREATE TABLE p2_benchmark.order_history AS
SELECT
    g AS history_id,
    c.customer_id,
    p.product_id,
    TIMESTAMPTZ '2000-01-01 00:00:00+00'
        + g * INTERVAL '1 hour' AS activity_at,
    (ARRAY['Pending', 'Processing', 'Shipped', 'Delivered'])
        [((g - 1) % 4) + 1] AS order_status
FROM generate_series(1, 100000) AS g
CROSS JOIN LATERAL (
    SELECT customer_id
    FROM public.customer
    ORDER BY customer_id
    LIMIT 1
    OFFSET ((g - 1) % (SELECT COUNT(*) FROM public.customer))
) AS c
CROSS JOIN LATERAL (
    SELECT product_id
    FROM public.product
    ORDER BY product_id
    LIMIT 1
    OFFSET ((g - 1) % (SELECT COUNT(*) FROM public.product))
) AS p;

-- Help PostgreSQL choose how to search the test table.
ANALYZE p2_benchmark.order_history;
```
-- Count query: Check the test data

The first query checks the total number of synthetic records. The second checks the records created on 1 January 2005.

-- Expected: 100,000 records.
SELECT COUNT(*) AS test_rows
FROM p2_benchmark.order_history;

-- Expected: 24 matching records.
SELECT COUNT(*) AS orders_on_day
FROM p2_benchmark.order_history
WHERE activity_at >= TIMESTAMPTZ '2005-01-01 00:00:00+00'
  AND activity_at < TIMESTAMPTZ '2005-01-02 00:00:00+00';
```
-- Before indexing: Baseline execution plan
Run the following identical query four times.

* Run 1: Warm-up. Ignore the execution time.
* Run 2-4: Record the three execution times in milliseconds.

EXPLAIN (ANALYZE, BUFFERS)
SELECT COUNT(*) AS orders_on_day
FROM p2_benchmark.order_history
WHERE activity_at >= TIMESTAMPTZ '2005-01-01 00:00:00+00'
  AND activity_at < TIMESTAMPTZ '2005-01-02 00:00:00+00';

-- After indexing: Execution plan
Run the following identical query four times.
-- Create a B-tree index on the activity timestamp.
CREATE INDEX order_history_activity_at_idx
ON p2_benchmark.order_history (activity_at);

-- Refresh table statistics.
ANALYZE p2_benchmark.order_history;

EXPLAIN (ANALYZE, BUFFERS)
SELECT COUNT(*) AS orders_on_day
FROM p2_benchmark.order_history
WHERE activity_at >= TIMESTAMPTZ '2005-01-01 00:00:00+00'
  AND activity_at < TIMESTAMPTZ '2005-01-02 00:00:00+00';