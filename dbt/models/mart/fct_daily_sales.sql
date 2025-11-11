WITH orders AS (
    SELECT * FROM {{ ref('stg_orders') }}
    
),

products AS (
    SELECT * FROM {{ ref('stg_products') }}
),

order_items AS (
    SELECT * FROM {{ ref('stg_order_items') }}
    --LIMIT 100
    --WHERE order_id in (6644, 30084, 3621, 3622, 3623, 3624)
),

orders_ext as (
    SELECT
        orders.order_id,
        orders.user_id,
        orders.`status`,
        orders.order_gender,
        orders.order_created_at,
        DATE(orders.order_created_at) AS order_created_at_day,
        orders.returned_at,
        orders.shipped_at,
        orders.delivered_at,
        orders.num_of_item,
        SUM(order_items.sale_price) AS order_value,
        SUM(order_items.sale_price) / orders.num_of_item AS order_average_item_price
    FROM orders
    INNER JOIN order_items
        ON orders.order_id = order_items.order_id
    GROUP BY
        orders.order_id,
        orders.user_id,
        orders.`status`,
        orders.order_gender,
        orders.order_created_at,
        orders.returned_at,
        orders.shipped_at,
        orders.delivered_at,
        orders.num_of_item
),

daily_orders AS (
    SELECT
        user_id,
        order_created_at_day,
        COUNT(order_id) AS orders_count,
        SUM(num_of_item) AS total_items,
        SUM(order_value) AS total_revenue,
        SUM(order_value) / COUNT(order_id) AS average_order_value,
        SUM(order_value) / SUM(num_of_item) AS average_item_price
    FROM orders_ext
    GROUP BY user_id, order_created_at_day
),

final AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['orders_ext.user_id', 'order_items.product_id', 'orders_ext.user_created_at_date']) }} AS sales_sk,
        orders_ext.user_id,
        order_items.product_id,
        --orders_ext.order_created_at,
        orders_ext.order_created_at_day,
        daily_orders.orders_count,
        daily_orders.total_items, --daily_user_total_items
        COUNT(DISTINCT order_items.order_item_id) AS quantity,
        order_items.sale_price,
        SUM(order_items.sale_price) AS item_revenue,
        daily_orders.average_item_price,
        daily_orders.total_revenue,
        daily_orders.average_order_value,
    FROM order_items
    INNER JOIN orders_ext
        ON order_items.order_id = orders_ext.order_id
    INNER JOIN products
        ON order_items.product_id = products.product_id
    INNER JOIN daily_orders
        ON order_items.user_id = daily_orders.user_id
            AND orders_ext.order_created_at_day = daily_orders.order_created_at_day
    GROUP BY
        orders_ext.user_id,
        order_items.product_id,
        --orders_ext.order_created_at,
        orders_ext.order_created_at_day,
        daily_orders.orders_count,
        daily_orders.total_items,
        order_items.sale_price,
        daily_orders.total_revenue,
        daily_orders.average_order_value
)

SELECT * FROM final
