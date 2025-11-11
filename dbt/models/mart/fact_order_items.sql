WITH orders AS (
    SELECT * FROM {{ ref('stg_orders') }}
),

products AS (
    SELECT * FROM {{ ref('stg_products') }}
),

order_items AS (
    SELECT * FROM {{ ref('stg_order_items') }}
)

SELECT
    --orders.order_id,
    orders.user_id,
    orders.`status`,
    --orders.order_gender,
    orders.order_created_at,
    --orders.returned_at,
    --orders.shipped_at,
    --orders.delivered_at,
    orders.num_of_item,

    --order_items.order_item_id,
    --order_items.order_id,
    --order_items.user_id,
    --order_items.product_id,
    --order_items.inventory_item_id,
    --order_items.order_item_status,
    order_items.order_item_created_at,
    --order_items.order_item_shipped_at,
    --order_items.order_item_delivered_at,
    --order_items.order_item_returned_at,
    order_items.sale_price,

    products.product_id,
    products.cost,
    --products.category,
    --products.product_name,
    --products.brand,
    products.retail_price,
    --products.department,
    --products.sku,
    --products.distribution_center_id
FROM order_items
INNER JOIN orders
    ON order_items.order_id = orders.order_id
INNER JOIN products
    ON order_items.product_id = products.product_id
LIMIT 10
