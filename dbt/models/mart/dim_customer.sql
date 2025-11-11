WITH users AS (
    SELECT * FROM {{ ref('stg_users') }}
    --LIMIT 1000
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
        CAST(user_created_at AS DATE) AS user_created_at_date,
        user_geom
    FROM users
),

final AS (
    SELECT DISTINCT
        {{ dbt_utils.generate_surrogate_key(['user_id', 'country', 'gender', 'user_created_at_date']) }} AS customer_sk,
        user_id,
        country,
        gender,
        user_created_at,
        user_created_at_date
    FROM modified
    --GROUP BY user_id, country, gender, user_created_at_date
)

SELECT * FROM final
