-- E-commerce platform: five tables from the agreed design.
-- Run once in the empty ecommerce_portfolio database.

BEGIN;
-- Each customer has a separate ID, name and unique email address.
CREATE TABLE public.customer (
    customer_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    email VARCHAR(254) NOT NULL UNIQUE,
    full_name VARCHAR(120) NOT NULL
);

-- Store product details, prices and available stock quantities.
CREATE TABLE public.product (
    product_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    price NUMERIC(10,2) NOT NULL,
    stock_quantity INTEGER NOT NULL,
    CONSTRAINT chk_product_price
        CHECK (price >= 0),
    CONSTRAINT chk_product_stock
        CHECK (stock_quantity >= 0)
);

-- Each order belongs to one customer and has a creation date and status.
CREATE TABLE public."order" (
    order_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id BIGINT NOT NULL,
    status VARCHAR(20) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL,
    CONSTRAINT order_customer_id_fkey
        FOREIGN KEY (customer_id) REFERENCES public.customer (customer_id),
    CONSTRAINT chk_order_status
        CHECK (status IN ('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled'))
);

-- Each order item links one product to an order and records its quantity and purchase price.
CREATE TABLE public.order_item (
    order_item_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    quantity INTEGER NOT NULL,
    unit_price NUMERIC(10,2) NOT NULL,
    CONSTRAINT order_item_order_id_fkey
        FOREIGN KEY (order_id) REFERENCES public."order" (order_id),
    CONSTRAINT order_item_product_id_fkey
        FOREIGN KEY (product_id) REFERENCES public.product (product_id),
    CONSTRAINT chk_item_quantity
        CHECK (quantity > 0),
    CONSTRAINT chk_item_unit_price
        CHECK (unit_price >= 0),
    CONSTRAINT order_item_order_product_unique
        UNIQUE (order_id, product_id)
);

-- Each payment is associated with an existing customer order.
CREATE TABLE public.payment (
    payment_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id BIGINT NOT NULL,
    amount NUMERIC(10,2) NOT NULL,
    payment_date TIMESTAMPTZ NOT NULL,
    CONSTRAINT payment_order_id_fkey
        FOREIGN KEY (order_id) REFERENCES public."order" (order_id)
);

COMMIT;