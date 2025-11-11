WITH source AS (
    SELECT * FROM `bigquery-public-data.thelook_ecommerce.orders`
    --LIMIT 10
),

renamed AS (
    SELECT
        order_id,
        user_id,
        `status`,
        gender AS order_gender,
        TIMESTAMP(created_at) AS order_created_at,
        TIMESTAMP(returned_at) AS returned_at,
        TIMESTAMP(shipped_at) AS shipped_at,
        TIMESTAMP(delivered_at) AS delivered_at,
        num_of_item
    FROM source
)

SELECT * FROM renamed