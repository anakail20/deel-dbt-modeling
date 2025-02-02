{{ config(
    materialized='table', 
    tags=['finance', 'payments', 'chargebacks'],
    enabled=True,
) }}

WITH transactions AS (
    SELECT 
        external_ref,
        date_time,
        country,
        currency,
        amount,
        state,
        chargeback_amount,
        chargeback
    FROM {{ ref('int_globepay_transactions') }}
),

-- 1. Acceptance Rate Over Time
acceptance_rate AS (
    SELECT 
        DATE_TRUNC('month', date_time) AS month,
        COUNT(CASE WHEN state = 'ACCEPTED' THEN external_ref END) AS accepted_transactions,
        COUNT(external_ref) AS total_transactions,
        ROUND(100.0 * COUNT(CASE WHEN state = 'ACCEPTED' THEN external_ref END) / NULLIF(COUNT(external_ref), 0), 2) AS acceptance_rate
    FROM transactions
    GROUP BY 1
),

-- 2. Countries where declined transactions > $25M
declined_transactions AS (
    SELECT 
        country,
        SUM(CASE WHEN state = 'DECLINED' THEN amount ELSE 0 END) AS declined_amount
    FROM transactions
    GROUP BY 1
    HAVING SUM(CASE WHEN state = 'DECLINED' THEN amount ELSE 0 END) > 25000000
),

-- 3. Transactions Missing Chargeback Data
missing_chargeback AS (
    SELECT 
        external_ref, 
        date_time, 
        country, 
        currency, 
        amount,
        state
    FROM transactions
    WHERE chargeback_amount = 0 OR chargeback IS FALSE
)

SELECT 'acceptance_rate' AS metric_type, * FROM acceptance_rate
UNION ALL
SELECT 'declined_transactions' AS metric_type, * FROM declined_transactions
UNION ALL
SELECT 'missing_chargeback' AS metric_type, * FROM missing_chargeback;
