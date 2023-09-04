/*

Cleaning Data in SQL Queries

*/ 
Select *
From PorfolioProjects..NashvilleHousing

-- Standardize Data Format

----Changing the Date Format

Select SaleDateConverted, convert(Date, SaleDate)
From PorfolioProjects..NashvilleHousing

Update NashvilleHousing
SET SaleDate = convert(Date,SaleDate)

Alter Table NashvilleHousing 
Add SaleDateConverted Date;

Update NashvilleHousing
Set SaleDateConverted = Convert(Date,SaleDate)



-- Populate Property Address Data

Select * --PropertyAddress
From PorfolioProjects..NashvilleHousing
--Where PropertyAddress is null
Order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PorfolioProjects..NashvilleHousing a
Join PorfolioProjects..NashvilleHousing b
		on a.ParcelID = b.ParcelID
		and a.[UniqueID ]<> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PorfolioProjects..NashvilleHousing a
Join PorfolioProjects..NashvilleHousing b
		on a.ParcelID = b.ParcelID
		and a.[UniqueID ]<> b.[UniqueID ]
Where a.PropertyAddress is null




-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From PorfolioProjects..NashvilleHousing
--Where PropertyAddress is null
--Order by ParcelID

--Seperation by the Comma 
Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+ 1, LEN(PropertyAddress)) as address

From PorfolioProjects..NashvilleHousing


Alter Table NashvilleHousing 
Add PropertySplitAddress nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

Alter Table NashvilleHousing 
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+ 1, LEN(PropertyAddress))


Select *
From PorfolioProjects..NashvilleHousing


Select OwnerAddress
From PorfolioProjects..NashvilleHousing

Select 
PARSENAME(Replace(OwnerAddress,',','.'),3)
,PARSENAME(Replace(OwnerAddress,',','.'),2)
,PARSENAME(Replace(OwnerAddress,',','.'),1)
From PorfolioProjects..NashvilleHousing


Alter Table NashvilleHousing 
Add OwnerSplitAddress nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(Replace(OwnerAddress,',','.'),3)

Alter Table NashvilleHousing 
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',','.'),2)

Alter Table NashvilleHousing 
Add OwnerSplitState nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(Replace(OwnerAddress,',','.'),1)


Select *
From PorfolioProjects..NashvilleHousing


--Change Y and N to Yes and No in "Solid as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PorfolioProjects..NashvilleHousing
Group by SoldAsVacant
order by 2

Select SoldAsVacant,
Case when SoldAsVacant = 'Y' Then 'Yes'
	 when SoldAsVacant = 'N' Then 'No'
	 Else SoldAsVacant
	 End
From PorfolioProjects..NashvilleHousing

Update NashvilleHousing
Set SoldAsVacant = Case when SoldAsVacant = 'Y' Then 'Yes'
	 when SoldAsVacant = 'N' Then 'No'
	 Else SoldAsVacant
	 End



-- Remove Duplicates
-- Duplicates with CTE Temp Table
With RowNumCTE AS(
Select *, 
ROW_NUMBER() Over(
Partition by ParcelID, 
			 PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 Order by UniqueID
			 ) row_num
From PorfolioProjects..NashvilleHousing 
--Order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress





--

Select *
From PorfolioProjects..NashvilleHousing




-- Delete Unused Columns 

Select *
From PorfolioProjects..NashvilleHousing

Alter Table PorfolioProjects..NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress  

Alter Table PorfolioProjects..NashvilleHousing
Drop Column SaleDate