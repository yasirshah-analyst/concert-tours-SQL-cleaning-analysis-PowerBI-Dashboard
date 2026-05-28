# 🎤 Female Concert Tours SQL Data Analysis

## 📌 Project Overview
This project is an end-to-end **SQL Data Cleaning and Business Analysis** using a kaggle dataset.

The goal is to transform raw, messy data into a clean, structured dataset and extract meaningful business insights such as top-earning artists, revenue trends, and tour performance.

---

## 🗂️ Dataset Description

- Source: Kaggle
- Dataset Name: Dirty Dataset for Data Cleaning Practice
- Link: https://www.kaggle.com/datasets/amruthayenikonda/dirty-dataset-to-practice-data-cleaning
- Description: A purposely messy dataset containing concert tour data, designed for practicing data cleaning skills. It includes inconsistencies such as  symbols, missing values, incorrect formats, and duplicate rankings.
- License: CC0: Public Domain

The dataset contains information about female concert tours, including:

- Artist name
- Tour title
- Revenue (actual & adjusted gross)
- Number of shows
- Tour years
- Ranking information

Two versions of the dataset are used:
- **Dirty dataset (raw)**
- **Cleaned dataset (processed using SQL)**

---

## 🧹 Data Cleaning Process (SQL)

Key cleaning steps performed:

- Removed unnecessary columns (`peak`, `all_time_peak`, `ref`)
- Fixed incorrect ranking using `ROW_NUMBER()`
- Converted text-based numeric columns into proper `BIGINT`
- Removed symbols using `REGEXP_REPLACE()`:
  - `$` currency symbols
  - commas `,`
  - footnotes like `[a]`, `[b]`
- Cleaned text fields (tour titles)
- Split `years` into `start_year` and `end_year`

---

## 📈 Business Analysis

The project answers key business questions:

### 1. Top Revenue Artists
Identify artists with the highest total revenue.

### 2. Highest Grossing Tours
Find the most successful tours based on revenue.

### 3. Shows vs Revenue Relationship
Analyze whether more shows lead to higher revenue.

### 4. Revenue Trends Over Time
Track how tour revenue changes by year.

### 5. Average Performance by Artist
Compare average gross earnings per artist.

---

## 🛠️ SQL Skills Used

- Data Cleaning with SQL
- `ALTER TABLE`, `UPDATE`, `DROP COLUMN`
- `REGEXP_REPLACE()`
- `CASE WHEN`
- `ROW_NUMBER()` window function
- Aggregations (`SUM`, `AVG`)
- Grouping and sorting data
- Data type conversion
- Feature engineering

---

## 📁 Project Structure

```id="proj1"
female-concert-tours-sql-analysis/
│
├── SQL/
│   └── female_tours_sql_project.sql
│
├── Data/
│   ├── Clean/
│   │       └── female_tours_clean.csv
│   │
│   └── Raw/
│       └── female_tours_dirty.csv
│           
│
└── README.md
```


---

## 🚀 Key Insights

- A few artists dominate total revenue generation
- Number of shows does not always guarantee higher revenue
- Tour duration impacts total earnings
- Revenue varies significantly across years

---

## 📌 Tools Used

- PostgreSQL / SQL
- Regular Expressions (Regex)
- Data Cleaning Techniques

---

## 👤 Author

- Yasir Shah
- SQL Portfolio Project

---

## ⭐ Purpose

This project is part of my data analytics learning journey to practice:

- Real-world SQL data cleaning
- Business problem solving
- Portfolio building for analytics roles
