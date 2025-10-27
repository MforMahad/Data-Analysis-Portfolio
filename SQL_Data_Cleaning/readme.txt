# SQL Data Cleaning Project

**Dataset:** <worldslayoffs>  
**Author:** Mahad (Maddy)  
**Date:** 2025-10-27

## Project Goal
Clean and prepare the raw dataset for meaningful analysis by removing duplicates, standardizing formats, handling missing values, and removing helper columns.

## Files in this folder
- `cleaning_project.sql` — Full SQL script with all cleaning steps (commented).
- `cleaned_dataset.csv` — Final cleaned dataset (exported).
- `raw_dataset_sample.csv` — Small sample of the original raw data (optional).
- `screenshots/` — Before/after screenshots (optional).

## Steps performed
1. **Exploratory counts and inspection**
   - Checked total rows, missing values per column, and basic stats.
2. **Removed duplicates**
   - Used `GROUP BY` + `MIN(id)` strategy and direct `DELETE ... JOIN` where appropriate.
3. **Standardized text fields**
   - Trimmed whitespace, converted to consistent case, normalized city names and other categorical values.
4. **Handled NULL & empty values**
   - Filled non-critical NULLs with defaults (e.g., 'Unknown').
   - Removed rows missing critical fields when necessary.
5. **Fixed data types & formats**
   - Converted date strings to proper `DATE` format using `STR_TO_DATE`.
6. **Split/combined columns**
   - Extracted `first_name` and `last_name` from `full_name` when helpful.
7. **Dropped helper/temp columns**
   - Removed intermediate columns used during the cleaning process.

## Key SQL examples
Example: remove duplicates by keeping minimum id
```sql
DELETE FROM raw_table
WHERE id NOT IN (
  SELECT min_id FROM (
    SELECT MIN(id) AS min_id FROM raw_table GROUP BY unique_key_column
  ) AS temp
);
