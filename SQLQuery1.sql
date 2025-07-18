-------------Data Cleaning --------------
UPDATE Blinkit_data
SET Item_Fat_Content =
CASE
WHEN Item_Fat_Content IN ('low fat' , 'LF') THEN 'Low Fat'
WHEN Item_Fat_Content = 'reg' THEN 'Regular'
ELSE Item_Fat_Content
END
-------------- To check the data is modified or not--------------------
SELECT DISTINCT Item_Fat_Content FROM BlinkIt_data
-------------------- Changing Sales Column name to Total_Sales-------------------
EXEC sp_rename 'Blinkit_data.Sales', 'Total_Sales', 'COLUMN';
SELECT * FROM Blinkit_data;

-------------------Total Sales---------------------

SELECT CONCAT(CAST(SUM(Total_Sales)/1000000 AS DECIMAL (10,2)), 'M')  AS Total_Sales_Millions 
FROM BlinkIt_data
WHERE Item_Fat_Content = 'Low Fat'

----------------Avarage Sales----------------------

SELECT CAST(AVG(Total_Sales) AS DECIMAL (10,2))  AS AVRAGESALES
FROM BlinkIt_data

---------------Total Sales----------------------

SELECT COUNT(*) AS Total_no_items FROM BlinkIt_data

--------------- AVG RATING--------------

SELECT CAST(AVG(Rating) AS DECIMAL(10,2)) AS AVG_RATING 
FROM BlinkIt_data

-------------Total Sales By Fat Content-----------------

SELECT Item_Fat_Content,
                     CAST(SUM(Total_Sales) AS DECIMAL(10,1)) AS Total_Sales,
                     CAST(AVG(Total_Sales) AS DECIMAL (10,2))  AS AVRAGE_SALES,
                     CAST (AVG(Rating) AS DECIMAL(10,2)) AS AVG_RATING,
                     COUNT(*) AS Total_no_items
                     FROM BlinkIt_data
                     GROUP BY Item_Fat_Content
                     ORDER BY Total_Sales DESC

----------------- Total Sales by Item Type ----------

SELECT Item_Type,
                     CAST(SUM(Total_Sales) AS DECIMAL(10,1)) AS Total_Sales,
                     CAST(AVG(Total_Sales) AS DECIMAL (10,2))  AS AVRAGE_SALES,
                     CAST (AVG(Rating) AS DECIMAL(10,2)) AS AVG_RATING,
                     COUNT(*) AS Total_no_items
                     FROM BlinkIt_data
                     GROUP BY Item_Type
                     ORDER BY Total_Sales DESC

----------------// Fat content by outlet for total sales ----------

SELECT Outlet_Location_Type,
       CAST(ISNULL([Low Fat], 0) AS VARCHAR) AS Low_Fat,
       CAST(ISNULL([Regular], 0) AS VARCHAR) AS Regular
FROM
(
SELECT Item_Fat_Content , Outlet_Location_Type,
                     CAST(SUM(Total_Sales) AS DECIMAL(10,1)) AS Total_Sales
                     FROM Blinkit_data
                     GROUP BY Item_Fat_Content , Outlet_Location_Type
                     )AS SOURCE_TABLE
PIVOT
(
 SUM(Total_Sales)
FOR Item_Fat_Content IN ([Low Fat],[Regular])
)AS PivotTable
ORDER BY Outlet_Location_Type 

----------- //Total Sales by Outlet Establishment ---------

SELECT Outlet_Establishment_Year,
 CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales
 FROM BlinkIt_data
 GROUP BY Outlet_Establishment_Year
 ORDER BY Outlet_Establishment_Year 

 ---------------- Percentage of Sales by outlet size-----------------
 SELECT Outlet_Size,
 CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
 CAST(SUM(Total_Sales)*100.0/(SUM(SUM(Total_Sales)) OVER()) AS DECIMAL(10,1)) AS Sales_Percentage
 FROM BlinkIt_data
 GROUP BY Outlet_Size
 ORDER BY Total_Sales DESC

 ---------------- Sales by Outlet Location -------------------
 
 SELECT Outlet_Location_Type,
                     CAST(SUM(Total_Sales) AS DECIMAL(10,1)) AS Total_Sales,
                     CAST(AVG(Total_Sales) AS DECIMAL (10,2))  AS AVRAGE_SALES,
                     CAST (AVG(Rating) AS DECIMAL(10,2)) AS AVG_RATING,
                     COUNT(*) AS Total_no_items
                     FROM BlinkIt_data
                     GROUP BY Outlet_Location_Type
                     ORDER BY Total_Sales DESC

----------------------outlet type------------

SELECT Outlet_Type,
                     CAST(SUM(Total_Sales) AS DECIMAL(10,1)) AS Total_Sales,
                     CAST(AVG(Total_Sales) AS DECIMAL (10,2))  AS AVRAGE_SALES,
                     CAST (AVG(Rating) AS DECIMAL(10,2)) AS AVG_RATING,
                     COUNT(*) AS Total_no_items
                     FROM BlinkIt_data
                     GROUP BY Outlet_Type
                     ORDER BY Total_Sales DESC
