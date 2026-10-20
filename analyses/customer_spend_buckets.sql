WITH spend_per_customer AS (
  SELECT c.customer_id, COALESCE(SUM(line_total),0) AS total_spend
  FROM main.dim_customers c
  LEFT JOIN main.fct_orders o ON c.customer_id = o.customer_id 
  GROUP BY c.customer_id
),
bucketed AS (
  SELECT customer_id,
  CASE 
	  WHEN total_spend = 0 THEN '0'
	  WHEN total_spend > 0 AND total_spend <= 2500 THEN '1-2500'
	  WHEN total_spend > 2500 AND total_spend <= 5000 THEN '2500-5000'
	  WHEN total_spend > 5000 AND total_spend <= 7500 THEN '5000-7500'
	  WHEN total_spend > 7500 AND total_spend <= 10000 THEN '7500-10000'
	  ELSE '10000+'
  END AS spend_bucket,
  CASE 
	  WHEN total_spend = 0 THEN 1
	  WHEN total_spend > 0 AND total_spend <= 2500 THEN 2
	  WHEN total_spend > 2500 AND total_spend <= 5000 THEN 3
	  WHEN total_spend > 5000 AND total_spend <= 7500 THEN 4
	  WHEN total_spend > 7500 AND total_spend <= 10000 THEN 5
	  ELSE 6
  END AS bucket_order
  FROM spend_per_customer
)
SELECT spend_bucket, COUNT(*) AS customer_count
FROM bucketed
GROUP BY spend_bucket, bucket_order
ORDER BY bucket_order
