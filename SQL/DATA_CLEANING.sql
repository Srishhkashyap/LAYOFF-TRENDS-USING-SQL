-- DATA CLEANING

SELECT *
FROM  layoffs_dataset;

-- 1. REMOVE DUPLICATES
-- 2. STANDARDIZE THE DATA
-- 3. NULL VALUES
-- 4. REMOVE ANY COLUMNS

CREATE TABLE layoffs_dataset_staging
LIKE layoffs_dataset;

SELECT * 
FROM layoffs_dataset_staging;

INSERT layoffs_dataset_staging
SELECT *
FROM layoffs_dataset;

-- Removing duplicate enteries by using window function and grouping them based on company, industry, etc. Whenever these values are same, it will generate a new number
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, industry, total_laid_off, percentage_laid_off, 'date') AS row_num
FROM layoffs_dataset_staging;

-- Finding row_num greater than 2, which means there exists duplicate enteries
WITH duplicate_CTE AS
(
	SELECT *,
	ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
	FROM layoffs_dataset_staging
)
SELECT * 
FROM duplicate_CTE
WHERE row_num> 1;

SELECT *
FROM layoffs_dataset_staging
WHERE company= 'Casper';

-- Deleting duplicate rows won't work in this manner
WITH duplicate_CTE AS
(
	SELECT *,
	ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
	FROM layoffs_dataset_staging
)
DELETE 
FROM duplicate_CTE
WHERE row_num> 1;

-- Creating one more table with an addon column named as 'row_num"
CREATE TABLE `layoffs_dataset_staging2` (
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
) ENGINE=InnoDB DEFAULT CHARSET =utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_dataset_staging2
WHERE row_num > 1;

USE world_layoffs;

-- Inserting the duplicate values into this table
INSERT INTO layoffs_dataset_staging2
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
FROM layoffs_dataset_staging;

-- Deleting duplicates from layoffs_dataset_staging2
DELETE
FROM layoffs_dataset_staging2
WHERE row_num > 1;

SET SQL_SAFE_UPDATES = 0;
SET SQL_SAFE_UPDATES = 1;

-- No results will be shown, as duplicates values are deleted
SELECT *
FROM layoffs_dataset_staging2
WHERE row_num >1;

-- Standardizing data- Finding issues and solving them 
SELECT *
FROM layoffs_dataset_staging2;

-- We can observe that there are left spaces in the 'Company' name, we need to sort it
SELECT company, TRIM(company) 
FROM layoffs_dataset_staging2;

UPDATE layoffs_dataset_staging2
SET company= TRIM(company);

SET SQL_SAFE_UPDATES = 0;

-- Now let's have a look on the 'industry' column
SELECT DISTINCT industry
FROM layoffs_dataset_staging2
ORDER BY industry;

-- Looks like we have similar industries as distinct, for eg; Crypto, Cryptocurrency etc.
SELECT DISTINCT industry
FROM layoffs_dataset_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_dataset_staging2
SET industry= 'Crypto'
WHERE industry LIKE 'Crypto%';

-- United states has a problem here
SELECT DISTINCT country
FROM layoffs_dataset_staging2
ORDER BY 1;

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_dataset_staging2
ORDER BY 1;

UPDATE layoffs_dataset_staging2
SET country= TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

SELECT DISTINCT country
FROM layoffs_dataset_staging2
ORDER BY 1;

-- Currently date's datatype is text, we need to change it
SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_dataset_staging2;

UPDATE layoffs_dataset_staging2
SET `date`= STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_dataset_staging2
MODIFY COLUMN `date` DATE;

SELECT *
FROM layoffs_dataset_staging2;

-- Dealing with NULL and Blank values in industry column
SELECT *
FROM layoffs_dataset_staging2
WHERE industry IS NULL
OR industry= '';

SELECT *
FROM layoffs_dataset_staging2
WHERE compxany= 'Airbnb';

SELECT *
FROM layoffs_dataset_staging2 t1
JOIN layoffs_dataset_staging2 t2
	ON t1.company= t2.company
WHERE (t1.industry IS NULL OR t1.industry='')
AND t2.industry IS NOT NULL;

UPDATE layoffs_dataset_staging2
SET industry= NULL 
WHERE industry='';

UPDATE layoffs_dataset_staging2 t1
JOIN layoffs_dataset_staging2 t2
	ON t1.company= t2.company
SET t1.industry= t2.industry
WHERE (t1.industry IS NULL OR t1.industry='')
AND t2.industry IS NOT NULL;

-- Dealing with the null and blank values for the below mentioned columns
SELECT *
FROM layoffs_dataset_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE
FROM layoffs_dataset_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Removing unnecessary columns
SELECT *
FROM layoffs_dataset_staging2;

ALTER TABLE layoffs_dataset_staging2
DROP COLUMN row_num;


