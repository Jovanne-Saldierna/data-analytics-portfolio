# Customer Churn Analysis

This project explores customer retention patterns using SQL to identify churn risk, customer value, and revenue concentration across segments.

## Business Problem

Customer retention is one of the most important drivers of long-term revenue performance. Acquiring new customers is often more expensive than retaining existing ones, making churn analysis critical for sustainable growth.

This analysis was designed to answer several key business questions:

- Which customers generate the most lifetime revenue?
- How does customer tenure relate to retention and revenue contribution?
- Which customer segments are most at risk of churn?
- How does inactive customer behavior affect revenue stability?

## Analytical Approach

The project uses SQL to analyze customer transaction behavior and evaluate churn-related patterns across revenue, tenure, and order activity.

Key analyses include:

- Customer lifetime revenue and order volume
- Customer tenure calculation
- Revenue by customer segment
- Monthly active customer trends
- Churn flagging using inactivity thresholds
- Revenue ranking with window functions
- Customer tenure segmentation with CTEs

## SQL Techniques Demonstrated

- Aggregate analysis
- Common Table Expressions (CTEs)
- Window functions
- Conditional logic with CASE statements
- Churn flagging based on inactivity thresholds
- Segmentation analysis
- Join-based query structure

## Key Insights

- Customers with shorter tenure are more likely to churn earlier in the lifecycle
- A relatively small set of customers contributes a disproportionate share of total revenue
- Revenue stability depends heavily on retaining repeat purchasers
- Customer inactivity thresholds can be used to identify churn risk before full customer loss occurs

## Business Recommendations

- Prioritize retention efforts during the early customer lifecycle
- Create targeted programs for high-value customers with strong lifetime revenue
- Monitor inactivity windows as early warning signals for churn
- Use revenue concentration analysis to identify customers with outsized business impact

## Files

- `churn-analysis.sql` — SQL queries for customer retention, segmentation, and churn analysis
