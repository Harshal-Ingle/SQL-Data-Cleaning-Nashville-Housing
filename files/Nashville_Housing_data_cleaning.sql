SELECT * FROM `nashville housing data`;

RENAME TABLE `nashville housing data` TO housing_data;

SELECT SaleDate 
FROM housing_data LIMIT 10;

-- Step 1: Add a new column with the DATE data type
ALTER TABLE housing_data
ADD COLUMN SaleDateConverted DATE;

-- Step 2: Populate the new column by converting the old text column
-- STR_TO_DATE can parse many common date formats.
UPDATE housing_data
SET SaleDateConverted = STR_TO_DATE(SaleDate, '%M %d, %Y');

-- Step 3 (Verification): Check if the conversion worked
SELECT SaleDate, SaleDateConverted FROM housing_data LIMIT 10;

-- Step 2: Populate Missing Property Addresses
SELECT * FROM housing_data
WHERE PropertyAddress IS NULL
ORDER BY ParcelID;

-- Using SELF JOIN 
UPDATE housing_data a
JOIN housing_data b
    ON a.ParcelID = b.ParcelID
    AND a.UniqueID <> b.UniqueID
SET a.PropertyAddress = IFNULL(a.PropertyAddress, b.PropertyAddress)
WHERE a.PropertyAddress IS NULL;

-- Step 3: Break Out Address into Individual Columns (Street, City)
SELECT PropertyAddress 
FROM housing_data LIMIT 10;

-- Add new columns for the split address and city
ALTER TABLE housing_data
ADD COLUMN PropertySplitAddress VARCHAR(255),
ADD COLUMN PropertySplitCity VARCHAR(255);

-- Populate the new columns using SUBSTRING_INDEX
UPDATE housing_data
SET
    PropertySplitAddress = SUBSTRING_INDEX(PropertyAddress, ',', 1),
    PropertySplitCity = SUBSTRING_INDEX(PropertyAddress, ',', -1);

-- Checking the result
SELECT PropertyAddress, PropertySplitAddress, PropertySplitCity FROM housing_data LIMIT 10;

-- Step 4: Standardize the 'Sold as Vacant' Field
-- The Problem: This field contains 'Y', 'N', 'Yes', and 'No'. For consistency, 
-- we should standardize them to just 'Yes' and 'No'.

SELECT DISTINCT SoldAsVacant, COUNT(*)
FROM housing_data
GROUP BY SoldAsVacant
ORDER BY 2;

UPDATE housing_data
SET SoldAsVacant = CASE
    WHEN SoldAsVacant = 'Y' THEN 'Yes'
    WHEN SoldAsVacant = 'N' THEN 'No'
    ELSE SoldAsVacant
END;

-- Step 5: Identify and Remove Duplicate Rows
-- We will use a Common Table Expression (CTE) and the ROW_NUMBER() window function.
-- Use a CTE to find duplicates
WITH RowNumCTE AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY ParcelID,
                         PropertyAddress,
                         SalePrice,
                         SaleDate,
                         LegalReference
            ORDER BY
                UniqueID
        ) as row_num
    FROM housing_data
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress;

DELETE t1 FROM housing_data t1
INNER JOIN (
    SELECT UniqueID,
        ROW_NUMBER() OVER (
            PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
            ORDER BY UniqueID
        ) as row_num
    FROM housing_data
) t2 ON t1.UniqueID = t2.UniqueID
WHERE t2.row_num > 1; 








