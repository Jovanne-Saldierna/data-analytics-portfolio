# Product Funnel Analysis

This project analyzes user progression through a product conversion funnel using SQL. The goal is to identify where users drop off, evaluate conversion efficiency at each stage, and highlight opportunities to improve activation and purchase performance.

## Business Problem

Product and growth teams often need to understand where users abandon the customer journey. Funnel analysis helps quantify conversion at each stage of the user lifecycle and identify the highest-friction steps.

This project investigates a four-step user funnel:

- Visit
- Sign Up
- Trial Start
- Purchase

## Analytical Questions

- How many users reach each stage of the funnel?
- What is the conversion rate between each step?
- Where does the largest user drop-off occur?
- Which stage improvements would create the biggest overall impact?

## SQL Techniques Demonstrated

- Aggregation
- Common Table Expressions (CTEs)
- Conditional logic with CASE
- Conversion rate calculations
- Funnel stage comparison
- Step-level drop-off analysis

## Key Insights

- The largest drop-off occurs between Sign Up and Trial Start, indicating friction in activation.
- A smaller subset of users reaches the Purchase stage, suggesting downstream monetization opportunities.
- Funnel analysis provides a clear framework for prioritizing product improvements by business impact.

## Business Recommendations

- Improve onboarding flows between Sign Up and Trial Start
- Reduce friction in trial activation
- Test messaging and UX changes to increase downstream purchase conversion
- Monitor funnel conversion rates regularly as core product KPIs

## Files

- `funnel-analysis.sql` — SQL analysis of funnel volume, step conversion, and drop-off
