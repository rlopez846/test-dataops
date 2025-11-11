WITH source AS (
    SELECT * FROM `bigquery-public-data.thelook_ecommerce.order_items`
    --LIMIT 10
),

renamed AS (
    SELECT
        id AS order_item_id,
        order_id,
        user_id,
        product_id,
        inventory_item_id,
        `status` AS order_item_status,
        TIMESTAMP(created_at) AS order_item_created_at,
        TIMESTAMP(shipped_at) AS order_item_shipped_at,
        TIMESTAMP(delivered_at) AS order_item_delivered_at,
        TIMESTAMP(returned_at) AS order_item_returned_at,
        sale_price
    FROM source
)

SELECT * FROM renamed