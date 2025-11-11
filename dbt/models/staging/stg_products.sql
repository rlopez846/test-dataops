WITH source AS (
    SELECT * FROM `bigquery-public-data.thelook_ecommerce.products`
    --LIMIT 10
),

renamed AS (
    SELECT
        id AS product_id,
        cost,
        category,
        `name` AS product_name,
        brand,
        retail_price,
        department,
        sku,
        distribution_center_id
    FROM source
)

SELECT * FROM renamed