-- =========================================
-- CUSTOMER CHURN ANALYSIS
-- Advanced SQL portfolio project
-- =========================================


-- -----------------------------------------
-- 1. Customer lifetime revenue and order volume
-- -----------------------------------------

SELECT
     customer_id
    ,SUM(revenue)                    AS lifetime_revenue
    ,COUNT(order_id)                 AS total_orders
FROM sales
GROUP BY
      customer_id
ORDER BY
      lifetime_revenue DESC;



-- -----------------------------------------
-- 2. Customer tenure and purchase history
-- -----------------------------------------

SELECT
     customer_id
    ,MIN(order_date)                 AS first_purchase_date
    ,MAX(order_date)                 AS last_purchase_date
    ,DATEDIFF(day
        ,MIN(order_date)
        ,MAX(order_date)
      )                              AS customer_tenure_days
FROM sales
GROUP BY
      customer_id
ORDER BY
      customer_tenure_days DESC;



-- -----------------------------------------
-- 3. Revenue by customer segment
-- -----------------------------------------

SELECT
     customer_type
    ,SUM(revenue)                    AS total_revenue
    ,COUNT(DISTINCT customer_id)     AS customers
    ,AVG(revenue)                    AS avg_order_revenue
FROM sales
GROUP BY
      customer_type
ORDER BY
      total_revenue DESC;



-- -----------------------------------------
-- 4. Monthly active customers
-- -----------------------------------------

SELECT
     DATE_TRUNC('month', order_date) AS order_month
    ,COUNT(DISTINCT customer_id)     AS active_customers
FROM sales
GROUP BY
      order_month
ORDER BY
      order_month;



-- =========================================
-- ADVANCED SQL ANALYSIS
-- =========================================



-- -----------------------------------------
-- 5. Customer summary using CTE
-- -----------------------------------------

WITH customer_summary AS (

    SELECT
         customer_id
        ,MIN(order_date)             AS first_purchase_date
        ,MAX(order_date)             AS last_purchase_date
        ,COUNT(order_id)             AS total_orders
        ,SUM(revenue)                AS lifetime_revenue
        ,AVG(revenue)                AS avg_order_value
        ,DATEDIFF(day
            ,MIN(order_date)
            ,MAX(order_date)
          )                          AS customer_tenure_days
    FROM sales
    GROUP BY
          customer_id
)

SELECT
     customer_id
    ,first_purchase_date
    ,last_purchase_date
    ,total_orders
    ,lifetime_revenue
    ,avg_order_value
    ,customer_tenure_days
FROM customer_summary
ORDER BY
      lifetime_revenue DESC;



-- -----------------------------------------
-- 6. Customer churn flagging
-- -----------------------------------------

WITH customer_summary AS (

    SELECT
         customer_id
        ,MAX(order_date)             AS last_purchase_date
        ,SUM(revenue)                AS lifetime_revenue
        ,COUNT(order_id)             AS total_orders
    FROM sales
    GROUP BY
          customer_id

),

churn_flags AS (

    SELECT
         customer_id
        ,last_purchase_date
        ,lifetime_revenue
        ,total_orders
        ,CASE
            WHEN CURRENT_DATE - last_purchase_date > 90
            THEN 'Churned'
            ELSE 'Active'
         END                         AS customer_status
    FROM customer_summary

)

SELECT
     customer_status
    ,COUNT(*)                        AS customers
    ,SUM(lifetime_revenue)           AS total_revenue
    ,AVG(lifetime_revenue)           AS avg_customer_revenue
FROM churn_flags
GROUP BY
      customer_status
ORDER BY
      total_revenue DESC;



-- -----------------------------------------
-- 7. Revenue ranking using window functions
-- -----------------------------------------

WITH customer_summary AS (

    SELECT
         customer_id
        ,SUM(revenue)                AS lifetime_revenue
        ,COUNT(order_id)             AS total_orders
        ,MAX(order_date)             AS last_purchase_date
    FROM sales
    GROUP BY
          customer_id

),

churn_flags AS (

    SELECT
         customer_id
        ,lifetime_revenue
        ,total_orders
        ,CASE
            WHEN CURRENT_DATE - last_purchase_date > 90
            THEN 'Churned'
            ELSE 'Active'
         END                         AS customer_status
    FROM customer_summary

)

SELECT
     customer_id
    ,customer_status
    ,total_orders
    ,lifetime_revenue
    ,RANK() OVER (
          PARTITION BY customer_status
          ORDER BY lifetime_revenue DESC
      )                               AS revenue_rank_within_status
FROM churn_flags
ORDER BY
     customer_status
    ,revenue_rank_within_status;



-- -----------------------------------------
-- 8. Customer tenure segmentation
-- -----------------------------------------

WITH customer_summary AS (

    SELECT
         customer_id
        ,SUM(revenue)               AS lifetime_revenue
        ,DATEDIFF(day
           ,MIN(order_date)
           ,MAX(order_date)
        )                           AS tenure_days
    FROM sales
    GROUP BY
          customer_id

)

SELECT
      CASE
          WHEN tenure_days < 30  THEN '0-29 days'
          WHEN tenure_days < 90  THEN '30-89 days'
          WHEN tenure_days < 180 THEN '90-179 days'
          ELSE '180+ days'
     END                             AS tenure_segment
    ,COUNT(*)                        AS customers
    ,SUM(lifetime_revenue)           AS total_revenue
    ,AVG(lifetime_revenue)           AS avg_revenue_per_customer
FROM customer_summary
GROUP BY
      tenure_segment
ORDER BY
      tenure_segment;



-- -----------------------------------------
-- 9. Example join-based revenue analysis
-- -----------------------------------------

-- SELECT
--      c.customer_id
--     ,c.customer_type
--     ,COUNT(DISTINCT o.order_id)   AS total_orders
--     ,SUM(o.revenue)               AS total_revenue
-- FROM customers c
-- JOIN orders o
--       ON c.customer_id = o.customer_id
-- GROUP BY
--      c.customer_id
--     ,c.customer_type
-- ORDER BY
--      total_revenue DESC;



-- -----------------------------------------
-- 10. Monthly retention trend
-- -----------------------------------------

WITH monthly_activity AS (

    SELECT
         DATE_TRUNC('month', order_date) AS order_month
        ,customer_id
    FROM sales
    GROUP BY
         order_month
        ,customer_id

)

SELECT
      order_month
    ,COUNT(DISTINCT customer_id)     AS active_customers
FROM monthly_activity
GROUP BY
      order_month
ORDER BY
      order_month;
