-- Q1: Orders that are still being processed.
SELECT c.full_name, o.order_id, p.name AS product_name, o.status
FROM public.order o
JOIN public.customer c USING (customer_id)
JOIN public.order_item oi USING (order_id)
JOIN public.product p USING (product_id)
WHERE o.status IN ('Pending', 'Processing')
ORDER BY o.order_id;

-- Q2: A product is available when its stock quantity is greater than zero.
SELECT p.product_id, p.name, p.price, p.stock_quantity
FROM public.product p
WHERE p.stock_quantity > 0
ORDER BY p.product_id;

-- Q3: Count each customer's orders, including customers with no orders.
-- LEFT JOIN also keeps customers who have not placed any orders.
SELECT c.full_name, COUNT(o.order_id) AS total_orders
FROM public.customer c
LEFT JOIN public.order o USING (customer_id)
GROUP BY c.customer_id, c.full_name
ORDER BY c.full_name;