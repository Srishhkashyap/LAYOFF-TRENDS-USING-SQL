# DATA-CLEANING-AND-EDA-USING-SQL

This project explores a real-world dataset of global layoffs to uncover trends, patterns, and company-level insights. The goal is to clean, structure, and analyze the data using pure SQL. The project is divided into two main phases:

📌 Phase 1: Data Cleaning
In this phase, the goal was to prepare the dataset for analysis. Tasks included:

✅ Removing duplicates using ROW_NUMBER() and CTEs

✅ Standardizing text values (e.g., trimming spaces, merging categories like “Crypto” and “Cryptocurrency”)

✅ Handling missing or null values logically

✅ Converting date formats from string to proper DATE datatype

✅ Deleting rows with insufficient data

✅ Dropping unnecessary helper columns

📌 Phase 2: Exploratory Data Analysis (EDA)
With a clean dataset, this phase focused on uncovering patterns and trends through SQL-based analysis:

📈 Identified companies with 100% layoffs

🏆 Ranked companies with the highest total layoffs

📆 Tracked layoffs month-over-month and created rolling totals

📊 Determined peak months for layoffs

🗓️ Found first and last recorded dates
