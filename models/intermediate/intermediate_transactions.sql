WITH acceptance_data AS (
    SELECT 
        external_ref,
        date_time,
        country,
        currency,
        amount,
        state
    FROM {{ source('seeds_globepay', 'acceptance_report') }}
),

chargeback_data AS (
    SELECT 
        external_ref,
        chargeback_date AS date_time,
        chargeback_amount,
        reason
    FROM {{ source('seeds_globepay', 'chargeback_report') }}
)

SELECT 
    a.external_ref,
    a.date_time,
    a.country,
    a.currency,
    a.amount,
    a.state,
    {{ coalesce_null('c.chargeback_amount', 0) }} AS chargeback_amount,
    {{ coalesce_null('c.reason', "'No Chargeback'") }} AS reason,
    CASE WHEN c.external_ref IS NOT NULL THEN TRUE ELSE FALSE END AS chargeback
FROM acceptance_data a
LEFT JOIN chargeback_data c 
    ON a.external_ref = c.external_ref
