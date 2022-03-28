
--Cleaning Data in SQL Queries
----- Task: Standardize Date Format

ALTER TABLE NashvilleHousing --Creating a column to input the converted result set in 
Add SaleDateConverted Date;--Standardizing the data to only contain DATE values

Update NashvilleHousing 
SET SaleDateConverted = CONVERT(Date,SaleDate) --Updating the empty column with result set 

Select SaleDate,SaleDateConverted -- Sharing the result from Query 
From PortfolioProjects.dbo.NashvilleHousing;



-- Task: Populate Property Address data
Select *
From Portfolioprojects.dbo.NashvilleHousing
order by ParcelID --Find any duplicate addresses 

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From Portfolioprojects.dbo.NashvilleHousing a --Using an inner join to Identify PropertyAddress values containing Null 
JOIN Portfolioprojects.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ] 
Where a.PropertyAddress is null 

Update a --Updating the Null values in PropertyAddress with the correct addresses 
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From Portfolioprojects.dbo.NashvilleHousing a
JOIN Portfolioprojects.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null




--------------------------------------------------------------------------------------------------------------------------

-- TASK: Splitting Address into Individual Columns (Address, City, State)

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address -- Extracting string of the Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address
-- Extracting string of City from PropertyAddress 

ALTER TABLE dbo.NashvilleHousing -- Creating new column for address
Add PropertySplitAddress Nvarchar(255);

Update dbo.NashvilleHousing --Updating new column with result set  
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE NashvilleHousing -- Creating new column for city 
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing -- Updating new column with city data 
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))





--TASK: Splitting the OwnerAddresses values into: Address, City, State columns 
Select OwnerAddress   
From Portfolioprojects.dbo.NashvilleHousing

Select -- Splitting the OwnerAddress 
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From Portfolioprojects.dbo.NashvilleHousing

Select * 
From NashvilleHousing;

ALTER TABLE NashvilleHousing -- Creating column for Address
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing 
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

ALTER TABLE NashvilleHousing -- Creating column for City data  
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing 
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


Select *
From PortfolioProject.dbo.NashvilleHousing




--------------------------------------------------------------------------------------------------------------------------


-- TASK: Change 'Y' and 'N' to Yes and No in "Sold as Vacant" field


Select SoldAsVacant --Creating a case statement to replace values when condition is true 
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From Portfolioprojects.dbo.NashvilleHousing


Update NashvilleHousing --Updating Columns 
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END






-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- TASK: Remove Duplicates
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER ( --Identifying duplicate rows by numbering them
	PARTITION BY ParcelID,
				 PropertyAddress, -- Columns that are indicators of duplicate data
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From Portfolioprojects.dbo.NashvilleHousing
)


Delete  --Deleting Duplicates by identifying if the row number is higher than 1 
From RowNumCTE
Where row_num > 1





-- TASK: Delete Unused Columns

Select *
From Portfolioprojects.dbo.NashvilleHousing
ALTER TABLE PortfolioProjects.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate 

