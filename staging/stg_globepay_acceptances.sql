WITH raw_acceptance AS (
   SELECT
        external_ref,
        ref AS transaction_id,
        state,
        cvv_provided::BOOLEAN AS cvv_used,
        {{ format_currency('amount') }} AS transaction_amount,
        country,
        currency,
        {{ convert_timestamp('date_time') }} AS transaction_date,
        {{ extract_json_value('rates', 'USD') }} AS exchange_rate_to_usd
    FROM {{ source('globepay', 'acceptance') }}
)

SELECT * FROM raw_acceptance;
