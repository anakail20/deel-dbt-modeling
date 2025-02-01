{{ config(materialized='view') }}

WITH raw_chargebacks AS (
    SELECT
        external_ref,
        CAST(chargeback AS BOOLEAN) AS chargeback_flag
    FROM {{ source('globepay', 'chargebacks') }}
)

SELECT * FROM raw_chargebacks
