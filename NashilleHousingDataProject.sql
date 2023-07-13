select *
from MyPortfolioProject.dbo.NashilleHousingData


/*Standardize date format */
select SaleDate, convert (Date,SaleDate)
from MyPortfolioProject.dbo.NashilleHousingData

update NashilleHousingData
set SaleDate = convert (Date,SaleDate)

ALTER table NashilleHousingData
Add SaleDateConverted Date; 

update NashilleHousingData
set SaleDateConverted = convert (Date,SaleDate)

select SaleDateConverted, convert (Date,SaleDate)
from MyPortfolioProject.dbo.NashilleHousingData


/*Populate PropertyAddress Data*/

select *
from MyPortfolioProject.dbo.NashilleHousingData
--where propertyaddress is null
order by ParcelID


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull (a.PropertyAddress, b.PropertyAddress)
from MyPortfolioProject.dbo.NashilleHousingData a
join MyPortfolioProject.dbo.NashilleHousingData b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


update a
set PropertyAddress = isnull (a.PropertyAddress, b.PropertyAddress)
from MyPortfolioProject.dbo.NashilleHousingData a
join MyPortfolioProject.dbo.NashilleHousingData b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


/*Breaking Address into individual columns (Address, City, State) */

select PropertyAddress
from MyPortfolioProject.dbo.NashilleHousingData
--where propertyaddress is null
--order by ParcelID


select
SUBSTRING (propertyaddress, 1, CHARINDEX(',', propertyaddress)-1) as Address
, SUBSTRING (propertyaddress, CHARINDEX(',', propertyaddress)+1, len(propertyaddress)) as Address
from MyPortfolioProject.dbo.NashilleHousingData

 
ALTER table NashilleHousingData
Add PropertysplitAddress nvarchar (255); 

update NashilleHousingData
set PropertysplitAddress = SUBSTRING (propertyaddress, 1, CHARINDEX(',', propertyaddress)-1)

ALTER table NashilleHousingData
Add PropertysplitCity nvarchar (255); 

update NashilleHousingData
set PropertysplitCity = SUBSTRING (propertyaddress, CHARINDEX(',', propertyaddress)+1, len(propertyaddress))


select *
from MyPortfolioProject.dbo.NashilleHousingData


select OwnerAddress
from MyPortfolioProject.dbo.NashilleHousingData

select
PARSENAME(replace(owneraddress, ',', '.') , 3)
,PARSENAME(replace(owneraddress, ',', '.') , 2)
,PARSENAME(replace(owneraddress, ',', '.') , 1)
from MyPortfolioProject.dbo.NashilleHousingData


ALTER table NashilleHousingData
Add OwnersplitAddress nvarchar (255); 

update NashilleHousingData
set OwnersplitAddress = PARSENAME(replace(owneraddress, ',', '.') , 3)

ALTER table NashilleHousingData
Add OwnersplitCity nvarchar (255); 

update NashilleHousingData
set OwnersplitCity = PARSENAME(replace(owneraddress, ',', '.') , 2)

ALTER table NashilleHousingData
Add OwnersplitState nvarchar (255); 

update NashilleHousingData
set OwnersplitState = PARSENAME(replace(owneraddress, ',', '.') , 1)


select *
from MyPortfolioProject.dbo.NashilleHousingData


/* Change Y n N to Yes and No "sold  as vacant" field */

select distinct (SoldAsVacant), count (SoldAsVacant)
from MyPortfolioProject.dbo.NashilleHousingData
GROUP BY SoldAsVacant
ORDER BY 2


SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
       WHEN SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END
from MyPortfolioProject.dbo.NashilleHousingData

UPDATE NashilleHousingData
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
       WHEN SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END



/* Delete Duplicate */

with RowNumCTE AS(
SELECT*,
ROW_NUMBER() OVER (
PARTITION BY ParcelID,
			 propertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 Order by UniqueID
			 ) Row_num
from MyPortfolioProject.dbo.NashilleHousingData
)
SELECT *
FROM RowNumCTE
WHERE Row_num > 1
ORDER BY  PropertyAddress

with RowNumCTE AS(
SELECT*,
ROW_NUMBER() OVER (
PARTITION BY ParcelID,
			 propertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 Order by UniqueID
			 ) Row_num
from MyPortfolioProject.dbo.NashilleHousingData
)
DELETE
FROM RowNumCTE
WHERE Row_num > 1




/*Delete unused columns*/

SELECT *
from MyPortfolioProject.dbo.NashilleHousingData

alter table MyPortfolioProject.dbo.NashilleHousingData
drop column owneraddress,taxdistrict, propertyaddress

alter table MyPortfolioProject.dbo.NashilleHousingData
drop column saledate


-- Thanks You



