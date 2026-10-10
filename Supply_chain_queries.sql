Create database supply_chain_db;
use supply_chain_db;
select * from supply_chain;

-- 1. Check Total Imported Records
SELECT COUNT(*) AS Total_Orders FROM supply_chain;

-- 2. Region-wise Late Delivery Percentage
SELECT 
    Region,
    COUNT(Order_ID) AS Total_Orders,
    SUM(CASE WHEN Delivery_Status = 'Late Delivery' THEN 1 ELSE 0 END) AS Late_Orders,
    ROUND(SUM(CASE WHEN Delivery_Status = 'Late Delivery' THEN 1 ELSE 0 END) * 100.0 / COUNT(Order_ID), 2) AS Late_Delivery_Pct
FROM supply_chain
GROUP BY Region
ORDER BY Late_Delivery_Pct DESC;

-- 3. Top 5 Products at Out-of-Stock Risk (Urgent Reorder List)
SELECT 
    Product_Name, 
    Category, 
    ROUND(AVG(Current_Stock), 0) AS Avg_Stock_Left, 
    ROUND(AVG(Reorder_Level), 0) AS Reorder_Threshold,
    SUM(Sales_Amount) AS Total_Revenue_At_Risk
FROM supply_chain
WHERE Inventory_Status = 'Out-of-Stock Risk (Reorder)'
GROUP BY Product_Name, Category
ORDER BY Total_Revenue_At_Risk DESC
LIMIT 5;

-- 4. Dead Stock / Overstocked Products (Blocked Inventory Value)
SELECT 
    Category,
    Product_Name,
    COUNT(Order_ID) AS Overstock_Instances,
    SUM(Current_Stock * Unit_Price) AS Blocked_Inventory_Value
FROM supply_chain
WHERE Inventory_Status = 'Overstocked (Dead Stock)'
GROUP BY Category, Product_Name
ORDER BY Blocked_Inventory_Value DESC
LIMIT 5;

-- 5. Shipping Mode Lead Time Analysis
SELECT 
    Shipping_Mode,
    ROUND(AVG(Lead_Time_Days), 1) AS Avg_Lead_Time_Days,
    COUNT(Order_ID) AS Total_Shipments
FROM supply_chain
GROUP BY Shipping_Mode
ORDER BY Avg_Lead_Time_Days DESC;