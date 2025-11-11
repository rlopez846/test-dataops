WITH source AS (
    SELECT * FROM {{ source('thelook_ecommerce', 'products') }}
    --LIMIT 10
),

renamed AS (
    SELECT
        id AS product_id,
        CAST(cost AS NUMERIC),
        category,
        `name` AS product_name,
        brand,
        CAST(retail_price AS NUMERIC) AS retail_price,
        department,
        sku,
        distribution_center_id
    FROM source
)

SELECT * FROM renamed
