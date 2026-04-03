# SQL Data Cleaning & Analysis – Layoffs Dataset

## Overview
This project focuses on cleaning and analyzing a layoffs dataset using SQL to ensure reliable insights for decision-making.

Raw data often appears usable but contains hidden issues such as duplicates, missing values, and inconsistent formats that can distort analysis.

## Data Cleaning Steps
- Removed duplicate records using ROW_NUMBER window function
- Standardized company, industry, and country fields
- Converted date formats for accurate time analysis
- Handled missing values using joins and data imputation
- Removed irrelevant or unusable records

## Techniques Used
- Window Functions (ROW_NUMBER)
- CTEs (Common Table Expressions)
- Joins (Data reconciliation)
- Data standardization
- DENSE_RANK for ranking analysis

## Key Insights
- Layoffs were concentrated in specific time periods
- A small number of companies accounted for a large share of layoffs
- Certain industries showed consistently higher workforce reductions

## Business Impact
- Improved accuracy of reporting and trend analysis
- Enabled reliable comparison across time and companies
- Provided clearer visibility into workforce and industry trends

## Files
- layoffs_analysis.sql → Full SQL workflow
- layoffs.csv → Dataset used

## Conclusion
Accurate analysis depends on clean, validated data. This project demonstrates how structured data cleaning directly impacts the quality of business insights.
