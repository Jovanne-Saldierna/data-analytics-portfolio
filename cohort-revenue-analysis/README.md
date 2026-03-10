# Cohort Revenue & Retention Analysis

This project analyzes customer retention and lifetime value using cohort analysis. Customers are grouped by their acquisition month, allowing us to track how engagement and revenue evolve over time.

## Business Problem

Companies need to understand whether newly acquired customers generate long-term value. Cohort analysis allows analysts to evaluate retention trends and identify whether customer quality is improving or declining over time.

## Analytical Questions

- Do newer customer cohorts retain better than older cohorts?
- How does revenue evolve after customer acquisition?
- Which acquisition cohorts generate the highest lifetime value?
- Are retention trends improving over time?

## Analytical Approach

Customers are grouped into cohorts based on their **first purchase month**. Revenue and retention metrics are then tracked for each cohort over time.

The analysis calculates:

- cohort size
- monthly retention rates
- cohort revenue growth
- lifetime revenue per cohort

## SQL Techniques Demonstrated

- Common Table Expressions (CTEs)
- Cohort assignment logic
- Date truncation
- Retention calculations
- Window functions
- Revenue aggregation by cohort

## Business Insights

Cohort analysis helps identify whether product improvements or marketing strategies are attracting higher-quality customers. It also highlights long-term revenue trends that cannot be seen in simple monthly reporting.

## Files

- `cohort-analysis.sql` — SQL queries used to build cohort retention and revenue analysis
