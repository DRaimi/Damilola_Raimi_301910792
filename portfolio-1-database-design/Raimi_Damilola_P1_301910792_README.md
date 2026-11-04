# Portfolio 1 Database Design and Modelling

## Case study
An e-commerce platform stores customer records, product information, orders, order items, payments and inventory levels. Customers purchase products online, while administrators manage products, monitor stock and track orders and payments.

## Users
Customers browse products and place orders. Administrators register products, update prices and stock levels, and monitor orders. Order management staff process orders and update delivery statuses.

## Main operations
Register a customer; add or update a product; view available products; place an order containing one or more products; record a payment; update inventory after an order is placed; and track order status.

## Business rules
1. Each customer has a unique customer ID and email address.
2. Each product has a unique product ID, a name, a non-negative price and a non-negative stock quantity.
3. Each order has a unique order ID and belongs to one existing customer. A customer can place multiple orders.
4. Each order item belongs to one existing order and references one existing product. An order can contain multiple items.
5. Each order item must have a quantity greater than zero and a unit price greater than or equal to zero.
6. Each payment has a unique payment ID and belongs to one existing order. An order can have multiple payment records.
7. An order can be placed only when sufficient stock is available for every product requested. Stock must not become negative when orders are processed.
8. Each order has a valid status of Pending, Processing, Shipped, Delivered or Cancelled. A delivered or cancelled order cannot be processed or shipped again.

## Scope
The system covers a single online store using fictional customers, products, orders and payments. It includes product management, order processing, basic inventory control and payment records. Refund processing, discount management, supplier management, multiple warehouses, delivery integrations and user authentication are excluded.

## Design and implementation files

| File | Contents |
| :--- | :--- |
| [Design](https://github.com/DRaimi/Raimi_Damilola_301910792/blob/main/portfolio-1-database-design/Raimi_Damilola_301910792_P1_Design.md) | Entities, attributes, keys and relationships. |
| [ER diagram](https://github.com/DRaimi/Raimi_Damilola_301910792/blob/main/portfolio-1-database-design/Raimi_Damilola_301910792_P1_ERDiagram.md) | The five tables and their relationships. |
| [Normalisation](https://github.com/DRaimi/Raimi_Damilola_301910792/blob/main/portfolio-1-database-design/Raimi_Damilola_301910792_P1_Normalization.md) | Example tables showing 1NF, 2NF and 3NF. |
| [Schema](Raimi_Damilola_301910792_P1_Schema.sql) | Table definitions, keys and constraints. |
| [Sample records](https://github.com/DRaimi/Raimi_Damilola_301910792/blob/main/portfolio-1-database-design/Raimi_Damilola_301910792_P1_Sampledata.mdl) | Fictional customers, products, orders, items and payments. |
| [Constraint tests](https://github.com/DRaimi/Raimi_Damilola_301910792/blob/main/portfolio-1-database-design/Raimi_Damilola_301910792_P1_ConstraintsTestsql.md) | Invalid inserts and the final count query. |
| [Screenshots](https://github.com/DRaimi/Raimi_Damilola_301910792/tree/main/portfolio-1-database-design/Raimi_Damilola_301910792_Screenshots) | Saved commands and results. |

## Implementation

The database runs on PostgreSQL 16 in GitHub Codespaces. Its name is `ecommerce_portfolio`, and it contains five tables: `customer`, `product`, `order`, `order_item`, and `payment`. Each table uses an automatically generated identity primary key, and foreign keys connect orders to customers, order items to orders and products, and payments to orders.
Required fields use `NOT NULL` constraints, emails and product names are enforced as `UNIQUE`, and `CHECK` constraints validate prices, stock quantities, item quantities, and permitted order statuses. The schema and valid sample records were executed successfully, followed by individual constraint tests run outside transaction blocks to evaluate failures.

## Test results

Deliberately invalid inserts were correctly rejected by PostgreSQL, triggering expected errors for missing required values, duplicate unique keys, non-existent foreign key references, and `CHECK` constraint violations (such as negative prices or unrecognized order statuses). Valid sample records representing different customer orders and states were successfully accepted. The final verification query confirmed that failed inserts corrupted no data. The final row counts are 2 customers, 2 products, 2 orders, 3 order items, and 1 payment record. 
Rules 7 (stock management) and 8 (state transitions) require application-level transaction logic and are not fully enforced by table definitions alone.

Reference: [PostgreSQL constraints](https://www.postgresql.org/docs/16/ddl-constraints.html).