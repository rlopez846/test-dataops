WITH source AS (
    SELECT * FROM `bigquery-public-data.thelook_ecommerce.users`
    --LIMIT 10
),

renamed AS (
    SELECT
        id AS user_id,
        first_name,
        last_name,
        email,
        age,
        gender,
        `state` AS user_state,
        street_address,
        postal_code,
        city,
        country,
        latitude,
        longitude,
        traffic_source,
        TIMESTAMP(created_at) AS user_created_at,
        user_geom
    FROM source
)

SELECT * FROM renamed