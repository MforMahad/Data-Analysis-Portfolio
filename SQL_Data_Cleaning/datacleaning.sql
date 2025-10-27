-- SQL Data Cleaning Script
-- Dataset: <layoffs>
-- Author: Mahad (Maddy)
-- Date: 2025-10-27



select *
from layoffs;


#steps to clean a dataset or database

-- 1. will remove duplicates
-- 2. Standardize the data like spelling mistaks
-- 3. Null values or blak values will add if we can add the values to those null or blank values
-- 4. Remove any colums if not nessesory or empty

-- so first we will duplicate the raw table 


create table layoffs_staging
like layoffs;




insert layoffs_staging
select *
from layoffs;

select *
from layoffs_staging;

-- now we have 2 different tables and we wil work or change the staging table not the real one 

-- now removing duplicates

# first we will select rows over columns

select *,
row_number() over(partition by company, industry, total_laid_off, percentage_laid_off, `date`) as row_num
from layoffs_staging;

# now we will filter if the row number is > 1 or above if yes then its duplicate

-- now creating cte to remove duplicates

with duplicate_cte as
(
select *,
row_number() over(partition by company,location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoffs_staging
)	
select *
from duplicate_cte
where row_num > 1;





CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;















insert into layoffs_staging2
select *,
row_number() over(partition by company,location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoffs_staging;




select *
from layoffs_staging2
where row_num > 1
;


delete
from layoffs_staging2
where row_num > 1
;

select *
from layoffs_staging2
;


-- Standardizing Data


select company, trim(company)
from layoffs_staging2;


update layoffs_staging2
set company = trim(company)
;

select distinct industry
from layoffs_staging2
order by 1
;

select *
from layoffs_staging2
where industry like 'Crypto%'
;


update layoffs_staging2
set industry = 'Crypto'
where industry like 'Crypto%'
;

select distinct country
from layoffs_staging2
order by 1
;

select distinct country, trim(trailing '.' from country)
from layoffs_staging2
order by 1
;

update layoffs_staging2
set country  = trim(trailing '.' from country)
where country like 'United States%'
;


select date,
str_to_date(`date`, '%m/%d/%Y')
from layoffs_staging2;

update layoffs_staging2
set `date` = str_to_date(`date`, '%m/%d/%Y');


select *
from layoffs_staging2;	

alter table layoffs_staging2
modify column `date` date;

 
 select *
 from layoffs_staging2
 where total_laid_off is null
 and percentage_laid_off is null
 ;
 
 select *
 from layoffs_staging2
 where company like "airbnb";
 
  
 select t1.industry, t2.industry
 from layoffs_staging2 t1
 join layoffs_staging2 t2
	on t1.company = t2.company
    and t1.location = t2.location
where (t1.industry is null or t1.industry =  '')
and t2.industry is not null
;

update layoffs_staging2
set industry = null
where industry = ''
;

update layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
set t1.industry = t2.industry
where (t1.industry is null or t1.industry = '')
and t2.industry is not null
;


delete 
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null
;

select *
from layoffs_staging2
; 

alter table layoffs_staging2
drop column row_num
;












