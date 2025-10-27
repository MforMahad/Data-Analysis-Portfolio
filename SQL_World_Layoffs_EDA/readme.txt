# 🧠 SQL Exploratory Data Analysis — World Layoffs Dataset

### 📊 Dataset Overview
- **Name:** World Layoffs Dataset  
- **Description:** Contains data about global layoffs across different companies, industries, and years.

---

### 🧹 Data Cleaning Summary
Before performing EDA, the dataset was cleaned by:
- Removing duplicates  
- Standardizing company and industry names  
- Handling NULL values  
- Removing unnecessary columns  

---

### 🔍 Exploratory Data Analysis (EDA)
**Goal:** Understand layoff patterns by year, industry, company, and location.

#### Key Queries:
```sql
-- Total layoffs per year
SELECT year, SUM(total_laid_off)
FROM world_layoffs
GROUP BY year
ORDER BY year;
