# Ecommerce platform Database Design

## Entities

I chose five entities for my ecommerce platform database system:

| Entity | Information stored |
| :--- | :--- |
| **customer** | A registered user who can place orders |
| **product** | A catalogue record for an item available for sale, including stock quantity |
| **order** | A purchase record placed by a customer |
| **order_item** | An individual line item within an order, linking products to orders |
| **payment** | A financial transaction record associated with an order |

I kept `product` and `order_item` separate. For example, a store may sell a *Wireless Mouse* catalogue item. I record product details once, and use `order_item` to record how many units of that product were purchased in a specific order along with its agreed unit price.

## Attributes and keys

I use an automatically generated ID for each record using `BIGINT`. In the tables below, **unique** means no repeated values. **Required** means the value cannot be `NULL` (missing); checking for blank text or negative values is a separate rule.

| Entity | Attributes and proposed PostgreSQL types | Keys and required values |
| :--- | :--- | :--- |
| **customer** | `customer_id BIGINT`; `email VARCHAR(254)`; `full_name VARCHAR(120)` | PK: `customer_id`. Unique: `email`. All required. |
| **product** | `product_id BIGINT`; `name VARCHAR(200)`; `price NUMERIC(10,2)`; `stock_quantity INTEGER` | PK: `product_id`. Unique: `name`. All required. |
| **order** | `order_id BIGINT`; `customer_id BIGINT`; `status VARCHAR(20)`; `created_at TIMESTAMPTZ` | PK: `order_id`. FK: `customer_id` $\rightarrow$ `customer.customer_id`. All required. |
| **order_item** | `order_item_id BIGINT`; `order_id BIGINT`; `product_id BIGINT`; `quantity INTEGER`; `unit_price NUMERIC(10,2)` | PK: `order_item_id`. FKs: `order_id` $\rightarrow$ `order.order_id`, `product_id` $\rightarrow$ `product.product_id`. All required. |
| **payment** | `payment_id BIGINT`; `order_id BIGINT`; `amount NUMERIC(10,2)`; `payment_date TIMESTAMPTZ` | PK: `payment_id`. FK: `order_id` $\rightarrow$ `order.order_id`. All required. |

`BIGINT` holds whole numbers for IDs. `VARCHAR(254)` holds text up to 254 characters. `NUMERIC(10,2)` holds exact monetary amounts. `TIMESTAMPTZ` holds a date and time with time-zone awareness.

Design assumption: Storing `unit_price` on `order_item` captures historical prices at the time of purchase if catalog `price` changes later.

## Relationships

| Tables linked | Relationship | Meaning |
| :--- | :--- | :--- |
| **customer $\rightarrow$ order** | One to many | A customer can have zero or many orders; each order belongs to exactly one customer. |
| **order $\rightarrow$ order_item** | One to many | An order can have one or many items; each order item belongs to exactly one order. |
| **product $\rightarrow$ order_item** | One to many | A product can appear in zero or many order items; each order item references exactly one product. |
| **order $\rightarrow$ payment** | One to many | An order can have zero or many payment records; each payment belongs to exactly one order. |

For example, order 101 can contain two `order_item` records: one for 2 mice and one for 1 keyboard. I use `order_item` as a linking table to connect `order` and `product`. A foreign key links records, but application logic ensures an order cannot exist without at least one item.

## Business rules and constraints

* **Rule 1:** `customer_id` is the primary key and `email` has a `UNIQUE` constraint.
* **Rule 2:** `product_id` is the primary key; `CHECK` constraints require `price >= 0` and `stock_quantity >= 0`.
* **Rule 3:** `order_id` is the primary key; required foreign key `customer_id` links each order to an existing customer.
* **Rule 4:** `order_item` contains required foreign keys `order_id` and `product_id` linking to existing orders and products.
* **Rule 5:** `CHECK` constraints on `order_item` require `quantity > 0` and `unit_price >= 0`.
* **Rule 6:** `payment_id` is the primary key; required foreign key `order_id` links each payment to an existing order.
* **Rule 7:** A check constraint ensures `stock_quantity >= 0`, but verifying sufficient stock before order placement and updating inventory requires transaction logic, not just a key.
* **Rule 8:** A `CHECK` constraint restricts `status` to ('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled'). Preventing illegal state transitions (e.g., reprocessing a delivered order) requires application logic.

An item is available when its `stock_quantity` is greater than or equal to the requested amount. Total order cost can be calculated from `order_item` prices and quantities, so no separate total field is stored.
