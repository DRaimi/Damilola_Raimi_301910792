# E-commerce Platform Constraint Tests

```sql
-- Run each statement separately after SampleData.sql.
-- Each INSERT is deliberately invalid and should produce an ERROR.
-- Use the normal PostgreSQL prompt, outside BEGIN/COMMIT.

-- 1. A required customer full_name cannot be missing.
INSERT INTO public.customer (customer_id, full_name, email)
OVERRIDING SYSTEM VALUE
VALUES (3, NULL, 'missing@example.com');

-- 2. An existing customer's email cannot be used by another customer.
INSERT INTO public.customer (customer_id, full_name, email)
OVERRIDING SYSTEM VALUE
VALUES (3, 'Test Customer', 'king@example.com');

-- 3. An order item cannot reference a product that does not exist.
INSERT INTO public.order_item
(order_item_id, order_id, product_id, quantity, unit_price)
OVERRIDING SYSTEM VALUE
VALUES (1004, 101, 999, 1, 25.00);

-- 4. An order item must have a quantity greater than zero.
INSERT INTO public.order_item
(order_item_id, order_id, product_id, quantity, unit_price)
OVERRIDING SYSTEM VALUE
VALUES (1004, 101, 10, 0, 25.00);

-- 5. An order item cannot have a negative unit price.
INSERT INTO public.order_item
(order_item_id, order_id, product_id, quantity, unit_price)
OVERRIDING SYSTEM VALUE
VALUES (1004, 101, 10, 1, -25.00);

-- 6. The same product cannot be added twice as separate items
-- within the same order. Order 101 already contains product 10.
INSERT INTO public.order_item
(order_item_id, order_id, product_id, quantity, unit_price)
OVERRIDING SYSTEM VALUE
VALUES (1004, 101, 10, 1, 25.00);

-- Failed inserts must not change these counts:
-- customer 2, product 2, order 2, order_item 3, payment 1.

SELECT 'customer' AS table_name, COUNT(*) AS row_count
FROM public.customer
UNION ALL
SELECT 'product', COUNT(*) FROM public.product
UNION ALL
SELECT 'order', COUNT(*) FROM public.order
UNION ALL
SELECT 'order_item', COUNT(*) FROM public.order_item
UNION ALL
SELECT 'payment', COUNT(*) FROM public.payment;
```
