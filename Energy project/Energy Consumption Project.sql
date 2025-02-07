USE energy_project;
-- Total consumption by building
create table Building_Consumption AS
SELECT SUM(e.`Water Consumption`) + SUM(e.`Electricity Consumption`) + SUM(e.`Gas Consumption`) AS TotalConsumption ,e.Building,b.City,b.Country,b.state
FROM `energy consumptions` e
join `buiding master` b on e.Building = b.Building
group by e.Building,b.City,b.Country,b.state;
-- Total consumption for each city
create table Total_consumption_for_cities AS
SELECT b.city,SUM(e.`Water Consumption`) + SUM(e.`Electricity Consumption`) + SUM(e.`Gas Consumption`) AS TotalConsumption 
FROM `buiding master` b
JOIN `energy consumptions` e on b.Building =e.Building
GROUP BY b.city 
ORDER BY TotalConsumption DESC ;
-- Water Consumption, Electricity Consumption, Gas Consumptioncity for USA
create table total_for_USA AS
SELECT b.Country ,SUM(e.`Water Consumption`) AS Total_Water_Consumption, SUM(e.`Electricity Consumption`) AS Total_Electricity_Consumption , 
SUM(e.`Gas Consumption`) AS Total_Gas_Consumption
FROM `buiding master` b
JOIN `energy consumptions` e on b.Building =e.Building
GROUP BY  b.Country;
-- Total consumption for USA country
create table Sum_USA_Consumption as
SELECT b.Country ,b.city,b.state,SUM(e.`Water Consumption`) + SUM(e.`Electricity Consumption`) + SUM(e.`Gas Consumption`) AS Total_Consumption 
FROM `buiding master` b
JOIN `energy consumptions` e on b.Building =e.Building
GROUP BY b.Country ,b.city,b.state;
-- calculate price for each energy type
create table total_price_for_energy_type AS
SELECT `Energy Type`,ROUND(SUM(`Price Per Unit`), 2)as total_price_per_unit
FROM `rates (1)`
group by `Energy Type`;
--  consumption(water, electricity, gas) per month 
create table consumption_over_time AS
SELECT Month,year,SUM(`Water Consumption`) AS Total_Water_Consumption,SUM(`Electricity Consumption`) AS Total_Electricity_Consumption,SUM(`Gas Consumption`) AS Total_Gas_Consumption
FROM `energy consumptions`
WHERE Date IS NOT NULL
GROUP BY Month,year
ORDER BY Month;
-- total energy consumption  for each month
create table energy_consumption_per_month AS
SELECT Month,year,SUM(`Water Consumption`) +SUM(`Electricity Consumption`) +SUM(`Gas Consumption`)AS TotalConsumption
FROM `energy consumptions`
WHERE Date IS NOT NULL
GROUP BY Month,year
ORDER BY  TotalConsumption DESC;
-- add state to city
CREATE TABLE city_states (
    city VARCHAR(50),
    state VARCHAR(50)
);

INSERT INTO city_states (city, state) VALUES
    ('New York', 'New York'),
    ('Chicago', 'Illinois'),
    ('Houston', 'Texas'),
    ('Phoenix', 'Arizona'),
    ('Los Angeles', 'California');

ALTER TABLE `buiding master`
ADD COLUMN state VARCHAR(50);
 
UPDATE`buiding master` b
JOIN city_states c ON b.city = c.city
SET b.state = c.state;
-- precentage for consumption
CREATE TABLE consumptions AS
SELECT 
(SUM(e.`Water Consumption`) / (SUM(e.`Water Consumption`) + SUM(e.`Electricity Consumption`) + SUM(e.`Gas Consumption`))) * 100 AS water_percentage,
(SUM(e.`Electricity Consumption`) / (SUM(e.`Water Consumption`) + SUM(e.`Electricity Consumption`) + SUM(e.`Gas Consumption`))) * 100 AS electricity_percentage,
(SUM(e.`Gas Consumption`) / (SUM(e.`Water Consumption`) + SUM(e.`Electricity Consumption`) + SUM(e.`Gas Consumption`))) * 100 AS gas_percentage
FROM `energy consumptions` e;
create table total_electricity as 
SELECT b.Building,(r.`total_price_per_unit` * e.`Electricity Consumption`) as Electricity,b.city,b.state,e.year,e.Month
FROM `energy consumptions` e
JOIN `buiding master` b ON e.building = b.Building
JOIN (SELECT * FROM `total_price_for_energy_type` WHERE `Energy Type` = 'Electricity') AS r
;
--
create table total_gas as 
SELECT b.Building,(r.`total_price_per_unit` * e.`Gas Consumption`) as Gas ,b.city,e.year,e.Month,b.state
FROM `energy consumptions` e
JOIN `buiding master` b ON e.building = b.Building
JOIN (SELECT * FROM `total_price_for_energy_type` WHERE `Energy Type` = 'Gas') as r
;
--
create table total_water as 
SELECT b.Building,(r.`total_price_per_unit` * e.`Water Consumption`) as Water ,b.city,e.year,e.Month,b.state
FROM `energy consumptions` e
JOIN `buiding master` b ON e.building = b.Building
JOIN (SELECT * FROM `total_price_for_energy_type` WHERE `Energy Type` = 'Water') as r
;
--  total of Water Consumption, Electricity Consumption, Gas Consumption 
create table total_consumption as 
SELECT b.Building,(r.`total_price_per_unit` * e.`Water Consumption`) as Water,(r.`total_price_per_unit` * e.`Gas Consumption`) as Gas 
,(r.`total_price_per_unit` * e.`Electricity Consumption`) as Electricity,b.city ,e.year,e.Month,b.state
FROM `energy consumptions` e
JOIN `buiding master` b ON e.building = b.Building
JOIN (SELECT * FROM `total_price_for_energy_type`) as r;
show tables;



