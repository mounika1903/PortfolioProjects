/****** Script for SelectTopNRows command from SSMS  ******/
SELECT *
  FROM [portfolio project].[dbo].[NashvilleHousing]

  --Standardize Date Format

  ALTER TABLE NashvilleHousing
  Add saleDateconverted Date;

  update NashvilleHousing
  set saleDateconverted = convert(Date,SaleDate)

  select saleDateconverted, convert(Date,SaleDate)
   FROM [portfolio project].[dbo].[NashvilleHousing]

   --populate property Address data

  select*
  FROM [portfolio project].[dbo].[NashvilleHousing]
  --WHERE PROPERTY ADDRESS IS NULL
  order by parcelID

    select a.parcelID,a.propertyAddress,b.parcelID,b.propertyAddress, ISNULL(a.propertyAddress,b.propertyAddress)
	  FROM [portfolio project].[dbo].[NashvilleHousing]a
	  join [portfolio project].[dbo].[NashvilleHousing]b
	  on a.parcelID = b.parcelID
	  AND a.[uniqueID]=b.[uniqueID]
	  where a.propertyAddress is null

	  update a
	  set propertyAddress = ISNULL(a.propertyAddress,b.propertyAddress)
	   FROM [portfolio project].[dbo].[NashvilleHousing]a
	  join [portfolio project].[dbo].[NashvilleHousing]b
	  on a.parcelID = b.parcelID
	  AND a.[uniqueID]<>b.[uniqueID]
	   where a.propertyAddress is null


	--Breaking out addreess into Individual columns(Address,city,state)

	select propertyAddress
  FROM [portfolio project].[dbo].[NashvilleHousing]
  	 -- where a.propertyAddress is null
	 -- order by parcelID
	 
   select
   SUBSTRING(propertyAddress,1,CHARINDEX(',', propertyAddress) -1) as Address
   ,SUBSTRING(propertyAddress,CHARINDEX(',', propertyAddress) +1,LEN(propertyAddress)) as Address
     FROM [portfolio project].[dbo].[NashvilleHousing]

    ALTER TABLE [portfolio project].[dbo].[NashvilleHousing]
  Add propertysplitAddress Nvarchar(255);

  Update [portfolio project].[dbo].[NashvilleHousing]
 SET propertysplitAddress  = SUBSTRING(propertyAddress,1,CHARINDEX(',',propertyAddress)-1)

  ALTER TABLE [portfolio project].[dbo].[NashvilleHousing]
   Add propertysplitCity Nvarchar(255);
  
  Update [portfolio project].[dbo].[NashvilleHousing]
	 SET propertysplitcity  = SUBSTRING(propertyAddress,CHARINDEX(',',propertyAddress)+1, LEN(propertyAddress))


  select*
  From  [portfolio project].[dbo].[NashvilleHousing]



  select ownerAddress
    From  [portfolio project].[dbo].[NashvilleHousing]


	select
	PARSENAME(replace(ownerAddress,',','.'),3)
	,PARSENAME(replace(ownerAddress,',','.'),2)
	,PARSENAME(replace(ownerAddress,',','.'),1)
	 From  [portfolio project].[dbo].[NashvilleHousing]

   
  ALTER TABLE [portfolio project].[dbo].[NashvilleHousing]
  Add ownersplitAddress Nvarchar(255);

  Update [portfolio project].[dbo].[NashvilleHousing]
  SET ownersplitAddress  = PARSENAME(replace(ownerAddress,',','.'),3)


  ALTER TABLE [portfolio project].[dbo].[NashvilleHousing]
   Add ownersplitcity Nvarchar(255);
  
  Update [portfolio project].[dbo].[NashvilleHousing]
  SET ownersplitCity  =	PARSENAME(Replace(ownerAddress,',','.'),2)
   
  ALTER TABLE [portfolio project].[dbo].[NashvilleHousing]
  Add ownersplitstate Nvarchar(255);

  Update [portfolio project].[dbo].[NashvilleHousing]
    SET ownersplitstate  = PARSENAME(Replace(ownerAddress,',','.'),1)


	SELECT*
  From[portfolio project].[dbo].[NashvilleHousing]


  --change Y and N to yes and No in "sold as vacant"field
 
 select Distinct(soldasvacant),COUNT(soldasvacant)
 From[portfolio project].[dbo].[NashvilleHousing]
 group by SoldAsVacant
 order by 2

 select SoldAsVacant
 ,case when SoldAsVacant = 'Y' then 'yes'
       when SoldAsVacant = 'N' then 'no'
	   ELSE SoldAsVacant
	   END
	   From[portfolio project].[dbo].[NashvilleHousing]

update[portfolio project].[dbo].[NashvilleHousing]
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'yes'
	when SoldAsVacant = 'N' then 'no'
	ELSE SoldAsVacant
	END
