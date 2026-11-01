# Portfolio 3: Transactions and Concurrency

## Commit and rollback
The update to order 101 is committed, changing its status from Processing to Shipped. Repeating the update affects zero rows because its `Processing` condition is no longer met. In a separate transaction, I inserted a Mechanical Keyboard order item for order 102, then deliberately set its quantity to zero, triggering the `chk_item_quantity` constraint. `ROLLBACK` removed the inserted item while preserving the earlier committed update. Final queries confirmed both orders remained Shipped and the inserted item was absent.

## Isolation and concurrency control
Two PostgreSQL sessions use `READ COMMITTED` isolation. Session A reduces Mechanical Keyboard stock from 30 to zero without committing. Session B initially sees 30 because uncommitted changes are invisible to it, then waits when attempting to update the same product row. Session A confirms the lock through `pg_stat_activity` and commits. Session B's update resumes and returns `UPDATE 0` because the stock condition is no longer satisfied. The final query confirms stock is zero. The conditional update and row-level locking prevent this operation from reducing stock below zero, provided stock changes follow this transaction pattern.

## Conclusion
`COMMIT` saves successful changes, while `ROLLBACK` reverses uncommitted changes. `READ COMMITTED` controls visibility between concurrent transactions, and PostgreSQL row-level locking coordinates competing updates to the same product. The conditional stock update protects against overselling through this operation, but it does not automatically protect against other operations that modify stock without the same condition.

## Files
- [Commit and rollback SQL](https://github.com/DRaimi/Damilola_Raimi_301910792/blob/main/portfolio-3-transactions-concurrency/Damilola_Raimi_301910792_P3_Transactions.sql)
- [Session A SQL](https://github.com/DRaimi/Damilola_Raimi_301910792/blob/main/portfolio-3-transactions-concurrency/Damilola_Raimi_301910792_P3_SessionA.sql)
- [Session B SQL](https://github.com/DRaimi/Damilola_Raimi_301910792/blob/main/portfolio-3-transactions-concurrency/Damilola_Raimi_301910792_P3_SessionB.sql)
- [Screenshots folder](https://github.com/DRaimi/Damilola_Raimi_301910792/tree/main/portfolio-3-transactions-concurrency/Damilola_Raimi_301910792_P3_Screenshots) : CommitRollback, SessionsWaiting and ConcurrencyResult.