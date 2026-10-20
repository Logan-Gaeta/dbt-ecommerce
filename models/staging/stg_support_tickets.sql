SELECT
    ticket_id,
    customer_id,
    CAST(created_date AS date),
    LOWER(TRIM(category)),
    LOWER(TRIM(status))
FROM {{ source('external', 'support_tickets') }}