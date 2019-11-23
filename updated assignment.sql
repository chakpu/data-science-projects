create table bajaj1 as 
select str_to_date(`Date`, '%d-%M-%Y') as `Date`,`Close Price`, 
avg(`Close Price`) over (ORDER BY STR_TO_DATE(`Date`, '%d-%M-%Y')ROWS 19 PRECEDING) as `20 Day MA`,
avg(`Close Price`) over (ORDER BY STR_TO_DATE(`Date`, '%d-%M-%Y')ROWS 49 PRECEDING) as `50 Day MA` 
from `bajaj auto`;

create table eichermotors1 as 
select str_to_date(`Date`, '%d-%M-%Y') as `Date`,`Close Price`, 
avg(`Close Price`) over (ORDER BY STR_TO_DATE(`Date`, '%d-%M-%Y')ROWS 19 PRECEDING) as `20 Day MA`,
avg(`Close Price`) over (ORDER BY STR_TO_DATE(`Date`, '%d-%M-%Y')ASC ROWS 49 PRECEDING) as `50 Day MA`
from `eicher motors`;

create table tcs1 as 
select str_to_date(`Date`, '%d-%M-%Y') as `Date`,`Close Price`, 
avg(`Close Price`) over (ORDER BY STR_TO_DATE(`Date`, '%d-%M-%Y')ROWS 19 PRECEDING) as `20 Day MA`,
avg(`Close Price`) over (ORDER BY STR_TO_DATE(`Date`, '%d-%M-%Y')ROWS 49 PRECEDING) as `50 Day MA` 
from `tcs`

create table infosys1 as select `Date`,`Close Price`, AVG(`Close Price`) OVER (ORDER BY `Date` ASC ROWS 19 PRECEDING) as `20 Day MA`,
AVG(`Close Price`) OVER (ORDER BY `Date` ASC ROWS 49 PRECEDING) as `50 Day MA` from `infosys`

create table tvsmotors1 as 
select str_to_date(`Date`, '%d-%M-%Y') as `Date`,`Close Price`, 
avg(`Close Price`) over (ORDER BY STR_TO_DATE(`Date`, '%d-%M-%Y')ROWS 19 PRECEDING) as `20 Day MA`,
avg(`Close Price`) over (ORDER BY STR_TO_DATE(`Date`, '%d-%M-%Y')ROWS 49 PRECEDING) as `50 Day MA`  from `tvs motors`


create table heromotocorp1 as
select str_to_date(`Date`, '%d-%M-%Y') as `Date`,`Close Price`, 
avg(`Close Price`) over (ORDER BY STR_TO_DATE(`Date`, '%d-%M-%Y')ROWS 19 PRECEDING) as `20 Day MA`,
avg(`Close Price`) over (ORDER BY STR_TO_DATE(`Date`, '%d-%M-%Y')ROWS 49 PRECEDING) as `50 Day MA` from `hero motocorp`

/*2. Create a master table containing the date and close price of all the six stocks. (Column header for the price is the name of the stock)*/


Create table`mastertable` as
select b.`Date`,b.`close Price` as Bajaj,t.`close Price` as TCS,tv.`close Price` as TVS,i.`close Price` as Infosys,e.`close Price` as Eicher,h.`close Price` as Hero
from bajaj1 b
left join tcs1 t on b.Date=t.Date
left join infosys1 i on b.Date=i.Date
left join tvsmotors1 tv on b.Date=tv.Date
left join eichermotors1 e on b.Date=e.Date
left join heromotocorp1 h on b.Date=h.Date

/*3. Use the table created in Part(1) to generate buy and sell signal. Store this in another table named 'bajaj2'*/

CREATE table bajaj2 as
SELECT `Date`,
       `Close Price`,
       CASE
		  WHEN `20 Day MA` > `50 Day MA` AND (LAG(`20 Day MA`,1) over (order by Date))<(LAG(`50 Day MA`,1) over (order by Date)) THEN 'BUY'
          WHEN `20 Day MA` < `50 Day MA` AND (LAG(`20 Day MA`,1) over (order by Date))>(LAG(`50 Day MA`,1) over (order by Date))THEN 'SELL'
          ELSE 'HOLD' 
		END as `Signal`
FROM  bajaj1 
Order by `Date`

select * from bajaj2 where `Signal` in ('Buy')


CREATE table eichermotors2 as
SELECT `Date`,
       `Close Price`,
        CASE
		  WHEN `20 Day MA` > `50 Day MA` AND (LAG(`20 Day MA`,1) over (order by Date))<(LAG(`50 Day MA`,1) over (order by Date)) THEN 'BUY'
          WHEN `20 Day MA` < `50 Day MA` AND (LAG(`20 Day MA`,1) over (order by Date))>(LAG(`50 Day MA`,1) over (order by Date))THEN 'SELL'
          ELSE 'HOLD' 
		END as `Signal`
FROM  eichermotors1

CREATE table heromotocorp2 as
SELECT `Date`,
       `Close Price`,
        CASE
		  WHEN `20 Day MA` > `50 Day MA` AND (LAG(`20 Day MA`,1) over (order by Date))<(LAG(`50 Day MA`,1) over (order by Date)) THEN 'BUY'
          WHEN `20 Day MA` < `50 Day MA` AND (LAG(`20 Day MA`,1) over (order by Date))>(LAG(`50 Day MA`,1) over (order by Date))THEN 'SELL'
          ELSE 'HOLD' 
		END as `Signal`
FROM heromotocorp1 

CREATE table infosys2 as
SELECT `Date`,
       `Close Price`,
        CASE
		  WHEN `20 Day MA` > `50 Day MA` AND (LAG(`20 Day MA`,1) over (order by Date))<(LAG(`50 Day MA`,1) over (order by Date)) THEN 'BUY'
          WHEN `20 Day MA` < `50 Day MA` AND (LAG(`20 Day MA`,1) over (order by Date))>(LAG(`50 Day MA`,1) over (order by Date))THEN 'SELL'
          ELSE 'HOLD' 
		END as `Signal`
FROM infosys1 

CREATE table tcs2 as
SELECT `Date`,
       `Close Price`,
        CASE
		  WHEN `20 Day MA` > `50 Day MA` AND (LAG(`20 Day MA`,1) over (order by Date))<(LAG(`50 Day MA`,1) over (order by Date)) THEN 'BUY'
          WHEN `20 Day MA` < `50 Day MA` AND (LAG(`20 Day MA`,1) over (order by Date))>(LAG(`50 Day MA`,1) over (order by Date))THEN 'SELL'
          ELSE 'HOLD' 
		END as `Signal`
FROM tcs1 

CREATE table tvsmotors2 as
SELECT `Date`,
       `Close Price`,
        CASE
		  WHEN `20 Day MA` > `50 Day MA` AND (LAG(`20 Day MA`,1) over (order by Date))<(LAG(`50 Day MA`,1) over (order by Date)) THEN 'BUY'
          WHEN `20 Day MA` < `50 Day MA` AND (LAG(`20 Day MA`,1) over (order by Date))>(LAG(`50 Day MA`,1) over (order by Date))THEN 'SELL'
          ELSE 'HOLD' 
		END as `Signal`
FROM  tvsmotors1


/*4. Create a User defined function, that takes the date as input and returns the signal for 
that particular day (Buy/Sell/Hold) for the Bajaj stock.*/

delimiter $$

create function `required_output`( `d` date)

 returns varchar(45)

 deterministic

 begin

declare `output` varchar(45);

select `signal` into output from bajaj2 where `date`=d;

return `output`;

end

$$

delimiter ;

select `required_output`('2015-04-01');












