-- Follow the codelab's order across TWO terminals. Do not run this whole file at once.
-- B1: Run only after Session A has updated product 20 but has NOT committed.

SET application_name = 'p3_session_b';

BEGIN ISOLATION LEVEL READ COMMITTED;

SHOW transaction_isolation;

-- Check the stock visible to Session B. Session A's uncommitted update is not visible yet.

SELECT stock_quantity
FROM public.product
WHERE product_id = 20;

-- Expected: 30. Session A's stock reduction is not committed yet.

-- Attempt to purchase the same 30 units. This update should wait because Session A holds a row lock.

UPDATE public.product
SET stock_quantity = stock_quantity - 30
WHERE product_id = 20
  AND stock_quantity >= 30;


-- STOP HERE. Session B should be waiting. Do not enter another command.
-- Switch to Session A. Run A2 to check the lock and COMMIT the transaction.

-- B2: Return to Session B after Session A commits.
-- The waiting UPDATE should resume and return UPDATE 0. This happens because the available stock is now 0.

ROLLBACK;

-- Clear and close Session B's transaction.

-- Verify the final stock quantity.

SELECT product_id, name, stock_quantity
FROM public.product
WHERE product_id = 20;

-- Expected: product_id: 20, name: Mechanical Keyboard, stock_quantity: 0