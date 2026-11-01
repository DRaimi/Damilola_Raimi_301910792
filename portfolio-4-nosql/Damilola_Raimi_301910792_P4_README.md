# Portfolio 4: NoSQL and Advanced Data Models

## 1. Document Model

The ecommerce_portfolio database contains an order_events collection. Each document records an event in an order's lifecycle, such as an order being placed, payment being received or an order being shipped. The collection uses embedded documents to store related customer, order and event-specific information.

| Field         | Content                                                                                         |
| ------------- | ----------------------------------------------------------------------------------------------- |
| _id         | Unique identifier for each event, such as E001 or E002.                                         |
| event_type  | Describes the activity, such as order_placed, payment_received or order_shipped.          |
| occurred_at | Date and time the event occurred, stored using MongoDB's ISODate format.                      |
| customer   | Embedded customer details, including customer ID, full name and email address.                  |
| order     | Embedded order details, including order ID, status and, where applicable, product items.        |
| details   | Additional event-specific information, such as total amount, payment status or shipping status. |

### Sample document records

| ID   | Event type         | Customer     | Order ID | Content                                                                  |
| ---- | ------------------ | ------------ | -------- | ------------------------------------------------------------------------ |
| E001 | order_placed     | King Fisher  | 101      | Ordered 2 Wireless Mice and 1 Mechanical Keyboard. Total amount: 135.00. |
| E002 | payment_received | King Fisher  | 101      | Payment of 135.00 received. Payment status: Received.                    |
| E003 | order_placed   | Claire Smith | 102      | Ordered 1 Wireless Mouse. Total amount: 25.00.                           |
| E004 | order_shipped  | Claire Smith | 102      | Order shipped. Shipping status: Dispatched.                              |

### Example MongoDB document

The following document represents a payment event:

```javascript
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
}
```

## 2. Implementation and Results

Four fictional order-event documents were inserted into MongoDB using mongosh.

The following operations were performed:

| Operation           | Purpose                                                                 | Result                  |
| ------------------- | ----------------------------------------------------------------------- | ----------------------- |
| countDocuments()  | Counts all documents in the collection.                                 | 4 documents             |
| Order history query | Retrieves events belonging to order 101 and sorts them chronologically. | E001 and E002 returned. |
| Payment query       | Finds events with a payment status of Received.                         | E002 returned.          |

The MongoDB implementation was completed separately from PostgreSQL. The existing relational database was not changed.

## 3. Why MongoDB Fits

MongoDB supports flexible document structures, allowing customer, order and event-specific information to be stored together. Different event types can contain different details without requiring every document to have identical fields. A separate document for each event also makes it possible to maintain an order's event history as new activities occur. The embedded customer and order information acts as a snapshot and does not automatically update when PostgreSQL records change. PostgreSQL continues to manage the relational data, while MongoDB stores the sample order events. The two databases are not automatically synchronised.

## 4. Project Files

* [MongoDB implementation and queries]: (https://github.com/DRaimi/Damilola_Raimi_301910792/blob/main/portfolio-4-nosql/Damilola_Raimi_301910792_P4_MongoDB.js)
* [Setup and Connection Check]: (https://github.com/DRaimi/Damilola_Raimi_301910792/blob/main/portfolio-4-nosql/Damilola_Raimi_301910792_P4_Screenshots/Damilola_Raimi_301910792_P4_MongoDBconnection.png)
* [Screenshots]: (https://github.com/DRaimi/Damilola_Raimi_301910792/tree/main/portfolio-4-nosql/Damilola_Raimi_301910792_P4_Screenshots): MongoDBConnection and EventsAndQueries.

## 5. References

1. MongoDB Manual: https://www.mongodb.com/docs/manual/
2. MongoDB Insert Documents: https://www.mongodb.com/docs/manual/tutorial/insert-documents/
3. MongoDB Query Documents: https://www.mongodb.com/docs/manual/tutorial/query-documents/