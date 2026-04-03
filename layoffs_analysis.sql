Select * from layoffs;


-- 1. Remove Duplicates
-- 2. Standardize the data
-- 3. Null values or blank values
-- 4. Remove any columns


Drop Table if exists layoffs_staging;


Create table layoffs_staging
	Like layoffs;
    
    

Insert layoffs_staging
Select * from layoffs;



Select * from layoffs;
Select * from layoffs_staging;



Select *, 
ROW_NUMBER() OVER(
Partition by Company, location, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
from layoffs_staging;

With duplicate_cte AS
(
Select *, 
ROW_NUMBER() OVER(
Partition by Company, location, industry, total_laid_off, percentage_laid_off, `date`, stage,
country, funds_raised_millions) AS row_num
from layoffs_staging
)
Select * 
from duplicate_cte
WHERE row_num > 1;


select * from layoffs_staging where company = 'casper';





With duplicate_cte AS
(
Select *, 
ROW_NUMBER() OVER(
Partition by Company, location, industry, total_laid_off, percentage_laid_off, `date`, stage,
country, funds_raised_millions) AS row_num
from layoffs_staging
)
Delete
from duplicate_cte
WHERE row_num > 1;




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
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



Select * from layoffs_staging2;

Insert into layoffs_staging2
Select *, 
ROW_NUMBER() OVER(
Partition by Company, location, industry, total_laid_off, percentage_laid_off, `date`, stage,
country, funds_raised_millions) AS row_num
from layoffs_staging;


Select * from layoffs_staging2
WHERE row_num > 1;

SET SQL_SAFE_UPDATES = 0;


DELETE
from layoffs_staging2
WHERE row_num > 1;

Select * from layoffs_staging2
where row_num > 1;



-- Standardizing the data


Select company, TRIM(company)
from layoffs_staging2;

Update layoffs_staging2 
set company = TRIM(company);

Select DISTINCT industry from layoffs_staging2;

Select * from layoffs_staging2 Where industry like 'crypto%';

Update layoffs_staging2
set industry = 'Crypto'
Where industry like 'crypto%';



SELECT DISTINCT country, TRIM(TRAILING '.' from country) FROM layoffs_staging2 ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' from country)
WHERE country LIKE 'United States%';

Select * from layoffs_staging2;

Select `date`,
str_to_date(`date`,'%m/%d/%Y')
FROM layoffs_staging2;


UPDATE layoffs_staging2
SET `date` = str_to_date(`date`,'%m/%d/%Y');


ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;





Select * from layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT * from layoffs_staging2
WHERE industry IS NULL
OR industry = '';

UPDATE layoffs_staging2
SET industry = null
WHERE industry = '';

SELECT * from layoffs_staging2
WHERE company = 'Airbnb';



SELECT * from layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
    AND t1.location = t2.location
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;



UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;


SELECT * 
FROM layoffs_staging2
WHERE company like 'Bally%';


SELECT * 
FROM layoffs_staging2;



Select * from layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;



Delete 
from layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT * 
FROM layoffs_staging2;



ALTER TABLE layoffs_staging2
DROP COLUMN row_num;


-- Explroratory Data Analysis


SELECT * 
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;


SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;



SELECT company, SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;



Select MIN(`date`), MAX(`date`)
FROM layoffs_staging2;


SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;



SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
WHERE `MONTH` IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;


SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;



WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, total_off,
SUM(total_off) OVER(ORDER BY `MONTH`)
FROM Rolling_Total;


SELECT company, SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;



SELECT company, YEAR(`date`),SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;


WITH Company_Year (company, years, total_laid_off) AS
( 
SELECT company, YEAR(`date`) AS years, SUM(total_laid_off) AS total_laid_off
	from layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS
(SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5
;







