-- =========================================
-- CUSTOMER COHORT RETENTION ANALYSIS
-- =========================================


-- -----------------------------------------
-- 1. Identify first purchase date for each customer
-- -----------------------------------------

WITH customer_first_purchase AS (

    SELECT
         customer_id
        ,MIN(order_date)                     AS first_purchase_date
    FROM sales
    GROUP BY
          customer_id

)



-- -----------------------------------------
-- 2. Assign customers to acquisition cohorts
-- -----------------------------------------

, customer_cohorts AS (

    SELECT
         customer_id
        ,DATE_TRUNC('month', first_purchase_date)   AS cohort_month
    FROM customer_first_purchase

)



-- -----------------------------------------
-- 3. Combine order data with cohort information
-- -----------------------------------------

, cohort_orders AS (

    SELECT
         s.customer_id
        ,DATE_TRUNC('month', s.order_date)          AS order_month
        ,c.cohort_month
        ,s.revenue
    FROM sales s
    JOIN customer_cohorts c
          ON s.customer_id = c.customer_id

)



-- -----------------------------------------
-- 4. Calculate months since acquisition
-- -----------------------------------------

, cohort_activity AS (

    SELECT
         customer_id
        ,cohort_month
        ,order_month
        ,DATE_PART('month', AGE(order_month, cohort_month)) AS months_since_acquisition
        ,revenue
    FROM cohort_orders

)



-- -----------------------------------------
-- 5. Cohort retention metrics
-- -----------------------------------------

SELECT
     cohort_month
    ,months_since_acquisition
    ,COUNT(DISTINCT customer_id)         AS active_customers
    ,SUM(revenue)                        AS cohort_revenue
    ,AVG(revenue)                        AS avg_revenue_per_customer
FROM cohort_activity
GROUP BY
     cohort_month
    ,months_since_acquisition
ORDER BY
     cohort_month
    ,months_since_acquisition;
