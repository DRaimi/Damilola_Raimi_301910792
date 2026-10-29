# E-commerce platform Normalisation

Normalisation separates information into related tables to reduce repeated details and avoid inconsistent updates. The same two orders are used below. Only the fields needed to explain the changes are shown; the full design keeps the other fields from the design document.

Dates are shortened for readability. `created_at` represents the full order date and time. Names and emails are fictional.

## Starting order list

| order_id | customer_email | customer_name | purchased items |
| :--- | :--- | :--- | :--- |
| **101** | king@example.com | King Fisher | Wireless Mouse, qty 2, $25.00; Mechanical Keyboard, qty 1, $85.00 |
| **102** | claire@example.com | Claire Smith | Wireless Mouse, qty 1, $25.00 |

The first row contains multiple items in one cell. Finding one item or updating individual product details is awkward.

---

## 1NF: One value per cell

Each item has its own row. The repeated list is removed.

| order_id | created_at | customer_id | customer_name | email | product_name | unit_price | quantity | status |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **101** | 2026-10-29 | 1 | King Fisher | king@example.com | Wireless Mouse | 25.00 | 2 | Pending |
| **101** | 2026-10-29 | 1 | King Fisher | king@example.com | Mechanical Keyboard | 85.00 | 1 | Pending |
| **102** | 2026-10-29 | 2 | Claire Smith | claire@example.com | Wireless Mouse | 25.00 | 1 | Shipped |

For this example, the key is `(order_id, product_name)`. Both values together identify one item line, assuming a product cannot appear twice in the exact same order.

The rows are in 1NF, but the customer and product details are repeated. Correcting a customer's email or product's price requires changing every related row.

---

## 2NF: Details depend on the whole key

2NF includes 1NF. A non-key field must not depend on only part of a combined key.

Here, `order_id` alone determines `customer_email`, `customer_name`, `status`, and `created_at`. These details belong to the order, regardless of what items are bought. They move into a separate table.

### Order details

**Key: `order_id`**

| order_id | customer_email | customer_name | status | created_at |
| :--- | :--- | :--- | :--- | :--- |
| **101** | king@example.com | King Fisher | Pending | 2026-10-29 |
| **102** | claire@example.com | Claire Smith | Shipped | 2026-10-29 |

### Order item details

**Key: `(order_id, product_name)`, `order_id` links to Order.**

| order_id | product_name | unit_price | quantity |
| :--- | :--- | :--- | :--- |
| **101** | Wireless Mouse | 25.00 | 2 |
| **101** | Mechanical Keyboard | 85.00 | 1 |
| **102** | Wireless Mouse | 25.00 | 1 |

The order details no longer repeat for every item in an order. However, the customer's email and name still repeat across orders, and product details repeat across order items.

---

## 3NF: Keep details with the thing they describe

3NF includes 2NF. Non-key fields must not depend on another non-key field. Two remaining links to explain the next split:

* `product_name` determines `unit_price` and stock; the price describes the product, not the individual order item line.
* `customer_email` determines `customer_name`; these describe the customer, not the order.

### customer

**Key: `customer_id`**

| customer_id | full_name | email |
| :--- | :--- | :--- |
| **1** | King Fisher | king@example.com |
| **2** | Claire Smith | claire@example.com |

### product

**Key: `product_id`**

| product_id | name | price | stock_quantity |
| :--- | :--- | :--- | :--- |
| **10** | Wireless Mouse | 25.00 | 50 |
| **20** | Mechanical Keyboard | 85.00 | 30 |

### order

**Key: `order_id`, `customer_id` is a foreign key to customer.**

| order_id | customer_id | status | created_at |
| :--- | :--- | :--- | :--- |
| **101** | 1 | Pending | 2026-10-29 |
| **102** | 2 | Shipped | 2026-10-29 |

### order_item

**Key: `order_item_id`, `order_id` and `product_id` are foreign keys to order and product.**

| order_item_id | order_id | product_id | quantity | unit_price |
| :--- | :--- | :--- | :--- | :--- |
| **1001** | 101 | 10 | 2 | 25.00 |
| **1002** | 101 | 20 | 1 | 85.00 |
| **1003** | 102 | 10 | 1 | 25.00 |

### payment

**Key: `payment_id`, `order_id` is a foreign key to order.**

| payment_id | order_id | amount | payment_date |
| :--- | :--- | :--- | :--- |
| **501** | 101 | 135.00 | 2026-10-29 |

The final design uses `order_item_id` as its primary key, rather than relying on a combined key. `customer_id`, `order_id`, and `product_id` are foreign keys. Adding an ID is a design choice, not what makes a table 3NF.

Now King's email is stored once in `customer`, and product details are stored once in `product`. The IDs preserve the links, so the records can still be brought together when needed.

These are the five tables in the ER diagram. The complete schema also includes unique values, date checks, and stock rules. Normalisation does not enforce these rules by itself.
