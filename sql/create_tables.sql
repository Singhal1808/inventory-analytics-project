-- =========================================================
-- Demand Forecasting and Sales Analytics Project
-- Purpose:
-- 1) Create database and table for retail sales data
-- 2) Perform business analysis using SQL queries
-- 3) Support Power BI dashboard reporting
-- =========================================================


-- =========================================================
-- Step 1: Create Database
-- =========================================================

CREATE DATABASE IF NOT EXISTS retail_sales_db;

USE retail_sales_db;


-- =========================================================
-- Step 2: Create Sales Table
-- This table stores daily sales transactions
-- for each store and item.
-- =========================================================

CREATE TABLE IF NOT EXISTS sales_data (

    -- Transaction date
    date DATE NOT NULL,

    -- Store identifier
    store_id VARCHAR(20) NOT NULL,

    -- Item identifier
    item_id VARCHAR(20) NOT NULL,

    -- Number of units sold
    sales INT NOT NULL,

    -- Selling price per unit
    price DECIMAL(10,2) NOT NULL,

    -- Promotion flag (1 = promotion active)
    promo INT NOT NULL,

    -- Day of week (0–6)
    weekday INT NOT NULL,

    -- Month number (1–12)
    month INT NOT NULL,

    -- Forecasted demand (calculated KPI)
    Demand_Forecast FLOAT,

    -- Estimated inventory level
    Inventory_Level FLOAT,

    -- Stockout indicator (1 = risk)
    Stockout_Risk INT,

    -- Composite primary key
    PRIMARY KEY (date, store_id, item_id)

);


-- Optional index for faster analytics
CREATE INDEX idx_store ON sales_data(store_id);
CREATE INDEX idx_item ON sales_data(item_id);



-- =========================================================
-- SQL Analysis Queries for Dashboard
-- =========================================================


-- =========================================================
-- Query 1: Total Revenue
-- Business Question:
-- What is the total revenue generated?
-- Used in:
-- Power BI Card (Total Revenue)
-- =========================================================

SELECT
    SUM(sales * price) AS total_revenue
FROM sales_data;



-- =========================================================
-- Query 2: Revenue by Store
-- Business Question:
-- Which store generates the most revenue?
-- Used in:
-- Power BI Bar Chart (Revenue by Store)
-- =========================================================

SELECT
    store_id,
    SUM(sales * price) AS revenue
FROM sales_data
GROUP BY store_id
ORDER BY revenue DESC;



-- =========================================================
-- Query 3: Sales Trend Over Time
-- Business Question:
-- How do sales change over time?
-- Used in:
-- Power BI Line Chart (Sales Trend)
-- =========================================================

SELECT
    date,
    SUM(sales) AS total_sales
FROM sales_data
GROUP BY date
ORDER BY date;



-- =========================================================
-- Query 4: Promotion Impact on Sales
-- Business Question:
-- Does promotion increase sales?
-- Used in:
-- Power BI Column Chart (Promo vs Sales)
-- =========================================================

SELECT
    promo,
    AVG(sales) AS average_sales
FROM sales_data
GROUP BY promo;



-- =========================================================
-- Query 5: Top 10 Selling Items
-- Business Question:
-- Which products sell the most?
-- Used in:
-- Power BI Bar Chart (Top Selling Items)
-- =========================================================

SELECT
    item_id,
    SUM(sales) AS total_sales
FROM sales_data
GROUP BY item_id
ORDER BY total_sales DESC
LIMIT 10;



-- =========================================================
-- Query 6: Stockout Risk Count
-- Business Question:
-- How many records indicate potential stockout?
-- Used in:
-- Power BI KPI Card (Stockout Risk)
-- =========================================================

SELECT
    COUNT(*) AS stockout_cases
FROM sales_data
WHERE Stockout_Risk = 1;