# Portfolio 5: Distributed and Cloud Database Exercise

## Current Setup

Portfolio 4 uses MongoDB to store e-commerce order events in the ecommerce_portfolio database, under the order_events collection. Four sample documents represent order placement, payment receipt and order shipment. The available project files demonstrate MongoDB document insertion and queries alongside the PostgreSQL e-commerce database. They do not verify a multi-server MongoDB deployment, replica set, sharding configuration or failover test. Therefore, the actual distributed topology is not verified.

## Proposed Replication

Replication maintains copies of the same data across multiple database servers. I propose a three-member MongoDB replica set, with all members holding data and participating in elections.

| Member | Starting role | Location |
|---|---|---|
| A | Primary: accepts event writes | Host 1 |
| B | Secondary: copies event changes | Host 2 |
| C | Secondary: copies event changes | Host 3 |

The hosts would be placed in separate failure zones to reduce the risk of losing all copies if one location fails. For example, when a payment_received event is recorded for order 101, the primary records the change and the secondary members replicate it. Replication is asynchronous, so secondary copies may briefly contain older information.

[MongoDB Replication](https://www.mongodb.com/docs/manual/replication/)

## Failure and Consistency

If Member A fails, the remaining members can hold an election to select an eligible secondary as the new primary. During the election, new writes are temporarily interrupted. A majority of voting members must be reachable for a primary to be elected. Without a majority, the replica set cannot elect a writable primary.
For important events, I propose using majority write acknowledgement (`w: "majorityy"`).` In this three-member design, at least two data-bearing voting members must acknowledge the write. This improves write durability but may increase waiting time. Secondary members may briefly lag behind the primary. Therefore, recent order-event queries should use the primary when the latest information is required. PostgreSQL remains responsible for authoritative customer, product, order and payment records. MongoDB replication does not automatically synchronise PostgreSQL.

* [Replica Set Elections](https://www.mongodb.com/docs/v8.0/core/replica-set-elections/)
* [Write Concern](https://www.mongodb.com/docs/v8.0/reference/write-concern/)

## Sharding and Cloud Deployment

Replication copies the same data across servers, while sharding splits data across multiple servers to distribute storage and workload. My current example contains only four event documents, so sharding is unnecessary. A single replica set would be a more suitable proposed starting point. Sharding could be considered if future event volumes and workload justify the additional complexity.
A cloud deployment could use a managed MongoDB service with database authentication, encrypted connections, restricted network access and scheduled backups. Backup restoration should also be tested. Deployment costs and available backup features would need to be checked before choosing a service.
Replication does not replace backups because accidental deletions can also be replicated. Another limitation is that MongoDB replication does not provide availability or recovery for the separate PostgreSQL database.

* [MongoDB Sharding](https://www.mongodb.com/docs/manual/sharding/)
* [MongoDB Atlas Backup and Restore](https://www.mongodb.com/docs/atlas/backup-restore-cluster/)

## References
* [MongoDB Replication](https://www.mongodb.com/docs/manual/replication/)
* [MongoDB Replica Set Elections](https://www.mongodb.com/docs/v8.0/core/replica-set-elections/)
* [MongoDB Write Concern](https://www.mongodb.com/docs/v8.0/reference/write-concern/)
* [MongoDB Sharding](https://www.mongodb.com/docs/manual/sharding/)
* [MongoDB Atlas Backup and Restore](https://www.mongodb.com/docs/atlas/backup-restore-cluster/)