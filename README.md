# SQL Data Cleaning Project

### 🗂️ Dataset
- Dataset: Nashville Housing Data
- Source: Kaggle
- Rows: 56,000 | Columns: 19

### 🧹 Tasks Performed
1. Removed duplicate records
2. Standardized city and address formats
3. Handled NULL and blank values
4. Dropped unnecessary helper columns

### 💡 Key SQL Queries
```sql
DELETE FROM table_name
WHERE id NOT IN (
  SELECT MIN(id) FROM table_name GROUP BY address
);
