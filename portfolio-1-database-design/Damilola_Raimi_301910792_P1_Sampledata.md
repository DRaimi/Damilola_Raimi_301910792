# E-commerce Platform Sample Data

The following SQL script populates the schema with valid records for **King Fisher** and **Claire Smith** using dynamic subquery lookups to reference generated Primary Keys

```sql
BEGIN;

-- 1. Insert Customers
INSERT INTO public.customer (email, full_name)
VALUES
('king@example.com', 'King Fisher'),
('claire@example.com', 'Claire Smith');

-- 2. Insert Products
INSERT INTO public.product (name, price, stock_quantity)
VALUES
('Wireless Mouse', 25.00, 50),
('Mechanical Keyboard', 85.00, 30);

-- 3. Insert Customer Orders
INSERT INTO public.order (customer_id, status, created_at)
VALUES
(
    (SELECT customer_id FROM public.customer
     WHERE email = 'king@example.com'),
    'Pending',
    '2026-10-29 10:00:00+00'
),
(
    (SELECT customer_id FROM public.customer
     WHERE email = 'claire@example.com'),
    'Shipped',
    '2026-10-29 11:30:00+00'
);

-- 4. Insert Order Items
INSERT INTO public.order_item (order_id, product_id, quantity, unit_price)
VALUES
(
    (SELECT order_id FROM public.order
     WHERE customer_id = (
         SELECT customer_id FROM public.customer
         WHERE email = 'king@example.com'
     ) AND status = 'Pending'),
    (SELECT product_id FROM public.product
     WHERE name = 'Wireless Mouse'),
    2,
    25.00
),
(
    (SELECT order_id FROM public.order
     WHERE customer_id = (
         SELECT customer_id FROM public.customer
         WHERE email = 'king@example.com'
     ) AND status = 'Pending'),
    (SELECT product_id FROM public.product
     WHERE name = 'Mechanical Keyboard'),
    1,
    85.00
),
(
    (SELECT order_id FROM public.order
     WHERE customer_id = (
         SELECT customer_id FROM public.customer
         WHERE email = 'claire@example.com'
     ) AND status = 'Shipped'),
    (SELECT product_id FROM public.product
     WHERE name = 'Wireless Mouse'),
    1,
    25.00
);

-- 5. Insert Payment Records
INSERT INTO public.payment (order_id, amount, payment_date)
VALUES
(
    (SELECT order_id FROM public.order
     WHERE customer_id = (
         SELECT customer_id FROM public.customer
         WHERE email = 'king@example.com'
     ) AND status = 'Pending'),
    135.00,
    '2026-10-29 10:05:00+00'
),
(
    (SELECT order_id FROM public.order
     WHERE customer_id = (
         SELECT customer_id FROM public.customer
         WHERE email = 'claire@example.com'
     ) AND status = 'Shipped'),
    25.00,
    '2026-10-29 11:35:00+00'
);

COMMIT;
```
