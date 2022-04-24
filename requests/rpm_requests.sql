-- LEVEL 1
-- 1.
select * from rpm_future_retail rfr
where (select count(*) from rpm_future_retail rfr2
       where rfr.item = rfr2.item AND rfr.location = rfr2.location AND rfr.action_date = rfr2.action_date) > 1;
-- or
select * from rpm_future_retail where (item, location, action_date) in (select item, location, action_date from rpm_future_retail
        group by item, location, action_date having count(*) > 1);

-- 2а.
select rfr.item, rfr.location from rpm_future_retail rfr
where rfr.location not in
      (select location from rpm_zone_location where zone_id in
      (select zone from rpm_zone_future_retail where item = rfr.item));

-- 2б.
select location, item, count(*) from rpm_future_retail where (item, location) in
(select rfr.item, rfr.location from rpm_future_retail rfr
where rfr.location not in
    (select location from rpm_zone_location where zone_id in
    (select zone from rpm_zone_future_retail where item = rfr.item)))
group by item, location;

-- 3.
select rfr.item, rfr.location from rpm_future_retail rfr
where rfr.location in
      (select location from rpm_zone_location where zone_id in
      (select zone from rpm_zone_future_retail where item = rfr.item and selling_retail != rfr.selling_retail))
and rfr.action_date = to_date('07-12-2017', 'dd-mm-yyyy');

-- LEVEL 2
-- 1.
select item, selling_retail, action_date from rpm_zone_future_retail
where zone = 1 and action_date >= '2017-12-01' and action_date <= '2018-01-05' order by action_date;

--2.
with data as (
    select distinct on (item, selling_retail)
    item, selling_retail, action_date from rpm_zone_future_retail
    where zone = 1 order by item)
select item, selling_retail, action_date, (lead(action_date, 1, action_date) over(partition by item) - action_date) as days from data;

--3.
with data as (
    select selling_retail from rpm_future_retail rfr
    where rfr.location in
          (select location from rpm_zone_location where zone_id in
          (select zone from rpm_zone_future_retail where item = rfr.item))
)
update rpm_future_retail set selling_retail=data.selling_retail from data where action_date='2017-12-07';

--LEVEL 3
-- 1.
delete from rpm_future_retail rfr
where (select count(*) from rpm_future_retail rfr2
       where rfr.item = rfr2.item AND rfr.location = rfr2.location AND rfr.action_date = rfr2.action_date) > 1;
-- or
delete from rpm_future_retail where (item, location, action_date) in (select item, location, action_date from rpm_future_retail
        group by item, location, action_date having count(*) > 1);

-- 2.
create table rpm_item_zone_price (
    ITEM_ZONE_PRICE_ID      SERIAL primary key,
    ZONE                    Numeric(2),
    item                    Varchar(20),
    action_date             date,
    SELLING_RETAIL          Numeric(10,4)
);
with data as (
    select
        zone,
        item,
        generate_series(
                date_trunc('month', '2017-05-01'::timestamp),
                '2018-03-01'::timestamp, '1 month'
            )::date as month,
        selling_retail
    from rpm_zone_future_retail rzfr
    where rzfr.zone=1
    order by item, selling_retail
)
insert into rpm_item_zone_price (zone, item, action_date,selling_retail) select zone, item, month, selling_retail from data;