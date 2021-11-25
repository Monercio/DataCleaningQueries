select SALEDATE, CONVERT(date, Saledate)
from	PortfolioProject..Nashville

Alter Table Nashville
Alter Column SaleDate date

Select *
from Nashville
--where PropertyAddress is null
order by ParcelID

Select A.ParcelID,B.ParcelID,A.PropertyAddress,B.PropertyAddress, ISNULL(A.PropertyAddress,B.PropertyAddress)
from Nashville a
join Nashville b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
--Where a.PropertyAddress is null

Update a
set a.PropertyAddress = ISNULL(A.PropertyAddress,B.PropertyAddress)
from Nashville a
join Nashville b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
Where a.PropertyAddress is null

Select SUBSTRING(Propertyaddress,1,CHARINDEX(',',PropertyAddress)-1) As Address
from Nashville

Select PropertyAddress,SUBSTRING(Propertyaddress,1,CHARINDEX(',',PropertyAddress)-1) As Address,
RIGHT(Propertyaddress,len(Propertyaddress)-CHARINDEX(',',PropertyAddress)) As City
from Nashville

ALTER TABLE NASHVILLE
ADD PropertySplitAddress Nvarchar (100), PropertySplitCity Nvarchar (100)

Update Nashville
set PropertySplitAddress = SUBSTRING(Propertyaddress,1,CHARINDEX(',',PropertyAddress)-1)
from Nashville

Update Nashville
set PropertySplitCity = RIGHT(Propertyaddress,len(Propertyaddress)-CHARINDEX(',',PropertyAddress)) 
from Nashville


Select PropertyAddress, PropertySplitAddress, PropertySplitCity
from Nashville

SELECT owneraddress, PARSENAME(REPLACE(owneraddress,',','.'),3),
PARSENAME(REPLACE(owneraddress,',','.'),2),
PARSENAME(REPLACE(owneraddress,',','.'),1)
from Nashville

ALTER TABLE NASHVILLE
ADD OwnerSplitAddress Nvarchar (100), OwnerSplitCity Nvarchar (100), OwnerSplitState Nvarchar (100)

Update Nashville
SET OwnerSplitAddress = PARSENAME(REPLACE(owneraddress,',','.'),3)

Update Nashville
SET OwnerSplitCity = PARSENAME(REPLACE(owneraddress,',','.'),2)

Update Nashville
SET OwnerSplitState = PARSENAME(REPLACE(owneraddress,',','.'),1)

select owneraddress, ownersplitaddress, ownersplitcity, ownersplitstate
from Nashville

select Distinct (SoldAsVacant)
from Nashville

select Distinct (SoldAsVacant), COUNT(soldasvacant)
from Nashville
group by SoldAsVacant

Update Nashville
set SoldAsVacant = case when SoldAsVacant='N' then 'NO' when SoldAsVacant='Y' then 'YES' ELSE SoldAsVacant END

SELECT *,
ROW_NUMBER () OVER (ORDER BY PROPERTYSPLITCITY)
From nashville


With RowNumCTE AS
(Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
From Nashville
)

Select * from RowNumCTE
where row_num>1

delete  from RowNumCTE
where row_num>1

Alter Table Nashville
drop column	Owneraddress, PropertyAddress
