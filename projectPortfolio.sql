create table [dbo].[Crime]
(
[id] int null,
[Case_Number] [varchar](50)  null,
[Date] [varchar](50) null,
[Month] int  null, 
[Block] [varchar](50)  null,
[IUCR] [varchar] (20)  null,
[Primary_type] [varchar](100)  null,
[Description] [varchar](100)  null,
[Primary_Description] [varchar] (100) null,
[Location_description] [varchar] (100)  null, 
[Arrest] [varchar] (100) null,
[Domestic] [varchar] (100)  null,
[District] [varchar] (100) null,
[Ward] int  null,
[Community_Area] int  null,
[FBI_Code] [varchar] (100)  null,
[Year] int  null,
[Crime_Ward] int  null,
[Police_districts] int  null,
[Police_beat] int  null,
[Temp_high] int  null,
[Precip] [varchar] (100)  null,
[Half_of_the_year] int  null
)

drop table Crime

select* into dbo.Crime from 
openrowset(bulk 'C:\Users\HP\Desktop\EverSed\DataLeum\Crimesheet.csv', 
FORMATFILE='C:\Users\HP\Desktop\EverSed\DataLeum\DataCrime.txt', FIRSTROW=2) as a;

select distinct Primary_Description as crime, count(Primary_Description) as NumberOfCrime_PerDescription from crime
group by Primary_Description
order by NumberOfCrime_PerDescription desc;

alter table dbo.crime 
add crime varchar(255)

alter table dbo.crime 
add primary key(id);

ALTER TABLE
Crime 
ALTER COLUMN
id int NOT NULL;

alter table crime
drop column crime;

select * from crime; 

-- this shows number of violent crimes in chicago
select distinct Primary_Description as crime, count(Primary_Description) as NumberOfCrime_PerDescription from crime
group by Primary_Description
order by NumberOfCrime_PerDescription  desc;

-- shows us the location and number of crime commited
select distinct Location_Description,count(Location_Description) as Numbers_Of_Crime_PerLocation from crime where arrest='true'
group by Location_Description
order by  Numbers_Of_Crime_PerLocation desc;


select distinct primary_type, count(primary_type) number_of_crime, month from crime
group by Location_Description, primary_type, month

select distinct date as Crime_date,primary_type, count (primary_description) as Number_Of_Crime,precip, Temp_high  from crime 
group by precip, date, Temp_high, primary_type

/* converting datetime to date*/
update crime
set Date =CONVERT(date, Date)

update Crime
set month = CONVERT(int , month)

SELECT month
FROM crime
WHERE TRY_CONVERT(datetime, Month, 101)=0;

-- checking for duplicate value '11603828' 
select * from crime where id='11603828';

-- checking if there are duplicate value in ID rows
select id, count(*) from crime 
group by id
having count(*) > 1;

-- checking if there are duplicates values in case number also
WITH Crimecte AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY 
               case_number
            ORDER BY 
              Case_Number
        ) row_num
     FROM 
        Crime
)
select * from  Crimecte WHERE row_num > 1;

-- List of crime date and their code
select distinct date as Crime_date, temp_high, Precip, count(primary_description) as Number_Of_Crime from Crime
group by date, Temp_high, Precip
order by Number_Of_Crime DESC



/* converting datetime to date*/
update crime
set Date =CONVERT(Date, Date);

-- numbers of crime in ward 
select distinct ward, count(ward) as NumberOfCrimesInward from crime where Ward=Ward
group by Ward
order by  NumberOfCrimesInward desc;

select date,count (primary_type) as Crime_count, temp_high, precip from crime 
group by date, temp_high, precip, primary_type
order by Crime_count DESC

select distinct count (primary_type) as Crime_count,  temp_high, precip from crime 
group by  primary_type, temp_high, precip
order by Crime_count DESC

-- decoding FBI codes assigned to offences
select distinct fbi_code, primary_type from crime 
group by fbi_code, primary_type

SELECT '['+SCHEMA_NAME(schema_id)+'].['+name+']'
AS SchemaTable
FROM sys.tables
