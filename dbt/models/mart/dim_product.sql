WITH products AS (
    SELECT * FROM {{ ref('stg_products') }}
    --LIMIT 100
),

average_retail_price_table AS (
    SELECT
        category,
        SUM(retail_price) / COUNT(product_id) AS average_retail_price
    FROM products
    GROUP BY category
),

final as (
    SELECT
        products.product_id,
        products.category,
        product_name,
        retail_price,
        average_retail_price_table.average_retail_price -- category wide
    FROM products
    INNER JOIN average_retail_price_table
        ON products.category = average_retail_price_table.category
)

SELECT * FROM final
