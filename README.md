# Nashville-Housing-Data-Cleaning
SQL Data Cleaning Project | Real-world dataset | End-to-End Data Preparation
# 🏠 Nashville Housing Data Cleaning Project (SQL)

## 📌 Project Overview

This project focuses on cleaning and preparing a real-world housing dataset using SQL.
The goal is to transform raw, unstructured data into a clean and analysis-ready dataset.

---

## 📂 Dataset

* Source: Kaggle (Nashville Housing Data)
* Total Rows: 56,636
* Total Columns: 31

---

## 🧹 Data Cleaning Steps

### 1. Created Backup Table

* Created a duplicate table to preserve original raw data.

### 2. Removed Unnecessary Columns

* Dropped irrelevant columns such as:

  * MyUnknownColumn
  * Unnamed: 0
  * Suite/Condo
  * Image

### 3. Renamed Columns

* Converted column names to snake_case
* Improved readability and consistency

### 4. Converted Data Types

* Converted `sale_date` from TEXT to DATE
* Converted `year_built` from TEXT to INT

### 5. Handled Duplicates

* Identified duplicate records using key columns:

  * parcel_id, property_address, sale_price, sale_date, legal_reference
* Removed duplicates using ROW_NUMBER() and CTE

### 6. Handled Missing Values

* Converted blank values to NULL
* Removed rows with missing address and city (low volume)
* Replaced high-volume missing values (owner_name) with 'Unknown'

### 7. Data Validation

* Verified:

  * No duplicate records
  * No NULL or blank values in key columns
  * Consistent data types

---

## 🧠 Key Learnings

* Data cleaning using SQL
* Handling NULL and blank values
* Using window functions (ROW_NUMBER)
* Data validation techniques
* Writing production-level SQL queries

---

## 🚀 Tools Used

* MySQL
* SQL

---

## 📊 Future Work

* Perform data analysis
* Build Power BI dashboard
* Generate business insights

---

## 💼 Author

* Prasad S
* Aspiring Data Analyst
