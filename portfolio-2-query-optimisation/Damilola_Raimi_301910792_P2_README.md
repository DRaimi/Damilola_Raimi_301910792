# Portfolio 2 Query Processing and Optimisation

## Queries and results

The orders-in-progress query returns two products under King Fisher's order (101), both with Pending status. The available-products query returns Wireless Mouse, with 50 units in stock, and Mechanical Keyboard, with 30 units in stock. The grouped query counts one order for Claire Smith and one for King Fisher.

## Index comparison

The separate `p2_benchmark.order_history` table contains 100,000 generated e-commerce order-history records using existing customer and product IDs. The original Portfolio 1 records remain unchanged. The benchmark table is created separately and does not copy the operational tables' constraints. The same query counts order-history records from January 1, 2005 (inclusive) to January 2, 2005 (exclusive), using explicit UTC timestamps. It is designed to return 24 records before and after adding the B-tree index `order_history_activity_at_idx` on `activity_at`. `ANALYZE` refreshes the test table statistics before measurement. Each phase has one warm-up and three measured `EXPLAIN (ANALYZE, BUFFERS)` runs.

| **Measurement**               | **Before index**         | **After index**          |
| ----------------------------- | ------------------------ | ------------------------ |
| Scan type                     | Sequential Scan          | Index Only Scan            |
| Three execution times (ms)    | 5.684, 6.036, 13.189 | 0.064, 0.056, 0.062 |
| Median time (ms)              | 6.036                 | 0.062                 |
| Shared buffer hits, third run | 896           | 3           |

## Performance analysis

Before indexing, PostgreSQL used a Sequential Scan to search the 100,000 records and identify those matching the date range. After indexing, the execution plan is examined to determine whether PostgreSQL uses the B-tree index to locate the matching records more efficiently.The median execution time changes from 5.684 ms to 0.064 ms, while shared buffer hits change from 896 to 3.The benchmark uses synthetic data and was conducted in GitHub Codespaces, where execution times may vary. The index also requires additional storage and adds maintenance work when records are inserted, updated or deleted. The results apply to this particular query and dataset, not necessarily every query.

## Files
[SQL Queries](https://super-duper-chainsaw-qv6v5jj7q95wc66q.github.dev/)

[Test data, execution plans and Index SQL](https://super-duper-chainsaw-qv6v5jj7q95wc66q.github.dev/)

[Screenshot](https://super-duper-chainsaw-qv6v5jj7q95wc66q.github.dev/) : QueryResults, BeforeIndex and AfterIndex.

## Reference
[PostgreSQL 16 — Using Explain](https://www.postgresql.org/docs/16/using-explain.html)