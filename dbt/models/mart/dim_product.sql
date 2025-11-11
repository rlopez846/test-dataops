WITH products AS (
    SELECT * FROM {{ ref('stg_products') }}
    LIMIT 100
),

average_retail_price_table AS (
    SELECT
        category,
        SUM(retail_price) / COUNT(product_id) AS average_retail_price
    FROM products
    GROUP BY category
)

SELECT
    products.product_id,
    --cost,
    products.category,
    product_name,
    --brand,
    retail_price,
    average_retail_price_table.average_retail_price -- category wide
    --department,
    --sku,
    --distribution_center_id
FROM products
INNER JOIN average_retail_price_table
    ON products.category = average_retail_price_table.category