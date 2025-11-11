WITH orders AS (
    SELECT * FROM {{ ref('stg_orders') }}
),

products AS (
    SELECT * FROM {{ ref('stg_products') }}
),

order_items AS (
    SELECT * FROM {{ ref('stg_order_items') }}
    --WHERE user_id = 88636
)

SELECT
    {{ dbt_utils.generate_surrogate_key(['orders.user_id', 'products.product_id']) }} AS order_items_sk,
    orders.user_id,
    products.product_id,
    COUNT(order_item_id) AS num_of_item,
    SUM(order_items.sale_price) AS sale_price,
    SUM(products.cost) AS cost,
    SUM(products.retail_price) AS retail_price,
FROM order_items
INNER JOIN orders
    ON order_items.order_id = orders.order_id
INNER JOIN products
    ON order_items.product_id = products.product_id
GROUP BY
    orders.user_id,
    products.product_id
