WITH source AS (
    SELECT * FROM {{ source('thelook_ecommerce', 'users') }}
    --LIMIT 10
),

renamed AS (
    SELECT
        id AS user_id,
        first_name,
        last_name,
        email,
        CAST(age AS NUMERIC) AS age,
        gender,
        `state` AS user_state,
        street_address,
        postal_code,
        city,
        country,
        CAST(latitude AS NUMERIC) AS latitude,
        CAST(longitude AS NUMERIC) AS longitude,
        traffic_source,
        CAST(created_at AS TIMESTAMP) AS user_created_at,
        user_geom
    FROM source
)

SELECT * FROM renamed
