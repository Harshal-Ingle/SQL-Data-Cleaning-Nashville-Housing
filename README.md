**SQL Data Cleaning Project: Nashville Housing Dataset**

**Introduction**
This project focuses on the crucial first step in any data analysis workflow: data cleaning. Using a raw dataset of housing sales in Nashville, Tennessee, this project demonstrates a variety of data cleaning techniques implemented purely in MySQL. The primary goal is to transform the messy, inconsistent raw data into a standardized, structured, and usable format, making it suitable for further analysis and reporting.

**Dataset**: Nashville Housing Data for Data Cleaning on Kaggle

**Tool**: MySQL

**Data Cleaning Process**
The following steps were taken to clean and prepare the data. Each step addresses a specific data quality issue.

**1. Standardize Date Format**
The Problem: The SaleDate column was imported as a text field with a non-standard format (e.g., "April 9, 2013"). 
This format is not suitable for date-based calculations or sorting.

**2. Populate Missing Property Addresses**
The Problem: Several rows in the dataset had NULL values for the PropertyAddress.

**3. Deconstruct Address into Individual Columns**
The Problem: The PropertyAddress and OwnerAddress columns contained the full address (street, city, and state) in a single field, 
making it difficult to query or aggregate data by city or state.

For PropertyAddress, it was split into PropertySplitAddress and PropertySplitCity using the comma as a delimiter.
For OwnerAddress, it was split into OwnerSplitAddress, OwnerSplitCity, and OwnerSplitState.

**4. Standardize Categorical Data**
The Problem: The SoldAsVacant column contained four distinct values: 'Y', 'N', 'Yes', and 'No'. This inconsistency can lead to inaccurate aggregations.

**5. Identify and Remove Duplicate Rows**
The Problem: Duplicate records were present in the dataset, which could skew analytical results.


Conclusion
After completing these cleaning steps, the Nashville Housing dataset is now clean, consistent, and structured. Redundant columns have been removed, data types are appropriate, and values are standardized. The resulting dataset is now in a reliable state, ready for in-depth exploratory data analysis, visualization, and modeling.
