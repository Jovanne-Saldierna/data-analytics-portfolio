-- =========================================
-- PRODUCT FUNNEL ANALYSIS
-- Advanced SQL portfolio project
-- =========================================


-- -----------------------------------------
-- 1. Funnel stage volume
-- -----------------------------------------

SELECT
     funnel_stage
    ,COUNT(DISTINCT user_id)         AS users_at_stage
FROM product_events
GROUP BY
      funnel_stage
ORDER BY
      CASE funnel_stage
          WHEN 'Visit'       THEN 1
          WHEN 'Sign Up'     THEN 2
          WHEN 'Trial Start' THEN 3
          WHEN 'Purchase'    THEN 4
      END;



-- -----------------------------------------
-- 2. Funnel stage summary in one row
-- -----------------------------------------

WITH funnel_counts AS (

    SELECT
         COUNT(DISTINCT CASE WHEN funnel_stage = 'Visit'       THEN user_id END) AS visit_users
        ,COUNT(DISTINCT CASE WHEN funnel_stage = 'Sign Up'     THEN user_id END) AS signup_users
        ,COUNT(DISTINCT CASE WHEN funnel_stage = 'Trial Start' THEN user_id END) AS trial_users
        ,COUNT(DISTINCT CASE WHEN funnel_stage = 'Purchase'    THEN user_id END) AS purchase_users
    FROM product_events

)

SELECT
     visit_users
    ,signup_users
    ,trial_users
    ,purchase_users
FROM funnel_counts;



-- -----------------------------------------
-- 3. Funnel conversion rates
-- -----------------------------------------

WITH funnel_counts AS (

    SELECT
         COUNT(DISTINCT CASE WHEN funnel_stage = 'Visit'       THEN user_id END) AS visit_users
        ,COUNT(DISTINCT CASE WHEN funnel_stage = 'Sign Up'     THEN user_id END) AS signup_users
        ,COUNT(DISTINCT CASE WHEN funnel_stage = 'Trial Start' THEN user_id END) AS trial_users
        ,COUNT(DISTINCT CASE WHEN funnel_stage = 'Purchase'    THEN user_id END) AS purchase_users
    FROM product_events

)

SELECT
     visit_users
    ,signup_users
    ,trial_users
    ,purchase_users
    ,ROUND(signup_users  * 1.0 / NULLIF(visit_users, 0), 4)   AS visit_to_signup_rate
    ,ROUND(trial_users   * 1.0 / NULLIF(signup_users, 0), 4)  AS signup_to_trial_rate
    ,ROUND(purchase_users * 1.0 / NULLIF(trial_users, 0), 4)  AS trial_to_purchase_rate
    ,ROUND(purchase_users * 1.0 / NULLIF(visit_users, 0), 4)  AS overall_visit_to_purchase_rate
FROM funnel_counts;



-- -----------------------------------------
-- 4. Funnel drop-off by stage
-- -----------------------------------------

WITH funnel_counts AS (

    SELECT
         COUNT(DISTINCT CASE WHEN funnel_stage = 'Visit'       THEN user_id END) AS visit_users
        ,COUNT(DISTINCT CASE WHEN funnel_stage = 'Sign Up'     THEN user_id END) AS signup_users
        ,COUNT(DISTINCT CASE WHEN funnel_stage = 'Trial Start' THEN user_id END) AS trial_users
        ,COUNT(DISTINCT CASE WHEN funnel_stage = 'Purchase'    THEN user_id END) AS purchase_users
    FROM product_events

)

SELECT
     visit_users - signup_users      AS dropoff_after_visit
    ,signup_users - trial_users      AS dropoff_after_signup
    ,trial_users - purchase_users    AS dropoff_after_trial
FROM funnel_counts;



-- -----------------------------------------
-- 5. User-level funnel progression
-- -----------------------------------------

WITH user_funnel AS (

    SELECT
         user_id
        ,MAX(CASE WHEN funnel_stage = 'Visit'       THEN 1 ELSE 0 END) AS visited
        ,MAX(CASE WHEN funnel_stage = 'Sign Up'     THEN 1 ELSE 0 END) AS signed_up
        ,MAX(CASE WHEN funnel_stage = 'Trial Start' THEN 1 ELSE 0 END) AS started_trial
        ,MAX(CASE WHEN funnel_stage = 'Purchase'    THEN 1 ELSE 0 END) AS purchased
    FROM product_events
    GROUP BY
          user_id

)

SELECT
     user_id
    ,visited
    ,signed_up
    ,started_trial
    ,purchased
FROM user_funnel
ORDER BY
      user_id;



-- -----------------------------------------
-- 6. Segment users by deepest funnel stage
-- -----------------------------------------

WITH user_funnel AS (

    SELECT
         user_id
        ,MAX(CASE WHEN funnel_stage = 'Visit'       THEN 1 ELSE 0 END) AS visited
        ,MAX(CASE WHEN funnel_stage = 'Sign Up'     THEN 1 ELSE 0 END) AS signed_up
        ,MAX(CASE WHEN funnel_stage = 'Trial Start' THEN 1 ELSE 0 END) AS started_trial
        ,MAX(CASE WHEN funnel_stage = 'Purchase'    THEN 1 ELSE 0 END) AS purchased
    FROM product_events
    GROUP BY
          user_id

)

SELECT
     CASE
          WHEN purchased = 1     THEN 'Purchase'
          WHEN started_trial = 1 THEN 'Trial Start'
          WHEN signed_up = 1     THEN 'Sign Up'
          WHEN visited = 1       THEN 'Visit Only'
          ELSE 'Unknown'
     END                         AS deepest_stage_reached
    ,COUNT(*)                    AS users
FROM user_funnel
GROUP BY
      deepest_stage_reached
ORDER BY
      users DESC;



-- -----------------------------------------
-- 7. Monthly funnel performance
-- -----------------------------------------

WITH monthly_funnel AS (

    SELECT
         DATE_TRUNC('month', event_date) AS event_month
        ,COUNT(DISTINCT CASE WHEN funnel_stage = 'Visit'       THEN user_id END) AS visit_users
        ,COUNT(DISTINCT CASE WHEN funnel_stage = 'Sign Up'     THEN user_id END) AS signup_users
        ,COUNT(DISTINCT CASE WHEN funnel_stage = 'Trial Start' THEN user_id END) AS trial_users
        ,COUNT(DISTINCT CASE WHEN funnel_stage = 'Purchase'    THEN user_id END) AS purchase_users
    FROM product_events
    GROUP BY
          event_month

)

SELECT
     event_month
    ,visit_users
    ,signup_users
    ,trial_users
    ,purchase_users
    ,ROUND(signup_users   * 1.0 / NULLIF(visit_users, 0), 4)   AS visit_to_signup_rate
    ,ROUND(trial_users    * 1.0 / NULLIF(signup_users, 0), 4)  AS signup_to_trial_rate
    ,ROUND(purchase_users * 1.0 / NULLIF(trial_users, 0), 4)   AS trial_to_purchase_rate
FROM monthly_funnel
ORDER BY
      event_month;



-- -----------------------------------------
-- 8. Example join-based funnel analysis
-- -----------------------------------------

-- SELECT
--      u.user_id
--     ,u.signup_date
--     ,e.funnel_stage
--     ,e.event_date
-- FROM users u
-- JOIN product_events e
--       ON u.user_id = e.user_id
-- ORDER BY
--      u.user_id
--     ,e.event_date;
