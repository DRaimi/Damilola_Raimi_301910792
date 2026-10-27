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