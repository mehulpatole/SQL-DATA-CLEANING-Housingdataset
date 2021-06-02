use housing_data

select * from housing

--cleaning/removing time from date column(salesdate)
select saledate,convert(date,saledate) from housing
 
update housing set saledate =convert(date,saledate)
alter table housing add salesdatenew date

update housing set salesdatenew = convert(date,saledate)


select * from housing

--filling missing values of property address
update a 
set propertyaddress= isnull(a.propertyaddress,b.propertyaddress)
from housing a join housing b on a.parcelid= b.parcelid
and a.uniqueid<>b.uniqueid where a.propertyaddress is null

select * from housing

--separating/splitting the address column into actual address and city

select SUBSTRING(propertyaddress,1,charindex(',',propertyaddress)-1) as address,
SUBSTRING(propertyaddress,charindex(',',propertyaddress)+1,len(propertyaddress)) as city
from housing

alter table housing add address varchar(200)
alter table housing add city varchar(200)

update housing set address = SUBSTRING(propertyaddress,1,charindex(',',propertyaddress)-1)

update housing set city = SUBSTRING(propertyaddress,charindex(',',propertyaddress)+1,len(propertyaddress))
select * from housing

-- splitting the owner address
select PARSENAME(replace(owneraddress,',','.'),1) from housing
select PARSENAME(replace(owneraddress,',','.'),2) from housing
select PARSENAME(replace(owneraddress,',','.'),3) from housing

alter table housing add ownerstate varchar(10)
alter table housing add ownerlocation varchar(100)
alter table housing add ownercity varchar(100)

update housing set ownerstate= PARSENAME(replace(owneraddress,',','.'),1) from housing
update housing set ownercity=  PARSENAME(replace(owneraddress,',','.'),2) from housing
update housing set  ownerlocation =PARSENAME(replace(owneraddress,',','.'),3) from housing


select * from housing

--cleaning sold as vacant column
select soldasvacant,count(soldasvacant) from housing group by soldasvacant

update housing set soldasvacant = 
case when soldasvacant= 'N' then 'No'
when soldasvacant = 'Y' then 'Yes'
else soldasvacant end

--deleting unnecessary columns

alter table housing drop column propertyaddress,owneraddress,saledate
select * from housing
