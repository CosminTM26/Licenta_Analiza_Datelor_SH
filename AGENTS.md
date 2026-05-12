# AGENTS.md - AI Coding Agent Guidelines

## Project Overview
This thesis project analyzes second-hand car sales data from USA, Germany, and India using SQLite for data storage and R for analysis. Data cleaning is performed via SQL scripts, followed by exploratory data analysis in R.

## Key Components
- **SQL Cleaning Scripts**: `Curatare_Date_SUA.sql`, `Curatare_Date_India.sql`, `Curatare_Date_Germany.sql` - standardize raw data into cleaned tables (`SUA_Cars_Cleaned`, `India_Cars_Cleaned`, `Germany_Cars`)
- **R Analysis Scripts**: `Germany_R.R`, `India_R.R` - load cleaned data from `identifier.sqlite` and perform basic checks
- **Database**: `identifier.sqlite` (ignored in `.gitignore`)
- **Documentation**: `Utile/CLAUDE.md` - detailed cleaning rules and patterns

## SQL Conventions (from CLAUDE.md)
- **Indentation**: 2 spaces for UPDATE statements
- **Continuations**: AND/OR on new line, no extra indent
- **Order Critical**: Specific variants (e.g., `F-150 Lightning`) before general models (e.g., `F-150`)
- **Comments**: Explain order/motivations above each UPDATE block
- **Patterns**: Use `LIKE '%pattern%'` with NOT LIKE exclusions for variants

### Examples
```sql
-- F-150 Lightning (PRIMUL - model electric distinct)
UPDATE SUA_Cars_Cleaned SET model = 'F-150 Lightning' WHERE model LIKE '%F-150 Lightning%' AND brand = 'Ford';
-- F-150 (restul - exclude Lightning)
UPDATE SUA_Cars_Cleaned SET model = 'F-150' WHERE model LIKE '%F-150%' AND model NOT LIKE '%Lightning%' AND brand = 'Ford';
```

## Workflow
1. Run SQL cleaning scripts in DataGrip/IntelliJ to populate cleaned tables
2. Execute R scripts to load data and check for NA values/outliers using `colSums(is.na())` and `summary()`
3. Analyze results in R with dplyr for data manipulation

## Project-Specific Patterns
- **Brand Handling**: USA uses `brand = 'BrandName'` (except Dodge/Ram: `brand IN ('Dodge', 'Ram')`); INFINITI in uppercase
- **Model Standardization**: Remove brand prefixes, unify variants (e.g., `Santa Fe Hybrid/PHEV` before `Santa Fe`)
- **Color Normalization**: Map to standard colors (Red, Blue, Black, etc.), set unknowns to 'Unknown'
- **Fuel/Transmission**: Standardize values like '2WD' for drivetrain
- **Data Types**: Convert prices to euros, power to PS, km to integers

## Key Files to Reference
- `Utile/CLAUDE.md`: Comprehensive rules for USA data cleaning
- `Curatare_Date_SUA.sql`: Exemplar for model grouping patterns
- `Germany_R.R` / `India_R.R`: R loading and validation template</content>
<parameter name="filePath">C:\Users\Cosmin\Desktop\Facultate\Licenta_\Analiza-Datelor-Legate-de-vanzarea-autovehiculelor-SH-folosind-sql-si-R\AGENTS.md
