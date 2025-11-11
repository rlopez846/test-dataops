{% test equals_product_of(model, a, b, c) %}

    SELECT *
    FROM {{ model }}
    WHERE {{ a }}  <>  {{ b }} * {{ c }}

{% endtest %}