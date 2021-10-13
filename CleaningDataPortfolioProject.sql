/*
Cleaning Data in SQL Queries

*/

Select*
From PortfolioProject.dbo.NashvilleHousingCleaning

--------------------------------------------------------------

--Standardize Date Format

Select SaleDateConverted, CONVERT(Date, SaleDate)
From PortfolioProject.dbo.NashvilleHousingCleaning

Update NashvilleHousingCleaning
SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE NashvilleHousingCleaning
Add SaleDateConverted1 Date;

Update NashvilleHousingCleaning
SET SaleDateConverted = CONVERT(Date, SaleDate)


------------------------------------------------------------------

--Populate Property Addess data

Select*
From PortfolioProject.dbo.NashvilleHousingCleaning
Where PropertyAddress is null
Order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
From PortfolioProject.dbo.NashvilleHousingCleaning a
Join PortfolioProject.dbo.NashvilleHousingCleaning b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousingCleaning a
Join PortfolioProject.dbo.NashvilleHousingCleaning b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]


--------------------------------------------------------------------------

--Breaking out Address into INdividual Columns (Address, City, State)

Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousingCleaning
--Where PropertyAddress is null
--Order by ParcelID


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as Address

From PortfolioProject.dbo.NashvilleHousingCleaning

ALTER TABLE NashvilleHousingCleaning
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousingCleaning
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE NashvilleHousingCleaning
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousingCleaning
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))

Select*
From PortfolioProject.dbo.NashvilleHousingCleaning


Select OwnerAddress
From PortfolioProject.dbo.NashvilleHousingCleaning


Select 
PARSENAME(REPLACE(OwnerAddress, ',','.') ,3)
,PARSENAME(REPLACE(OwnerAddress, ',','.') ,2)
,PARSENAME(REPLACE(OwnerAddress, ',','.') ,1)
From PortfolioProject.dbo.NashvilleHousingCleaning


ALTER TABLE NashvilleHousingCleaning
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousingCleaning
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.') ,3)

ALTER TABLE NashvilleHousingCleaning
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousingCleaning
SET PropertySplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.') ,2)

ALTER TABLE NashvilleHousingCleaning
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousingCleaning
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.') ,1)


Select*
From PortfolioProject.dbo.NashvilleHousingCleaning


----------------------------------------------------------------------

--Change Y and N to Yes and No in 'Solid as Vacant" field

Select Distinct(SoldAsVacant),COUNT(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousingCleaning
Group by SoldAsVacant
Order by 2


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
		When SoldAsVacant= 'N' THEN 'No'
		ELSE SoldAsVacant
		END
From PortfolioProject.dbo.NashvilleHousingCleaning


Update NashvilleHousingCleaning
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
		When SoldAsVacant= 'N' THEN 'No'
		ELSE SoldAsVacant
		END

----------------------------------------------------------------------------

--Remove Duplicates
WITH RowNumCTE AS(
Select*,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice, 
				SaleDate,
				LegalReference
				ORDER BY
					UniqueID
					) row_num

From PortfolioProject.dbo.NashvilleHousingCleaning
--Order by ParcelID
)
Select*
From RowNumCTE
Where row_num> 1
Order by PropertyAddress



Select*
From PortfolioProject.dbo.NashvilleHousingCleaning
------------------------------------------------------------------------

--Delete unused Column

Select*
From PortfolioProject.dbo.NashvilleHousingCleaning
 

 ALTER TABLE PortfolioProject.dbo.NashvilleHousingCleaning
 DROP COLUMN OwnerAddress, TaxDistrict,PropertyAddress

 ALTER TABLE PortfolioProject.dbo.NashvilleHousingCleaning
 DROP COLUMN SaleDate



