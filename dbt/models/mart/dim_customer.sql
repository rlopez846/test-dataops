WITH users AS (
    SELECT * FROM {{ ref('stg_users') }}
    LIMIT 1000
),

modified AS (
    SELECT
        user_id,
        first_name,
        last_name,
        email,
        age,
        gender,
        user_state,
        street_address,
        postal_code,
        city,
        country,
        latitude,
        longitude,
        traffic_source,
        user_created_at,
        DATE(user_created_at) AS user_created_at_date,
        user_geom
    FROM users
)

SELECT
    {{ dbt_utils.generate_surrogate_key(['country', 'gender', 'user_created_at_date']) }} AS test_sk,
    --user_id,
    country,
    gender,
    user_created_at_date,
    count(user_id) AS test_count
FROM modified
GROUP BY country, gender, user_created_at_date