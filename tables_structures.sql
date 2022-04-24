-----------------------------------
-- Creating rpm_future_retail
-----------------------------------
create table rpm_future_retail (
    FUTURE_RETAIL_ID         Numeric(20) primary key,
    item                     Varchar(20),
    location                 Numeric(5),
    action_date              date,
    SELLING_RETAIL           Numeric(10,4),
    SELLING_RETAIL_CURRENCY  Varchar(3),
    SELLING_UOM              Varchar(2));

-- Use the provided rpm_future_retail.sql file to insert data
-- OR: select * from rpm_future_retail for update;  -- and then insert data manually from Excel file

-----------------------------------
-- Creating rpm_zone_future_retail
-----------------------------------
create table rpm_zone_future_retail (
    ZONE_FUTURE_RETAIL_ID   Numeric(20) primary key,
    item                    Varchar(20),
    ZONE                    Numeric(2),
    action_date             date,
    SELLING_RETAIL          Numeric(10,4),
    SELLING_RETAIL_CURRENCY Varchar(3),
    SELLING_UOM             Varchar(2));


-- Use the provided rpm_zone_future_retail.sql file to insert data
-- OR: select * from rpm_zone_future_retail for update;  -- and then insert data manually from Excel file

-----------------------------------
-- Creating rpm_zone_location:
-----------------------------------
create table rpm_zone_location (zone_id  Numeric(2),
                                location Numeric(4));

-- Use the provided rpm_zone_location.sql file to insert data
-- OR: select * from rpm_zone_location for update;  -- and then insert data manually from Excel file
