WITH transactions AS (
    SELECT * FROM {{ ref('int_globepay_transactions') }}
)

SELECT 
    country,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN state = 'Accepted' THEN 1 ELSE 0 END) AS accepted_transactions,
    SUM(CASE WHEN state = 'Declined' THEN 1 ELSE 0 END) AS declined_transactions,
    ROUND(SUM(CASE WHEN state = 'Accepted' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS acceptance_rate,
    COUNT(CASE WHEN chargeback = TRUE THEN 1 END) AS chargeback_count,
    ROUND(COUNT(CASE WHEN chargeback = TRUE THEN 1 END) * 100.0 / COUNT(*), 2) AS chargeback_rate
FROM transactions
GROUP BY country
