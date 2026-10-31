-- Start from the Portfolio 1 sample data. Run the sections in order, once.
-- Commit an order status update for order 101.The Processing condition ensures only an order awaiting shipment is updated.

BEGIN;

UPDATE public.order
SET status = 'Shipped'
WHERE order_id = 101
  AND status = 'Processing';

COMMIT;

-- Try to update the same order again. Expected: UPDATE 0 because the order is already Shipped.

UPDATE public.order
SET status = 'Shipped'
WHERE order_id = 101
  AND status = 'Processing';


-- Begin another transaction and add a valid order item for order 102 using product 20 (Mechanical Keyboard).

BEGIN;

INSERT INTO public.order_item
    (order_id, product_id, quantity, unit_price)
SELECT
    102,
    product_id,
    1,
    price
FROM public.product
WHERE product_id = 20;


-- This deliberate mistake sets the quantity to zero.
-- Expected: chk_item_quantity constraint violation. Run ROLLBACK next.

UPDATE public.order_item
SET quantity = 0
WHERE order_id = 102
  AND product_id = 20;

ROLLBACK;

-- The committed order status remains Shipped. The order item added in the failed transaction is gone.

SELECT order_id, status
FROM public.order
WHERE order_id = 101;
SELECT COUNT(*) AS mechanical_keyboard_items
FROM public.order_item
WHERE order_id = 102
  AND product_id = 20;