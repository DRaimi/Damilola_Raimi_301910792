// Run once in mongosh, using either the local connection or Atlas.
// Select the MongoDB database, not the PostgreSQL database.

// Select the e-commerce database
db = db.getSiblingDB("ecommerce_portfolio");

// Insert four sample order events
db.order_events.insertMany([
  {
    _id: "E001",
    event_type: "order_placed",
    occurred_at: ISODate("2026-10-29T10:00:00Z"),
    customer: {
      customer_id: 1,
      full_name: "King Fisher",
      email: "king@example.com"
    },
    order: {
      order_id: 101,
      status: "Pending",
      items: [
        { product_id: 10, name: "Wireless Mouse", quantity: 2, unit_price: 25.00 },
        { product_id: 20, name: "Mechanical Keyboard", quantity: 1, unit_price: 85.00 }
      ]
    },
    details: { total_amount: 135.00 }
  },
  {
    _id: "E002",
    event_type: "payment_received",
    occurred_at: ISODate("2026-10-29T10:05:00Z"),
    customer: {
      customer_id: 1,
      full_name: "King Fisher",
      email: "king@example.com"
    },
    order: {
      order_id: 101,
      status: "Pending"
    },
    details: {
      amount: 135.00,
      payment_status: "Received"
    }
  },
  {
    _id: "E003",
    event_type: "order_placed",
    occurred_at: ISODate("2026-10-29T11:30:00Z"),
    customer: {
      customer_id: 2,
      full_name: "Claire Smith",
      email: "claire@example.com"
    },
    order: {
      order_id: 102,
      status: "Shipped",
      items: [
        { product_id: 10, name: "Wireless Mouse", quantity: 1, unit_price: 25.00 }
      ]
    },
    details: { total_amount: 25.00 }
  },
  {
    _id: "E004",
    event_type: "order_shipped",
    occurred_at: ISODate("2026-10-30T09:00:00Z"),
    customer: {
      customer_id: 2,
      full_name: "Claire Smith",
      email: "claire@example.com"
    },
    order: {
      order_id: 102,
      status: "Shipped"
    },
    details: { shipping_status: "Dispatched" }
  }
]);

// Query 1: Count all order events
db.order_events.countDocuments();

// Query 2: Find events for order 101, sorted by date
db.order_events.find(
  { "order.order_id": 101 },
  { _id: 1, event_type: 1, occurred_at: 1, details: 1 }
).sort({ occurred_at: 1, _id: 1 }).toArray();

// Query 3: Find events with received payments
db.order_events.find(
  { "details.payment_status": "Received" }
).toArray();