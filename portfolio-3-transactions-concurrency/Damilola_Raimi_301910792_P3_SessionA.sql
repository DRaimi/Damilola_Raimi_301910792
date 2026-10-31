-- Follow the codelab's order across TWO terminals. Do not run this whole file at once.
-- A1: Use the first PostgreSQL terminal (left).

SET application_name = 'p3_session_a';

BEGIN ISOLATION LEVEL READ COMMITTED;

SHOW transaction_isolation;

-- Reduce Mechanical Keyboard stock by 30 units. Product ID 20 represents the Mechanical Keyboard.
UPDATE public.product
SET stock_quantity = stock_quantity - 30
WHERE product_id = 20
  AND stock_quantity >= 30;

-- Expected: UPDATE 1.
-- Session A has reduced the stock to 0, but has not committed. 
-- STOP. Leave this transaction open.

-- Switch to Session B and run B1. Session B will attempt to update the same product and should wait.
-- A2: After Session B's UPDATE is waiting, return to Session A.

SELECT application_name, wait_event_type
FROM pg_stat_activity
WHERE application_name = 'p3_session_b';

-- Expected: p3_session_b | Lock. Take the waiting screenshot, then continue.

COMMIT;

-- Expected: COMMIT. The stock reduction is now permanently saved.

-- Switch to Session B.
-- Its UPDATE should resume and return UPDATE 0 because no stock remains.