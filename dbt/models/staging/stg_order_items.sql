WITH source AS (
    SELECT * FROM {{ source('thelook_ecommerce', 'order_items') }}
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
        CAST(created_at AS TIMESTAMP) AS order_item_created_at,
        CAST(shipped_at AS TIMESTAMP) AS order_item_shipped_at,
        CAST(delivered_at AS TIMESTAMP) AS order_item_delivered_at,
        CAST(returned_at AS TIMESTAMP) AS order_item_returned_at,
        CAST(sale_price AS NUMERIC) AS sale_price
    FROM source
)

SELECT * FROM renamed
