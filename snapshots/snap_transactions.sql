{% snapshot snap_transactions %}

/*
Purpose:
- Tracks changes in transaction status (state) and chargeback events over time.
- Helps monitor updates to transactions for auditing, reporting, and fraud detection.

How it works:
- Uses `strategy='timestamp'` to capture changes based on date_time.
- Stores historical snapshots whenever stat` or chargeback status changes.
*/
{{ 
    config(
        target_schema='snapshots',
        unique_key='external_ref',  -- Ensures each transaction is uniquely tracked
        strategy='timestamp',       -- Captures changes based on `date_time`
        updated_at='date_time'      -- Detects updates in the transaction record
    ) 
}}

SELECT 
    external_ref,       
    date_time,          
    state,              
    chargeback,         
    amount,             
    currency,          
    country,           
    rates,              
    merchantReference   
FROM {{ source('staging', 'stg_globepay_transactions') }}

{% endsnapshot %}
