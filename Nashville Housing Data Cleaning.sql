-- Populate Property Address Data
Select 
	NashvilleHousing1.ParcelID,
	NashvilleHousing1.PropertyAddress,
	NashvilleHousing2.ParcelID,
	NashvilleHousing2.PropertyAddress,
	ISNULL(NashvilleHousing1.PropertyAddress, NashvilleHousing2.PropertyAddress)
FROM NashvilleHousing AS NashvilleHousing1
Join NashvilleHousing AS NashvilleHousing2
	ON NashvilleHousing1.ParcelID = NashvilleHousing2.ParcelID AND
	NashvilleHousing1.[UniqueID ] <> NashvilleHousing2.[UniqueID ]
Where NashvilleHousing1.PropertyAddress IS NULL

Update NashvilleHousing1
SET PropertyAddress = ISNULL(NashvilleHousing1.PropertyAddress, NashvilleHousing2.PropertyAddress)
FROM NashvilleHousing AS NashvilleHousing1
Join NashvilleHousing AS NashvilleHousing2
	ON NashvilleHousing1.ParcelID = NashvilleHousing2.ParcelID AND
	NashvilleHousing1.[UniqueID ] <> NashvilleHousing2.[UniqueID ]
Where NashvilleHousing1.PropertyAddress IS NULL


-- Breaking Out Address Into Individual Columns (Address, City)
SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) AS City 
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress nvarchar(255)

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1);

ALTER TABLE NashvilleHousing
ADD PropertySplitCity nvarchar(255)

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress));


-- Breaking Out Address Into Individual Columns (Address, City, State) With PARSENAME Method
SELECT 
	PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) AS ParsedAddress,
	PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) AS ParsedCity,
	PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) AS ParsedState
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
ADD ParsedAddress nvarchar(255)

UPDATE NashvilleHousing
SET ParsedAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3);

ALTER TABLE NashvilleHousing
ADD ParsedCity nvarchar(255)

UPDATE NashvilleHousing
SET ParsedCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2);

ALTER TABLE NashvilleHousing
ADD ParsedState nvarchar(255)

UPDATE NashvilleHousing
SET ParsedState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1); 


-- Changing Y and N to 'Yes' and 'No' in | Sold as Vacant | Column	
SELECT SoldAsVacant,
CASE 
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
END AS SoldAsVacantFixed
FROM NashvilleHousing


UPDATE NashvilleHousing
SET SoldAsVacant = CASE 
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
END


-- Removing Duplicates
WITH RowNumCTE AS(
SELECT *,
	   ROW_NUMBER() OVER (
	   PARTITION BY ParcelID,
					PropertyAddress,
					SalePrice,
					SaleDate,
					LegalReference
					ORDER BY 
						UniqueID
					) AS RowNum
FROM NashvilleHousing
)

SELECT *
FROM RowNumCTE
WHERE RowNum > 1
ORDER BY PropertyAddress


-- Standardize Date Format
ALTER TABLE NashvilleHousing
Add SaleDateConverted Date

Update NashvilleHousing
SET SaleDateConverted = CONVERT(date, SaleDate)

SELECT *
FROM NashvilleHousing


-- Deleting Unused Columns 
SELECT *
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN
	OwnerAddress,
	TaxDistrict,
	PropertyAddress

ALTER TABLE NashvilleHousing
DROP COLUMN SaleDate