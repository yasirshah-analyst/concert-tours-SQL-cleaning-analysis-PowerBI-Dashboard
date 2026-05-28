-- =========================================================
-- FEMALE CONCERT TOURS DATA CLEANING & ANALYSIS PROJECT
-- =========================================================

-- =========================================================
-- 1. CREATE RAW (DIRTY) TABLE
-- =========================================================
-- Store the original uncleaned dataset.

CREATE TABLE female_tours_dirty (
    rank TEXT,
    peak TEXT,
    all_time_peak TEXT,
    actual_gross TEXT,
    adjusted_gross TEXT,
    artist TEXT,
    tour_title TEXT,
    years TEXT,
    shows TEXT,
    average_gross TEXT,
    ref TEXT
);

SELECT * 
FROM female_tours_dirty;

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

-- =========================================================
-- 15. BUSINESS ANALYSIS QUERIES
-- =========================================================

-- =========================================================
-- Analysis 1: Highest Revenue Artists
-- =========================================================
-- Find artists with highest total earnings.

SELECT artist,
       SUM("actual_gross($)") AS total_revenue
FROM female_tours_clean
GROUP BY artist
ORDER BY total_revenue DESC
LIMIT 5;

-- =========================================================
-- Analysis 2: Highest Grossing Tours
-- =========================================================
-- Identify top earning tours.

SELECT tour_title,
       artist,
       SUM("actual_gross($)") AS total_revenue
FROM female_tours_clean
GROUP BY tour_title, artist
ORDER BY total_revenue DESC
LIMIT 10;

-- =========================================================
-- Analysis 3: Shows vs Revenue
-- =========================================================
-- Check relationship between number of shows and revenue.

SELECT shows,
       SUM("actual_gross($)") AS total_revenue
FROM female_tours_clean
GROUP BY shows
ORDER BY shows;

-- =========================================================
-- Analysis 4: Revenue Over Time
-- =========================================================
-- Track revenue trends by year.

SELECT start_year,
       SUM("actual_gross($)") AS total_revenue
FROM female_tours_clean
GROUP BY start_year
ORDER BY start_year;

-- =========================================================
-- Analysis 5: Average Gross Per Artist
-- =========================================================
-- Compare average tour performance by artist.

SELECT artist,
       AVG("actual_gross($)") AS avg_gross
FROM female_tours_clean
GROUP BY artist
ORDER BY avg_gross DESC;