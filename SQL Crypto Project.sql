create database Crypto;
use Crypto;

CREATE TABLE coins (
    coin_id INT PRIMARY KEY,
    coin_name VARCHAR(50),
    symbol VARCHAR(10),
    launch_year INT
);

CREATE TABLE exchanges (
    exchange_id INT PRIMARY KEY,
    exchange_name VARCHAR(50),
    country VARCHAR(50)
);

CREATE TABLE trading_pairs (
    pair_id INT PRIMARY KEY,
    coin_id INT,
    exchange_id INT,
    pair_symbol VARCHAR(20),
    FOREIGN KEY (coin_id) REFERENCES coins(coin_id),
    FOREIGN KEY (exchange_id) REFERENCES exchanges(exchange_id)
);

CREATE TABLE investors (
    investor_id INT PRIMARY KEY,
    investor_name VARCHAR(50),
    country VARCHAR(50),
    invested_date DATE,
    invested_amount DECIMAL(18,2),
    coin_id INT,
    FOREIGN KEY (coin_id) REFERENCES coins(coin_id)
);

CREATE TABLE historical_data (
    record_id INT PRIMARY KEY,
    date DATE,
    coin_id INT,
    exchange_id INT,
    open_price DECIMAL(18,2),
    close_price DECIMAL(18,2),
    volume BIGINT,
    market_cap BIGINT,
    coin_rank INT,
    FOREIGN KEY (coin_id) REFERENCES coins(coin_id),
    FOREIGN KEY (exchange_id) REFERENCES exchanges(exchange_id)
);


-- Coins
SELECT * FROM coins LIMIT 10;

-- Exchanges
SELECT * FROM exchanges LIMIT 10;

-- Trading Pairs
SELECT * FROM trading_pairs LIMIT 10;

-- Investors
SELECT * FROM investors LIMIT 10;

-- Historical Data
SELECT * FROM historical_data LIMIT 10;


-- Q.1 Total Amount invested by investers 

SELECT SUM(invested_amount) AS total_investment
FROM investors;

-- Q.2 Total Count of investers. 

select count(investor_id) 
from investors;

-- Q.3 Minimum opening price of of crypto _market.

SELECT historical_data.open_price,coins.coin_name
 FROM historical_data JOIN coins 
 ON historical_data.coin_id = coins.coin_id
 order by historical_data.open_price limit 1;

-- Q.4 Maximum opening price of crypto market.

SELECT historical_data.open_price,coins.coin_name
 FROM historical_data JOIN coins 
 ON historical_data.coin_id = coins.coin_id
 order by historical_data.open_price desc limit 1 ;
 
use Crypto;

-- Q.5 What is average volume per exchange.

select e.exchange_name,avg(h.volume) as avg_volume from exchanges e join historical_data h 
on e.exchange_id=h.exchange_id 
group by e.exchange_name
order by avg_volume desc;

-- Q.6 Find all investores from India & thier total investment 

select count(investor_id) as Total_Indian_Investors,sum(invested_amount) as Total_Investment from investors where country="India";

-- Q.7 What is average opening & closing price as per crypto coin type.

select c.coin_name,avg(h.open_price) as avg_opening_price,avg(h.close_price) as avg_closing_price
from coins c join historical_data h 
on c.coin_id=h.coin_id
group by coin_name;

-- Q.8 What is the Country wise total investment.

select
    country,
    COUNT(investor_id) as Total_Investors,
    SUM(invested_amount) as Total_Amount_Invested,
    rank() over (order by sum(invested_amount) desc) as Investment_Rank
from investors
group by  country
order by  Total_Amount_Invested desc;


