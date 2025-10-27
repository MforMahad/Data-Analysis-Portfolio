


select *
from layoffs_staging2
;

select max(total_laid_off), max(percentage_laid_off)
from layoffs_staging2
;


select *
from layoffs_staging2
where percentage_laid_off = 1
order by total_laid_off desc	
;



select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc
;

select min(`date`), max(`date`)
from layoffs_staging2
;



select industry, sum(total_laid_off)
from layoffs_staging2
group by industry
order by 2 desc
;


select year(`date`), sum(total_laid_off)
from layoffs_staging2
group by year(`date`)
order by 2 desc
;

select stage, sum(total_laid_off)
from layoffs_staging2
group by stage
order by 2 desc
;


select company, avg(percentage_laid_off)
from layoffs_staging2
group by company
order by 2 desc
;


# rolling total layoffs based on months

select substring(`date`,6,2)
from layoffs_staging2
; 

# rolling total layoffs based on months and year
select substring(`date`,1,7) as `MONTH`, sum(total_laid_off)
from layoffs_staging2
where substring(`date`,1,7) 
group by `MONTH`
order by 1 asc
; 

#rolling data using CTE
with Rolling_Total as
(
select substring(`date`, 1,7) as `Month`, sum(total_laid_off)  as total_off
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `Month`
order by 1 asc
)
select `Month`, total_off
,sum(total_off) over( order by `Month`) as rolling_total
from Rolling_Total;




#checking companies how much they were laying off per year

select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc
;
# this one checking companies how much they were laying off per year

select company, year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
order by company asc
;

# now we will rank which year they layoff the most
select company, year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
order by 3 asc
;
#//////////////////////////////////////////////

with Company_year(company, years, total_laid_off) as
(
select company, year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
),
#second CTE we hit the first CTE to make that second CTe
 Company_year_rank as
(
select *, dense_rank() over(partition by years order by total_laid_off desc) as Ranking
from Company_year
where years is not null
order by ranking asc
)
# we filtered on that rank
select *
from company_year_rank
where Ranking <= 5
;
