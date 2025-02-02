{% snapshot snap_transactions %}

/*
Purpose:
- Tracks changes in transaction status (state) and chargeback events over time.
- Helps monitor updates to transactions for auditing, reporting, and fraud detection.

How it works:
- Uses `strategy='timestamp'` to capture changes based on date_time.
- Stores historical snapshots whenever state or chargeback status changes.
*/

{{ 
    config(
        target_schema='snapshots',
        unique_key='external_ref',  
        strategy='timestamp',       
        updated_at='date_time'      
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
