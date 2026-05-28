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

```sql
-- =========================================================
-- 2. CREATE CLEANING WORKING TABLE
-- =========================================================
-- Create a separate table for cleaning operations.

CREATE TABLE female_tours_clean AS
SELECT *
FROM female_tours_dirty;

SELECT *
FROM female_tours_clean;

-- =========================================================
-- 3. REMOVE UNNECESSARY COLUMNS
-- =========================================================
-- Remove columns that are not needed for analysis.

ALTER TABLE female_tours_clean
DROP COLUMN peak,
DROP COLUMN all_time_peak,
DROP COLUMN ref;

-- =========================================================
-- 4. FIX RANK COLUMN
-- =========================================================
-- Rebuild rank values properly using revenue order.

WITH ranked AS (
    SELECT *,
           ROW_NUMBER() OVER(ORDER BY actual_gross DESC) AS new_rank
    FROM female_tours_clean
)

UPDATE female_tours_clean t
SET rank = r.new_rank
FROM ranked r
WHERE t.artist = r.artist
AND t.tour_title = r.tour_title;

-- =========================================================
-- 5. CONVERT RANK TO INTEGER
-- =========================================================
-- Convert rank from TEXT into numeric datatype.

ALTER TABLE female_tours_clean
ALTER COLUMN rank TYPE INT
USING rank::INT;

-- =========================================================
-- 6. CLEAN ACTUAL GROSS COLUMN
-- =========================================================
-- Remove symbols and convert revenue into BIGINT.
-- Remove footnotes like [a], [b], [12]

UPDATE female_tours_clean
SET actual_gross = REGEXP_REPLACE(
    actual_gross,
    '\[[^\]]*\]',
    '',
    'g'
);

-- Convert into numeric datatype

ALTER TABLE female_tours_clean
ALTER COLUMN actual_gross TYPE BIGINT
USING REPLACE(
          REPLACE(actual_gross, '$', ''),
          ',',
          ''
      )::BIGINT;

-- =========================================================
-- 7. CLEAN ADJUSTED GROSS COLUMN
-- =========================================================
-- Remove symbols and convert adjusted revenue into BIGINT.

ALTER TABLE female_tours_clean
ALTER COLUMN adjusted_gross TYPE BIGINT
USING REPLACE(
          REPLACE(adjusted_gross, '$', ''),
          ',',
          ''
      )::BIGINT;

-- =========================================================
-- 8. CLEAN TOUR TITLE COLUMN
-- =========================================================
-- Remove unwanted symbols and spaces from tour titles.
-- Remove footnotes

UPDATE female_tours_clean
SET tour_title = REGEXP_REPLACE(
    tour_title,
    '\[[^\]]*\]',
    '',
    'g'
);

-- Remove special symbols

UPDATE female_tours_clean
SET tour_title = REGEXP_REPLACE(
    tour_title,
    '[†‡*]',
    '',
    'g'
);

-- Remove extra spaces

UPDATE female_tours_clean
SET tour_title = TRIM(tour_title);

-- =========================================================
-- 9. CLEAN SHOWS COLUMN
-- =========================================================
-- Convert shows column into INTEGER datatype.

ALTER TABLE female_tours_clean
ALTER COLUMN shows TYPE INT
USING shows::INT;

-- =========================================================
-- 10. SPLIT YEARS COLUMN
-- =========================================================
-- Create separate start and end year columns.
-- Create new columns

ALTER TABLE female_tours_clean
ADD COLUMN start_year INT,
ADD COLUMN end_year INT;

-- Handle year ranges like 2013–2014

UPDATE female_tours_clean
SET start_year = CAST(SPLIT_PART(years, '–', 1) AS INT),
    end_year = CAST(SPLIT_PART(years, '–', 2) AS INT)
WHERE years LIKE '%–%';

-- Handle single year values like 2018

UPDATE female_tours_clean
SET start_year = CAST(years AS INT),
    end_year = CAST(years AS INT)
WHERE years NOT LIKE '%–%';

-- Remove old years column

ALTER TABLE female_tours_clean
DROP COLUMN years;

-- =========================================================
-- 11. CLEAN AVERAGE GROSS COLUMN
-- =========================================================
-- Convert average gross into BIGINT datatype.

ALTER TABLE female_tours_clean
ALTER COLUMN average_gross TYPE BIGINT
USING REPLACE(
          REPLACE(average_gross, '$', ''),
          ',',
          ''
      )::BIGINT;

-- =========================================================
-- 12. RENAME REVENUE COLUMNS
-- =========================================================
-- Make column names more descriptive.

ALTER TABLE female_tours_clean
RENAME COLUMN actual_gross TO "actual_gross($)";

ALTER TABLE female_tours_clean
RENAME COLUMN adjusted_gross TO "adjusted_gross($)";

ALTER TABLE female_tours_clean
RENAME COLUMN average_gross TO "average_gross($)";

-- =========================================================
-- 13. FINAL CLEANED DATA PREVIEW
-- =========================================================
-- Check cleaned dataset structure and values.

SELECT *
FROM female_tours_clean;
```

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
