WITH raw_acceptance AS (
    SELECT
        external_ref,
        ref AS transaction_id,
        state,
        cvv_provided::BOOLEAN AS cvv_used,
        CAST(amount AS DECIMAL(18,2)) AS transaction_amount,
        country,
        currency,
        TRY_CAST(rates::STRING AS JSON) AS rates_json,
        PARSE_TIMESTAMP('%Y-%m-%dT%H:%M:%E*S', date_time) AS transaction_date
    FROM {{ source('globepay', 'acceptance') }}
)

SELECT 
    external_ref,
    transaction_id,
    state,
    cvv_used,
    transaction_amount,
    country,
    currency,
    transaction_date,
    rates_json->>'USD' AS exchange_rate_to_usd
FROM raw_acceptance
