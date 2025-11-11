WITH source AS (
    SELECT * FROM {{ source('thelook_ecommerce', 'orders') }}
    --LIMIT 10
),

renamed AS (
    SELECT
        order_id,
        user_id,
        `status`,
        gender AS order_gender,
        CAST(created_at AS TIMESTAMP) AS order_created_at,
        CAST(returned_at AS TIMESTAMP) AS returned_at,
        CAST(shipped_at AS TIMESTAMP) AS shipped_at,
        CAST(delivered_at AS TIMESTAMP) AS delivered_at,
        CAST(num_of_item AS NUMERIC) AS num_of_item
    FROM source
)

SELECT * FROM renamed
