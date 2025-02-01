WITH transactions AS (
    SELECT * FROM {{ ref('int_globepay_transactions') }}
)

SELECT 
    external_ref,
    date_time,
    country,
    currency,
    amount AS transaction_amount,
    state,
    chargeback,
    chargeback_amount,
    reason AS chargeback_reason
FROM transactions
