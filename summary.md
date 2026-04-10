# 📊 Nashville Housing Data Project – Summary

## 🧹 Data Cleaning

Performed complete data cleaning on the housing dataset:

* Removed irrelevant and duplicate columns
* Renamed columns for better readability (snake_case format)
* Converted `sale_date` from TEXT to DATE format
* Identified and removed duplicate records using window functions
* Handled missing values:

  * Converted blanks to NULL
  * Removed rows with critical missing data (address, city)
  * Replaced high-volume missing values with 'Unknown'
* Cleaned numeric columns by removing commas and invalid characters
* Converted columns to appropriate data types
* Replaced missing numeric values using averages

---

## 📊 Data Analysis

Performed SQL-based analysis to generate insights:

* Total number of properties and total sales revenue
* Minimum and maximum property prices
* City-wise property distribution
* Average sale price per city
* Top 10 most expensive properties
* Year-wise sales trend analysis
* Year-over-year growth analysis
* Property classification (Low, Mid, High)
* Vacant vs non-vacant property comparison
* Top performing cities by revenue
* Ranking properties within each city
* Running total sales analysis

---

## 🛠 Tools & Skills Used

* SQL (MySQL)
* Data Cleaning
* Data Transformation
* Window Functions
* Data Analysis

---

## ✅ Final Outcome

The dataset is fully cleaned, structured, and ready for analysis.
This project demonstrates end-to-end data analytics workflow from raw data to insights.

🚀 Ready for dashboarding and business decision-making.
