CREATE DATABASE retail_analysis;
USE retail_analysis;

CREATE TABLE orders_raw (
    rowid        INT PRIMARY KEY,
    orderid      VARCHAR(20),
    orderdate    DATE,
    shipdate     DATE,
    shipmode     VARCHAR(20),
    cid          VARCHAR(15),
    cname        VARCHAR(100),
    segment      VARCHAR(20),
    country      VARCHAR(50),
    city         VARCHAR(100),
    state        VARCHAR(50),
    postal       INT,
    region       VARCHAR(20),
    pid          VARCHAR(20),
    category     VARCHAR(30),
    subcategory  VARCHAR(30),
    pname        VARCHAR(255),
    sales        DECIMAL(10,4),
    quantity     INT,
    discount     DECIMAL(4,2),
    profit       DECIMAL(10,4)
);
USE retail_analysis;
SELECT COUNT(*) FROM orders;
describe orders;

alter table orders add column order_date DATE, add column ship_date DATE;
SET sql_safe_updates = 0;
update orders
SET order_date = str_to_date(orderdate,'%m/%d/%Y'),ship_date = str_to_date(shipdate,'%m/%d/%Y');

SELECT orderdate, order_date, shipdate, ship_date FROM orders LIMIT 5;
SELECT
  SUM(order_date IS NULL) AS null_order_date,
  SUM(ship_date IS NULL) AS null_ship_date,
  SUM(sales IS NULL) AS null_sales,
  SUM(profit IS NULL) AS null_profit
FROM orders;

SELECT orderid, pid, COUNT(*) AS cnt
FROM orders
GROUP BY orderid, pid
HAVING COUNT(*) > 1;

SELECT *
FROM orders
WHERE (orderid, pid) IN (
  SELECT orderid, pid
  FROM orders
  GROUP BY orderid, pid
  HAVING COUNT(*) > 1
)
ORDER BY orderid, pid;

SELECT *
FROM (
  SELECT *, COUNT(*) OVER (PARTITION BY orderid, pid) AS cnt
  FROM orders
) t
WHERE cnt > 1
ORDER BY orderid, pid;

CREATE TABLE orders_backup AS SELECT * FROM orders;
DELETE FROM orders WHERE rowid = 3407;

SET SQL_SAFE_UPDATES = 0;
DELETE FROM orders WHERE rowid = 3407;
SELECT COUNT(*) FROM orders;
SELECT
  SUM(order_date IS NULL) AS null_order_date,
  SUM(ship_date IS NULL) AS null_ship_date,
  SUM(sales IS NULL) AS null_sales,
  SUM(profit IS NULL) AS null_profit
FROM orders;

SELECT
  COUNT(DISTINCT orderid) AS total_orders,
  COUNT(DISTINCT cid) AS total_customers,
  ROUND(SUM(sales), 2) AS total_sales,
  ROUND(SUM(profit), 2) AS total_profit
FROM orders;

SELECT
  category,
  ROUND(SUM(sales), 2) AS total_sales,
  ROUND(SUM(profit), 2) AS total_profit,
  ROUND(SUM(profit) / SUM(sales) * 100, 2) AS margin_pct
FROM orders
GROUP BY category
ORDER BY total_profit DESC;

SELECT
  subcategory,
  ROUND(SUM(sales), 2) AS total_sales,
  ROUND(SUM(profit), 2) AS total_profit,
  ROUND(SUM(profit) / SUM(sales) * 100, 2) AS margin_pct
FROM orders
WHERE category = 'Furniture'
GROUP BY subcategory
ORDER BY total_profit;

SELECT
  subcategory,
  ROUND(AVG(discount) * 100, 1) AS avg_discount_pct,
  ROUND(SUM(profit), 2) AS total_profit
FROM orders
WHERE category = 'Furniture'
GROUP BY subcategory
ORDER BY avg_discount_pct DESC;

SELECT
  CASE
    WHEN discount = 0 THEN '0%'
    WHEN discount <= 0.2 THEN '1-20%'
    WHEN discount <= 0.4 THEN '21-40%'
    ELSE '40%+'
  END AS discount_band,
  COUNT(*) AS order_lines,
  ROUND(SUM(sales), 2) AS total_sales,
  ROUND(SUM(profit), 2) AS total_profit
FROM orders
GROUP BY discount_band
ORDER BY MIN(discount);

SELECT
  YEAR(order_date) AS yr,
  MONTH(order_date) AS mth,
  ROUND(SUM(sales), 2) AS total_sales,
  ROUND(SUM(profit), 2) AS total_profit
FROM orders
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY yr, mth;