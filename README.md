# 🛢️ Oil & Gas Production Data Cleaning 

---

## 📖 Project Overview

This project focuses on cleaning and standardizing a messy oil and gas production dataset using SQL Server.

The dataset simulates real-world upstream operational data, containing inconsistencies such as missing values, invalid entries, mixed formats, and logical data issues.  

A structured SQL-based data cleaning pipeline was implemented to transform the raw dataset into a clean, consistent, and analysis-ready format.

---

## 🎯 Objectives

- Standardize inconsistent well identifiers  
- Clean and format date values  
- Handle missing and invalid production data  
- Apply domain-driven logic to ensure data accuracy  
- Improve overall data quality for downstream analysis  

---

## 📂 Raw Dataset

The raw dataset used in this project is included for reference:

👉 [Download Dataset](oil_gas_raw.xlsx))

This file contains the original uncleaned data with:
- Inconsistent well IDs and names  
- Mixed date formats  
- Missing values  
- Data entry errors  
- Logical inconsistencies  

---

## 🧠 Dataset Description

The dataset represents daily production from multiple oil wells and includes:

- **Well_ID / Well_Name** → Inconsistent well identifiers  
- **Location** → Oilfield region  
- **Date** → Production date (mixed formats)  
- **Oil_Production_BBL** → Oil output (barrels)  
- **Gas_Production_MSCF** → Gas output  
- **Water_Cut (%)** → Water content in production  
- **Downtime_Hours** → Non-operational hours  
- **Equipment_Status** → Operational condition  
- **Operator_Name** → Operating company  

Each row represents daily well-level production data.

---

## 🧹 Data Cleaning Approach

The dataset contained several real-world data quality issues:

- Inconsistent naming conventions  
- Missing values across multiple columns  
- Mixed date formats  
- Invalid numerical values  
- Logical inconsistencies across operational fields  

A step-by-step SQL cleaning pipeline was applied to address these issues.

---

## 🔧 Data Cleaning Steps

### 🔹 1. Standardizing Well Identifiers

- Extracted numeric components from inconsistent `Well_ID` values  
- Standardized identifiers into:
  - `WXXXX` → WellID  
  - `WellXXXX` → WellName  
- Removed original inconsistent columns  

---

### 🔹 2. Handling Missing Well Identifiers

- Derived missing WellID from WellName and vice versa  
- Replaced unrecoverable values with `"UNKNOWN"`  
- Ensured no NULL identifiers remain  

---

### 🔹 3. Date Standardization

- Converted mixed date formats into SQL `DATE` format using `TRY_CONVERT`  
- Enabled consistent time-series analysis  

---

### 🔹 4. Handling Missing Production Values

Applied domain-driven logic:

- Set oil and gas production to **0** for downtime or equipment failure scenarios  
- Estimated missing values using **well-level averages** for active and maintenance wells  
- Ensured realistic operational behavior  

---

### 🔹 5. Water Cut Cleaning

- Set water cut to **0** for non-producing wells  
- Estimated missing values using well-level averages  
- Maintained consistency with production data  

---

### 🔹 6. Downtime Handling

- Assigned **0 downtime** for active wells  
- Estimated downtime for maintenance scenarios using historical averages  
- Replaced remaining NULL downtime values appropriately  

---

### 🔹 7. Handling Missing Categorical Data

- Replaced missing values in:
  - WellID  
  - WellName  
  - Location  

with `"UNKNOWN"` to prevent aggregation issues  

---

## 🧠 Key Data Quality Improvements

After cleaning:

- All well identifiers are standardized and consistent  
- Date column is properly formatted  
- Missing production values are handled using business logic  
- Logical inconsistencies are minimized  
- Dataset is fully analysis-ready  

---

## 🛠️ Tools Used

- **SQL Server** → Data cleaning and transformation  

---

## 📁 Project Structure

Oil-Gas-Data-Cleaning/
└── oil_gas_raw.xlsx
└── data_cleaning.sql
└── README.md  

---

## 🎯 Conclusion

This project demonstrates the ability to clean complex, messy operational data using structured SQL techniques and domain-driven logic.

The final dataset is consistent, reliable, and ready for advanced analysis and reporting.
